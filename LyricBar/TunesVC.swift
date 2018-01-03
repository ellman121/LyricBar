//
//  TunesVC.swift
//  LyricBar
//
//  Created by Elliott Rarden on 02.01.18.
//  Copyright © 2018 Elliott Rarden. All rights reserved.
//

import Cocoa
import ScriptingBridge

func getITunes() -> iTunesApplication? {
    let iTunes = SBApplication(bundleIdentifier: "com.apple.iTunes")
    
    if iTunes == nil || !((iTunes?.isRunning)!) {
        return nil
    }
    
    return iTunes! as iTunesApplication
}

class TunesVC: NSViewController {
    
    // MARK: - Class Functions
    
    static func createNewTunesVC() -> TunesVC {
        let sb = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let id = NSStoryboard.SceneIdentifier("TunesVC")
        
        guard let VC = sb.instantiateController(withIdentifier: id) as? TunesVC else {
            fatalError("Error creating popover")
        }
        return VC
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var PreviousButton: NSButton!
    @IBOutlet weak var PlayPauseButton: NSButton!
    @IBOutlet weak var NextButton: NSButton!
    @IBOutlet weak var SongMetaBox: NSTextField!
    @IBOutlet weak var LyricBox: NSTextFieldCell!
    
    // MARK: - Instance Variables
    var currentTask: URLSessionTask? = nil
    
    // MARK: - Lifecycle
    
    override func viewWillAppear() {
        self.update()
        self.setPlayPauseState()
    }
    
    // MARK: - Methods
    
    func setLyricText(text: String) {
        DispatchQueue.main.async {
            self.LyricBox.stringValue = text
        }
    }
    
    func update() {
        let iTunes = getITunes()
        if iTunes == nil {
            self.LyricBox.stringValue = "iTunes Not Running"
        }
    
        let currentTrack = iTunes?.currentTrack
        if currentTrack == nil || currentTrack?.name == "" {
            self.LyricBox.stringValue = "No Song Playing"
        }
        
        if self.currentTask != nil {
            self.currentTask?.cancel()
            self.currentTask = nil
        }
        
        // Set the song metadata
        let artist = currentTrack?.artist
        let name   = currentTrack?.name!
        
        self.SongMetaBox.stringValue = "\(name!) - \(artist!)"
        self.LyricBox.stringValue    = "... Loading ..."
        
        let percentEncodedArtist = artist?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! ?? ""
        let percentEncodedName   = name?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! ?? ""
        let url = URL(string: "https://lyric-api.herokuapp.com/api/find/\(percentEncodedArtist)/\(percentEncodedName)")!
        self.currentTask = URLSession.shared.dataTask(with: url) { (raw_data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = raw_data else {
                return self.setLyricText(text: "No data received")
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: String] else {
                return self.setLyricText(text: "Error serializing json")
            }
            
            let err = json!["err"]!
            switch err {
            case "not found":
                return self.setLyricText(text: "Song Not Found")
            default:
                return self.setLyricText(text: json!["lyric"]!)
            }
        }
        self.currentTask?.resume()
    }
    
    func setPlayPauseState() {
        let iTunes = getITunes()
        if iTunes != nil {
            let state = iTunes?.playerState!
            if state! == iTunesEPlS.paused || state! == iTunesEPlS.stopped {
                self.PlayPauseButton.image = NSImage(named: NSImage.Name("play"))
            } else if state! == iTunesEPlS.playing {
                self.PlayPauseButton.image = NSImage(named: NSImage.Name("pause"))
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func PreviousSong(_ sender: Any) {
        let iTunes = getITunes()
        if iTunes != nil {
            iTunes?.previousTrack!()
        }
        self.update()
    }
    
    @IBAction func PlayPause(_ sender: Any) {
        let iTunes = getITunes()
        if iTunes != nil {
            iTunes?.playpause!()
            self.setPlayPauseState()
        }
    }
    
    @IBAction func NextSong(_ sender: Any) {
        let iTunes = getITunes()
        if iTunes != nil {
            iTunes?.nextTrack!()
        }
        self.update()
    }
}

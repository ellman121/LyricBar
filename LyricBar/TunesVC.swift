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
    @IBOutlet weak var LyricBox: NSTextField!

    // MARK: - Lifecycle
    
    override func viewWillAppear() {
        self.update()
        self.setPlayPauseState()
    }
    
    // MARK: - Methods
    
    func update() {
        let iTunes = getITunes()
        if iTunes == nil {
            LyricBox.stringValue = "iTunes Not Running"
        }
    
        let currentTrack = iTunes?.currentTrack
        if currentTrack == nil || currentTrack?.name == "" {
            LyricBox.stringValue = "No Song Playing"
        }
        
        
    }
    
    func setPlayPauseState() {
        let iTunes = getITunes()
        if iTunes != nil {
            let state = iTunes?.playerState!
            if state! == iTunesEPlS.paused || state! == iTunesEPlS.stopped {
                PlayPauseButton.image = NSImage(named: NSImage.Name("play"))
            } else if state! == iTunesEPlS.playing {
                PlayPauseButton.image = NSImage(named: NSImage.Name("pause"))
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

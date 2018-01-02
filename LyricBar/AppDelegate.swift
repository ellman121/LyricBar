//
//  AppDelegate.swift
//  LyricBar
//
//  Created by Elliott Rarden on 02.01.18.
//  Copyright © 2018 Elliott Rarden. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusBarItem: NSStatusItem? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusBarItem?.button {
            button.image = NSImage(named:NSImage.Name("L"))
            button.action = #selector(p(_:))
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func p(_ sender: Any?) {
        print("hello world")
    }
}

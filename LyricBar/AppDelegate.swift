//
//  AppDelegate.swift
//  LyricBar
//
//  Created by Elliott Rarden on 02.01.18.
//  Copyright © 2018 Elliott Rarden. All rights reserved.
//

import Carbon
import Cocoa
import ScriptingBridge
import Magnet

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let popover = NSPopover()
    var statusBarItem: NSStatusItem? = nil
    
    
    func initHotKey() {
        if let kc = KeyCombo(keyCode: 0x25, carbonModifiers: optionKey | controlKey) {
            let hk = HotKey(identifier: "ctrl_opt_l", keyCombo: kc, target: self, action: #selector(toggle(_:)))
            hk.register()
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        initHotKey()
        
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusBarItem?.button {
            button.image = NSImage(named:NSImage.Name("L"))
            button.action = #selector(toggle(_:))
            button.sendAction(on: [.leftMouseUp])
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseUp]) { (e) in
            if self.popover.isShown {
                self.popover.close()
                self.popover.contentViewController = nil
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        HotKeyCenter.shared.unregisterAll()
    }

    @objc func toggle(_ sender: NSStatusBarButton) {        
        if popover.isShown {
            popover.performClose(sender)
            popover.contentViewController = nil
        } else {
            if let button = statusBarItem?.button {
                popover.contentViewController = TunesVC.createNewTunesVC()
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}

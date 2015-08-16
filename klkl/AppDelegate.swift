//
//  AppDelegate.swift
//  glgl
//
//  Created by dch on 8/15/15.
//  Copyright (c) 2015 co.l0o0l. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let theWorkspace : NSWorkspace = NSWorkspace.sharedWorkspace()
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
                NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.FlagsChangedMask, handler: handlerEvent)
    }
    var prevTimeInterval = 0.0
    func handlerEvent(aEvent: (NSEvent!)) -> Void {
        if aEvent.modifierFlags.rawValue & NSEventModifierFlags.CommandKeyMask.rawValue > 0 {
            println("command")
            if (aEvent.timestamp - prevTimeInterval < 0.2) {
                println( "double Command was pressed" );
                if theWorkspace.launchApplication("Google Chrome"){
                    NSLog("OK")
                } else {
                    NSLog("NO")
                }
            }
            prevTimeInterval = aEvent.timestamp;
        }
    }
    
//    func applicationWillTerminate(aNotification: NSNotification) {
//        Insert code here to tear down your application
//    }
}
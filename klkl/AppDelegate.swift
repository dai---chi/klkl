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
    var lastPressedKey: UInt = 0
    
    func handlerEvent(aEvent: (NSEvent!)) -> Void {
        setShortCut(NSEventModifierFlags.CommandKeyMask.rawValue, app_name: "Google Chrome", aEvent: aEvent)
        setShortCut(NSEventModifierFlags.ShiftKeyMask.rawValue, app_name: "iTerm", aEvent: aEvent)
        setShortCut(NSEventModifierFlags.AlternateKeyMask.rawValue, app_name: "RubyMine", aEvent: aEvent)
        setShortCut(NSEventModifierFlags.FunctionKeyMask.rawValue, app_name: "Finder", aEvent: aEvent)
        setShortCut(NSEventModifierFlags.ControlKeyMask.rawValue, app_name: "Slack", aEvent: aEvent)
        lastPressedKey = aEvent.modifierFlags.rawValue
    }
    
    func setShortCut(key_uint: UInt, app_name: NSString, aEvent: NSEvent) {
        if aEvent.modifierFlags.rawValue & key_uint > 0 {
            println("key pressed")
            if (aEvent.timestamp - prevTimeInterval < 0.2 && lastPressedKey & aEvent.modifierFlags.rawValue == 0) {
                println( "double key pressed" );
                if theWorkspace.launchApplication(app_name as String){
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
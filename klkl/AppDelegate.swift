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
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)

    let theWorkspace : NSWorkspace = NSWorkspace.sharedWorkspace()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.FlagsChangedMask, handler: handlerEvent)
        if let button = statusItem.button {
            button.image = NSImage(named: "cyclone")
        }
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit klkl", action: Selector("terminate:"), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    var prevTimeInterval = 0.0
    var lastPressedKey: UInt = 0
    let modifierKeyArray: [UInt: String] = [
        NSEventModifierFlags.CommandKeyMask.rawValue: "Google Chrome",
        NSEventModifierFlags.ShiftKeyMask.rawValue: "iTerm",
        NSEventModifierFlags.AlternateKeyMask.rawValue: "Kobito",
        NSEventModifierFlags.FunctionKeyMask.rawValue: "Finder",
        NSEventModifierFlags.ControlKeyMask.rawValue: "Slack",
    ]

    var simulKeyPressedCountAtLast: Int = 0 // 最後のイベント発生時に同時に押されていた修飾キーの数
    
    func handlerEvent(aEvent: (NSEvent!)) -> Void {
        print("=======event=======")
        var simulKeyPressedCount:Int = 0 // 同時に押されている修飾キーの数
        var app_name = ""
        
        for key in modifierKeyArray.keys {
            if (aEvent.modifierFlags.rawValue & key > 0) {
                simulKeyPressedCount += 1
                app_name = modifierKeyArray[key]!
            }
        }
        
        // 「何も押されていない状態から1つ修飾キーが押された状態になった」かどうか
        let singleKeyPressed？ = simulKeyPressedCountAtLast == 0 && simulKeyPressedCount == 1

        if (singleKeyPressed？) {
            singleKeyPressed(aEvent)
            
            if( doubleKeyPressed？(aEvent) ) {
                openApp(app_name)
            }
        }

        print("同時に押されている修飾キーの数", simulKeyPressedCount)
        simulKeyPressedCountAtLast = simulKeyPressedCount
        prevTimeInterval = aEvent.timestamp;
    }
    
    func openApp(app_name: String) {
        if theWorkspace.launchApplication(app_name){
            print("opened the App")
        } else {
            print("coudn't open the App")
        }
    }
    
    func doubleKeyPressed？(aEvent: NSEvent) -> Bool {
        let theLastKeyIsTheSameKey: Bool = lastPressedKey == aEvent.modifierFlags.rawValue
        let intervalIsShort: Bool = aEvent.timestamp - prevTimeInterval < 0.2

        if (theLastKeyIsTheSameKey && intervalIsShort) {
            print( "the same key pressed twice" )
            return true
        } else {
            return false
        }
    }
    
    func singleKeyPressed(aEvent: NSEvent) {
        print("single key pressed")
        lastPressedKey = aEvent.modifierFlags.rawValue
    }

//    func applicationWillTerminate(aNotification: NSNotification) {
//        Insert code here to tear down your application
//    }
}
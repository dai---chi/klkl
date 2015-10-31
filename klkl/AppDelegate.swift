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
        
        readConfig()
    }

    var prevTimeInterval = 0.0
    var interval = Double()
    
    var lastPressedKey: UInt = 0
    var modifierKeyDict = Dictionary<UInt, String>()
    var simulKeyPressedCountAtLast: Int = 0 // 最後のイベント発生時に同時に押されていた修飾キーの数
    
    func handlerEvent(aEvent: (NSEvent!)) -> Void {
        print("=======event=======")
        var simulKeyPressedCount:Int = 0 // 同時に押されている修飾キーの数
        var app_name = ""
        
        for key in modifierKeyDict.keys {
            if (aEvent.modifierFlags.rawValue & key > 0) {
                simulKeyPressedCount += 1
                app_name = modifierKeyDict[key]!
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
        let intervalIsShort: Bool = aEvent.timestamp - prevTimeInterval < interval

        if (theLastKeyIsTheSameKey && intervalIsShort) {
            print(interval)
            print (aEvent.timestamp - prevTimeInterval)
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
    
    func readConfig() {
        let path = NSHomeDirectory() + "/.klkl"
        var appDict = Dictionary<String, String>()
        
        do {
            let configData = NSData(contentsOfFile:path)
            let configDict = try NSJSONSerialization.JSONObjectWithData(configData!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            for key in ["cmd", "alt", "shift", "fn", "ctrl"] {
                print(key, configDict!["apps"]![key])
                appDict[key] = configDict!["apps"]![key] as? String
            }
            let intervalFromConfigFile:Double = configDict!["interval"] as! Double
            setConfig(appDict, intervalFromConfigFile: intervalFromConfigFile)
        } catch {
            print("error")
        }
    }
    
    func setConfig(appDict:Dictionary<String, String>, intervalFromConfigFile:Double) -> Void {
        interval = intervalFromConfigFile
        
        modifierKeyDict = [
            NSEventModifierFlags.CommandKeyMask.rawValue: appDict["cmd"]!,
            NSEventModifierFlags.ShiftKeyMask.rawValue: appDict["shift"]!,
            NSEventModifierFlags.AlternateKeyMask.rawValue: appDict["alt"]!,
            NSEventModifierFlags.FunctionKeyMask.rawValue: appDict["fn"]!,
            NSEventModifierFlags.ControlKeyMask.rawValue: appDict["ctrl"]!,
        ]
    }

//    func applicationWillTerminate(aNotification: NSNotification) {
//        Insert code here to tear down your application
//    }
}
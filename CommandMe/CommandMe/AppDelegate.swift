//
//  AppDelegate.swift
//  CommandMe
//
//  Created by Lucas Derraugh on 7/29/21.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    static let port = (Bundle.main.bundleIdentifier ?? "") as CFString
    var window: NSWindow!

    let appState = AppState()
    
    lazy var callback: CFMessagePortCallBack = { messagePort, messageID, cfData, info in
        guard let pointer = info,
              let dataReceived = cfData as Data?,
              let string = String(data: dataReceived, encoding: .utf8) else {
            return nil
        }
        
        let appDelegate = Unmanaged<AppDelegate>.fromOpaque(pointer).takeUnretainedValue()
        appDelegate.appState.text = string.isEmpty ? "<Nothing>" : string
        
        let dataToSend = Data("😁 You made it!".utf8)
        return Unmanaged.passRetained(dataToSend as CFData)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(appState: self.appState)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
        let info = Unmanaged.passUnretained(self).toOpaque()
        var context = CFMessagePortContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)
        if let messagePort = CFMessagePortCreateLocal(nil, AppDelegate.port, callback, &context, nil),
           let source = CFMessagePortCreateRunLoopSource(nil, messagePort, 0) {
            CFRunLoopAddSource(CFRunLoopGetMain(), source, .defaultMode)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}




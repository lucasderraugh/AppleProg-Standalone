//
//  AppDelegate.swift
//  DispatchWorkItemProject
//
//  Created by Lucas Derraugh on 5/26/21.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSSearchFieldDelegate {

    @IBOutlet var window: NSWindow!

    @IBOutlet weak var button: NSButton!
    
    private var animateWorkItem: DispatchWorkItem?
    private var searchWorkItem: DispatchWorkItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.animate(self.button)
        }
        
        animateWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: workItem)
    }

    func controlTextDidChange(_ obj: Notification) {
        guard let searchField = obj.object as? NSSearchField else { return }
        let searchText = searchField.stringValue
        
        searchWorkItem?.cancel()
        
        let request = DispatchWorkItem {
            print("Latest: \(searchText)")
        }
        
        request.notify(queue: .main) {
            print("Notify Block")
        }
        
        searchWorkItem = request
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: request)
    }
    
    @IBAction func animate(_ sender: NSButton) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, NSNumber(value: 1.0 / 6.0), NSNumber(value: 3.0 / 6.0), NSNumber(value: 5.0 / 6.0), 1]
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.isAdditive = true
        
        sender.layer?.add(animation, forKey: "animate")
        
        animateWorkItem?.cancel()
        animateWorkItem = nil
    }
}


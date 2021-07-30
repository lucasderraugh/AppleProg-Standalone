//
//  AppState.swift
//  CommandMe
//
//  Created by Lucas Derraugh on 8/28/21.
//

import Foundation

class AppState: ObservableObject {
    @Published var text: String
    
    init() {
        text = "Testing"
    }
    
    func installTool() {
        text = ToolInstaller.install() ? "Success" : "Failure"
    }
}

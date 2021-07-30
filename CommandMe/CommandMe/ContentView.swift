//
//  ContentView.swift
//  CommandMe
//
//  Created by Lucas Derraugh on 7/29/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var appState: AppState
    
    var body: some View {
        VStack {
            Text(appState.text)
            Button(action: {
                appState.installTool()
            }, label: {
                Text("Install Tool")
            })
        }.frame(width: 480, height: 300)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(appState: AppState())
    }
}

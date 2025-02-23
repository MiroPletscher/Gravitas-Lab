//
//  ContentView.swift
//  Gravitas Lab
//
//  Created by Miro Pletscher on 23/02/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack{
            NavigationStack{
                IntroductionScene()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background || newPhase == .inactive {
                AudioManager.shared.stopMusic()  // Stop music
            }
        }
    }
}

#Preview {
    ContentView()
}

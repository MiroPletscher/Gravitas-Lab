//
//  AudioManager.swift
//  Gravitas Lab
//
//  Created by Miro Pletscher on 23/02/25.
//

import Foundation
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    var audioPlayer: AVAudioPlayer?

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "game-music", withExtension: "mp3") else {
            print("Music file not found!")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // 🔄 Loop indefinitely
            audioPlayer?.volume = 0.5       // Adjust volume (0.0 - 1.0)
            audioPlayer?.play()
        } catch {
            print("Error playing music: \(error.localizedDescription)")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
    }
}

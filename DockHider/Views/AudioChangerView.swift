//
//  AudioChangerView.swift
//  DockHider
//
//  Created by lemin on 1/9/23.
//

import SwiftUI

struct AudioChangerView: View {
    var SoundIdentifier: AudioFiles.SoundEffect
    
    // included audio files
    struct IncludedAudioName: Identifiable {
        var id = UUID()
        var attachment: AudioFiles.SoundEffect
        var audioName: String
        var fileName: String
        var checked: Bool = false
    }
    
    // list of included audio files
    @State var audioFiles: [IncludedAudioName] = [
        // charging
        .init(attachment: AudioFiles.SoundEffect.charging, audioName: "Default", fileName: "Default"),
        .init(attachment: AudioFiles.SoundEffect.charging, audioName: "Old", fileName: "Old"),
        .init(attachment: AudioFiles.SoundEffect.charging, audioName: "Engage", fileName: "Engage"),
        .init(attachment: AudioFiles.SoundEffect.charging, audioName: "MagSafe", fileName: "MagSafe"),
        
        // lock
        .init(attachment: AudioFiles.SoundEffect.lock, audioName: "Default", fileName: "Default"),
        
        // notification
        .init(attachment: AudioFiles.SoundEffect.notification, audioName: "Default", fileName: "Default"),
        
        // screenshot
        .init(attachment: AudioFiles.SoundEffect.screenshot, audioName: "Default", fileName: "Default"),
        
        // sent message
        .init(attachment: AudioFiles.SoundEffect.sentMessage, audioName: "Default", fileName: "Default"),
        
        // received message
        .init(attachment: AudioFiles.SoundEffect.receivedMessage, audioName: "Default", fileName: "Default"),
        
        // payment success
        .init(attachment: AudioFiles.SoundEffect.paymentSuccess, audioName: "Default", fileName: "Default"),
    ]
    
    // applied sound
    @State private var appliedSound: String = "Default"
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach($audioFiles) { audio in
                        if audio.attachment.wrappedValue == SoundIdentifier {
                            // create button
                            // idk what I am doing with this but okay
                            HStack {
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.blue)
                                    .opacity(audio.checked.wrappedValue ? 1: 0)
                                
                                Button(audio.audioName.wrappedValue, action: {
                                    if appliedSound != audio.audioName.wrappedValue {
                                        for (i, file) in audioFiles.enumerated() {
                                            if file.audioName == appliedSound {
                                                audioFiles[i].checked = false
                                            } else if file.audioName == audio.audioName.wrappedValue {
                                                audioFiles[i].checked = true
                                            }
                                        }
                                        appliedSound = audio.audioName.wrappedValue
                                        // save to defaults
                                        UserDefaults.standard.set(appliedSound, forKey: SoundIdentifier.rawValue+"_Applied")
                                    }
                                })
                                .padding(.horizontal, 8)
                                .foregroundColor(.primary)
                            }
                        }
                    }
                } header: {
                    Text("Included")
                }
            }
        }
        .navigationTitle(SoundIdentifier.rawValue)
        .onAppear {
            appliedSound = UserDefaults.standard.string(forKey: SoundIdentifier.rawValue+"_Applied") ?? "Default"
            for (i, file) in audioFiles.enumerated() {
                if file.audioName == appliedSound {
                    audioFiles[i].checked = true
                }
            }
        }
    }
}

struct AudioChangerView_Previews: PreviewProvider {
    static var previews: some View {
        AudioChangerView(SoundIdentifier: AudioFiles.SoundEffect.charging)
    }
}

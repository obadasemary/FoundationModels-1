//
//----------------------------------------------
// Original project: FM - 1
// by  Stewart Lynch on 2025-08-31
//
// Follow me on Mastodon: https://iosdev.space/@StewartLynch
// Follow me on Threads: https://www.threads.net/@stewartlynch
// Follow me on Bluesky: https://bsky.app/profile/stewartlynch.bsky.social
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Email: slynch@createchsol.com
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch
//----------------------------------------------
// Copyright © 2025 CreaTECH Solutions. All rights reserved.


import SwiftUI
import FoundationModels

struct IsModelAvailable: View {
    
    @Environment(NavigationManger.self) var navManager
    
    @State private var notAvailableReason: String = ""
    
    var body: some View {
        NavigationStack {
            VStack{
                if notAvailableReason.isEmpty {
                    VStack {
                        Image(systemName: "apple.intelligence")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                        Text("Apple intelligence is enabled")
                    }
                        
                } else {
                    ContentUnavailableView {
                        Label("Apple intelligence is unavailable", systemImage: "apple.intelligence")
                    } description: {
                        Text(notAvailableReason)
                    } actions: {
                        Button {
                            checkIsAvailable()
                        } label: {
                            Text("Try again")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding()
            .navigationTitle(navManager.selectedTab.rawValue)
        }
        .onAppear {
            checkIsAvailable()
        }
    }
    
    func checkIsAvailable() {
        switch SystemLanguageModel.default.availability {
        case .available:
            notAvailableReason = ""
        case .unavailable(.appleIntelligenceNotEnabled):
            notAvailableReason = "Enable Apple Intelligence in your device settings"
        case .unavailable(.deviceNotEligible):
            notAvailableReason = "Your device is not eligible for this model"
        case .unavailable(.modelNotReady):
            notAvailableReason = "Model is not ready.\n Downloading or temporarily unavailable.\n Please ensure that you have sufficient battery and Wi-Fi"
        case .unavailable(let unknownReason):
            notAvailableReason = "Unknown reason: \(unknownReason)"
        }
    }
}

#Preview {
    @Previewable @State var navManager = NavigationManger()
    IsModelAvailable()
        .environment(navManager)
        .onAppear {
            navManager.selectedTab = .isAvailable
        }
}

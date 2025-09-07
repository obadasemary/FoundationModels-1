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
    @State private var notAvailableReason = ""
    var body: some View {
        VStack{
            if notAvailableReason.isEmpty {
                Text("Apple Intelligence enabled!")
            } else {
                ContentUnavailableView("Apple Intelligence Not available", systemImage: "apple.intelligence", description: Text(notAvailableReason))
            }
        }
        .padding()
        .navigationTitle("Model Status")
        .onAppear {
            checkIsAvailable()
        }
    }
    
    func checkIsAvailable() {
        switch SystemLanguageModel.default.availability {
        case .available:
            notAvailableReason = ""
        case .unavailable(.deviceNotEligible):
            notAvailableReason = "Upgrade to use Apple Intelligence"
        case .unavailable(.appleIntelligenceNotEnabled):
            notAvailableReason = "Enable Apple Intelligence in System Settings."
        case .unavailable(.modelNotReady):
            notAvailableReason = "Model not ready.  Downloding or temporarily unavailable. Please wait, ensure sufficient battery and Wi-Fi."
        case.unavailable(let unknownReason):
            notAvailableReason = "Model unavailable: \(String(describing: unknownReason))"
        }
    }
}

#Preview {
    IsModelAvailable()
}

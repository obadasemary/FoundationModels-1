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

struct ObservableIsModelAvailable: View {
    
    @Environment(NavigationManger.self) var navManager
    @Environment(FoundationModelsService.self) var foundationModelsService
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        NavigationStack {
            VStack{
                if foundationModelsService.isModelAvailable {
                    Text("Reusable Observable Service")
                } else {
                    AIUnavailableView()
                }
            }
            .padding()
            .navigationTitle(navManager.selectedTab.rawValue)
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .active {
                    foundationModelsService.checkIsAvailable()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var navManager = NavigationManger()
    ObservableIsModelAvailable()
        .environment(navManager)
        .environment(FoundationModelsService())
        .onAppear {
            navManager.selectedTab = .isAvailable
        }
}


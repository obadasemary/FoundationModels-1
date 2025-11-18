//
//  AIUnavailableView.swift
//  FM - 1
//
//  Created by Abdelrahman Mohamed on 18.11.2025.
//

import SwiftUI

struct AIUnavailableView: View {
    
    @Environment(FoundationModelsService.self) var foundationModelsService
    
    var body: some View {
        ContentUnavailableView {
            Label("Apple intelligence is unavailable", systemImage: "apple.intelligence")
        } description: {
            Text(foundationModelsService.notAvailableReason)
        } actions: {
            Button {
                foundationModelsService.checkIsAvailable()
            } label: {
                Text("Try again")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    AIUnavailableView()
        .environment(FoundationModelsService())
}

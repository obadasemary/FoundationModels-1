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

struct TheBasics: View {
    @Environment(NavigationManger.self) var navManager
    
    @State private var promt: String = ""
    @State private var reply: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Question", text: $promt)
                    .textFieldStyle(.roundedBorder)
                
                Button("Answer") {
                    reply = ""
                    let session = LanguageModelSession()
                    Task {
                        Task {
                            do {
                                reply = try await session
                                    .respond(to: promt)
                                    .content
                            } catch let error as LanguageModelSession.GenerationError {
                                switch error {
                                case .guardrailViolation(let context):
                                    reply = "Guadrail violation: \(context.debugDescription)"
                                case .decodingFailure(let context):
                                    reply = "Decoding Failure: \(context.debugDescription)"
                                case .rateLimited(let context):
                                    reply = "Rate Limited exceeded: \(context.debugDescription)"
                                default:
                                    reply = "Other error: \(error.localizedDescription)"
                                }
                                
                                if let failureReason = error.failureReason {
                                    reply += "\nFailure Reason: \(failureReason)"
                                }
                                if let helpAnchor = error.helpAnchor {
                                    reply += "\nHelp Anchor: \(helpAnchor)"
                                }
                                if let recoverySuggestion = error.recoverySuggestion {
                                    reply += "\nRecovery Suggestion: \(recoverySuggestion)"
                                }
                            } catch {
                                reply = error.localizedDescription
                            }
                        }
                        
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(promt.isEmpty)
                
                ScrollView {
                    Text(reply)
                }
            }
            .padding()
            .navigationTitle(navManager.selectedTab.rawValue)
        }
    }
}

#Preview {
    @Previewable @State var navManager = NavigationManger()
    TheBasics()
        .environment(NavigationManger())
        .onAppear {
            navManager.selectedTab = .basics
        }
}

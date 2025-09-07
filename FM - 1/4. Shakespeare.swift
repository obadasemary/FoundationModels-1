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

struct Shakespeare: View {
    @Environment(FoundationManager.self) var manager
    @Environment(\.scenePhase) private var scenePhase
    @FocusState private var isFocused:Bool
    @State private var topic = ""
    @State private var session = LanguageModelSession()
    @State private var response = ""
    var body: some View {
        Group {
            if manager.isModelAvailable {
                VStack  {
                    TextField("Enter poem topic", text: $topic)
                        .textFieldStyle(.roundedBorder)
                        .focused($isFocused)
                    Button("Create Poem") {
                        isFocused = false
                        guard manager.checkIsAvailable() else { return }
                        response = ""
                        var responseError = ""
                        Task {
                            let  prompt = Prompt("Create a two verse about \(topic) in the style of William Shakespeare.  Do not return any preamble.  Just return the two verse poem.")
                            do {
                                response = try await session.respond(to: prompt).content
                            } catch let error as LanguageModelSession.GenerationError {
                                switch error {
                                case .guardrailViolation(let context):
                                    responseError = "Guardrail violation: \(context.debugDescription)\n"
                                case .decodingFailure(let context):
                                    responseError = "Decoding failure: \(context.debugDescription)\n"
                                default:
                                    responseError = "Other error: \(error.localizedDescription)\n"
                                }
                                if let failureReason = error.failureReason {
                                    responseError += failureReason + "\n"
                                }
                                if let recovertSuggestion = error.recoverySuggestion {
                                    responseError += recovertSuggestion
                                }
                                response = responseError
                            } catch {
                                response = error.localizedDescription
                            }
                        }
                    }
                    .disabled(topic.isEmpty)
                    .buttonStyle(.borderedProminent)
                    ScrollView{
                        Text(LocalizedStringKey(response))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    }
                    .font(.title)
                    .scrollBounceBehavior(.basedOnSize)
                    .background(.quinary)
                    .clipShape(.rect(cornerRadius: 20))
                    .overlay {
                        if session.isResponding {
                            VStack {
                                ProgressView()
                                Text("Thinking....").font(.largeTitle)
                            }
                        }
                    }
                }
                .padding()
            } else {
                IntelligenceUnavailableView()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                manager.checkIsAvailable()
                print("Model is available:", manager.isModelAvailable)
            }
        }
        .onAppear {
            session.prewarm()
        }
    }
}

#Preview {
    Shakespeare()
        .environment(FoundationManager())
}

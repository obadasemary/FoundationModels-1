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
    @State private var prompt = ""
    @State private var response = ""
    var body: some View {
        VStack  {
            TextField("Enter Prompt", text: $prompt, axis: .vertical)
                .textFieldStyle(.roundedBorder)
            Button("Answer") {
                response = ""
                var responseError = ""
                let session = LanguageModelSession()
                Task {
                    do {
                        response =  try await session.respond(to: prompt).content
                    } catch let error as LanguageModelSession.GenerationError {
                        switch error {
            //            case .exceededContextWindowSize(let context):
            //
            //            case .assetsUnavailable(let context):
            //
                        case .guardrailViolation(let context):
                            responseError = "Guardrail violation: \(context.debugDescription)\n"
            //            case .unsupportedGuide(let context):
            //
            //            case .unsupportedLanguageOrLocale(let context):
            //
                        case .decodingFailure(let context):
                            responseError = "Decoding failure: \(context.debugDescription)\n"
            //            case .rateLimited(let context):
            //
            //            case .concurrentRequests(let context):
            //
            //            case .refusal(let refusal, let context):
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
                        response =  error.localizedDescription
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            ScrollView{
                Text(LocalizedStringKey(response))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .scrollBounceBehavior(.basedOnSize)
            .font(.title)
        }
        .padding()
    }
}

#Preview {
    TheBasics()
}

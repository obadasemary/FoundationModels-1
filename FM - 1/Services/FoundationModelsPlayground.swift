//
//  FoundationModelsPlayground.swift
//  FM - 1
//
//  Created by Abdelrahman Mohamed on 18.11.2025.
//

import Foundation
import Playgrounds
import FoundationModels

#Playground {
    
    let session = LanguageModelSession()
    let prompt = "What is the capital of Egypt?"
    
    Task {
        Task {
            do {
                let response = try await session.respond(to: prompt)
                print(response.content)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

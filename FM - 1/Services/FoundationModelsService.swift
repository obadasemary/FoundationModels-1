//
//  FoundationModelsService.swift
//  FM - 1
//
//  Created by Abdelrahman Mohamed on 18.11.2025.
//

import Foundation
import FoundationModels

@Observable
class FoundationModelsService {
    
    var notAvailableReason: String = "Checking for model availability..."
    var isModelAvailable: Bool {
        notAvailableReason.isEmpty
    }
    
    init() {
        checkIsAvailable()
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

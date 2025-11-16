# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a starter project for learning Apple's Foundation Models framework for on-device AI. The project is an educational resource accompanying a video tutorial series on implementing Foundation Models in Swift/SwiftUI applications.

**Bundle ID:** `com.SamuraiStudios.FM-1`
**Deployment Target:** iOS 26.0
**Language:** Swift with SwiftUI

## Building and Running

### Build the project
```bash
xcodebuild -scheme "FM - 1" -project "FM - 1.xcodeproj" build
```

### Clean build folder
```bash
xcodebuild -scheme "FM - 1" -project "FM - 1.xcodeproj" clean
```

### Run in simulator
Open the project in Xcode and use Cmd+R, or:
```bash
xcodebuild -scheme "FM - 1" -project "FM - 1.xcodeproj" -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Architecture

### Application Structure

The app uses a **tab-based navigation** architecture with numbered lesson modules demonstrating different Foundation Models concepts:

1. **Basics** - Introduction to Foundation Model requests
2. **Availability** - Checking if models are available on the device
3. **Observed Availability** - Reactive model availability using Observable pattern

### Key Components

**App Entry Point:** `FM - 1App.swift`
- Main app struct that injects `NavigationManger` into the environment
- Launches with `StartTab` as the root view

**Navigation System:**
- `NavigationManger` (Services/NavigationManager.swift) - Observable class that manages the currently selected tab
- `MyTabs` enum (0. StartTab.swift) - Defines all available tabs with associated views
- `StartTab` (0. StartTab.swift) - TabView container that binds to NavigationManger

**View Organization:**
- All views are numbered (0-3) to indicate learning progression
- Each view follows a consistent pattern: NavigationStack wrapper with environment-injected NavigationManger
- Navigation titles are dynamically set from the selected tab's raw value

### File Naming Convention

Files are prefixed with numbers to indicate the order they should be understood/implemented:
- `0. StartTab.swift` - Entry point view
- `1. TheBasics.swift` - First lesson
- `2. IsModelAvailable.swift` - Second lesson
- `3. ObservableIsModelAvailable.swift` - Third lesson

## Development Notes

### Environment Injection Pattern

The app uses SwiftUI's environment system to share state:
```swift
.environment(navManager)  // Inject NavigationManger
@Environment(NavigationManger.self) var navManager  // Access in views
```

### Observable Pattern

`NavigationManger` uses the `@Observable` macro (iOS 17+) for reactive state management instead of ObservableObject/Published pattern.

### Preview Pattern

All views include SwiftUI previews with properly configured environment:
```swift
#Preview {
    @Previewable @State var navManager = NavigationManger()
    ViewName()
        .environment(navManager)
        .onAppear {
            navManager.selectedTab = .relevantTab
        }
}
```

## Project Context

This is a learning/tutorial project based on content by Stewart Lynch. The codebase is intentionally simple and structured for educational purposes, demonstrating Foundation Models framework concepts progressively across numbered tabs.

//
//  Timer_Composable_ArchitectureApp.swift
//  Timer Composable Architecture
//
//  Created by Tiago Pinheiro on 12/10/2023.
//

import ComposableArchitecture
import SwiftUI

@main
struct Timer_Composable_ArchitectureApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: CounterFeature.State()) {
                    CounterFeature()
                }
            )
        }
    }
}

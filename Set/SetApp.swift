//
//  SetApp.swift
//  Set
//
//  Created by Flynn Traeger on 19/04/2021.
//

import SwiftUI

@main
struct SetApp: App {
    let viewModel = SetGameViewModel()
    var body: some Scene {
        WindowGroup {
            SetGameView(game: viewModel)
        }
    }
}

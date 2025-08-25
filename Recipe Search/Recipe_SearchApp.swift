//
//  Recipe_SearchApp.swift
//  Recipe Search
//
//  Created by Dev Soni on 24/08/25.
//

import SwiftUI

@main
struct Recipe_SearchApp: App {
    
    let vm = RecipeSearchViewModel(dataService: DataService())
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(vm)
        }
    }
}

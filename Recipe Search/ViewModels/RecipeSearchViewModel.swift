//
//  RecipeSearchViewModel.swift
//  Recipe Search
//
//  Created by Dev Soni on 25/08/25.
//

import Foundation
import Observation

@MainActor
@Observable
final class RecipeSearchViewModel{
    
    private let dataService: DataService
    
    var queryText: String = "" // What the user typed in the search bar
    var recipes: [Recipe] = [] // The Recipes to render in the list
    var isLoading: Bool = false // When true; disable the ui and show a spinner
    var errorMessage: String? = nil
    
    private var lastSuccessfulQuery: String?
    
    init(dataService: DataService){
        self.dataService = dataService
    }
    
    // Kick off a search based on 'queryText'
    // Call this from a search button tap or onSubmit of the TextField.
    func search() async {
        // 1. Trim & Validate to avoid junk request and rate-limit
        let q = queryText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else {
            errorMessage = nil
            recipes = []
            return
        }
        
        // 2. Prevent double-taps / overlapping the requests
        guard !isLoading else { return }
        
        // 3. Call the Service
        let items = await dataService.fetchRecipes(query: q)
        
        recipes = items
        lastSuccessfulQuery = q
        
        if items.isEmpty {
            errorMessage = "No recipes found for '\(q)'"
        }
    }
}

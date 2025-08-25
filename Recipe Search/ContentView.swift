//
//  ContentView.swift
//  Recipe Search
//
//  Created by Dev Soni on 24/08/25.
//

import SwiftUI

struct ContentView: View {
    
    let dataService = DataService()
    
    var body: some View {
        VStack {
            Button{
                Task {
                    let recipes = await dataService.fetchRecipes(query: "pasta")
                    print(recipes)
                }
            } label: {
                Text("Test Request")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

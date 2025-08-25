//
//  DataService.swift
//  Recipe Search
//
//  Created by Dev Soni on 25/08/25.
//

import Foundation

struct DataService {
    let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    func fetchRecipes(query: String?) async -> [Recipe]{
        // 1. Check if API Key exists
        guard let apiKey = apiKey else {
            return []
        }
        
        // 2. Create URL
        var endpointUrlString = "https://api.spoonacular.com/recipes/complexSearch"
        if query != nil && query != "" {
            endpointUrlString.append("?query=\(query!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)")
        }
        
        if let url = URL(string: endpointUrlString) {
            
            // 3. Create Request
            var request = URLRequest(url: url)
            request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
            request.httpMethod = "GET"
            
            // 4. Send Request
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                
                // 5. Parse the JSON
                let decoder = JSONDecoder()
                let decodedResult = try decoder.decode(RecipeSearchResponse.self, from: data)
                return decodedResult.results
            } catch {
                print(error)
                return []
            }
        }
        return []
    }
}

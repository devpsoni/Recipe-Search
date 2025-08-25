//
//  RecipeSearchResponse.swift
//  Recipe Search
//
//  Created by Dev Soni on 25/08/25.
//

import Foundation

struct RecipeSearchResponse: Decodable {
    let results: [Recipe]
    let totalResults: Int
}

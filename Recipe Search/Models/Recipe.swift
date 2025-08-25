//
//  Recipe.swift
//  Recipe Search
//
//  Created by Dev Soni on 25/08/25.
//

import Foundation

struct Recipe: Decodable, Identifiable {
    var id: Int
    var title: String
    var image: String
}

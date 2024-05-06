//
//  SearchModel.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import Foundation

struct SearchModel: Codable {
    let search: [SearchDataModel]
    let totalResults: String
    let response: String
    
    private enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults = "totalResults"
        case response = "Response"
    }
}

struct SearchDataModel: Codable {
    let title: String
    let year: String
    let poster: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
    }
}

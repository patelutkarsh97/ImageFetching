//
//  NetworkConstants.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import Foundation

enum NetworkMethods: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkUrls {
    case searchResult(_ query: String, _ page: Int)
    
    private var endpoint: String {
        switch self {
        case .searchResult(let query, let page):
            return "s=\(query)&page=\(page)"
        }
    }
    
    private var webProtocol: String {
        return "https"
    }
    
    private var baseUrl: String {
        return "www.omdbapi.com"
    }
    
    private var path: String {
        return "?apikey=7d58cc52&"
    }
    
    func getURL() -> String {
        webProtocol + "://" + baseUrl + "/" + path + endpoint
    }
}

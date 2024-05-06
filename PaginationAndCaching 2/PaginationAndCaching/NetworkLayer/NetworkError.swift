//
//  NetworkError.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import Foundation

enum NetworkError: Error {
    case parsingFailed
    case unknownError
    case invalidUrl
    case unableToFetchImage
    
    var localizedDescription: String {
        switch self {
        case .parsingFailed:
            return "Parsing Failed"
        case .unknownError:
            return "Something went wrong"
        case .invalidUrl:
            return "Invalid Url"
        case .unableToFetchImage:
            return "Unable to fetch Image"
        }
    }
}

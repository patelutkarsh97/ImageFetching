//
//  NetworkManager.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import Foundation
import UIKit

struct NetworkManager {
    private var urlSession = URLSession.shared
    
    func fetchData<T: Codable>(for type: T.Type, url: URL, completion: @escaping (Result<T,NetworkError>) -> Void) {
        let urlCache = URLCache(memoryCapacity: 20000, diskCapacity: 200000)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = NetworkMethods.get.rawValue
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        
        urlSession.configuration.urlCache = urlCache

        urlSession.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                if let finalError = error as? NetworkError {
                    completion(.failure(finalError))
                } else {
                    completion(.failure(.unknownError))
                }
            } else if let data = data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseData = try decoder.decode(T.self, from: data)
                    completion(.success(responseData))
                } catch let error {
                    if let finalError = error as? NetworkError {
                        completion(.failure(finalError))
                    } else {
                        completion(.failure(.parsingFailed))
                    }
                }
            } else {
                completion(.failure(.unknownError))
            }
        }.resume()
    }
    
    func downloaadImageFromURL(imageURL: URL, completion: @escaping (Result<UIImage,NetworkError>) -> Void) {
        urlSession.dataTask(with: imageURL) { data, response, error in
            if let _ = error {
                completion(.failure(.unknownError))
            } else if let data = data {
                if let movieImage = UIImage(data: data) {
                    completion(.success(movieImage))
                } else {
                    completion(.failure(.parsingFailed))
                }
            } else {
                completion(.failure(.unknownError))
            }
        }.resume()
    }
    
}


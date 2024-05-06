//
//  NetworkRepo.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import Foundation
import UIKit

protocol NetworkLoaderProtocol {
    func fetchData<T: Codable>(for type: T.Type, with urlString: NetworkUrls, completion: @escaping (Result<T,NetworkError>) -> Void)
    func fetchImage(imageURL: String, completion: @escaping (Result<UIImage,NetworkError>) -> Void)
}

extension NetworkLoaderProtocol {
    func fetchData<T: Codable>(for type: T.Type, with urlString: NetworkUrls, completion: @escaping (Result<T,NetworkError>) -> Void) {
        guard let url = URL(string: urlString.getURL()) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let cacheManager = CacheManager<T>()
        cacheManager.fetchData(url: url) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func fetchImage(imageURL: String, completion: @escaping (Result<UIImage,NetworkError>) -> Void) {
        guard let imgURL = URL(string: imageURL) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let imageCacheManager = ImageCacheManager()
        imageCacheManager.fetchImage(url: imgURL) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    completion(.success(image))
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                
            }
        }
    }
}

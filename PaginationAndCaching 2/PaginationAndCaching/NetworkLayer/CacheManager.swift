//
//  CacheManager.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import Foundation
import UIKit

struct CacheManager<T: Codable> {
    private var urlSession = URLSession.shared

    func fetchData(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard isDataAvailableInCache(for: url) else {
            loadDataFromWeb(for: url, completion: completion)
            return
        }

        do {
            let data = try loadDataFromCache(for: url)
            completion(.success(data))
        } catch {
            loadDataFromWeb(for: url, completion: completion)
        }
    }

    private func loadDataFromWeb(for url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let networkManager = NetworkManager()
        networkManager.fetchData(for: T.self, url: url) { result in
            switch result {
            case .success(let data):
                do {
                    try self.saveData(for: url, data: data)
                } catch {
                    print("Cache saving failed")
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func isDataAvailableInCache(for url: URL) -> Bool {
        guard let endPoint = URLComponents(string: url.absoluteString)?.path.split(separator: "/").last, let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }

        let fileURL = url.appendingPathComponent(String(endPoint))
        do {
            let _ = try Data(contentsOf: fileURL)
            return true
        } catch {
            return false
        }
    }

    private func loadDataFromCache(for url: URL) throws -> T {
        guard let endPoint = URLComponents(string: url.absoluteString)?.path.split(separator: "/").last, let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NetworkError.unknownError
        }

        let fileURL = url.appendingPathComponent(String(endPoint))
        do {
            let data = try Data(contentsOf: fileURL)
            let responseData = try JSONDecoder().decode(T.self, from: data)
            return responseData
        } catch {
            throw NetworkError.unknownError
        }
    }

    private func saveData(for url: URL, data: T) throws {
        guard let endPoint = URLComponents(string: url.absoluteString)?.path.split(separator: "/").last, let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NetworkError.unknownError
        }

        let fileURL = url.appendingPathComponent(String(endPoint))
        do {
            let rawData = try JSONEncoder().encode(data)
            try rawData.write(to: fileURL)
        } catch {
            throw NetworkError.unknownError
        }
    }
}

struct ImageCacheManager {

    func fetchImage(url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard isDataAvailableInCache(for: url) else {
            fetchImagefromServer(for: url, completion: completion)
            return
        }

        do {
            let image = try loadImageFromCache(for: url)
            completion(.success(image))
        } catch {
            fetchImagefromServer(for: url, completion: completion)
        }
    }

    private func fetchImagefromServer(for url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        let networkManager = NetworkManager()
        networkManager.downloaadImageFromURL(imageURL: url) { result in
            switch result {
            case .success(let image):
                try? saveImage(for: url, image: image)
                completion(.success(image))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func isDataAvailableInCache(for url: URL) -> Bool {
        guard let endPoint = URLComponents(string: url.absoluteString)?.path.split(separator: "/").last, let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }

        let fileURL = url.appendingPathComponent(String(endPoint))
        do {
            let _ = try Data(contentsOf: fileURL)
            return true
        } catch {
            return false
        }
    }


    private func loadImageFromCache(for url: URL) throws -> UIImage {
        guard let imageName = URLComponents(string: url.absoluteString)?.path.split(separator: "/").last, let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw NetworkError.invalidUrl
        }
        let fileURL = url.appendingPathComponent(String(imageName))

        do {
            let data = try Data(contentsOf: fileURL)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw NetworkError.unableToFetchImage
            }
        } catch {
            throw NetworkError.unableToFetchImage
        }
    }

    private func saveImage(for url: URL, image: UIImage) throws {
        guard let imageName = URLComponents(string: url.absoluteString)?.path.split(separator: "/").last, let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let fileURL = url.appendingPathComponent(String(imageName))
        if let data = image.jpegData(compressionQuality: 1.0) {
            do {
                try data.write(to: fileURL)
            } catch {
                throw NetworkError.unknownError
            }
        } else {
            throw NetworkError.unknownError
        }
    }

}

//
//  SearchViewModel.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import Foundation

protocol SearchViewModelProtocol {
    var searchlistData: [SearchDataModel] { get }
    var totalResponse: Int { get }
    var page: Int { get set }
    func fetchListData(queryString: String, completion: @escaping (Bool) -> Void)
}

class SearchViewModel: SearchViewModelProtocol, NetworkLoaderProtocol {
    
    var searchlistData: [SearchDataModel] = []
    var page: Int = 1
    var totalResponse: Int = 0
    
    func fetchListData(queryString: String, completion: @escaping (Bool) -> Void) {
        let operationQueue = OperationQueue()
        operationQueue.cancelAllOperations()
        operationQueue.addOperation { [unowned self] in
            if self.searchlistData.count < self.totalResponse {
                page += 1
            } else if searchlistData.count != 0, totalResponse != 0 {
                page = 1
                return
            }
            fetchData(for: SearchModel.self, with: .searchResult(queryString, page)) { [weak self] result in
                switch result {
                case .success(let response):
                    self?.searchlistData.append(contentsOf: response.search)
    //                self?.searchlistData = response.search
                    self?.totalResponse = Int(response.totalResults) ?? 0
                    completion(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
}

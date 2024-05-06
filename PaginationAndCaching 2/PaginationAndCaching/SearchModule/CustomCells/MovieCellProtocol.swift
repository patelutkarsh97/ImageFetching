//
//  MovieCellProtocol.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import Foundation
import UIKit

protocol MovieCellProtocol: UICollectionViewCell {
    var movieImageView: UIImageView! { get }
    var movieTitleLabel: UILabel! { get }
    var movieYearLabel: UILabel! { get }
    
    func configureMovieCell(for item: SearchDataModel)
}

extension MovieCellProtocol {
    
    func configureMovieCell(for item: SearchDataModel) {
        movieTitleLabel.text = item.title
        movieYearLabel.text = item.year
        setImage(url: item.poster)
    }
    
    func setImage(url: String) {
        guard let imageURL = URL(string: url) else {
            return
        }
        let cacheManager = ImageCacheManager()
        cacheManager.fetchImage(url: imageURL) { result in
            switch result {
            case.success(let image):
                DispatchQueue.main.async {
                    self.movieImageView.image = image
                }
            case.failure(let error):
                print("Error", error)
            }
        }
    }
    
}

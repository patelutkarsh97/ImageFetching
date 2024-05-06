//
//  SearchViewController.swift
//  PaginationAndCaching
//
//  Created by UTKARSH PATEL on 21/05/22.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var gridViewButton: UIButton!
    @IBOutlet weak var searchResultCollectionView: UICollectionView!
    
    let searchVM: SearchViewModelProtocol = SearchViewModel()
    var searchText: String = "Avenger"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        registerCell()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
    }

    private func setupUI() {
        if searchVM.searchlistData.isEmpty {
            [gridViewButton, searchResultCollectionView].forEach({ $0?.isHidden = true })
        } else {
            [gridViewButton, searchResultCollectionView].forEach({ $0?.isHidden = false })
        }
    }
    @IBAction func switchButtonAction() {
        gridViewButton.isSelected = !gridViewButton.isSelected
        searchResultCollectionView.reloadData()
    }
    
    func registerCell() {
        searchResultCollectionView.register(UINib(nibName: "GridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridCollectionViewCell")
        searchResultCollectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
    }
    
    func fetchData() {
        guard !searchText.isEmpty else { return }
        guard searchText.count > 2 else { return }
        searchVM.fetchListData(queryString: searchText) { isSuccess in
            if isSuccess {
                print(self.searchVM.searchlistData)
                self.searchResultCollectionView.reloadData()
            } else {
                print("Error")
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchVM.searchlistData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var movieCell: MovieCellProtocol?
        if gridViewButton.isSelected {
            movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCollectionViewCell", for: indexPath) as? GridCollectionViewCell
        } else {
            
            movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCollectionViewCell", for: indexPath) as? ListCollectionViewCell
        }
        movieCell?.configureMovieCell(for: searchVM.searchlistData[indexPath.item])
        return movieCell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if gridViewButton.isSelected {
            return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.width)
        } else {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.width/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (searchVM.searchlistData.count - 1) == indexPath.item {
            fetchData()
        }
    }

}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText = textField.text ?? ""
        print("Search Text is ", searchText)
        fetchData()
        return true
    }
}

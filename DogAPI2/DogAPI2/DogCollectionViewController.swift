//
//  DogCollectionViewController.swift
//  DogAPI2
//
//  Created by spark-02 on 2024/06/12.
//

import UIKit

class DogCollectionViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dogName: String?
    var dogImages: [String] = []
    let dogImageFetcher = DogImageFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let dogName = dogName {
            navigationItem.title = dogName
        }
        
        fetchDogImages()
    }
    
    func fetchDogImages() {
        guard let dogName = dogName else {
            return
        }
        
        dogImageFetcher.fetchDogImages(for: dogName) { [weak self] images in
            DispatchQueue.main.async {
                self?.dogImages = images
                self?.collectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dogImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DogImageCell", for: indexPath) as! CollectionViewCell
        
        let imageURL = dogImages[indexPath.item]
        cell.configure(with: imageURL)
        
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "DogDetailSegue" {
//            if let dogDetailVC = segue.destination as? DogDetailViewController,
//               let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
//                dogDetailVC.imageURLs = dogImages
//                dogDetailVC.currentIndex = selectedIndexPath.item
//            }
//        }
//    }
    
}

// 画面サイズ2分割
extension DogCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth: CGFloat = screenWidth / 2
        let cellHeight = cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

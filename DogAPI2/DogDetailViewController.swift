//
//  DogDetailViewController.swift
//  DogAPI2
//
//  Created by spark-02 on 2024/06/12.
//

import UIKit

class DogDetailViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var imageURLs: [String] = []
    var currentIndex: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        //右スワイプのジェスチャー
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeRightGesture.direction = .right
        imageView.addGestureRecognizer(swipeRightGesture)
        
        // 左へスワイプのジェスチャー
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeLeftGesture.direction = .left
        imageView.addGestureRecognizer(swipeLeftGesture)
        
        // 画像の拡大縮小
        scrollView.delegate = self
               scrollView.minimumZoomScale = 1.0
               scrollView.maximumZoomScale = 3.0
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
               scrollView.addGestureRecognizer(pinchGesture)
        
        loadImage(at: currentIndex)
    }
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
           if let view = gesture.view {
               view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
               gesture.scale = 1.0
           }
       }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            // 右にスワイプされた場合の処理
            currentIndex -= 1
            if currentIndex < 0 {
                currentIndex = imageURLs.count - 1
            }
            loadImage(at: currentIndex)
        } else if gesture.direction == .left {
            // 左にスワイプされた場合の処理
            currentIndex += 1
            if currentIndex >= imageURLs.count {
                currentIndex = 0
            }
            
            loadImage(at: currentIndex)
        }
    }
    
    func loadImage(at index: Int) {
        let imageURL = imageURLs[index]
        
        guard let url = URL(string: imageURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            
            DispatchQueue.main.async {
                UIView.transition(with: self.imageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.imageView.image = image
                }, completion: nil)
            }
        }.resume()
    }
}

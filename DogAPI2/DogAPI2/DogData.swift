//
//  DogData.swift
//  DogAPI2
//
//  Created by spark-02 on 2024/06/12.
//

import Foundation


// TableView
class DogFetcher {
    func fetchDogList(completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "https://dog.ceo/api/breeds/list/all") else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(DogResponse.self, from: data)
                    let dogs = Array(response.message.keys)
                    completion(dogs)
                } catch {
                    print("データの解析エラー: \(error.localizedDescription)")
                    completion([])
                }
            } else {
                completion([])
            }
        }.resume()
    }
}


// CollectionView
class DogImageFetcher {
    func fetchDogImages(for dogName: String, completion: @escaping ([String]) -> Void) {
        guard let url = URL(string: "https://dog.ceo/api/breed/\(dogName)/images") else {
            completion([]) // URLが無効な場合は空の画像リストを返す
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                completion([])
                return
            }
            
            do {
                let result = try JSONDecoder().decode(DogImageResponse.self, from: data)
                let images = result.message
                completion(images)
            } catch {
                print("Error in decoding: \(error.localizedDescription)")
                completion([])
            }
        }.resume()
    }
}

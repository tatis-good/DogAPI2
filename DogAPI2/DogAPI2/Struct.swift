//
//  Struct.swift
//  DogAPI2
//
//  Created by spark-02 on 2024/06/12.
//

import Foundation



// TableView
struct DogResponse: Codable {
    let message: [String: [String]]
}

// CollectionView
struct DogImageResponse: Decodable {
    let message: [String]
}

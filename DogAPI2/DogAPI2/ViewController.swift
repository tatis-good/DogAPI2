//
//  ViewController.swift
//  DogAPI2
//
//  Created by spark-02 on 2024/06/12.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dogs: [String] = []
    let dogFetcher = DogFetcher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchDogList()
    }

    func fetchDogList() {
        dogFetcher.fetchDogList { [weak self] dogs in
            let sortedDogs = dogs.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
            DispatchQueue.main.async {
                self?.dogs = sortedDogs
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDog = dogs[indexPath.row]
        performSegue(withIdentifier: "DogImageSegue", sender: selectedDog)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DogCell", for: indexPath)
        cell.textLabel?.text = dogs[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DogImageSegue" {
            if let selectedDog = sender as? String, let destinationVC = segue.destination as? DogCollectionViewController {
                destinationVC.dogName = selectedDog
            }
        }
    }
}


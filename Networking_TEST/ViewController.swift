//
//  ViewController.swift
//  Networking_TEST
//
//  Created by User on 05.03.2022.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    let url =  "https://jsonplaceholder.typicode.com/albums"
    let urlBeatles = "https://itunes.apple.com/search?term=the+beatles&media=music&limit=10"
    let postRequest = "https://jsonplaceholder.typicode.com/posts"
    
    var posts:[Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
    
    }
    private func fetch() {
        NetworkManager.shared.fetchData(from: url) { result in
            switch result {
                
            case .success(let posts):
                DispatchQueue.main.async {
                    self.titleLabel.text = posts[3].title
                    self.idLabel.text = String(posts[3].ID ?? 0)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func postTestRequestWithDictionary () {
        
        NetworkManager.shared.postRequestWithDictionary(with: NetworkManager.shared.dict, url: postRequest) { result in
            switch result {
                
            case .success(let post):
                print(post)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postTestRequestWithModel () {
        
        NetworkManager.shared.postRequestWithModel(with: NetworkManager.shared.model, url: postRequest) { result in
            switch result {
            case .success(let post):
                print(post)
            case .failure(let error):
                print(error)
            }
        }
            }
}


//
//  Post.swift
//  Networking_TEST
//
//  Created by User on 05.03.2022.
//

import Foundation
import Alamofire


struct Post: Codable {
    let userId: Int?
    let ID: Int?
    let title: String?
    
    init (dataPost: [String : Any]) {
        userId = dataPost["userId"] as? Int ?? 0
        ID = dataPost["id"] as? Int ?? 0
        title = dataPost["title"] as? String ?? ""
    }
    
    init(userID: Int, id: Int, title: String) {
        self.userId = userID
        self.ID = id
        self.title = title
    }
    
    
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case ID = "id"
        case title = "title"
    }
    
    static func getPosts(from value: Any) -> [Post] {

        var posts:[Post] = []
        
        guard let value = value as? [[String:Any]] else { return [] }
        for value in value {
            let post = Post(dataPost: value)
            posts.append(post)
        }
        return posts
    }
}

struct PostTwo: Codable {
    let userId: Int?
    let ID: Int?
    let title: String?
}

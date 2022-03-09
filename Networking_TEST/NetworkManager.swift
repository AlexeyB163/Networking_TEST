//
//  NetworkManager.swift
//  Networking_TEST
//
//  Created by User on 05.03.2022.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    

    enum NetworkError: Error {
        case invalidURL
        case noData
        case decodingError
    }
    
    let dict:[String : Any] =
        ["name": "Networking",
         "imageUrl": "image url",
         "numberOfLessons": "10",
         "numberOfTests": "8"]
    
    let model = PostTwo(userId: 1,
                        ID: 2,
                        title: "test"
    )
    
    func fetchData ( from url: String, completion: @escaping (Result<[Post],Error>) -> Void) {

        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
                do {
                    // ручной парсинг
                    // переводим data  в Any
                    let dataPost = try JSONSerialization.jsonObject(with: data)
                    let posts = Post.getPosts(from: dataPost)
                    
//                    let jsonDecoder = JSONDecoder()
//                    guard let posts = try? jsonDecoder.decode([Post].self, from: data) else {
//                        print(NetworkError.decodingError)
//                        return}
                    DispatchQueue.main.async {
                        completion(.success(posts))
                    }
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
        }.resume()
    }
    
    func postRequestWithDictionary(with data: [String:Any], url: String, completion: @escaping (Result<Any, NetworkError>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        // Создаем типа Data из формата JSON
        guard let postData = try? JSONSerialization.data(withJSONObject: data) else {
            completion(.failure(.noData))
            return
        }
        // Помещаем данные которые нам нужно отправить на сервер в сам этот запрос:
        //Создаем URL запрос
        var request = URLRequest(url: url)
        //Определяем тип запроса.
        request.httpMethod = "POST"
        // Определяем правила формирования запроса(только если это требуется):
        // данные берем из ответа от сервера - response (см. URLSession ниже)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //Помещаем data в запрос
        request.httpBody = postData
        
        // Запускаем URLсессию по отправке данных
        // Completion означает, что сервер нам вернет результат, тот результат который мы ему отправили
        // Completion нужен для того чтобы сервер вернул нам результат отправки, для того чтобы понять успешно отправились данные или нет
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                return
            }
            print(response)
            
        // Декодируем полученный ответ от сервера
        do {
            //т.к данные отправляли не ввиде модели, то и получаем их не ввиде модели
            // jsonObject - декодируем data в json
            let post = try JSONSerialization.jsonObject(with: data)
            completion(.success(post))
        } catch {
            completion(.failure(.decodingError))
            }
        }.resume()
        
    }
    
    func postRequestWithModel(with data: PostTwo, url: String, completion: @escaping (Result<Any, NetworkError>) -> Void) {
        
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        // Создаем типа Data из модели
        guard  let postData = try? JSONEncoder().encode(data) else {
            completion(.failure(.noData))
            return
        }
        // Помещаем данные которые нам нужно отправить на сервер в сам этот запрос:
        //Создаем URL запрос
        var request = URLRequest(url: url)
        //Определяем тип запроса. По умолчанию стоит get, но нам сейчас нужен post.
        request.httpMethod = "POST"
        // Определяем правила формирования запроса(только если это требуется):
        // данные берем из ответа от сервера - response (см. URLSession ниже)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //Помещаем data в запрос
        request.httpBody = postData
        
        // Запускаем URLсессию по отправке данных
        // Completion означает, что сервер нам вернет результат, тот результат который мы ему отправили
        // Completion нужен для того чтобы сервер вернул нам результат отправки, для того чтобы понять успешно отправились данные или нет
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, let response = response else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let post = try JSONDecoder().decode(PostTwo.self, from: data)
                completion(.success(post))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
                         
        
    }
    
    private init() {}
}

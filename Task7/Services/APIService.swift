//
//  APIService.swift
//  Task7
//
//  Created by Вадим Сайко on 24.01.23.
//

import UIKit

struct APIService {
    enum APIError: Error {
        case invalidURL
        case invalidResponseStatus
        case dataTaskError
        case corruptData
        case decodingError
    }
    
    static func getData(completionHandler: @escaping (Result<GetModel, APIError>) -> Void) {
        guard let url = URL(string: "http://test.clevertec.ru/tt/meta/") else { completionHandler(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                    completionHandler(.failure(.invalidResponseStatus))
                return
            }
            guard error == nil else {
                    completionHandler(.failure(.dataTaskError))
                return
            }
            guard let data = data else {
                    completionHandler(.failure(.corruptData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(GetModel.self, from: data)
                    completionHandler(.success(decodedData))
            } catch {
                    completionHandler(.failure(.decodingError))
                return
            }
        }
        .resume()
    }
 
    static func loadImage(url: String, completionHandler: @escaping (Result<UIImage, APIError>) -> Void) {
        guard let url = URL(string: url) else {
                completionHandler(.failure(.invalidURL))
            return
        }
        let urlRequest = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else {
                    completionHandler(.failure(.corruptData))
                return
            }
            guard let image = UIImage(data: data) else {
                    completionHandler(.failure(.dataTaskError))
                return
            }
            DispatchQueue.main.async {
                completionHandler(.success(image))
            }
        }
        .resume()
    }
    
    static func postData(_ dataToPost: PostModel, completionHandler: @escaping (Result<Response, APIError>) -> Void) {
        guard let url = URL(string: "http://test.clevertec.ru/tt/data/") else { completionHandler(.failure(.invalidURL))
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(dataToPost)
            urlRequest.httpBody = encodedData
        } catch {
            print(error)
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlRequest) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                    completionHandler(.failure(.invalidResponseStatus))
                return
            }
            guard error == nil else {
                    completionHandler(.failure(.dataTaskError))
                return
            }
            guard let data = data else {
                    completionHandler(.failure(.corruptData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Response.self, from: data)
                completionHandler(.success(data))
            } catch {
                    completionHandler(.failure(.decodingError))
                return
            }
        }
        .resume()
    }
}

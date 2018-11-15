//
//  MenuController.swift
//  Restaurant
//
//  Created by Александр Макаров on 12.11.2018.
//  Copyright © 2018 Александр Макаров. All rights reserved.
//

import UIKit

class MenuController {
    let baseURL = URL(string: "http://api.armenu.net:8090/")!
    
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
        let categoryURL = baseURL.appendingPathComponent("categories")
        let task = URLSession.shared.dataTask(with: categoryURL) { data, response, error in
            if let data = data,
                let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let categories = jsonDictionary?["categories"] as? [String] {
                completion(categories)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    //    func fetchCategories(completion: @escaping ([String]?) -> Void) {
    //        let categoryURL = baseURL.appendingPathComponent("categories")
    //        let task = URLSession.shared.dataTask(with: categoryURL) {
    //            data, response, error in
    //
    //            guard let data = data else {
    //                completion(nil)
    //                return
    //            }
    //
    //            guard let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    //                else {
    //                    completion(nil)
    //                    return
    //            }
    //
    //            guard let categories = jsonDictionary?["categories"] as? [String] else {
    //                completion(nil)
    //                return
    //            }
    //
    //            completion(categories)
    //        }
    //        task.resume()
    //    }
    
    func fetchMenuItems(forCategory categoryName: String = "", completion: @escaping ([MenuItem]?) -> Void) {
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        //components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        if categoryName != "" {
            components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        }
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) { data, response, error in
            let jsonDecoder = JSONDecoder()
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            guard let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) else {
                completion(nil)
                return
            }
            
            completion(menuItems.items)
        }
        task.resume()
    }
    
    func submitOrder(forMenuIDS menuIds: [Int], completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let jsonDecoder = JSONDecoder()
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            guard let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) else {
                completion(nil)
                return
            }
            
            completion(preparationTime.prepTime)
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return }
        
        components.host = baseURL.host
        
        guard let url = components.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
}

//
//  APIClient.swift
//  Eh-Ho
//
//  Created by Ignacio Garcia Sainz on 16/07/2019.
//  Copyright © 2019 KeepCoding. All rights reserved.
//

import Foundation

final class SessionAPI {
    
    private let mDataManager = DataManager()
    private var mListCategoriesResponse: Array<ListCategoriesResponse> = Array()
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        return session
    }()
    
    //...... SEND
    func send<T: APIRequest>(request: T, completion: @escaping(Result<T.Response, Error>) -> ()) {
        let request = request.requestWithBaseUrl()
      
        
        let task = session.dataTask(with: request) { data, response, error in
            
            do {
                
                if let data = data {
                    let model = try JSONDecoder().decode(T.Response.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(model))
                    }
                   
                }
            } catch _ {
               
                print("Error en respuesta función SEND -> más que probable error de PARSEO")
                }
        }
        task.resume()
    }
    
   
}

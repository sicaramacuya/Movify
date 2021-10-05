//
//  APIClient.swift
//  Moviefy
//
//  Created by Eric Morales on 10/4/21.
//  Copyright © 2021 Adriana González Martínez. All rights reserved.
//

import Foundation

struct APIClient {
    static let shared = APIClient()
    let session = URLSession(configuration: .default)
    let parameters = [
        "api_key": "a39a35f0ad63375d1cf21515e56de8c5",
        "sort_by": "popularity.desc",
    ]
    
    func getPopularMovies(_ completion: @escaping (Result<[Movie]>) -> ()) {
        do{
            // Creating the request
            let request = try Request.configureRequest(from: .movies, with: parameters, and: .get, contains: nil)
            session.dataTask(with: request) { (data, response, error) in
                
                if let response = response as? HTTPURLResponse, let data = data {
                    
                    let result = Response.handleResponse(for: response)
                    switch result {
                    case .success:
                        //Decode if successful
                        let result = try? JSONDecoder().decode(MovieApiResponse.self, from: data)
                        completion(Result.success(result!.movies))
                        
                    case .failure:
                        completion(Result.failure(NetworkError.decodingFailed))
                    }
                }
            }.resume()
        }catch{
            completion(Result.failure(NetworkError.badRequest))
        }
    }
    
}

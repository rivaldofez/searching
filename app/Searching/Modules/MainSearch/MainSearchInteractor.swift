//
//  MainSearchInteractor.swift
//  Searching
//
//  Created by Rivaldo Fernandes on 14/07/25.
//

import Foundation
import Combine

class MainSearchInteractor {
    func searchNews(query: String) -> AnyPublisher<[String], Error> {
        guard !query.isEmpty else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let baseURL = "http://127.0.0.1:5000/search"
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [URLQueryItem(name: "q", value: query)]
        
        let url = urlComponents.url!
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [String].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

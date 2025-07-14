//
//  MainSearchInteractor.swift
//  Searching
//
//  Created by Rivaldo Fernandes on 14/07/25.
//

import Foundation
import Combine

/// The Interactor in the VIPER architecture.
/// Handles the business logic: networking and data fetching.
/// Here, it performs an HTTP GET request to a Flask backend to search news.
class MainSearchInteractor {

    /// Searches news by sending a query to the backend.
    ///
    /// - Parameter query: The search keyword entered by the user.
    /// - Returns: A Combine publisher that emits an array of matching strings or an error.
    func searchNews(query: String) -> AnyPublisher<[String], Error> {
        // If the query is empty, return an empty array immediately.
        guard !query.isEmpty else {
            return Just([]) // Emit an empty list.
                .setFailureType(to: Error.self) // Match the required failure type.
                .eraseToAnyPublisher()
        }

        // Build the URL for the local Flask server.
        let baseURL = "http://127.0.0.1:5000/search"
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [URLQueryItem(name: "q", value: query)]

        // Safely unwrap the final URL.
        let url = urlComponents.url!

        // Perform the network request.
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data) // Extract only the data.
            .decode(type: [String].self, decoder: JSONDecoder()) // Decode JSON array of Strings.
            .eraseToAnyPublisher() // Type erase to match AnyPublisher.
    }
}

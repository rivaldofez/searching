//
//  MainSearchPresenter.swift
//  Searching
//
//  Created by Rivaldo Fernandes on 14/07/25.
//

import UIKit
import Combine

/// The Presenter in the VIPER module for searching.
/// Receives input from the View, requests data from the Interactor,
/// and passes formatted results back to the View.
class MainSearchPresenter {

    /// Reference to the View (usually via protocol).
    /// The Presenter updates the View with results.
    weak var view: MainSearchViewController?

    /// The Interactor handles business logic like API calls.
    var interactor: MainSearchInteractor?

    /// The Router handles navigation. Not used here but wired for future expansion.
    var router: MainSearchRouter?

    /// Combine subscriptions to manage memory for async streams.
    private var subscriptions = Set<AnyCancellable>()

    /// Called by the View when the search query changes.
    ///
    /// - Parameter query: The current text input from the user.
    func didUpdateSearchQuery(_ query: String) {
        // If the query is empty, clear the results in the View.
        guard !query.isEmpty else {
            view?.showResults([])
            return
        }

        // Ask the Interactor to perform the search.
        interactor?.searchNews(query: query)
            .receive(on: RunLoop.main) // Make sure updates happen on the main thread.
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        // If the Interactor reports an error, show it.
                        self?.view?.showResults(["Error: \(error.localizedDescription)"])
                    }
                },
                receiveValue: { [weak self] results in
                    // On success, update the View with search results.
                    self?.view?.showResults(results)
                }
            )
            .store(in: &subscriptions)
    }
}

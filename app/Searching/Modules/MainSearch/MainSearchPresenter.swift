//
//  MainSearchPresenter.swift
//  Searching
//
//  Created by Rivaldo Fernandes on 14/07/25.
//

import UIKit
import Combine

class MainSearchPresenter {
    weak var view: MainSearchViewController?
    var interactor: MainSearchInteractor?
    var router: MainSearchRouter?
    
    private var subscriptions = Set<AnyCancellable>()
    
    func didUpdateSearchQuery(_ query: String) {
        guard !query.isEmpty else {
            view?.showResults([])
            return
        }
        
        interactor?.searchNews(query: query)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.view?.showResults(["Error: \(error.localizedDescription)"])
                }
            }, receiveValue: { [weak self] results in
                self?.view?.showResults(results)
            })
            .store(in: &subscriptions)
    }
    
}

//
//  MainSearchRouter.swift
//  Searching
//
//  Created by Rivaldo Fernandes on 14/07/25.
//

import UIKit

/// `MainSearchRouter` handles navigation and wiring for search module
///
/// This router is responsible for creating and connecting the View, Presenter, and Interactor
/// to set up the module according to the VIPER architecture.
///
/// Example usage:
/// ```swift
/// let router = MainSearchRouter.start()
/// let initialViewController = router.entryPoint
/// ```
///
/// - Note: The `entryPoint` holds a reference to the configured `MainSearchViewController`.
class MainSearchRouter {
    var entryPoint: MainSearchViewController?
    
    static func start() -> MainSearchRouter {
        let view = MainSearchViewController()
        let interactor = MainSearchInteractor()
        let presenter = MainSearchPresenter()
        let router = MainSearchRouter()

        presenter.interactor = interactor
        presenter.view = view
        presenter.router = router
        view.presenter = presenter
        router.entryPoint = view

        return router
    }
}

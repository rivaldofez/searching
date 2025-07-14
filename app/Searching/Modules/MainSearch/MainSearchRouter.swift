//
//  MainSearchRouter.swift
//  Searching
//
//  Created by Rivaldo Fernandes on 14/07/25.
//

import UIKit

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

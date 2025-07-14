//
//  ViewController.swift
//  Searching
//
//  Created by Rivaldo Fernandes on 14/07/25.
//

import UIKit
import Combine

class MainSearchViewController: UIViewController {

    var presenter: MainSearchPresenter?

    private let textField = UITextField()
    private let tableView = UITableView()
    lazy var stack = UIStackView(arrangedSubviews: [textField, tableView])
    
    private var results: [String] = []
    private var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "Search"
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        setupTextField()
        setupTableView()
        setupConstraints()
    }
    
    
    private func setupTextField() {
        textField.placeholder = "Insert query to start search..."
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.textColor = .label
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap { ($0.object as? UITextField)?.text }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.presenter?.didUpdateSearchQuery(query)
            }
            .store(in: &subscriptions)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupConstraints() {
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    func showResults(_ results: [String]) {
        self.results = results
        tableView.reloadData()
    }
}

extension MainSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

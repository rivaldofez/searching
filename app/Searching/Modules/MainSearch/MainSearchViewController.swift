//
//  ViewController.swift
//  Searching
//
//  Created by Rivaldo Fernandes on 14/07/25.
//

import UIKit
import Combine

/// The View in the VIPER module.
/// Displays the UI: search text field and results table view.
/// Sends user input to the Presenter and displays results received.
class MainSearchViewController: UIViewController {

    /// Reference to the Presenter that handles logic and data flow.
    var presenter: MainSearchPresenter?

    /// Text field for user to type search queries.
    private let textField = UITextField()

    /// Table view to display search results.
    private let tableView = UITableView()

    /// Vertical stack view to layout the text field and table.
    lazy var stack = UIStackView(arrangedSubviews: [textField, tableView])
    
    /// Data source for the table view — holds search results.
    private var results: [String] = []

    /// Combine subscriptions for observing text field changes.
    private var subscriptions = Set<AnyCancellable>()

    /// Called when the view has loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }

    /// Setup the entire view hierarchy and styling.
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

    /// Configure the search text field.
    /// Adds a Combine publisher for text changes with debounce.
    private func setupTextField() {
        textField.placeholder = "Insert query to start search..."
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemBackground
        textField.textColor = .label
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Observe text changes and send updates to Presenter with debounce 500 milisecond to reduce requests.
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .compactMap { ($0.object as? UITextField)?.text }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.presenter?.didUpdateSearchQuery(query)
            }
            .store(in: &subscriptions)
    }

    /// Configure the table view to display results.
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        tableView.showsVerticalScrollIndicator = false
    }

    /// Setup Auto Layout constraints for the stack view.
    private func setupConstraints() {
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }

    /// Called by the Presenter when new results are ready.
    /// Updates the data source and reloads the table view.
    ///
    /// - Parameter results: An array of search result strings.
    func showResults(_ results: [String]) {
        self.results = results
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MainSearchViewController: UITableViewDataSource, UITableViewDelegate {

    /// Number of rows equals the number of search results.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    /// Configure each cell with the result text.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

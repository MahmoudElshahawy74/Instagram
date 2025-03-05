//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 04/03/2025.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {
    private let viewModel: ProfileViewModel
    private var cancellables = Set<AnyCancellable>()

    private let activityIndicator: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        loader.color = .gray
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
        private let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Profile"
            label.font = UIFont.boldSystemFont(ofSize: 30)
            label.textAlignment = .left
            return label
        }()

        private let nameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 22)
            label.textAlignment = .left
            return label
        }()

        private let addressLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .left
            label.textColor = .black
            label.numberOfLines = 2
            return label
        }()

        private let albumsLabel: UILabel = {
            let label = UILabel()
            label.text = "My Albums"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            label.textAlignment = .left
            return label
        }()
    
        private let tableView: UITableView = {
            let tableView = UITableView()
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumCell")
            tableView.rowHeight = 50
            tableView.separatorStyle = .singleLine
            tableView.separatorColor = .lightGray
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            return tableView
     }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchUserData()
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, nameLabel, addressLabel, albumsLabel, tableView])
              stackView.axis = .vertical
              stackView.spacing = 15
              stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        view.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    private func setupBindings() {
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let user = user else { return }
                self?.nameLabel.text = user.name
                self?.addressLabel.text = "\(user.address.street), \(user.address.suite), \(user.address.city), \(user.address.zipcode)"
            }
            .store(in: &cancellables)

        viewModel.$albums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] albums in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
         viewModel.$isLoading
             .receive(on: DispatchQueue.main)
             .sink { [weak self] isLoading in
                 if isLoading {
                     self?.activityIndicator.startAnimating()
                 } else {
                     self?.activityIndicator.stopAnimating()
                 }
             }
             .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let errorMessage = errorMessage {
                    self?.showErrorAlert(message: errorMessage)
                }
            }
            .store(in: &cancellables)

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.fetchUserData()
        }
        alert.addAction(retryAction)

        present(alert, animated: true, completion: nil)
    }
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)
             cell.textLabel?.text = viewModel.albums[indexPath.row].title
             cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
             cell.textLabel?.textAlignment = .left
             cell.selectionStyle = .none
             return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = viewModel.albums[indexPath.row]
        AppRouter.shared.navigateToAlbumDetails(from: self, albumId: album.id, albumTitle: album.title)
    }
}

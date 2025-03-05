//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 04/03/2025.
//

import Combine
import Foundation

class ProfileViewModel {
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()

    @Published var user: User?
    @Published var albums: [Album] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false 

    func fetchUserData() {
        isLoading = true
        networkManager.fetchUsers()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Something went wrong \n Please try again later! \n \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] users in
                if let randomUser = users.randomElement() {
                    self?.user = randomUser
                    self?.fetchAlbums(for: randomUser.id)
                }
            })
            .store(in: &cancellables)
    }

    func fetchAlbums(for userId: Int) {
        isLoading = true
        networkManager.fetchAlbums(userId: userId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = "Failed to load albums: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] albums in
                self?.albums = albums
            })
            .store(in: &cancellables)
    }
}

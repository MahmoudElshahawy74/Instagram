//
//  AlbumDetailsViewModel.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 04/03/2025.
//

import Foundation
import Combine

class AlbumDetailsViewModel {
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    private let albumId: Int
    let albumTitle: String
    
    @Published var isLoading: Bool = false

    @Published var photos: [Photo] = []
    @Published var filteredItems: [Photo] = []
    @Published var searchQuery: String = ""

    var filteredPhotos: AnyPublisher<[Photo], Never> {
        return Publishers.CombineLatest($photos, $searchQuery)
            .map { photos, query in
                guard !query.isEmpty else { return photos }
                self.filteredItems = photos.filter { $0.title.lowercased().contains(query.lowercased())}
                print(self.filteredItems.count)
                return photos.filter { $0.title.lowercased().contains(query.lowercased()) }
            }
            .eraseToAnyPublisher()
    }

    func fetchPhotos() {
        isLoading = true
        networkManager.fetchPhotos(albumId: albumId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("🚨 Failed to fetch photos: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] photos in
                self?.photos = photos
            })
            .store(in: &cancellables)
    }
    
    init(albumId: Int, albumTitle: String) {
        self.albumId = albumId
        self.albumTitle = albumTitle
    }
}

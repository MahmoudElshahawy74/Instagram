//
//  NetworkManager.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 04/03/2025.
//

import Moya
import Combine

class NetworkManager {
    static let shared = NetworkManager()
    private let provider = MoyaProvider<InstagramAPI>()

    private init() {}

    func fetchUsers() -> AnyPublisher<[User], Error> {
        return provider.requestPublisher(.getUsers)
            .map([User].self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func fetchAlbums(userId: Int) -> AnyPublisher<[Album], Error> {
        return provider.requestPublisher(.getAlbums(userId: userId))
            .map([Album].self)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    func fetchPhotos(albumId: Int) -> AnyPublisher<[Photo], Error> {
        return provider.requestPublisher(.getPhotos(albumId: albumId))
            .map([Photo].self)
            .mapError { $0 as Error } 
            .eraseToAnyPublisher()
    }
}

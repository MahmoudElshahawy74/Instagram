//
//  InstagramAPI.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 04/03/2025.
//

import Moya
import CombineMoya
import Foundation

enum InstagramAPI {
    case getUsers
    case getAlbums(userId: Int)
    case getPhotos(albumId: Int)
}

extension InstagramAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com") else {
            print("Error: Invalid base URL, returning a fallback URL.")
            return URL(fileURLWithPath: "")
        }
        return url
    }

    var path: String {
        switch self {
        case .getUsers: return "/users"
        case .getAlbums: return "/albums"
        case .getPhotos: return "/photos"
        }
    }

    var method: Moya.Method { return .get }

    var task: Task {
        switch self {
        case .getUsers:
            return .requestPlain
        case .getAlbums(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.default)
        case .getPhotos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? { return ["Content-Type": "application/json"] }
}

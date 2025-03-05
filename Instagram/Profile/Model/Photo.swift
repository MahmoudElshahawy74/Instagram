//
//  Photo.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 05/03/2025.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let albumID, id: Int
    let title: String
    let url, thumbnailURL: String

    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
}

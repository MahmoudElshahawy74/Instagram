//
//  Albums.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 03/03/2025.
//


import Foundation

// MARK: - Album
struct Album: Codable {
    let userID, id: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
}

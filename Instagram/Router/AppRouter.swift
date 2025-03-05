//
//  AppRouter.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 04/03/2025.
//

import UIKit

class AppRouter {
    static let shared = AppRouter()

     private init() {}

    func navigateToAlbumDetails(from viewController: UIViewController, albumId: Int, albumTitle: String) {
        let albumDetailsViewModel = AlbumDetailsViewModel(albumId: albumId, albumTitle: albumTitle)
        let albumDetailsVC = AlbumDetailsViewController(viewModel: albumDetailsViewModel)
        viewController.navigationController?.pushViewController(albumDetailsVC, animated: true)
    }
}





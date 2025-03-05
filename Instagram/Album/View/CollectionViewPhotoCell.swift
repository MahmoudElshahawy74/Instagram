//
//  CollectionViewPhotoCell.swift
//  Instagram
//
//  Created by Mahmoud Elshahawy on 04/03/2025.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    func configure(with photo: Photo) {
        let photoURL = URL(string: photo.url)
        imageView.sd_setImage(with: photoURL) { _, error, _, _ in
            if error != nil {
                self.imageView.image = UIImage(named: "fall-back-photo")
            }
        }
    }
}

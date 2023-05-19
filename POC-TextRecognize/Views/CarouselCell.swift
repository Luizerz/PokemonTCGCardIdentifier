//
//  CollectionViewCell.swift
//  POC-TextRecognize
//
//  Created by Luiz Sena on 17/05/23.
//

import UIKit
import SDWebImage

class CarouselCell: UICollectionViewCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        imageView.image = nil
    }

    func setCardImage(_ url: String) {
        let unwrappedURL = URL(string: url)!
        imageView.sd_setImage(with: unwrappedURL)
    }
}



//
//  ViewModel.swift
//  NewsApi
//
//  Created by Максим Герасимов on 17.11.2024.
//

import UIKit
import SnapKit
import SDWebImage

class NewsCell: UITableViewCell {
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
      
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.layer.cornerRadius = 8
        contentView.addSubview(thumbnailImageView)

       
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)

      
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
        contentView.addSubview(dateLabel)

       
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(2)
            make.bottom.equalToSuperview().offset(-2)
            make.size.equalTo(100)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }

    func configure(with article: Article) {
        titleLabel.text = article.title
        dateLabel.text = article.publishedAt
        if let urlToImage = article.urlToImage, let imageURL = URL(string: urlToImage) {
            thumbnailImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "photo"))
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
        }
    }
}

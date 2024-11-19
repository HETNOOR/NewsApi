//
//  NewsDetailViewController.swift
//  NewsApi
//
//  Created by Максим Герасимов on 13.11.2024.
//

import UIKit
import SnapKit
import SDWebImage

class NewsDetailViewController: UIViewController {
    private let article: Article
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let dateLabel = UILabel()
    private let contentLabel = UILabel()

    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayArticle()
    }

    private func setupUI() {
        view.backgroundColor = .white

        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        view.addSubview(titleLabel)

        authorLabel.font = UIFont.italicSystemFont(ofSize: 18)
        authorLabel.textColor = .gray
        view.addSubview(authorLabel)

        dateLabel.font = UIFont.systemFont(ofSize: 16)
        dateLabel.textColor = .gray
        view.addSubview(dateLabel)

        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.numberOfLines = 0
        view.addSubview(contentLabel)

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalTo(200)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    private func displayArticle() {
        titleLabel.text = article.title
        authorLabel.text = "By \(article.author ?? "Unknown")"
        dateLabel.text = article.publishedAt
        contentLabel.text = article.content ?? "No content available"
        
        if let urlToImage = article.urlToImage, let imageURL = URL(string: urlToImage) {
            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "photo"))
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}

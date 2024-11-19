//
//  Models.swift
//  NewsApi
//
//  Created by Максим Герасимов on 13.11.2024.
//

import Foundation

struct Article: Codable {
    let author: String?
    let title: String
    let description: String?
    let url: String
    let publishedAt: String
    let content: String?
    let urlToImage: String?
}

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int?
    let articles: [Article]
}

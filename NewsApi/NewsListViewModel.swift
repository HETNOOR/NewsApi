//
//  NewsListViewModel.swift
//  NewsApi
//
//  Created by Максим Герасимов on 13.11.2024.
//

// NewsListViewModel.swift
import Foundation
import Combine

class NewsListViewModel {
    @Published var articles: [Article] = []
    @Published var searchText: String = ""
    @Published var sortOption: SortOption = .publishedAt
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var page = 1
    private let pageSize = 20
    private let apiKey = "5fa57af605354dc98f379542bbb96d68"

    enum SortOption: String {
        case publishedAt
        case popularity
    }

    init() {
        setupBindings()
    }

    private func setupBindings() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main) 
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.resetSearch()
            }
            .store(in: &cancellables)
    }


    func resetSearch() {
        articles = []
        page = 1
        fetchArticles()
    }

    func fetchArticles() {
        guard !isLoading, !searchText.isEmpty else { return }
        isLoading = true

        let urlString = "https://newsapi.org/v2/everything?q=\(searchText)&pageSize=\(pageSize)&page=\(page)&sortBy=\(sortOption.rawValue)&apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: NewsResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching articles: \(error)")
                }
            }, receiveValue: { [weak self] response in
                self?.articles += response.articles
                self?.page += 1
            })
            .store(in: &cancellables)
    }
}

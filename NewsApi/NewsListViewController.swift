//
//  ViewController.swift
//  NewsApi
//
//  Created by Максим Герасимов on 13.11.2024.
//

import UIKit
import Combine
import SnapKit

class NewsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    private let viewModel = NewsListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private let sortControl = UISegmentedControl(items: ["Date", "Popularity"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchArticles()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "News"

      
        searchBar.placeholder = "Search news..."
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
       
        sortControl.selectedSegmentIndex = 0
        sortControl.addTarget(self, action: #selector(sortChanged), for: .valueChanged)
        view.addSubview(sortControl)
        
        sortControl.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
       
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(sortControl.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func sortChanged() {
        viewModel.sortOption = sortControl.selectedSegmentIndex == 0 ? .publishedAt : .popularity
        viewModel.fetchArticles()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        let article = viewModel.articles[indexPath.row]
        cell.configure(with: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.row]
        let detailVC = NewsDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height * 1.5 {
            viewModel.fetchArticles()
        }
    }
}


//
//  ViewController.swift
//  Clowder iOS Test
//
//  Created by Oraz Atakishiyev on 1/9/19.
//  Copyright © 2019 Oraz Atakishiyev. All rights reserved.
//

import UIKit

class RssFeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    var viewModel: RssFeedViewModel = RssFeedViewModel()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        bindViewModel()
    }
    
    private func config() {
        hide()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshRssData(_:)), for: .valueChanged)
        viewModel.getRss()
    }
    
    func bindViewModel() {
        viewModel.didStartLoading = { [weak self] in
            self?.hide()
            self?.refreshControl.beginRefreshing()
        }
        
        viewModel.didFinishLoading = { [weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
            if self!.viewModel.feed.count <= 0 {
                self?.show(text: "No data")
            }
        }
        
        viewModel.didFinishWithError = { [weak self] error in
            self?.show(text: error.localizedDescription)
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
         viewModel.getRss()
    }
    
    @objc private func refreshRssData(_ sender: Any) {
        viewModel.getRss()
    }
    
    func show(text: String) {
        headerView.frame.size.height = 100
        headerView.isHidden = false
        errorLabel.text = text
    }
    
    func hide() {
        headerView.frame.size.height = 0
        headerView.isHidden = true
    }
}

extension RssFeedVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.feed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.nibName, for: indexPath) as! FeedTableViewCell
        cell.titleLab.text = viewModel.feed[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let webView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WebViewController") as? WebViewController {
            webView.rssItem = viewModel.feed[indexPath.row]
            self.navigationController?.pushViewController(webView, animated: true)
        }
    }
}


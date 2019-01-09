//
//  RssFeedViewModel.swift
//  Clowder iOS Test
//
//  Created by Oraz Atakishiyev on 1/9/19.
//  Copyright © 2019 Oraz Atakishiyev. All rights reserved.
//

import Foundation
import AlamofireRSSParser

final class RssFeedViewModel {
    var didStartLoading: () -> Void = { }
    var didFinishLoading: () -> Void = { }
    var didFinishWithError: (Error) -> Void = { _ in }
    
    let apiClient: APIClient
    var feed = [RSSItem]()
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getRss() {
        didStartLoading()
        apiClient.loadRss(completion: { [weak self] result in
            switch result {
            case .success(let feed):
                self?.feed = feed.items
                self?.didFinishLoading()
            case .failure(let error):
                self?.didFinishWithError(error)
            }
        })
    }
}

//
//  APIClient.swift
//  Clowder iOS Test
//
//  Created by Oraz Atakishiyev on 1/9/19.
//  Copyright © 2019 Oraz Atakishiyev. All rights reserved.
//

import Alamofire
import AlamofireRSSParser

enum ApiResult<T, U> {
    case success(T)
    case failure(U)
}

class APIClient {
    
    typealias GetRSSResult = ApiResult<RSSFeed, Error>
    typealias GetRSSCompletion = (_ result: GetRSSResult) -> Void
    
    func loadRss(completion:@escaping GetRSSCompletion) {
        Alamofire.request(APIRouter.loadRss()).responseRSS() { (response) -> Void in
            switch response.result {
            case .success:
                if let feed: RSSFeed = response.result.value {
                    completion(.success(feed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

//
//  APIRouter.swift
//  Clowder iOS Test
//
//  Created by Oraz Atakishiyev on 1/9/19.
//  Copyright © 2019 Oraz Atakishiyev. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case loadRss()
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .loadRss:
            return .get
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .loadRss():
            return "/feed/rss"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .loadRss(_):
            return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        switch self {
            case .loadRss(): break
        }
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}

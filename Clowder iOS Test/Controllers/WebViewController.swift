//
//  WebViewController.swift
//  Clowder iOS Test
//
//  Created by Oraz Atakishiyev on 1/9/19.
//  Copyright © 2019 Oraz Atakishiyev. All rights reserved.
//

import UIKit
import WebKit
import AlamofireRSSParser

class WebViewController: UIViewController {
    
    var progressView: UIProgressView!
    var webView: WKWebView!
    var errorView: UIView!
    
    var rssItem: RSSItem!
    
    private func setupWebView() {
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: self.view.bounds, configuration: config)
        self.progressView = UIProgressView(progressViewStyle: UIProgressView.Style.bar)
        self.progressView.translatesAutoresizingMaskIntoConstraints = false
        self.progressView.progressTintColor = UIColor.blue
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.view.addSubview(self.webView)
        
        let height = NSLayoutConstraint(item: webView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)
        
        let width = NSLayoutConstraint(item: webView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)
        
        let top = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraints([top, height, width, bottom])
        
        if let navigationVC = self.navigationController {
            
            // create progress bar with .bar style and add it as subview
            navigationVC.navigationBar.addSubview(progressView)
            
            let bottomConstraint = NSLayoutConstraint(item: navigationVC.navigationBar, attribute: .bottom, relatedBy: .equal, toItem: progressView, attribute: .bottom, multiplier: 1, constant: 1)
            let leftConstraint = NSLayoutConstraint(item: navigationVC.navigationBar, attribute: .leading, relatedBy: .equal, toItem: progressView, attribute: .leading, multiplier: 1, constant: 0)
            let rightConstraint = NSLayoutConstraint(item: navigationVC.navigationBar, attribute: .trailing, relatedBy: .equal, toItem: progressView, attribute: .trailing, multiplier: 1, constant: 0)
            
            // add constraints
            navigationVC.view.addConstraints([bottomConstraint, leftConstraint, rightConstraint])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupWebView()
        if let link = rssItem.link {
            self.title = rssItem.title
            if let url = URL(string: link) {
                let request = URLRequest(url: url)
                self.webView.load(request)
            }
        }
    }
    
    deinit {
        progressView.removeFromSuperview()
        webView.scrollView.delegate = nil
        webView.stopLoading()
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "loading")
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            
        }
        if (keyPath == "estimatedProgress") {
            if progressView != nil {
                progressView.isHidden = webView.estimatedProgress == 1
                progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if progressView != nil {
            progressView.setProgress(0.0, animated: false)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let alert = UIAlertController(title: "Error", message:error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

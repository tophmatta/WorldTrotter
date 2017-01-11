//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Toph Matta on 12/26/16.
//  Copyright © 2016 Toph Matta. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        webView = WKWebView()
        
        view = webView
        
        loadPage()
        
    }
    
    func loadPage(){
        
        let url = URL(string: "https://www.bignerdranch.com")
        
        let request = URLRequest(url: url!)
        
        webView.load(request)
        
    }
    
}

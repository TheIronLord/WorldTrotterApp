//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Sajjad Patel on 2018-02-12.
//  Copyright © 2018 Sajjad Patel. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate{
    var webView: WKWebView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    override func loadView(){
        super.loadView()
        
        //Configure webView
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.uiDelegate = self
        view = webView
    }
}

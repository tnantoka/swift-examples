//
//  SignInViewController.swift
//  GitHubLoginFromScratch
//
//  Created by Tatsuya Tobioka on 11/12/15.
//  Copyright © 2015 Tatsuya Tobioka. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UIWebViewDelegate {

    let clientId = "YOUR_CLIENT_ID"
    let clientSecret = "YOUR_CLIENT_SECRET"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let webview = view as? UIWebView {
            webview.delegate = self
            let urlString = "https://github.com/login/oauth/authorize?client_id=\(clientId)"
            if let url = NSURL(string: urlString) {
                let req = NSURLRequest(URL: url)
                webview.loadRequest(req)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if let url = request.URL where url.host == "example.com" {
            if let code = url.query?.componentsSeparatedByString("code=").last {
                let urlString = "https://github.com/login/oauth/access_token"
                if let tokenUrl = NSURL(string: urlString) {
                    let req = NSMutableURLRequest(URL: tokenUrl)
                    req.HTTPMethod = "POST"
                    req.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    req.addValue("application/json", forHTTPHeaderField: "Accept")
                    let params = [
                        "client_id" : clientId,
                        "client_secret" : clientSecret,
                        "code" : code
                    ]
                    req.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
                    let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { data, response, error in
                        if let data = data {
                            do {
                                if let content = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                                    if let accessToken = content["access_token"] as? String {
                                        self.getUser(accessToken)
                                    }
                                }
                            } catch {}
                        }
                    }
                    task.resume()
                }
            }
            return false
        }
        return true
    }
    
    func getUser(accessToken: String) {
        let urlString = "https://api.github.com/user"
        if let url = NSURL(string: urlString) {
            let req = NSMutableURLRequest(URL: url)
            req.addValue("application/json", forHTTPHeaderField: "Accept")
            req.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
            let task = NSURLSession.sharedSession().dataTaskWithRequest(req) { data, response, error in
                if let data = data {
                    if let content = String(data: data, encoding: NSUTF8StringEncoding) {
                        dispatch_async(dispatch_get_main_queue()) {
                            print(content)
                            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

//
//  ViewController.swift
//  SafariViewControllerExample
//
//  Created by Tatsuya Tobioka on 11/16/15.
//  Copyright © 2015 Tatsuya Tobioka. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createSafariController() -> SFSafariViewController {
        return SFSafariViewController(URL: NSURL(string: "https://www.apple.com/")!)
    }
    
    @IBAction func push(sender: AnyObject) {
        navigationController?.pushViewController(createSafariController(), animated: true)
    }

    @IBAction func present(sender: AnyObject) {
        let safariController = createSafariController()
        safariController.delegate = self
        presentViewController(safariController, animated: true, completion: nil)
    }
    
    @IBAction func showWithRightButtonItem(sender: AnyObject) {
        let safariController = createSafariController()
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "barButtonItemDidTap:")
        safariController.navigationItem.rightBarButtonItem = barButtonItem
        
        navigationController?.pushViewController(safariController, animated: true)
    }
    
    func barButtonItemDidTap(sender: AnyObject) {
        print("tapped")
    }
    
    // MARK: - SFSafariViewControllerDelegate

    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}


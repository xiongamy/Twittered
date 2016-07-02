//
//  LoginViewController.swift
//  Twitter
//
//  Created by Amy Xiong on 6/27/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var birdImageView: UIImageView!
    @IBOutlet weak var birdBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        birdBackgroundView.layer.cornerRadius = birdBackgroundView.frame.height / 2
        birdBackgroundView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        
        client.login({ () in
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }, failure: { (error: NSError) in
            print("error: \(error.localizedDescription)")
        })
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("seguing from login!")
        let vc = segue.destinationViewController
        print(vc.title)
    }
}

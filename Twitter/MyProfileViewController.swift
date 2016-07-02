//
//  MyProfileViewController.swift
//  Twitter
//
//  Created by Amy Xiong on 7/1/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit

class MyProfileViewController: ProfileViewController {
    
    func viewWillLoad() {
        TwitterClient.sharedInstance.currentAccount({ (user: User) in
            self.user = user
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
    }
}
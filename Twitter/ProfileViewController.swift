//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Amy Xiong on 7/1/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var backgroundPicView: UIImageView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var tweetsCountLabels: UILabel!
    @IBOutlet weak var followersCountLabels: UILabel!
    @IBOutlet weak var followingCountLabels: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePicView.layer.cornerRadius = 10
        profilePicView.clipsToBounds = true
        profilePicView.layer.borderColor = UIColor.whiteColor().CGColor
        profilePicView.layer.borderWidth = 3
        
        layout()
        
        if user == nil {
            TwitterClient.sharedInstance.currentAccount({ (user: User) in
                self.user = user
                self.layout()
                
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })

        }
    }
    
    func layout() {
        if let user = user {
            usernameLabel.text = user.name
            screennameLabel.text = "@" + user.screenname!
            taglineLabel.text = user.tagline
            
            tweetsCountLabels.text = User.formatCount(user.tweetsCount)
            followersCountLabels.text = User.formatCount(user.followersCount)
            followingCountLabels.text = User.formatCount(user.followingCount)
            
            if let url = user.profilePicFullSizeURL {
                profilePicView.setImageWithURL(url)
            }
            
            user.getBannerURL({ (url) in
                self.backgroundPicView.setImageWithURL(url)
                }, failure: { (error: NSError) in
                    print(error.localizedDescription)
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

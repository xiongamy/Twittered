//
//  TweetCell.swift
//  Twitter
//
//  Created by Amy Xiong on 6/28/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    

    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likesCountLabel: UILabel!
    @IBOutlet weak var retweetedUserLabel: UILabel!
    @IBOutlet weak var retweetImageView: UIImageView!
    
    @IBOutlet weak var retweetHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userHeightConstraint: NSLayoutConstraint!
    
    var retweetOrigHeight: CGFloat?
    var userOrigHeight: CGFloat?
    
    var tweet: Tweet? {
        didSet {
            var displayTweet = tweet
            
            if tweet!.retweetedStatus && tweet!.retweetedTweet != nil {
                displayTweet = tweet?.retweetedTweet
                
                retweetImageView.tintColor = self.backgroundColor
                retweetedUserLabel.text = (tweet!.user?.name)! + " Retweeted"
                
                if let userHeight = userOrigHeight {
                    userHeightConstraint.constant = userHeight
                }
                if let retweetHeight = retweetOrigHeight {
                    retweetHeightConstraint.constant = retweetHeight
                }
                
            } else {
                retweetOrigHeight = retweetHeightConstraint.constant
                userOrigHeight = userHeightConstraint.constant
                retweetHeightConstraint.constant = 0
                userHeightConstraint.constant = 0
            }
            
            tweetTextLabel.text = displayTweet!.text
            usernameLabel.text = displayTweet!.user?.name
            screennameLabel.text = "@" + (displayTweet!.user?.screenname)!
            retweetCountLabel.text = Tweet.formatCount(displayTweet!.retweets)
            likesCountLabel.text = Tweet.formatCount(displayTweet!.likes)
            
            self.timestampLabel!.text = displayTweet!.timestampRelative
            
            if let url = displayTweet!.user?.profilePicURL {
                profilePicView.setImageWithURL(url)
            } else {
                print("no image")
            }
        }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilePicView.layer.cornerRadius = 5
        profilePicView.clipsToBounds = true
        
        retweetImageView.layer.cornerRadius = 5
        retweetImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didPushRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet!, success: { (tweet: Tweet) in
            self.retweetCountLabel.text = String(Int(self.retweetCountLabel.text!)! + 1)
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }
    
    @IBAction func didPushLike(sender: AnyObject) {
        TwitterClient.sharedInstance.like(tweet!, success: { (tweet: Tweet) in
            self.likesCountLabel.text = String(Int(self.likesCountLabel.text!)! + 1)
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
    }

    
    
    
    
}
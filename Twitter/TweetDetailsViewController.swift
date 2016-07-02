//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Amy Xiong on 6/30/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet var retweetsCountLabels: [UILabel]!
    @IBOutlet var likesCountLabels: [UILabel]!
    @IBOutlet weak var timestampLabel: UILabel!

    var tweet: Tweet?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if var displayTweet = tweet {
            if displayTweet.retweetedStatus && displayTweet.retweetedTweet != nil {
                displayTweet = displayTweet.retweetedTweet!
            }
            
            textLabel.text = displayTweet.text
            usernameLabel.text = displayTweet.user?.name
            screennameLabel.text = "@" + (displayTweet.user?.screenname)!
            for label in retweetsCountLabels {
                label.text = Tweet.formatCount(displayTweet.retweets)
            }
            for label in likesCountLabels {
                label.text = Tweet.formatCount(displayTweet.likes)
            }
            
            self.timestampLabel!.text = displayTweet.timestampLong
            
            if let url = displayTweet.user?.profilePicURL {
                profilePicView.setImageWithURL(url)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPushRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet!, success: { (tweet: Tweet) in
            for label in self.retweetsCountLabels {
                label.text = String(Int(label.text!)! + 1)
            }
            
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
    }
    
    @IBAction func didPushLike(sender: AnyObject) {
        TwitterClient.sharedInstance.like(tweet!, success: { (tweet: Tweet) in
            for label in self.likesCountLabels {
                label.text = String(Int(label.text!)! + 1)
            }
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "profileSegue" {
            let vc = segue.destinationViewController as! ProfileViewController
            
            var user: User?
            if let tweet = tweet {
                if tweet.retweetedStatus && tweet.retweetedTweet != nil {
                    print("have set user to a retweeted user")
                    user = tweet.retweetedTweet?.user
                } else {
                    print("have set user")
                    user = tweet.user
                }
            }
            
            vc.user = user
        }
    }


}

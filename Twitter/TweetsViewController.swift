//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Amy Xiong on 6/27/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tweetsTableView: UITableView!
    @IBOutlet weak var composeButtonView: UIButton!
    
    var tweets: [Tweet]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetsTableView.delegate = self
        tweetsTableView.dataSource = self
        tweetsTableView.estimatedRowHeight = 150
        tweetsTableView.rowHeight = UITableViewAutomaticDimension
        
        composeButtonView.layer.cornerRadius = 10
        composeButtonView.clipsToBounds = true
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getTweets(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tweetsTableView.insertSubview(refreshControl, atIndex: 0)
        
        getTweets(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            print(tweets.count)
            return tweets.count
            
        } else {
            print("no tweets")
            return 0
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapProfile(_:)))
        cell.profilePicView.userInteractionEnabled = true
        cell.profilePicView.addGestureRecognizer(tapRecognizer)
        
        if tweets != nil {
            cell.tweet = tweets[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
    }
    
    func getTweets(refreshControl: UIRefreshControl?) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            
            //print("tweets")
            self.tweetsTableView.reloadData()
            
            if let refreshControl = refreshControl {
                refreshControl.endRefreshing()
            }
            
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
    }

    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    func onTapProfile(sender: AnyObject) {
        performSegueWithIdentifier("profileSegue", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tweetsTableView.indexPathForCell(cell)
            let vc = segue.destinationViewController as! TweetDetailsViewController
            
            if tweets != nil {
                vc.tweet = tweets[indexPath!.row]
            }
        } else if segue.identifier == "profileSegue" {
            let vc = segue.destinationViewController as! ProfileViewController
            
            let tapRecognizer = sender as! UITapGestureRecognizer
            let tapLocation = tapRecognizer.locationInView(self.tweetsTableView)
            
            if let tappedIndexPath = self.tweetsTableView.indexPathForRowAtPoint(tapLocation) {
                if self.tweets != nil {
                    let tweet = self.tweets![tappedIndexPath.row]
                    var user = tweet.user
                    
                    if tweet.retweetedStatus && tweet.retweetedTweet != nil {
                        user = tweet.retweetedTweet!.user
                    }
                    vc.user = user
                }
            }
        }
    
    }
}

//
//  TwitterClient.swift
//  Twitter
//
//  Created by Amy Xiong on 6/27/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "C61rJI1FeCjDo7LRkltTorThL", consumerSecret: "knMrR1GEoq0qLWxisynCsaDEwsCbpqcKJOCMw9WNawS1WAqiS3")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twittered://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
        }, failure: { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.LogoutNotification, object: nil)
    }
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                
                self.loginSuccess?()
            }, failure: { (error: NSError) in
                self.loginFailure?(error)
            })
            
            }, failure: { (error: NSError!) in
                
                self.loginFailure?(error)
        })
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
    
        GET("1.1/statuses/home_timeline.json?count=20", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionary = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionary)
            
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    func accountDictionaryById(id: String, success: (NSDictionary) -> (), failure: (NSError) -> ()) {
        let requestLink = "https://api.twitter.com/1.1/users/show.json?user_id=\(id)"
        
        GET(requestLink, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            success(response as! NSDictionary)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }
    
    /*func userBanner(user: User, success: (NSDictionary) -> (), failure: (NSError) -> ()) {
        var requestLink = "https://api.twitter.com/1.1/users/profile_banner.json"
        requestLink += "?screen_name=\(user.screenname)"
        
        GET(requestLink, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            success(response as! NSDictionary)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
    }*/
    
    
    func retweet(tweet: Tweet, success: (Tweet) -> (), failure: (NSError) -> ()) {
        var requestLink = "https://api.twitter.com/1.1/statuses/retweet/"
        
        if tweet.retweetedStatus {
            requestLink += "\(tweet.retweetedTweet!.id!).json"
        } else {
            requestLink += "\(tweet.id!).json"
        }
        
        POST(requestLink, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            success(Tweet(dictionary: response as! NSDictionary))
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func like(tweet: Tweet, success: (Tweet) -> (), failure: (NSError) -> ()) {
        var requestLink = "https://api.twitter.com/1.1/favorites/create.json"
        
        
        if tweet.retweetedStatus {
            requestLink += "?id=\(tweet.retweetedTweet!.id!)"
        } else {
            requestLink += "?id=\(tweet.id!)"
        }
        
        POST(requestLink, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            success(Tweet(dictionary: response as! NSDictionary))
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    
    func postTweet(text: String, success: (Tweet) -> (), failure: (NSError) -> ()) {
        var requestLink = "https://api.twitter.com/1.1/statuses/update.json"
        
        let URLencodedText = text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        requestLink += "?status=\(URLencodedText!)"
        print(requestLink)
        
        POST(requestLink, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            success(Tweet(dictionary: response as! NSDictionary))
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
        })
        
        
    }

}

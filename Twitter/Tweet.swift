//
//  Tweet.swift
//  Twitter
//
//  Created by Amy Xiong on 6/27/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit
import DateTools

class Tweet: NSObject {
    
    var text: String?
    var timestamp: NSDate?
    var retweets: Int = 0
    var likes: Int = 0
    var user: User?
    var retweetedStatus: Bool = false
    var retweetedTweet: Tweet?
    var id: Int?
    
    var timestampRelative: String? {
        get {
            var timestampString: String = ""
            let currentDate = NSDate()
            
            if timestamp!.daysAgo() < 1 {
                // use relative timestamp
                if timestamp!.hoursAgo() >= 1 {
                    //round hours
                    let hoursSince = round((timestamp?.hoursAgo())!)
                    timestamp = NSDate(timeIntervalSinceNow: -1 * (3600 * hoursSince))
                } else if timestamp!.minutesAgo() >= 1 {
                    //round minutes
                    let minutesSince = round((timestamp?.minutesAgo())!)
                    timestamp = NSDate(timeIntervalSinceNow: -1 * (60 * minutesSince))
                }
                
                // just now
                if timestamp!.secondsAgo() < 5{
                    timestampString = "Just now"
                } else {
                    timestampString = timestamp!.shortTimeAgoSinceNow()
                }
            } else if timestamp!.year() == currentDate.year() {
                // use absolute timestamp without year
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM d"
                timestampString = dateFormatter.stringFromDate(timestamp!)
            } else {
                // use absolute timestamp with year
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "d MMM yyyy"
                timestampString = dateFormatter.stringFromDate(timestamp!)
            }
            
            return timestampString
        }
    }
    
    var timestampLong: String? {
        get {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm a - d MMM yyyy"
            return dateFormatter.stringFromDate(timestamp!)
        }
    }
    
    class func formatCount(count: Int) -> String {
        var countString = ""
        
        let formatter = NSNumberFormatter()
        formatter.minimumSignificantDigits = 0
        formatter.maximumSignificantDigits = 2
        
        if count >= 10000000 { // over 10 million
            let num = Int(round(Double(count) / 100000.0))
            countString = "\(formatter.stringFromNumber(num)!)M"
        } else if count >= 1000000 { // over 1 million
            let num = Double(round(Double(count) / 100000.0)) / 10.0

            countString = "\(formatter.stringFromNumber(num)!)M"
        } else if count >= 10000 { // over 10 thousand
            let num = round(Double(count) / 1000.0)
            countString = "\(formatter.stringFromNumber(num)!)K"
        } else if count >= 1000 { // over 1 thousand
            let num = Double(round(Double(count) / 100.0)) / 10.0
            
            countString = "\(formatter.stringFromNumber(num)!)K"
        } else {
            countString = "\(count)"
        }
        
        return countString
    }
    
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweets = (dictionary["retweet_count"] as? Int) ?? 0
        likes = (dictionary["favorite_count"] as? Int) ?? 0
        id = dictionary["id"] as? Int
        
        let timestampString = dictionary["created_at"] as? String

        if let timestampString = timestampString {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = dateFormatter.dateFromString(timestampString)
        }
        
        if let userDict = dictionary["user"] as? NSDictionary {
            user = User(dictionary: userDict)
        }
        
        if let retweetedDict = dictionary["retweeted_status"] as? NSDictionary {
            retweetedStatus = true
            retweetedTweet = Tweet(dictionary: retweetedDict)
        }
    }
    
    // Creates an array of Tweet objects, given an array of dictionaries
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dict in dictionaries {
            //print(dict)
            let tweet = Tweet(dictionary: dict)
            tweets.append(tweet)
        }
        
        return tweets
    }
}

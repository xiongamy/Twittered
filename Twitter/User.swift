//
//  User.swift
//  Twitter
//
//  Created by Amy Xiong on 6/27/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var id: String?
    var name: String?
    var screenname: String?
    var profilePicURL: NSURL?
    var profilePicFullSizeURL: NSURL? {
        get {
            if let url = profilePicURL {
                let modifiedURL = url.absoluteString.stringByReplacingOccurrencesOfString("_normal", withString: "")
                
                return NSURL(string: modifiedURL)
            } else {
                return nil
            }
        }
    }
    var tagline: String?
    var tweetsCount: Int
    var followersCount: Int
    var followingCount: Int
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        id = dictionary["id_str"] as? String
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        tagline = dictionary["description"] as? String
        followersCount = (dictionary["followers_count"] as? Int) ?? 0
        followingCount = (dictionary["friends_count"] as? Int) ?? 0
        tweetsCount = (dictionary["statuses_count"] as? Int) ?? 0
        
        let profileURLString = dictionary["profile_image_url_https"] as? String
        if let url = profileURLString {
            profilePicURL = NSURL(string: url)
        }
    }
    
    func getBannerURL(success: (url: NSURL) -> (), failure: (NSError) -> ()) {
        TwitterClient.sharedInstance.accountDictionaryById(id!, success: { (dict: NSDictionary) in
            let bannerURLString = dict["profile_banner_url"] as? String
            if var url = bannerURLString {
                url += "/1500x500"
                success(url: NSURL(string: url)!)
            }
            }, failure: { (error: NSError) in
                failure(error)
        })
    }
    
    class func formatCount(count: Int) -> String {
        var countString = ""
        
        let formatter = NSNumberFormatter()
        formatter.minimumSignificantDigits = 0
        formatter.maximumSignificantDigits = 3
        
        if count >= 100000000 { // over 100 million
            let num = Int(round(Double(count) / 1000000.0))
            countString = "\(formatter.stringFromNumber(num)!)M"
        } else if count >= 10000000 { // over 10 million
            let num = round(Double(count) / 100000.0) / 10.0
            countString = "\(formatter.stringFromNumber(num)!)M"
        } else if count >= 1000000 { // over 1 million
            let num = round(Double(count) / 10000.0) / 100.0
            countString = "\(formatter.stringFromNumber(num)!)M"
        } else if count >= 100000 { // over 100 thousand
            let num = Int(round(Double(count) / 1000.0))
            countString = "\(formatter.stringFromNumber(num)!)K"
        } else if count >= 10000 { // over 10 thousand
            let num = round(Double(count) / 100.0) / 10.0
            countString = "\(formatter.stringFromNumber(num)!)K"
        } else {
            let numberFormatter = NSNumberFormatter()
            numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
            countString = numberFormatter.stringFromNumber(count)!
        }
        
        return countString
    }
    
    static let LogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    

}

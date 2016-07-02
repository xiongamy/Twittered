//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Amy Xiong on 6/30/16.
//  Copyright © 2016 Amy Xiong. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var charsLeftLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    
    var currentMessage: String = ""
    
    let maxChars = 140
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tweetTextView.delegate = self
        
        tweetButton.layer.cornerRadius = 5
        
        tweetTextView.layer.borderColor = UIColor.lightGrayColor().CGColor
        tweetTextView.layer.borderWidth = 1
        
        charsLeftLabel.text = String(maxChars)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(textView: UITextView) {
        let message = textView.text
        let chars = message.characters.count
        
        if chars <= maxChars {
            charsLeftLabel.text = String(maxChars - chars)
            currentMessage = message
        } else {
            textView.text = currentMessage
        }
        
        
    }

    @IBAction func didPressCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didPressSubmit(sender: AnyObject) {
        TwitterClient.sharedInstance.postTweet(currentMessage, success: { (tweet: Tweet) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }, failure: { (error: NSError) in
            print(error.localizedDescription)
        })
    }
}

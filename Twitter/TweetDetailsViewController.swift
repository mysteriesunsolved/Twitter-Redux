//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by Sanaya Sanghvi on 2/21/16.
//  Copyright © 2016 Sanaya Sanghvi. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
    
    var tweet: Tweet!
    var tweetID: Int = 0
    

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!
    @IBOutlet var retweetLabel: UILabel!
    @IBOutlet var favouriteLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var favouriteButton: UIButton!
    
    @IBOutlet var retweetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let name = (tweet.user?.name)! as String
        nameLabel.text = name
        
        let username = (tweet.user?.screenname)! as String
        userNameLabel.text = "@\(username)"
        
        let date = tweet.createdAtString
        dateLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
        
        
        tweetTextLabel.text = tweet.text
        tweetTextLabel.sizeToFit()
        
        let retweetCount = tweet.retweetCount!
        retweetLabel.text = String(retweetCount)
        
       favouriteLabel.text = String(tweet.favouriteCount!)
        
        let imageURL = (tweet.user?.profileImageUrl)! as String
        profileImage.setImageWithURL(NSURL(string: imageURL)!)
        
       tweetID = (tweet.tweetID as? Int)!
        
        let profilebackground = tweet.user?.profileBackgroundUrl
        print(profilebackground)
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func calculateTimeStamp(timeTweetPostedAgo: NSTimeInterval) -> String {
        
        var rawTime = Int(timeTweetPostedAgo)
        var time: Int = 0
        var timeChar = ""
        
        rawTime = rawTime * (-1)
        
        if (rawTime <= 60) {
            time = rawTime
            timeChar = "s"
        } else if ((rawTime/60) <= 60) {
            time = rawTime/60
            timeChar = "m"
        } else if (rawTime/60/60 <= 24) {
            time = rawTime/60/60
            timeChar = "h"
        } else if (rawTime/60/60/24 <= 365) {
            time = rawTime/60/60/24
            timeChar = "d"
        } else if (rawTime/(3153600) <= 1) {
            
            time = rawTime/60/60/24/365
            timeChar = "y"
        }
        
        return "\(time)\(timeChar)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toProfile" {
        let profile = segue.destinationViewController as! ProfileViewController
            profile.tweet = tweet
        } else if segue.identifier == "reply" {
            let composetweet = segue.destinationViewController as! ComposeTweetViewController
            let usernamebel = tweet.user!.screenname?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            
            composetweet.tweetText.text = composetweet.tweetText.text.stringByAppendingString(usernamebel!)
        }
    }
    
    @IBAction func onFavourite(sender: AnyObject) {
        
        TwitterClient.sharedInstance.favTweet(Int(tweetID), params: nil, completion: {(error) -> () in
            
            
            self.favouriteLabel.text = String(self.tweet.favouriteCount! + 1)
            self.favouriteButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)
            
            
        })
        
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        
        TwitterClient.sharedInstance.retweet(Int(tweetID), params: nil, completion: {(error) -> () in
            
            self.retweetLabel.text = String(self.tweet!.retweetCount! + 1)
            self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
            
        })
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  TweetCell.swift
//  Twitter
//
//  Created by Sanaya Sanghvi on 2/14/16.
//  Copyright © 2016 Sanaya Sanghvi. All rights reserved.
//

import UIKit


class TweetCell: UITableViewCell {
    
    
    @IBOutlet var profilepictureView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var timestampLabel: UILabel!
    @IBOutlet var tweetTextLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var favouriteButton: UIButton!
    @IBOutlet var favouriteLabel: UILabel!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var retweetLabel: UILabel!
   
    var tweetID: Int = 0
    var tweet: Tweet! {
        
        didSet {
            
            let name = tweet.user?.name
            let username = (tweet.user?.screenname)!
            let tweetText = tweet.text
            let date = tweet.createdAtString
            let imageURL = tweet.user?.profileImageUrl!
        
            nameLabel.text = name
            usernameLabel.text = "@ \(username)"
            tweetTextLabel.text = tweetText
             tweetTextLabel.sizeToFit()
            
            dateLabel.text = calculateTimeStamp(tweet.createdAt!.timeIntervalSinceNow)
           
            profilepictureView.setImageWithURL(NSURL(string: imageURL!)!)
           
            tweetID = (tweet.tweetID as? Int)!
            retweetLabel.text = String(tweet.retweetCount!)
            favouriteLabel.text = String(tweet.favouriteCount!)
            
            retweetButton.setImage(UIImage(named: "retweet-action-on-pressed"), forState: .Highlighted)
            favouriteButton.setImage(UIImage(named: "like-action-on-pressed"), forState: .Highlighted)

            
           
        }
        
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
        
    
        
       
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.retweet(Int(tweetID), params: nil, completion: {(error) -> () in
            
            self.retweetLabel.text = String(self.tweet!.retweetCount! + 1)
            self.retweetButton.setImage(UIImage(named: "retweet-action-on"), forState: .Normal)
           
        })
        
    }
    
    @IBAction func onFavourite(sender: AnyObject) {
        
        TwitterClient.sharedInstance.favTweet(Int(tweetID), params: nil, completion: {(error) -> () in
           
            
                self.favouriteLabel.text = String(self.tweet.favouriteCount! + 1)
                self.favouriteButton.setImage(UIImage(named: "like-action-on"), forState: .Normal)

            
        })
        
    }
    
    


}

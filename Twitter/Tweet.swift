//
//  Tweet.swift
//  Twitter
//
//  Created by Sanaya Sanghvi on 2/13/16.
//  Copyright © 2016 Sanaya Sanghvi. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    
    var tweetID: Int
    var retweetCount: Int?
    var favouriteCount: Int?
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        tweetID = ((dictionary["id"]!) as? Int)!
        retweetCount = dictionary["retweet_count"] as? Int
        favouriteCount = dictionary["favorite_count"] as? Int
        
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    

}

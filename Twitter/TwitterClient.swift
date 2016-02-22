//
//  TwitterClient.swift
//  Twitter
//
//  Created by Sanaya Sanghvi on 2/7/16.
//  Copyright © 2016 Sanaya Sanghvi. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey = "gbr91ssxWdzoDDUEcgAAtikCg"
let twitterConsumerSecret = "A5Rk28scguNt4fVSdW6lip7IYnE7p7le6Oa0U85mqYwuhmb0Zt"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance =  TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey , consumerSecret: twitterConsumerSecret)

        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("home timeline: \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            for tweet in tweets{
                print("text: \(tweet.text), created: \(tweet.createdAt)")
            }
            
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
            print("error getting home timeline: .\(error)")
            completion(tweets: nil, error: error)
                
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token and redirect to authorisation page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("error getting the request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
    }

    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //print("user: \(response)")
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
                    
            })
            
        }) { (error: NSError!) -> Void in
            print("Failed to receieve the acess token")
            self.loginCompletion?(user: nil, error: error)

        }
        
    }
    
    func retweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/statuses/retweet/\(id).json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("RetweetID: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("RT failure")
                completion(error: error)
            }
        )
    }
    
    func favTweet(id: Int, params: NSDictionary?, completion: (error: NSError?) -> () ){
        POST("1.1/favorites/create.json?id=\(id)", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("FavouriteID: \(id)")
            completion(error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Couldn't fav tweet")
                completion(error: error)
            }
        )}
    
    func getCurrentUser(completion: (user: User, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("user: \(response)")
            var user = User(dictionary: response as! NSDictionary)
            User.currentUser = user
            print("user: \(user.name)")
            self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                print("error getting current user")
                self.loginCompletion?(user: nil, error: error)
                
        })

    }
    
    func tweeting(tweet: String){
        
        POST("https://api.twitter.com/1.1/statuses/update.json?status=\(tweet)", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
          print("tweeeeting")
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("Sigh please work")
               
            }
        )}



}

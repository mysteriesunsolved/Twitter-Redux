//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Sanaya Sanghvi on 2/21/16.
//  Copyright © 2016 Sanaya Sanghvi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var tweet: Tweet!
    var user: User!
    
    @IBOutlet var profileBackgroundView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var followersLabel: UILabel!
    @IBOutlet var followingLabel: UILabel!
    @IBOutlet var tweetCountLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profileimageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
            
        let profileimageURL = (tweet.user?.profileImageUrl)! as String
        profileimageView.setImageWithURL(NSURL(string: profileimageURL)!)
        
        profileBackgroundView.setImageWithURL(NSURL(string: profileimageURL)!)
       
        let darkblur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurView = UIVisualEffectView(effect: darkblur)
        let vibrancyEffect = UIVibrancyEffect(forBlurEffect: darkblur)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        blurView.frame = profileBackgroundView.bounds
        vibrancyView.frame = profileBackgroundView.bounds
        blurView.addSubview(vibrancyView)
        profileBackgroundView.addSubview(blurView)
        
        let name = (tweet.user?.name)! as String
        nameLabel.text = name
        
        let username = (tweet.user?.screenname)! as String
        usernameLabel.text = username
        
        let tweetCount = (tweet.user?.tweetCount)!
        tweetCountLabel.text = String(tweetCount)
        
        let followersCount = tweet.user?.friendsCount
        followersLabel.text = String(followersCount!)
        
        let followingCount = tweet.user?.followersCount
        followingLabel.text = String(followingCount!)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

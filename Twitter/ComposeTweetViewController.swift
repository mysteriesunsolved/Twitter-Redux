//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Sanaya Sanghvi on 2/21/16.
//  Copyright © 2016 Sanaya Sanghvi. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {
    
    var user: User!
    
    @IBOutlet var characterCountLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var tweetText: UITextView!
    @IBOutlet var tweetButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tweetText.delegate = self
        
        tweetText.layer.borderWidth = 1
        tweetText.layer.cornerRadius = 8
        tweetText.layer.borderColor = UIColor .lightGrayColor().CGColor
        tweetButton.layer.cornerRadius = 2
        
        TwitterClient.sharedInstance.getCurrentUser() { (user, error) -> () in
            self.user = user
            
            if (user.name != nil) {
                self.nameLabel.text = user.name!
                print(user.name)
            }
           
            if (user.screenname != nil) {
                self.usernameLabel.text = user.screenname!
                print(user.screenname)
            }
            
            self.profileImage.setImageWithURL(NSURL(string: user.profileImageUrl!)!)
            
            
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textViewDidChange(textView: UITextView) {
        var len = textView.text.characters.count
        characterCountLabel.text = String(140-len)
        
        if len > 140 {
            characterCountLabel.textColor = UIColor .redColor()
            
        } else {
            characterCountLabel.textColor = UIColor .grayColor()
        }
        
        }
    

    
    @IBAction func onTweet(sender: AnyObject) {
        if tweetText != nil {
             let tweet = tweetText.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                
            
            
            TwitterClient.sharedInstance.tweeting(tweet!)
        }
        dismissViewControllerAnimated(true, completion: nil)
       
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

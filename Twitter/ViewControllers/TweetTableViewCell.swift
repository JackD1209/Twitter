//
//  TweetTableViewCell.swift
//  Twitter
//
//  Created by Đoàn Minh Hoàng on 1/19/18.
//  Copyright © 2018 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileScreenName: UILabel!
    @IBOutlet weak var tweetDescription: UILabel!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    var tweet: TweetModel! {
        didSet{
            if let user = tweet.user {
                if let profileImageURL = user.userProfileUrl {
                    self.profileImage.setImageWith(profileImageURL as URL)
                }
                
                self.profileName.text = user.userName
                self.profileScreenName.text = "@\(user.userScreenName!)"
            }
            
            if let content = tweet.content {
                self.tweetDescription.text = content
            }
            
            self.retweetCount.text = String(tweet.retweetCount)
            self.likeCount.text = String(tweet.likeCount)
            
            like()
            retweet()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func like() {
        if tweet.liked {
            likeButton.setImage(UIImage(named: "liked-action"), for: .normal)
            likeCount.textColor = UIColor.red
        }
        else {
            likeButton.setImage(UIImage(named: "like-action"), for: .normal)
            likeCount.textColor = UIColor.gray
        }
    }
    
    func retweet() {
        if tweet.retweeted {
            retweetButton.setImage(UIImage(named: "retweeted-action"), for: .normal)
            retweetCount.textColor = UIColor.red
        }
        else{
            retweetButton.setImage(UIImage(named: "retweet-action"), for: .normal)
            retweetCount.textColor = UIColor.gray
        }
    }

    @IBAction func retweetButtonClicked(_ sender: Any) {
        if tweet.retweeted {
            TwitterNetwork.sharedInstance?.retweet(id: tweet.id as! Int, success: {
                self.tweet.retweetCount -= 1
                self.retweetCount.text = String(self.tweet.retweetCount)
                self.tweet.retweeted = !self.tweet.retweeted
                self.retweetButton.setImage(UIImage(named: "retweet-action"), for: .normal)
            }, failure: { (error: NSError) in

            })
        }
        else{
            TwitterNetwork.sharedInstance?.unretweet(id: tweet.id as! Int, success: {
                self.tweet.retweetCount += 1
                self.retweetCount.text = String(self.tweet.retweetCount)
                self.tweet.retweeted = !self.tweet.retweeted
                self.retweetButton.setImage(UIImage(named: "retweeted-action"), for: .normal)
            }, failure: { (error: NSError) in

            })
        }
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        if tweet.liked {
            TwitterNetwork.sharedInstance?.dislike(id: tweet.id as! Int, success: {
                self.tweet.likeCount -= 1
                self.likeCount.text = String(self.tweet.likeCount)
                self.tweet.liked = !self.tweet.liked
                self.likeButton.setImage(UIImage(named: "like-action"), for: .normal)
            }, failure: { (error: NSError) in

            })
        }
        else{
            TwitterNetwork.sharedInstance?.like(id: tweet.id as! Int, success: {
                self.tweet.likeCount += 1
                self.likeCount.text = String(self.tweet.likeCount)
                self.tweet.liked = !self.tweet.liked
                self.likeButton.setImage(UIImage(named: "liked-action"), for: .normal)
            }, failure: { (error: NSError) in

            })
        }
    }
}

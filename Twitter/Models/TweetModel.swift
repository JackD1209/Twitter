//
//  TweetModel.swift
//  Twitter
//
//  Created by Đoàn Minh Hoàng on 1/19/18.
//  Copyright © 2018 Đoàn Minh Hoàng. All rights reserved.
//

import Foundation
import UIKit

class TweetModel: NSObject {
    
    var content: String?
    var retweetCount: Int = 0
    var likeCount: Int = 0
    var liked: Bool = false
    var retweeted: Bool = false
    var id: NSNumber?
    var user: UserModel?
    
    init(dictionary: NSDictionary) {
        id = (dictionary["id"] as? NSNumber!) ?? 0
        user = UserModel(dictionary: dictionary["user"] as! NSDictionary)
        content = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        likeCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        if let liked = dictionary["favorited"] as? Bool {
            self.liked = liked
        }
        if let retweeted = dictionary["retweeted"] as? Bool{
            self.retweeted = retweeted
        }
    }
    
    class func initTweets(dictionaries: [NSDictionary]) -> [TweetModel] {
        var tweets = [TweetModel]()
        for dictionary in dictionaries {
            let tweet = TweetModel(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
}

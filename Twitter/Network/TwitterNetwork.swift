//
//  TwitterNetwork.swift
//  Twitter
//
//  Created by Đoàn Minh Hoàng on 1/19/18.
//  Copyright © 2018 Đoàn Minh Hoàng. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

class TwitterNetwork: BDBOAuth1SessionManager {
    
    static let sharedInstance  = TwitterNetwork(baseURL: NSURL(string: "https://api.twitter.com/") as URL!, consumerKey: "8TrFOsgme7nM6fv89eg1TRH6w", consumerSecret: "DdOwGaHljwmiLimnW3zpus14BhzDIUpTxc7xzGmGUYPW2AVkf7")
    
    var success: (()->())?
    var failure: ((NSError)->())?
    
    func login(success: @escaping ()->(), failure: @escaping (NSError) -> ()) {
        self.success = success
        self.failure = failure
        TwitterNetwork.sharedInstance?.deauthorize()
        
        TwitterNetwork.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "POST", callbackURL: URL(string: "mytwitter://auth"), scope: nil, success: { (response: BDBOAuth1Credential?) in
            if let response = response {
                let authURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(response.token!)")
                UIApplication.shared.openURL(authURL!)
            }
        }, failure: { (error: Error?) in
            self.failure?(error as! NSError)
        })
    }
    
    func logout() {
        UserModel.currentUser = nil
        deauthorize()
    }
    
    func handleRedirectBrowser(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (response: BDBOAuth1Credential?) in
            self.currentAccount(success: { (user: UserModel) in
                UserModel.currentUser = user
                self.success?()
            }, failure: { (error: NSError) in
                self.failure?(error)
            })
        }, failure: { (error: Error?) in
            self.failure?(error as! NSError)
        })
    }
    
    func currentAccount(success: @escaping (UserModel) -> (), failure: (NSError) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
            let userDictionary = response as! NSDictionary
            let user = UserModel(dictionary: userDictionary)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            self.failure?(error as NSError)
        })
    }
    
    func initTimeLine(success: @escaping ([TweetModel]) -> (), failure: @escaping (NSError) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
            let tweetDictionaries = response as! [NSDictionary]
            let tweets = TweetModel.initTweets(dictionaries: tweetDictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func newTweet(content: String, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        var parameter: [String: AnyObject] = [:]
        parameter["status"] = content as AnyObject?
        post("1.1/statuses/update.json", parameters: parameter, progress: nil, success: { (task: URLSessionDataTask, response) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func like(id: Int, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        var parameter: [String: AnyObject] = [:]
        parameter["id"] = id as AnyObject?
        post("1.1/favorites/create.json", parameters: parameter, progress: nil, success: { (task: URLSessionDataTask, response) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func dislike(id: Int, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        var parameter: [String: AnyObject] = [:]
        parameter["id"] = id as AnyObject?
        post("1.1/favorites/destroy.json", parameters: parameter, progress: nil, success: { (task: URLSessionDataTask, response) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func retweet(id: Int, success: @escaping () -> (), failure: @escaping (NSError) ->()) {
        post("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func unretweet(id: Int, success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        post("1.1/statuses/unretweet/\(id).json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
    
    func reply(id: Int, text: String,success: @escaping () -> (), failure: @escaping (NSError) -> ()) {
        var parameter:[String: AnyObject] = [:]
        parameter["in_reply_to_status_id"] = id as AnyObject?
        parameter["status"] = text as String? as AnyObject?
        post("1.1/statuses/update.json", parameters: parameter, progress: nil, success: { (task: URLSessionDataTask, response) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error as NSError)
        })
    }
}

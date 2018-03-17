//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Đoàn Minh Hoàng on 1/19/18.
//  Copyright © 2018 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController {
    
    let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    var tweets: [TweetModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        loadInitialData()
        // Do any additional setup after loading the view.
    }
    
    func loadInitialData() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.label.text = "Loading"
        
        TwitterNetwork.sharedInstance?.initTimeLine(success: { (tweets: [TweetModel]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) in

        })
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        TwitterNetwork.sharedInstance?.initTimeLine(success: { (tweets: [TweetModel]) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: NSError) in
            
        })
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        TwitterNetwork.sharedInstance?.logout()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newTweetClicked(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let newTweetViewController = main.instantiateViewController(withIdentifier: "NewTweetViewController") as! NewTweetViewController
        newTweetViewController.delegate = self
        self.present(newTweetViewController, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TweetTableViewCell
        tweetCell.tweet = tweets[indexPath.row]
        return tweetCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let replyTweetViewController = main.instantiateViewController(withIdentifier: "ReplyTweetViewController") as! ReplyTweetViewController
        replyTweetViewController.tweet = tweets[indexPath.row]
        self.present(replyTweetViewController, animated: true, completion: nil)
    }
}

extension TweetsViewController: NewTweetViewControllerDelegate{
    func newTweetViewController(newTweetViewController: NewTweetViewController, content: String) {
        var tweetDictionary = [String:AnyObject]()
        tweetDictionary["text"] = content as AnyObject?
        tweetDictionary["user"] = UserModel.currentUser?.userDictionary
        
        let tweetPosted = TweetModel(dictionary: tweetDictionary as NSDictionary)
        tweets.insert(tweetPosted, at: 0)
        tableView.reloadData()
    }
}

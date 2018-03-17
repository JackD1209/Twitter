//
//  ReplyTweetViewController.swift
//  Twitter
//
//  Created by Đoàn Minh Hoàng on 3/17/18.
//  Copyright © 2018 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit

class ReplyTweetViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileScreenName: UILabel!
    @IBOutlet weak var tweetDescription: UILabel!
    @IBOutlet weak var replyContent: UITextView!
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    @IBOutlet weak var replyButton: UIBarButtonItem!
    var tweet: TweetModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        replyContent.becomeFirstResponder()
        replyContent.delegate = self
        replyButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(ReplyTweetViewController.onShowKeyboard(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ReplyTweetViewController.onHideKeyBoard(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func replyButtonPressed(_ sender: Any) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension ReplyTweetViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tweet your reply"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "Tweet your reply" && textView.text != "" {
            replyButton.isEnabled = true
        }
        else {
            replyButton.isEnabled = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: NSString = replyContent.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        if updatedText.characters.count < 140 {
            return true
        }
        return false
    }
    
    @objc func onShowKeyboard(_ notification: NSNotification){
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.keyboardHeight.constant = keyboardFrame.size.height
        })
    }
    
    @objc func onHideKeyBoard(_ notification: NSNotification){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.keyboardHeight.constant = 0
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        replyContent.resignFirstResponder()
    }
}

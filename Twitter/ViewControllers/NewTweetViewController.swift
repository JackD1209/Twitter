//
//  NewTweetViewController.swift
//  Twitter
//
//  Created by Đoàn Minh Hoàng on 3/17/18.
//  Copyright © 2018 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit

@objc protocol NewTweetViewControllerDelegate {
    @objc optional func newTweetViewController(newTweetViewController: NewTweetViewController, content: String)
}

class NewTweetViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileScreenName: UILabel!
    @IBOutlet weak var wordCount: UILabel!
    @IBOutlet weak var tweetContent: UITextView!
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    @IBOutlet weak var keyboardHeight: NSLayoutConstraint!
    
    var delegate: NewTweetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetContent.becomeFirstResponder()
        tweetContent.delegate = self
        tweetButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(NewTweetViewController.onShowKeyboard(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewTweetViewController.onHideKeyBoard(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        if let profileImage = UserModel.currentUser?.userProfileUrl{
            self.profileImage.setImageWith(profileImage as URL)
        }
        self.profileName.text = UserModel.currentUser?.userName
        self.profileScreenName.text = "@\(UserModel.currentUser!.userScreenName!)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetButtonClicked(_ sender: Any) {
        TwitterNetwork.sharedInstance?.newTweet(content: tweetContent.text, success: {
            self.delegate?.newTweetViewController!(newTweetViewController: self, content: self.tweetContent.text)
            self.dismiss(animated: true, completion: nil)
        }, failure: { (error: NSError) in

        })
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
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

extension NewTweetViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's on your mind?"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text != "What's on your mind?" && textView.text != "" {
            wordCount.text = String(140 - textView.text.characters.count)
            tweetButton.isEnabled = true
        }
        else {
            tweetButton.isEnabled = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: NSString = tweetContent.text as NSString
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
        tweetContent.resignFirstResponder()
    }
}

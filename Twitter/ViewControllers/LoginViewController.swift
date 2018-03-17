//
//  LoginViewController.swift
//  Twitter
//
//  Created by Đoàn Minh Hoàng on 1/19/18.
//  Copyright © 2018 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var twitterLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        twitterLogo.image = twitterLogo?.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        twitterLogo?.tintColor = UIColor(red: 37/255, green: 185/255, blue: 235/255, alpha: 1.0)
        loginButton.layer.cornerRadius = 8
    }
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        let client = TwitterNetwork.sharedInstance
        client?.login(success: {
            let main = UIStoryboard(name: "Main", bundle: nil)
            let tweetsViewController = main.instantiateViewController(withIdentifier: "TweetsViewController") as! TweetsViewController
            self.present(tweetsViewController, animated: true, completion: nil)
        }, failure: { (error: NSError) in

        })
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

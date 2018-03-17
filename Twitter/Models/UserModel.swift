//
//  UserModel.swift
//  Twitter
//
//  Created by Đoàn Minh Hoàng on 1/19/18.
//  Copyright © 2018 Đoàn Minh Hoàng. All rights reserved.
//

import Foundation
import UIKit

class UserModel: NSObject {
    
    var userName: String?
    var userScreenName: String?
    var userProfileUrl: NSURL?
    var userDictionary: NSDictionary?
    
    static var _currentUser: UserModel?
    let currentUserKey = "kCurrentUserKey"
    
    init(dictionary: NSDictionary) {
        self.userDictionary = dictionary
        
        userName = dictionary["name"] as? String
        userScreenName = dictionary["screen_name"] as? String
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            self.userProfileUrl = NSURL(string: profileUrlString)
        }
    }
    
    class var currentUser: UserModel? {
        get {
            if _currentUser == nil {
                let user = UserDefaults.standard.object(forKey: "currentUser") as? NSData
                if let user = user {
                    do {
                        let dictionary = try JSONSerialization.jsonObject(with: user as Data, options: [])
                        _currentUser = UserModel(dictionary: dictionary as! NSDictionary)
                    } catch  {

                    }
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if let user = user {
                do {
                    let data = try JSONSerialization.data(withJSONObject: user.userDictionary!, options: JSONSerialization.WritingOptions())
                    UserDefaults.standard.set(data, forKey: "currentUser")
                } catch {

                }
            }
            else {
                UserDefaults.standard.set(nil, forKey: "currentUser")
            }
            UserDefaults.standard.synchronize()
        }
    }
}

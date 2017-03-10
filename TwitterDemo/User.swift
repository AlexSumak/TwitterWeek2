//
//  User.swift
//  TwitterDemo
//
//  Created by  Alex Sumak on 2/25/17.
//  Copyright © 2017  Alex Sumak. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var numTweets: Int = 0
    var profileBackground: URL?
 
    var numFollowings: Int = 0
    var numFollowers: Int = 0
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        print(dictionary)
      
        //numFollowers = dictionary["followers_count"] as? String
      
       numFollowers = (dictionary["followers_count"]as? Int) ?? 0
       numFollowings = (dictionary["friends_count"] as? Int) ?? 0
       numTweets = (dictionary["statuses_count"] as? Int) ?? 0
      
     
        screenname = dictionary["screen_name"] as? String
        //numTweets = dictionary["statuses_count"] as? String
      
        name = dictionary["name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
      
      
      let profileBackgroundString = dictionary["profile_banner_url"] as? String
      if let profileBackgroundString = profileBackgroundString {
        profileBackground = URL(string: profileBackgroundString)
      }
        tagline = dictionary["description"] as? String
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? Data
            if let userData = userData {
                if let dict = try! JSONSerialization.jsonObject(with: userData as Data, options: []) as? NSDictionary {
                    //print(dict)
                    _currentUser = User(dictionary: dict)
                } else {
                    _currentUser = nil
                }
            }
            
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = _currentUser {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary ?? [], options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                //defaults.set(nil, forKey: "currentUserData")
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    
}

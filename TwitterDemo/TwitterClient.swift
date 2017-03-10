//
//  TwitterClient.swift
//  TwitterDemo
//
//  Created by  Alex Sumak on 2/25/17.
//  Copyright © 2017  Alex Sumak. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "Xdztgh6PILOEcGBaejk8ZCwYj", consumerSecret: "4FckRuvrTXXvFzbachNOgL47lUnSIFcca4xH0WcaBJdewiRHQg")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken:BDBOAuth1Credential?) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url)
        }, failure: { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    

    func homeTimeLine(count: Int, success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: ["count": count], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
 
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            //print("account: \(response)")
            let userDictionary = response as? NSDictionary
            let user = User(dictionary: userDictionary!)
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            self.currentAccount(success: { (user: User) -> () in
               // User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) -> Void in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
        
    }
    
    func retweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/statuses/retweet/" + tweet.id_str! + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
    
    func favorite(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/create.json", parameters: ["id": tweet.id_str!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
  
  
  func replyTweet (message: String, replyID: String) {
    //let encodedTweetText = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    var paramsDictionary: [String: Any?] = [String: Any?]()
    paramsDictionary.updateValue(message, forKey: "status")
    paramsDictionary.updateValue(replyID, forKey: "in_reply_to_status_id")
    
    post("1.1/statuses/update.json", parameters: paramsDictionary, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
      print("message tweeted")
      
      
    }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
      print("message unable to tweet")
      
    })
    
    
  }
  
  func sendTweet (message: String, success: @escaping (Tweet)->()) {
    let encodedTweetText = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    
    
    post("1.1/statuses/update.json?status=\(encodedTweetText!)", parameters: nil, progress: nil, success: {(task: URLSessionDataTask, response: Any?) -> Void in
      print("message tweeted")
      let tweet = Tweet(dictionary: (response as? NSDictionary)!)
      success(tweet)
      print("Successfully posted tweet: \(response)")
      
    }, failure: {(task: URLSessionDataTask?, error: Error) -> Void in
      print(error.localizedDescription)
      
    })
    
    
  }
  

  
    func unretweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
      
        if !tweet.retweeted! {
        } else {
            var original_tweet_id: String?
            
            if tweet.retweeted_status == nil {
                original_tweet_id = tweet.id_str
            } else {
                original_tweet_id = tweet.retweeted_status?.id_str
            }
        
            get("1.1/statuses/show.json", parameters: ["id": original_tweet_id!, "include_my_retweet": true], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                let dictionary = response as? NSDictionary
                let full_tweet = Tweet(dictionary: dictionary!)
                if let retweet_id = full_tweet.current_user_retweet?.id_str {
                  
                    self.post("1.1/statuses/unretweet/" + retweet_id + ".json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
                        let dictionary = response as? NSDictionary
                        let orig_tweet = Tweet(dictionary: dictionary!)
                        success(orig_tweet)
                    }, failure: { (task: URLSessionDataTask?, error: Error) in
                        failure(error)
                    })
                }
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                print(error.localizedDescription)
            })
        }
    }
    
    func unfavorite(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
        post("1.1/favorites/destroy.json", parameters: ["id": tweet.id_str!], progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            let dictionary = response as? NSDictionary
            let tweet = Tweet(dictionary: dictionary!)
            success(tweet)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
            
        })
    }
    
    
}

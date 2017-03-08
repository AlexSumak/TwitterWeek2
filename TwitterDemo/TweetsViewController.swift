//
//  TweetsViewController.swift
//  TwitterDemo
//
//  Created by  Alex Sumak on 2/25/17.
//  Copyright © 2017  Alex Sumak. All rights reserved.
//
import UIKit

class TweetsViewController: UIViewController {
    
    
    var tweets: [Tweet]!
    var count = 20
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClient.sharedInstance?.homeTimeLine(count: count, success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            
            
            
        }, failure: { (error: Error) -> () in
            print(error.localizedDescription)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    

 
}



extension TweetsViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        cell.tweet = tweet
        cell.delegate = self
        return cell
    }
    
    
    
}

extension TweetsViewController: TweetCellDelegate {
  func userTappedProfilePicture(tappedCell: TweetCell, withUserData data: User){
  
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController{
      profileVC.user = data
      self.navigationController?.pushViewController(profileVC, animated: true)
      
    }
    
    
  }
  func userTappedText(tappedCell: TweetCell, withUserData data: User) {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let profileVC = storyboard.instantiateViewController(withIdentifier: "TweetDetailsViewController") as? TweetDetailsViewController{
      profileVC.user = data
      self.navigationController?.pushViewController(profileVC, animated: true)
      
    }
  }
  
  func userTappedReply(tappedCell: TweetCell, withUserData data: User){
    
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    if let profileVC = storyboard.instantiateViewController(withIdentifier: "MessageViewController") as? MessageViewController{
      profileVC.user = data
      self.navigationController?.pushViewController(profileVC, animated: true)
      
    }
  
  
  
  
  
}
}




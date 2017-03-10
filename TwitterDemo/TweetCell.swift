//
//  TweetCell.swift
//  TwitterDemo
//
//  Created by  Alex Sumak on 2/26/17.
//  Copyright © 2017  Alex Sumak. All rights reserved.
//

import UIKit

protocol TweetCellDelegate: class {
  func userTappedProfilePicture(tappedCell: TweetCell, withUserData data:
    User)
  
  func userTappedText(tappedCell: TweetCell, withUserData data:
    Tweet)
  
  func userTappedReply(tappedCell: TweetCell, withUserData data:
    User)
}

class TweetCell: UITableViewCell {
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    
    var retweetMe: Int = 1
    var favoriteMe: Int = 1
    weak var delegate: TweetCellDelegate?
    
    @IBOutlet weak var profilePicImageView:
    UIImageView!
 
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var repostLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    //@IBOutlet weak var profileImageView: UIImageView!
 
    var tweet: Tweet!{
        didSet{
            //set the url using the new user property inside the Tweet class we just created
            if let profileURL = self.tweet.user.profileUrl{
                self.profilePicImageView.setImageWith(profileURL)
            }
            //set the name using the new user property inside the Tweet class we just created
            if let name = self.tweet.user.name{
                self.nameLabel.text = name
            }
            
            //update the rest of the UI
            self.likeLabel.text = tweet.favoriteCount.description
            self.repostLabel.text = tweet.retweetCount.description
            self.timeLabel.text = timeAgoSince(tweet.timestamp!)
            self.tweetTextLabel.text = tweet.text
         
            
        }
    }
    
    func timeAgoSince(_ date: Date) -> String {
        
        let calendar = Calendar.current
        let now = Date()
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
        
        if let year = components.year, year >= 2 {
            return "\(year) years ago"
        }
        
        if let year = components.year, year >= 1 {
            return "Last year"
        }
        
        if let month = components.month, month >= 2 {
            return "\(month) months ago"
        }
        
        if let month = components.month, month >= 1 {
            return "Last month"
        }
        
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks ago"
        }
        
        if let week = components.weekOfYear, week >= 1 {
            return "Last week"
        }
        
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
        
        if let day = components.day, day >= 1 {
            return "Yesterday"
        }
        
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours ago"
        }
        
        if let hour = components.hour, hour >= 1 {
            return "An hour ago"
        }
        
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes ago"
        }
        
        if let minute = components.minute, minute >= 1 {
            return "A minute ago"
        }
        
        if let second = components.second, second >= 3 {
            return "\(second) seconds ago"
        }
        
        return "Just now"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func userTappedProfilePicture(_ sender: Any) {
      delegate?.userTappedProfilePicture(tappedCell: self, withUserData: (self.tweet?.user)!)
    }
    
  @IBAction func userTappedText(_ sender: Any) {
    delegate?.userTappedText(tappedCell: self, withUserData: (self.tweet)!)
    
  }
  
  @IBAction func userTappedReply(_ sender: Any) {
       delegate?.userTappedReply(tappedCell: self, withUserData: (self.tweet?.user)!)
  }
 
    
    @IBAction func onRetweet(_ sender: Any) {
        favoritesCount = tweet.favoriteCount
        favoritesCount = favoritesCount + 1
        likeLabel.text = String (self.favoritesCount)
        retweetMe = retweetMe + 1
        if (retweetMe % 2 != 0){
            favoritesCount = favoritesCount - 1
            likeLabel.text = String (self.favoritesCount)
        }
    }
  
    @IBAction func onLike(_ sender: Any) {
        retweetCount = tweet.retweetCount
        retweetCount = retweetCount + 1
        repostLabel.text = String (self.retweetCount)
        favoriteMe = favoriteMe + 1
        if (favoriteMe % 2 != 0){
            retweetCount = retweetCount - 1
            repostLabel.text = String (self.retweetCount)
        }
    }

 

}


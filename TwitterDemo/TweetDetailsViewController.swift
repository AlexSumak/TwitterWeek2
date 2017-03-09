//
//  TweetDetailsViewController.swift
//  TwitterDemo
//
//  Created by  Alex Sumak on 3/8/17.
//  Copyright © 2017  Alex Sumak. All rights reserved.
//

import UIKit

class TweetDetailsViewController: UIViewController {
   // var user: User!
  var tweet: Tweet!
  @IBOutlet weak var textLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  
  @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       print(tweet.tweetDict)
      
      //nameLabel.text = user.name
      textLabel.text = tweet.text
      if let profileImg = tweet.profileUrl{
        profileImage.setImageWith(profileImg)
      }
      
      
      //profileImage.setImageWith(user.profileUrl!)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//
//  MessageViewController.swift
//  TwitterDemo
//
//  Created by  Alex Sumak on 3/8/17.
//  Copyright © 2017  Alex Sumak. All rights reserved.
//

import UIKit

protocol MessageViewControllerDelegate: class{
  
  func userSuccessTweet(tweet: Tweet)
  
}

class MessageViewController: UIViewController {
    var user: User!
  
  @IBOutlet weak var messageView: UITextView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var profileImage: UIImageView!
  
  weak var delegate:MessageViewControllerDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = user.name
        profileImage.setImageWith(user.profileUrl!)
      
      messageView.text = "What's happening?"
      messageView.textColor = UIColor.lightGray
      messageView.selectedTextRange = messageView.textRange(from: messageView.beginningOfDocument, to: messageView.beginningOfDocument)
      
      
        // Do any additional setup after loading the view.
    }

  @IBAction func cancel(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func tweet(_ sender: Any) {
    
    if messageView.text != "" {
     
      TwitterClient.sharedInstance?.sendTweet(message: messageView.text, success: { (tweet: Tweet) in
         self.delegate?.userSuccessTweet(tweet: tweet)
        self.navigationController?.popViewController(animated: true)
      })
    
    }
   // dismiss(animated: true, completion: nil)
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

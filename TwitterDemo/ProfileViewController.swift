//
//  ProfileViewController.swift
//  TwitterDemo
//
//  Created by  Alex Sumak on 3/8/17.
//  Copyright © 2017  Alex Sumak. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  @IBOutlet weak var nameLabel: UILabel!
    var user: User!
    override func viewDidLoad() {
        super.viewDidLoad()
      print(user)
      print(user.dictionary)
      nameLabel.text = user.name
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

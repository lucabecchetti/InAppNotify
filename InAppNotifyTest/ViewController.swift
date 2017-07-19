//
//  ViewController.swift
//  InAppNotifyTest
//
//  Created by Luca Becchetti on 19/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation
import UIKit
import InAppNotify

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var subTitileLabel: UITextField!
    @IBOutlet weak var avatarVisible: UISwitch!
    @IBOutlet weak var userInteraction: UISwitch!
    @IBOutlet weak var logLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Hi, i'am in app notification! 😄"
        logLabel.text = ""
        logLabel.numberOfLines = 0
        
    }

    @IBAction func showSimple(_ sender: Any) {
        
        logLabel.text = "Notification will be show!"
        if let txt = titleLabel.text{
            
            let ann = Announcement(title: txt, subtitle: subTitileLabel.text, image: (avatarVisible.isOn) ? #imageLiteral(resourceName: "smile") : nil, urlImage: nil, duration: 3, interactionType: (userInteraction.isOn) ? InteractionType.inputText : InteractionType.none, action: { (type, string, announcement) in
                
                if type == CallbackType.tap{
                    self.logLabel.text = self.logLabel.text!+"\nUser has been tapped"
                }else if type == CallbackType.text{
                    self.logLabel.text = self.logLabel.text!+"\nReply from notification: \(string!)"
                }else{
                    self.logLabel.text = self.logLabel.text!+"\nNotification has been closed!"
                }
                
            })
            InAppNotify.Show(ann, to: self)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}


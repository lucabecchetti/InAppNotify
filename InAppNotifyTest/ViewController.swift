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

    @IBOutlet weak var buttonShow           : UIButton!
    @IBOutlet weak var titleLabel           : UITextField!
    @IBOutlet weak var subTitileLabel       : UITextField!
    @IBOutlet weak var avatarVisible        : UISwitch!
    @IBOutlet weak var userInteraction      : UISwitch!
    @IBOutlet weak var logLabel             : UILabel!
    @IBOutlet weak var segmentControlTheme  : UISegmentedControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //------ CONFIGURATION ONLY FOR EXAMPLE ------//
        titleLabel.text         = "Hi, i'am in app notification! 😄"
        subTitileLabel.text     = "Use me in your app, that's fun!"
        logLabel.text           = ""
        logLabel.numberOfLines  = 6
        buttonShow.setTitleColor(UIColor(red:0.90, green:0.58, blue:0.15, alpha:1.00), for: .normal)
        segmentControlTheme.tintColor = UIColor(red:0.90, green:0.58, blue:0.15, alpha:1.00)
        avatarVisible.onTintColor = UIColor(red:0.90, green:0.58, blue:0.15, alpha:1.00)
        userInteraction.onTintColor = UIColor(red:0.90, green:0.58, blue:0.15, alpha:1.00)
        //------ CONFIGURATION ONLY FOR EXAMPLE ------//
        
    }

    
    /// Function called to show notification
    ///
    /// - Parameter sender: UIButton
    @IBAction func showSimple(_ sender: Any) {
        
        //reset log label
        logLabel.text = "Notification will be show!"
        
        
        //------ PERSONALIZE THEME ------ 
        switch segmentControlTheme.selectedSegmentIndex {
        case 1:
            
            //Use buitin light theme
            InAppNotify.theme = Themes.light
            
        case 2:
            
            //Create and use a custom theme
            InAppNotify.theme = Theme(
                titleFont                   : UIFont.boldSystemFont(ofSize: 18),
                subtitleFont                : UIFont.systemFont(ofSize: 13),
                backgroundColor             : UIColor(red:0.90, green:0.58, blue:0.15, alpha:1.00),
                dragIndicatorColor          : UIColor(red:0.95, green:0.80, blue:0.19, alpha:1.00),
                titleColor                  : UIColor.white,
                subtitleColor               : UIColor.white,
                shadowColor                 : UIColor.darkGray.cgColor,
                inputTextBackgroundColor    : UIColor(red:0.95, green:0.80, blue:0.19, alpha:1.00),
                inputTextColor              : UIColor.white,
                sendButtonHighlightedColor  : UIColor.darkGray,
                sendButtonNormalColor       : UIColor.black,
                separatorLineColor          : UIColor.black
            )
            
        default:
            
            //Use buitin dark theme
            InAppNotify.theme = Themes.dark
            
        }
        
        if let txt = titleLabel.text{
            
            //Create announcemente object to display a notification
            
            let ann = Announcement(
                //Title, the first line
                title           : txt,
                //Subtitle, the second line
                subtitle        : subTitileLabel.text,
                //Image local, show if no urlImage is set
                image           : (avatarVisible.isOn) ? #imageLiteral(resourceName: "smile") : nil,
                //URL of remote image
                urlImage        : nil,
                //Seconds before disappear
                duration        : 3,
                //Interaction type. none or text
                interactionType : (userInteraction.isOn) ? InteractionType.inputText : InteractionType.none,
                //Action callback
                action: { (type, string, announcement) in
                
                    //You can detect the action by test "type" var
                    
                    if type == CallbackType.tap{
                        self.logLabel.text = self.logLabel.text!+"\nUser has been tapped"
                    }else if type == CallbackType.text{
                        self.logLabel.text = self.logLabel.text!+"\nReply from notification: \(string!)"
                    }else{
                        self.logLabel.text = self.logLabel.text!+"\nNotification has been closed!"
                    }
                }
            
            )
        
            //Show notitication in the current view controller
            InAppNotify.Show(ann, to: self)
        
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}


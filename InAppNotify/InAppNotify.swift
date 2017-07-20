//
//  InAppNotify.swift
//  InAppNotify
//
//  Created by Luca Becchetti on 19/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation

public class InAppNotify{
    
    /// Notify current dislayed
    public static var currentNotify:NotificationFactory?
    
    public static var sendString = "Send"
    
    public static var theme:Theme = Themes.dark
    
    /// Function to show notify
    ///
    /// - Parameters:
    ///   - announcement: Announcement to show
    ///   - to: UIViewController to show
    ///   - completion: completition callback
    public class func Show(_ announcement: Announcement, to: UIViewController) {
        
        //Hide previous notify if exists
        currentNotify?.hide(false)
        //Create new notify
        currentNotify = NotificationFactory()
        //Build new notify
        currentNotify?.build(forAnnouncement : announcement, to: to)

    }

}

/// Type for callback
public typealias CallbackInApp = ((CallbackType,String?,Announcement) -> ())

/// Describe interaction type with notification
///
/// - None: no interaction
/// - InputText: textarea interaction
public enum InteractionType:String{
    case none       = "None"
    case inputText  = "Input"
}


/// Define type of callback verified
///
/// - tap: user tap notify
/// - text: user reply in notify
public enum CallbackType:Int{
    case tap        = 1
    case text       = 2
    case hide       = 3
}

/// The object to show
public struct Announcement {
    
    
    /// Title of notify
    public var title            : String
    /// Subtitle of notify
    public var subtitle         : String?
    /// Image for notity (local image asset)
    public var image            : UIImage?
    /// Duration before notify disappear
    public var duration         : TimeInterval
    /// Callback action
    public var action           : CallbackInApp?
    /// Remote imageUrl to show
    public var urlImage         : String?
    /// Interaction type
    public var interactionType  : InteractionType?
    /// Use this field to pass data
    public var userInfo         : Any?
    
    
    /// Initialize announce passing 'title' and other optional value
    ///
    /// - Parameters:
    ///   - title: Title, first line
    ///   - subtitle: Subtitile, second line
    ///   - image: Image to show
    ///   - urlImage: imageUrl
    ///   - duration: duration in seconds before it disappear
    ///   - interactionType: can be none or text
    ///   - action: action callback
    public init(title: String, subtitle: String? = nil, image: UIImage? = nil, urlImage:String? = nil, duration: TimeInterval = 2, interactionType:InteractionType = InteractionType.none, userInfo:Any? = nil, action: CallbackInApp? = nil) {
        
        self.title              = title
        self.subtitle           = subtitle
        self.image              = image
        self.duration           = duration
        self.action             = action
        self.urlImage           = urlImage
        self.interactionType    = interactionType
        self.userInfo           = userInfo
        
    }
}


/// Struct for theme
public struct Theme{
    
    public var titleFont                    : UIFont?
    public var subtitleFont                 : UIFont?
    public var backgroundColor              : UIColor?
    public var dragIndicatorColor           : UIColor?
    public var titleColor                   : UIColor?
    public var subtitleColor                : UIColor?
    public var shadowColor                  : CGColor?
    public var inputTextBackgroundColor     : UIColor?
    public var inputTextColor               : UIColor?
    public var sendButtonHighlightedColor   : UIColor?
    public var sendButtonNormalColor        : UIColor?
    public var separatorLineColor           : UIColor?
    
    /// Initialize a theme passing all colors and font
    ///
    /// - Parameters:
    ///   - titleFont: font for title
    ///   - subtitleFont: font for subtitle
    ///   - backgroundColor: color of background
    ///   - dragIndicatorColor: color for drag indicator
    ///   - titleColor: color for title
    ///   - subtitleColor: color for subtitle
    ///   - shadowColor: color for shadow
    public init(titleFont : UIFont, subtitleFont : UIFont, backgroundColor : UIColor,dragIndicatorColor : UIColor,titleColor : UIColor,subtitleColor : UIColor,shadowColor : CGColor, inputTextBackgroundColor: UIColor, inputTextColor: UIColor, sendButtonHighlightedColor : UIColor,sendButtonNormalColor : UIColor, separatorLineColor: UIColor) {
        
        self.titleFont                  = titleFont
        self.subtitleFont               = subtitleFont
        self.backgroundColor            = backgroundColor
        self.dragIndicatorColor         = dragIndicatorColor
        self.titleColor                 = titleColor
        self.subtitleColor              = subtitleColor
        self.shadowColor                = shadowColor
        self.inputTextBackgroundColor   = inputTextBackgroundColor
        self.inputTextColor             = inputTextColor
        self.sendButtonHighlightedColor = sendButtonHighlightedColor
        self.sendButtonNormalColor      = sendButtonNormalColor
        self.separatorLineColor         = separatorLineColor
        
    }
    
}

/// Define a fonts for varius themes
public struct Themes {

    public static let dark:Theme = Theme(
        titleFont                   : UIFont.boldSystemFont(ofSize: 15),
        subtitleFont                : UIFont.systemFont(ofSize: 13),
        backgroundColor             : UIColor.black,
        dragIndicatorColor          : UIColor(red:0.90, green:0.90, blue:0.90, alpha:1),
        titleColor                  : UIColor.white,
        subtitleColor               : UIColor.white,
        shadowColor                 : UIColor.black.cgColor,
        inputTextBackgroundColor    : UIColor(red:0.57, green:0.57, blue:0.57, alpha:1),
        inputTextColor              : UIColor.white,
        sendButtonHighlightedColor  : UIColor.darkGray,
        sendButtonNormalColor       : UIColor.white,
        separatorLineColor          : UIColor.white
    )
    
    public static let light:Theme = Theme(
        titleFont                   : UIFont.boldSystemFont(ofSize: 15),
        subtitleFont                : UIFont.systemFont(ofSize: 13),
        backgroundColor             : UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00),
        dragIndicatorColor          : UIColor.gray,
        titleColor                  : UIColor.black,
        subtitleColor               : UIColor.black,
        shadowColor                 : UIColor.darkGray.cgColor,
        inputTextBackgroundColor    : UIColor(red:0.57, green:0.57, blue:0.57, alpha:1),
        inputTextColor              : UIColor.white,
        sendButtonHighlightedColor  : UIColor.darkGray,
        sendButtonNormalColor       : UIColor.black,
        separatorLineColor          : UIColor.black
    )

}


/// Define the varius dimensions for the notification
public struct NotificationSize {
    public static let indicatorHeight   : CGFloat = 6
    public static let indicatorWidth    : CGFloat = 40
    public static let imageSize         : CGFloat = 48
    public static let imageOffset       : CGFloat = 9
    public static var height            : CGFloat = UIApplication.shared.isStatusBarHidden ? 70 : 80
    public static var textOffset        : CGFloat = 65
}



// MARK: - UIImageView
extension UIImageView{
    
    
    /// Set an image in UIImageView from remote URL
    ///
    /// - Parameter url: url of the image
    func setImageFromURL(stringImageUrl url: String){
        
        //Placeholder image
        image = #imageLiteral(resourceName: "user_blank")
        
        //Download async image
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if let url = URL(string: url) {
                do{
                
                    let data = try Data.init(contentsOf: url)
                    
                    //Set image in the main thread
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                    
                }catch{
                
                }
            }
        }
        
    }
}

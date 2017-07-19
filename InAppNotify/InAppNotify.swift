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


/// Define a colors for varius themes
public struct ColorTheme {
    
    /// Dark theme
    public struct Dark {
        public static var background    = UIColor.black
        public static var dragIndicator = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1)
        public static var title         = UIColor.white
        public static var subtitle      = UIColor.white
        public static var shadowColor   = UIColor.black.cgColor
    }

}

/// Define a fonts for varius themes
public struct FontTheme {
    
    /// Dark theme
    public struct Dark {
        public static var title         = UIFont.boldSystemFont(ofSize: 15)
        public static var subtitle      = UIFont.systemFont(ofSize: 13)
    }

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


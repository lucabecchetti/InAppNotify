//
//  NotificationFactory.swift
//  InAppNotify
//
//  Created by Luca Becchetti on 19/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import UIKit

/// This class design the notification
open class NotificationFactory: UIView,UITextViewDelegate {
    
    /// True if notification is opened in InteractionType.text
    private var openedToReply   : Bool = false
    
    /// The visibility of statusbar before panned for InteractionType.text
    private var preVisibileBar  : Bool = true

    /// The main controller where notification is showed
    private var maincontroller  : UIViewController?
    
    /// Lazy view that represent a background of notitication
    open fileprivate(set) lazy var backgroundView: UIView = {
        
        let view = UIView()
        view.backgroundColor = InAppNotify.theme.backgroundColor
        view.alpha           = 0.8
        view.clipsToBounds   = true
        return view
        
    }()
    
    
    /// Lazy view that contain the gesture to dismiss a notification
    open fileprivate(set) lazy var gestureContainer: UIView = {
        
        let view = UIView()
        view.backgroundColor          = UIColor.clear
        view.isUserInteractionEnabled = true
        return view
        
    }()
    
    
    /// Lazy view for drag indicator
    open fileprivate(set) lazy var indicatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor            = InAppNotify.theme.dragIndicatorColor
        view.layer.cornerRadius         = NotificationSize.indicatorHeight / 2
        view.isUserInteractionEnabled   = true
        return view
        
    }()
    
    
    /// Lazy view for avatar image
    open fileprivate(set) lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.layer.cornerRadius    = NotificationSize.imageSize / 2
        imageView.clipsToBounds         = true
        imageView.contentMode           = .scaleAspectFill
        return imageView
        
    }()
    
    
    /// Lazy label for title
    open fileprivate(set) lazy var titleLabel: UILabel = {
        
        let label           = UILabel()
        label.font          = InAppNotify.theme.titleFont
        label.textColor     = InAppNotify.theme.titleColor
        label.numberOfLines = 1
        return label
        
    }()
    
    
    /// Lazy label for subtitle
    open fileprivate(set) lazy var subtitleLabel: UILabel = {
        
        let label           = UILabel()
        label.font          = InAppNotify.theme.subtitleFont
        label.textColor     = InAppNotify.theme.subtitleColor
        label.numberOfLines = 1
        return label
        
    }()
    
    
    /// Lazy button for action
    open fileprivate(set) lazy var buttonSend: UIButton = {
        
        let button       = UIButton()
        button.isEnabled = false
        
        button.setTitle(InAppNotify.sendString, for: UIControlState())
        button.setTitleColor(InAppNotify.theme.sendButtonNormalColor, for: UIControlState())
        button.setTitleColor(InAppNotify.theme.sendButtonHighlightedColor, for: .highlighted)
        return button
    }()
    
    /// Lazy text view for action
    open fileprivate(set) lazy var inputText: UITextView = {
        
        let txf             = UITextView()
        txf.alpha           = 1
        txf.backgroundColor = InAppNotify.theme.inputTextBackgroundColor
        txf.textColor       = InAppNotify.theme.inputTextColor
        txf.isScrollEnabled = true;
        txf.font            = .systemFont(ofSize: 16)
        return txf
        
    }()
    
    /// Lazy view for line separator
    open fileprivate(set) lazy var lineSeparator: UIView = {
        var line = UIView()
        line.tag = 1000
        line.backgroundColor = InAppNotify.theme.separatorLineColor
        return line
    }()
    
    /// Lazy gesture for tap in notification
    open fileprivate(set) lazy var tapGestureRecognizer: UITapGestureRecognizer = { [unowned self] in
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.handleTapGestureRecognizer))
        return gesture
        }()
    
    /// Lazy gesture for pan in notification
    open fileprivate(set) lazy var panGestureRecognizer: UIPanGestureRecognizer = { [unowned self] in
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(self.handlePanGestureRecognizer))
        return gesture
        }()
    
    
    /// Announce to show
    open fileprivate(set) var announcement      : Announcement?
    
    /// Timer to dismiss notification
    open fileprivate(set) var displayTimer      = Timer()
    
    /// Define if pan gesture is enabled
    open fileprivate(set) var panGestureActive  = false
    
    /// Define if notification has to be hide
    open fileprivate(set) var canHide      = false
    
    /// Callaback on tap
    open fileprivate(set) var completion        : CallbackInApp?
    
    /// Define the interaction type for notificaion
    open var interactionType                    : InteractionType?
    
    /// Screen total with
    var totalWidth:CGFloat{
        get{
            return UIScreen.main.bounds.width
        }
    }
    
    /// Screen total height
    var totalHeight:CGFloat{
        get{
            return UIScreen.main.bounds.height
        }
    }
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //Create views
        createViews()
        
        //Define settings
        clipsToBounds               = false
        isUserInteractionEnabled    = true
        layer.shadowColor           = InAppNotify.theme.shadowColor
        layer.shadowOffset          = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity         = 0.1
        layer.shadowRadius          = 0.5
        
        addGestureRecognizer(tapGestureRecognizer)
        gestureContainer.addGestureRecognizer(panGestureRecognizer)
        
        //Register delegate and actions
        inputText.delegate          = self
        interactionType             = InteractionType.none
        buttonSend.addTarget(self, action:#selector(self.interactionSend), for: .touchUpInside)
        
        //Register for rotation change
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationDidChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        //Deregister for rotation change
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    
    /// Create views for notification
    private func createViews(){
        addSubview(backgroundView)
        [indicatorView, imageView, titleLabel, subtitleLabel, inputText,gestureContainer,buttonSend].forEach { backgroundView.addSubview($0) }
    }
    
    
    /// Called when text inside textview change
    ///
    /// - Parameter textView: textView
    open func textViewDidChange(_ textView: UITextView) {
        
        let fixedWidth              = textView.frame.size.width
        let newSize                 = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame                = textView.frame
        newFrame.size               = CGSize(width: max(newSize.width, fixedWidth), height: (newSize.height > 100) ? 100 : newSize.height)
        textView.frame              = newFrame;
        buttonSend.isEnabled        = textView.text != ""
        buttonSend.frame.origin.y   = inputText.frame.origin.y+inputText.frame.size.height-buttonSend.frame.size.height
        let stringLength:Int        = textView.text.characters.count
        
        textView.scrollRangeToVisible(NSMakeRange(stringLength-1, 0))
        
    }
    
    
    /// Call when user press send on interaction
    @objc fileprivate func interactionSend(){
        self.completion?(CallbackType.text,inputText.text!,self.announcement!)
        hide()
    }
    
    
    /// Function to build a notitication views for a announcement
    ///
    /// - Parameters:
    ///   - announcement: announcement to show
    ///   - to: a UIViewController to append the notification
    ///   - completion: a completition callback
    open func build(forAnnouncement announcement: Announcement, to: UIViewController) {
        
        //Adjust size based on statusbar
        NotificationSize.height = UIApplication.shared.isStatusBarHidden ? 70 : 80
        
        //Reset variables
        panGestureActive        = false
        canHide                 = false
        self.completion         = announcement.action
        self.interactionType    = announcement.interactionType
        
        //Configure view
        configureView(announcement)
        
        //Show the notification
        show(to: to)
        
    }
    
    
    /// Configure the view based on announcement options
    ///
    /// - Parameter announcement: announcement to show
    open func configureView(_ announcement: Announcement) {
        
        //Set current announcement
        self.announcement = announcement
        
        //Set image if needed
        if(announcement.urlImage != nil && announcement.urlImage! != ""){
            imageView.setImageFromURL(stringImageUrl: announcement.urlImage!)
        }else{
            imageView.image = announcement.image
        }
        
        //Set texts
        titleLabel.text     = announcement.title
        subtitleLabel.text  = announcement.subtitle ?? ""
        
        //Size all views
        [titleLabel, subtitleLabel,inputText,buttonSend].forEach {
            $0.sizeToFit()
        }
        
        //Adjust offset based on image
        NotificationSize.textOffset = (imageView.image == nil) ? 18 : 65
        
        //Invalidate e recreate timer
        displayTimer.invalidate()
        displayTimer = Timer.scheduledTimer(timeInterval: announcement.duration,target: self, selector: #selector(self.displayTimerDidFire), userInfo: nil, repeats: false)
        
        //Setup and position views
        setupFramesAndPositionViews()
        
    }
    
    
    /// Show current announcement to passed controller
    ///
    /// - Parameter controller: UIViewController where append announcement
    open func show(to controller: UIViewController) {
        
        //Set this as main controller
        maincontroller = controller
        
        //Append notitication to a passed controller
        controller.view.addSubview(self)
        
        //Set initial size to 100% with and 0 height
        let width = UIScreen.main.bounds.width
        frame = CGRect(x: 0, y: 0, width: width, height: 0)
        backgroundView.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        
        //Animate to needed size
        UIView.animate(withDuration: 0.35, animations: {
            self.frame.size.height = NotificationSize.height
            self.backgroundView.frame.size.height = self.frame.height
        })
        
    }
    
    /// Function used to resize and position views
    open func setupFramesAndPositionViews() {
        
        //Get current offset based on statusbar
        let offset: CGFloat = UIApplication.shared.isStatusBarHidden ? 2.5 : 5
        
        //Adjust objects frame
        backgroundView.frame.size   = CGSize(width: totalWidth, height: NotificationSize.height)
        gestureContainer.frame      = CGRect(x: 0, y: 0, width: totalWidth, height: totalHeight)
        indicatorView.frame         = CGRect(
            x       : (totalWidth - NotificationSize.indicatorWidth) / 2,
            y       : NotificationSize.height - NotificationSize.indicatorHeight - 5,
            width   : NotificationSize.indicatorWidth,
            height  : NotificationSize.indicatorHeight
        )
        imageView.frame = CGRect(
            x       : NotificationSize.imageOffset,
            y       : (NotificationSize.height - NotificationSize.imageSize) / 2 + offset,
            width   : NotificationSize.imageSize,
            height  : NotificationSize.imageSize
        )
        
        titleLabel.frame.origin         = CGPoint(x: NotificationSize.textOffset, y: imageView.frame.origin.y + 3)
        subtitleLabel.frame.origin      = CGPoint(x: NotificationSize.textOffset, y: titleLabel.frame.maxY + 2.5)
        inputText.layer.cornerRadius    = 4
        inputText.layer.masksToBounds   = true
        inputText.keyboardAppearance    = .dark
        inputText.isHidden              = true
        buttonSend.isHidden             = true
        
        if let text = subtitleLabel.text, text.isEmpty {
            titleLabel.center.y = imageView.center.y - 2.5
        }
        
        [titleLabel, subtitleLabel].forEach { $0.frame.size.width = totalWidth - NotificationSize.imageSize - (NotificationSize.imageOffset * 2) }
        
    }
    
    
    // MARK: - Handling screen orientation
    
    func orientationDidChange() {
        setupFramesAndPositionViews()
        if openedToReply {
            setupTextInteractionFrame()
        }
    }
    
    
    /// Show current announcement to passed controller
    ///
    /// - Parameter animate: if true animation will be perfomed
    
    open func hide(_ animate:Bool? = true) {
        
        let dur = (animate!) ? 0.35 : 0
        UIView.animate(withDuration: dur, animations: {
            self.inputText.resignFirstResponder()
            self.frame.size.height = 0
            self.backgroundView.frame.size.height = self.frame.height
        }, completion: { finished in
            self.completion?(CallbackType.hide, nil,self.announcement!)
            self.displayTimer.invalidate()
            self.removeFromSuperview()
            if self.interactionType == InteractionType.inputText && self.openedToReply{
                self.openedToReply = false
                self.maincontroller?.tabBarController?.tabBar.isHidden = self.preVisibileBar
            }
        })
    }
    
    /// MARK: - Gesture methods
    open func displayTimerDidFire() {
        
        //stop if user is dragging
        if panGestureActive { return }
        
        //set notification closable
        canHide = true
        
        //Close notitification
        hide()
    }
    
    // MARK: - Gesture methods
    
    
    /// Called when user tap on a notification
    @objc fileprivate func handleTapGestureRecognizer() {
        
        guard let announcement = announcement else { return }
        if openedToReply == false{
            announcement.action?(CallbackType.tap,nil,self.announcement!)
        }else{
            inputText.text = ""
        }
        hide()
        
    }
    
    
    /// Function used to resize and position views for user interaction
    private func setupTextInteractionFrame(){
        
        //Adjust frame size to all screen
        frame.size.height = UIScreen.main.bounds.size.height
        
        subtitleLabel.numberOfLines = 5
        subtitleLabel.sizeToFit()
        
        self.backgroundView.frame.size.height   = self.frame.height
        self.gestureContainer.frame.origin.y    = self.frame.height - 20
        self.indicatorView.frame.origin.y       = self.frame.height - NotificationSize.indicatorHeight - 5
        
        //Check if separator exists
        var line:UIView?                        = self.viewWithTag(1000)
        if line == nil{
            line = lineSeparator
            self.addSubview(line!)
        }
        
        //Set correct frame
        line!.frame = CGRect(
            x: 0,
            y: max(imageView.frame.origin.y+imageView.frame.size.height,subtitleLabel.frame.origin.y+subtitleLabel.frame.size.height) + 8,
            width: totalWidth,
            height: 0.5
        )
        
        //Align elements
        let topy            = line!.frame.origin.y + max(subtitleLabel.frame.size.height, 10)
        inputText.frame     = CGRect(x: 10, y: topy, width: totalWidth-25-buttonSend.frame.size.width, height: 35)
        buttonSend.frame    = CGRect(x: inputText.frame.size.width+15, y: topy, width: buttonSend.frame.size.width, height: 35)
        buttonSend.isHidden = false
        inputText.isHidden  = false
        
        //Show keyboard
        inputText.becomeFirstResponder()
        
    }
    
    /// Called when user pan up or down on a notification
    @objc fileprivate func handlePanGestureRecognizer() {
        
        let translation = panGestureRecognizer.translation(in: self)
        var duration: TimeInterval = 0
        
        if panGestureRecognizer.state == .changed || panGestureRecognizer.state == .began {
            panGestureActive = true
            if translation.y >= 20 {
                
                //Check if notitification has textInteraction enabled
                if interactionType == InteractionType.inputText{
                    if(openedToReply){ return }
                    openedToReply = true
                    setupTextInteractionFrame()
                    if maincontroller != nil && maincontroller!.tabBarController != nil{
                        preVisibileBar = maincontroller!.tabBarController!.tabBar.isHidden
                    }
                    maincontroller?.tabBarController?.tabBar.isHidden = true
                    
                }else{
                    frame.size.height = NotificationSize.height + 12 + (translation.y) / 25
                }
                
            } else {
                frame.size.height = NotificationSize.height + translation.y
            }
        } else if (!openedToReply){
                
                panGestureActive = false
                let height = translation.y < -5 || canHide ? 0 : NotificationSize.height
                duration = 0.2
                UIView.animate(withDuration: duration, animations: {
                    self.frame.size.height = height
                }, completion: { _ in if translation.y < -5 {
                    self.completion?(CallbackType.hide,nil,self.announcement!)
                    self.removeFromSuperview()
                    self.displayTimer.invalidate()
                }})
                
        }
        
        //Animate view
        UIView.animate(withDuration: duration, animations: {
            self.backgroundView.frame.size.height = self.frame.height
            self.gestureContainer.frame.origin.y = self.frame.height - 20
            self.indicatorView.frame.origin.y = self.frame.height - NotificationSize.indicatorHeight - 5
        })
    }
 
}

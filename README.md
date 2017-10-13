# InAppNotify - Manage in App notifications
<p align="center" >
  <img src="https://user-images.githubusercontent.com/16253548/28424204-4c36af46-6d6d-11e7-95df-0cb4582093d7.png" width=400px alt="InAppNotify" title="InAppNotify">
</p>

[![Version](https://img.shields.io/badge/pod-0.1.3-blue.svg)](https://cocoapods.org/pods/InAppNotify) [![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://cocoapods.org/pods/InAppNotify) [![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://cocoapods.org/pods/InAppNotify) [![Swift3](https://img.shields.io/badge/swift3-compatible-brightgreen.svg)](https://cocoapods.org/pods/InAppNotify)

During develop of my app [Frind](http://www.frind.it), I needed to manage in app notifications like whatsapp or telegram, but i didn't find nothing that liked me, so, i created this library. Choose InAppNotify for your next project, I'll be happy to give you a little help!

<p align="center" >★★ <b>Star our github repository to help us!, or <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BZD2RPBADPA6G" target="_blank"> ☕ pay me a coffee</a></b> ★★</p>
<p align="center" >Created by <a href="http://www.lucabecchetti.com">Luca Becchetti</a></p>


## Screenshots

<p align="center" >
<img src="https://user-images.githubusercontent.com/16253548/28425722-74d8b1e8-6d71-11e7-9183-c5a7a8d519fe.png" width="33%">
<img src="https://user-images.githubusercontent.com/16253548/28425724-75042ea4-6d71-11e7-86fe-99651fa85a8a.png" width="33%">
<img src="https://user-images.githubusercontent.com/16253548/28425723-7500587e-6d71-11e7-8447-80c5302e44b6.png" width="33%">
</p>


## Requirements

  - iOS 8+
  - swift 3.0
  
## Main features
Here's a highlight of the main features you can find in InAppNotify:
* **Multiple orientation** We support `portrait` and `landscape` orientation
* **Fully customizable**. You can customize all programmatically  
* **Swipe gesture** Up to dismiss, or down to show reply text field

## You also may like

Do you like `InAppNotify`? I'm also working on several other opensource libraries.

Take a look here:

* **[CountriesViewController](https://github.com/lucabecchetti/CountriesViewController)** - Countries selection view
* **[SwiftMultiSelect](https://github.com/lucabecchetti/SwiftMultiSelect)** - Generic multi selection tableview
* **[SwiftMulticastProtocol](https://github.com/lucabecchetti/SwiftMulticastProtocol)** - send message to multiple classes

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like InAppNotify in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate InAppNotify into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
  use_frameworks!
  pod 'InAppNotify'
end
```

Then, run the following command:

```bash
$ pod install
```

## How to use

First of all import library in your project

```swift
import InAppNotify
```

The basic code to show a simple notification is:

```swift
//If you are in a UIViewController
InAppNotify.Show(Announcement(title: "Hello world! my first example!"), to: self)
```

### InAppNotify.Show method

This is a static method used to present a notitication, it takes two parameters, first is an instance of Announcement object, the second is a subclass of UIViewController

### Create announcement object

This library can show only an instance of "Announcement" object, you can pass many parameters to his initializer:

```swift
let announce = Announcement(
      //Title, the first line
      title           : "I am titile",
      //Subtitle, the second line
      subtitle        : "I am subititle",
      //Image local, show if no urlImage is set
      image           : UIImage(named: "test"),
      //URL of remote image
      urlImage        : "https://.....",
      //Seconds before disappear
      duration        : 3,
      //Interaction type. none or text
      interactionType : InteractionType.none,
      //Pass data to annoucement
      userInfo        : ["id" : 10],
      //Action callback
      action: { (type, string, announcement) in
                
            //You can detect the action by test "type" var     
            if type == CallbackType.tap{
                  print("User has been tapped")
            }else if type == CallbackType.text{
                  print("Reply from notification: \(string!)")
            }else{
                  print("Notification has been closed!")
            }
      }
            
)
```

### Present announcement object
When object is created you can present it with this code:

```swift
//If you are in a UIViewController
InAppNotify.Show(announce, to: self)
```

### Interact with notification

When you create an announcement, you can interact with it passed an action callback:

```swift
//Inside initialization of announcement
action: { (type, string, announcement) in
                
  //You can detect the action by test "type" var     
  if type == CallbackType.tap{
    print("User has been tapped")
  }else if type == CallbackType.text{
    print("Reply from notification: \(string!)")
  }else{
    print("Notification has been closed!")
  }
  
}
```

From the callbacak you can access the announcement object that has been triggered this method, announcement has a particolar attribute called "userInfo" (it's of type "Any") that you can set when create object, and read here.

If you want to enable a textField interaction when pull down notification, pass this parameter to announcement object:

```swift
//Inside initialization of announcement
interactionType : InteractionType.text,
```

This will present a textArea where user can write! to modify the text button ("send" by default) use this code:

```swift
InAppNotify.sendString = "Send"
```

To read user input, if you have set an action callback, test if the type is "text" and access string variable:

```swift
//Inside callback
if type == CallbackType.text{
    print("Reply from notification: \(string!)")
}
```

### Customization

InAppNotify supports themes, by default we have two themes, accessibile from "Themes" class:

- Themes.dark
- Themes.light

To use a theme you have to set a global variable of the library, example:

```swift
//Set dark theme
InAppNotify.theme = Themes.dark
```

Of course, you can create your custom theme programmatically, here an example:

```swift
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
```
## Projects using InAppNotify

- Frind - [www.frind.it](https://www.frind.it) 

### Your App and InAppNotify
I'm interested in making a list of all projects which use this library. Feel free to open an Issue on GitHub with the name and links of your project; we'll add it to this site.

## Credits & License
InAppNotify is owned and maintained by [Luca Becchetti](http://www.lucabecchetti.com) 

As open source creation any help is welcome!

The code of this library is licensed under MIT License; you can use it in commercial products without any limitation.

The only requirement is to add a line in your Credits/About section with the text below:

```
In app notification by InAppNotify - http://www.lucabecchetti.com
Created by Becchetti Luca and licensed under MIT License.
```
## About me

I am a professional programmer with a background in software design and development, currently developing my qualitative skills on a startup company named "[Frind](https://www.frind.it) " as Project Manager and ios senior software engineer.

I'm high skilled in Software Design (10+ years of experience), i have been worked since i was young as webmaster, and i'm a senior Php developer. In the last years i have been worked hard with mobile application programming, Swift for ios world, and Java for Android world.

I'm an expert mobile developer and architect with several years of experience of team managing, design and development on all the major mobile platforms: iOS, Android (3+ years of experience).

I'm also has broad experience on Web design and development both on client and server side and API /Networking design. 

All my last works are hosted on AWS Amazon cloud, i'm able to configure a netowrk, with Unix servers. For my last works i configured apache2, ssl, ejabberd in cluster mode, Api servers with load balancer, and more.

I live in Assisi (Perugia), a small town in Italy, for any question, [contact me](mailto:luca.becchetti@brokenice.it)

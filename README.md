# InAppNotify - Manage in App notifications
<p align="center" >
  <img src="https://user-images.githubusercontent.com/16253548/28424204-4c36af46-6d6d-11e7-95df-0cb4582093d7.png" width=400px alt="InAppNotify" title="InAppNotify">
</p>

[![Version](https://img.shields.io/badge/pod-0.1.2-blue.svg)](https://cocoapods.org/pods/InAppNotify) [![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://cocoapods.org/pods/InAppNotify) [![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://cocoapods.org/pods/InAppNotify) [![Swift3](https://img.shields.io/badge/swift3-compatible-brightgreen.svg)](https://cocoapods.org/pods/InAppNotify)

During delevoping of my app [Frind](http://www.frind.it), I needed to manage in app notifications like whatsapp or telegram, but i didn't find nothing that liked me, so, i created this library. Choose InAppNotify for your next project, I'll be happy to give you a little help!

<p align="center" >★★ <b>Star our github repository to help us!</b> ★★</p>
<p align="center" >Created by <a href="https://github.com/lucabecchetti">Luca Becchetti</a></p>


## Screenshots

<p align="center" >
<img src="https://user-images.githubusercontent.com/16253548/28425722-74d8b1e8-6d71-11e7-9183-c5a7a8d519fe.png" width="33%">
<img src="https://user-images.githubusercontent.com/16253548/28425724-75042ea4-6d71-11e7-86fe-99651fa85a8a.png" width="33%">
<img src="https://user-images.githubusercontent.com/16253548/28425723-7500587e-6d71-11e7-8447-80c5302e44b6.png" width="33%">
</p>


## Requirements

  - iOS 8+
  - swift 3.0
  
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
//In you are in a UIViewController
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
//In you are in a UIViewController
InAppNotify.Show(announce, to: self)
```

### Interact with notification

When you create an announcement, you can interact with it passed an action callback:

```swift
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


## Credits & License
InAppNotify is owned and maintained by [Luca Becchetti](https://github.com/lucabecchetti) 

As open source creation any help is welcome!

The code of this library is licensed under MIT License; you can use it in commercial products without any limitation.

The only requirement is to add a line in your Credits/About section with the text below:

```
In app notification by InAppNotify - https://github.com/lucabecchetti
Created by Becchetti Luca and licensed under MIT License.
```

## Your App and SwiftDate
I'm interested in making a list of all projects which use this library. Feel free to open an Issue on GitHub with the name and links of your project; we'll add it to this site.

[![KR8OS](https://github.com/kr8os/ios-sdk/blob/master/Example/KR8OS/Assets.xcassets/KR8OS.imageset/Image.png?raw=true)](http://www.kr8os.com)
# iOS SDK
* **[Overview](#overview)**
* **[Requirements](#requirements)**
* **[Installation](#installation)**
  * [CocoaPods](#cocoapods)
* **[Usage](#usage)**
  * [Code Implementation](#code-implementation)
* [License](#license)

## Overview

This SDK integrates KR8OS into your iOS apps to track new app installations. To learn more about KR8OS and how it can accurately track advertising attributions, please visit [www.KR8OS.com](http://www.kr8os.com).

## Requirements
* Xcode 9.
* iOS 8 or higher.
* An AppID from [www.KR8OS.com](https://watson.kr8os.com/apps/create).

## Installation
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate KR8OS into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'KR8OS'
```

Then, run the following command:

```bash
$ pod install
```

## Usage
### Code Implementation
At the top of your App Delegate, import KR8OS:
```swift
import KR8OS
```

Next, add the following to your App Delegate's `didFinishLaunchingWithOptions` method:
``` swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    // Note: if you differentiate between debug and release build of your app, please use KR8OS.registerInstall(appId: "YOUR_APP_ID_HERE", debug: true)
    KR8OS.registerInstall(appId: "YOUR APP ID HERE")

    return true
}
```

## License

This KR8OS iOS SDK is available under the MIT license. See the LICENSE file for more info.

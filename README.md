![VirtuozSDK](https://raw.githubusercontent.com/MagieFactory/virtuoz-sdk/refs/heads/main/doc/images/banner%402x.png)

# Virtuoz iOS SDK

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/MagieFactory/virtuoz-sdk/blob/main/LICENSE)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMagieFactory%2Fvirtuoz-sdk%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/MagieFactory/virtuoz-sdk)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FMagieFactory%2Fvirtuoz-sdk%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/MagieFactory/virtuoz-sdk)

The Virtuoz iOS SDK enables you to integrate the Virtuoz experience into your native iOS and iPadOS apps.

This Swift library notifies you when a user clicks on Virtuoz and lets you trigger vibrations on the device as needed.

- [Virtuoz iOS SDK](#virtuoz-ios-sdk)
  - [🚀 Getting Started](#-getting-started)
    - [Installation](#installation)
      - [Swift Package Manager](#swift-package-manager)
      - [XCFramework](#xcframework)
    - [One Time Setup](#one-time-setup)
      - [Initializing the SDK](#initializing-the-sdk)
   	  - [Configuring the SDK](#configuring-the-sdk)
	- [Usage](#usage)
      - [Listening to events](#listening-to-events)
   	  - [Triggering actions](#triggering-actions)
  - [🎬 Examples](#-examples)
  - [📄 License](#-license)

## 🚀 Getting Started

### Installation

Add the Virtuoz iOS SDK package to your app. There are several supported installation options.

#### Swift Package Manager

Add the Swift package as a dependency to your project in Xcode:

1. In Xcode, open your project and navigate to **File** → **Add Packages…**
2. Enter the package URL `https://github.com/MagieFactory/virtuoz-sdk`
3. For **Dependency Rule**, select **Up to Next Major Version**
4. Click **Add Package**

Alternatively, if your project has a `Package.swift` file, you can add Virtuoz iOS SDK to your dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/MagieFactory/virtuoz-sdk", from: "1.0.0"),
]
```

#### XCFramework

An XCFramework is attached with each [release](https://github.com/MagieFactory/virtuoz-sdk/releases).

1. Download `VirtuozSDK.xcframework.zip` attached to the [latest release](https://github.com/MagieFactory/virtuoz-sdk/releases) and unzip.
2. In Xcode, open your project and navigate to **File** → **Add Files to "\<Project\>"…**
3. Find the XCFramework in the file navigator and select it
4. Ensure the option to "Copy items if needed" is checked and that your app's target is selected
5. Click **Add**
6. Select your project in the **Project navigator**, select your app target and then the **General** tab. Under **Frameworks, Libraries, and Embedded Content**, set VirtuozSDK.xcframework to **Embed & Sign**

### One Time Setup

After installing the package, you can reference Virtuoz iOS SDK by importing the package with `import VirtuozSDK`.

#### Initializing the SDK

The Virtuoz iOS SDK instance can be used at any time (behind the scenes, a singleton ensures only one instance exists). Linking Virtuoz to your app requires following several steps.

1. Create a custom URL scheme for your app if you haven't already. The SDK uses this scheme to handle navigation between Virtuoz and your app. You can find [a tutorial](https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app#register-your-url-scheme) on the Apple website
2. Virtuoz SDK must handle fallback URL in application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool method:

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
   return VirtuozManager.shared.handleUrl(url)
}
```

#### Configuring the SDK

After setting up the SDK, you will need to configure it based on your needs.

```swift
let configuration = VirtuozSDK.Configuration(urlScheme: "YOUR_URL_SCHEME://", enableLogs: true, killAppOnLongPress: false)
VirtuozManager.shared.setup(with: configuration)
```

The `Configuration` struct allows you to customize how VirtuozSDK handles various options:
- `urlScheme` must match the value defined in the [Initializing the SDK](#initializing-the-sdk) section.
- `enableLogs` controls debug logging in the console. You can disable this in production.
- `killAppOnLongPress` tells the Virtuoz SDK to close the app automatically when the user long-presses Virtuoz.

Next, call the `connect` method to initiate pairing between Virtuoz and your app.

```swift
VirtuozManager.shared.connect(onSuccess: {
	print("✅ Connection with Virtuoz app is complete!")
}, onError: { 
	print("🚫 There was an error while linking your app 😢")
})
```

### Usage

#### Listening to events

Conforming a class to the `VirtuozManagerDelegate` will notify you when events occur on Virtuoz.

```swift
VirtuozManager.shared.delegate = self
```

Here is the list of delegate methods:
- `virtuozHasBeenUnpaired()` notifies when the Virtuoz is unpaired from the Virtuoz app.
- `virtuozStateUpdated(state: VirtuozSDK.PeripheralState)` notifies when the Virtuoz connects or disconnects.
- `virtuozHasAnUpdateAvailable()` notifies when a Virtuoz update is available. You can then redirect to Virtuoz using the `redirectToVirtuoz()` method from the VirtuozManager instance.
- `virtuozBatteryLevelUpdated(value: Int, image: UIImage?)` notifies when the battery level changes (with its corresponding status image).
- `virtuozDidPress()` notifies when Virtuoz is pressed.
- `virtuozDidLongPress()` notifies when Virtuoz is long-pressed.

You can see all these delegate methods implemented in the demo application in the Example folder.

#### Triggering actions

Access information and trigger actions in your app through the same VirtuozManager instance.

- `linkedVirtuozName` returns the name of the currently linked Virtuoz device.
- `redirectToVirtuoz()` opens the Virtuoz app if necessary.
- `triggerVibration()` sends an immediate vibration command to the connected Virtuoz device.

## 🎬 Example

The `Example` directory in repository contains full example iOS app demonstrating how to integrate Virtuoz SDK in a project.

## 📄 License

This project is licensed under the MIT License. See [LICENSE](https://github.com/MagieFactory/virtuozsdk/blob/main/LICENSE) for more information.
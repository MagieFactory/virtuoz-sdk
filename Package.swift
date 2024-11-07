// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "virtuoz-sdk",
    platforms: [
        .iOS(.v15) // iOS version target
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VirtuozSDK",
            targets: ["VirtuozSDK"]),
    ],
    targets: [
        // The destination of the framework you will obfuscate the code
        .binaryTarget(
            name: "VirtuozSDK",
            path: "./Sources/VirtuozSDK.xcframework"
        )
    ]
)

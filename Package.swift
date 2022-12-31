// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "snowswift",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "snowswift",
            targets: ["snowswift"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "3.0.0"),
    ],
    targets: [
        .target(
            name: "snowswift",
            dependencies: [.product(name: "Crypto", package: "swift-crypto")]),
        .testTarget(
            name: "snowswiftTests",
            dependencies: ["snowswift"]),
    ]
)

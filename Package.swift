// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TwitterPublishPlugin",
	platforms: [
		.macOS(.v12),
	],
    products: [
        .library(
            name: "TwitterPublishPlugin",
            targets: ["TwitterPublishPlugin"]
        ),
    ],
    dependencies: [
		.package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "TwitterPublishPlugin",
            dependencies: ["Publish"]
        ),
        .testTarget(
            name: "TwitterPublishPluginTests",
            dependencies: ["TwitterPublishPlugin"]
        ),
    ]
)

// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "NetworkProvider",
  platforms: [
    .macOS(.v10_13), .iOS(.v11), .tvOS(.v11),
  ],
  products: [
    .library(
      name: "NetworkProvider",
      targets: ["NetworkProvider"]
    ),
  ],
  dependencies: [
  ],
  targets: [
    .target(
      name: "NetworkProvider",
      dependencies: []
    ),
    .testTarget(
      name: "NetworkProviderTests",
      dependencies: ["NetworkProvider"]
    ),
  ]
)

// swift-tools-version: 6.1
// Copyright (c) 2025 Schubert Anselme <schubert@anselm.es>
// SPDX-Licence-Identifier: GPL-3.0

import PackageDescription

let package = Package(
  name: "cli-swift-template",
  platforms: [.macOS(.v15)],

  // MARK: - Dependencies

  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
    .package(url: "https://github.com/apple/swift-container-plugin", from: "1.0.0"),
    .package(url: "https://github.com/elegantchaos/Versionator.git", from: "2.0.2"),
    .package(url: "https://github.com/orlandos-nl/Citadel.git", from: "0.10.0"),
    .package(url: "https://github.com/Zollerboy1/SwiftCommand.git", from: "1.4.1"),
  ],

  // MARK: - Targets

  targets: [
    .executableTarget(
      name: "cli",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Citadel", package: "citadel"),
        .product(name: "SwiftCommand", package: "swiftcommand"),
      ],
      swiftSettings: [
        .enableExperimentalFeature("StrictConcurrency=complete"),
        .enableExperimentalFeature("StrictMemorySafety")
      ],
      plugins: [
        .plugin(name: "VersionatorPlugin", package: "Versionator")
      ],
    ),
  ],
)

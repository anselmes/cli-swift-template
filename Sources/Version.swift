// Copyright (c) 2025 Schubert Anselme <schubert@anselm.es>
// SPDX-Licence-Identifier: GPL-3.0

import ArgumentParser

struct VersionInfo {
  static var version: String { VersionatorVersion.full }
  private static var longVersion: String {
    return """
    Current build is \(VersionatorVersion.build)
    Current commit is \(VersionatorVersion.commit)
    Git describe is \(VersionatorVersion.git)
    """
  }

  // MARK: - Arguments & Flags

  @Flag
  var long = false
}

// MARK: - Command

extension VersionInfo: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "version",
    abstract: "Prints the version information.",
    discussion: "This command prints the current version of the CLI service.",
  )

  // MARK: - Entrypoint

  func run() async {
    if long {
      print(Self.longVersion)
    } else {
      print(Self.version)
    }
  }
}

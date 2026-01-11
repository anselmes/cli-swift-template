// Copyright (c) 2025 Schubert Anselme <schubert@anselm.es>
// SPDX-Licence-Identifier: GPL-3.0

import Foundation

import ArgumentParser

@main
struct Entrypoint: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "cli",
    abstract: "A CLI service template in Swift.",
    version: VersionInfo.version,
    subcommands: [
      Exec.self,
      RemoteExec.self,
      VersionInfo.self,
    ],
  )
}

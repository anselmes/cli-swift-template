// Copyright (c) 2025 Schubert Anselme <schubert@anselm.es>
// SPDX-Licence-Identifier: GPL-3.0

import ArgumentParser
import SwiftCommand

struct Exec {
  // MARK: - Arguments & Flags

  @Argument(help: "The command to execute.")
  var cmd: String

  @Argument(help: "Arguments for the command.")
  var args: [String] = []

  // MARK: - Error

  enum Error: Swift.Error {
    case failedCommand
  }
}

// MARK: - Command

extension Exec: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "exec",
    abstract: "Executes a command in the shell.",
    discussion: "This command runs a specified shell command and prints its output.",
  )

  // MARK: - Entrypoint

  func run() async {
    do {
      let output = try await Command.findInPath(withName: cmd)!
                                    .addArguments(args)
                                    .output
      print(output.stdout)
    } catch {
      _ = CleanExit.message(Error.failedCommand.localizedDescription)
    }
  }
}

// MARK: - Custom String

extension Exec.Error: CustomStringConvertible {
  var errorDescription: String? { return description }
  var description: String {
    switch self {
    case .failedCommand:
      return "The command execution failed."
    }
  }
}

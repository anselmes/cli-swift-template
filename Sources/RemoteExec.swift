// Copyright (c) 2025 Schubert Anselme <schubert@anselm.es>
// SPDX-Licence-Identifier: GPL-3.0

import ArgumentParser
import Citadel

struct RemoteExec {
  // MARK: - Arguments & Flags

  @Option(name: .shortAndLong, help: "The username to use for SSH authentication.")
  var username: String = "admin"

  @Argument(help: "The host to connect to.")
  var host = "localhost"

  @Argument(help: "The command to execute on the remote host.")
  var cmd = "ls -lh ~"

  // MARK: - Error

  enum Error: Swift.Error {
    case failedCommand
  }
}

// MARK: - Command

extension RemoteExec: AsyncParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "remote",
    abstract: "Run remote commands via SSH",
    discussion: "This command allows you to execute commands on a remote server using SSH.",
    aliases: ["ssh", "rsh"],
  )

  // MARK: - Entrypoint

  func run() async {
    do {
      let client = try await SSHClient.connect(
        host: "localhost",
        authenticationMethod: .ed25519(username: username, privateKey: .init()),
        hostKeyValidator: .acceptAnything(),
        reconnect: .never,
      )

      let answer = try await client.executeCommandPair(cmd)
      for try await blob in answer.stdout {
        print(blob)
      }

      let streams = try await client.executeCommandStream("ls -lh ~")
      for try await event in streams {
        switch event {
          case .stdout(let output):
            print(output)
          case .stderr(let error):
            print(error)
        }
      }
    } catch {
      _ = CleanExit.message(RemoteExec.Error.failedCommand.localizedDescription)
    }
  }
}

// MARK: - Custom String

extension RemoteExec.Error: CustomStringConvertible {
  var errorDescription: String? { return description }
  var description: String {
    switch self {
    case .failedCommand:
      return "The command execution failed."
    }
  }
}

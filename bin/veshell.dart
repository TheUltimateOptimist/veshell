import 'dart:io';

import 'package:args/command_runner.dart';

import 'build.dart';
import 'dependency/check_depencies.dart' as dependencies;

void main(List<String> arguments) {
  var runner = CommandRunner(
      "veshell_tool", "A suit of tools to help developping Veshell")
    ..addCommand(InstallCommand());

  runner.run(arguments).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64); // Exit code 64 indicates a usage error.
  });
}

class InstallCommand extends Command {
  @override
  final name = "install";
  @override
  final description = "Build and install Veshell localy";

  InstallCommand();

  // [run] may also return a Future.
  @override
  void run() async {
    await dependencies.check();
    await buildEmbedder();
    await buildShell();
    await packageBuild();
    await createSession();
  }
}

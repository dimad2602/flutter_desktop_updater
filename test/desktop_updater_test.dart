import "package:desktop_updater/desktop_updater.dart";
import "package:desktop_updater/desktop_updater_method_channel.dart";
import "package:desktop_updater/desktop_updater_platform_interface.dart";
import "package:flutter_test/flutter_test.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

class MockDesktopUpdaterPlatform
    with MockPlatformInterfaceMixin
    implements DesktopUpdaterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value("42");

  @override
  Future<void> restartApp() {
    return Future.value();
  }

  @override
  Future<String?> sayHello() {
    return Future.value();
  }

  @override
  Future<String?> getExecutablePath() {
    return Future.value();
  }

  @override
  Future<void> generateFileHashes({String? path}) {
    return Future.value();
  }

  @override
  Future<List<FileHashModel?>> verifyFileHash(
    String oldHashFilePath,
    String newHashFilePath,
  ) {
    return Future.value([]);
  }

  @override
  Future<void> updateApp({required String remoteUpdateFolder}) {
    return Future.value();
  }

  @override
  Future<String?> getCurrentVersion() {
    return Future.value();
  }

  @override
  Future<List<FileHashModel?>> prepareUpdateApp(
      {required String remoteUpdateFolder}) {
    return Future.value([]);
  }
}

void main() {
  final initialPlatform = DesktopUpdaterPlatform.instance;

  test("$MethodChannelDesktopUpdater is the default instance", () {
    expect(initialPlatform, isInstanceOf<MethodChannelDesktopUpdater>());
  });

  test("getPlatformVersion", () async {
    final desktopUpdaterPlugin = DesktopUpdater();
    final fakePlatform = MockDesktopUpdaterPlatform();
    DesktopUpdaterPlatform.instance = fakePlatform;

    expect(await desktopUpdaterPlugin.getPlatformVersion(), "42");
  });
}

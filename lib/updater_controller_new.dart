import "dart:async";

import "package:desktop_updater/desktop_updater.dart";
import "package:flutter/material.dart";

class DesktopUpdaterControllerNew extends ChangeNotifier {
  DesktopUpdaterControllerNew({
    required Uri? appArchiveUrl,
    this.localization,
  }) {
    if (appArchiveUrl != null) {
      try {
        init(appArchiveUrl);
      } catch (e) {
        debugPrint("init error $e");
      }
    }
  }

  DesktopUpdaterControllerNew? localization;
  DesktopUpdaterControllerNew? get getLocalization => localization;

  String? _appName;
  String? get appName => _appName;

  String? _appVersion;
  String? get appVersion => _appVersion;

  Uri? _appArchiveUrl;
  Uri? get appArchiveUrl => _appArchiveUrl;

  bool _needUpdate = false;
  bool get needUpdate => _needUpdate;

  bool _isMandatory = false;
  bool get isMandatory => _isMandatory;

  String? _folderUrl;

  UpdateProgress? _updateProgress;
  UpdateProgress? get updateProgress => _updateProgress;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  bool _isDownloaded = false;
  bool get isDownloaded => _isDownloaded;

  double _downloadProgress = 0;
  double get downloadProgress => _downloadProgress;

  double _downloadSize = 0;
  double? get downloadSize => _downloadSize;

  double _downloadedSize = 0;
  double get downloadedSize => _downloadedSize;

  List<FileHashModel?>? _changedFiles;

  List<ChangeModel?>? _releaseNotes;
  List<ChangeModel?>? get releaseNotes => _releaseNotes;

  bool _skipUpdate = false;
  bool get skipUpdate => _skipUpdate;

  final _plugin = DesktopUpdater();

  final _stateController =
      StreamController<DesktopUpdaterControllerNew>.broadcast();
  Stream<DesktopUpdaterControllerNew> get stream => _stateController.stream;

  void _emit() {
    try {
      notifyListeners();
      _stateController.add(this);
    } catch (e) {
      debugPrint("_emit error: $e");
    }
  }

  void init(Uri url) {
    try {
      _appArchiveUrl = url;
      checkVersion();
      _emit();
    } catch (e, st) {
      debugPrint("checkVersion error: $e\n$st");
    }
  }

  void makeSkipUpdate() {
    _skipUpdate = true;
    _emit();
  }

  Future<void> checkVersion() async {
    try {
      if (_appArchiveUrl == null) throw Exception("App archive URL is not set");

      final versionResponse = await _plugin.versionCheck(
        appArchiveUrl: appArchiveUrl.toString(),
      );

      if (versionResponse?.url != null) {
        _needUpdate = true;
        _folderUrl = versionResponse?.url;
        _isMandatory = versionResponse?.mandatory ?? false;
        _downloadSize = (versionResponse?.changedFiles?.fold<double>(
              0,
              (previousValue, element) =>
                  previousValue + ((element?.length ?? 0) / 1024.0),
            )) ??
            0.0;
        _changedFiles = versionResponse?.changedFiles;
        _releaseNotes = versionResponse?.changes;
        _appName = versionResponse?.appName;
        _appVersion = versionResponse?.version;

        print("Need update: $_needUpdate");

        _emit();
      }
    } catch (e) {
      debugPrint("check version error = $e");
    }
  }

  Future<void> downloadUpdate() async {
    try {
      if (_folderUrl == null) {
        throw Exception("Folder URL is not set");
      }

      if (_changedFiles == null && _changedFiles!.isEmpty) {
        throw Exception("Changed files are not set");
      }

      final stream = await _plugin.updateApp(
        remoteUpdateFolder: _folderUrl!,
        changedFiles: _changedFiles ?? [],
      );

      stream.listen(
        (event) {
          _updateProgress = event;
          _isDownloading = true;
          _isDownloaded = false;
          _downloadProgress = event.receivedBytes / event.totalBytes;
          _downloadedSize = _downloadSize * _downloadProgress;
          notifyListeners();
          _emit();
        },
        onDone: () {
          _isDownloading = false;
          _downloadProgress = 1.0;
          _downloadedSize = _downloadSize;
          _isDownloaded = true;

          notifyListeners();
          _emit();
        },
      );
    } catch (e) {
      debugPrint("downloadUpdate error = $e");
    }
  }

  void restartApp() {
    _plugin.restartApp();
  }

  @override
  void dispose() {
    _stateController.close();
    super.dispose();
  }
}

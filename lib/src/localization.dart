/// Localization for the update card texts,
/// There are 5 texts that can be localized:
///
/// - updateAvailableText
/// - newVersionAvailableText
/// - newVersionLongText
/// - restartText
/// - restartWarningText
/// - warningCancelText
/// - warningConfirmText
class DesktopUpdateLocalization {
  /// constructor
  const DesktopUpdateLocalization({
    this.updateAvailableText,
    this.newVersionAvailableText,
    this.newVersionLongText,
    this.restartText,
    this.warningTitleText,
    this.restartWarningText,
    this.warningCancelText,
    this.warningConfirmText,
    this.skipThisVersionText,
    this.downloadText,
  });

  /// Default: "Update available"
  final String? updateAvailableText;

  /// Default: "{} {} is available"
  ///
  /// ie: Appname 1.0.1 is available
  final String? newVersionAvailableText;

  /// Default: "New version is ready to download, click the button below to start downloading. This will download {} MB of data."
  ///
  /// "New version is ready to download, click the button below to start downloading. This will download 35.34 MB of data."
  final String? newVersionLongText;

  /// Default: "Restart to update"
  final String? restartText;

  /// Default: "Are you sure?"
  final String? warningTitleText;

  /// Default: "A restart is required to complete the update installation.\nAny unsaved changes will be lost. Would you like to restart now?"
  final String? restartWarningText;

  /// Default: "Not now"
  final String? warningCancelText;

  /// Default: "Restart"
  final String? warningConfirmText;

  /// Default: "Skip this version"
  final String? skipThisVersionText;

  /// Default: "Download"
  final String? downloadText;
}

String? getLocalizedString(String? key, List<dynamic> args) {
  for (var i = 0; i < args.length; i++) {
    key = key?.replaceFirst("{}", args[i].toString());
  }
  return key;
}

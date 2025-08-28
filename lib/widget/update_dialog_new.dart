import "package:desktop_updater/desktop_updater.dart";
import "package:desktop_updater/updater_controller_new.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

//TODO: Добавить локализацию
class UpdateDialogListenerNew extends StatefulWidget {
  const UpdateDialogListenerNew({
    super.key,
    required this.controller,
    this.backgroundColor,
    this.iconColor,
    this.shadowColor,
    this.textColor,
    this.buttonTextColor,
    this.buttonIconColor,
  });

  final DesktopUpdaterControllerNew controller;

  /// The background color of the dialog. if null, it will use Theme.of(context).colorScheme.surfaceContainerHigh,
  final Color? backgroundColor;

  /// The color of the icon. if null, it will use Theme.of(context).colorScheme.primary,
  final Color? iconColor;

  /// The color of the shadow. if null, it will use Theme.of(context).shadowColor,
  final Color? shadowColor;

  /// The color of the text. if null, it will use Theme.of(context).colorScheme.onSurface,
  final Color? textColor;

  /// The color of the button text. if null, it will use Theme.of(context).colorScheme.primary,
  final Color? buttonTextColor;

  /// The color of the button icon. if null, it will use Theme.of(context).colorScheme.primary,
  final Color? buttonIconColor;

  @override
  State<UpdateDialogListenerNew> createState() =>
      _UpdateDialogListenerNewState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<DesktopUpdaterControllerNew>(
        "controller",
        controller,
      ),
    );
    properties.add(ColorProperty("backgroundColor", backgroundColor));
    properties.add(ColorProperty("iconColor", iconColor));
    properties.add(ColorProperty("shadowColor", shadowColor));
    properties.add(ColorProperty("buttonTextColor", buttonTextColor));
    properties.add(ColorProperty("buttonIconColor", buttonIconColor));
    properties.add(ColorProperty("textColor", textColor));
  }
}

class _UpdateDialogListenerNewState extends State<UpdateDialogListenerNew> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        debugPrint("UpdateDialogListener: ${widget.controller.needUpdate}");
        if (((widget.controller.needUpdate) == false) ||
            (widget.controller.skipUpdate) ||
            widget.controller.isDownloading) {
          return const SizedBox();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            showDialog(
              context: context,
              barrierDismissible: widget.controller.isMandatory == false,
              builder: (context) {
                return UpdateDialogWidgetNew(
                  controller: widget.controller,
                  backgroundColor: widget.backgroundColor,
                  iconColor: widget.iconColor,
                  shadowColor: widget.shadowColor,
                  textColor: widget.textColor,
                  buttonTextColor: widget.buttonTextColor,
                  buttonIconColor: widget.buttonIconColor,
                );
              },
            );
          });
        }
        return const SizedBox();
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<DesktopUpdaterControllerNew>(
        "controller",
        widget.controller,
      ),
    );
    properties.add(ColorProperty("backgroundColor", widget.backgroundColor));
    properties.add(ColorProperty("iconColor", widget.iconColor));
    properties.add(ColorProperty("shadowColor", widget.shadowColor));
  }
}

/// Shows an update dialog.
Future showUpdateDialog<T>(
  BuildContext context, {
  required DesktopUpdaterControllerNew controller,
  Color? backgroundColor,
  Color? iconColor,
  Color? shadowColor,
}) {
  return showDialog(
    context: context,
    // barrierDismissible: controller.isMandatory == false,
    builder: (context) {
      return UpdateDialogWidgetNew(
        controller: controller,
        backgroundColor: backgroundColor,
        iconColor: iconColor,
        shadowColor: shadowColor,
      );
    },
  );
}

/// A widget that shows an update dialog.
class UpdateDialogWidgetNew extends StatelessWidget {
  /// Creates an update dialog widget.
  const UpdateDialogWidgetNew({
    super.key,
    required DesktopUpdaterControllerNew controller,
    this.backgroundColor,
    this.iconColor,
    this.shadowColor,
    this.textColor,
    this.buttonTextColor,
    this.buttonIconColor,
  }) : notifier = controller;

  /// The controller for the update dialog.
  final DesktopUpdaterControllerNew notifier;

  /// The background color of the dialog. if null, it will use Theme.of(context).colorScheme.surfaceContainerHigh,
  final Color? backgroundColor;

  /// The color of the icon. if null, it will use Theme.of(context).colorScheme.primary,
  final Color? iconColor;

  /// The color of the shadow. if null, it will use Theme.of(context).shadowColor,
  final Color? shadowColor;

  /// The color of the text. if null, it will use Theme.of(context).colorScheme.onSurface,
  final Color? textColor;

  /// The color of the button text. if null, it will use Theme.of(context).colorScheme.primary,
  final Color? buttonTextColor;

  /// The color of the button icon. if null, it will use Theme.of(context).colorScheme.primary,
  final Color? buttonIconColor;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return ListenableBuilder(
          listenable: notifier,
          builder: (context, child) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              iconColor: iconColor,
              shadowColor: shadowColor,
              title: Text(
                notifier.getLocalization?.updateAvailableText ??
                    "Update Available",
                style: TextStyle(color: textColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${getLocalizedString(
                          notifier.getLocalization?.newVersionAvailableText,
                          [notifier.appName, notifier.appVersion],
                        ) ?? "${notifier.appName} ${notifier.appVersion} is available"}, "
                    "${getLocalizedString(
                          notifier.getLocalization?.newVersionLongText,
                          [
                            ((notifier.downloadSize ?? 0) / 1024)
                                .toStringAsFixed(2)
                          ],
                        ) ?? "New version ready, download size ~${((notifier.downloadSize ?? 0) / 1024).toStringAsFixed(2)} MB"}",
                    style: TextStyle(color: textColor),
                  ),

                  const SizedBox(height: 16),

                  // Прогресс загрузки
                  if (notifier.isDownloading && !notifier.isDownloaded) ...[
                    LinearProgressIndicator(value: notifier.downloadProgress),
                    const SizedBox(height: 8),
                    Text(
                      "${((notifier.downloadProgress) * 100).toInt()}% "
                      "(${((notifier.downloadedSize) / 1024).toStringAsFixed(2)} MB / "
                      "${((notifier.downloadSize ?? 0.0) / 1024).toStringAsFixed(2)} MB)",
                      style: TextStyle(fontSize: 12, color: textColor),
                    ),
                  ],
                  if (notifier.downloadError) ...[
                    //TODO: Локализация
                    const Text(
                      "Download failed. Please try again.",
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Кнопка перезапуска после загрузки
                  if (!notifier.isDownloading && notifier.isDownloaded)
                    Text(
                      notifier.getLocalization?.restartText ??
                          "Update downloaded. Please restart to apply.",
                      style: TextStyle(color: textColor),
                    ),
                ],
              ),
              actions: [
                if (notifier.downloadError)
                  TextButton.icon(
                    icon: Icon(Icons.refresh, color: buttonIconColor),
                    label:
                        Text("Retry", style: TextStyle(color: buttonTextColor)),
                    onPressed: notifier.downloadUpdate,
                  )
                else if (notifier.isDownloading && !notifier.isDownloaded)
                  TextButton.icon(
                    icon: const Icon(Icons.close),
                    label: Text(
                      notifier.getLocalization?.warningCancelText ?? "Cancel",
                      style: TextStyle(color: buttonTextColor),
                    ),
                    onPressed: notifier.makeSkipUpdate,
                  )
                else if (!notifier.isDownloading && notifier.isDownloaded)
                  TextButton.icon(
                    icon: const Icon(Icons.restart_alt),
                    label: Text(
                      notifier.getLocalization?.restartText ?? "Restart",
                      style: TextStyle(color: buttonTextColor),
                    ),
                    onPressed: notifier.restartApp,
                  )
                else ...[
                  if (!notifier.isMandatory)
                    TextButton.icon(
                      icon: Icon(Icons.close, color: buttonIconColor),
                      label: Text(
                        notifier.getLocalization?.skipThisVersionText ??
                            "Skip this version",
                        style: TextStyle(color: buttonTextColor),
                      ),
                      onPressed: notifier.makeSkipUpdate,
                    ),
                  TextButton.icon(
                    icon: Icon(Icons.download, color: buttonIconColor),
                    label: Text(
                      notifier.getLocalization?.downloadText ?? "Download",
                      style: TextStyle(color: buttonTextColor),
                    ),
                    onPressed: notifier.downloadUpdate,
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<DesktopUpdaterControllerNew>("notifier", notifier),
      )
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(ColorProperty("iconColor", iconColor))
      ..add(ColorProperty("shadowColor", shadowColor))
      ..add(ColorProperty("buttonTextColor", buttonTextColor))
      ..add(ColorProperty("buttonIconColor", buttonIconColor))
      ..add(ColorProperty("textColor", textColor));
  }
}

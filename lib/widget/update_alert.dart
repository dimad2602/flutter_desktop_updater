import "package:desktop_updater/updater_controller.dart";
import "package:desktop_updater/updater_controller_new.dart";
import "package:desktop_updater/widget/update_dialog.dart";
import "package:desktop_updater/widget/update_dialog_new.dart";
import "package:flutter/material.dart";

class UpdateAlert extends StatefulWidget {
  const UpdateAlert({
    super.key,
    required this.controller,
    this.backgroundColor,
    this.iconColor,
    this.shadowColor,
    this.textColor,
    this.buttonTextColor,
    this.buttonIconColor,
    this.child,
    this.navigatorKey,
  });

  final DesktopUpdaterControllerNew controller;

  final Color? backgroundColor;
  final Color? iconColor;
  final Color? shadowColor;
  final Color? textColor;
  final Color? buttonTextColor;
  final Color? buttonIconColor;

  final GlobalKey<NavigatorState>? navigatorKey;
  final Widget? child;

  @override
  State<UpdateAlert> createState() => _UpdateAlertState();
}

class _UpdateAlertState extends State<UpdateAlert> {
  bool displayed = false;

  @override
  Widget build(BuildContext context) {
    print('Building UpdateAlert with StreamBuilder');

    return StreamBuilder<DesktopUpdaterControllerNew>(
      stream: widget.controller.stream,
      initialData: widget.controller,
      builder: (context, snapshot) {
        final ctrl = snapshot.data ?? widget.controller;

        debugPrint("UpdateAlert: needUpdate=${ctrl.needUpdate}, "
            "skipUpdate=${ctrl.skipUpdate}, "
            "isDownloading=${ctrl.isDownloading}, "
            "displayed=$displayed");

        if ((ctrl.skipUpdate || !ctrl.needUpdate) && displayed) {
          final checkContext = widget.navigatorKey?.currentContext ?? context;
          if (checkContext.mounted) {
            Navigator.of(checkContext, rootNavigator: true).pop();
          }
          displayed = false;
        }

        // если нужно открыть окно
        if (ctrl.needUpdate &&
            !ctrl.skipUpdate &&
            !ctrl.isDownloading &&
            !displayed) {
          displayed = true;

          final checkContext = widget.navigatorKey?.currentContext ?? context;

          Future.microtask(() {
            if (!mounted || !checkContext.mounted) return;

            showDialog(
              context: checkContext,
              barrierDismissible: ctrl.isMandatory == false,
              builder: (context) {
                return UpdateDialogWidgetNew(
                  controller: ctrl,
                  backgroundColor: widget.backgroundColor,
                  iconColor: widget.iconColor,
                  shadowColor: widget.shadowColor,
                  textColor: widget.textColor,
                  buttonTextColor: widget.buttonTextColor,
                  buttonIconColor: widget.buttonIconColor,
                );
              },
            ).then((_) {
              displayed = false;
            });
          });
        }

        return widget.child ?? const SizedBox.shrink();
      },
    );
  }
}

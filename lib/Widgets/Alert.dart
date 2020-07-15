import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class InfoAlert extends StatelessWidget {
  final Widget child;
  const InfoAlert({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _buildAlartDialog(context);
      },
      child: child,
    );
  }

  FutureOr<bool> _buildAlartDialog(BuildContext context) async {
    return showPlatformDialog<bool>(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(
          'Info',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text("This feature will be implemented soon, stay tuned."),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText('OK'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }
}

import 'package:app_customizer/app_customizer.dart';
import 'package:flutter/material.dart';

class AppCustomizer extends StatefulWidget {
  final Customizer customizer;
  final DeviceConfig deviceConfig;
  final DimenInitializer dimen;
  final ColorTheme theme;
  final Widget child;

  const AppCustomizer({
    super.key,
    required this.customizer,
    required this.deviceConfig,
    required this.dimen,
    required this.theme,
    required this.child,
  });

  @override
  State<AppCustomizer> createState() => _AppCustomizerState();
}

class _AppCustomizerState extends State<AppCustomizer> {
  @override
  void initState() {
    super.initState();
    widget.customizer.createInstance();
    widget.deviceConfig.createInstance();
    widget.dimen.createInstance();
    widget.theme.createInstance();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

import 'package:app_customizer/app_customizer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    AppCustomizer(
      customizer: Customizer(
        customizers: [
          const CustomizerConfigData<Alignment>(
            name: "box",
            config: CustomizerConfig(
              mobile: Customizers(
                primary: Alignment.center,
              ),
            ),
          ),
        ],
      ),
      deviceConfig: const DeviceConfig(),
      dimen: Dimen(
        dimens: [],
      ),
      theme: ColorTheme(
        themeMode: ThemeMode.light,
        scaffold: const ColorThemeConfig(
          light: ThemeColors(
            primary: Colors.green,
          ),
          dark: ThemeColors(
            primary: Colors.red,
          ),
        ),
        colors: [],
        gradients: [],
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP CUSTOMIZER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: context.primary),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldColor.primary,
      body: ResponsiveLayout(
        builder: (context, device) {
          return Container(
            alignment: context.customizerOf<Alignment>("box").primary,
            width: context.sizes.large,
            height: context.sizes.large,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(context.corners.medium),
              border: Border.all(
                color: context.backgroundColor.primary ?? Colors.black,
                width: context.strokes.normal,
              ),
            ),
            child: Text(
              "$device",
              style: TextStyle(
                fontSize: context.fontSizes.medium,
                fontWeight: context.fontWeights.bold.fontWeight,
              ),
            ),
          );
        },
      ),
    );
  }
}

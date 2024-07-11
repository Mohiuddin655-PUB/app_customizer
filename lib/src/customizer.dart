import 'package:flutter/material.dart';
import 'package:flutter_device_config/config.dart';

class Customizers<T extends Object?> {
  final T? primary;
  final T? secondary;
  final T? tertiary;

  const Customizers({
    this.primary,
    this.secondary,
    this.tertiary,
  });
}

typedef CustomizerConfigs<T extends Object?>
    = Map<String, CustomizerConfig<T>?>;

class CustomizerConfig<T extends Object?> {
  final Customizers<T> mobile;
  final Customizers<T>? _watch;
  final Customizers<T>? _tablet;
  final Customizers<T>? _laptop;
  final Customizers<T>? _desktop;
  final Customizers<T>? _tv;

  Customizers<T> get watch => _watch ?? mobile;

  Customizers<T> get tablet => _tablet ?? mobile;

  Customizers<T> get laptop => _laptop ?? tablet;

  Customizers<T> get desktop => _desktop ?? laptop;

  Customizers<T> get tv => _tv ?? desktop;

  const CustomizerConfig({
    required this.mobile,
    Customizers<T>? tablet,
    Customizers<T>? laptop,
    Customizers<T>? desktop,
    Customizers<T>? watch,
    Customizers<T>? tv,
  })  : _laptop = laptop,
        _tablet = tablet,
        _desktop = desktop,
        _watch = watch,
        _tv = tv;

  Customizers<T> detect(DeviceType type) {
    switch (type) {
      case DeviceType.watch:
        return watch;
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.laptop:
        return laptop;
      case DeviceType.desktop:
        return desktop;
      case DeviceType.tv:
        return tv;
    }
  }
}

class CustomizerConfigData<T extends Object?> {
  final String name;
  final CustomizerConfig<T> config;

  const CustomizerConfigData({
    required this.name,
    required this.config,
  });
}

class Customizer {
  final DeviceConfig? _config;
  final DeviceType? _type;
  final CustomizerConfigs _configs = {};

  static Customizer? _i;

  static Customizer get i {
    if (_i != null) {
      return _i!;
    } else {
      throw UnimplementedError("Customizer not initialized yet!");
    }
  }

  static CustomizerConfig<T>? of<T extends Object?>(String name) {
    final x = _i?._configs[name];
    if (x is CustomizerConfig<T>) return x;
    return null;
  }

  static void init({
    DeviceConfig? deviceConfig,
    DeviceType? deviceType,
    final Iterable<CustomizerConfigData> customizers = const [],
  }) {
    _i = Customizer._(
      deviceType: deviceType,
      deviceConfig: deviceConfig,
      customizers: customizers,
    );
  }

  Customizer._({
    DeviceConfig? deviceConfig,
    DeviceType? deviceType,
    final Iterable<CustomizerConfigData> customizers = const [],
  })  : _config = deviceConfig,
        _type = deviceType {
    if (customizers.isNotEmpty) {
      _configs.addEntries(customizers.map((e) => MapEntry(e.name, e.config)));
    }
  }

  Customizer({
    DeviceConfig? deviceConfig,
    DeviceType? deviceType,
    final Iterable<CustomizerConfigData> customizers = const [],
  }) : this._(
          customizers: customizers,
          deviceType: deviceType,
          deviceConfig: deviceConfig,
        );

  void createInstance() => _i = this;

  Device _device(Size size) {
    final x = _config ?? DeviceConfig.i;
    if (_type != null) return x.deviceFromType(_type!);
    return x.device(size.width, size.height);
  }
}

extension CustomizerHelper on BuildContext {
  Size get _size => MediaQuery.sizeOf(this);

  Device get _device => Customizer.i._device(_size);

  Customizers<T> customizerOf<T extends Object?>(String name) {
    final device = _device;
    final x = Customizer.of<T>(name)?.detect(device.type);
    if (x != null) return x;
    throw UnimplementedError("Customizers<$T> not initialized yet!");
  }
}

import 'package:flutter/material.dart';

import 'ui/splash.dart';
import 'ui/style/theme.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Anotações',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.temaClaro,
      darkTheme: AppTheme.temaEscuro,
      themeMode: ThemeMode.system,
      home: Splash(),
    ),
  );
}

import 'package:flutter/material.dart';

import 'colors.dart';

abstract class AppTheme {
  static ThemeData temaClaro = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.c5,
    primaryColor: AppColors.c1,
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.c5,
      scrimColor: AppColors.c2,
    ),
    iconTheme: IconThemeData(color: AppColors.c1),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.c1,
      foregroundColor: AppColors.c5,
      shape: const CircleBorder(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.c1,
      foregroundColor: AppColors.c5,
      titleTextStyle: const TextStyle(
        color: AppColors.c5,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'RedLipstick',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.c1,
        foregroundColor: AppColors.c5,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'RedLipstick',
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.c5,
      titleTextStyle: const TextStyle(
        color: AppColors.c1,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'RedLipstick',
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.c1,
        fontSize: 16,
        fontFamily: 'RedLipstick',
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: AppColors.c1,
      iconColor: AppColors.c2,
      style: ListTileStyle.list,
      titleTextStyle: const TextStyle(
        color: AppColors.c1,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'RedLipstick',
      ),
    ),
  );

  static ThemeData temaEscuro = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppColors.c1,
    primaryColor: AppColors.c5,
    drawerTheme: DrawerThemeData(
      backgroundColor: AppColors.c1,
      scrimColor: AppColors.c5,
    ),
    iconTheme: IconThemeData(color: AppColors.c5),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.c5,
      foregroundColor: AppColors.c1,
      shape: const CircleBorder(),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.c5,
      foregroundColor: AppColors.c1,
      titleTextStyle: const TextStyle(
        color: AppColors.c1,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        fontFamily: 'RedLipstick',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.c5,
        foregroundColor: AppColors.c1,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'RedLipstick',
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.c1,
      titleTextStyle: const TextStyle(
        color: AppColors.c5,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'RedLipstick',
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.c5,
        fontSize: 16,
        fontFamily: 'RedLipstick',
      ),
    ),
    listTileTheme: ListTileThemeData(
      textColor: AppColors.c5,
      iconColor: AppColors.c4,
      style: ListTileStyle.list,
      titleTextStyle: const TextStyle(
        color: AppColors.c5,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: 'RedLipstick',
      ),
    ),
  );
}

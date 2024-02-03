import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utils.dart';

class EasyLocalizationCacheManager {
  const EasyLocalizationCacheManager._();

  static const String _localeStorageName = "alghwalbi_easy_localization_locale";
  static const String _supportedLocalesStorageName =
      "alghwalbi_easy_suporte_locales";

  static Future<String?> getLocaleFromStorage() async {
    try {
      return (await SharedPreferences.getInstance())
          .getString(_localeStorageName);
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error retrieving locale from storage: $e");
      return null;
    }
  }

  static Future<void> clearLocaleFromStorage() async {
    try {
      (await SharedPreferences.getInstance()).remove(_localeStorageName);
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error clearing locale from storage: $e");
    }
  }

  static Future<void> saveLocaleToStorage(Locale? locale) async {
    try {
      (await SharedPreferences.getInstance())
          .setString(_localeStorageName, locale?.languageCode ?? "");
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error saving locale to storage: $e");
    }
  }

  static Future<void> saveSupportedLocalesToStorage(
      {required Iterable<Locale> supportedLocales}) async {
    try {
      (await SharedPreferences.getInstance()).setStringList(
        _supportedLocalesStorageName,
        supportedLocales.map((e) => e.languageCode).toList(),
      );
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error saving supported locales to storage: $e");
    }
  }

  static Future<Iterable<Locale>?> getSupportedLocalesFromStorage() async {
    try {
      List<String>? stringSupportedLocales =
          (await SharedPreferences.getInstance())
              .getStringList(_supportedLocalesStorageName);
      if (stringSupportedLocales == null) return null;
      return stringSupportedLocales.map((e) => Locale(e)).toList();
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error retrieving supported locales from storage: $e");
      return null;
    }
  }
}

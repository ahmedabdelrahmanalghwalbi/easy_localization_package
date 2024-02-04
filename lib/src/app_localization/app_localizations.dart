import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/easy_localization_cache_manager.dart';
import '../utils/utils.dart';

class AppLocalizations {
  final Locale locale;
  static Iterable<Locale>? locales;
  AppLocalizations({required this.locale}) {
    Future.delayed(Duration.zero, () async {
      locales =
          await EasyLocalizationCacheManager.getSupportedLocalesFromStorage();
    });
  }

  //getter to get supported locales that stored in locale storage
  static Iterable<Locale>? get supportedLocales => locales;

  //define delegate as variable
  static LocalizationsDelegate<AppLocalizations> delegate =
      const _AppLocalizationDelegate();

  //intialize of(context) method that provide instance from AppLocalization Class depends on the current (context)
  //to access on AppLocalization from the current context.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  //create and load the correct json data file depends on the current locale to provide it to all application
  late Map<String, String> _localeLanguageStrings;
  Future<void> loadLocaleLanguage() async {
    try {
      //first load the correct json file depend on the current picked locale
      String jsonString = await rootBundle
          .loadString("assets/easy_localizations/${locale.languageCode}.json");
      //decode jsonString that comes from the json file of the locale
      Map<String, dynamic> jsonStringToMap = jsonDecode(jsonString);
      //finaly mapping the jsonStringToMap to Map<String,String> to assert it to _localeLanguageStrings
      _localeLanguageStrings =
          jsonStringToMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (ex) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error loading locale language: $ex");
    }
  }

  // this mehtod take the key of String and return the translation on if
  String translate({required String key}) => _localeLanguageStrings[key] ?? key;
}

//make delegate of out AppLocalizations class
class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    // Check if the locale's language code is supported
    return (((AppLocalizations.supportedLocales?.map((e) => e.languageCode))
                ?.contains(locale.languageCode)) ??
            false) ||
        (locale.languageCode == 'ar');
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations appLocalizations = AppLocalizations(locale: locale);
    await appLocalizations.loadLocaleLanguage();
    return appLocalizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    // Set it to true if you want to force a reload of the localized resources
    return false;
  }
}

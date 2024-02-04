import 'package:alghwalbi_easy_localization/src/app_localization/app_localizations.dart';
import 'package:alghwalbi_easy_localization/src/localization_cubit/localization_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:alghwalbi_easy_localization/src/utils/utils.dart';

//extension to make use of the translate method in simple, profissional way.
extension TransEx on String {
  String trans(BuildContext context) {
    return AppLocalizations.of(context)?.translate(key: this) ?? this;
  }
}

class EasyLocalizationHelper {
  const EasyLocalizationHelper._();

  /// Get supported locales to provide to MaterialApp [supportedLocales] property.
  static Iterable<Locale> easyLocalizationSupportedLocals(
      {required BuildContext context}) {
    try {
      return BlocProvider.of<LocalizationCubit>(context).locales;
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error getting supported locales: $e");
      return [];
    }
  }

  /// Get necessary localization delegates to provide to MaterialApp [localizationsDelegates] property.
  static List<LocalizationsDelegate<dynamic>>
      get easyLocalizationLocalizationsDelegates {
    try {
      return [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AppLocalizations.delegate,
      ];
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error getting localization delegates: $e");
      return [];
    }
  }

  /// Resolve the locale based on device locale, supported locales, and cached locale.
  static Locale? easyLocalizationLocaleResolutionCallback(
      {required Locale? deviceLocale,
      required Iterable<Locale> supportedLocales,
      required BuildContext context}) {
    try {
      // If the cached locale is null, return the device locale if it's supported, else return the first supported locale.
      if (BlocProvider.of<LocalizationCubit>(context).state.locale == null) {
        return (deviceLocale != null &&
                supportedLocales
                    .map((e) => e.languageCode)
                    .contains(deviceLocale.languageCode))
            ? deviceLocale
            : supportedLocales.first;
      }
      // If the cached locale is not null, use the cached locale.
      return BlocProvider.of<LocalizationCubit>(context).state.locale;
    } catch (e) {
      Utils.showDebugErrorMessage(errorMessage: "Error resolving locale: $e");
      return null;
    }
  }

  /// Get the current locale.
  static Locale? easyLocalizationLocale(BuildContext context) {
    try {
      return BlocProvider.of<LocalizationCubit>(context).state.locale;
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error getting current locale: $e");
      return null;
    }
  }

  /// Change the locale within the application.
  static Future<void> easyLocalizationChangeLocale(
      {Locale? newLocale, required BuildContext context}) async {
    try {
      await BlocProvider.of<LocalizationCubit>(context)
          .changeLocaleAndUpdateItInChache(newLocale);
    } catch (e) {
      Utils.showDebugErrorMessage(errorMessage: "Error changing locale: $e");
    }
  }
}

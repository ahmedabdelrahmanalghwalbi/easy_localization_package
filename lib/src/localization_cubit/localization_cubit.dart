import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../controllers/easy_localization_cache_manager.dart';
import '../utils/utils.dart';
part 'localization_cubit_state.dart';

class LocalizationCubit extends Cubit<_LocalizationCubitState> {
  final Iterable<Locale> locales;
  LocalizationCubit({required this.locales})
      : super(const _LocalizationCubitState(locale: null)) {
    try {
      //call updating locale here
      getLocaleFromChacheAndEmitIt();
    } catch (ex) {
      Utils.showDebugErrorMessage(
          errorMessage:
              "Error getting locale from cache and emit it in Constructor: $ex");
    }
  }

  //get locale from the cache and emitting it to cubit
  Future<void> getLocaleFromChacheAndEmitIt() async {
    try {
      String? chachedLanguageCode =
          await EasyLocalizationCacheManager.getLocaleFromStorage();
      emit(_LocalizationCubitState(
          locale: chachedLanguageCode != null
              ? Locale(chachedLanguageCode)
              : null));
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error getting locale from cache: $e");
      // Handle the error appropriately, such as emitting a default state or showing an error message.
      emit(const _LocalizationCubitState(locale: null));
    }
  }

  //change locale (and update it in chahce)
  Future<void> changeLocaleAndUpdateItInChache(Locale? newLocale) async {
    try {
      // Save the new locale in the cache
      if (newLocale == null) {
        await EasyLocalizationCacheManager.clearLocaleFromStorage();
      } else {
        await EasyLocalizationCacheManager.saveLocaleToStorage(newLocale);
      }
      // Emit the new locale to the localization cubit to update the application locale
      emit(_LocalizationCubitState(locale: newLocale));
    } catch (e) {
      Utils.showDebugErrorMessage(
          errorMessage: "Error changing locale and updating cache: $e");
      // Handle the error appropriately, such as emitting the current state or showing an error message.
    }
  }
}

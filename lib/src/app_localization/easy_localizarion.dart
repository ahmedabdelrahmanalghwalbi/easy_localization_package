import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/easy_localization_cache_manager.dart';
import '../localization_cubit/localization_cubit.dart';

class EasyLocalization extends StatelessWidget {
  ///provide here your MaterialAppWidget then pass to it supported locals that provided by EasyLocalization Widget
  final Widget materialApp;

  ///provide here suported localizations,by default it will appling the device localization
  final Iterable<Locale> supportedLocals;

  EasyLocalization(
      {required this.materialApp, required this.supportedLocals, super.key}) {
    //save supported locales in local storage to use it inside isSupported in Applocalization Delegate
    Future.delayed(Duration.zero, () async {
      await EasyLocalizationCacheManager.saveSupportedLocalesToStorage(
          supportedLocales: supportedLocals);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocalizationCubit>(
      create: (_) => LocalizationCubit(locales: supportedLocals),
      child: materialApp,
    );
  }
}

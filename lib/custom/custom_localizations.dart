import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:i18n/custom/strings.dart';

///
/// 自定义多语言实现
///
/// Author: walker
/// Email: zhaocework@gmail.com
/// Date: 2022/4/14

///
/// 多语言资源类
class CustomLocalizations {
  final Locale locale;

  CustomLocalizations(this.locale);

  static CustomLocalizations of(BuildContext context) {
    return Localizations.of(context, CustomLocalizations);
  }

  static final Map<String, StringBase> _stringValues = {
    'zh': StringZh(),
    'en': StringEn(),
  };

  StringBase get strings =>
      _stringValues[locale.languageCode] ?? _stringValues.values.first;

  static const LocalizationsDelegate delegate = _CustomLocalizationsDelegate();

  static List<Locale> supportedLocales =
      _stringValues.keys.map((code) => Locale(code)).toList();

  static const List<LocalizationsDelegate> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];
}

///
/// 多语言代理
class _CustomLocalizationsDelegate
    extends LocalizationsDelegate<CustomLocalizations> {
  const _CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['zh', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<CustomLocalizations> old) => false;

  @override
  Future<CustomLocalizations> load(Locale locale) {
    return SynchronousFuture(CustomLocalizations(locale));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i18n/custom/custom_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// 多语言自定义实现
///
/// 支持应用内切换
///
/// Author: walker
/// Email: zhaocework@gmail.com
/// Date: 2022/4/14
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      onGenerateTitle: (context) =>
          CustomLocalizations.of(context).strings.tips,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: CustomLocalizations.localizationsDelegates,
      supportedLocales: CustomLocalizations.supportedLocales,
      locale: ref.watch(localeProvider),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              CustomLocalizations.of(context).strings.tips,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ref.read(localeProvider.notifier).switchToZH();
                  },
                  child: Text(
                    CustomLocalizations.of(context).strings.switchToZH,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(localeProvider.notifier).switchToEN();
                  },
                  child: Text(
                    CustomLocalizations.of(context).strings.switchToEN,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(localeProvider.notifier).followSystem();
                  },
                  child: Text(
                    CustomLocalizations.of(context)
                        .strings
                        .followSystemLanguage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// 状态保存
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(Locale locale) : super(locale);

  void switchToZH() {
    state = const Locale('zh');
    setPreferenceLocale(state);
  }

  void switchToEN() {
    state = const Locale('en');
    setPreferenceLocale(state);
  }

  void followSystem() {
    state = WidgetsBinding.instance!.window.locale;
    setPreferenceLocale(const Locale('system'));
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final locale = ref.watch(preferenceLocaleProvider).when(
        data: (locale) => locale,
        error: (_, __) => const Locale('zh'),
        loading: () => const Locale('zh'),
      );
  return LocaleNotifier(locale);
});

final preferenceLocaleProvider = FutureProvider<Locale>((ref) async {
  return await getPreferenceLocale();
});

// 数据持久化
const kLocaleKey = 'locale';

Future<Locale> getPreferenceLocale() async {
  final prefs = await SharedPreferences.getInstance();
  final value = prefs.getString(kLocaleKey);
  switch (value) {
    case 'system':
      return WidgetsBinding.instance!.window.locale;
    case 'en':
      return const Locale('en');
    default:
      return const Locale('zh');
  }
}

Future setPreferenceLocale(Locale locale) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(kLocaleKey, locale.languageCode);
}

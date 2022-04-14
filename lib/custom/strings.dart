///
/// 字符串资源
///
/// Author: walker
/// Email: zhaocework@gmail.com
/// Date: 2022/4/14
abstract class StringBase {
  String get helloWorld;
  String get tips;
}

class StringEn extends StringBase {
  @override
  String get helloWorld => 'Hello World';

  @override
  String get tips => 'You have pushed the button this many times:';
}

class StringZh extends StringBase {
  @override
  String get helloWorld => '你好世界!';

  @override
  String get tips => '你点击按钮的次数:';
}

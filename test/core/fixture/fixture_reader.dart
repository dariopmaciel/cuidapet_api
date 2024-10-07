import 'dart:convert';
import 'dart:io';

class FixtureReader {
  FixtureReader._();

  static String getJsonData(String path) =>
      File('test/$path').readAsStringSync();
  // { return File('test/$path').readAsString(); }

  // static Future<T> getData<T>(String path) async =>
  //     jsonDecode(await File('test/$path').readAsString());

  static Future<T> getData<T>(String path) async {
    final jsonString = await File('test/$path').readAsString();
    return jsonDecode(jsonString) as T;
    // {
    // final jsonString = await File('test/$path').readAsString();
    // return jsonDecode(jsonString);
    // }
  }
}

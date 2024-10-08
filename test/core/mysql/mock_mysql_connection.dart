import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';

class MockMySqlConnection extends Mock implements MySqlConnection {

  MockMySqlConnection() {
    when(() => close()).thenAnswer((_) async => _);
  }
}

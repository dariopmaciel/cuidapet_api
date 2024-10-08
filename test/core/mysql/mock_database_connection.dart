import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_mysql_connection.dart';
import 'mock_results.dart';

class MockDatabaseConnection extends Mock implements IDatabaseConnection {
  final mySqlConnection = MockMySqlConnection();

  MockDatabaseConnection() {
    when(() => openConnection()).thenAnswer((_) async => mySqlConnection);
  }
  void mockQuerry(MockResults mockResults, [List<Object>? params]) {
    when(() => mySqlConnection.query(any(), params ?? any()))
        .thenAnswer((_) async => mockResults);
  }
  void verifyConncectionClose(){
    verify(()=>mySqlConnection.close()).called(1);
  }
}

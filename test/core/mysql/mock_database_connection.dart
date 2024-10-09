import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:mocktail/mocktail.dart';
import 'mock_mysql_connection.dart';
import 'mock_mysql_exception.dart';
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

  void mockQueryException(
      [MockMysqlException? mockException, List<Object>? params]) {
    var exception = mockException;

    if (exception == null) {
      exception = MockMysqlException();
      //se não mandei uma excessão ele cria um mock de de uma exessão, coloca um erro qualquer nela
      when(() => exception!.message).thenReturn('Erro mysql generico');
    }
    //se mandei uma excessão com um erro qualquer recebe isto
    when(() => mySqlConnection.query(any(), params ?? any()))
        .thenThrow(exception);
  }

  void verifyConncectionClose() {
    verify(() => mySqlConnection.close()).called(1);
  }
}

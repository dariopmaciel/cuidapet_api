import 'dart:convert';
import 'package:cuidapet_api/application/database/i_database_connection.dart';
import 'package:cuidapet_api/application/exceptions/database_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_exists_exception.dart';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/cripty_helper.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/user_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mysql1/mysql1.dart';
import 'package:test/test.dart';
import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/mysql/mock_database_connection.dart';
import '../../../core/mysql/mock_mysql_exception.dart';
import '../../../core/mysql/mock_results.dart';

void main() {
  late IDatabaseConnection database;
  late ILogger log;
  // late MySqlConnection mySqlConnection;
  // late Results mySqlResult;
  // late ResultRow mySqlResultRow;

  setUp(
    () {
      database = MockDatabaseConnection();
      log = MockLogger();
      // mySqlConnection = MockMySqlConnection();
      // mySqlResult = MockResults();
      // mySqlResultRow = MockResultRow();
    },
  );

  group('Grupo Teste Find By ID', () {
    test('DEVE retornar um usuário por ID', () async {
      //preparação
      final userId = 1;

      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/find_by_id_sucess_fixture.json');
      // D:\01-DOCUMENTOS ADF\Documentos\ADF\Jornada Flutter\CuidaPet\cuidapet_api\test\modules\user\data\fixture\find_by_id_sucess_fixture.json

      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);
      final userRepository = UserRepository(connection: database, log: log);

      (database as MockDatabaseConnection).mockQuerry(mockResults);

      final userMap = jsonDecode(userFixtureDB);
      final userExpected = User(
          id: userMap['id'] as int,
          email: userMap['email'],
          registerType: userMap['tipo_cadastro'],
          iosToken: userMap['ios_token'],
          androidToken: userMap['android_token'],
          refreshToken: userMap['refresh_token'],
          imageAvatar: userMap['img_avatar'],
          supplierId: userMap['fornecedor_id']);

      // ----
      // when(() => mySqlConnection.close()).thenAnswer((_) async => _);
      // when(() => mySqlResult.first).thenReturn(mySqlResultRow);
      // when(() => mySqlResultRow['id']).thenReturn(51);
      // when(() => mySqlConnection.query(any(), any())).thenAnswer((_) async => mysqlResults);
      // when(() => mySqlResult.isEmpty).thenReturn(false);
      // when(() => database.openConnection()).thenAnswer((_) async => mySqlConnection);
      //Act
      final user = await userRepository.findById(userId);

      //Assert
      expect(user, isA<User>());
      expect(user, userExpected);
      // await Future.delayed(Duration(seconds: 1));
      (database as MockDatabaseConnection).verifyConncectionClose();
    });
    test('DEVE retornar EXCEPTION - Usuario Não encontrado - opção 1',
        () async {
      //Arrange
      final id = 1;
      final mockResults = MockResults();
      (database as MockDatabaseConnection).mockQuerry(mockResults, [id]);
      final userRepository = UserRepository(connection: database, log: log);
      //Act
      var call = userRepository.findById;
      //Assert
      expect(() => call(id), throwsA(isA<UserNotfoundException>()));
      await Future.delayed(Duration(seconds: 1));
      (database as MockDatabaseConnection).verifyConncectionClose();
    });
    test('DEVE retornar EXCEPTION - Usuario Não encontrado - opção 2',
        () async {
      //muito ruim
      //Arrange
      final id = 1;
      final mockResults = MockResults();
      (database as MockDatabaseConnection).mockQuerry(mockResults, [id]);
      final userRepository = UserRepository(connection: database, log: log);
      //Act
      try {
        await userRepository.findById(id);
      } catch (e) {
        if (e is UserNotfoundException) {
          // não fazer nada
        } else {
          fail('Exception errada, deveria retornar um usernotfound');
        }
      }
      //Assert
      // expect(() => call(id), throwsA(isA<UserNotfoundException>()));
      (database as MockDatabaseConnection).verifyConncectionClose();
    });
  });

  group('Grupo - Teste de Criação de Usuário', () {
    test('DEVE criar usuario com sucesso', () async {
      //Arrange
      final userId = 1;
      final mockResults = MockResults();

      when(() => mockResults.insertId).thenReturn(userId);
      (database as MockDatabaseConnection).mockQuerry(mockResults);

      final userInsert = User(
        email: 'dariodepaulamaciel@academiadoflutter.com.br',
        registerType: 'APP',
        imageAvatar: '',
        password: '123123',
        // supplierId: null,
        // socialKey: null,
      );
      final userExpected = User(
        id: userId,
        email: 'dariodepaulamaciel@academiadoflutter.com.br',
        registerType: 'APP',
        imageAvatar: '',
        password: '',
        // supplierId: null,
        // socialKey: null,
      );
      final userRepository = UserRepository(connection: database, log: log);
      //Act
      final user = await userRepository.createUser(userInsert);
      //Assert
      expect(user, userExpected);
    });

    test('DEVE retornar o DatabaseException', () async {
      //Arrange
      // final mockResults = MockResults();
      // final MySqlException exception = MockMysqlException();
      // when(() => exception.message).thenReturn('Erro mysql');

      // em "mock_database_conecction.dart" fiz classes utilitária
      (database as MockDatabaseConnection).mockQueryException();
      //Act
      var call = UserRepository(connection: database, log: log).createUser;
      //Assert
      expect(() => call(User()), throwsA(isA<DatabaseException>()));
    });

    test('DEVE retornar o UserExistsException', () async {
      final exception = MockMysqlException();

      when(() => exception.message).thenReturn('usuario.email_UNIQUE');

      (database as MockDatabaseConnection).mockQueryException(exception);
      //Act
      var call = UserRepository(connection: database, log: log).createUser;
      //Assert
      expect(() => call(User()), throwsA(isA<UserExistsException>()));
    });
  });

  group('Grupo Teste loginWithEmailAndPassword', () {
    test('Deve efetuar login com email e password', () async {
      //Arrange
      final userFixtureDB = FixtureReader.getJsonData(
          'modules/user/data/fixture/find_by_id_sucess_fixture.json');
      //entar no 'MockResults' e ver quais itens são passados
      final mockResults = MockResults(userFixtureDB, [
        'ios_token',
        'android_token',
        'refresh_token',
        'img_avatar',
      ]);

      final email = 'dariodepaulamaciel@hotmail.com';
      final password = '123123';
      (database as MockDatabaseConnection).mockQuerry(mockResults, [
        email,
        CriptyHelper.generateSha256Hash(password),
      ]);
      //Act

      //Assert
    });
  });
}

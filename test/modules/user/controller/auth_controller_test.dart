import 'dart:convert';
import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';

import 'package:cuidapet_api/modules/user/controller/auth_controller.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:dotenv/dotenv.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import '../../../core/fixture/fixture_reader.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';
import 'mock/mock_user_service.dart';

void main() {
  late IUserService userService;
  late ILogger log;
  late AuthController authController;
  late Request request;

  setUp(() async {
    userService = MockUserService();
    log = MockLogger();
    authController = AuthController(userService: userService, log: log);
    request = MockShelfRequest();
    DotEnv().load();
  });

  group('Grupo teste metodo de login', () {
    // test('Deve fazer login com sucesso', () async {
    //   //Arrange
    //   final loginRequestFixture = FixtureReader.getJsonData(
    //       'modules/user/controller/fixture/login_with_email_password_request.json');
    //   final loginRequestData = jsonDecode(loginRequestFixture);

    //   final email = loginRequestData['login'];
    //   final password = loginRequestData['password'];
    //   final supplierUser = loginRequestData['supplier_user'];

    //   when(() => request.readAsString())
    //       .thenAnswer((invocation) async => loginRequestFixture);

    //   when(() =>
    //           userService.loginWithEmailPassword(email, password, supplierUser))
    //       .thenAnswer((invocation) async => User(id: 1, email: email));
    //   //Act
    //   final response = await authController.login(request);
    //   //Assert
    //   final responseData = jsonDecode(await response.readAsString());

    //   expect(response.statusCode, 200);
    //   expect(responseData['access_token'], isNotEmpty);
    //   verify(() =>
    //           userService.loginWithEmailPassword(email, password, supplierUser))
    //       .called(1);
    //   verifyNever(
    //     () => userService.loginWithSocial(any(), any(), any(), any()),
    //   );
    // });

    test('Deve fazer retornar request validation exception on login', () async {
      //Arrange
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_password_request_validation_error.json');

      when(() => request.readAsString())
          .thenAnswer((invocation) async => loginRequestFixture);

      //Act
      final response = await authController.login(request);
      //Assert
      final responseData = jsonDecode(await response.readAsString());

      expect(response.statusCode, 400);
      expect(responseData['password'], 'required');
      verifyNever(
          () => userService.loginWithEmailPassword(any(), any(), any()));
      verifyNever(
        () => userService.loginWithSocial(any(), any(), any(), any()),
      );
    });

    test('Deve fazer retornar UserNotFoundException', () async {
      //Arrange
      final loginRequestFixture = FixtureReader.getJsonData(
          'modules/user/controller/fixture/login_with_email_password_request.json');
      final loginRequestData = jsonDecode(loginRequestFixture);

      final email = loginRequestData['login'];
      final password = loginRequestData['password'];
      final supplierUser = loginRequestData['supplier_user'];

      when(() => request.readAsString())
          .thenAnswer((invocation) async => loginRequestFixture);

      when(() =>
              userService.loginWithEmailPassword(email, password, supplierUser))
          .thenThrow(UserNotfoundException(message: 'Usuario Não encontrado'));

      //Act
      final response = await authController.login(request);
      //Assert

      expect(response.statusCode, 403);

      verify(() => userService.loginWithEmailPassword(email, password, supplierUser));
      verifyNever(
        () => userService.loginWithSocial(any(), any(), any(), any()),
      );
    });
  });

  group('Grupo de teste de loginSocial', () {
    test('Deve efetuar login com sucesso', () async {
      //Arrange
      
      //Act
      
      //Assert
      
    });
  });
}

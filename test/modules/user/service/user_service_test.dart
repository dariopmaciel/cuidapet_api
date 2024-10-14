import 'package:cuidapet_api/application/exceptions/user_notfound_exception.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/entities/user.dart';
import 'package:cuidapet_api/modules/user/data/i_user_repository.dart';
import 'package:cuidapet_api/modules/user/service/user_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../core/log/mock_logger.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late IUserRepository userRepository;
  late ILogger log;
  late UserService userService;

  setUp(() {
    userRepository = MockUserRepository();
    log = MockLogger();
    userService = UserService(userRepository: userRepository, log: log);
    registerFallbackValue(/* create a dummy instance of `User` */ User());
  });

  group('Grupo de teste loginWithEmailPassword', () {
    test('Deve efetuar login com email e password - Caminho Feliz', () async {
      //Arrange
      final id = 1;
      final email = 'dariopmaciel@gmail.com';
      final password = '123123';
      final supplierUser = false;
      final userMock = User(id: id, email: email);
      when(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).thenAnswer((_) async => userMock);
      //Act

      final user = await userService.loginWithEmailPassword(
          email, password, supplierUser);

      //Assert
      expect(user, userMock);
      verify(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).called(1);
    });
    test(
        'Deve efetuar login com email e password - and return UserNotFoundException',
        () async {
      //Arrange
      final email = 'dariopmaciel@gmail.com';
      final password = '123123';
      final supplierUser = false;

      when(() => userRepository.loginWithEmailPassword(
              email, password, supplierUser))
          .thenThrow(UserNotfoundException(message: 'Usuario não encontrado'));
      //Act

      final call = userService.loginWithEmailPassword;

      //Assert
      expect(() => call(email, password, supplierUser),
          throwsA(isA<UserNotfoundException>()));
      verify(() => userRepository.loginWithEmailPassword(
          email, password, supplierUser)).called(1);
    });
  });

  group('Grupo de teste loginWithSocial', () {
    test('Deve efetuar loginSocial with sucess - Caminho Feliz', () async {
      //Arrange
      final email = 'dariopmaciel@gmail.com';
      final socialKey = '123';
      final socialType = 'FACEBOOK';
      final userReturnLogin = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepository.loginByEmailSocialKey(
              email, socialKey, socialType))
          .thenAnswer((_) async => userReturnLogin);

      //Act
      final user =
          await userService.loginWithSocial(email, '', socialType, socialKey);

      //Assert

      expect(user, userReturnLogin);
      verify(() => userRepository.loginByEmailSocialKey(
          email, socialKey, socialType)).called(1);
    });

    test('Deve efetuar loginSocial with UserNotFound and create newUser',
        () async {
      //Arrange
      final email = 'dariopmaciel@gmail.com';
      final socialKey = '123';
      final socialType = 'FACEBOOK';
      final userCreated = User(
        id: 1,
        email: email,
        socialKey: socialKey,
        registerType: socialType,
      );

      when(() => userRepository.loginByEmailSocialKey(
              email, socialKey, socialType))
          .thenThrow(UserNotfoundException(message: 'Usuario não encontrado'));

      when(() => userRepository.createUser(any<User>()))
          .thenAnswer((_) async => userCreated);

      //Act
      final user =
          await userService.loginWithSocial(email, '', socialType, socialKey);

      //Assert

      expect(user, userCreated);
      verify(() => userRepository.loginByEmailSocialKey(
          email, socialKey, socialType)).called(1);
      verify(() => userRepository.createUser(         any())).called(1);
    });
  });
}
//await Future.delayed(Duration(microseconds: 100));
//(database as MockDatabaseConnection).verifyConncectionClose();
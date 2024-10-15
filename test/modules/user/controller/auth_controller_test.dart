import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/modules/user/controller/auth_controller.dart';
import 'package:cuidapet_api/modules/user/service/i_user_service.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import '../../../core/log/mock_logger.dart';
import '../../../core/shelf/mock_shelf_request.dart';
import 'mock/mock_user_service.dart';

void main() {
late IUserService userService;
late ILogger log;
late AuthController autController;
late Request request;

  setUp((){
    userService = MockUserService();
    log = MockLogger();
    autController = AuthController(userService: userService, log: log);
    request = MockShelfRequest();
  });

  group('Grupo ', () {
    test('Deve fazer login com sucesso', () async {
      //Arrange
      
      //Act
      
      //Assert
      
    });
  });

}
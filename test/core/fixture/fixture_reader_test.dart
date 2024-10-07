import 'dart:io';

import 'package:test/test.dart';

import 'fixture_reader.dart';

void main() {
  setUp(() {});

  test('Deve retornar um JSON', () async {
    //Arrange
    //Act
    final json =
        FixtureReader.getJsonData('core/fixture/fixture_reader_test.json');
    //Assert
    expect(json, allOf([isNotEmpty]));
  });

  test('Deve retornar um Map<String, dynamic>', () async {
    //Arrange
    //Act
    final data = await FixtureReader.getData<Map<String, dynamic>>(
        'core/fixture/fixture_reader_test.json');
    //Assert
    expect(data, allOf([isA<Map<String, dynamic>>()]));
    expect(data['id'], 1);
  });


  
  test('Deve retornar um List', () async {
    //Arrange
    //Act  //! >>>>>>>>>         TIPAR SEMPREE
    final data = await FixtureReader.getData<List>(
        'core/fixture/fixture_reader_list_test.json');
    //Assert
    expect(data, isA<List>());
    expect(data.isNotEmpty, isTrue);
    expect(data.isEmpty, isFalse);
    expect(data, isNotEmpty);
  });

  test('Deve retornar FileSystemException se arquivo não encontrado', () async {
    //Arrange
    
    //Act
    var call = FixtureReader.getData;
    //Assert
    expect( ()=> call('error.json'), throwsA(isA<FileSystemException>()));
  });
}

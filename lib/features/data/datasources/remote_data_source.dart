import '../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
  Future<NumberTriviaModel> getTrivia(String url);
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client _client;

  NumberTriviaRemoteDataSourceImpl(this._client);
  //http://numbersapi.com/random
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) {
    return getTrivia('http://numbersapi.com/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return getTrivia('http://numbersapi.com/random');
  }

  @override
  Future<NumberTriviaModel> getTrivia(String url) async {
    final response = await _client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    final resBody = json.decode(response.body);
    return response.statusCode == 200
        ? NumberTriviaModel.fromJson(resBody)
        : throw ServerException();
  }
}

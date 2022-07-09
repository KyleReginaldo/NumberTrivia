import 'dart:convert';

import '../../../core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const String CACHE_NUMBER_TRIVIA = "CACHE_NUMBER_TRIVIA";

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreference;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreference});
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreference.setString(
        CACHE_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final cacheString = sharedPreference.getString(CACHE_NUMBER_TRIVIA);
    return cacheString != null
        ? Future.value(NumberTriviaModel.fromJson(json.decode(cacheString)))
        : throw CacheException();
  }
}

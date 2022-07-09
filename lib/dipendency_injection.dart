import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:give_me_a_number/core/network/network_info.dart';
import 'package:give_me_a_number/core/utils/input_converter.dart';
import 'package:give_me_a_number/features/data/datasources/local_data_source.dart';
import 'package:give_me_a_number/features/data/datasources/remote_data_source.dart';
import 'package:give_me_a_number/features/data/repositories/number_trivia_repository_impl.dart';
import 'package:give_me_a_number/features/domain/repositories/number_trivia_repository.dart';
import 'package:give_me_a_number/features/domain/usecases/get_concrete_number_triviia.dart';
import 'package:give_me_a_number/features/domain/usecases/get_random_number_trivia.dart';
import 'package:give_me_a_number/features/presentation/bloc/number_trivia_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future init() async {
  //! features - number trivia
  //bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      sl(),
      sl(),
      sl(),
    ),
  );
  //usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  //repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      sl(),
      sl(),
      sl(),
    ),
  );
  //datasource
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreference: sl()));

  //! core
  //utils
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  //! external
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

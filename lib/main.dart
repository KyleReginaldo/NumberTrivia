import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/presentation/bloc/number_trivia_bloc.dart';
import 'dipendency_injection.dart' as dipendency;
import 'dipendency_injection.dart';
import 'features/presentation/screens/number_trivia_scree.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dipendency.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'give me a number',
      theme: ThemeData(
        primaryColor: Colors.pink,
        primarySwatch: Colors.pink,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.pink),
      ),
      home: BlocProvider<NumberTriviaBloc>(
        create: (context) => sl<NumberTriviaBloc>(),
        child: const NumberTriviaScreen(),
      ),
    );
  }
}

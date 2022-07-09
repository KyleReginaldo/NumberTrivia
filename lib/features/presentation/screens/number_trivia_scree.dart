import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:give_me_a_number/features/presentation/screens/history_screen.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ph.dart';

import '../../../dipendency_injection.dart';
import '../../domain/entities/number_trivia.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widget/loading_indicator.dart';
import '../widget/message_display.dart';
import '../widget/trivia_messhe.dart';

class NumberTriviaScreen extends StatefulWidget {
  const NumberTriviaScreen({Key? key}) : super(key: key);

  @override
  State<NumberTriviaScreen> createState() => _NumberTriviaScreenState();
}

class _NumberTriviaScreenState extends State<NumberTriviaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text("Number Trivia"),
            Iconify(
              Ph.number_square_zero_thin,
              color: Colors.white,
              size: 40,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider<NumberTriviaBloc>(
                        create: (context) => sl<NumberTriviaBloc>(),
                        child: HistoryScreen(
                          trivias: trivias,
                        ),
                      )));
            },
            icon: const Icon(Icons.history),
          ),
        ],
        elevation: 0,
      ),
      body: buildBody(context),
    );
  }
}

List<NumberTrivia> trivias = [];
BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
  return BlocProvider(
    create: (_) => sl<NumberTriviaBloc>(),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessaggeDisplay(
                      message: "Give me a number",
                    );
                  } else if (state is Loading) {
                    return const LoadingIndicator();
                  } else if (state is Loaded) {
                    trivias.add(state.numberTrivia);
                    return TriviaMessage(
                      numberTrivia: state.numberTrivia,
                    );
                  } else if (state is Error) {
                    return MessaggeDisplay(message: state.errormsg);
                  }
                  return Container();
                },
              ),
              const TriviaController(),
            ],
          ),
        ),
      ),
    ),
  );
}

class TriviaController extends StatefulWidget {
  const TriviaController({Key? key}) : super(key: key);

  @override
  State<TriviaController> createState() => _TriviaControllState();
}

class _TriviaControllState extends State<TriviaController> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a number',
            ),
            onSaved: (value) {
              dispatchConcrete(value ?? '');
            }),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  dispatchConcrete(controller.text);
                },
                child: const Text("Search"),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: dispatchRandom,
                child: const Text(
                  "Get random trivia",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void dispatchConcrete(String number) {
    if (number.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please input a number')));
    } else {
      BlocProvider.of<NumberTriviaBloc>(context)
          .add(GetTriviaForConcreteNumber(number));
      controller.clear();
    }
  }

  void dispatchRandom() {
    BlocProvider.of<NumberTriviaBloc>(context).add(
      GetTriviaForRandomNumber(),
    );
  }
}

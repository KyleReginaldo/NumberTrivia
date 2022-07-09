import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dipendency_injection.dart';
import '../bloc/number_trivia_bloc.dart';
import '../widget/loading_indicator.dart';
import '../widget/message_display.dart';
import '../widget/trivia_messhe.dart';

class NumberTriviaScreen extends StatelessWidget {
  const NumberTriviaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("give me a number"),
      ),
      body: buildBody(context),
    );
  }
}

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
                      message: "Start Searching!",
                    );
                  } else if (state is Loading) {
                    return const LoadingIndicator();
                  } else if (state is Loaded) {
                    return TriviaMessage(numberTrivia: state.numberTrivia);
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
        TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'input a number',
            ),
            onChanged: (value) {
              controller.text = value;
            },
            onSubmitted: (value) {
              dispatchConcrete(value);
            }),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () async {
                  dispatchConcrete(controller.text);
                },
                child: const Text("Search"),
              ),
            ),
            Expanded(
              child: TextButton(
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

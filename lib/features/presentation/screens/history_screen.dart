import 'package:flutter/material.dart';

import 'package:give_me_a_number/features/domain/entities/number_trivia.dart';
import 'package:give_me_a_number/features/presentation/screens/number_trivia_scree.dart';

class HistoryScreen extends StatefulWidget {
  final List<NumberTrivia> trivias;
  const HistoryScreen({
    Key? key,
    required this.trivias,
  }) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('History'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: trivias
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: Text(
                        e.number.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        e.text,
                      ),
                      tileColor: Colors.pink.shade400,
                      textColor: Colors.white,
                    ),
                  ),
                )
                .toList(),
          ),
        ));
  }
}

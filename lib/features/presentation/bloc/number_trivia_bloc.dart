import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:give_me_a_number/core/constants/failure_contants.dart';
import '../../../core/errors/failure.dart';
import '../../../core/usecases/usecase.dart';
import '../../../core/utils/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_triviia.dart';
import '../../domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
    this.getConcreteNumberTrivia,
    this.getRandomNumberTrivia,
    this.inputConverter,
  ) : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      emit(Loading());
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);
        await inputEither.fold(
          (l) async =>
              emit(Error(FailureConstants.INVALID_INPUT_FAILURE_MESSAGE)),
          (integer) async {
            emit(Loading());
            final concreteEither =
                await getConcreteNumberTrivia(Params(number: integer));
            concreteEither.fold((l) => emit(Error(_mapFailureToMessage(l))),
                (trivia) => emit(Loaded(trivia)));
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        final randomEither = await getRandomNumberTrivia(NoParams());
        randomEither.fold(
          (l) => emit(
            Error(_mapFailureToMessage(l)),
          ),
          (randomTrivia) => emit(
            Loaded(randomTrivia),
          ),
        );
      }
    });
  }
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return FailureConstants.SERVER__MESSAGE;
      case CacheFailure:
        return FailureConstants.CACHE_FAILURE;
      default:
        return 'unexpected error';
    }
  }
}

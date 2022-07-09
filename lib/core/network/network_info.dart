import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker connection;

  NetworkInfoImpl(this.connection);
  @override
  Future<bool> get isConnected async => await connection.hasConnection;
}

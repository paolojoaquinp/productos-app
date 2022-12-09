import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:formvalidation/src/bloc/validators.dart';

class LoginBloc with Validators{
  final _emailController = BehaviorSubject<String>();
  final _passWordController = BehaviorSubject<String>();

  // Recuperar los datos del Stream
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passWordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream =>
    CombineLatestStream.combine2(emailStream, passwordStream, (email, password) => true);


  // Insertar valores al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passWordController.sink.add;


  // Obtener el último valor ingresado a los streams
  String get email    => _emailController.value;
  String get password => _passWordController.value;

  dispose() {
    _emailController.close();
    _passWordController.close();
  }

}
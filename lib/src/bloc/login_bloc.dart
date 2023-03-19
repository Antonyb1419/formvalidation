

import 'dart:async';

import 'package:formvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

   final _emailController = BehaviorSubject<String>();
   final _passwordController = BehaviorSubject<String>();

   //Recuperar los datos al string

   Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
   Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

   Stream<bool> get formValidStream =>
   Rx.combineLatest2(emailStream, passwordStream , (e,p) => true);
   
   //Insertar valores al string

    Function (String) get changeEmail => _emailController.sink.add;
    Function (String) get changePassword => _passwordController.sink.add;

    //Obtener el ultimo va blor ingresado a los sreams

   String get email => _emailController.value.toString();
   String get password => _passwordController.value.toString();


   dispose(){
      _emailController?.close();
      _passwordController?.close();
    }


}
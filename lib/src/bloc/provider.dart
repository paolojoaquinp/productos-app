import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget {

  static Provider? _instancia;

  factory Provider({Key? key, Widget? child}) { 
    if(_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia as Provider;
  }

  Provider._internal({Key? key, Widget? child })
    : super(key: key, child: child as Widget);

  final loginBloc = LoginBloc();

/*   Provider({Key? key, Widget? child })
    : super(key: key, child: child as Widget); */

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>(aspect: Provider) as Provider).loginBloc;
  }
}
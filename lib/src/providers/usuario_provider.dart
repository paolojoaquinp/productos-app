import 'dart:convert';
import 'dart:io';
import 'package:formvalidation/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _firebaseToken = 'AIzaSyBjRft1USmxIan6FL8uNzzCIpZtpLu_Ddc';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String,dynamic>> login(String email, String password) async {
    final authData = <String,dynamic>{
      'email'            : email,
      'password'         : password,
      'returnSecureToken': true
    };
    final resp = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken'),
      body: jsonEncode(authData),
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if(decodedResp.containsKey('idToken')) {
      // Salvar el token en el storage del telefono
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token':decodedResp['idToken']};
    } else {
      return {'ok': false, 'message':decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(String email, String password) async {
    final authData = <String,dynamic>{
      'email'            : email,
      'password'         : password,
      'returnSecureToken': true
    };
    final resp = await http.post(
      Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'),
      body: jsonEncode(authData),
    );
    Map<String, dynamic> decodedResp = json.decode(resp.body);
    print(decodedResp);
    if(decodedResp.containsKey('idToken')) {
      // Salvar el token en el storage del telefono
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token':decodedResp['idToken']};
    } else {
      return {'ok': false, 'message':decodedResp['error']['message']};
    }
  }
}
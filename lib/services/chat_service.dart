import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/models/mensajes_response.dart';
import 'package:real_time_chat/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:real_time_chat/services/auth_service.dart';

class ChatService with ChangeNotifier {
 
  late Usuario usuarioPara;
 
  Future<List<Mensaje>> getChat(String usuarioID) async{
 
    String? token = await AuthService.getToken();
    final uri = Uri.parse('${ Environment.apiUrl }/mensajes/$usuarioID');
    final resp = await http.get(uri,
     headers: {
      'Content-Type': 'application/json',
      'x-token': token.toString()
    }
    );
   
    final mensajesResp = mensajesResponseFromJson(resp.body);
    
    return mensajesResp.mensajes;
 
 
  }
  
}
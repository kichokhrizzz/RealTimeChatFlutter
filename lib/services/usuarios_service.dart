
import 'package:http/http.dart' as http;
import 'package:real_time_chat/global/environment.dart';
import 'package:real_time_chat/models/usuario.dart';
import 'package:real_time_chat/models/usuarios_response.dart';
import 'package:real_time_chat/services/auth_service.dart';

class UsuariosService {

  Future<List<Usuario>> getUsuario() async {
    //obteniendo el token
    String? token = await AuthService.getToken();
    try {
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
          headers: {
            'Content-Type': 'application/json',
            'x-Token': token.toString()
          });
 
      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
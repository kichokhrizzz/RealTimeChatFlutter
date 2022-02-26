import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:real_time_chat/models/usuario.dart';
import 'package:real_time_chat/services/auth_service.dart';

class UsuariosPage extends StatefulWidget {


   
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(online: true, email: 'test1@gmail.com', nombre: 'Maria', uid: '1'),
    Usuario(online: false, email: 'test1@gmail.com', nombre: 'Jhosel', uid: '2'),
    Usuario(online: true, email: 'test1@gmail.com', nombre: 'Josue', uid: '3'),
    Usuario(online: true, email: 'test1@gmail.com', nombre: 'Itzel', uid: '4'),
    Usuario(online: false, email: 'test1@gmail.com', nombre: 'Karol', uid: '5'),
    Usuario(online: true, email: 'test1@gmail.com', nombre: 'Pedro', uid: '6'),
    Usuario(online: false, email: 'test1@gmail.com', nombre: 'Steve', uid: '7'),
    Usuario(online: true, email: 'test1@gmail.com', nombre: 'Gregory', uid: '8'),
  ];

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;

    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(usuario!.nombre, style: TextStyle(color: Colors.black87),),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.black87,),
          onPressed: (){
            Navigator.pushReplacementNamed(context ,'login');
            AuthService.deleteToken();
          },
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.wifi, color: Colors.blue[400],),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check, color: Colors.blue[400],),
          waterDropColor: Colors.blue,
        ),
        child: _listViewUsuarios(),
      )
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
      itemBuilder: (BuildContext context, int index) {
        return _usuarioListTile(usuarios[index]);
      },
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
          title: Text(usuario.nombre),
          subtitle: Text(usuario.email),
          leading: CircleAvatar(
            child: Text(usuario.nombre.substring(0,2)),
            backgroundColor: Colors.blue[100],
          ),
          trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: usuario.online ? Colors.green[300] : Colors.red,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        );
  }

  _cargarUsuarios() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
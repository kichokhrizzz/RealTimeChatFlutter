import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/models/mensajes_response.dart';
import 'package:real_time_chat/services/auth_service.dart';
import 'package:real_time_chat/services/chat_service.dart';
import 'package:real_time_chat/services/socket_service.dart';
import 'package:real_time_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
   
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;


  bool _estaEscribiendo = false;
  
  List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', (data) => _escucharMensaje(data));

    _cargarHistorial(this.chatService.usuarioPara.uid);

  }

  void _cargarHistorial( String usuarioID) async {
    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    final history = chat.map((m) => new ChatMessage(
      texto: m.mensaje, 
      uid: m.de, 
      animationController: new AnimationController(vsync: this, duration: Duration(milliseconds: 0))..forward()
      )
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload){
    //print('Tengo Mensaje! ${data}');
      ChatMessage message = new ChatMessage(texto: payload['mensaje'], uid: payload['de'], animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300)));
  
      setState(() {
        _messages.insert(0, message);
      });

      message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              child: Text(usuarioPara.nombre.substring(0,2), style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
            ),
            SizedBox(height: 3),
            Text(usuarioPara.nombre, style: TextStyle(color: Colors.black87, fontSize: 12),)
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return _messages[index] ;
                },
              ),
            ),
            Divider( height: 1),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat (){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto){
                  setState(() {
                    if(texto.trim().length > 0 )
                    {
                      _estaEscribiendo = true;
                    }
                    else
                    {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar mensaje'
                ),
                focusNode: _focusNode,
              ),
            ),
            //Boton de enviar
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: Platform.isIOS
              ? CupertinoButton(
                child: Text('Enviar'),
                onPressed: _estaEscribiendo
                ? () => _handleSubmit(_textController.text.trim())
                : null,
              )
              : Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                child: IconTheme(
                  data: IconThemeData(
                    color: Colors.blue[400]
                  ),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: Icon(Icons.send),
                    onPressed: _estaEscribiendo
                    ? () => _handleSubmit(_textController.text.trim())
                    : null,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto){
    
    if(texto.length == 0) return;

    //print(texto);
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(texto: texto, uid: authService.usuario!.uid, animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 200)));
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaEscribiendo = false;
    });

    this.socketService.emit('mensaje-personal',{
      'de': this.authService.usuario!.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje' : texto
    });

  }

  @override
  void dispose() {


    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }

    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }

}
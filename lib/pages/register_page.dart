import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/helper/mostrar_alerta.dart';
import 'package:real_time_chat/services/auth_service.dart';
import 'package:real_time_chat/widgets/boton_azul.dart';
import 'package:real_time_chat/widgets/custom_input.dart';
import 'package:real_time_chat/widgets/labels.dart';
import 'package:real_time_chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
   
  const RegisterPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {



    return  Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9 ,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Logo(titulo: 'Registro', img: 'assets/register.png'),
                _Form(),
                Labels(ruta: 'login', titulo: '¿Ya tienes una?', subTitulo: 'Ingresa ahora',),
                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({ Key? key }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.person, 
            placeholder: 'Nombre',
            keyboardType: TextInputType.text, 
            textController: nameCtrl
          ),
          CustomInput(
            icon: Icons.mail, 
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress, 
            textController: emailCtrl
          ),
          CustomInput(
            icon: Icons.lock,
            placeholder: 'Contraseña',
            isPassword: true,
            textController: passCtrl
          ),
          BotonAzul(
            text: 'Crear Cuenta',
             onPressed: authService.autenticando ? null : () async {
              final registroOk = await authService.register(nameCtrl.text.trim(), emailCtrl.text.trim(), passCtrl.text.trim());
             
              if(registroOk == true)
              {

                Navigator.pushReplacementNamed(context, 'usuarios');

              }
              else
              {
                mostrarAlerta(context, 'Registro Incorrecto', registroOk);
              }
             
             }
          )
        ],
      ),
    );
  }
}


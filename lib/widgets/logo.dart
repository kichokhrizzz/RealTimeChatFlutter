import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String titulo;
  final String img;

  const Logo({ Key? key, required this.titulo, required this.img }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Image(image: AssetImage(this.img)),
            SizedBox(height: 20,),
            Text(this.titulo, style: TextStyle(fontSize: 30),)
          ],
        ),
      ),
    );
  }
}
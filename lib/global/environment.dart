import 'dart:io';

class Environment {

  static String apiUrl = Platform.isAndroid ? 'http://192.168.0.9:3000/api' : 'htpp://localhost:3000/api' ;
  static String socketUrl = Platform.isAndroid ? 'http://192.168.0.9:3000' : 'htpp://localhost:3000' ;

}
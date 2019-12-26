import 'package:flutter/material.dart';

class AlertPage extends StatefulWidget {

  @override
  _AlertPageState createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final _textFieldController = TextEditingController();

  @override
  void dispose() { 
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              'assets/logo.jpeg',
              width: 250.0,
              height: 250.0,
            ),
            RaisedButton(
              child: Text("Iniciar Sesión"),
              color: Colors.black,
              textColor: Colors.white,
              shape: StadiumBorder(),
              onPressed: () => _mostrarAlerta(context),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 149, 162, 241),
    ); 
  }

  void _mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          title: Text("Iniciar sesión"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Introducir contraseña"),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("Ok"),
              //onPressed: (){ Navigator.pushNamed(context, "sounds");},
              onPressed: (){ _loggin(context, _textFieldController.text);},
            )
          ],
        );
      }
    );
  }

  void _loggin(BuildContext context, String textInput) {
    if(textInput == "password") {
      Navigator.pushNamed(context, "sounds");
    }
  }
}
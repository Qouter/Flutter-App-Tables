import 'package:flutter/material.dart';

import 'package:app_components/src/pages/alert_page.dart';
import 'package:app_components/src/providers/menu_provider.dart';
import 'package:app_components/src/utils/icono_string_util.dart';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Componentes"),
      ),
      body: _lista(),
    );
  }

  Widget _lista() {

    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: [],
      builder: ( context, AsyncSnapshot<List<dynamic>> snapshot) {


        return ListView(
          children: _listaItems(snapshot.data, context),
        );


      },
    );

  }

  List<Widget> _listaItems(List<dynamic> data, BuildContext context) {

    final List<Widget> opciones = [];

    data.forEach((opt) {
      final widgetTemp = ListTile(
        title: Text(opt["texto"]),
        leading: getIcon(opt["icon"]),
        trailing: Icon(Icons.keyboard_arrow_right, color: Colors.blue),
        onTap: () {
          /*
          final route = MaterialPageRoute(
            builder: (context) => AlertPage()
          );
          Navigator.push(context, route);
          */
          Navigator.pushNamed(context, opt["ruta"]);
        }
      );
      opciones..add(widgetTemp)
              ..add(Divider());
    });

    return opciones;

  }

}
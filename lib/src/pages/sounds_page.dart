import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:app_components/src/utils/sound_manager.dart';

class SoundsPage extends StatefulWidget {
  _SoundsPageState createState() => _SoundsPageState();
}

class TableResource extends SoundsPage{
  List<int> tablesList = [1];

  List <Widget> get tables {

    List<Widget> listTables = [];
    for (var table = 0; table < tablesList.length; table++) {
      final tempTable = ListTile(
        title: Text("Mesa "+tablesList[table].toString()),
        leading: Icon(Icons.av_timer),
        onTap: () => {},
      );
      listTables.add(tempTable);
    }
    return listTables;
  }

  List<int> getTableListInt() {
    return tablesList;
  }

  void addTable(BuildContext context, int table) {
    tablesList.add(table);
    Navigator.of(context).pop();
  }

  bool tableInListPenging(int table){
    for (var i = 0; i < tablesList.length; i++) {
      if(tablesList[i] == table) {
        return true;
      }
    }
    return false;
  }

  void deleteTableFromList(int table) {
    for (var i = 0; i < tablesList.length; i++) {
      if(tablesList[i] == table) {
        tablesList.removeAt(i);
      }
    }
  }
}

class _SoundsPageState extends State<SoundsPage> {

  TableResource _tableObject = new TableResource();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  SoundManager _soundManager = new SoundManager();
  Duration _valorSlider = Duration(seconds: 200);
  Duration _maxTimeinSound = Duration(seconds: 1);
  Duration _currentTimeinSound = Duration(seconds: 0);
  int _currentTable = 0;
  List <int> _tablesPending = [];
  List <Widget> _tablesPendingTile = [];
  bool showFab = true;
  String _playerState = "Waiting";
  int _playingTable;
  //User Variables
  int _numberOfTables = 99;
  int _secondsRepetitionCaller = 25;


  @override
  void initState() {
    _modalListener(context);
    _tablesListener(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20.0),
              child: Text("$_playerState"),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        elevation: 20.0,
        child: Container(
          child: ListView(
            padding: EdgeInsets.zero,
            children: _tableObject.tables,
          ),
          margin: const EdgeInsets.only(top: 80.0),
        ),
      ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                ///no.of items in the horizontal axis
                crossAxisCount: 14,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),

              ///Lazy building of list
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                    /// To convert this infinite list to a list with "n" no of items,
                    /// uncomment the following line:
                    index += 1;
                    return listItem(Colors.blue, index, context);
                  }, 
                  childCount: _numberOfTables,
                  ),
            )
          ],
        ),
        margin: const EdgeInsets.all(15.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (builder) {
              return Container(
                height: MediaQuery.of(context).size.height / 7,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      _crearSlider(),
                    ],
                  )
                ),
              );
            }
          );
        },
        child: Icon(Icons.expand_less),
      )
    );
  }

  Widget _crearSlider() {
    return Container(
      child: Slider(
        activeColor: Colors.indigoAccent,
        label: "Tamaño de la imagen = $_valorSlider",
        value: 70.0,
        min: 30.0,
        max: 400.0,
      ),
    );
  }

  Future _playAudio(int table, context) async {
    _currentTable = table;
    await _soundManager.playLocal("$table.mp3", context);
  }

  void _pauseAudio() {
    _soundManager.pauseLocal("$_currentTable.mp3");
  }

  void _tablesListener(BuildContext context) {
    Timer.periodic(Duration(seconds: _secondsRepetitionCaller), (Timer t) => {
      _callPendingTables(context)
    });

  }

  Future _callPendingTables(BuildContext context) async {
    List<int> listTable = _tableObject.getTableListInt();
    print("CALLING");
    if(listTable.length > 0) {
      for (var i = 0; i < listTable.length; i++) {
        //Logic to Know What table is playing
        await new Future.delayed(const Duration(seconds: 5));
        _playAudio(listTable[i], context);
        _playingTable = listTable[i];
        print("afterCall");
      }
    }
  }


  Widget listItem(Color color, int title, BuildContext context) => FlatButton(
    color: _setTableColor(title),
    child: Center(
      child: Text(
        "$title",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold),
      ),
    ),
    //onPressed: () => _playAudio(title, context),
    onPressed:  () => _tapInTable(context, title),
  );

  Color _setTableColor(int table) {
    if(_tableObject.tableInListPenging(table)) {
      return Colors.red;
    }
    else {
      return getRandomColor();
    }
  }

  void _tapInTable(BuildContext context,int table) {
    if(_tableObject.tableInListPenging(table)) {
      setState(() {
        _tableObject.deleteTableFromList(table);
      });
    }
    else {
      _showAlert(context, table);
    }
  }

  Color getRandomColor() {
    final random = Random();
    List<Color> listColors = [
      Colors.blue[300],
      Colors.blue[400],
      Colors.blue,
      Colors.blue[600],
      Colors.blue[700]
    ];

    return listColors[random.nextInt(listColors.length)];
  }

  void _modalListener(BuildContext context) {
    _soundManager.audioPlayer.onDurationChanged.listen((Duration d) {
      _maxTimeinSound = d;
    });
    _soundManager.audioPlayer.onAudioPositionChanged
        .listen((Duration d) => {_currentTimeinSound = d});
    _soundManager.audioPlayer.onPlayerStateChanged
        .listen((AudioPlayerState state) => {
          setTitle(state)
        });
  }

  void setTitle(state) {
    setState(() {
      print(state);
      if(state.toString() == "AudioPlayerState.PLAYING") {
        _playerState = "Llamando a mesa " + _playingTable.toString(); 
      }
      else {
        _playerState = "Esperando...";
      }
    });
  }

  void setCorrectPosition(Duration d) {
    //print(double.parse(d.toString()));
  }

  void _modalController(BuildContext context, AudioPlayerState state) {
    print("Estate $state");
    switch (state) {
      case AudioPlayerState.PLAYING:
        print("playing");
        print(_valorSlider);
        break;
      case AudioPlayerState.COMPLETED:
        print("completed");
        Navigator.of(context).pop();
        break;
      default:
    }
  }

  void _showAlert(BuildContext context, int table) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(20.0)),
          title: Text("Añadir"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Añadir mesa $table a la cola"),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: () => setState((){_tableObject.addTable(context, table);}),
            )
          ],
        );
      }
    );
  }

}

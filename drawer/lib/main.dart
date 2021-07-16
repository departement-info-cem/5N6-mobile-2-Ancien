import 'package:drawer/drawer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // On peut passer un objet au tiroir par exemple pour
  // l'utilisateur connecte
  String? _utilisateur = null; // ? signifie que la variable peut etre null

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiroir de nav'),
      ),
      // TODO rien n'empeche d'avoir des tiroirs differents pour chaque
      // ecran mais on utilise souvent le meme
      drawer: MonTiroir(nomUtilisateur: _utilisateur),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Text('connexion comme Bob'),
              onPressed: () {
                this._utilisateur = 'bob';
                //TODO c'est le setState qui met a jour l'UI et donc le tiroir
                setState(() {});
              }
            ),
            MaterialButton(
                child: Text('connexion comme Alice'),
                onPressed: () {
                  this._utilisateur = 'alice';
                  setState(() {});
                }
            ),
            MaterialButton(
                child: Text('deconnexion'),
                onPressed: () {
                  this._utilisateur = null;
                  setState(() {});
                }
            ),
          ],
        ),
      ),
    );
  }
}

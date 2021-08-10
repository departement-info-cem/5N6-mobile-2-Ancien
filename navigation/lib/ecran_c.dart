
import 'package:flutter/material.dart';

class EcranC extends StatefulWidget {

  // TODO comme le parametre est necessaire pour le widget, par exemple l'ID de
  // l'objet a affiché, on le met final ce qui garantit une assignation
  final String le_parametre;

  // TODO on specifie que le parametre est requis ici
  const EcranC({Key? key, required this.le_parametre}) : super(key: key);

  @override
  _EcranCState createState() => _EcranCState();
}

class _EcranCState extends State<EcranC> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ecran B'),
      ),
      // TODO widget. donne accès aux paramètres du widget
      body: Text('Tu as navigué vers B avec ' + widget.le_parametre),
    );
  }
}

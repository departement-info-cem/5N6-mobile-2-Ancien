
import 'package:flutter/material.dart';

class MonTiroir extends StatefulWidget {
  MonTiroir({Key? key, required this.nomUtilisateur}) : super(key: key);

  final String? nomUtilisateur;

  @override
  _MonTiroirState createState() => _MonTiroirState();
}

class _MonTiroirState extends State<MonTiroir> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: widget.nomUtilisateur == null ?
          // TODO si pas d'utilisateur connecte
      Container(
        color: const Color(0xAFFF0000), // Couleur en AARRGGBB
        child: Padding(
          padding: const EdgeInsets.all(58.0),
          child: Text('non connecte'),
        ),
      )
          :
      // TODO menu pour l'utilisateur
      ListView(
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  widget.nomUtilisateur!,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.house),
            title: Text("Accueil"),
            onTap: () {
              Navigator.of(context).pop();
              // TODO
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.add_rounded),
            title: Text("Ajout nouveau"),
            onTap: () {
              Navigator.of(context).pop();
              // TODO
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('paf'))
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.account_box),
            title: Text("Profil"),
            onTap: () {
              Navigator.of(context).pop();
              // TODO
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('paf'))
              );
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.exit_to_app),
            title: Text("Déconnexion"),
            onTap: () {
              Navigator.of(context).pop();
              // TODO
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('paf'))
              );
            },
          ),
        ],
      ),
    );
  }
}

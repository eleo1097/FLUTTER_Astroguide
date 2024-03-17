import 'package:flutter/material.dart';
import 'package:astroguide_flutter/services/user_service.dart';
import 'package:get_storage/get_storage.dart';
import 'editar_perfil.dart'; // Importa la pantalla de edición de perfil

import 'package:astroguide_flutter/theme/theme.dart';



class UserData {
  final String name;
  final String username;
  final String email;

  UserData({
    required this.name,
    required this.username,
    required this.email,
  });
}

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    var storage = GetStorage();
    var token = storage.read('token');
    final Future<UserData> userData = UserService.obtenerUsuarios(token);

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: FutureBuilder<UserData>(
        future: userData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final usuario = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Nombre: ${usuario!.name}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Nombre de usuario: ${usuario.username}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Correo electrónico: ${usuario.email}',
                    style: TextStyle(fontSize: 20.0),
                  ),

                  SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditarPerfil()),
                            );
                          },
                          child: const Text('Editar Perfil'),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),

                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Navegar a la pantalla de edición de perfil
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditarPerfil()),
                      );
                    },
                    child: Text('Editar perfil'),
                  ),

                ],
              ),
            );
          }
        },
      ),
    );
  }
}
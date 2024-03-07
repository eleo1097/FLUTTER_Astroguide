import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astroguide_flutter/services/lecciones_service.dart';
import 'menu.dart'; // Importa la primera página para la navegación

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const Lecciones());
}

class Lecciones extends StatelessWidget {
  const Lecciones({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecciones'),
      ),
      body: LeccionesList(),
    );
  }
}

class LeccionesList extends StatefulWidget {
  @override
  _LeccionesListState createState() => _LeccionesListState();
}

class _LeccionesListState extends State<LeccionesList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
       
      future: LeccionesService.obtenerLecciones(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<dynamic> leccionesData = snapshot.data ?? [];

          return Scrollbar(
     
           
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: leccionesData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeccionDetalle(
                          leccionData: leccionesData[index],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 5),
                          color:
                              Color.fromARGB(255, 104, 51, 155).withOpacity(.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Text(
                      leccionesData[index]['Nombre_de_la_leccion'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}

class LeccionDetalle extends StatelessWidget {
  final dynamic leccionData;

  const LeccionDetalle({Key? key, required this.leccionData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(leccionData['nombre'] ?? 'Detalle de la lección'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                  'Nombre de la lección: ${leccionData['Nombre_de_la_leccion'] ?? ''}'),
              SizedBox(height: 10),
              Text('Tipo de lección: ${leccionData['Tipo_de_leccion'] ?? ''}'),
              SizedBox(height: 10),
              Text('Contenido: ${leccionData['Contenido'] ?? ''}'),
            ],
          ),
        ),
      ),
    );
  }
}

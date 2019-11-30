import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final bd=Firestore.instance;

main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Estado();
  }
}

class Estado extends State{
  final txtMensaje = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 7, 94, 84),
            title: Text('Servicios en la nube'),
            actions: <Widget>[
              IconButton (
                icon: Icon(Icons.search),
                onPressed: () {
                  print('Seleccionaste el menu');
                }
              ),
              IconButton (
                icon: Icon(Icons.send),
                onPressed: () {
                  print('Seleccionaste el menu');
                }
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(child: Text('Chats'),),
                Tab(child: Text('Estados'),),
                Tab(child: Text('Llamadas'),)
              ]
            ),
          ),
          body:
          TabBarView(
            children: [
              Center(
                child: Column(
                  children: <Widget>[
                    Expanded(
                       child: Container(
                        child: FutureBuilder(
                          future: getPost(),
                          builder: (_, snapshot){
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(
                                child: Text("Cargando ...")
                              );
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (_, index){
                                  return ListTile(
                                    title: Text(snapshot.data[index].data["mensaje"]),
                                  );
                                }
                              );
                            }
                          }
                        ),
                      )
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Escribe un mensaje',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)
                        )
                      ),
                      controller: txtMensaje,
                    ),
                    RaisedButton(
                      child: Text('Ver'),
                      onPressed: () {
                        getData();
                      },
                    ),
                    RaisedButton(
                      child: Text('Eliminar'),
                      onPressed: (){
                        eliminar();
                      },
                    ),
                    RaisedButton(
                      child: Text('Actualizar'),
                      onPressed: (){
                        actualizar();
                      },
                    )
                  ],
                ),
              ),
              Center(child: Text('Estados') ),
              Center(child: Text('Para llamar a contactos que tiene WhatsApp') ),
            ],
          ),
          drawer: Drawer(
            elevation: 16.0,
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: Text('Menú'),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 7, 94, 84)
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text('Bandeja de entrada'),
                  onTap: () {
                    print('Abriendo correos');
                  },
                ),
                Divider(),
                  ListTile(
                    leading: Icon(Icons.cancel),
                    title: Text('Correo no deseados'),
                    onTap: () {
                      print('Abriendo correos');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.cast_connected),
                    title: Text('Spam'),
                    onTap: () {
                      print('Abriendo Spam');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Correo eliminados'),
                    onTap: () {
                      print('Abriendo Correo eliminados');
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.close),
                    title: Text('Cerrar sesión'),
                    onTap: () {
                      print('Abriendo errar sesión');
                    },
                  )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: (){
                insertar(txtMensaje.text);
              },
              child: Icon(Icons.message)),
        )
      )
    );
  }
}

void insertar(String mensaje)async {
  await bd.collection("whatsapp").
    add({'mensaje':mensaje});
}

void eliminar() async{
  await bd.collection('whatsapp').
    document('-LuuR3itOA22mNkLopDl').delete();
}

void actualizar() async{
  await bd.collection('whatsapp').
    document('-LuuR3itOA22mNkLopDl').
    updateData({'mensaje': 'Mensaje actualizado'});
}

void getData() {
  bd
    .collection("whatsapp")
    .getDocuments()
    .then((QuerySnapshot snapshot) {
  snapshot.documents.forEach((f) => print('${f.data}}'));
  });
}

Future getPost() async {
  QuerySnapshot qn = await bd.collection("whatsapp").getDocuments();
  return qn.documents;
}

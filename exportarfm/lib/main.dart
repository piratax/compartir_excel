// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:exportarfm/data/databaseController.dart';
import 'package:flutter/material.dart';
import 'package:exportarfm/components/listaInventario.dart';
import 'package:exportarfm/components/actualProduct.dart';
import 'package:exportarfm/util/excel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Exportar datos excel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Future<List<Map>> _productos = databaseController();
  late List<Map> _productos;
  List<Map> _inventariado = [
    // {'nombre': 'Prueba', 'cantidad': 0}
  ];
  List<bool> _selected = [];
  Map _actualProduct = {
    "nombre": "Seleccione un producto",
    'cantidad': -1,
    "codigo": null,
    "precioCaja": null,
    "precioUnitario": null
  };
  // ignore: missing_return
  void selectProduct(Map product) {
    print(product);
    setState(() {
      _actualProduct = product;
    });
  }

// ignore: missing_return
  void productChange(Map product) {
    try {
      Map productChanged = _inventariado
          .firstWhere((element) => element['nombre'] == product['nombre']);
      setState(() {
        _inventariado[_inventariado.indexOf(productChanged)] = product;
      });
    } catch (e) {
      print(e);
    }
  }

  // // ignore: must_call_super
  @override
  void initState() {
    super.initState();
    // firstLoad();
    Future.delayed(Duration.zero).then((_) async {
      _productos = await databaseController();
      List<Map> tempInve = [];
      _productos.forEach((element) {
        tempInve.add({'nombre': element['nombre'], 'cantidad': 0});
        setState(() {
          _inventariado = tempInve;
          _selected =
              List<bool>.generate(tempInve.length, (int index) => false);
        });
      });
    }).then((value) => print('initial is working'));
    // print('initial is working');
  }

  @override
  Widget build(BuildContext context) {
    print(_productos);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Almacen DIALGO"),
        actions: [
          IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                print('i was pressed');
                generarExcel(_inventariado);
              })
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListaInveWidget(
                      _inventariado,
                      selectProduct,
                      _selected,
                      key: null,
                    ),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            top: 0.0,
            width: MediaQuery.of(context).size.width,
            height: 100,
            // left: 0.0,
            child: ActualProductWidget(_actualProduct, productChange),
          ),
        ],
      ),

      // body: ListView(children: [
      //   Padding(
      //     padding: const EdgeInsets.symmetric(vertical: 30),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget>[
      //         Stack(
      //           children: [
      //             Column(
      //               children: [
      //                 ListaInveWidget(
      //                     _inventariado,
      //                     selectProduct,
      //                     _actualProduct
      //                 ),
      //                 TextButton(
      //                   child: Text('Presioname'),
      //                   onPressed: (){
      //                     print('i was pressed');
      //                     generarExcel(_inventariado);
      //                   },
      //                 )
      //               ],
      //             ),
      //             Positioned(
      //               top: 0.0,
      //               width: MediaQuery.of(context).size.width,
      //               height: 100,
      //               // left: 0.0,
      //               child: ActualProductWidget(
      //                   _actualProduct,
      //                   productChange
      //               ),
      //             ),
      //           ],
      //         ),
      //         // FutureBuilder(
      //         //   future: _productos,
      //         //   builder: (BuildContext context,AsyncSnapshot<List<Map<dynamic, dynamic>>> snapshot) {
      //         //     List<Map> tempInve = [];
      //         //     if (snapshot.hasData) {
      //         //       snapshot.data.forEach((element) {
      //         //         tempInve.add({'nombre': element['nombre'], 'cantidad': 0});
      //         //       });
      //         //       return ListaInveWidget(
      //         //         tempInve,
      //         //         selectProduct,
      //         //         _actualProduct
      //         //       );
      //         //     } else {
      //         //       var children = const <Widget>[
      //         //         SizedBox(
      //         //           child: CircularProgressIndicator(),
      //         //           width: 60,
      //         //           height: 60,
      //         //         ),
      //         //         Padding(
      //         //           padding: EdgeInsets.only(top: 16),
      //         //           child: Text('Awaiting result...'),
      //         //         )
      //         //       ];
      //         //       return Center(
      //         //         child: Column(
      //         //           mainAxisAlignment: MainAxisAlignment.center,
      //         //           crossAxisAlignment: CrossAxisAlignment.center,
      //         //           children: children,
      //         //         ),
      //         //       );
      //         //     }
      //         //   },
      //         // ),
      //       ],
      //     ),
      //   ),
      // ]),
    );
  }
}

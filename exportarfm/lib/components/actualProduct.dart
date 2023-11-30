// ignore_for_file: no_logic_in_create_state, avoid_print

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ActualProductWidget extends StatefulWidget {
  Map productoActual;
  Function(Map) changeInveProduct;
  ActualProductWidget(this.productoActual, this.changeInveProduct, {Key? key})
      : super(key: key);
  @override
  ActualProductWidgetState createState() =>
      ActualProductWidgetState(productoActual, changeInveProduct);
}

class ActualProductWidgetState extends State<ActualProductWidget> {
  ActualProductWidgetState(Map productoActual, Function(Map) changeInveProduct);

  // Map productoActual;
  // int index;
  // ActualProductWidgetState(this.productoActual,this.index);

  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController(
        text: widget.productoActual['cantidad'] != 0
            ? widget.productoActual['cantidad'].toString()
            : '');
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
        child: Column(
          children: [
            Text(widget.productoActual['nombre']),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Cantidad',
              ),
              keyboardType: TextInputType.number,

              textAlign: TextAlign.center,
              controller: myController,
              // onEditingComplete:  (){
              //   print('edited');
              // },
              onEditingComplete: () {
                print(myController.text);
                Map tempProduct = widget.productoActual;
                tempProduct['cantidad'] = int.parse(myController.text);
                widget.changeInveProduct(tempProduct);
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ],
        ),
      ),
    );
  }
}

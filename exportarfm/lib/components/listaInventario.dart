// ignore_for_file: no_logic_in_create_state, unnecessary_null_comparison

import 'package:flutter/material.dart';

class ListaInveWidget extends StatefulWidget {
  final List<Map> inventario;
  final Function(Map) _selectProduct;
  final List<bool> _productState;

  const ListaInveWidget(
      this.inventario, this._selectProduct, this._productState,
      {Key? key})
      : super(key: key);

  @override
  ListaInveWidgetState createState() =>
      ListaInveWidgetState(inventario, _selectProduct, _productState);
}

class ListaInveWidgetState extends State<ListaInveWidget> {
  final List<Map> inventario;
  final Function(Map p1) selectProduct;
  final List<bool> productState;

  ListaInveWidgetState(this.inventario, this.selectProduct, this.productState);

  @override
  Widget build(BuildContext context) {
    return DataTable(
      showCheckboxColumn: false,
      columns: const [
        DataColumn(
          label: Text('Producto'),
        ),
        DataColumn(
          label: Text('Cantidad'),
        ),
        DataColumn(
          label: Text('Unidad'),
        ),
      ],
      rows: widget.inventario.map((map) {
        final index = widget.inventario.indexOf(map);
        return DataRow(
          selected: widget._productState != null
              ? widget._productState[index]
              : false,
          color: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.50);
              } else {
                // Devuelve un valor predeterminado cuando no está seleccionado
                return Theme.of(context)
                    .colorScheme
                    .primary; // Cambia según tus necesidades
              }
            },
          ),
          cells: [
            DataCell(Text(map['nombre'])),
            DataCell(Text(map['cantidad'].toString())),
            const DataCell(Text('Cajas')),
          ],
          onSelectChanged: (bool? selec) {
            if (selec != null && selec) {
              widget._productState[!widget._productState.contains(true)
                  ? 0
                  : widget._productState.indexOf(true)] = false;
              widget._productState[index] = true;
              widget._selectProduct(map);
            }
          },
        );
      }).toList(),
    );
  }
}

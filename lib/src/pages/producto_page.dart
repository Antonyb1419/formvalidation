import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/productos_provider.dart';
import '../utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final productoProvider = new ProductosProvider();
  final ImagePicker _picker = ImagePicker();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  XFile? foto;

  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData =
        ModalRoute.of(context)?.settings.arguments as ProductoModel;

    if (prodData != null) {
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child:
        Container(
          padding: EdgeInsets.all(15.0),
          child:
          Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value!),
      validator: (value) {
        if (utils.isNumeric(value.toString())) {
          return null;
        } else {
          return 'Solo números';
          ;
        }
      },
    );
  }

  _crearBoton() {
    return ElevatedButton.icon(
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0))),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState?.save();

    setState(() {
      _guardando = true;
    });
    if (foto != null) {
      producto.fotoUrl = await productoProvider.subirImagen(File(foto!.path));
      print(producto.fotoUrl);
    }
    print(producto.fotoUrl);
    if (producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }
    //setState(() {_guardando = false;});
    mostrarSnackBar('Registro guardado');
    Navigator.pop(context);
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(mensaje), duration: Duration(milliseconds: 2500)));
    scaffoldKey.currentState!.showSnackBar(snackbar as SnackBar);
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible as bool,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
          image: NetworkImage(producto.fotoUrl.toString()),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.contain
      );
    } else {
      return Image(
        image: foto != null? FileImage(File(foto!.path)): AssetImage('assets/no-image.png')
        as  ImageProvider<Object>,
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }
  
  void _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  void _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = (await _picker.pickImage(source: origen))!;

    if (foto != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }
}

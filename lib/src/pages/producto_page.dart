import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_providers.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  
  @override
  State<ProductoPage> createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File? foto;


  @override
  Widget build(BuildContext context) {
    final ProductoModel? prodData = ModalRoute.of(context)?.settings.arguments as dynamic;
    if( prodData != null) {
      producto = prodData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(onPressed: _seleccionarFoto, icon: Icon(Icons.photo_size_select_actual)),
          IconButton(onPressed: _tomarFoto, icon: Icon(Icons.camera_alt)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
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
    //widget de input text para formularios
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (newValue) => producto.titulo = newValue,
      validator: (value) {
        final val = value as String;
        if(val.length < 3) {
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
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (newValue) => producto.valor = double.parse(newValue as String),
      validator: (value) {
        final val = value as String;
        if(utils.isNumeric(val)) {
          return null;
        } else {
          return 'Solo números';
        }
      },
    );
  }

  Widget _crearBoton() {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      textStyle: TextStyle(color: Colors.white),
      backgroundColor: Colors.deepPurple
    );
    return ElevatedButton.icon(
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      style: raisedButtonStyle,
      onPressed: _guardando ? _submit : null,
    );
  } 

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible as bool,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        producto.disponible = value;
      })
    );
  }

  void _submit() async {
    final validar = formKey.currentState as FormState;
    if( !validar.validate()) return;
    formKey.currentState?.save();
    setState(() {
      _guardando = true;
    });

    if(foto != null) {
      producto.fotoUrl = await productoProvider.subirImage(foto as File);
    }

    if(producto.id == null) {
      productoProvider.crearProducto(producto);
    } else {
      productoProvider.editarProducto(producto);
    }

    mostrarSnackbar('Registro guardado');
    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );


    setState(() {
      _guardando = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  } 
  Widget _mostrarFoto() {
    if(producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl as String),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
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
    foto = await ImagePicker.platform.pickImage(
      source: origen
    ) as File?;
    if(foto != null) {
      // limpieza
      producto.fotoUrl = null;
    }
    setState(() {
      
    });
  }
}
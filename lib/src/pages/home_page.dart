import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';


class HomePage extends StatelessWidget {
  /* final productosProvider = new ProductosProvider(); */

  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    /* final bloc = Provider.of(context); */
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title:  Text('Home'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }   

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if(snapshot.hasData) {
          final productos = snapshot.data as dynamic;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(productos[i], context, productosBloc),
          );
        }else {
          return Center(child: CircularProgressIndicator(),);
        }
      }
    );
  }

  Widget _crearItem(ProductoModel producto, BuildContext context, ProductosBloc productosBloc) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        productosBloc.borrarProducto(producto.id as String);
        /* productosProvider.borrarProducto(producto.id as String); */
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (producto.fotoUrl == null)
            ? Image(image: AssetImage('assets/no-image.png'))
            : FadeInImage(
                image: NetworkImage(producto.fotoUrl as String),
                placeholder: AssetImage('assets/jar-loading,gif'),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
            ),
            ListTile(
              title: Text('${producto.titulo} - ${producto.valor}'),
              subtitle: Text(producto.id as String),
              onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
            ),
          ],
        ),
      )
    );
  }
  
  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto')
    );
  }
}
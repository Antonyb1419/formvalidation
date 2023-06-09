import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:formvalidation/src/models/producto_model.dart';
class ProductosProvider{

  final String _url = 'https://flutter-varios-c66e2-default-rtdb.firebaseio.com';

 Future<bool> crearProducto(ProductoModel producto) async{

   final url = Uri.parse('$_url/productos.json');

   final resp = await http.post(url, body: productoModelToJson(producto));

   final decodedData = json.decode(resp.body);

   print(decodedData);

   return true;

  }

  Future<bool> editarProducto(ProductoModel producto) async{

    final url = Uri.parse('$_url/productos/${producto.id}.json');

    final resp = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;

  }

  Future<List<ProductoModel>> cargarProductos() async{

    final url = Uri.parse('$_url/productos.json');
    final resp = await http.get(url);
    
    final Map<String, dynamic> decodeData = json.decode(resp.body);
    final List<ProductoModel> productos = [];

    if(decodeData == null) return [];
    decodeData.forEach((id, prod) {

      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);


    });

    //print(productos);

    return productos;

  }

  Future<int> borrarProducto(String id) async{

    final url = Uri.parse('$_url/productos/$id.json');
    final resp = await http.delete(url);

    return 1;

  }

  Future<String?> subirImagen(File imagen) async{

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dvtens8ty/image/upload?upload_preset=cpce0d5v');
    final mimeType = mime(imagen.path)!.split('/'); //image/jpg

    final imageUploadRequest = http.MultipartRequest(
      'POST',
       url
    );

    final file = await http.MultipartFile.fromPath(
        'file',
        imagen.path,
        contentType: MediaType(mimeType[0],mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
       print('Algo salio mal');
       print(resp.body);
       return null;
    }

    final respData = json.decode(resp.body);
    print(respData);
    return respData['secure_url'];
  }
  
}
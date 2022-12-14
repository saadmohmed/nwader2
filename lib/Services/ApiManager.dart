
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../CONSTANT.dart';
import '../model/Ad.dart';

class ApiProvider {
  Future<List<Ad>> ads() async {
    List<Ad> ads = [];

    final http.Response response = await http.get(
      Uri.parse('${ADS}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );
    if (response.statusCode == 200) {
      dynamic body = json.decode(response.body);
      body["ads"].forEach((elemnt) {
        ads.add(new Ad(
          id: elemnt['id'],
          title: elemnt['title'],
          image: elemnt['preview'],
        ));
      });
    }
    return ads;
  }

  Future cat_wtith_products() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    dynamic url =  Uri.parse('${CAT_WITH_PRODUCTS}');
    if(user_id != null){
     url =  Uri.parse('${CAT_WITH_PRODUCTS}?user_id='+user_id!);
    }

    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data['cats'];
      }
      return null;
    }
    return null;
  }
  Future getAreas() async {
    final storage = new FlutterSecureStorage();

    final http.Response response = await http.get(
      Uri.parse('${GET_AREAS}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',

      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);

      return data;

    }
    return null;
  }
  Future getProductData(String id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    dynamic url =  Uri.parse('${PRODUCT_DATA}?product_id=' + id);
    if(user_id != null) {
      url = Uri.parse('${PRODUCT_DATA}?product_id=' + id + '&user_id='+user_id);
    }
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
    );
print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data['product'];
      }
      return null;
    }
    return null;
  }

  Future get_order(String id) async {
    final storage = new FlutterSecureStorage();
  final api_token = await storage.read(
  key: 'token',
  );
    final http.Response response = await http.get(
      Uri.parse('${ORDERDETAILS}?order_id=' + id),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }
  Future getDriverLocation(String id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final http.Response response = await http.get(
      Uri.parse('${GETDRIVERLOCATION}?order_id=' + id),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
    );
      final data = json.decode(response.body);
        return data;


  }
  Future edit_to_address(address_id, address_name ,area_id,gov_id , block , street  , build_number ,lat , lng , full_address ,flat) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    final http.Response response = await http.post(
      Uri.parse('${EDIT_USER_ADDRESS}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'address_id': address_id.toString(),

        'address_name': address_name,
        'area_id': area_id,
        'gov_id': gov_id,
        'block': block,
        'street': street,
        'build_number': build_number,
        'lat': lat,
        'lng': lng,
        'full_address': full_address,
        'flat': flat,

        'user_id' : user_id
      },
    );
    print('ddd');
    print( json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }

  Future add_to_address( address_name ,area_id,gov_id , block , street  , build_number ,lat , lng , full_address ,flat) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    final http.Response response = await http.post(
      Uri.parse('${ADD_USER_ADDRESS}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'address_name': address_name,
        'area_id': area_id,
        'gov_id': gov_id,
        'block': block,
        'street': street,
        'build_number': build_number,
        'lat': lat,
        'lng': lng,
        'full_address': full_address,
        'flat': flat,

        'user_id' : user_id
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }
  Future add_to_favorite(String product_id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    final http.Response response = await http.post(
      Uri.parse('${ADD_TO_FAVORITE}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'product_id': product_id,
        'user_id' : user_id
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }

  Future delete_user_address(address_id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );

    final user_id = await storage.read(
      key: 'id',
    );
    if(user_id != null){
      final http.Response response = await http.post(
        Uri.parse('${DELETE_ADDRESS}'),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
        },
        body: {
          'user_id': user_id,
          'address_id' : address_id
        },
      );
        final data = json.decode(response.body);
        return data;

    }
    return null;


  }

  Future update_device_key(token) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );

    final user_id = await storage.read(
      key: 'id',
    );
    if(user_id != null){
      final http.Response response = await http.post(
        Uri.parse('${UPDATE_DEVICE_KEY}'),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
        },
        body: {
          'user_id': user_id,
          'device_key' : token
        },
      );
    }

  }
  Future contact_us(name , email , message , title) async {
    final storage = new FlutterSecureStorage();


      final http.Response response = await http.post(
        Uri.parse('${CONTACT_US}'),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
        body: {
          'title':title,
          'name': name,
          'mobile' : email,
          'details' : message,

        },
      );
    final data = json.decode(response.body);
    return data;


  }
  Future getPage(page) async {
    final storage = new FlutterSecureStorage();

    final http.Response response = await http.get(
      Uri.parse('${GET_PAGE}/'+page),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    }
    return null;
  }
  Future get_config() async {
    final storage = new FlutterSecureStorage();

    final http.Response response = await http.get(
      Uri.parse('${CONFIGURATION}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
    return data;
    }
    return null;
  }
  Future get_user_favorite() async {
      final storage = new FlutterSecureStorage();
        final api_token = await storage.read(
          key: 'token',
        );
      final user_id = await storage.read(
        key: 'id',
      );
      print(user_id);
      dynamic url =  Uri.parse('${GET_FAVORITES}');
      if(user_id != null){
     url =    Uri.parse('${GET_FAVORITES}?user_id='+user_id!);
      }
    final http.Response response = await http.get(
    url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }

  Future get_user_notification() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    dynamic url =  Uri.parse('${USER_NOTIFICATION}');
    if(user_id != null){
      url =    Uri.parse('${USER_NOTIFICATION}?user_id='+user_id!);
    }
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        return data;

    }
    return null;
  }
  Future get_user_order() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    print(api_token);

    dynamic url =  Uri.parse('${GET_ORDERS}');
    if(user_id != null){
      url =   Uri.parse('${GET_ORDERS}?user_id='+user_id!);
    }
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
    );
    print( json.decode(response.body));
    // if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // if (data['status'] == true) {
        return data;
      // }
      // return null;

    return null;
  }

  Future get_user_cart() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    print(api_token);

    dynamic url =  Uri.parse('${GET_CART}');
    if(user_id != null){
    url =   Uri.parse('${GET_CART}?user_id='+user_id!);
    }
    final http.Response response = await http.get(
    url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
    );
    print( json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }
  // 'id', 'user_id', 'product_id', 'product_variant_id', 'quantity', 'cut_type_id', 'cover_type_id', 'is_slaughtered',
  Future add_to_cart(String product_id  , is_slaughtered , cover_type_id , cut_type_id , quantity , product_variant_id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    print( {
      'user_id':user_id,
      'product_id':product_id,
      'product_variant_id':product_variant_id,
      'quantity':quantity.toString(),
      'cut_type_id':cut_type_id.toString(),
      'cover_type_id':cover_type_id.toString(),
      'is_slaughtered':is_slaughtered,
    });

    dynamic url =  Uri.parse('${ADD_TO_CART}');
    if(user_id != null){
      Uri.parse('${ADD_TO_CART}?user_id='+user_id!);
    }
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
    'user_id':user_id,
    'product_id':product_id,
    'product_variant_id':product_variant_id,
    'quantity':quantity.toString(),
    'cut_type_id':cut_type_id.toString(),
    'cover_type_id':cover_type_id.toString(),
    'is_slaughtered':is_slaughtered,
      },
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }

  Future update_password(String new_password , String old_password ) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${UPDATE_PASSWORD}');
    if(user_id != null){
      url =    Uri.parse('${UPDATE_PASSWORD}?user_id='+user_id!);
    }
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'old_password': old_password,
        'new_password': new_password,


      },
    );
    print(json.decode(response.body));
    return json.decode(response.body);

    // if (response.statusCode == 200) {
    //   final data = json.decode(response.body);
    //   if (data['status'] == true) {
    //     return data;
    //   }
    //   return null;
    // }
    // return null;
  }
  Future add_order(address_id  , payment_type  ,price ) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    final http.Response response = await http.post(
      Uri.parse('${ADD_ORDER}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'user_id':user_id.toString(),
        'address_id' : address_id.toString(),
        'payment_type' : payment_type.toString(),
  'price' : price,
      },
    );

      return json.decode(response.body);

  }
  Future update_profile(String name , String email , String phone ) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );

    dynamic url =  Uri.parse('${UPDATE_PROFILE}');
    if(user_id != null){
   url =    Uri.parse('${UPDATE_PROFILE}?user_id='+user_id!);
    }
    final http.Response response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
      body: {
        'name': name,
        'email': email,
        'mobile': phone,

      },
    );
    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }
  Future get_products(String category_id) async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    print(user_id);
    dynamic url =  Uri.parse('${GET_PRODUCTS}?category_id='+category_id);
    if(user_id != null) {
      url = Uri.parse('${GET_PRODUCTS}?category_id='+category_id+'&user_id='+user_id);
    }
      final http.Response response = await http.get(
url,      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data;
      }
      return null;
    }
    return null;
  }
  Future get_categoires() async {
    final http.Response response = await http.get(
      Uri.parse('${CATEGORES}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data['categories'];
      }
      return null;
    }
    return null;
  }

  Future login(String email, String password) async {
    final http.Response response = await http.post(
      Uri.parse('${LOGIN_API}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
      body: {
        'username': email,
        'password': password,
      },
    );

      return json.decode(response.body);

    return null;
  }



  Future<dynamic> user() async {
    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    try {
      final http.Response response = await http.get(
        Uri.parse(USER_API +'?user_id='+user_id!),
        headers: <String, String>{
          'Accept': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
          'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)

        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print(e);
      return null;
    }

    return null;
  }

  Future getName() async {
    final storage = new FlutterSecureStorage();
    final name = await storage.read(
      key: 'name',
    );
    return name;
  }
  Future get_token() async {
    final storage = new FlutterSecureStorage();
    final token = await storage.read(
      key: 'token',
    );
    return token;
  }



  Future getUserAddress() async {


    final storage = new FlutterSecureStorage();
    final api_token = await storage.read(
      key: 'token',
    );
    final user_id = await storage.read(
      key: 'id',
    );
    print(api_token);

    dynamic url =  Uri.parse('${GET_USER_ADDRESS}');
    if(user_id != null){
      url =   Uri.parse('${GET_USER_ADDRESS}?user_id='+user_id!);
    }
    final http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
        'X-Authorization' : 'Bearer '+(api_token == null ? '' : api_token)
      },
    );
    print( json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == true) {
        return data['addresss'];
      }
      return null;
    }
    return null;
  }

  Future logout() async {
    final storage = new FlutterSecureStorage();
     await storage.deleteAll();

    return true;
  }

  Future register(String phone, String password, String name) async {
    final http.Response response = await http.post(
      Uri.parse('${REGISTER_API}'),
      headers: <String, String>{
        'Accept': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*'
      },
      body: {'mobile': phone, 'password': password, 'name': name},
    );

    return json.decode(response.body);
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_uas/model/category_models.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpHelper {
  final String _baseUrl = 'http://10.0.2.2:8000/api/';
  final String token = '';

  Future<Response> login(String email, String password, String deviceId) async {
    final url = Uri.parse(_baseUrl + 'auth/login');
    final body = {
      'email': email,
      'password': password,
      'device_name': deviceId
    };
    final headers = {
      'Accept': 'application/json',
    };

    final response = await post(url, body: body, headers: headers);

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      const key = 'token';

      final token = json.decode(response.body);
      var data = json.decode(response.body);
      _save('name', data['name']);
      _save('email', data['email']);

      prefs.setString(key, token['token']);
    }
    return response;
  }

  Future<Response> register(
      String name, String email, String password, String deviceId) async {
    final url = Uri.parse(_baseUrl + 'auth/register');
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'device_name': deviceId,
    };
    final headers = {
      'Accept': 'application/json',
    };

    final response = await post(url, body: body, headers: headers);
    return response;
  }

  Future<Response> logout(String token) async {
    final url = Uri.parse(_baseUrl + 'auth/logout');
    final body = {};
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + '$token',
    };
    final response = await post(url, body: body, headers: headers);

    return response;
  }

  getKategori() async {
    final url = Uri.parse(_baseUrl + 'category');
    final prefs = await SharedPreferences.getInstance();
    const key = 'token';
    final token = prefs.get(key);
    final headers = {
      'Authorization': 'Bearer ' + '$token',
      'Accept': 'application/json',
    };
    final response = await get(url, headers: headers);

    return response;
  }

  Future<Response> logOut(String token) async {
    final url = Uri.parse(_baseUrl + 'auth/logout');
    final body = {};
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + '$token',
    };
    final response = await post(url, body: body, headers: headers);

    return response;
  }

  Future<Response> requestAddCategory(String name) async {
    var url = Uri.parse(_baseUrl + 'category');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await post(
      url,
      headers: {
        "Accept": "application/json",
        "Access-Control_Allow_Origin": "*",
        "Authorization": "Bearer $token",
      },
      body: {
        "name": name,
      },
    );
    return response;
  }

  Future<Response> addCategory(String name) async {
    final url = Uri.parse(_baseUrl + 'category');
    SharedPreferences pref = await SharedPreferences.getInstance();
    const key = 'token';
    final value = pref.get(key);
    final token = value;
    final body = {
      'name': name,
    };
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + '$token',
    };

    final response = await post(url, body: body, headers: headers);
    return response;
  }

  Future<Response> deleteCategory(Category category) async {
    final url = Uri.parse(_baseUrl + 'category/${category.id}');
    SharedPreferences pref = await SharedPreferences.getInstance();
    const key = 'token';
    final value = pref.get(key);
    final token = value;
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + '$token',
    };

    final response = await delete(url, headers: headers);
    return response;
  }

  _save(String key, String data) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, data);
  }

  Future<Response> editCategory(Category category, String name) async {
    final url = Uri.parse(_baseUrl + 'category/${category.id}');
    SharedPreferences pref = await SharedPreferences.getInstance();
    const key = 'token';
    final value = pref.get(key);
    final token = value;
    final body = {
      'name': name,
    };
    final headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + '$token',
    };

    final response = await put(url, body: body, headers: headers);

    print(response.body);
    print(response.statusCode);
    return response;
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/api.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  Future doLogin() async {
    final email = txtEmail.text;
    final password = txtPassword.text;
    final deviceId = "12345";
    final response = await HttpHelper().login(email, password, deviceId);
    print(response.body);
    SharedPreferences pref = await SharedPreferences.getInstance();
    const key = 'token';
    final value = pref.get(key);
    final token = value;
    Navigator.pushNamed(
      context,
      '/Home',
    );
  }

  final txtEmail = TextEditingController(text: 'superadmin@gmail.com');
  final txtPassword = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(22),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.deepPurple[50]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          TextFormField(
            controller: txtEmail,
            decoration: InputDecoration(label: Text('Username')),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: txtPassword,
            decoration: InputDecoration(label: Text('Password')),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              doLogin();
            },
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return Colors.amber[500]; //<-- SEE HERE
                  return null; // Defer to the widget's default.
                },
              ),
            ),
            child: Text('Masuk'),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ));
  }
}

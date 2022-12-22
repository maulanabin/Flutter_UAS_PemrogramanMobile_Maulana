import 'package:flutter/material.dart';
import 'package:flutter_uas/screen/edit_category.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_uas/model/category_models.dart';

import '../../network/api.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  String token = '';
  String name = '';
  String email = '';
  List listCategory = [];

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      const key = 'token';
      const key1 = 'name';
      const key2 = 'email';
      final value = pref.get(key);
      final value1 = pref.get(key1);
      final value2 = pref.get(key2);
      token = '$value';
      name = '$value1';
      email = '$value2';
    });
  }

  getKategori() async {
    final response = await HttpHelper().getKategori();
    var dataResponse = json.decode(response.body);
    setState(() {
      var listRespon = dataResponse['data'];
      for (var i = 0; i < listRespon.length; i++) {
        listCategory.add(Category.fromJson(listRespon[i]));
      }
    });
  }

  doAddCategory() async {
    final name = addCategoryTxt.text;
    final response = await HttpHelper().addCategory(name);
    print(response.body);
    // Navigator.pushNamed(context, "/");
    listCategory.clear();
    getKategori();
    addCategoryTxt.clear();
  }

  @override
  void initState() {
    getPref();
    super.initState();
    getKategori();
  }

  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await HttpHelper().logout(token);
    setState(() {
      preferences.remove("token");
      preferences.clear();
    });
  }

  final TextEditingController addCategoryTxt = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.deepPurple[50],
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.amber[400],
              ),
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 35, horizontal: 25),
                    child: Text(
                      '🍀 Selamat Datang 🍀',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 29,
                        fontFamily: 'Raleway',
                        shadows: [
                          Shadow(
                            color: Colors.red.shade300,
                            blurRadius: 6,
                            offset: const Offset(4.0, 4.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: Align(
                            child: ElevatedButton(
                              child: const Text("Keluar"),
                              style: ElevatedButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    Colors.deepPurple[400], // Background color
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/',
                                );
                                logOut();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16),
              child: TextFormField(
                controller: addCategoryTxt,
                decoration: InputDecoration(
                  hintText: "Masukkan Kategori Baru",
                  labelText: "Tambahkan Kategori",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  suffixIcon: Container(
                    margin: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                    child: ElevatedButton(
                      child: const Text("Tambah"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.deepPurple[400], // Background color
                      ),
                      onPressed: () {
                        doAddCategory();
                      },
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber.shade400,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                  ),
                ),
                child: ListView.builder(
                  itemCount: listCategory.length,
                  itemBuilder: (context, index) {
                    var kategori = listCategory[index];
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.blue[100],
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.create_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red[100],
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                      onDismissed: (DismissDirection direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          // Navigator.pushNamed(
                          //   context,
                          //   '/Edit',
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    editCategory(category: listCategory[index]),
                              ));
                        } else {
                          final response = await HttpHelper()
                              .deleteCategory(listCategory[index]);
                          print(response.body);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 7,
                              offset: Offset(6.0, 6.0),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: Text(
                              kategori.name,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontFamily: 'Raleway',
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}

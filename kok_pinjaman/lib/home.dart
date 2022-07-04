// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kok_pinjaman/cart.dart';
import 'package:kok_pinjaman/clothes.dart';
import 'package:kok_pinjaman/generalequipment.dart';
import 'package:kok_pinjaman/login.dart';
import 'package:kok_pinjaman/music.dart';
import 'package:kok_pinjaman/mybooking.dart';
import 'package:kok_pinjaman/selectedEquipment.dart';
import 'package:kok_pinjaman/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  const HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late double screenHeight, screenWidth;
  String server = "https://seriouslaa.com/rentApplicationSystem/php";

  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController _quantityEditingController =
      TextEditingController();

  List equipmentdata = [];
  String cartquantity = "0";

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
    // refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Center(
            child: Container(
                height: screenHeight / 16,
                width: screenWidth / 2,
                // ignore: prefer_const_constructors
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/logokok.png'),
                        fit: BoxFit.contain))),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                upper(context),
                lower(context),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Cart(
                          user: widget.user,
                        )));
            // _loadData();
            // _loadCartQuantity();
          },
          label: Badge(
            toAnimate: true,
            badgeContent: Text(
              cartquantity,
              style: TextStyle(color: Colors.white),
            ),
            child: Row(
              children: [Text("My Cart  "), Icon(Icons.shopping_cart)],
            ),
          ),
        ),
      ),
    );
  }

  upper(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: screenHeight / 2.7,
    );
  }

  lower(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15, screenHeight / 40, 15, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    height: screenHeight / 10,
                    width: screenWidth / 4,
                    child: Center(
                        child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/userdefault.jpg'),
                    )
                        // Your Widget
                        ),
                  ),
                  SizedBox(
                    height: screenHeight / 10,
                    width: screenWidth / 2.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            widget.user.name,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          widget.user.matrik,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          widget.user.email,
                          style: TextStyle(fontSize: 11, color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight / 25,
                width: screenWidth / 4.3,
                child: MaterialButton(
                  // elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text('Log Out',
                      style: TextStyle(
                        color: Colors.black,
                      )),
                  color: Colors.blue[200],
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Login())),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, screenHeight / 30, 8, 10),
          child: SizedBox(
            // height: screenHeight / 1.8,
            width: screenWidth / 1.1,
            child: TextField(
              cursorColor: Colors.white,
              controller: _searchController,
              // textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(),
                border: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(50),
                    // borderSide: BorderSide(color: Colors.black, width: 2),
                    ),
                prefixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      _sortItembyName(_searchController.text);
                    }),
                hintText: "Find Equipment",
                suffixIcon: IconButton(
                  color: Colors.black,
                  onPressed: _searchController.clear,
                  icon: Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            height: screenHeight / 4,
            width: screenWidth / 1.1,
            margin: const EdgeInsets.only(
                bottom: 6.0), //Same as `blurRadius` i guess
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => GeneralEquipment(
                                  user: widget.user,
                                )));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        child: Icon(
                          Icons.car_rental,
                          color: Colors.white,
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 81, 118, 182)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
                        child: Text("General"),
                      ),
                      Text("Equipment"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Music(
                                  user: widget.user,
                                )));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        child: Icon(
                          Icons.music_video,
                          color: Colors.white,
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 230, 130, 99)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Music"),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Clothes(
                                  user: widget.user,
                                )));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 75,
                        height: 75,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 163, 91, 218)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Clothes"),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
              child: Text(
                "Latest Equipment",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        equipmentdata == []
            ? SizedBox(
                height: 50,
                width: screenWidth / 1.12,
                child: Center(
                  child: Text("A"),
                ),
              )
            : SizedBox(
                height: screenHeight / 2.02,
                child: GridView.count(
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 1,
                    childAspectRatio: 1.7,
                    children: List.generate(equipmentdata.length, (index) {
                      return GestureDetector(
                        onTap: () => selectIndex(index),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.fitHeight,
                                    height: screenHeight / 3,
                                    width: screenWidth / 3,
                                    imageUrl:
                                        "https://seriouslaa.com/rentApplicationSystem/website/images/equipment/${equipmentdata[index]['EQUIPMENTNAME'] + ".jpg"}",
                                    placeholder: (context, url) =>
                                        new CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                equipmentdata[index]
                                                    ['EQUIPMENTNAME'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Text(
                                                equipmentdata[index]
                                                    ['EQUIPMENTTYPE'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Text(
                                            "Available: " +
                                                equipmentdata[index]
                                                    ['QUANTITY'] +
                                                " " +
                                                equipmentdata[index]['UNIT'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            Text("Deposit Fee:",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                )),
                                            Text(
                                                " RM " +
                                                    equipmentdata[index]
                                                        ['DEPOSIT'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text("Student's Fee",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    )),
                                                Text("|",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text("Staff's Fee",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    )),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                    "RM " +
                                                        equipmentdata[index]
                                                            ['PRICEUUM'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(" ",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    "RM " +
                                                        equipmentdata[index]
                                                            ['PRICESTAFF'],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })))
      ]),
    );
  }

  void _sortItembyName(String _searchController) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();

      http
          .post(Uri.parse(server + "/load_equipment.php"), body: {
            "name": _searchController.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Equipment not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              pr.hide();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            if (_searchController == "") {
              Toast.show("Please enter something", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
              pr.hide();
              FocusScope.of(context).requestFocus(new FocusNode());
              return;
            }
            setState(() {
              var extractdata = json.decode(res.body);
              equipmentdata = extractdata["equipments"];

              pr.hide();
            });
          })
          .catchError((err) {
            pr.hide();
          });
      pr.hide();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _loadData() async {
    await http
        .post(Uri.parse(server + "/load_equipment.php"), body: {}).then((res) {
      if (res.body == "nodata") {
        // cartquantity = "0";
        // titlecenter = "No product found";
        setState(() {
          // productdata = null;
          // cartquantity = "0";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          equipmentdata = extractdata["equipments"];
          // cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  selectIndex(int index) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: screenHeight / 4,
                width: screenWidth / 1,
                decoration: BoxDecoration(
                    //border: Border.all(color: Colors.black),
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(
                            "https://seriouslaa.com/rentApplicationSystem/website/images/equipment/${equipmentdata[index]['EQUIPMENTNAME'] + ".jpg"}")))),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(equipmentdata[index]['EQUIPMENTNAME'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(equipmentdata[index]['EQUIPMENTTYPE'],
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(
                        "Available: " +
                            equipmentdata[index]['QUANTITY'] +
                            " " +
                            equipmentdata[index]['UNIT'],
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Text("Deposit Fee:",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            )),
                        Text(" RM " + equipmentdata[index]['DEPOSIT'],
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Student's Fee",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                )),
                            Text("|",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text("Staff's Fee",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("RM " + equipmentdata[index]['PRICEUUM'],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text(" ",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text("RM " + equipmentdata[index]['PRICESTAFF'],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Quantity:   ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            )),
                        SizedBox(
                          height: screenHeight / 25,
                          width: screenWidth / 3,
                          child: TextField(
                              textAlign: TextAlign.start,
                              controller: _quantityEditingController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.blue),
                                enabledBorder: OutlineInputBorder(),
                                border: OutlineInputBorder(
                                  // borderRadius: BorderRadius.circular(50),
                                  borderSide:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  minWidth: 100,
                  height: screenHeight / 20,
                  child: Text(
                    'Add to Cart',
                  ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  elevation: 10,
                  onPressed: () => _addtoCart(index),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight / 70,
            )
          ],
        ));
      },
    );
  }

  void _addtoCart(int index) {
    try {
      int cquantity = int.parse(equipmentdata[index]["QUANTITY"]);
      int selectedQuantity = int.parse(_quantityEditingController.text);

      if (cquantity > 0 && selectedQuantity < cquantity) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Adding to cart...");
        pr.show();
        http.post(Uri.parse(server + "/insert_cart.php"), body: {
          "email": widget.user.email,
          "equipmentid": equipmentdata[index]["EQUIPMENTID"],
          "quantity": selectedQuantity.toString(),
        }).then((res) {
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.hide();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              // widget.user.quantity = cartquantity;
              // _havecart = true;
              // _loadCartQuantity();
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.hide();
          }
          pr.hide();
        }).catchError((err) {
          pr.hide();
        });
        pr.hide();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _loadCartQuantity() async {
    await http.post(Uri.parse(server + "/load_cartquantity.php"), body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        cartquantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }
}

// ignore_for_file: prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kok_pinjaman/applicantdata.dart';
import 'package:kok_pinjaman/navigationbarscreen.dart';
import 'package:kok_pinjaman/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class Cart extends StatefulWidget {
  final User user;

  const Cart({Key? key, required this.user}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List cartData = [];
  late double screenHeight, screenWidth;
  String server = "https://seriouslaa.com/rentApplicationSystem/php";

  @override
  void initState() {
    super.initState();

    //_getCurrentLocation();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                cartData == []
                    ? SizedBox(
                        height: 50,
                        width: screenWidth / 1.12,
                        child: Center(
                          child: Text("Not Cart"),
                        ),
                      )
                    : SizedBox(
                        height: screenHeight,
                        child: GridView.count(
                            scrollDirection: Axis.vertical,
                            crossAxisCount: 1,
                            childAspectRatio: 1.7,
                            children: List.generate(cartData.length, (index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                elevation: 2,
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.fitHeight,
                                        height: screenHeight / 3,
                                        width: screenWidth / 2.5,
                                        imageUrl:
                                            "https://seriouslaa.com/rentApplicationSystem/website/images/equipment/${cartData[index]['EQUIPMENTNAME'] + ".jpg"}",
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
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
                                                    cartData[index]
                                                        ['EQUIPMENTNAME'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    cartData[index]
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
                                                    cartData[index]
                                                        ['QUANTITY'] +
                                                    " " +
                                                    cartData[index]['UNIT'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              children: [
                                                Text("Deposit Fee:",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    )),
                                                Text(
                                                    " RM " +
                                                        cartData[index]
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
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  // ignore: prefer_const_literals_to_create_immutables
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
                                                                FontWeight
                                                                    .bold)),
                                                    Text("Staff's Fee",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        )),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                        "RM " +
                                                            cartData[index]
                                                                ['PRICEUUM'],
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(" ",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        "RM " +
                                                            cartData[index]
                                                                ['PRICESTAFF'],
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Center(
                                                // height: 10,
                                                // width: 30,
                                                child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () => {
                                                    _updateCart(index, "remove")
                                                  },
                                                  child: Text(
                                                    "<",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Text(
                                                  cartData[index]
                                                      ['CARTQUANTITY'],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                GestureDetector(
                                                  onTap: () => {
                                                    _updateCart(index, "add")
                                                  },
                                                  child: Text(
                                                    ">",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }))),
              ],
            ),
          ),
          Positioned(
            left: 30.0,
            right: 30.0,
            bottom: 30.0,
            child: SizedBox(
              height: 50,
              width: screenWidth / 1.2,
              child: MaterialButton(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Text('Continue',
                    style: TextStyle(
                      color: Colors.white,
                    )),
                color: Color.fromARGB(255, 85, 156, 255),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ApplicantData(
                                user: widget.user,
                              )));
                },
              ),
            ),
          ),
        ],
      )),
    );
  }

  void _loadCart() {
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart...");
    pr.show();

    http.post(Uri.parse(server + "/load_cart.php"), body: {
      "email": widget.user.email,
    }).then((res) {
      pr.hide();
      if (res.body == "Cart Empty") {
        //Navigator.of(context).pop(false);

        // setState(() {
        //   widget.user.quantity = "0";
        // });
        // widget.user.quantity = "0";

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => NavigationBarScreen(
                      user: widget.user,
                    )));
      }
      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        pr.hide();
      });
    }).catchError((err) {
      pr.hide();
    });
    pr.hide();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['QUANTITY']);
    int quantity = int.parse(cartData[index]['CARTQUANTITY']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }

    http.post(Uri.parse(server + "/update_cart.php"), body: {
      "email": widget.user.email,
      "equipmentid": cartData[index]['EQUIPMENTID'],
      "quantity": quantity.toString()
    }).then((res) {
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {});
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Row(
          children: <Widget>[
            Flexible(
              child: Text(
                'Delete ' + cartData[index]['EQUIPMENTNAME'] + "?",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 15),
                maxLines: 2,
              ),
            )
          ],
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(Uri.parse(server + "/delete_cart.php"), body: {
                  "email": widget.user.email,
                  "equipmentid": cartData[index]['EQUIPMENTID'],
                }).then((res) {
                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  if (kDebugMode) {
                    print(err);
                  }
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }
}

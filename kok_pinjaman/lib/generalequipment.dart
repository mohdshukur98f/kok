// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kok_pinjaman/user.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class GeneralEquipment extends StatefulWidget {
  final User user;
  const GeneralEquipment({Key? key, required this.user}) : super(key: key);

  @override
  State<GeneralEquipment> createState() => _GeneralEquipmentState();
}

class _GeneralEquipmentState extends State<GeneralEquipment> {
  late double screenHeight, screenWidth;
  String server = "https://seriouslaa.com/rentApplicationSystem/php";
  List generalData = [];
  final TextEditingController _quantityEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _loadgeneralData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Equipment List'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            generalData == []
                ? SizedBox(
                    height: 50,
                    width: screenWidth / 1.12,
                    child: const Center(
                      child: Text("No Data Available"),
                    ),
                  )
                : SizedBox(
                    height: screenHeight / 1.1,
                    child: GridView.count(
                        scrollDirection: Axis.vertical,
                        crossAxisCount: 1,
                        childAspectRatio: 1.7,
                        children: List.generate(generalData.length, (index) {
                          return GestureDetector(
                            onTap: () => selectIndex(index),
                            child: Padding(
                              padding: const EdgeInsets.all(1),
                              child: Card(
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
                                        width: screenWidth / 3,
                                        imageUrl:
                                            "https://seriouslaa.com/rentApplicationSystem/website/images/equipment/${generalData[index]['EQUIPMENTNAME'] + ".jpg"}",
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
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
                                                    generalData[index]
                                                        ['EQUIPMENTNAME'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    generalData[index]
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
                                                    generalData[index]
                                                        ['QUANTITY'] +
                                                    " " +
                                                    generalData[index]['UNIT'],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              children: [
                                                const Text("Deposit Fee:",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                    )),
                                                Text(
                                                    " RM " +
                                                        generalData[index]
                                                            ['DEPOSIT'],
                                                    style: const TextStyle(
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
                                                            generalData[index]
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
                                                            generalData[index]
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
          ],
        ),
      )),
    );
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
                            "https://seriouslaa.com/rentApplicationSystem/website/images/equipment/${generalData[index]['EQUIPMENTNAME'] + ".jpg"}")))),
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
                        Text(generalData[index]['EQUIPMENTNAME'],
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(generalData[index]['EQUIPMENTTYPE'],
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Text(
                        "Available: " +
                            generalData[index]['QUANTITY'] +
                            " " +
                            generalData[index]['UNIT'],
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
                        Text(" RM " + generalData[index]['DEPOSIT'],
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
                            Text("RM " + generalData[index]['PRICEUUM'],
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text(" ",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            Text("RM " + generalData[index]['PRICESTAFF'],
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
      int cquantity = int.parse(generalData[index]["QUANTITY"]);
      int selectedQuantity = int.parse(_quantityEditingController.text);

      if (cquantity > 0 && selectedQuantity < cquantity) {
        ProgressDialog pr = ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Adding to cart...");
        pr.show();
        http.post(Uri.parse(server + "/insert_cart.php"), body: {
          "email": widget.user.email,
          "equipmentid": generalData[index]["EQUIPMENTID"],
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
              // cartquantity = respond[1];
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

  Future<void> _loadgeneralData() async {
    await http.post(Uri.parse(server + "/load_equipment.php"), body: {
      "type": "General Equipment",
    }).then((res) {
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
          generalData = extractdata["equipments"];
          // cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {});
  }
}

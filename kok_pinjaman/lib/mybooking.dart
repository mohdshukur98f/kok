// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kok_pinjaman/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MyBookingScreen extends StatefulWidget {
  final User user;

  const MyBookingScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen>
    with SingleTickerProviderStateMixin {
  late double screenHeight, screenWidth;
  String server = "https://seriouslaa.com/rentApplicationSystem/php";

  late TabController _tabController;

  List pendingData = [];
  List approvedData = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadpendingbooking();
    _loadapprovebooking();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Container(
                height: screenHeight / 16,
                width: screenWidth / 2,
                decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('assets/images/logokok.png'),
                        fit: BoxFit.contain))),
          ),
          bottom: TabBar(
              controller: _tabController,
              // labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              // indicatorColor: Colors.black,
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                Tab(
                  text: "Pending",
                ),
                Tab(
                  text: "Approved",
                ),
              ]),
        ),
        body: SafeArea(
          child: TabBarView(controller: _tabController, children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  pendingData == []
                      ? SizedBox(
                          height: screenHeight,
                          width: screenWidth / 1.12,
                          child: Center(
                            child: Text(
                              "No Data Available",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: screenHeight / 1.33,
                          child: GridView.count(
                              scrollDirection: Axis.vertical,
                              crossAxisCount: 1,
                              childAspectRatio: 0.9,
                              children:
                                  List.generate(pendingData.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              // borderRadius: BorderRadius.all(
                                              //     Radius.circular(10)),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                height: screenHeight / 8,
                                                width: screenWidth / 3,
                                                imageUrl:
                                                    "https://seriouslaa.com/rentApplicationSystem/website/images/equipment/${pendingData[index]['EQUIPMENTNAME'] + ".jpg"}",
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                      pendingData[index]
                                                          ['EQUIPMENTNAME'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Text("Booking ID: ",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          )),
                                                      Text(
                                                          pendingData[index]
                                                              ['ORDERID'],
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Start Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                            Icon(Icons.arrow_forward),
                                            Text(
                                              "Return Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                        Flexible(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                  pendingData[index]
                                                      ['STARTDATE'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(width: 3),
                                              Text(
                                                  pendingData[index]
                                                      ['RETURNDATE'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Quantity",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  pendingData[index]
                                                      ['QUANTITY'],
                                                )
                                              ],
                                            ),
                                            VerticalDivider(
                                              thickness: 6,
                                              color: Colors.black,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Student Price",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  pendingData[index]
                                                      ['PRICEUUM'],
                                                )
                                              ],
                                            ),
                                            VerticalDivider(
                                              thickness: 6,
                                              color: Colors.black,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Staff Price",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  pendingData[index]
                                                      ['PRICESTAFF'],
                                                )
                                              ],
                                            ),
                                            VerticalDivider(
                                              thickness: 6,
                                              color: Colors.black,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Deposit",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  pendingData[index]['DEPOSIT'],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 20),
                                            Icon(
                                              MdiIcons.progressAlert,
                                              size: 20,
                                              color: Colors.orange,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              pendingData[index]
                                                  ['APPLICATION_STATUS'],
                                              style: TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Text(
                                          "Purpose",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Flexible(
                                            child: SingleChildScrollView(
                                              child: Text(
                                                pendingData[index]['PURPOSE'],
                                                textAlign: TextAlign.justify,

                                                // maxLines: 4,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                );
                              })))
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  approvedData == []
                      ? SizedBox(
                          height: 50,
                          width: screenWidth / 1.12,
                          child: Center(
                            child: Text(
                              "No Data Available",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: screenHeight / 1.33,
                          child: GridView.count(
                              scrollDirection: Axis.vertical,
                              crossAxisCount: 1,
                              childAspectRatio: 0.9,
                              children:
                                  List.generate(approvedData.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(1),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    elevation: 2,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            ClipRRect(
                                              // borderRadius: BorderRadius.all(
                                              //     Radius.circular(10)),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                height: screenHeight / 8,
                                                width: screenWidth / 3,
                                                imageUrl:
                                                    "https://seriouslaa.com/rentApplicationSystem/website/images/equipment/${approvedData[index]['EQUIPMENTNAME'] + ".jpg"}",
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                      approvedData[index]
                                                          ['EQUIPMENTNAME'],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Text("Booking ID: ",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          )),
                                                      Text(
                                                          approvedData[index]
                                                              ['ORDERID'],
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey,
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "Start Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                            Icon(Icons.arrow_forward),
                                            Text(
                                              "Return Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        ),
                                        Flexible(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                  approvedData[index]
                                                      ['STARTDATE'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  )),
                                              SizedBox(width: 3),
                                              Text(
                                                  approvedData[index]
                                                      ['RETURNDATE'],
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Quantity",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  approvedData[index]
                                                      ['QUANTITY'],
                                                )
                                              ],
                                            ),
                                            VerticalDivider(
                                              thickness: 6,
                                              color: Colors.black,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Student Price",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  approvedData[index]
                                                      ['PRICEUUM'],
                                                )
                                              ],
                                            ),
                                            VerticalDivider(
                                              thickness: 6,
                                              color: Colors.black,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Staff Price",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  approvedData[index]
                                                      ['PRICESTAFF'],
                                                )
                                              ],
                                            ),
                                            VerticalDivider(
                                              thickness: 6,
                                              color: Colors.black,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Deposit",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  approvedData[index]
                                                      ['DEPOSIT'],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 20),
                                            Icon(
                                              MdiIcons.checkCircle,
                                              size: 20,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              approvedData[index]
                                                  ['APPLICATION_STATUS'],
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 14),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        Text(
                                          "Purpose",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Flexible(
                                            child: SingleChildScrollView(
                                              child: Text(
                                                approvedData[index]['PURPOSE'],
                                                textAlign: TextAlign.justify,

                                                // maxLines: 4,
                                              ),
                                            ),
                                          ),
                                        ),
                                        // SizedBox(height: 5),
                                      ],
                                    ),
                                  ),
                                );
                              })))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  _loadpendingbooking() {
    http.post(Uri.parse(server + "/load_booking.php"), body: {
      "bookingstatus": "Pending",
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
        setState(() {
          // titlecenter = "No action available";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          pendingData = extractdata["bookinglist"];
        });
      }
    }).catchError((err) {});
  }

  _loadapprovebooking() {
    http.post(Uri.parse(server + "/load_booking.php"), body: {
      "bookingstatus": "Approve",
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
        setState(() {
          // titlecenter = "No action available";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          approvedData = extractdata["bookinglist"];
        });
      }
    }).catchError((err) {});
  }
}

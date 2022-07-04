// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kok_pinjaman/navigationbarscreen.dart';
import 'package:kok_pinjaman/user.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ApplicantData extends StatefulWidget {
  final User user;

  const ApplicantData({Key? key, required this.user}) : super(key: key);

  @override
  State<ApplicantData> createState() => _ApplicantDataState();
}

class _ApplicantDataState extends State<ApplicantData> {
  late double screenHeight, screenWidth;

  TextEditingController _inasisEditingController = new TextEditingController();
  TextEditingController _purposeEditingController = new TextEditingController();
  TextEditingController _bookingdateEditingController =
      new TextEditingController();
  TextEditingController _returndateEditingController =
      new TextEditingController();

  String server = "https://seriouslaa.com/rentApplicationSystem/php";
  final _formKey = GlobalKey<FormState>();

  String _startDate = '';

  String _returnDate = '';

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Applicant Info'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Applicant Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Form(
                    // autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("FULL NAME: "),
                              Text("    " + widget.user.name),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("IC NUMBER: "),
                              Text("    " + widget.user.nokp),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text("MATRIC NUMBER: "),
                              Text("    " + widget.user.matrik),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("INASIS:       "),
                                SizedBox(
                                  width: screenWidth / 1.5,
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your inasis address';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      minLines: null,
                                      maxLines: null,
                                      textAlign: TextAlign.start,
                                      controller: _inasisEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'INASIS',
                                        alignLabelWithHint: true,
                                        labelStyle:
                                            TextStyle(color: Colors.blue),
                                        enabledBorder: OutlineInputBorder(),
                                        border: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(50),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("PURPOSE:  "),
                                SizedBox(
                                  width: screenWidth / 1.5,
                                  child: TextFormField(
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        return null;
                                      },
                                      textInputAction: TextInputAction.newline,
                                      keyboardType: TextInputType.multiline,
                                      minLines: null,
                                      maxLines: null,
                                      textAlign: TextAlign.start,
                                      controller: _purposeEditingController,
                                      decoration: InputDecoration(
                                        hintText: 'PURPOSE',
                                        alignLabelWithHint: true,
                                        labelStyle:
                                            TextStyle(color: Colors.blue),
                                        enabledBorder: OutlineInputBorder(),
                                        border: OutlineInputBorder(
                                          // borderRadius: BorderRadius.circular(50),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text("Start Date:           "),
                              Text(_startDate),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text("Return Date:       "),
                              Text(_returnDate),
                            ],
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            height: 30,
                            width: screenWidth / 3,
                            child: MaterialButton(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Text('Select Date',
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                              color: Colors.grey[100],
                              onPressed: choosedate,
                            ),
                          ),
                          SizedBox(height: 30),
                          SizedBox(
                            height: 50,
                            width: screenWidth / 1.2,
                            child: MaterialButton(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Text('Register',
                                  style: TextStyle(
                                    color: Colors.black,
                                  )),
                              color: Colors.blue[100],
                              onPressed: _register,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate =
            '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} ';
        // ignore: lines_longer_than_80_chars
        _returnDate =
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      }
    });
  }

  _register() {
    var now = DateTime.now();
    var formatter = DateFormat('ddMMyyyy');

    String orderid = formatter.format(now) + randomAlphaNumeric(3);
    String inasis = _inasisEditingController.text;
    String purpose = _purposeEditingController.text;

    if (_formKey.currentState!.validate()) {
      http.post(Uri.parse(server + "/applicant.php"), body: {
        "orderid": orderid,
        "email": widget.user.email,
        "inasis": inasis,
        "purpose": purpose,
        "matrik": widget.user.matrik,
        "applicantname": widget.user.name,
        "startdate": _startDate,
        "returndate": _returnDate,
        "applicationStatus": "Pending",
        "returnStatus": "Not Return",
        "rentStatus": "Pending",
      }).then((res) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => NavigationBarScreen(
                      user: widget.user,
                    )));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }).catchError((err) {
        print(err);
      });
    }
  }

  choosedate() {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  "Select New Delivery Location",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                titlePadding: EdgeInsets.all(5),
                //content: Text(curaddress),
                actions: <Widget>[
                  SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    //minWidth: 200,
                    height: 30,
                    child: Text('OK '),
                    color: Color.fromRGBO(101, 255, 218, 50),
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      return;
    }
  }
}

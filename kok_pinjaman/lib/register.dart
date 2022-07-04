// ignore_for_file: unnecessary_new, prefer_final_fields, prefer_const_constructors, sized_box_for_whitespace, avoid_print, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kok_pinjaman/login.dart';
import 'package:kok_pinjaman/navigationbarscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late double screenHeight, screenWidth;

  String server = "https://seriouslaa.com/rentApplicationSystem/php";
  String? selectedGender;
  List<String> items = ['Male', 'Female'];
  //Text
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _matrikEditingController = new TextEditingController();
  TextEditingController _icnoEditingController = new TextEditingController();
  TextEditingController _phoneEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _confirmpasswordEditingController =
      new TextEditingController();
  TextEditingController _passwordEditingController =
      new TextEditingController();

  bool _showPassword = false;
  bool _showPassword1 = false;
  void _passwordvisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _passwordvisibility1() {
    setState(() {
      _showPassword1 = !_showPassword1;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
                child: Stack(
              children: [
                Container(
                  height: screenHeight / 3,
                  width: screenWidth,
                  color: Colors.blue,
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      FractionallySizedBox(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Setting up your Account now",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                child: Text(
                                  "Already have an account? Login",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                                // ignore: sdk_version_set_literal
                                onTap: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Login()))
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          elevation: 10,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    "User Information",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Form(
                                    // autovalidateMode: AutovalidateMode.always,
                                    key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 10, 10, 10),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your full name';
                                                }
                                                return null;
                                              },
                                              textAlign: TextAlign.start,
                                              controller:
                                                  _nameEditingController,
                                              keyboardType: TextInputType.name,
                                              decoration: InputDecoration(
                                                hintText: 'Full Name',
                                                alignLabelWithHint: true,
                                                labelStyle: TextStyle(
                                                    color: Colors.blue),
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  // borderRadius: BorderRadius.circular(50),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your matrik number';
                                                }
                                                return null;
                                              },
                                              textAlign: TextAlign.start,
                                              controller:
                                                  _matrikEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'Matrik Number',
                                                alignLabelWithHint: true,
                                                labelStyle: TextStyle(
                                                    color: Colors.blue),
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  // borderRadius: BorderRadius.circular(50),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    hint: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Gender',
                                                      ),
                                                    ),
                                                    items: items
                                                        .map((item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                              value: item,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Text(
                                                                  item,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ))
                                                        .toList(),
                                                    value: selectedGender,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedGender =
                                                            value as String;
                                                      });
                                                    },
                                                    buttonHeight: 60,
                                                    // buttonWidth: screenWidth / 1.4,
                                                    // itemHeight: 40,
                                                    buttonDecoration:
                                                        BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              validator: (value) => EmailValidator
                                                      .validate(value)
                                                  ? null
                                                  : "Please enter a valid email",
                                              textAlign: TextAlign.start,
                                              controller:
                                                  _emailEditingController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                hintText: 'Email Address',
                                                alignLabelWithHint: true,
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  // borderRadius: BorderRadius.circular(50),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your IC number';
                                                }
                                                return null;
                                              },
                                              textAlign: TextAlign.start,
                                              controller:
                                                  _icnoEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'IC Number',
                                                alignLabelWithHint: true,
                                                labelStyle: TextStyle(
                                                    color: Colors.blue),
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  // borderRadius: BorderRadius.circular(50),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter your phone number';
                                                }
                                                return null;
                                              },
                                              textAlign: TextAlign.start,
                                              controller:
                                                  _phoneEditingController,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: 'Phone Number',
                                                alignLabelWithHint: true,
                                                labelStyle: TextStyle(
                                                    color: Colors.blue),
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  // borderRadius: BorderRadius.circular(50),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter password';
                                                }
                                                return null;
                                              },
                                              obscureText: !_showPassword,
                                              textAlign: TextAlign.start,
                                              controller:
                                                  _passwordEditingController,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              decoration: InputDecoration(
                                                hintText: 'Password',
                                                alignLabelWithHint: true,
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  // borderRadius: BorderRadius.circular(50),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    _passwordvisibility();
                                                  },
                                                  child: Icon(
                                                    _showPassword
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty ||
                                                    _confirmpasswordEditingController
                                                            .text !=
                                                        _passwordEditingController
                                                            .text) {
                                                  return 'Password not match';
                                                }
                                                return null;
                                              },
                                              obscureText: !_showPassword1,
                                              textAlign: TextAlign.start,
                                              controller:
                                                  _confirmpasswordEditingController,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              decoration: InputDecoration(
                                                hintText: 'Confirm Password',
                                                alignLabelWithHint: true,
                                                enabledBorder:
                                                    OutlineInputBorder(),
                                                border: OutlineInputBorder(
                                                  // borderRadius: BorderRadius.circular(50),
                                                  borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 2),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.black)),
                                                suffixIcon: GestureDetector(
                                                  onTap: () {
                                                    _passwordvisibility1();
                                                  },
                                                  child: Icon(
                                                    _showPassword1
                                                        ? Icons.visibility
                                                        : Icons.visibility_off,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              )),
                                          SizedBox(height: 20),
                                          SizedBox(
                                            height: 50,
                                            width: screenWidth / 1.2,
                                            child: MaterialButton(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: Text('Register',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  )),
                                              color: Colors.blue[100],
                                              // ignore: sdk_version_set_literal
                                              onPressed: _register,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ))),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            ))));
  }

  void _register() {
    String name = _nameEditingController.text;
    String matrik = _matrikEditingController.text;
    String icno = _icnoEditingController.text;
    String phone = _phoneEditingController.text;
    String email = _emailEditingController.text;
    String password = _passwordEditingController.text;

    if (_formKey.currentState!.validate()) {
      ProgressDialog pb = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pb.style(message: "Loading...");
      pb.show();
      http.post(Uri.parse(server + "/register.php"), body: {
        "name": name,
        "matrik": matrik,
        "icno": icno,
        "phone": phone,
        "selectedGender": selectedGender,
        "email": email,
        "password": password,
      }).then((res) {
        print(res);
        pb.hide();
        if (res.body == "success") {
          Navigator.pop(context,
              MaterialPageRoute(builder: (BuildContext context) => Login()));
          Toast.show("Registration success", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
      });
    }
  }
}

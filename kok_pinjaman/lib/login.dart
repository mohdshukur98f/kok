// ignore_for_file: unnecessary_new, prefer_final_fields, prefer_const_constructors, sized_box_for_whitespace, avoid_print

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:kok_pinjaman/navigationbarscreen.dart';
import 'package:kok_pinjaman/register.dart';
import 'package:kok_pinjaman/user.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late double screenHeight, screenWidth;
  String server = "https://seriouslaa.com/rentApplicationSystem/php";

  TextEditingController _useremailEditingController =
      new TextEditingController();
  TextEditingController _passwordEditingController =
      new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool rememberMe = false;

  void _passwordvisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [
              Column(children: [
                Container(
                  height: screenHeight / 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight / 30,
                        ),
                        Text(
                          "Welcome to",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height: screenHeight / 5,
                                width: screenWidth / 2,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/logokok.png'),
                                        fit: BoxFit.contain))),
                          ],
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: screenHeight / 1.8,
                    width: screenWidth / 1.1,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "LOG IN",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            TextFormField(
                                validator: (value) =>
                                    EmailValidator.validate(value)
                                        ? null
                                        : "Please enter a valid email",
                                textAlign: TextAlign.start,
                                controller: _useremailEditingController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  alignLabelWithHint: true,
                                  enabledBorder: OutlineInputBorder(),
                                  border: OutlineInputBorder(
                                    // borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                )),
                            SizedBox(height: 20),
                            TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                                obscureText: !_showPassword,
                                textAlign: TextAlign.start,
                                controller: _passwordEditingController,
                                keyboardType: TextInputType.visiblePassword,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  alignLabelWithHint: true,
                                  enabledBorder: OutlineInputBorder(),
                                  border: OutlineInputBorder(
                                    // borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
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
                          ]),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: <Widget>[
                              Switch(
                                value: rememberMe,
                                onChanged: (bool? value) {
                                  setState(() {
                                    rememberMe = value!;
                                    _onRememberMeChanged(value);
                                  });
                                },
                              ),
                              Text('Remember Me ',
                                  style: TextStyle(
                                      // fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                            ],
                          ),
                          GestureDetector(
                            onTap: _forgotPassword,
                            child: Text(
                              'Forgot Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            height: screenHeight / 13,
                            width: screenWidth / 2.5,
                            child: MaterialButton(
                                // elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: const Text('Log In',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                color: Colors.blue[100],
                                onPressed: _login),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth / 2.5,
                            child: Divider(
                              thickness: 3,
                              color: Colors.blue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "OR",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth / 2.5,
                            child: Divider(
                              thickness: 3,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: screenHeight / 13,
                        width: screenWidth / 2.5,
                        child: MaterialButton(
                            // elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: const Text('Create Account',
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                            color: Colors.blue[100],
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Register()));
                            }),
                      ),
                    ]),
                  ),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }

  _login() {
    if (_formKey.currentState!.validate()) {
      ProgressDialog pb = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pb.style(message: "Log in...");

      pb.show();

      String _useremail = _useremailEditingController.text;
      String _password = _passwordEditingController.text;

      http.post(Uri.parse(server + "/login.php"), body: {
        "useremail": _useremail,
        "password": _password,
      })
          // .timeout(const Duration(seconds: 4))
          .then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
              matrik: userdata[1],
              email: userdata[2],
              password: userdata[3],
              name: userdata[4],
              telephone: userdata[5],
              nokp: userdata[6],
              gender: userdata[7]);
          pb.hide();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => NavigationBarScreen(
                        user: _user,
                      )));
        } else {
          pb.hide();
          showDialog(
              context: context,
              builder: (context) => new AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: new Text(
                      'Invalid email or password!',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            "Okay",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )),
                    ],
                  ));
        }
      }).catchError((err) {
        print(err);
      });
    }
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });
  void savepref(bool value) async {
    String username = _useremailEditingController.text;
    String password = _passwordEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('username', username);
      await prefs.setString('password', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('username', '');
      await prefs.setString('password', '');
      setState(() {
        _useremailEditingController.text = '';
        _passwordEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  void _forgotPassword() {}
}

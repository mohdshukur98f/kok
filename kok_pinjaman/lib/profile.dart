// ignore_for_file: prefer_const_constructors, duplicate_ignore, import_of_legacy_library_into_null_safe

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kok_pinjaman/navigationbarscreen.dart';
import 'package:kok_pinjaman/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late double screenHeight, screenWidth;
  String server = "https://seriouslaa.com/rentApplicationSystem/php";

  String? selectedGender;
  List<String> items = ['Male', 'Female'];
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController icnoEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController matricEditingController = TextEditingController();

  TextEditingController oldpasswordEditingController = TextEditingController();
  TextEditingController newpasswordEditingController = TextEditingController();
  TextEditingController confirmpasswordEditingController =
      TextEditingController();

  bool editProfile = false;
  bool _showPassword = false;

  void _passwordvisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _editProfileVisibility() {
    setState(() {
      editProfile = !editProfile;
    });
  }

  @override
  void initState() {
    super.initState();

    nameEditingController.text = widget.user.name;
    icnoEditingController.text = widget.user.nokp;
    phoneEditingController.text = widget.user.telephone;
    // passwordEditingController.text = widget.user.userpassword;
    // selectedGender = widget.user.gender;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Material App',
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
            child: Stack(children: [
              upper(context),
              lower(context),
            ]),
          ),
        ),
      ),
    );
  }

  upper(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: screenHeight / 3,
    );
  }

  lower(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight / 10.3,
          ),
          Text(
            "Profile",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            height: screenHeight / 10,
            width: screenWidth / 4,
            child: Center(
                child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/userdefault.jpg'),
            )
                // Your Widget
                ),
          ),
          editProfile == false
              ? Padding(
                  padding: EdgeInsets.fromLTRB(20, screenHeight / 10, 20, 0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: "   " + widget.user.name,
                            enabled: editProfile,
                            textCapitalization: TextCapitalization.characters,
                            style: TextStyle(fontSize: 15),
                            controller: null,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              prefix: Icon(Icons.person),
                              labelText: "Full Name",
                            ),
                          ),
                          TextFormField(
                            initialValue: "   " + widget.user.matrik,
                            enabled: editProfile,
                            textCapitalization: TextCapitalization.none,
                            style: TextStyle(fontSize: 15),
                            controller: null,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefix: Icon(MdiIcons.formatListNumbered),
                              labelText: "Matrik Number",
                            ),
                          ),
                          TextFormField(
                            initialValue: "  " + widget.user.nokp,
                            enabled: editProfile,
                            textCapitalization: TextCapitalization.characters,
                            style: TextStyle(fontSize: 15),
                            controller: null,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              prefix: Icon(MdiIcons.cardAccountDetails),
                              labelText: "IC Number",
                            ),
                          ),
                          TextFormField(
                              initialValue:
                                  "  " "(+60) " + widget.user.telephone,
                              enabled: editProfile,
                              style: TextStyle(fontSize: 15),
                              controller: null,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  prefix: Icon(MdiIcons.phone),
                                  labelText: "Phone Number")),
                          TextFormField(
                            initialValue: "  " + widget.user.gender,
                            enabled: editProfile,
                            textCapitalization: TextCapitalization.characters,
                            style: TextStyle(fontSize: 15),
                            controller: null,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              prefix: Icon(MdiIcons.genderMaleFemale),
                              labelText: "Gender",
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Visibility(
                            visible: !editProfile,
                            child: SizedBox(
                              width: screenWidth / 2,
                              child: MaterialButton(
                                child: Text('EDIT',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                color: Colors.blue,
                                // ignore: sdk_version_set_literal
                                onPressed: _editProfileVisibility,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.fromLTRB(20, screenHeight / 8, 20, 0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          enabled: editProfile,
                          textCapitalization: TextCapitalization.words,
                          style: TextStyle(fontSize: 15),
                          controller: nameEditingController,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefix: Icon(Icons.person),
                            labelText: "Full Name",
                          ),
                        ),
                        TextFormField(
                            enabled: editProfile,
                            style: TextStyle(fontSize: 15),
                            controller: matricEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefix: Icon(MdiIcons.formatListNumbered),
                                labelText: "Matric Number")),
                        TextFormField(
                            enabled: editProfile,
                            style: TextStyle(fontSize: 15),
                            controller: icnoEditingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                prefix: Icon(MdiIcons.cardAccountDetails),
                                labelText: "IC Number")),
                        TextFormField(
                            enabled: editProfile,
                            style: TextStyle(fontSize: 15),
                            controller: phoneEditingController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                prefix: Icon(MdiIcons.phone),
                                labelText: "Phone Number")),
                        SizedBox(
                          height: 17,
                        ),
                        Row(
                          children: [
                            Icon(MdiIcons.genderMaleFemale),
                            Text(
                              " Gender : ",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700]),
                            ),
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  hint: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Gender',
                                    ),
                                  ),
                                  items: items
                                      .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                item,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                  value: selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedGender = value as String;
                                    });
                                  },
                                  buttonHeight: 60,
                                  // buttonWidth: screenWidth / 1.4,
                                  // itemHeight: 40,
                                  buttonDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: editProfile,
                          child: TextFormField(
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value != widget.user.password) {
                                  return 'Please enter correct old password';
                                }
                                return null;
                              },
                              obscureText: !_showPassword,
                              enabled: editProfile,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(fontSize: 15),
                              controller: oldpasswordEditingController,
                              decoration: InputDecoration(
                                  prefix: Icon(Icons.lock),
                                  suffixIcon: Visibility(
                                    visible: editProfile,
                                    child: GestureDetector(
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
                                  ),
                                  labelText: "Old Password")),
                        ),
                        Visibility(
                          visible: editProfile,
                          child: TextFormField(
                              obscureText: !_showPassword,
                              enabled: editProfile,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(fontSize: 15),
                              controller: newpasswordEditingController,
                              decoration: InputDecoration(
                                  prefix: Icon(Icons.lock),
                                  suffixIcon: Visibility(
                                    visible: editProfile,
                                    child: GestureDetector(
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
                                  ),
                                  labelText: "New Password")),
                        ),
                        Visibility(
                          visible: editProfile,
                          child: TextFormField(
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value !=
                                        newpasswordEditingController.text) {
                                  return 'Please enter correct old password';
                                }
                                return null;
                              },
                              obscureText: !_showPassword,
                              enabled: editProfile,
                              textCapitalization: TextCapitalization.characters,
                              style: TextStyle(fontSize: 15),
                              controller: confirmpasswordEditingController,
                              decoration: InputDecoration(
                                  prefix: Icon(Icons.lock),
                                  suffixIcon: Visibility(
                                    visible: editProfile,
                                    child: GestureDetector(
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
                                  ),
                                  labelText: "Confirm Password")),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        Visibility(
                          visible: editProfile,
                          child: SizedBox(
                            width: screenWidth / 2,
                            child: MaterialButton(
                              child: Text('UPDATE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              color: Colors.blue,
                              // ignore: sdk_version_set_literal
                              onPressed: updateProfile,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: editProfile,
                          child: SizedBox(
                            width: screenWidth / 2,
                            child: MaterialButton(
                              child: Text('CANCEL',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                              color: Colors.blue,
                              // ignore: sdk_version_set_literal
                              onPressed: _editProfileVisibility,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }

  updateProfile() {
    http.post(Uri.parse(server + "/update_user.php"), body: {
      "email": widget.user.email,
      "name": nameEditingController.text,
      "matric": matricEditingController.text,
      "icno": icnoEditingController.text,
      "phone": phoneEditingController.text,
      "gender": selectedGender,
      "password": newpasswordEditingController.text,
    }).then((res) {
      if (res.body == "success") {
        setState(() {
          _editProfileVisibility();

          try {
            ProgressDialog pb = ProgressDialog(context,
                type: ProgressDialogType.Normal, isDismissible: false);
            pb.style(message: "Log in...");
            pb.show();
            String _email = widget.user.email;
            String _password = newpasswordEditingController.text;
            http.post(Uri.parse(server + "/login.php"), body: {
              "useremail": _email,
              "password": _password,
            }).then((res) {
              var string = res.body;
              List userdata = string.split(",");
              if (userdata[0] == "success") {
                User _user = User(
                    matrik: userdata[1],
                    email: userdata[2],
                    password: userdata[3],
                    name: userdata[4],
                    telephone: userdata[5],
                    gender: userdata[6],
                    nokp: userdata[7]);
                pb.hide();

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    title: Text(
                      'Information Saved',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        NavigationBarScreen(user: _user)));
                          },
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )),
                      MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )),
                    ],
                  ),
                );
              } else {
                Toast.show("Information Updated", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            }).catchError((err) {});
          } on Exception catch (_) {
            Toast.show("Error", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
        });
      } else {
        Toast.show("Update failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {});
  }
}

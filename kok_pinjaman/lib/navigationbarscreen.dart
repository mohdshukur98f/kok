// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kok_pinjaman/mybooking.dart';
import 'package:kok_pinjaman/home.dart';
import 'package:kok_pinjaman/profile.dart';
import 'package:kok_pinjaman/user.dart';

class NavigationBarScreen extends StatefulWidget {
  final User user;
  const NavigationBarScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  late List<Widget> tabchildren;
  int _currentIndex = 0;
  String maintitle = "Home";
  late double screenHeight, screenWidth;

  @override
  void initState() {
    super.initState();
    tabchildren = [
      HomeScreen(user: widget.user),
      MyBookingScreen(user: widget.user),
      Profile(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        // ignore: prefer_const_literals_to_create_immutables
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.bookmark,
              ),
              label: "My Booking"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              label: "Profile")
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        maintitle = "Home";
      }
      if (_currentIndex == 1) {
        maintitle = "My Booking";
      }

      if (_currentIndex == 2) {
        maintitle = "Profile";
      }
    });
  }
}

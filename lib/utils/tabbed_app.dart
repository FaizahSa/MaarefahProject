import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/tutor/tutor_component/TutorsList.dart';
import 'package:flutter_app_1/screens/notification.dart';
import 'package:flutter_app_1/screens/profile.dart';
import 'package:flutter_app_1/screens/home_page.dart';

class TabbedApp extends StatefulWidget {
  @override
  _TabbedAppState createState() => _TabbedAppState();
}

class _TabbedAppState extends State<TabbedApp> {
  User currentUser;
  final usersRef = FirebaseFirestore.instance.collection('Learner');

  var _selectedIndex = 1;
  List<Widget> _tabViews = <Widget>[
    TutorsListPage(),
    HomePage(),
    NotificationPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _tabViews.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tutors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Account',
          ),
        ],
        iconSize: 30,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: onItemPressed,
      ),
    );
  }

  onItemPressed(index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
    }
  }
}

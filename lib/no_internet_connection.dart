import 'package:flutter/material.dart';
import 'package:flutter_app_1/utils/constants.dart';

class NoIntentConnection extends StatefulWidget {
  @override
  _NoIntentConnectionState createState() => _NoIntentConnectionState();
}

class _NoIntentConnectionState extends State<NoIntentConnection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar1(
        context,
        iconButton: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {},
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "No Internet Connection",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Please check your internet connection and try again",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 30,
                ),
                Image(
                  image: AssetImage("images/client.jpg"),
                  height: MediaQuery.of(context).size.height * 0.50,
                  width: MediaQuery.of(context).size.width * 0.99,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

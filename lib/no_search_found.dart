import 'package:flutter/material.dart';

class NoSearchFound extends StatefulWidget {
  @override
  _NoSearchFoundState createState() => _NoSearchFoundState();
}

class _NoSearchFoundState extends State<NoSearchFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff14213C),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.close_rounded),
          ),
        ],
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
                  "Oops!",
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
                  "We couldn’t find results for “Lorem” at this store.",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 16),
                ),
                SizedBox(
                  height: 30,
                ),
                Image(
                  image: AssetImage("images/oops.png"),
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

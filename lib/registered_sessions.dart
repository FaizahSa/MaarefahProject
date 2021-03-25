import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_1/component/vertical_list.dart';
import 'package:flutter_app_1/utils/constants.dart';
import 'package:flutter_app_1/utils/constants.dart';
import 'package:flutter_app_1/course_details.dart';

class RegisteredSessions extends StatefulWidget {
  @override
  _RegisteredSessionsState createState() => _RegisteredSessionsState();
}

navigateToCourseDetails(BuildContext context, DocumentSnapshot post) {
  Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CourseDetails(
                post: post,
              )));
}

class _RegisteredSessionsState extends State<RegisteredSessions> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar1(
        context,
        title: "Registered Sessions",
        iconButton: IconButton(
          icon: Icon(Icons.ios_share),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            //child: VerticalCards(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('registration')
                    .snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot doc = snapshot.data.docs[index];
                      return Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 9,
                          child: new ListTile(
                            title: new Text(doc.data()['l_name']),
                            subtitle: new Text(doc.data()['ses_name']),
                            isThreeLine: true,
                            leading: new Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/ma-arefah-app.appspot.com/o/" +
                                  doc.data()['image_name'] +
                                  "?alt=media&token=" +
                                  doc.data()['imageToken'],
                              width: 40,
                              height: 200,
                              fit: BoxFit.fill,
                            ),
                            onTap: () {
                              navigateToCourseDetails(
                                  context, snapshot.data.docs[index]);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

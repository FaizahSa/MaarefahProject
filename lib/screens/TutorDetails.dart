import 'package:flutter/material.dart';
import 'package:flutter_app_1/utils/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_1/tutor/tutor_component/tutorsList.dart';
import 'package:flutter_app_1/models/users.dart';
import 'package:flutter_app_1/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/constants.dart';

// ignore: camel_case_types
class MyTutorDetails extends StatefulWidget {
  final DocumentSnapshot post;

  MyTutorDetails({
    this.post,
  });

  @override
  _MyTutorDetailsState createState() => _MyTutorDetailsState();
}

// ignore: camel_case_types
class _MyTutorDetailsState extends State<MyTutorDetails> {
  final _formKey = GlobalKey<FormState>();
  String reviewtxt;
  var rating = 0.0;
  OurUser _currentUser = OurUser();
  OurUser _cUser;
  OurUser get getCurrntUser => _currentUser;

  Future<void> getUserInfo() async {
    User _firebaseUser = FirebaseAuth.instance.currentUser;
    _currentUser = await OurDatabase().getuserInfo(_firebaseUser.uid);
    setState(() {
      _cUser = _currentUser;
    });
    print(_cUser);
  }

  Stream<dynamic> getSessionsByTutor() {
    // var tname = ;
    Stream<QuerySnapshot> x = FirebaseFirestore.instance
        .collection('session')
        .where(
          "tutor_name",
          isEqualTo: widget.post.data()['name'],
        )
        .where('approved', isEqualTo: 'yes')
        .snapshots();

    return x;
  }

  int docCount = 0;
  Future<void> countSessions() async {
    // var tname = ;
    QuerySnapshot x = await FirebaseFirestore.instance
        .collection('session')
        .where(
          "tutor_name",
          isEqualTo: widget.post.data()['name'],
        )
        .where('approved', isEqualTo: 'yes')
        .get();
    setState(() {
      docCount = x.docs.length;
    });
    print(docCount);
  }

  int docCount2 = 0;
  Future<void> countReviews() async {
    //var tname = ;
    QuerySnapshot x = await FirebaseFirestore.instance
        .collection('ratings')
        .where(
          "tutor_name",
          isEqualTo: widget.post.data()['name'],
        )
        .get();
    setState(() {
      docCount2 = x.docs.length;
    });
    print(docCount2);
  }

  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    countSessions();
    countReviews();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    // var thetutorname = widget.post.data()['name'];
    countSessions();
    return Scaffold(
      appBar: myAppBar1(
        context,
        title: "Tutor Details",
        iconButton: IconButton(
          icon: Icon(Icons.ios_share),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 40,
                      backgroundImage:
                          NetworkImage(widget.post.data()['avatar_url']),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    //margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.fromLTRB(4, 20, 4, 20),
                    width: 300,
                    height: 70,
                    child: Text(widget.post.data()['name'],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300],
                      width: 3.0,
                    ),
                  ),
                ),
                width: 110.0,
                height: 80.0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(docCount.toString(), style: h4),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sessions', style: style),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300],
                      width: 3.0,
                    ),
                  ),
                ),
                width: 110.0,
                height: 80.0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(docCount2.toString(), style: h4),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Reviews', style: style),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[300],
                      width: 3.0,
                    ),
                  ),
                ),
                width: 110.0,
                height: 80.0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(4.5.toString(), style: h4),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Reviews', style: style),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              height: 40,
              child: ListView(
                children: <Widget>[
                  _buildCardListView(),
                  Container(
                      margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      width: double.infinity,
                      height: 220,
                      child: printreview()),
                  Container(
                    child: sendreview(widget.post.data()['name']),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sendreview(dynamic aa) {
    if (aa != _cUser.uid) {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            Text("What is your rate?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SmoothStarRating(
                  rating: rating,
                  isReadOnly: false,
                  size: 35,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 1.0,
                  color: Colors.yellow,
                  borderColor: Colors.yellow,
                  onRated: (value) {
                    rating = value;
                    print("rating value -> $value");
                    // print("rating value dd -> ${value.truncate()}");
                  },
                )),
            Text("How was your experience with this tutor?", style: h5),
            SizedBox(
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                          maxLines: 5,
                          obscureText: false,
                          style: h5,
                          validator: textReviewValidation,
                          onSaved: (value) {
                            reviewtxt = value;
                          },
                          decoration: textInputDecoratuon.copyWith(
                            hintText: 'Write your Review here',
                          )),
                    ],
                  )),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(100, 0, 100, 20),
                child: MaterialButton(
                  color: Color(0xffF9A21B),
                  onPressed: _sendToServer,
                  padding: EdgeInsets.fromLTRB(15.0, 18.0, 15.0, 18.0),
                  child: Text(
                    'Send Review',
                    style: yellowButtonsTextStyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Text(
          'You can not rate yourself',
          style: style,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget printreview() {
    // var tname = ;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('ratings')
            .where(
              "tutor_name",
              isEqualTo: widget.post.data()['name'],
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: const Text('There are no reviews on this tutor...'));
          }

          return ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = snapshot.data.docs[index];
              var rat = double.parse(doc.data()['rating']);
              return Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.account_circle_outlined,
                          size: 70,
                        ),
                        title: Text(
                          doc.data()['l_name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RatingBar.builder(
                        initialRating: rat,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemSize: 20,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        doc.data()['body'],
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  void calculateRating() {
//     var total = 0;
//     Future x =
//         FirebaseFirestore.instance.collection('ratings')
//         .doc('VVxZWXuZM5sw0RZldntf')
//         .collection('is_rating')
//         .get()
//         .then(querySnapshot => {
//     querySnapshot.forEach(adding(){

//     });
// });
    // x.forEach(function(x){
    //   total += x.val().rating;
    // });

//     var _db=FirebaseFirestore.instance.collection('ratings').snapshots();
//     _db.forEach((QuerySnapshot snapshot) {
//    Map<dynamic, dynamic> values=snapshot.docs;
//    print(values.toString());
//      values.forEach((k,v) {
//         print(k);
//         print(v["name"]);
//      });
//  }
//  );
  }

  void _sendToServer() {
    if (_formKey.currentState.validate()) {
      //No error in validator
      _formKey.currentState.save();
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        CollectionReference reference =
            FirebaseFirestore.instance.collection('ratings');
        await reference.add({
          'body': '$reviewtxt',
          'l_name': _cUser.name,
          'tutor_name': widget.post.data()['name'],
          'rating': '$rating',
        });
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TutorsList(),
        ),
      );
    } else {
      setState(() {
        return AutovalidateMode.disabled;
      });
    }
  }

  Widget _buildCardListView() {
    //if (getSessionsByTutor().Documents.length>0) {
    var x = getSessionsByTutor();
    return SizedBox(
        height: 200.0,
        child: StreamBuilder(
          stream: x,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: const Text('No sessions made yet...'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.docs.length,
              itemExtent: 180.0,
              itemBuilder: (context, index) {
                DocumentSnapshot doc = snapshot.data.docs[index];
                return Card(
                  elevation: 10.0,
                  margin: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(doc.data()['image_url']),
                              fit: BoxFit.fitHeight,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          doc.data()['ses_name'],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          },
        ));
    // } else {
    //   return Text('No Data to be shown');
    // }
  }
}

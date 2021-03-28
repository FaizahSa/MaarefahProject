import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/models/users.dart';
import 'package:flutter_app_1/screen%20messages/tutor_add_session_congrats.dart';
import 'package:flutter_app_1/services/database.dart';
import '../utils/constants.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class AddSessionPage extends StatefulWidget {
  AddSessionPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _AddSessionPage createState() => _AddSessionPage();
}

bool visibilityValue = false;
String sessionName,
    valueChoose,
    sessionDescription,
    sessionAgenda,
    sessionRequirements;

final sessionNumController = TextEditingController();

num sessionNumber;

List sessionTypes = ["College Courses", "Additional Skills Courses"];
List levelsList = ["4th", "5th", "6th", "7th", "8th", "9th", "10th"];

String coursesValue;
List coursesList = [
  "Object Oriented Programming 1",
  "Discreate Math",
  "Operating Systems"
];

String locationGroupValue = '';
String daysGroupValue = '';
String timeGroupValue = '';

bool isLocationSelected = false;
bool isDaySelected = false;
bool isTimeSelected = false;

bool buttonDisabled = false;

final _formKey = GlobalKey<FormState>();

class _AddSessionPage extends State<AddSessionPage> {
  // String imageUrl;
  String url;
  //generating random uuid
  String sessionId = Uuid().v4();

  //getting current user information
  OurUser _currentUser = OurUser();
  OurUser _cUser;
  OurUser get getCurrntUser => _currentUser;
  Future<void> getUserInfo() async {
    User _firebaseUser = FirebaseAuth.instance.currentUser;
    _currentUser = await OurDatabase().getuserInfo(_firebaseUser.uid);
    setState(() {
      _cUser = _currentUser;
    });
  }

  User user;
  Future<void> getUserData() async {
    User userData = FirebaseAuth.instance.currentUser;
    setState(() {
      user = userData;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Widget build(BuildContext context) {
    // Future getImage() async {
    //   final imagePicker = ImagePicker();
    //   PickedFile image =
    //       await imagePicker.getImage(source: ImageSource.gallery);
    //   setState(() {
    //     _image = File(image.path);
    //     print('image path $_image');
    //   });
    // }
    // uploadPic(BuildContext context) async {
    //   FirebaseStorage storage = FirebaseStorage.instance;
    //   String fileName = basename(_image.path);
    //   String url;
    //   Reference ref = storage.ref().child(fileName);
    //   UploadTask uploadTask = ref.putFile(_image);
    //   uploadTask.whenComplete(() {
    //     url = ref.getDownloadURL().toString();
    //   }).catchError((onError) {
    //     print(onError);
    //   });
    //   return url;
    // }

    void _sendToServer() {
      if (_formKey.currentState.validate()) {
        // uploadPic(context);
        _formKey.currentState.save();
        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          CollectionReference reference =
              FirebaseFirestore.instance.collection('add_session_request');
          await reference.add({
            'sessionName': '$sessionName',
            'session_type': '$valueChoose',
            'sessionId': '$sessionId',
            'course_name': '$coursesValue',
            'session_description': '$sessionDescription',
            'session_location': '$locationGroupValue',
            'session_requirements': '$sessionRequirements',
            'session_agenda': '$sessionAgenda',
            'academic_level': '${_cUser.academicLevel}',
            'tutorName': '${_cUser.name}',
            'tutor_PhoneNum': '${_cUser.phoneNum}',
            'tutor_email': '${_cUser.email}',
            'session_number_of_hours': sessionNumController.text,
            'suitable_tutoring_days': '$daysGroupValue',
            'suitable_session_times': '$timeGroupValue',
            'image_url': '$url',
            //'sessionImage': '$url',
          });
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AddSessionCongrats(),
          ),
          (route) => false,
        );
      } else {
        setState(() {
          return AutovalidateMode.disabled;
        });
      }
    }

    final requistButton = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xffF9A21B),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(30.0, 15.0, 20.0, 15.0),
          disabledColor: Colors.grey,
          onPressed: isLocationSelected && isDaySelected && isTimeSelected
              ? () {
                  _sendToServer();
                }
              : null,
          child: Text("Add Now",
              textAlign: TextAlign.center, style: yellowButtonsTextStyle),
        ));

    return Scaffold(
      appBar: myAppBar2(context, title: 'Add Session'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(36),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text("Upload Session image",
                      textAlign: TextAlign.left, style: h4),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  child: (url != null)
                      ? Image.network(
                          url,
                          fit: BoxFit.fill,
                          height: 200,
                          width: double.infinity,
                        )
                      : Placeholder(
                          fallbackHeight: 200,
                          fallbackWidth: double.infinity,
                        ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 40.0,
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.upload_rounded),
                    label: Text("upload image"),
                    style: ElevatedButton.styleFrom(
                      primary: accentYellow,
                    ),
                    onPressed: () => uploadImage(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text("Session Name",
                      textAlign: TextAlign.left, style: h4),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  obscureText: false,
                  style: h5,
                  validator: nameValidation,
                  decoration: textInputDecoratuon.copyWith(
                    hintText: 'Session Name',
                  ),
                  onSaved: (value) {
                    sessionName = value;
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text("Session Type",
                      textAlign: TextAlign.left, style: h4),
                ),
                SizedBox(
                  height: 15.0,
                ),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(5.0)))),
                  hint: Text('Session Type'),
                  icon: Icon(Icons.arrow_drop_down),
                  style: h5,
                  isExpanded: true,
                  validator: (value) =>
                      value == null ? '   This field is required' : null,
                  value: valueChoose,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoose = newValue;
                      newValue == 'College Courses'
                          ? visibilityValue = true
                          : visibilityValue = false;
                    });
                  },
                  items: sessionTypes.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text('Type: ' + valueItem),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Visibility(
                  visible: visibilityValue,
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    hint: Text('Course Name'),
                    icon: Icon(Icons.arrow_drop_down),
                    style: h5,
                    isExpanded: true,
                    validator: (value) =>
                        value == null ? '   This field is required' : null,
                    value: coursesValue,
                    onChanged: (course) {
                      setState(() {
                        coursesValue = course;
                      });
                    },
                    onSaved: (course) {
                      setState(() {
                        coursesValue = course;
                      });
                    },
                    items: coursesList.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text('Course: ' + valueItem),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text("Session Description",
                      textAlign: TextAlign.left, style: h4),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  maxLines: 3,
                  style: h5,
                  validator: textAreaValidation,
                  decoration: textInputDecoratuon.copyWith(
                      hintText: "Enter your text here"),
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    sessionDescription = value;
                  },
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text(
                    "Session Agenda",
                    textAlign: TextAlign.left,
                    style: h4,
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  maxLines: 3,
                  style: h5,
                  validator: textAreaValidation,
                  decoration: textInputDecoratuon.copyWith(
                      hintText: "Enter your text here"),
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    sessionAgenda = value;
                  },
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text("Session Location",
                      textAlign: TextAlign.left, style: h4),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
                  width: double.infinity,
                  height: 55,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Radio(
                            value: 'Physical',
                            groupValue: locationGroupValue,
                            activeColor: Colors.orange,
                            onChanged: (val) {
                              setState(() {
                                locationGroupValue = val;
                                isLocationSelected = true;
                              });
                            }),
                        Text('Physical'),
                        Radio(
                            value: 'Online',
                            groupValue: locationGroupValue,
                            activeColor: Colors.orange,
                            onChanged: (val) {
                              setState(() {
                                locationGroupValue = val;
                                isLocationSelected = true;
                              });
                            }),
                        Text('Online'),
                      ]),
                ),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text(
                    "Session Requirements",
                    textAlign: TextAlign.left,
                    style: h4,
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  maxLines: 3,
                  style: h5,
                  validator: textAreaValidation,
                  decoration: textInputDecoratuon.copyWith(
                      hintText: "Enter your text here"),
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    sessionRequirements = value;
                  },
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text(
                    "Number of hours for the session",
                    textAlign: TextAlign.left,
                    style: h4,
                  ),
                ),
                SizedBox(height: 15.0),
                NumberInputWithIncrementDecrement(
                  controller: sessionNumController,
                  min: 1,
                  max: 10,
                  numberFieldDecoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  widgetContainerDecoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  incIconDecoration: BoxDecoration(
                    color: accentYellow,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  separateIcons: true,
                  decIconDecoration: BoxDecoration(
                    color: accentYellow,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  incIconSize: 28,
                  decIconSize: 28,
                  incIcon: Icons.keyboard_arrow_up,
                  decIcon: Icons.keyboard_arrow_down,
                ),
                SizedBox(height: 15.0),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text(
                    "Suitable Tutoring Days",
                    textAlign: TextAlign.left,
                    style: h4,
                  ),
                ),
                SizedBox(height: 15),
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 200,
                    child: SingleChildScrollView(
                      child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: FlexColumnWidth(5),
                            1: FlexColumnWidth(7),
                            2: FlexColumnWidth(5),
                            3: FlexColumnWidth(7),
                          },
                          children: [
                            TableRow(
                              children: [
                                Radio(
                                    value: 'Sunday',
                                    groupValue: daysGroupValue,
                                    activeColor: Colors.orange,
                                    onChanged: (val) {
                                      setState(() {
                                        daysGroupValue = val;
                                        isDaySelected = true;
                                      });
                                    }),
                                Text('Sunday'),
                                Radio(
                                    value: 'Monday',
                                    groupValue: daysGroupValue,
                                    activeColor: Colors.orange,
                                    onChanged: (val) {
                                      setState(() {
                                        daysGroupValue = val;
                                        isDaySelected = true;
                                      });
                                    }),
                                Text('Monday'),
                              ],
                            ),
                            TableRow(children: [
                              Radio(
                                  value: 'Tuesday',
                                  groupValue: daysGroupValue,
                                  activeColor: Colors.orange,
                                  onChanged: (val) {
                                    setState(() {
                                      daysGroupValue = val;
                                      isDaySelected = true;
                                    });
                                  }),
                              Text('Tuesday'),
                              Radio(
                                  value: 'Wednesday',
                                  groupValue: daysGroupValue,
                                  activeColor: Colors.orange,
                                  onChanged: (val) {
                                    setState(() {
                                      daysGroupValue = val;
                                      isDaySelected = true;
                                    });
                                  }),
                              Text('Wednesday'),
                            ]),
                            TableRow(children: [
                              Radio(
                                  value: 'Thursday',
                                  groupValue: daysGroupValue,
                                  activeColor: Colors.orange,
                                  onChanged: (val) {
                                    setState(() {
                                      daysGroupValue = val;
                                      isDaySelected = true;
                                    });
                                  }),
                              Text('Thursday'),
                              Radio(
                                  value: 'Friday',
                                  groupValue: daysGroupValue,
                                  activeColor: Colors.orange,
                                  onChanged: (val) {
                                    setState(() {
                                      daysGroupValue = val;
                                      isDaySelected = true;
                                    });
                                  }),
                              Text('Friday'),
                            ]),
                            TableRow(children: [
                              Radio(
                                  value: 'Saturday',
                                  groupValue: daysGroupValue,
                                  activeColor: Colors.orange,
                                  onChanged: (val) {
                                    setState(() {
                                      daysGroupValue = val;
                                      isDaySelected = true;
                                    });
                                  }),
                              Text('Saturday'),
                              Text(' '),
                              Text(' '),
                            ])
                          ]),
                    )),
                SizedBox(height: 15),
                SizedBox(
                  height: 20.0,
                  width: double.infinity,
                  child: Text("Suitable time(s) for holding the session",
                      textAlign: TextAlign.left, style: h4),
                ),
                SizedBox(height: 15.0),
                Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 100,
                    child: SingleChildScrollView(
                      child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: FlexColumnWidth(5),
                            1: FlexColumnWidth(7),
                            2: FlexColumnWidth(5),
                            3: FlexColumnWidth(7),
                          },
                          children: [
                            TableRow(
                              children: [
                                Radio(
                                    value: '6 PM',
                                    groupValue: timeGroupValue,
                                    activeColor: Colors.orange,
                                    onChanged: (val) {
                                      setState(() {
                                        timeGroupValue = val;
                                        isTimeSelected = true;
                                      });
                                    }),
                                Text('6 PM'),
                                Radio(
                                    value: '7 PM',
                                    groupValue: timeGroupValue,
                                    activeColor: Colors.orange,
                                    onChanged: (val) {
                                      setState(() {
                                        timeGroupValue = val;
                                        isTimeSelected = true;
                                      });
                                    }),
                                Text('7 PM'),
                              ],
                            ),
                            TableRow(children: [
                              Radio(
                                  value: '8 PM',
                                  groupValue: timeGroupValue,
                                  activeColor: Colors.orange,
                                  onChanged: (val) {
                                    setState(() {
                                      timeGroupValue = val;
                                      isTimeSelected = true;
                                    });
                                  }),
                              Text('8 PM'),
                              Radio(
                                  value: '9 PM',
                                  groupValue: timeGroupValue,
                                  activeColor: Colors.orange,
                                  onChanged: (val) {
                                    setState(() {
                                      timeGroupValue = val;
                                      isTimeSelected = true;
                                    });
                                  }),
                              Text('9 PM'),
                            ]),
                          ]),
                    )),
                SizedBox(height: 35.0),
                requistButton,
                SizedBox(
                  height: 35.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  uploadImage() async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    PickedFile image;
    //check permission for accessing photos
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image.path);
      String fileName = basename(file.path);
      if (image != null) {
        //Upload to firebase
        UploadTask uploadTask =
            _storage.ref().child('sessinImages/' + fileName).putFile(file);
        // = ref.putFile(file);
        var imageUrl = await (await uploadTask).ref.getDownloadURL();
        // uploadTask.whenComplete(() {
        //   downlaodUrl = ref.getDownloadURL().toString();

        // });
        setState(() {
          url = imageUrl.toString();
        });
      } else {
        print('no path recieved');
      }
    } else {
      print('permission denied..Grant permission and try again');
    }
  }
}

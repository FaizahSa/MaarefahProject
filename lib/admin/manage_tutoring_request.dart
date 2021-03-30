import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_1/admin/applicants_details.dart';
import 'package:flutter_app_1/utils/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ManageTutoingRequest());
}

class ManageTutoingRequest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutoring Requests',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ManageTutoingRequestPage(),
    );
  }
}

class ManageTutoingRequestPage extends StatefulWidget {
  @override
  _ManageTutoingRequestState createState() => _ManageTutoingRequestState();
}

class _ManageTutoingRequestState extends State<ManageTutoingRequestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar1(
        context,
        title: 'Tutoring Requests',
        iconButton: IconButton(
          icon: Icon(Icons.menu),
          iconSize: 40,
          onPressed: () => (0),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tutoring_request')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          return Column(
            children: <Widget>[
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(50),
                    child: Text(
                      'Tutoring Requests',
                      style: h1,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Applicant uid')),
                    DataColumn(label: Text('Applicant \nName')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Option')),
                  ],
                  rows: _buildList(context, snapshot.data.docs),
                  // columnSpacing: 30,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<DataRow> _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return DataRow(
      cells: [
        DataCell(Text(record.uid)),
        DataCell(Text(record.name)),
        DataCell(Text(record.email)),
        DataCell(
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ApplicantsDetailsPage(id: record.uid)),
              );
            },
            child: Text(
              'More',
            ),
          ),
          showEditIcon: true,
        ),
      ],
      selected: true | false,
    );
  }
}

class Record {
  final String uid;
  final String name;
  final String email;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['email'] != null),
        assert(map['uid'] != null),
        uid = map['uid'],
        name = map['name'],
        email = map['email'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$uid:$name:$email>";
}
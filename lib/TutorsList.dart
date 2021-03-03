import 'package:flutter/material.dart';
import 'package:flutter_app_1/TutorCard.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TutorsList(),
  ));
}

class TutorsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff14213C),
          actions: [
            IconButton(icon: Icon(Icons.close_rounded), onPressed: () => {})
          ],
          title: Text('Tutors List'),
          leading: Icon(Icons.arrow_back_ios)),
      body: AnimationLimiter(
        child: ListView.builder(
          itemCount: 16,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TutorCard(
                        child: Column(
                          children: [Text('ggvgvg')],
                        ),
                      ),
                      TutorCard(
                        child: Column(
                          children: [Text('ggvgvg')],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
//   return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Color(0xff14213C),
//           actions: [
//             IconButton(icon: Icon(Icons.close_rounded), onPressed: () => {})
//           ],
//           leading: Icon(Icons.arrow_back_ios)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           children: <Widget>[
//             Container(
//               height: 150.0,
//               width: 150.0,
//               color: Colors.grey,
//               margin: EdgeInsets.all(20.0),
//             ),
//             Container(
//               height: 150.0,
//               width: 150.0,
//               color: Colors.grey,
//               margin: EdgeInsets.all(20.0),
//             ),
//             TutorCard(
//               child: Column(
//                 children: [Text('ggvgvg')],
//               ),
//             )
//           ],
//         ),
//       ));
// }

// class TutorsList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Tutors List',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: TutorsListPage(title: 'Tutors List'),
//     );
//   }
// }

// class TutorsListPage extends StatelessWidget {
//   TutorsListPage({Key key, this.title}) : super(key: key);
//   final String title;

//   //@override
//   //_TutorsListPage createState() => _TutorsListPage();

//   @override
//   Widget build(BuildContext context) {
//     _TutorsListPage();
//     throw UnimplementedError();
//   }
// }

// class _TutorsListPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Color(0xff41213C),
//           actions: [
//             IconButton(icon: Icon(Icons.close_rounded), onPressed: () => {})
//           ],
//           leading: Icon(Icons.arrow_back_ios)),
//     );
//   }
// }
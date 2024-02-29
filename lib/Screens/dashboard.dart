// ignore_for_file: use_build_context_synchronously

import 'package:attendance_system/Screens/Attendance_screen.dart';
import 'package:attendance_system/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  Widget fixedSizeButton(String label, VoidCallback onPressed) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  Future<void> markAttendance(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final String userId = user.uid;
      final DateTime now = DateTime.now();
      final String currentDate = "${now.year}-${now.month}-${now.day}";

      final DocumentSnapshot attendanceSnapshot = await FirebaseFirestore
          .instance
          .collection('attendance')
          .doc(userId)
          .collection('dates')
          .doc(currentDate)
          .get();

      if (!attendanceSnapshot.exists) {
        await FirebaseFirestore.instance
            .collection('attendance')
            .doc(userId)
            .collection('dates')
            .doc(currentDate)
            .set({
          'markedAt': now,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance marked for today.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have already marked attendance for today.'),
          ),
        );
      }
    }
  }

  Future<void> viewAttendance(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final String userId = user.uid;
      final DateTime now = DateTime.now();
      final String currentDate = "${now.year}-${now.month}-${now.day}";

      final QuerySnapshot attendanceData = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userId)
          .collection('dates')
          .get();
      if (attendanceData.docs.isNotEmpty) {
        List<String> attendanceDates = attendanceData.docs
            .map((doc) => doc.id)
            .toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AttendancePage(attendanceDates: attendanceDates),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No attendance data found.'),
          ),
        );
      }
    }
  }
  Future<void> sendLeaveRequest(BuildContext context, String requestMessage) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;

    if (user != null) {
      final String userId = user.uid;
      final DateTime now = DateTime.now();
      await FirebaseFirestore.instance.collection('leave_requests').add({
        'userId': userId,
        'requestMessage': requestMessage,
        'requestDate': now,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Leave request sent.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Attendance App'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              fixedSizeButton('Mark Attendance', () {
                markAttendance(context);
              }),
              const SizedBox(height: 20),
              fixedSizeButton('View Attendance', () {
                viewAttendance(context);
              }),
              const SizedBox(height: 20),
              fixedSizeButton('Send Leave Request', () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String requestMessage = '';
                    return AlertDialog(
                      title: Text('Send Leave Request'),
                      content: TextField(
                        onChanged: (value) {
                          requestMessage = value;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your leave request message',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            sendLeaveRequest(context, requestMessage);
                            Navigator.of(context).pop();
                          },
                          child: Text('Send'),
                        ),
                      ],
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
              fixedSizeButton('Log Out', () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false);
                });
              }),
            ],
          ),
        ),
      ),
    );
  }
}

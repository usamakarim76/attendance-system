import 'package:flutter/material.dart';

class AttendancePage extends StatelessWidget {
  final List<String> attendanceDates;

  const AttendancePage({Key? key, required this.attendanceDates})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Data'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 40),
            child: Text(
              'You have marked attendance on the following dates:',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DIN Condensed',
                  color: Colors.blue),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: attendanceDates.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(attendanceDates[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

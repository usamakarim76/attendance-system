import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to view student records screen

              },
              child: const Text('View Student Records'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to create reports screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewStudentRecordsScreen(userId: 'user_id_here'),
                  ),
                );
              },
              child: const Text('Create Reports'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit admin details screen

              },
              child: const Text('Edit Admin Details'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to leave approval screen

              },
              child: const Text('Leave Approval'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewStudentRecordsScreen extends StatelessWidget {
  final String userId; // Pass the user's ID to this screen

  ViewStudentRecordsScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Student Records'),
      ),
      body: StreamBuilder<List<String>>(
        stream: getUserAttendanceStream(userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final attendanceDates = snapshot.data!;

          return ListView.builder(
            itemCount: attendanceDates.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(attendanceDates[index]),
              );
            },
          );
        },
      ),
    );
  }

  getUserAttendanceStream(String userId) {
    return FirebaseFirestore.instance
        .collection('attendance')
        .doc(userId)
        .collection('dates')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }
}

import 'package:attendance_system/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Admin_Dashboard.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({Key? key}) : super(key: key);

  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  bool isPasswordSee = true;

  User? user;
  // Check if the user is an admin
  bool isAdminUser(User? user) {
    // Implement your logic to determine if the user is an admin
    // You might check their role, email, or any other criteria
    return user != null && user.email == 'admin@example.com';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.purpleAccent],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft)),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 120),
                child: Text(
                  "Welcome back!",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DIN Condensed',
                      color: Color(0xffffffff)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: const Text(
                  "Enter your credentials to continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Avenir',
                    color: Color(0xffcccbcf),
                  ),
                ),
              ),
              const SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email/Username",
                        style: TextStyle(
                          color: Color(0xffcccbcf),
                          fontFamily: 'Avenir',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailTextController,
                        cursorColor: const Color(0xffe24556),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Valid Email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xffcccbcf),
                          fontFamily: 'Avenir',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        controller: passwordTextController,
                        obscureText: isPasswordSee,
                        cursorColor: const Color(0xffffffff),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordSee == false
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color(0xffffffff),
                            ),
                            onPressed: () {
                              isPasswordSee == true
                                  ? isPasswordSee = false
                                  : isPasswordSee = true;
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Password";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.lightBlue,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        auth
                            .signInWithEmailAndPassword(
                            email: emailTextController.text,
                            password: passwordTextController.text.toString())
                            .then((value) {
                          if (isAdminUser(value.user)) {
                            // User is an admin, navigate to admin dashboard
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminDashboard(),
                              ),
                            );
                          } else {
                            // User is not an admin, navigate to user dashboard
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Dashboard(),
                              ),
                            );
                          }
                        }).catchError((error) {
                          // Handle authentication errors
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: $error'),
                            ),
                          );
                        });
                      }
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

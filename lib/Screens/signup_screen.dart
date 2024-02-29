import 'package:attendance_system/Screens/dashboard.dart';
import 'package:attendance_system/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailTextController = TextEditingController();
final TextEditingController passwordTextController =
TextEditingController();
final TextEditingController userNameTextController =
TextEditingController();
final FirebaseAuth auth = FirebaseAuth.instance;
final formKey = GlobalKey<FormState>();
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
bool isPasswordSee = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
                    padding: EdgeInsets.only(top: 80),
                    child: Text(
                      "SIGN UP NOW",
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
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Username",
                            style: TextStyle(
                              color: Color(0xffcccbcf),
                              fontFamily: 'Avenir',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: userNameTextController,
                            cursorColor: const Color(0xffe24556),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            validator: RequiredValidator(errorText: '*Required'),
                            keyboardType: TextInputType.text,
                          ),
                          const SizedBox(height: 40),
                          const Text(
                            "Email",
                            style: TextStyle(
                              color: Color(0xffcccbcf),
                              fontFamily: 'Avenir',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: emailTextController,
                            cursorColor: const Color(0xffe24556),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            validator: MultiValidator([
                              RequiredValidator(errorText: '*Required'),
                              PatternValidator("^[a-zA-Z0-9+_.]+@[gmail]+.com",
                                  errorText: 'Enter Valid Email')
                            ]),
                            keyboardType: TextInputType.emailAddress,
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
                            cursorColor: const Color(0xffe24556),
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
                            validator: MultiValidator([
                              RequiredValidator(errorText: '*Required'),
                              MinLengthValidator(8,
                                  errorText:
                                  'Password must be at least 8 digits long'),
                              PatternValidator(r'(?=.*?[#?!@$%^&*-])',
                                  errorText: 'At least one special character')
                            ]),
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
                                .createUserWithEmailAndPassword(
                                email: emailTextController.text,
                                password: passwordTextController.text)
                                .then((value) {
                              firebaseFirestore.collection("User").add({
                                "user": userNameTextController.text,
                                "email": emailTextController.text.toString(),
                                "password": passwordTextController.text.toString(),
                                "uid": auth.currentUser!.uid,
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Dashboard()));
                            });
                          }
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "ALREADY HAVE AN ACCOUNT",
                        style: TextStyle(
                          color: Color(0xffcccbcf),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Color(0xffcccbcf),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
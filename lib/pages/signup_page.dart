import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_database/pages/signin_page.dart';
import 'package:my_database/services/auth_service.dart';
import 'package:my_database/services/prefs_service.dart';
import 'package:my_database/services/utils_service.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  static const String id = "signup_page";

  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var isLoading = false;

  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignUp(){
    String name = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if(name.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser!),
    });
  }

  _getFirebaseUser(User firebaseUser) async {
    setState(() {
      isLoading = false;
    });
    if (firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireToast("Check your information");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: fullnameController,
                  decoration: const InputDecoration(
                      hintText: "Fullname"
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: "Email"
                  ),
                ),
                const SizedBox(height: 10,),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                      hintText: "Password"
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: _doSignUp,
                    color: Colors.blue,
                    child: const Text("Sign Up",style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(height: 10,),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, SignInPage.id);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text("Already have an account?",style: TextStyle(color: Colors.black),),
                        SizedBox(width: 10,),
                        Text("Sign In",style: TextStyle(color: Colors.black),),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),

          isLoading?
          Center(
            child: CircularProgressIndicator(),
          ): SizedBox.shrink(),
        ],
      ),
    );
  }

}

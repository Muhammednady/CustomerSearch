import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:customersearch/component/alert.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

TextEditingController c1 = TextEditingController();
TextEditingController c2 = TextEditingController();
   LogIn()async{

      try{
        showLoading(context);
       UserCredential uc = await FirebaseAuth.instance.signInWithEmailAndPassword(
       email:c1.text, password:c2.text);
       
       
       bool stateOfemail = uc.user!.emailVerified;
       if(stateOfemail == true){
         Navigator.of(context).pop();
         Navigator.of(context).pushReplacementNamed("homepage");
       }else{
        Navigator.of(context).pop();
        AwesomeDialog(context: context,
        padding: EdgeInsets.symmetric(horizontal: 20),
               body: Text("Go to your e-mail and verify the link to login easily..."))..show();
       }
        
     }on FirebaseAuthException catch(e){
         Navigator.of(context).pop();
         AwesomeDialog(context: context,body: Text("${e.code}"))..show();
        }

   }
 
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        
        body: Container(
          color: Colors.cyan,
          padding: EdgeInsets.all(20),
          child: ListView(
            children: [
               SizedBox(
                height: 50,
              ),
               Center(
                 child: Image.asset(
                    "images/customer.jpg",
                    fit: BoxFit.fill,
                    width: 150,
                    height: 150,
                  ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: c1,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: Colors.amber,
                      hintText: "e-mail",
                      hintStyle: Theme.of(context).textTheme.headline3,
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: c2,
                    obscureText: true,
                    decoration: InputDecoration(
                       fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.lock),
                      prefixIconColor: Colors.amber,
                      hintText: "Password",
                      hintStyle: Theme.of(context).textTheme.headline3,
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                ],
              )),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      child: Text(
                        "If you have not an account",
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        /////////Action Here/////////
                        Navigator.of(context).pushNamed("signup");
                      },
                      child: Text(
                        "click here",
                        style: TextStyle(color: Colors.amber, fontSize: 17),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.amber,),
                child: TextButton(
                  onPressed: ()async{
                       await LogIn();
                  },
                  child: Text("Log In",
                      style: Theme.of(context).textTheme.headline4),
                ),
              ),
            ],
          ),
        ));
  }

 
}

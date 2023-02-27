import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../component/alert.dart';


class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

   String? username,email,password;
   TextEditingController c1 = TextEditingController();
   TextEditingController c2 = TextEditingController();
   GlobalKey<FormState> formstate = GlobalKey<FormState>();
  
   Future<UserCredential?> SignUp()async{
    UserCredential uc ;
     if( formstate.currentState!.validate()){
       formstate.currentState!.save();    
        
        try{
             showLoading(context);
            uc = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                 email:email!, password: password!);
                           
            return uc;

        }on FirebaseAuthException catch(e){

           Navigator.of(context).pop();
          AwesomeDialog(context: context,body: Text("${e.code}"))..show();

           }
        }else{
        AwesomeDialog(context: context,body: Text("Correct your inputs"))..show();
      }
    
       return null;
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
            key: formstate,
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                validator: (value) {
                  if(value!.length > 100){
                    return "username can't be more than 100";
                  }else if(value!.length < 5){
                    return "username can't be less than 5";
                  }else return null;
                  
                },
                onSaved: (String? newValue) {
                 username = newValue;
                  
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Colors.amber,
                  hintText: "Username",
                  hintStyle:Theme.of(context).textTheme.headline3 ,
                  
                  border: OutlineInputBorder(                    
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50),),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if(value!.length > 100){
                    return "e-mail can't be more than 100";
                  }else if(value!.length < 10){
                    return "e-mail can't be less than 10";
                  }else return null;
                  
                },
                 onSaved: (String? newValue) {
                 email = newValue;
                  
                },
                controller: c1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.email),
                  prefixIconColor: Colors.amber,                 
                  hintText: "e-mail",
                  hintStyle:Theme.of(context).textTheme.headline3,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                validator: (value) {
                  if(value!.length > 100){
                    return "password can't be more than 100";
                  }else if(value!.length < 3){
                    return "password can't be less than 3";
                  }else return null;                  
                },
                 onSaved: (String? newValue) {
                 password = newValue;
                  
                },
                controller: c2,
                obscureText: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: Colors.amber,
                  hintText: "Password", 
                  hintStyle: Theme.of(context).textTheme.headline3,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(50)),
                ),
              ),
            ],
          )),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(right: 5),
                child: Text(
                  "If you have  an account",
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              InkWell(
                onTap: () {
                  /////////Action Here/////////
                   Navigator.of(context).pushNamed("login");
                 // Navigator.of(context).pop();
                },
                child: Text(
                  "click here",
                  style: TextStyle(color: Colors.amber, fontSize: 17),
                ),
              )
            ],
          ),SizedBox(height: 20,),
          Container(            
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(50)),
            child: TextButton(
              onPressed: ()async{
              UserCredential? uc  =await SignUp();
              
              bool result  = (uc == null)? false:true;        
               print("===============outside result===============");

            // If(result  ) async {
                
                print("===============inside result===============");

                if(FirebaseAuth.instance.currentUser!.emailVerified == false){
                    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                  }
                  await FirebaseFirestore.instance.collection("users").add({
                    "username":username,
                    "e-mail":email
                   });
                    print("===============inside result Again===============");

                  Navigator.of(context).pop();   //to remove AlertDialog.
          
                  Navigator.of(context).pushReplacementNamed("login");
          
              /*  ///===perhaps, we use Notification here in future======
               AwesomeDialog(context: context,dialogType: DialogType.info,
               body: Text("Go to your e-mail and verify the link to be able to login..."))..show();
                */
              }
          
              
               
               //  },
              ,child: Text(
                "Sign Up",style:Theme.of(context).textTheme.headline4,
                
              ),
            ),
          ),
        ],
      ),
    ));
    
  }
}



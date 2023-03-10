
import 'dart:io';
import 'dart:math';
import 'package:customersearch/component/alert.dart';
import 'package:path/path.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class EditCustomer extends StatefulWidget {
 final  String? customerid;
 final  String? name;
 final  String? phone;
 final  String? company;
  const EditCustomer({this.customerid,this.name,this.phone,this.company});

  @override
  State<EditCustomer> createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
  String? customername;
  String? customerphone;
  String? customercompany;
  File? image;
  Reference? imageref;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  
  Future<void>  editCustomer(context)async{
    
     if(image != null){
      
      if(formstate.currentState!.validate()){
       formstate.currentState!.save();
       showLoading(context);
       
        /* await FirebaseFirestore.instance.collection("customers").doc(widget.customerid).get().then((value) async{
           await FirebaseStorage.instance.refFromURL(value.data()!['imageUrl']).delete();
         });*/
       
      // imageref!.putFile(image!);
       
      // final String imageurl = await imageref!.getDownloadURL();

      await FirebaseFirestore.instance.collection("customers").doc(widget.customerid).update({
        "name":customername  ,
        "phone": customerphone ,
        "company":customercompany,
      //  "imageUrl":"$imageurl"  
      }).then((value) {
        Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("homepage");
      }).catchError((e){
       Navigator.of(context).pop();
       AwesomeDialog(context: context,body: Text("error happened while adding a customer"))..show();
      });      

      }
     }else{

     if(formstate.currentState!.validate()){
       formstate.currentState!.save();
       showLoading(context);

      await FirebaseFirestore.instance.collection("customers").doc(widget.customerid).update({
        "name":customername  ,
        "phone": customerphone ,
        "company":customercompany, 
      }).then((value) {
        Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed("homepage");
      }).catchError((e){
       Navigator.of(context).pop();
       AwesomeDialog(context: context,body: Text("error happened while adding a customer"))..show();
      });
     }

     }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text("Edit Customer ")),),
        body: Container(
          color: Colors.cyan,
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formstate,
                  child: Column(children: [
                  TextFormField(
                    validator: ((String? value) {
                      if(value!.length == 0 ){
                        return "Please, Enter a name for your customer";
                      }else if( value!.length > 30){
                        return "customer name is too large";
                      }else{
                        return null;
                      }                    
                    }),
                    onSaved: ((newValue) {
                      customername = newValue;
                    }),
                    maxLength: 30 ,
                    initialValue: widget.name,
                    decoration: InputDecoration(
                      filled: true, 
                      fillColor: Colors.white,               
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: Colors.amber,
                      labelText: "name",
                      labelStyle: Theme.of(context).textTheme.headline3,
                      hintText: "customer name",
                      hintStyle: Theme.of(context).textTheme.headline3,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                      
                      
                    ),
                  ),
                  TextFormField(
                    validator: ((String? value) {
                      if(value!.length == 0 ){
                        return "Please, Enter phone # for a customer";
                      }else if( value!.length > 11){
                        return "Phone number is too large";
                      }else{
                        return null;
                      }                    
                    }),
                    onSaved: ((newValue) {
                      customerphone = newValue;
                    }),
                    maxLength: 11,
                    minLines: 1,
                    initialValue: widget.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                     prefixIcon: Icon(Icons.person),
                      prefixIconColor: Colors.amber,
                      labelText: "phone",
                      labelStyle: Theme.of(context).textTheme.headline3,
                      hintText: "customer phone",
                      hintStyle: Theme.of(context).textTheme.headline3 ,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),               
                      
                    ),
                  ),
                  TextFormField(
                    validator: ((String? value) {
                      if(value!.length == 0 ){
                        return "Please, Enter a company for a customer";
                      }else if( value!.length > 50){
                        return "company name is too large";
                      }else{
                        return null;
                      }                    
                    }),
                    onSaved: ((newValue) {
                      customercompany = newValue;
                    }),
                    maxLength: 30 ,
                    initialValue: widget.company,
                    decoration: InputDecoration(
                      filled: true, 
                      fillColor: Colors.white,               
                      prefixIcon: Icon(Icons.person),
                      prefixIconColor: Colors.amber,
                      labelText: "company",
                      labelStyle: Theme.of(context).textTheme.headline3,
                      hintText: "customer company",
                      hintStyle: Theme.of(context).textTheme.headline3,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
                      
                      
                    ),
                  ),
                ],)),
              ),
              Container(                
                decoration: BoxDecoration(color: Colors.amber,
                  borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: TextButton(
                onPressed: (){
                  showBottom(context);
                  
                },
                 child:Text("Edit Image For Customer",style:Theme.of(context).textTheme.headline1,)),
              ),
              SizedBox(height: 20,),
               Container(
                decoration: BoxDecoration(color: Colors.amber,
                  borderRadius: BorderRadius.circular(50)),
                margin: EdgeInsets.symmetric(horizontal: 20),
                 child: TextButton(onPressed: ()async{
                  await editCustomer(context);
                 },
                  child:Text("Edit Customer",style: Theme.of(context).textTheme.headline4,)),
               ),
        
            ],
          ),
        ),
    );
  }
  
 void showBottom(BuildContext context){

     showModalBottomSheet(context: context,
               builder:((context) {
                 return Container(
                  color: Colors.cyan,
                   child: Container(                  
                    margin: EdgeInsets.all(20),
                      height: 200,
                     // width: MediaQuery.of(context).size.width-200,
                     child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [                    
                      Text("Please Choose Image",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                      InkWell(
                        onTap: ()async{
                         await uploadImageFromGallery(context);
                      // AwesomeDialog(context: context,dialogType: DialogType.warning,
                       //  body: Text(" !???????? ?????? ???? ?????????? ??????????"))..show();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.browse_gallery,size: 30,),
                            SizedBox(width: 20,),
                            Container(                          
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("From Gallery",style: TextStyle(fontSize: 20),)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: ()async{
                        await uploadImageFromCamera(context);
                       // AwesomeDialog(context: context,dialogType: DialogType.warning,
                       //  body: Text(" !???????? ?????? ???? ?????????? ??????????"))..show();
                        },
                        child: Row(
                          children: [
                            Icon(Icons.camera,size: 30,),
                            SizedBox(width: 20,),
                            Container(
                               padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("From Camera",style: TextStyle(fontSize: 20))),
                          ],
                        ),
                      ),
                 
                     ],),
                   ),
                 );
               }));



  }
  User getCurrentUser(){

 return FirebaseAuth.instance.currentUser!;

}

uploadImageFromGallery(context)async{
   
  XFile? imagechosen = await ImagePicker().pickImage(source: ImageSource.gallery);
 // getCurrentUser().
  if(imagechosen != null){

    image = File(imagechosen.path);
    String imagename = basename(imagechosen.path);
    int num  = Random().nextInt(100000);
    imagename = "$imagename$num";
    final storageRef = FirebaseStorage.instance.ref();
    imageref =  storageRef.child("images").child(imagename);
                   
  }
   Navigator.of(context).pop();

  
  }
  uploadImageFromCamera(context)async{
   
   
  XFile? imagepicked = await ImagePicker().pickImage(source: ImageSource.camera);

  if(imagepicked != null){

    image = File(imagepicked.path);
    String imagename = basename(imagepicked.path);
    int num  = Random().nextInt(100000);
    imagename = "$imagename$num";
    final storageRef = FirebaseStorage.instance.ref();
    imageref =  storageRef.child("images").child(imagename);

  }
  Navigator.of(context).pop();

  }



}






 
import 'package:flutter/material.dart';

showLoading(BuildContext context){
      return  showDialog(context: context, builder: (context) {
        
        return AlertDialog(title: Text("Loading......"),
        content:Container( height: 30,
          child: Center(child: CircularProgressIndicator())) ,);
      },);
   }
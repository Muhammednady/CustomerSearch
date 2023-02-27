
import 'package:flutter/material.dart';



class ViewCustomer extends StatefulWidget {
  final Map? customer;
   ViewCustomer({super.key,this.customer});

  @override
  State<ViewCustomer> createState() => _ViewCustomerState();
}

class _ViewCustomerState extends State<ViewCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(" Customer Details"),),
      body: Column(children: [
        Image.asset("images/p4.jpg",width: double.infinity,height: 300,fit:BoxFit.fill),
        Container(margin: EdgeInsets.symmetric(vertical: 20),
        child: Text("${widget.customer!['name']}",style: Theme.of(context).textTheme.headline2,)),
        Text("${widget.customer!['company']}",style:Theme.of(context).textTheme.headline3),
        SizedBox(height: 20,),
        Text("${widget.customer!['phone']}",style:Theme.of(context).textTheme.headline3),

        
      ],),
    );
  }
}
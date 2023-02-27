import 'package:customersearch/crud/addnewcustomer.dart';
import 'package:customersearch/crud/editcustomer.dart';
import 'package:customersearch/crud/viewcustomer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<dynamic, dynamic>>? customers;
  List? images;
  QueryDocumentSnapshot? userSnapShot;
  int? indicator;
  CollectionReference docref =
      FirebaseFirestore.instance.collection("customers");

  User getCurrentUser() {
    return FirebaseAuth.instance.currentUser!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getUserDataContent();
  }

  @override
  Widget build(BuildContext context) {
    double mdw = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("addcustomer");
            },
            child: Icon(
              Icons.add,
              color: Colors.cyan,
            ),
          ),
          appBar: AppBar(
            shadowColor: Colors.cyan,
            title: Center(
                child: Text(
              "Home Page",
              style: TextStyle(fontSize: 30),
            )),
            actions: [
              IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushReplacementNamed("login"); //so important....
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    size: 30,
                    color: Colors.amber,
                  ))
            ],
          ),
          body: FutureBuilder(
            future: docref.get(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Loading.....",
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      CircularProgressIndicator(
                        color: Colors.amber,
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                String customerid;
                Map customerdata;
                return Container(
                  color: Colors.cyan,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: ((context, index) {
                        customerid = snapshot.data!.docs[index].id;
                        customerdata = snapshot.data!.docs[index].data() as Map;
                        return Dismissible(
                            onDismissed: (DismissDirection direction) async {
                              // snapshot.data!.docs[index].reference.delete();
                              await FirebaseFirestore.instance
                                  .collection("customers")
                                  .doc(customerid)
                                  .delete();
                              // await FirebaseStorage.instance.refFromURL(customerdata['imageUrl']).delete();
                            },
                            key: UniqueKey(),
                            child: ListCustomers(
                              customer:
                                  snapshot.data!.docs[index].data() as Map,
                              customerid: customerid,
                            ));
                      })),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("ËRROR"));
              } else
                return Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text("you haven't added notes yet !"),
                );
            },
          )),
    );
  }
}

class ListCustomers extends StatelessWidget {
  final Map? customer;
  String? customerid;
  //final double? mdw;
  ListCustomers({this.customer, this.customerid});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return ViewCustomer(
              customer: customer,
            );
          },
        ));
      },
      child: Card(
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Image.asset(
                  "images/p4.jpg",
                  fit: BoxFit.fill,
                  height: 80,
                )),Expanded(
                  flex: 3,
                  child:Column(mainAxisSize: MainAxisSize.min,
                    children: [
                    Text(" ${customer!['name']}",style: Theme.of(context).textTheme.headline3,),
                    Text(" ${customer!['company']}",style: Theme.of(context).textTheme.headline3,),
                    Text(" ${customer!['phone']}",style: Theme.of(context).textTheme.headline3,),

                  ],) ),
                Expanded(
                  flex: 1,
                  child:  Center(
                    child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => EditCustomer(
                                customerid: customerid,
                                name: customer!['name'],
                                phone: customer!['phone'],
                                company: customer!['company']),
                          ));
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.amber,
                        )),
                  ),),
            
          ],
        ),
      ),
    );
  }
}
/*
(notes == null)? (indicator == null?Center(child: CircularProgressIndicator())
        :Column(children: [SizedBox(height: 20,),Center(child: Text("You haven't added notes yet !"),)],))
        :
        */
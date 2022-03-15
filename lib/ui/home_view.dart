

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewalet/net/api_methods.dart';
import 'package:ewalet/ui/add_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({ Key? key }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  double bitcoin = 0.0;
  double ethereum = 0.0;
  double tether = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValues();
  }

   getValues() async{
     bitcoin = (await getPrice("bitcoin"))!;
     ethereum = (await getPrice(("ethereum")))!;
     tether = (await getPrice("tether"))!;
     setState(() {
       
     });
   }





  @override
  Widget build(BuildContext context) {


      getValue(String id , double amount ){

    if ( id == "bitcoin") {
      return bitcoin * amount;
    }else if (id == "ethereum"){
      return ethereum * amount ;
    }else {
      return tether* amount;
    }
  }  



    return Scaffold(
      body: Container(
        
        // ignore: prefer_const_constructors
        decoration: BoxDecoration( 
          color: Colors.white,
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child : Center(
        child:  StreamBuilder (  stream: FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('Coins')
                                  .snapshots(),
                                  builder: ( BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot){
                                    if(!snapshot.hasData){
                                      return Center(child: CircularProgressIndicator(),);
                                    }

                                    return ListView( children: snapshot.data!.docs.map((document){
                                    return Padding( padding: EdgeInsets.only( top:  5.0, left:  15.0, right:  15.0 ) , 
                                    
                                    child : Container(
                                      
                                      width: MediaQuery.of(context).size.width /1.3,
                                      height: MediaQuery.of(context).size.height /12,
                                      decoration:  BoxDecoration( borderRadius: BorderRadius.circular(15.0), 
                                      color: Colors.blue,
                                      ),
                                      
                                      
                                      child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Coin :${document.id} ", style: TextStyle( color : Colors.white)),
                                        Text("Amount : \$${ getValue ( document.id , document.get('Amount')) }" , style: TextStyle( color : Colors.white) ),
                                       
                                      ],
                                    ),));
                                    }).toList(),
                                    );

                                  }
                                   ),
                                
        ),
        ),

         floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddView(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      );
      
    
  }
}
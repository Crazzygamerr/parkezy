import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Parking extends StatefulWidget {
  const Parking({Key? key}) : super(key: key);

  @override
  State<Parking> createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  
  String name = "";
  TextEditingController regCon = TextEditingController(), modelCon = TextEditingController();
  Stream<QuerySnapshot>? stream;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        name = (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>)['parking'] ?? "";
        stream = FirebaseFirestore.instance.collection('lots').doc(name).collection('spots').snapshots();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20,),
            // StreamBuilder<QuerySnapshot>(
            //   stream: stream,
            //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //     if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            //       // return a progress bar showing half full
                  
            //     } else {
            //       return const CircularProgressIndicator();
            //     }
            //   },
            // ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Spots",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: (){}, 
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ]
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "History",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: (){}, 
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ]
                ),
              ),
            ),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add Vehicle Details",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      controller: regCon,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Registration",
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter registration number';
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: modelCon,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Model",
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async{
                          if(regCon.text.isNotEmpty && modelCon.text.isNotEmpty) {
                            await FirebaseFirestore.instance.collection('lots').doc(name).collection('spots').add({
                              'reg': regCon.text,
                              'model': modelCon.text,
                              'time': DateTime.now().toString(),
                            });
                            regCon.clear();
                            modelCon.clear();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please enter all details"),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purpleAccent,
                        ),
                        child: const Text("Book"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
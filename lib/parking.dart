import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Parking extends StatefulWidget {
  const Parking({Key? key}) : super(key: key);

  @override
  State<Parking> createState() => _ParkingState();
}

class _ParkingState extends State<Parking> {
  
  String name = "";
  int capacity = 0;
  TextEditingController regCon = TextEditingController(), modelCon = TextEditingController();
  Stream<QuerySnapshot>? stream;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        name = args['parking'] ?? "";
        capacity = args['capacity'] ?? 0;
        stream = FirebaseFirestore.instance.collection('lots').doc(name).collection('spots').snapshots();
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(10),
        color: const Color(0xffEBEFF2),
        alignment: Alignment.center,
        child: SizedBox(
          height: double.infinity,
          width: MediaQuery.of(context).size.width > 500 ? 500 : MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                StreamBuilder<QuerySnapshot>(
                  stream: stream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    } else {
                      return Card(
                        child: ListTile(
                          title: const Text(
                            "Capacity:",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          trailing: Text(
                            "${snapshot.data!.docs.length}/$capacity",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          subtitle: LinearProgressIndicator(
                            value: snapshot.data!.docs.length / capacity,
                            color: Colors.purple[400],
                            backgroundColor: Colors.grey[300],
                          ),
                        ),
                      );
                    }
                  },
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/spots', arguments: {
                      "parking": name,
                      "history": false,
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Spots",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ]
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/spots', arguments: {
                      "parking": name,
                      "history": true,
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 50,
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "History",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ]
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Add Vehicle",
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
                        StreamBuilder<QuerySnapshot>(
                          stream: stream,
                          builder: (context, snapshot) {
                            return Container(
                              width: double.infinity,
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if(regCon.text.isNotEmpty 
                                    && modelCon.text.isNotEmpty
                                    && snapshot.hasData
                                    && snapshot.data!.docs.length < capacity
                                  ) {
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
                                  primary: Colors.purple[400],
                                ),
                                child: const Text("Book"),
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
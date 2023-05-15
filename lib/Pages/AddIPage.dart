import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Models/GItem.dart';
import 'package:flutter_application_1/Pages/home.dart';
import 'package:uuid/uuid.dart';

class AddIPage extends StatefulWidget {
  const AddIPage({super.key, required this.i});

  final String i;
  @override
  State<AddIPage> createState() => _AddIPage();
}

class _AddIPage extends State<AddIPage> {
  final nameController = TextEditingController();
  final imageController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    imageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.i),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(labelText: 'Item'),
                onChanged: (val) {},

                controller: nameController,

                onSaved: (value) {},
                // textInputAction: TextInputAction.done,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(labelText: 'image URL'),
                onChanged: (val) {},

                controller: imageController,

                onSaved: (value) {},
                // textInputAction: TextInputAction.done,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    border: Border.all(color: const Color.fromARGB(190, 200, 200, 200)),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: InkWell(
                    onTap: () {
                      //Appdata.glist.add(GItem(id: 'id', name: nameController.text, imageUrl: imageController.text));
                      var uuid = Uuid();
                      final Nitem = GItem(id: uuid.v4(), name: nameController.text, imageUrl: imageController.text);
                      final GItemCollection = FirebaseFirestore.instance.collection('GItem');
                      final GItemDoc = GItemCollection.doc(Nitem.id);
                      GItemDoc.set(Nitem.toMap());
                      setState(() {});
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                    title: 'Grocery',
                                  )),
                          (Route<dynamic> route) => false);
                    },
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

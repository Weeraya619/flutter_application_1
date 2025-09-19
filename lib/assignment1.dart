import 'package:flutter/material.dart';

class MyWidget2 extends StatelessWidget {
  const MyWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> listProduct = ['Apple','Samsung', 'Oppo', 'Nothing'];
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView'),
      ),
      backgroundColor: const Color.fromARGB(255, 74,74, 74),
      body: ListView.separated(
        itemCount: listProduct.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('$index'),
            title: Text(listProduct[index]),
            subtitle: Text('loading...'),
            trailing: Icon(Icons.edit),
            iconColor: Colors.white,
            textColor: Colors.white,
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 2,
            width: double.infinity,
            color: Colors.white,
          );
        }
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Week3 extends StatelessWidget {
  const Week3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              height: 400,
              width: 280,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 145, 139, 125),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            Positioned(
              top: 15,
              child: Container(
                height: 200,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/pic3.JPG'),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),
            Positioned(
              bottom: 130,
              child: Text('Weeraya Siasakun',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              )
            ),
            Positioned(
              bottom: 110,
              child: Text('660710619',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ),
            Positioned(
              bottom: 90,
              child: Text('Computer Science',
                style: TextStyle(
                  color: const Color.fromARGB(255, 214, 210, 197),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ),
            Positioned(
              bottom: 70,
              child: Text('A fox person',
                style: TextStyle(
                  color: const Color.fromARGB(255, 214, 210, 197),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ),
            Positioned(
              bottom: 50,
              child: Text('sleep like fox and play like them',
                style: TextStyle(
                  color: const Color.fromARGB(255, 214, 210, 197),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

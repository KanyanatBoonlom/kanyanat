import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlinedb_kanyanat/showproducttype.dart';
import 'addproduct.dart';
import 'showproductgrid.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAQQZA5qFiRLpwPmfi9SNf_6T9Mudm5DMY",
            authDomain: "onlinefirebase-bd07e.firebaseapp.com",
            databaseURL:
                "https://onlinefirebase-bd07e-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-bd07e",
            storageBucket: "onlinefirebase-bd07e.firebasestorage.app",
            messagingSenderId: "15783088973",
            appId: "1:15783088973:web:40fb1f14ef30aafac6dd04",
            measurementId: "G-E34PLX1NM9"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(221, 236, 129, 200)),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูหลัก'),
      ),
      body: Stack(
        children: [
          // เพิ่มภาพพื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bgg.JPG"), // พาธของภาพที่อยู่ในโฟลเดอร์ assets
                fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,  // จัดให้อยู่ตรงกลาง
              crossAxisAlignment: CrossAxisAlignment.center,  // จัดให้ปุ่มอยู่กลาง
              children: [
                // เพิ่มโลโก้ที่ด้านบน
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0), // ระยะห่างจากโลโก้ไปยังปุ่ม
                  child: Image.asset(
                    'assets/chobbkun.png', // โลโก้ที่ต้องการแสดง
                    width: 350, // ขนาดความกว้างของโลโก้
                    height: 200, // ขนาดความสูงของโลโก้
                  ),
                ),
                // ปุ่มบันทึกสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0), // ระยะห่างระหว่างปุ่ม
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addproduct()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(221, 236, 129, 200), // สีพื้นหลัง
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15), // ขนาดปุ่ม
                    ),
                    child: Text(
                      'บันทึกสินค้า',
                      style: TextStyle(
                        color: Color.fromARGB(221, 255, 255, 255), // ฟอนต์สีขาว
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // ปุ่มแสดงข้อมูลสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => showproductgrid()), // เปิดหน้าจอ ShowProductGrid
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(221, 236, 129, 200),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'แสดงข้อมูลสินค้า',
                      style: TextStyle(
                        color: Color.fromARGB(221, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // ปุ่มแสดงประเภทสินค้า
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => showproducttype()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(221, 236, 129, 200),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: Text(
                      'ประเภทสินค้า',
                      style: TextStyle(
                        color: Color.fromARGB(221, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


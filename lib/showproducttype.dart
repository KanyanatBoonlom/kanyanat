import 'package:flutter/material.dart';
import 'showfiltertype.dart'; // Import หน้าแสดงรายการสินค้า

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(221, 236, 129, 200)),
        useMaterial3: true,
      ),
      home: showproducttype(), // เรียกหน้าแสดงประเภทสินค้า
    );
  }
}

class showproducttype extends StatefulWidget {
  @override
  _showproducttypeState createState() => _showproducttypeState();
}

class _showproducttypeState extends State<showproducttype> {
  // รายการประเภทสินค้า
  List<Map<String, dynamic>> categories = [
    {'name': 'Electronics', 'icon': Icons.computer},
    {'name': 'Clothing', 'icon': Icons.storefront},
    {'name': 'Food', 'icon': Icons.restaurant},
    {'name': 'Books', 'icon': Icons.library_books},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประเภทสินค้า', // ชื่อของแอป
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor:Color.fromARGB(221, 236, 129, 200), // สีของแถบ AppBar
      ),
      body: Stack(
        children: [
          // ภาพพื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bgg.jpg"), // ภาพพื้นหลังจากไฟล์
                fit: BoxFit.cover, // ปรับขนาดภาพให้ครอบคลุมหน้าจอ
              ),
            ),
          ),
          // การแสดงผลรายการประเภทสินค้าในกริด
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // กำหนดจำนวนคอลัมน์ในกริด
                crossAxisSpacing: 20, // เว้นระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 20, // เว้นระยะห่างระหว่างแถว
              ),
              itemCount: categories.length, // จำนวนประเภทสินค้า
              itemBuilder: (context, index) {
                final category =
                    categories[index]; // การเข้าถึงประเภทสินค้าแต่ละตัว
                return GestureDetector(
                  onTap: () {
                    // เมื่อกดที่ประเภทสินค้า, แอปจะนำผู้ใช้ไปยังหน้าจอแสดงสินค้าของประเภทนั้น
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => showfiltertypect(
                          selectedCategory: category[
                              'name'], // ส่งประเภทที่เลือกไปยังหน้าใหม่
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5, // ความสูงของการ์ด
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // ขอบมนของการ์ด
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // จัดตำแหน่งไอคอนและข้อความ
                        children: [
                          Icon(
                            category['icon'], // ไอคอนที่แสดงตามประเภทสินค้า
                            size: 65,
                            color: Colors.pink,
                          ),
                          SizedBox(
                              height: 10), // ระยะห่างระหว่างไอคอนและข้อความ
                          Text(
                            category['name'], // ชื่อประเภทสินค้า
                            style: TextStyle(
                              color: Colors.black, // สีของข้อความ
                              fontSize: 18,
                              fontWeight: FontWeight.w600, // รูปแบบตัวอักษร
                            ),
                            textAlign:
                                TextAlign.center, // จัดตำแหน่งข้อความให้ตรงกลาง
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//Method หลักที่Run
void main() {
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
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
      home: showproduct(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showproduct extends StatefulWidget {
  @override
  State<showproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproduct> {
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final query = dbRef.orderByChild('price').startAt(500);
      final snapshot = await query.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] = child.key;
          loadedProducts.add(product);
        });
        loadedProducts.sort((a, b) => a['price'].compareTo(b['price']));
        setState(() {
          products = loadedProducts;
        });
        print("จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ");
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  void deleteProduct(String key, BuildContext context) {
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('ไม่ลบ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                deleteProduct(key, context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('แสดงข้อมูลสินค้า'),
          backgroundColor: Color.fromARGB(221, 236, 129, 200)),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/bgg.JPG"), // พาธของภาพที่อยู่ในโฟลเดอร์ assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(product['name']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('รายละเอียดสินค้า: ${product['description']}'),
                            Text(
                                'วันที่ผลิต: ${formatDate(product['productionDate'])}'),
                            Text('ราคา : ${product['price']} บาท'),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 80,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red[50], // พื้นหลังสีแดงอ่อน
                              shape: BoxShape.circle, // รูปทรงวงกลม
                            ),
                            child: IconButton(
                              onPressed: () {
                                // เรียกใช้ฟังก์ชัน showDeleteConfirmationDialog โดยส่ง key ของสินค้า
                                showDeleteConfirmationDialog(
                                    product['key'], context);
                              },
                              icon: Icon(Icons.delete),
                              color: Colors.red, // สีของไอคอน
                              iconSize: 30,
                              tooltip: 'ลบสินค้า',
                            ),
                          ),
                        ),
                        onTap: () {
                          // เมื่อกดที่แต่ละรายการสามารถใส่ฟังก์ชันเพิ่มเติมได้
                        },
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
} 
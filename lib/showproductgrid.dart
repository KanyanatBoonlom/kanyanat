import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Method หลักที่ Run
void main() {
  runApp(MyApp());
}

// Class stateless สั่งแสดงผลหน้าจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(221, 236, 129, 200)),
        useMaterial3: true,
      ),
      home: showproductgrid(),
    );
  }
}

// Class stateful เรียกใช้การทำงานแบบโต้ตอบ
class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
  // สร้าง reference ไปยัง Firebase Realtime Database
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        snapshot.children.forEach((child) {
          Map<String, dynamic> product = Map<String, dynamic>.from(child.value as Map);
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
      fetchProducts();
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
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // ฟังก์ชันสำหรับแสดง DatePicker
  Future<void> selectDate(BuildContext context, TextEditingController dateController) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null) {
      // อัพเดตค่าที่เลือกไปที่ TextField
      dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
    }
  }

  void showEditProductDialog(Map<String, dynamic> product) {
    TextEditingController nameController = TextEditingController(text: product['name']);
    TextEditingController descriptionController = TextEditingController(text: product['description']);
    TextEditingController priceController = TextEditingController(text: product['price'].toString());
    TextEditingController categoryController = TextEditingController(text: product['category']);
    TextEditingController quantityController = TextEditingController(text: product['quantity'].toString());
    TextEditingController manufacturedDateController = TextEditingController(text: product['manufactured_date']);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                // ฟิลด์เลือกวันที่ผลิต
                TextField(
                  controller: manufacturedDateController,
                  decoration: InputDecoration(labelText: 'วันที่ผลิต (dd/MM/yyyy)'),
                  readOnly: true, // ไม่สามารถแก้ไขโดยตรงได้
                  onTap: () {
                    // เปิด Date Picker เมื่อคลิก
                    selectDate(context, manufacturedDateController);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'category': categoryController.text,
                  'quantity': int.parse(quantityController.text),
                  'manufactured_date': manufacturedDateController.text,
                };
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),

                  );
                });
                Navigator.of(dialogContext).pop();
              },
              child: Text('บันทึก'),
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
        title: Text(
          'แสดงข้อมูลสินค้า',
          style: TextStyle(
            color: Color.fromARGB(221, 255, 255, 255),
            fontSize: 23,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: Color.fromARGB(221, 236, 129, 200),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bgg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          products.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(10.0), // เพิ่มระยะห่างจากขอบ
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                      mainAxisSpacing: 10, // ระยะห่างระหว่างแถว
                      childAspectRatio: 0.8, // ขนาดของการ์ดสินค้า
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0), // เพิ่มระยะห่างภายในการ์ด
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  product['name'],
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'รายละเอียดสินค้า',
                                  style: TextStyle(
                                    color: Color.fromARGB(221, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ' ${product['description']}',
                                  style: TextStyle(
                                    color: Color.fromARGB(221, 0, 0, 0),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'ราคา : ${product['price']} บาท',
                                  style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Spacer(), // เพื่อให้ข้อมูลไม่แน่นเกินไป
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            showEditProductDialog(product);
                                          },
                                          icon: Icon(Icons.edit),
                                          color: Colors.red,
                                          iconSize: 20,
                                          tooltip: 'แก้ไขสินค้า',
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red[50],
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            showDeleteConfirmationDialog(product['key'], context);
                                            setState(() {
                                              products.removeAt(index);
                                            });
                                          },
                                          icon: Icon(Icons.delete),
                                          color: Colors.red,
                                          iconSize: 20,
                                          tooltip: 'ลบสินค้า',
                                        ),
                                      ),
                                    ],
                                  ),
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

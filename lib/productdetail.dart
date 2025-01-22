import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> product; // รับข้อมูลสินค้าที่ส่งมาจากหน้าก่อน

  ProductDetail({required this.product}); // คอนสตรัคเตอร์รับค่าข้อมูลสินค้า

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product['name'],
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w400,
          ),
        ), // แสดงชื่อสินค้าบน AppBar
        backgroundColor: Color.fromARGB(221, 236, 129, 200),
      ),
      body: Stack(
        children: [
          // เพิ่มภาพพื้นหลัง
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/bgg.png"), // พาธของภาพที่อยู่ในโฟลเดอร์ assets
                fit: BoxFit.cover, // ปรับขนาดภาพให้เต็มพื้นที่
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ชื่อสินค้า: ${product['name']}',
                  style: TextStyle(
                    color: Color.fromARGB(221, 236, 129, 200), // กำหนดสีของฟอนต์
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'รายละเอียด: ${product['description']}',
                  style: TextStyle(
                    color: Color.fromARGB(221, 0, 0, 0), // กำหนดสีของฟอนต์
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'จำนวน: ${product['quantity']}',
                  style: TextStyle(
                    color: Color.fromARGB(221, 0, 0, 0), // กำหนดสีของฟอนต์
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'ราคา: ${product['price']} ฿ ',
                  style: TextStyle(
                    color: Color.fromARGB(221, 236, 129, 200), // กำหนดสีของฟอนต์
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
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

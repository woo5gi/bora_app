import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final auth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;


class Shop extends StatefulWidget {
  const Shop({Key? key}) : super(key: key);
  @override
  _ShopState createState() => _ShopState();
}
class _ShopState extends State<Shop> {

  getData() async {
    try {
      var result = await auth.createUserWithEmailAndPassword(
        email: "test@test.com",
        password: "123456",
      );
      result.user?.updateDisplayName('john');
      print(result.user);
    } catch (e) {
      print(e);
    }

    if(auth.currentUser?.uid == null){
      print('로그인 안된 상태군요');
    } else {
      print('로그인 하셨네');
    }

    // 로그아웃
    // await auth.signOut();
    // var a = await firestore.collection('product').add({ 'name' : '바지' });
    // print(a);
    try{
      // await firestore.collection('product').add({'name' : '내복', 'price' : 6000});
    var result = await firestore.collection('product').get();
    if (result.docs.isNotEmpty) {
      print('성공');
      for (var doc in result.docs) {
        print(doc['name']);
      }
    }
    } catch (e){
      print("에러났다고... 정신차리라고");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('샵페이지임!!'),
    );
  }
}




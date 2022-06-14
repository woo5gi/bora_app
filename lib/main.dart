import 'package:bora_app/notification.dart';
import 'package:bora_app/shop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'notification.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (c) => Store1()),
          ChangeNotifierProvider(create: (c) => Store2()),
        ],
          child: MaterialApp(
            theme: style.theme,
            // initialRoute: '/',
            // routes: {
            //   '/': (c) => Text('첫페이지'),
            //   '/detail': (c) => Text('둘째페이지'),
            // },
            home : MyApp(),
          ),
      )
  );
}

var a = TextStyle();
class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var userContent;

  addMyData(){
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      // 리스트 맨압에 자료추가하는 방법
      data.insert(0, myData);
    });
  }

  setUserContent(a){
    setState((){
      userContent = a;
    });
  }


  saveData() async{
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'john');
    var result = storage.getString('name');
    print(result);
  }

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState((){
      data = result2;
    });
  }
  addData(a){
    setState(() {
      data.add(a);
    });
  }
    // if (result.statusCode == 200) {
    //   var result2 = jsonDecode(result.body);
    //   // print( jsonDecode(result.body) );
    //   data = result2;
    // } else {
    //   throw Exception('실패했습니다.');
    // }

  @override
  void initState() {
    super.initState();
    initNotification(context);
    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    MediaQuery.of(context).size.width;  //폭 (LP단위)
    MediaQuery.of(context).size.height;  //높이 (LP단위)
    MediaQuery.of(context).padding.top;  //기기의 상단바 부분 높이 (LP단위)
    MediaQuery.of(context).devicePixelRatio;  //이 기기는 1LP에 픽셀이 몇개 들어있는지

    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('+'),
        onPressed: (){
          showNotification();
        },
      ),
      appBar: AppBar(
        title: Text('BoraApp'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () async {
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              if (image != null){
                setState((){
                  userImage = File(image.path);
                });
              }
              // ignore: use_build_context_synchronously
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => Upload(
                      userImage : userImage,
                      setUserContent : setUserContent,
                      addMyData: addMyData
                  ) )
              );
            },
            iconSize: 30,
          )
        ],
      ),
      body: [Home(data : data, addData : addData),Shop()][tab],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: (i){
          setState((){
            tab = i;
          });
        },
        items: [
          BottomNavigationBarItem(
              label : '홈',
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              label : '샵',
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag)
          )
        ],
      ),
    );

  }
}

// homepage
class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.addData,  }) : super(key: key);
  final data;
  final addData;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      print(scroll.position.userScrollDirection);
      // 맨밑까지 스크롤했는지 체크 가능
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        // print('같음');
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty){
      return ListView.builder(itemCount: widget.data.length, controller: scroll, itemBuilder: (c, i)
      {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.network(widget.data[i]['image']),
            widget.data[i]['image'].runtimeType == String
                ? Image.network(widget.data[i]['image'])
                : Image.file(widget.data[i]['image']),
            GestureDetector(
              child: Text(widget.data[i]['user']),
              onTap: (){
                Navigator.push(context,
                  CupertinoPageRoute(builder: (c) => Profile())
                );
              },
            ),
            Text('좋아요 ${widget.data[i]['likes']}'),
            Text(widget.data[i]['date']),
            Text(widget.data[i]['content']),
          ],
        );
      });
    } else {
      return Text('로딩중');
    }
  }
}

// uploadpage
class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(onPressed: (){ addMyData(); }, icon: Icon(Icons.send))
         ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(userImage),
            Text('이미지업로드화면'),
            TextField(onChanged: (text){
              setUserContent(text);
            },),
            IconButton(
                onPressed: (){
                  //페이지닫기 버튼
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close)
            ),
          ],
        )
    );

  }
}
class Store2 extends ChangeNotifier {
  var name = 'john kim';
}

class Store1 extends ChangeNotifier {
  var profileImage = [];
  var friend = false;
  var follower = 0;

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  addFollower(){
    if (friend == false) {
      follower++;
      friend = true;
    } else {
      follower--;
      friend = false;
    }
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title : Text(context.watch<Store2>().name)
      ),
        body : CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: ProfileHeader()),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (c,i) => Image.network(context.watch<Store1>().profileImage[i]),
                  childCount: context.watch<Store1>().profileImage.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2 ))
          ],
        )
    );
  }
}
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context.watch<Store1>().follower}명'),
        ElevatedButton(onPressed: (){
          context.read<Store1>().addFollower();
        }, child: Text('팔로우')),
        ElevatedButton(
            onPressed: (){
              context.read<Store1>().getData();
            },
            child: Text('사진가져오기')
        )
      ],
    );
  }
}

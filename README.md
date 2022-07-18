# flutter 로 인스타그램 
## 1. **프로젝트설치 & ThemeData로 스타일 분리하려면**

**프로젝트 시작은 main.dart 켜서**

```jsx
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home : MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold();

  }
}
```

**analysis_options.yaml 파일**

```jsx
rules: prefer_typing_uninitialized_variables: false;
prefer_const_constructors_in_immutables: false;
prefer_const_constructors: false;
avoid_print: false;
prefer_const_literals_to_create_immutables: false;
```

**ThemeData() 에서 스타일 관리하기**

```jsx
MaterialApp(
  theme : ThemeData(),
  home : MyApp()
)
// 모든 위젯들 스타일을 한 번에 결정
```

**ThemeData() 에 넣을 수 있는 것들**

**Q. 스타일 중복이 발생하면?**

A. 나랑 물리적으로 가까운 스타일을 먼저 적용하려고 한다.

**Q. 분명 ThemeData() 에 모든 아이콘을 파란색으로 칠해놨는데**

AppBar 안의 actions: [] 아이콘엔 적용이 안되는 것?

A. 복잡한 위젯은 복잡한위젯Theme() 안에서 스타일 줘야 잘 작동

그래서 AppBarTheme() 안에서 아이콘 스타일 주면 됨!

```jsx
ThemeData(
  iconTheme: IconThemeData(color: Colors.red, size: 60),
  appBarTheme: AppBarTheme(
    color: Colors.grey,
  ),
)
```

**Text()의 스타일을 변경하고 싶으면**

```jsx
ThemeData(
  textTheme: TextTheme(
    bodyText2: TextStyle(
        color : Colors.blue,
    ),
  ),
)
```

Text 위젯은 이 중에 bodyText2 스타일을 사용하고

AppBar와 Dialog 위젯은 이 중에 headline6을 사용하고

ListTile 위젯은 이 중에 subtitle1을 사용하고

그래서 글자스타일은 그냥 변수에 저장해놓고 밑에 처럼 사용 변수에 넣어두면 재사용도 편리

```jsx
var text1 = TextStyle(color : Colors.red);
Text('글자', style : text1)
```

## 2. **import 문법과 ThemeData 추가 내용**

**길면 다른 파일로 빼기**

1. lib 폴더 안에 style.dart 이런 파일을 만들어서 거기다가 변수 만들어서 축약할 내용 다 집어넣고

```jsx
(style.dart 파일)
import 'package:flutter/material.dart';

var theme = ThemeData(
  ThemeData안에 들어있던 모든 내용
)
```

1. main.dart로 불러오면 된다.

다른 파일에 있는 변수, 함수, 클래스를 import해올 때는 **import '경로' as 작명**

사용할 땐 **작명.거기있던변수명**

```jsx
(main.dart 파일)
import 'style.dart' as style;

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: style.theme,
      (하단생략)
```

**변수를 다른 파일에서 쓰기 싫으면**

```jsx
var _age = 20;
var _data = "john";

// _ 를 왼쪽에 붙이면 다른 파일에서 import해서 쓸 수 없는 변수가 된다.
```

**ThemeData에서 버튼 디자인 변경하려면**

```jsx
ThemeData(
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      primary: Colors.black,
      backgroundColor: Colors.orange,
    )
  ),
)
```

**하위 ThemeData() 생성하고 싶으면**

특정 박스 안에서부터는 스타일 다르게 하고싶으면 중간에 ThemeData()를 하나 새로 만들어서 넣으면 된다.

```jsx
Container(
  child : Theme(
    data : ThemeData(글자 파랗게 하는 스타일~~),
    child : Container(
      여기부터는 글자 파래짐~~
    )
  )
)
```

**ThemeData() 안의 특정스타일 불러오기**

```jsx
Text('안녕', style: Theme.of(context).textTheme.bodyText1)
```

## 3.**탭으로 페이지 나누는 법**

BottomNavigationBar()

```jsx
// (MyApp의 Scaffold 내부)
bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,
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

// (style.dart 파일 내부)
ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 2,
    selectedItemColor: Colors.black,
  ),
```

**동적인 UI 만드는 법**

**1. 현재 UI의 현재 상태를 저장할 state를 만들어 둔다.**

MyApp이라는 위젯을 state넣을 수 있는 StatefulWidget으로 바꿈

```jsx
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
```

**2. 그 state에 따라서 현재 UI가 어떻게 보일지 코드를 짠다.**

만약에 tab이 0이면 0번째 내용 보여주세요~

만약에 tab이 1이면 1번째 내용 보여주세요~

```jsx
body: [ Text('홈페이지'), Text('샵페이지') ]
,
```

**3. 유저가 state 쉽게 조작할 수 있는 기능도 개발한다.**

```jsx
bottomNavigationBar: BottomNavigationBar(
    showUnselectedLabels: false,
    showSelectedLabels: false,
    currentIndex: pageNum,
		onTap: (i){
		  setState((){
		    pageNum = i;
		  })
		},
    items: [ 생략 ]
)
```

## 4. 앱이 서버와 데이터 주고받는 법

**게시물 레이아웃**

```jsx
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return ListView.builder(itemCount: 3, itemBuilder: (c, i){
        return Column(
          children: [
            Image.network('https://codingapple1.github.io/kona.jpg'),
            Container(
              constraints: BoxConstraints(maxWidth: 600),
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('좋아요 100'),
                  Text('글쓴이'),
                  Text('글내용'),
                ],
              ),
            )
          ],
        );
      });

  }
}

// 1. 자동으로 스크롤되게 ListView.builder()로 만들음
// 2. Container 안에는 constraints: 넣을 수 있는데, 넣으면 최대 폭을 줄 수 있다.
// 3. Image.network() 쓰면 웹에 올려진 이미지가져다쓸 수 있습니다.
```

**서버란?**

**데이터 달라고 하면 데이터 주는 간단한 프로그램**

1. 정확한 URL 주소로 2. GET 요청을 날려야 한다.

**GET 요청날리는 법**

```jsx
// pubspec.yaml

dependencies:
  http: ^0.13.4

// main.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

// android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.INTERNET" />
```

**서버에게 GET요청**

await http.get( Uri.parse('요청할url') )

GET요청을 날려주고 그 자리에 서버에서 가져온 데이터가 남는다.

변수에 저장해서 쓰면 된다.

JSON 코드를 조작하기 쉬운 list, map같은 자료로 변환하려면 json.Decode()사용

```jsx
getData() async {
  var result = await http.get( Uri.parse('https://codingapple1.github.io/app/data.json') );
  print( jsonDecode(result.body) )
}
```

**에러체크**

```jsx
getData() async {
  var result = await http.get(
      Uri.parse('https://codingapple1.github.io/app/data.json')
  );
  if (result.statusCode == 200) {
    print( jsonDecode(result.body) );
  } else {
    throw Exception('실패함ㅅㄱ');
  }
}
```

**페이지 첫 로드시 특정 코드를 실행하고 싶은 경우**

```jsx
// initState() 안에 짠 코드는 위젯이 처음 로드될 때 한 번 자동으로 실행 된다.
@override
void initState() {
  super.initState();
  getData();
}
```

**@override, super ??**

1. 우리가 커스텀 위젯 만들 때 StatefulWidget를 extends로 복사해서 만들어야한다.

복사한 StatefulWidget class를 보통 부모class 라고 부르는데

부모 class 안에 나랑 똑같은 이름을 가진 함수가 있을 경우

@override는 내걸 먼저 적용하라는 뜻입니다.

2. super.어쩌구는 부모 class 안에 있던 initState() 함수를 여기서 실행해달라는 뜻이다.

혹여나 부모 위젯이 있고 다른것도 initState()를 해야하는 경우 그거 먼저 실행하라는 뜻일 뿐입니다.

3. 그냥 전부 플러터가 정상적으로 동작하기 위한 부가적인 문법일 뿐인데 평생 수정할 일이 없으니 그냥 무시하고 지나가도 된다.

**Map 자료형**

List []

Map {}

```jsx
var map = { 'john', 20 };

var map = { 'name' : 'john', 'age' : 20 };
print(map['name']);  //'john' 나옴
```

## 5. **Future 다루기 그리고 FutureBuilder**

**가져온 데이터를 화면에 보여주기**

```jsx
class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState((){
      data = result2;
    })
  }
```

**MyApp() 안에 있던 state를 Home 안에서 쓰고 싶으면**

```jsx
// 1. MyApp 안에있던 Home 에 전송하고
Home(data : data)

// 2. Home 은 등록하고
class Home extends StatelessWidget{
  const Home ({Key? key, this.data})
  final data;
// 3. Home 안에서 쓰기
Text(data[0]['content'])

```

**문제점 : 데이터 도착전에 먼저쓰면 에러**

```jsx
class Home extends StatelessWidget{
  const Home ({Key? key, this.data})
  final data;
  Widget build(BuildContext context){

    if (data.isNotEmpty){
      return ListView.builder(생략);
    } else {
      return Text('로딩중');
    }

  }
}
```

**Dio 패키지**

서버와 GET요청 POST 요청할 일이 많으면 http 패키지 말고 Dio 패키지 설치해서 쓰는게 좋을 수 있다.

**Future가 변하면 실행해주는 FutureBuilder**

1. future: 안에는 Future를 담은 state 이름을 적으면 된다.

http.get() 이런거 직접 적어도 되긴 하지만 state에 저장했다가 쓰는게 좋을 수 있다.

2. builder: (){return 어쩌구} 안의 코드는 입력한 state 데이터가 도착할 때 실행해줍니다.

3. 그리고 snapshot 이라는 파라미터가 변화된 state 데이터를 의미합니다.

그래서 아까와 같은 상황을 좀 더 매끄럽게 해결가능한데 딱 한번 데이터가 도착하고

도착시 위젯을 보여줘야할 경우 FutureBuilder가 유용할 수 있는데 데이터가 추가되는 경우가 잦으면 불편해서 쓸모없습니다.

```jsx
// FutureBuilder() 이걸로 state 사용하는 곳을 싸매면 됨
// FutureBuilder()는 입력한 Future 변수가 실제 데이터로 변할 때 내부 코드 1회 실행해주는 위젯
FutureBuilder (
  future: http.get(어쩌구),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text('post에 데이터 있으면 보여줄 위젯')
    }
    return Text('post에 데이터 없으면 보여줄 위젯')
  },
)
```

## 6.**스크롤 위치 파악하는 법과 더보기 요청**

맨 밑까지 스크롤했는지 계속 감시하다가 맨 밑에 도달하면 데이터 달라고 GET요청

1. 게시물목록 ListView에 ScrollController() 부착하기
2. 스크롤위치 계속 감시해주는 리스너 부착하기
3. 맨 밑까지 스크롤하면 서버에 게시물 더 달라고 GET요청하기
4. 데이터 가져오면 data라는 state에 추가해주기

**글자 중간에 변수 넣으려면**

'문자 ${변수명} 문자’

**스크롤 위치 기록하려면 StatefulWidget이 필요**

StatefulWidget으로 변경

StatefulWidget은 class가 2개

부모가 보낸 state를 등록할 때는 윗 class에 등록

사용은 아랫 class에서 함

아랫 class에서 윗 class에 있는 변수를 사용할 때는 **widget.변수명**

**스크롤바 위치 기록해주는 ScrollController**

```jsx
class _HomeState extends State<Home> {
  var scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
  if (widget.data.isNotEmpty){
    return ListView.builder(itemCount: 3, controller: scroll, (생략)

// 유저가 스크롤할 때 마다 매번 실행해줘야함
// 스크롤할 때 마다 계속 실행해주고 싶으면 addListener
```

**스크롤 할 때 마다 코드 실행해주는 리스너 부착하기**

scroll.position.pixels

유저가 얼마나 위에서 부터 스크롤바를 내렸는지

scroll.position.maxScrollExtent

최대 스크롤 내릴 수 있는 높이

scroll.position.userScrollDirection

스크롤 방향이 위인지 아래인지

```jsx
// import 'package:flutter/rendering.dart';

class _HomeState extends State<Home> {
  var scroll = ScrollController();

// addListener는 보통 initState안에 사용함
  @override
  void initState() {
    super.initState();
    scroll.addListener( () {
      print('스크롤위치 변화함')
    });
  }

  @override
  Widget build(BuildContext context) {
  if (widget.data.isNotEmpty){
    return ListView.builder(itemCount: 3, controller: scroll, (생략)

// 유저가 맨 밑까지 스크롤했는지 안했는지
@override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent){
        print('맨 밑까지 스크롤함')
      }
    });
  }

```

**유저가 맨 밑까지 스크롤바를 내리면 서버에서 게시물을 1개 더 가져와서 하단에 보여주기**

1. 유저가 스크롤바를 내리면 GET요청하기

2. 그리고 가져온 데이터를 data라는 state에 추가

data라는 state쓰는 곳도 알아서 재렌더링

3. 근데 data라는 state는 부모위젯에 있네요 부모 state 수정

```jsx

// 1. getMore() 함수 추가
// getMore() 하면 데이터 가져오는데 맨 밑까지 스크롤하면 실행됨

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent){
        getMore();
      }
    });
  }

// 2. 부모 state 수정
class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];

  addData(a){
    setState(() {
      data.add(a);
    });
  }

// widget.변수명을 붙여야 윗 class에서 등록했던 변수들을 아랫 class에서 사용가능
getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }
```

## 7.**상세페이지 만들기 (Navigator)**

**Flutter에서 페이지 이동 만드는 방법**

페이지 위에 페이지를 덮는 식으로 간단하게 페이지 이동을 구현

**이거 누르면 다른 페이지 띄워주세요**

```jsx
IconButton(
  icon: Icon(Icons.add_box_outlined),
  onPressed: (){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Text('안녕')),
    );
  },
),
```

⇒

```jsx
(context) => Text('안녕')
(context) { return Text('안녕'); }
```

**상세페이지 만들기**

```jsx
class Upload extends StatelessWidget {
  const Upload({Key? key}) : super(key: key);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('이미지업로드화면'),
            IconButton(
                onPressed: (){},
                icon: Icon(Icons.close)
            ),
          ],
        )
    );

  }
}
```

**뒤로가기 버튼**

```jsx
Navigator.pop(context);
```

**Route 만드는 법**

```jsx
MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Text('첫페이지'),
      '/detail': (context) => Text('둘째페이지'),
    },
);
```

**버튼을 눌렀을 때 페이지이동**

```jsx
Navigator.pushNamed(context, "/detail");
```

**Route에 파라미터를 입력하고 싶은 경우**

```jsx
MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        var arguments = settings.arguments;
        if (settings.name == '/detail') {
          return MaterialPageRoute(builder: (context) => Upload(routeparam : arguments) );
        } else if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => Text('홈페이지') );
        } else {
          return null;
        }
      },
);
```

## 8.**폰에 저장된 이미지 가져오려면**

**image_picker 설치와 셋팅**

1. pubspec.yaml 파일

```
dependencies:
  image_picker: ^0.8.4+4
```

2. ios/Runner/Info.plist 파일

```
<key>NSPhotoLibraryUsageDescription</key>
<string>사진첩좀 써도 됩니까</string>
<key>NSCameraUsageDescription</key>
<string>카메라좀 써도 됩니까</string>
<key>NSMicrophoneUsageDescription</key>
<string>마이크 권한좀 제발</string>
```

3. dart파일 맨 위에

```
import 'package:image_picker/image_picker.dart';
import 'dart:io';
```

**image_picker 사용법**

```jsx
onPressed: () async {
  var picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);
}

// 카메라 :  picker.pickImage(source: ImageSource.camera);

// 비디오 :  picker.pickVideo(source: ImageSource.gallery);

// 다중 gallery : picker.pickMultiImage(source: ImageSource.gallery);
```

**선택한 이미지 다루기**

이미지는 용량이 크기 때문에 이미지의 경로만 가져와서 변수에 저장하고 사용

```jsx
onPressed: () async {
  var picker = ImagePicker();
  var image = await picker.pickImage(source: ImageSource.gallery);
   if (image != null) {
    setState((){
      userImage = File(image.path);
    });
  }

}
```

## 9.**선택한 이미지와 글을 게시물로 보여주기**

1. Upload 페이지 상단에 버튼

```jsx
Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar( actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.send))
      ]),
```

2.유저가 입력한 글과 사진을 MyApp 안에 state에 저장

```jsx
class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var userContent;

  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }
(생략)

// (Upload페이지)

TextField(onChanged: (text){ setUserContent(text); })
```

3. 발행버튼 누르면 var data = [] 에 게시물데이터 하나 추가

```jsx
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
      // List 맨 앞부분에 자료를 추가가능
      data.insert(0, myData);
    });
  }

(생략)

Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar( actions: [
        IconButton(onPressed: (){ addMyData(); }, icon: Icon(Icons.send))
      ]),
(생략)
```

4. if문으로 예외처리

```jsx
widget.data[i]['image'].runtimeType == String
   ? Image.network(widget.data[i]['image'])
   : Image.file(widget.data[i]['image']),
```

## 10.**DB없이 데이터 저장하려면 shared preferences**

**shared_preferences 설치**

pubspec.yaml

```jsx
shared_preferences: ^2.0.11
```

```jsx
import "package:shared_preferences/shared_preferences.dart";
import "dart:convert";
```

**shared preferences에 데이터 저장**

```jsx
saveData(){
  var storage = await SharedPreferences.getInstance();
  storage.setString('name', 'john');
}

// setString('자료이름', '저장할자료') 쓰면 저장됨
```

**저장했던 자료 출력하는 법**

```jsx
saveData(){
  var storage = await SharedPreferences.getInstance();
  storage.setString('name', 'john');
  var result = storage.getString('name');
  print(result);
}
// getString('자료이름')
```

**숫자도 저장가능**

```jsx
storage.setString("name", "john");
storage.setBool("name", true);
storage.setInt("name", 20);
storage.setDouble("name", 20.5);
storage.setStringList("name", ["john", "park"]);
```

**자료 삭제**

```jsx
storage.remove("name");
```

**Map 자료 저장**

```jsx
// jsonEncode() 쓰면 Map -> JSON으로 변환
storage.setString("map", jsonEncode({ age: 20 }));

// SON으로 저장하면 자료 꺼내도 JSON
var result = storage.getString("map") ?? "없는데요";
print(jsonDecode(result));
```

## 11. **GestureDetector & 페이지 전환 애니메이션**

**GestureDetector**

위젯감지

onTap: (){ 한 번 누를시 실행할 코드 }

onDoubleTap: (){ 더블탭시 실행할 코드 }

onLongPress: (){ 길게누를시 실행할 코드 }

onScaleStart: (){ 줌인시 실행할 코드 }

onHorizontalDragStart: (){ 수평으로 드래그시 실행할 코드 }

**커스텀 페이지 전환 애니메이션**

```jsx
// 페이드인 혹은 슬라이드 애니메이션

import 'package:flutter/cupertino.dart'

Navigator.push(context,
  PageRouteBuilder(
    pageBuilder: (c, a1, a2) => Upload(),
    transitionsBuilder: (c, a1, a2, child) => FadeTransition(opacity: a1, child: child),
    transitionDuration: Duration(milliseconds : 500),
  ),
)

// pageBuilder: 보여줄 페이지를 return
// transitionsBuilder: 파라미터 4개를 입력하고 애니메이션을 return

// 첫째는 context (쓸데없음)
// 둘째는 0에서 1로 증가하는 애니메이션 숫자 (새로운 페이지에 씀)
// 셋째는 0에서 1로 증가하는 애니메이션 숫자 (기존에 보이던 페이지에 씀)
// 넷째는 현재 보여주는 위젯

// FadeTransition()
// opacity: 애니메이션 숫자
// child: 보여줄 위젯
// 이렇게 작성하면 특정 위젯을 서서히 opacity를 0에서 1로 보여줄 수 있다.
```

**슬라이드 애니메이션**

위젯 위치 변경하려면 PositionedTransition()

위젯 사이즈를 변경하려면 ScaleTransition()

위젯을 가렸다가 보여주려면 SizeTransition()

위젯을 회전시키려면 RotationTransition()

```jsx
SlideTransition(
  position: Tween(
    begin: Offset(-1.0, 0.0),
    end: Offset(0.0, 0.0),
  ).animate(a1),
  child: child,
)
```

## 12. **3-step으로 보내는거 싫으면 Provider 쓰기**

**Provider 패키지 사용**

```jsx
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.1
```

```jsx
import "package:provider/provider.dart";
```

**1. state 보관하는 store 필요**

```jsx
// 모든 위젯들이 공유할 state들은 class 따로 만들어서 보관
class Store1 extends ChangeNotifier {
  var name = 'john kim';
}
```

**2. store 등록 필요**

```jsx
// store를 사용할 위젯들을 전부 ChangeNotifierProvider() 로 감싸면 됨
void main() {
  runApp(
      ChangeNotifierProvider(
          create: (c) => Store1(),
          child: MaterialApp(
              theme: style.theme,
              home: MyApp()
          )
      )
  );
}

// create: 안에는 아까 만들었던 store 넣으면 되고

// child: 안에는 store 적용할 위젯을 넣습니다.
```

**3. store에 있던 state 사용하고 싶으면**

```jsx
// context.watch<store명>()
Text(context.watch<Store1>().name)
```

**state 변경하고 싶으면**

- state 변경하는 함수를 미리 만들어놓고
- 그걸 부르는 식으로 state를 변경함

```jsx
class Counter extends ChangeNotifier {
  var name = 'john kim';
  changeName() {
    name = 'john park';
    notifyListeners();
  }
}
// state변경 다 한 후에 notifyListeners() 를 사용하면
// state 사용중인 위젯이 자동 재렌더링됨

ElevatedButton(
  onPressed: (){
    context.read<Store1>().changeName();
  },
  child: Text('팔로우')
)
// state를 변경하고 싶으면 context.read<store명>().함수명() 이걸 쓰면
```

## 13.**Provider 2 : store 여러개 & GET 요청**

```
class Store1 extends ChangeNotifier {
  var name = 'john kim';
  var follower = 0;
  addFollower(){
    follower++;
    notifyListeners();
  }
}
```

1. follower 라는 state 와 state 변경함수

2. context.watch<Store1>().follower 써서 원하는 곳에 state 보여줌

3. 버튼 누르면 +1 해주고 싶어서 context.read<Store1>().addFollower() 이걸 실행

하지만 한 번 더 누르면 +1 이 아니라 -1이 되어야합니다.

그럼 버튼 누른 횟수를 기록해두고 짝수면 +1 홀수면 -1 이렇게 해도 되고

아니면 유저가 지금 팔로우중인지 (친구인지) 상태를 저장해둬도 됩니다.

store에 그런 용도의 state를 하나 만들어봅시다.

```
class Store1 extends ChangeNotifier {
  var name = 'john kim';
  var friend = false;
  var follower = 0;
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
```

friend : 현재 친구인지 아닌지를 임의로 저장해놓는 state

버튼누르면 현재 친구아니면... +1 해주고 친구상태로 변경하고 현재 친구면... -1 해주고 친구아닌 상태로 변경

**store는 여러개 만들어도 상관없다**

```jsx
class Store1 extends ChangeNotifier {
  var name = 'john kim';
}

class Store2 extends ChangeNotifier {
  var follower = 0;
  follower 변경함수들~~
}
```

**store가 많은 경우 store 등록하는 법**

```jsx
MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => Store1()),
      ChangeNotifierProvider(create: (c) => Store2()),
    ],
    child: MaterialApp( 어쩌구 ),
),

// ChangeNotifierProvider() 를 여러개 사용가능
```

**Provider 쓰면 get요청**

1. Profile의 initState안에서 get요청 날리고 get요청이 완료되면 state수정함수를 작동시키거나
2. Profile의 initState안에서 state수정함수를 작동시켜서 state수정함수 안에서 get요청을 날리거나

state 관련된 모든 로직들은 store 안에 보관하는게 나중에 디버깅도 쉽다

```jsx
class Store1 extends ChangeNotifier {
  var profileImage = [];

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }
}
```

1. profileImage라는 state를 만들었다.

2. get요청해서 그 결과를 profileImage 라는 state에 넣어주는 getData() 함수를 만들기

```jsx
ElevatedButton(
  onPressed: (){
    context.read<Store1>().getData();
  },
  child: Text('사진가져오기')
)
```

3. 버튼 눌렀을 때 getData()를 실행했더니 진짜 서버에서 데이터 가져와서 profileImage에 넣어준다.

## 14. **GridView, CustomScrollView 프로필 페이지 만들기**

레이아웃을 만들고 싶으면 GridView를 쓰면 된다

```jsx
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2 ),
  itemCount: list자료.length,
  itemBuilder: (c, i) {
    return Container(color : Colors.grey);
  }
),
// grid가 몇개 생성될지 미리 알고 있으면 GridView.count 쓰고
// grid가 몇개 생성될지 아직 모르겠으면 GridView.builder 쓰면 됩
// 여러 요소를 합쳐서 전부 스크롤바를 생성하고 싶으면 CustomScrollView() 위젯을 쓰고 그 안에 여러가지 것들을 다 넣으됨
```

**스크롤바 만들어주는 CustomScrollView()**

```jsx
CustomScrollView(
  slivers: [ 위젯1, 위젯2, 위젯3 ]
)
```

**스크롤 영역 안에 ListView 만들고 싶으면 SliverList()**

```jsx
SliverList(
  delegate: SliverChildListDelegate(
    [ Text('리스트'), Text('리스트'), Text('리스트') ]
  )
),
```

**CustomScrollView안에 GridView 만들고 싶으면 SliverGrid()**

```jsx
SliverGrid(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
  delegate: SliverChildListDelegate(
    [ Container(Colors.blue), Container(Colors.green), Container(Colors.yellow) ],
  ),
),
// GridView.builder() 처럼 쓰고 싶으면 delegate: SliverChildBuilderDelegate() 이걸 넣으면 됨
```

**CustomScrollView 안에 박스 넣고 싶으면 SliverToBoxAdapter()**

스크롤 영역 안에 Container 하나 만들고 싶으면

**CustomScrollView 안에 이쁜 헤더 만들고 싶으면 SliverAppBar()**

pinned:true (상단고정옵션)

floating:true (위로 스크롤시 등장여부)

expandedHeight: 300 (높이 설정)

flexibleSpace: FlexibleSpaceBar() (앱바에 넣을 내용)

[https://api.flutter.dev/flutter/material/FlexibleSpaceBar-class.html](https://api.flutter.dev/flutter/material/FlexibleSpaceBar-class.html)

```jsx
// (Profile 페이지)
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
```

## 15. **Local notification 알림 주는 법**

flutter_local_notifications: ^9.1.5

**Android 셋팅**

android/app/src/main/res/drawable 폴더 이미지 등록

**iOS 셋팅**

ios/Runner/AppDelegate.swift

```jsx
if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
```

**알림 띄우려면 일단 먼저 실행할 코드가 있음**

```jsx
//notification.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

//1. 앱로드시 실행할 기본설정
initNotification() async {

  //안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('app_icon');

  //ios에서 앱 로드시 유저에게 권한요청하려면
  var iosSetting = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting
  );
  await notifications.initialize(
    initializationSettings,
    //알림 누를때 함수실행하고 싶으면
    //onSelectNotification: 함수명추가
  );
}
```

```jsx
// main.dart
import 'notification.dart';

@override
void initState() {
    super.initState();
    initNotification(); //추가함
    getData();
}
```

**알림 띄우는 코드**

notifications.show()

```jsx
//2. 이 함수 원하는 곳에서 실행하면 알림 뜸
showNotification() async {

  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      '제목1',
      '내용1',
      NotificationDetails(android: androidDetails, iOS: iosDetails)
    );
}

- 알림 ID는 알림 채널 ID 만드는 곳인데 비슷한 알림들을 모으는 그룹 같은 거라고 생각하면 되고 알아서 아무 글자나 넣으면 됩니다.

- 알림 설명은 알림 채널 설명 적으면 됩니다. 안드로이드에서 알림 길게 누르면 나오는 문자임

- color : 파라미터 수정하면 안드로이드에서 알림 아이콘 색상이 변경됩니다.

- priority, importance를 수정하면 안드로이드에서 알림 소리, 팝업 띄울지 말지를 결정가능합니다.

- iosDetails 부분에 presentSound : false로 바꿔주면 iOS 알림 보여줄 때 소리 켤지말지 선택가능합니다.

- 실제 알림 제목, 내용은 notifications.show() 안에서 수정하면 됩니다. 안에 있는 숫자는 개별 알림마다 넣을 유니크한 번호임
```

```jsx
// main.dart
Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('+'),
        onPressed: (){
          showNotification();
        },
      ),
(생략)
```

## 16. 주기적 알람

notifications.zonedSchedule()

```jsx
// notification.dart 상단

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
```

**특정 시간에 알림 띄우는 법**

```jsx
// notification.dart
showNotification2() async {

  tz.initializeTimeZones();

  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알림 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = const IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  notifications.zonedSchedule(
      2,
      '제목2',
      '내용2',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime
  );
}
```

**주기적으로 알림 띄우는 법**

```jsx
notifications.periodicallyShow(
    3,
    '제목3',
    '내용3',
    RepeatInterval.daily,
    NotificationDetails(android: androidDetails, iOS: iosDetails),
    androidAllowWhileIdle: true
);
// - RepeatInterval.daily 부분을 맘대로 바꾸면 됩니다. weekly, hourly 이런거 있음

// - daily로 설정해놓으면 이 코드가 실행되는 시점 부터 정확히 24시간 후에 알림이 뜹니다.
```

**예정된 알림 취소하는 법**

```jsx
await notifications.cancel(0);
await notifications.cancelAll();
```

**매일 7시 알림**

```jsx
makeDate(hour, min, sec){
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, min, sec);
  if (when.isBefore(now)) {
    return when.add(Duration(days: 1));
  } else {
    return when;
  }
}
// 간단하게 시간을 입력하면 tz.TZDateTime()으로 만들어주는 함수입니다.

// makeDate(8,30,0) 이러면 오늘 8시 30분이라는 날짜로 만들어줍니다.

notifications.zonedSchedule(
      2,
      '제목2',
      '내용2',
      makeDate(8,30,0),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time
);
// - matchDateTimeComponents: DateTimeComponents.time 이런 파라미터가 있으면 같은 시간 매일 알림을 띄워줍니다.

// - .time 대신 .dayOfWeekAndTime 이런 파라미터가 있으면 같은 요일, 시간 매주 알림을 띄워줍니다.

// - .time 대신 .dayOfMonthAndTime 이런 파라미터가 있으면 같은 날짜, 시간 매달 알림을 띄워줍니다.

// - .time 대신 .dateAndTime 이런 파라미터가 있으면 같은 날짜, 시간 매년 알림을 띄워줍니다.
```

## 17. **Firebase**

android 1:501337586149:android:271af1a8b95e3df1c4970c
ios 1:501337586149:ios:76d7f46da341fef8c4970c

```jsx
firebase_core: ^1.10.6
firebase_auth: ^3.3.4
cloud_firestore: ^3.1.5
```

**프로젝트 생성**

[https://console.firebase.google.com/](https://console.firebase.google.com/)

(1) 프로젝트 작명은 이쁘게 맘대로, 애널리틱스는 쓰지맙시다.

![https://codingapple.com/wp-content/uploads/2022/01/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA-2022-01-01-%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE-6.09.53.png](https://codingapple.com/wp-content/uploads/2022/01/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA-2022-01-01-%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE-6.09.53.png)

(2) ▲ 프로젝트 생성이 완료되면 Android, iOS, Web 추가 버튼 각각 눌러서 셋팅하면 됩니다.

Web도 추가하셈 안하면 앞으로 크롬으로 미리보기 못띄움

![https://codingapple.com/wp-content/uploads/2022/01/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA-2022-01-01-%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE-7.09.58.png](https://codingapple.com/wp-content/uploads/2022/01/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA-2022-01-01-%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE-7.09.58.png)

(3) android 앱추가 누르면 일단 앱 id 부터 기입하면 됩니다.

님들 프로젝트의 android/app/build.gradle 파일 오픈하면

중간쯤 applicationId "com.example.instagram" 이런 항목이 있습니다.

거기있는거 위에 기입하면 됩니다.

앱 id는 다른 유저와 중복 허용을 안해줘서

앱 id를 바꾸려면 안드로이드 스튜디오 상단 View - Tool Windows - Terminal 누르고

dart pub global activate rename 입력하고

dart pub global run rename --bundleId com.회사명작명.앱이름

입력하면 됩니다.

**(주의)** 앱이름, 회사명에 \_ 언더바 있으면 안됩니다.

앱 닉네임같은것도 하나 작명해주고 계속 다음다음 누르면 됩니다.

뭐 다운받고 코드 추가하라고 하는게 있으면 개무시하셈

![https://codingapple.com/wp-content/uploads/2022/01/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA-2022-01-01-%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE-7.01.48.png](https://codingapple.com/wp-content/uploads/2022/01/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA-2022-01-01-%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE-7.01.48.png)

(4) iOS 앱추가도 눌러서 똑같이 하면 됩니다. 입력할 앱 id는 대부분 아까랑 똑같습니다.

(5) Web 추가도 대충하십시오

**flutterfire_cli 프로그램을 설치**

안드로이드 스튜디오 상단 View - Tool Windows - Terminal 을 오픈한 뒤에

```
dart pub global activate flutterfire_cli
```

이거 입력

맥은

export PATH="$PATH":"$HOME/.pub-cache/bin"

**환경변수를 등록**

맥은 터미널에서 open ~/.zshrc 아니면 open ~/.bash_profile 입력합니다.

그리고 아까 터미널에 나왔던 export 부터 시작하는 긴 코드를 밑에 복사붙여넣기하고 저장하고 나오면 됩니다.

**터미널**

```jsx
flutterfire configure
```

**셋팅하는 코드**

```jsx
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(어쩌구~~);

}
```

**셋팅**

- android/app/build.gradle 파일 오픈해서

minSdkVersion 어쩌구라고 되어있는 부분을

minSdkVersion 21 이렇게 바꿔줍시다. 안그럼 에러남

- ios/Podfile 파일 오픈해서

맨 위에 platform :ios, '9.0' 이렇게 되어있으면

'10.0' 으로 바꾸면 됩니다.

Firebase가 요구하는 최소 OS 버전이 있어서 바꾸는 것들일 뿐입니다.

- 맥북은 아이폰 미리보기 띄울 때 Cocoapods 어쩌구, deploy target이 8.0이라 안된다는 에러가 뜬다면

ios/Podfile 열어서

```
platform :ios, '10.0'
```

상단에 이런 코드 있나 확인하고

```
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
```

하단코드를 이렇게 수정

그리고 터미널을 열어서

cd ios

pod install (m1 맥북은 이거말고 arch -x86_64 pod update)

입력

## 18. **Firestore 데이터 저장하고 출력**

**Firestore 특징**

- NoSQL 데이터베이

SQL 문법 없이 님들 평소에 쓰던 언어 그대로 써서 자료 입출력 가능

- 폴더를 하나 만들고 그 안에 문서들을 넣는 식으로 자료를 저장합니다.

컴퓨터 폴더 안에 워드 파일 하나 만들고 거기 자료 넣는 거랑 동작방식이 똑같습니다.

폴더는 collection, 문서는 document라고 부릅니다.

- document 안엔 Map 자료형으로 자료를 저장할 수 있으며

document 하나 당 최대 2MB의 문자자료만 저장가능합니다.

{ name : 'kim', age : 20 } 이런거 넣을 수 있는 것임

- 누가 어떤 document를 읽고 쓸 수 있는지 rules 메뉴에서 제한가능합니다.
- collection과 document의 실시간 변동사항 감지하는게 매우 쉽습니다.

**Firestore 공간 만들기**

Firebase console 들어가서 좌측에서 Firestore 누르고 데이터베이스 만들기 누르면 됩니다.

- 뭐 고르라고 하면 프로덕션모드를 선택하고
- 물리적 위치는 asia-northeast3 을 고릅시다.

▲ 컬렉션 시작 눌러서 컬렉션 만들면 됩니다.

컬렉션은 폴더입니다 비슷한 문서들을 안에 보관하면 됩니다.

렉션을 하나 만들고 문서를 넣고 문서 안에 데이터들 맘대로 { } 형식으로 넣으면 됩니다.

**Firestore에 저장된 문서 가져오는 법**

```jsx
import 'package:cloud_firestore/cloud_firestore.dart';
final firestore = FirebaseFirestore.instance;
```

```jsx
var result = await firestore.collection("product").doc("문서id").get();
print(result);
```

**권한 없다고 에러**

```jsx
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**Firestore 컬렉션의 모든 문서 가져오는 법**

```jsx
var result = await firestore.collection('product').get();
for (var doc in result.docs) {
  print('dsf');
}
);
```

**Firestore에 데이터 저장하는 법**

```jsx
await firestore.collection("product").add({ name: "내복", price: 6000 });

//에러
try {
  await firestore.collection("product").add({ name: "내복", price: 6000 });
  print("성공");
} catch (e) {
  print(에러);
}
```

## 19. **Firebase 회원 인증기능**

**Authentication 셋팅**

```jsx
import 'package:firebase_auth/firebase_auth.dart';
final auth = FirebaseAuth.instance;#
```

**회원가입하는 법**

```jsx
try {
  var result = await auth.createUserWithEmailAndPassword(
      email: "kim@test.com",
      password: "123456",
  );
  print(result.user);
} catch (e) {
  print(e);
}
```

**가입시 유저이름추가하는 법**

```jsx
try {
  var result = await auth.createUserWithEmailAndPassword(
      email: "kim@test.com",
      password: "123456",
  );
  result.user?.updateDisplayName('john');
} catch (e) {
  print(e);
}
```

**물음표랑 마침표**

```
result.user.updateDisplayName();
```

그냥 사용하면 result.user에 updateDisplayName이 없을까봐 미리 에러를 내줍니다.

이것도 null check 하라는 소리인데 좀 간편하게 null check 하려면 ?. 쓰면 됩니다.

```
result.user?.updateDisplayName();
```

?. 뜻은 .updateDisplayName() 없으면 null 남기고

있으면 그거 쓰라는 삼항연산자의 축약어일 뿐입니다.

```
result.user!.updateDisplayName();
```

느낌표는 null check 하라는 워닝 개무시하겠다는 뜻입니다.

null이 아닌게 확실할 때 쓰는 문법입니다.

**로그인하는 법**

```jsx
try {
  await auth.signInWithEmailAndPassword(
    email: 'kim@test.com',
    password: '123456'
  );
} catch (e) {
  print(e)
}
```

- 앱을 꺼도 로그인했던 정보가 계속 남아있
- await 부분 변수에 저장해서 출력해보면 유저 정보가 나오는데 그 중 uid 부분이 중요합니다.
- uid는 유저간 중복되지 않는 유니크한 문자열이기 때문에 **유저의 uid로 각각 유저들을 구분하면 됩니다.**

**로그인 된 상태인지 검사하는 법**

```jsx
if (auth.currentUser?.uid == null) {
  print("로그인 안된 상태군요");
} else {
  print("로그인 하셨네");
}
```

**로그아웃하는 법**

```jsx
await auth.signOut();
```

로그인 기능이 있으면

- 인스타그램 글을 발행하면 누가 발행하는 글인지 유저의 uid를 몰래 추가할 수 있음
- 그러면 나중에 내가 발행한 글만 모아볼 수 있고
- 글 수정 삭제할 때도 "현재 유저의 uid가 글에 저장된 uid와 일치하는지" 검사할 수도 있고
- 로그인시 유저가 남자인걸 기록해놓고 나중에 재방문하면 남자용 샵 상품들을 보내줄 수도 있고
- 싫어하는 유저의 uid가 있는 게시물은 안보이게 차단할 수 있고
- 친구가 발행한 게시물만 가져와서 보여줄 수 있고

그래서 사용하는 것입니다.

유저간 구분이 필요없으면 로그인기능 필요없습니다.

## 20. **Firestore 데이터 입출력시 규칙 정하는 법**

**규칙 새로 만드는 법**

```jsx
match 경로 {
  allow read : if 규칙
}

// document 읽을 때 규칙은 read

// document 추가 규칙은 create

// 수정규칙은 update

// 삭제규칙은 delete
```

product라는 컬렉션의 모든 document 읽기접근권한을 정하고 싶으면

```jsx
// {} 이건 모든 문서~ 를 뜻하는 키워드
match /product/{docid} {
  allow read : if 규칙
}
```

**로그인된 유저 검사하는 법**

```jsx
match /product/{docid} {
  allow read : if request.auth != null;
}

```

if문 안에서 request라고 쓰면 현재 Firestore 데이터베이스에 접근요청하는 유저의 정보를 출력해볼 수 있다

**내 게시물만 수정하고 싶으면**

```jsx
match /product/{docid} {
  allow read : if request.auth != null;
  allow update : if 수정요청하는사람uid == 게시물에저장된uid
}

match /product/{docid} {
  allow read : if request.auth != null;
  allow update : if request.auth.uid == resource.data.who;
}
```

**유용한 함수들**

request

method, time, query, resource, auth 등 document 접근원하는 사람에 대한 정보들이 담겨 있다.

resource

지금 접근원하는 document의 정보가 들어있습니다.

resource.data

지금 다루려는 문서의 내용이 출력됨 여기에 여러 함수들을 붙일 수 있습니다.

.size()

길이를 출력해줌

.matches(정규식)

정규식으로 해당문자를 검사해줍니다.

string()

문자로 변환해줍니다.

int()

정수로 변환해줍니다.

데이터 validation이 전부 가능합니다. 자주쓰는건 함수로 만들어놓기도 함.

rules 편집란에서 함수만들어쓰는거 제약없음

**접근 방법**

```
allow get : if 어쩌구
allow list : if 어쩌구
```

get은 딱 하나의 document,

list는 collection 안의 document들을 접근할 때

이렇게 따로도 규칙을 지정가능합니다.

두개 싸잡아서 allow read 라고 표현할 수 있습니다.

```
allow create : if 어쩌구
allow update : if 어쩌구
allow delete : if 어쩌구
```

create

새로운 게시물 추가

update

수정

delete

삭제

allow write 라고 표현

```
match /product/{docid} {
  allow read : if true;
  allow create : if request.auth != null;
  allow update : if request.auth.uid == resource.data.uid;
}
```

**별표두개 입력하면 뺑뺑이 돌려줌**

```jsx
match /{document=**} {
  allow read : if true
}
```

작명할 때 =** 이걸 뒤에 붙여주면 recursive라는 뜻이되어 **하위경로까지 전부 계속 이걸 적용해주라는\*\* 뜻이다.

**(주의) 규칙 중복발생시**

```jsx
match /product/{docid} {
  allow read : if true;
}

match /product/{docid} {
  allow read : if false;
}
```

규칙에서 중복이 발생하면 항상 관대하게 적용함

**규칙 플레이그라운드**

규칙이 잘 만들어져있는지 테스트

rules 문법

https://firebase.google.com/docs/rules/basics

더 다양하게 규칙을 두고 싶으면

Firebase Functions라는 기능과 함께 사용

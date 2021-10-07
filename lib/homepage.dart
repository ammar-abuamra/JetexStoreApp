import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jettaexstores/Module/Info_Api.dart';
import 'package:jettaexstores/Module/mainscreeninfo.dart';
import 'package:jettaexstores/Provider/Localapp.dart';
import 'package:jettaexstores/Screens/Drawer.dart';
import 'package:jettaexstores/Screens/InfoScreen.dart';
import 'package:jettaexstores/Screens/ProdcutDitalScreen.dart';
import 'package:jettaexstores/Screens/CategoryScreen.dart';
import 'package:jettaexstores/alertdilog.dart';
import 'package:jettaexstores/config/Constant.dart';
import 'package:jettaexstores/main.dart';
import 'package:jettaexstores/widget.dart';
import 'Provider/Localapp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource src) async {
    final pickedFile = await picker.pickImage(source: src);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(pickedFile.path);
      } else {
        print('non');
      }
    });
  }

  dynamic userdata;
  Future<List<Infoapi>> _getData() async {
    String url = 'http://45.76.132.167/api/authentication/mainStoreinfo.php?id=';
    var getStore = {
      "storeID": sharedPreferences.getString("storeID")};
    print(getStore);
    var response = await http.post(Uri.parse(url), body: getStore,);
    var jsonData = json.decode(response.body);
    List<Infoapi> info = [];

    for (var itm in jsonData) {
      info.add(Infoapi.fromJson(itm));
    }
    return info;
  } //with shared pref

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
    setdata();
  }

  void setdata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userdata = jsonDecode(sharedPreferences.getString("userdata"));
    });
  }

  Widget buildContainer(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height * .5,
        width: MediaQuery.of(context).size.width * .6,
        decoration: BoxDecoration(
            color: SecondryColor, ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(

              child: Center(
                  child: Text(
                  "Change Photo",
                    style: TextStyle(
                        color: SecondryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
              decoration: BoxDecoration( borderRadius: BorderRadius.circular(5), color: PrimaryColor,),
              padding: EdgeInsets.all(5),
              width: double.infinity,
            ),
            buildListTile(
                context, Icons.image, 'From Gallery', ImageSource.gallery),
            buildListTile(
                context, Icons.camera, 'From Camera', ImageSource.camera),
          ],
        ),
      ),
    );
  }

  var lang = sharedPreferences.getString("lang");

  Widget buildListTile(
      BuildContext context, IconData icon, String fname, ImageSource src) {
    return ListTile(
      onTap: () {

        getImage(src);
        // });
        Navigator.of(context).pop();
      },
      leading: Icon(icon,color: PrimaryColor,),
      title: Text(fname,style: TextStyle(color: PrimaryColor),),
    );
  }

  @override
  Widget build(BuildContext context) {

    final AlertDialog alertq = AlertDialog(backgroundColor: SecondryColor,shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)),
      content: buildContainer(context),
    );

    return Scaffold(
      backgroundColor: SecondryColor,
      drawer: TheDrawer(),
      appBar: AppBar(
        foregroundColor: SecondryColor,
        backgroundColor: PrimaryColor,
        title: Text('JETTEX STORE',style: TextStyle(color: SecondryColor)),

      ),
      body: FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot){

          if (snapshot.data == null) {return Text('eroor');}else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.of(context).padding.bottom) /
                              3.5,

                          child: _image == null ? Image.network('https://images-na.ssl-images-amazon.com/images/I/513CiKyzUWL.jpg', fit: BoxFit.cover,) : Image.file(_image, fit: BoxFit.cover,)),
                      Editbutton(
                        radios: 15,
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return alertq;
                              });
                        },
                      ),

                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom) /
                      6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //للمسافات الي بين اسم المحل و الايقونات والييتختهن
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userdata['name_ar']}',
                                style: TextStyle(
                                    color: Color(0xffedb54f),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    wordSpacing: 4),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star,size: 15,),
                                  Icon(Icons.star,size: 15),
                                  Icon(Icons.star,size: 15),
                                  Icon(Icons.star,size: 15),
                                  Icon(Icons.star,size: 15),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.phone),
                              Text(

                                  '${userdata['phone_number']}',

                                style: TextStyle(color: PrimaryColor),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.add_location_rounded),
                              Text(
                                '${userdata['store_location']}',
                                style: TextStyle(color: PrimaryColor),
                              ),
                              Expanded(
                                  child: SizedBox(
                                    width: 0,
                                  )),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height -
                      appBar.preferredSize.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom) /
                      2.5,
                  child: GridView(
                    children: [
                      ProdcutsBoxs(context, getLang(context, "ProductButton"),
                          'ProscutDitalScreen'),
                      ProdcutsBoxs(
                          context, getLang(context, "OrderButton"), 'OrderScreen'),
                      ProdcutsBoxs(context, getLang(context, "ReviewButton"),
                          'RevewiesScreen'),
                      ProdcutsBoxs(
                          context, getLang(context, "InfoButton"), 'InfoScreen'),
                    ],
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.7,
                    ),
                  ),
                ),
              ],
            );
          }
        },

      ),
    );
  }

  FloatingActionButton cbuildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Color(0xffedb54f),
      onPressed: null,
      child: Icon(
        Icons.home,color: SecondryColor,
      ),
    );
  }
}

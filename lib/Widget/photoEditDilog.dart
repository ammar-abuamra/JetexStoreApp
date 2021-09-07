import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jettaexstores/Provider/Localapp.dart';


class PhotoEditDilog extends StatelessWidget {

//   @override
//   _PhotoEditDilogState createState() => _PhotoEditDilogState();
// }
//
// class _PhotoEditDilogState extends State<PhotoEditDilog> {
  File image;

  final picker = ImagePicker();

  Future getImage(ImageSource src)async{
    final pickedFile = await picker.pickImage(source: src);
    //  setState(() {
    if (pickedFile !=null){
      image = File(pickedFile.path);
      print(pickedFile.path);
    }else{
      print('non');
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height*.6,width:MediaQuery.of(context).size.width*.6,
        decoration: BoxDecoration(
            color: Colors.white,borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(child: Text(getLang(context, "PhotoDilog"),style: TextStyle(color: Colors.white),),backgroundColor: Colors.black,radius: 55,
            ),
            buildListTile(context, Icons.image,getLang(context, "FromGallery"), ImageSource.gallery),
            buildListTile(context, Icons.camera,getLang(context, "FromCamera"),ImageSource.camera),

          ],
        ),
      ),
    );
  }

  Widget buildListTile(BuildContext context,IconData icon , String fname ,ImageSource src ) {
    return ListTile(
      onTap: (){
        //  setState(() {
        getImage(src);
        // });
        Navigator.of(context).pop();
      },
      leading:Icon(icon,color: Color(0xffedb54f),) ,
      title: Text(fname),

    );
  }
}

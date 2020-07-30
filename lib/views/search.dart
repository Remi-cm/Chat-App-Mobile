import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerchat/helpers/constants.dart';
import 'package:customerchat/services/database.dart';
import 'package:customerchat/views/components/formTools.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  DatabaseMethods _databaseMethods = new DatabaseMethods();  
  QuerySnapshot searchSnapshot;
  TextEditingController _searchController = new TextEditingController();
  
  // ChatRoom Creation
createChatroomAndStartConversation(String username) async {

  String chatRoomId = getChatRoomId(username, Constants.localName);

  List<String> users = [username, Constants.localName];
  Map<String, dynamic> chatRoomMap = {
    "users": users,
    "chatroomId": chatRoomId
  };

  Map<String, dynamic> chatRoom = {
    "replierName": username,
    "chatRoomId": chatRoomId
  };

await _databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
Navigator.pushNamed(context, '/conversation', arguments: chatRoom);

}

  Widget searchResults(){
    return searchSnapshot != null ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot.documents.length,
      itemBuilder: (context, index){
        return SearchResult(
          userName: searchSnapshot.documents[index].data["username"],
          userEmail: searchSnapshot.documents[index].data["email"],
          onTap: () async { await createChatroomAndStartConversation(searchSnapshot.documents[index].data["username"]);},
          );
      }) : Container();
  }

  search (){
    _databaseMethods.getUserByUsername(_searchController.text).then((val){
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  @override
  void initState() {
    //search();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hv =MediaQuery.of(context).size.height/100;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffe8ebe8),
        titleSpacing: 0,
        automaticallyImplyLeading: false, 
        title: Row(
          children: <Widget>[
            InkWell(child: Container(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.grey,),
            ),
            onTap: (){Navigator.pop(context);},
            borderRadius: BorderRadius.circular(50),),
            SizedBox(width: 0,),
            Expanded(
              child: Container(
                height: 45,
                padding: EdgeInsets.only(top: 5, bottom: 5, right: 5),

                // TextField
                child: TextField(
                  controller: _searchController,
                  onChanged: (val){search();},
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.0)),
                      borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Search for other users",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.only(bottom: 12, left: 15, right: 15),
                    
                    /*prefixIcon: IconButton(icon :Icon(Icons.arrow_back_ios), enableFeedback: false, 
                    onPressed: (){Navigator.pop(context);},),*/
                    /*suffixIcon: IconButton(icon :Icon(Icons.search), 
                    onPressed: (){
                      search();
                    },),*/
                  ),
                ),
              ),
            ),
            SizedBox(width: 7)
          ],
        ),

      ),
      body: 
      (searchSnapshot != null) ?
      Container(
        child: Column(children: <Widget>[

          searchResults(),
          (searchSnapshot == null) ? noUsers(context) : Container()
        ],),
      ) :
      noUsers(context),
    );
  }
  
Widget noUsers(context){
  final hv =MediaQuery.of(context).size.height/100;
  return Center(
    child: Column(
      children: <Widget>[
        SizedBox(height: hv*30),
        Icon(Icons.search, size: hv*10, color: Color(0xffe8ebe8),),
        Text("Search for Users", style: TextStyle(fontSize: 20, color: Color(0xffe8ebe8), fontWeight: FontWeight.w900),)
    ],),
  );
}

}

class SearchResult extends StatelessWidget {
  final String userName;
  final String userEmail;
  final Function onTap;

  const SearchResult({Key key, this.userName, this.userEmail, this.onTap}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(userName),
      subtitle: Text(userEmail),
      trailing: Icon(Icons.person_pin, size: 30,),
      onTap: () { onTap(); },
    );
  }
}

  getChatRoomId(String a, String b) {
   if(a.length == b.length){ 

    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    }
    else {
      return "$a\_$b";
    }
   }
  else if(a.length < b.length){
    return "$a\_$b";
  }
  else {
    return "$b\_$a";
  }
    
}


/*
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0x0fffffff),
                const Color(0xffa4aba6).withOpacity(0.3),
                const Color(0xffa4aba6).withOpacity(0.0),
              ])
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Type and search a user name",
                filled: true,
                prefixIcon: IconButton(icon :Icon(Icons.arrow_back_ios), enableFeedback: false, 
                onPressed: (){Navigator.pop(context);},),
                suffixIcon: IconButton(icon :Icon(Icons.search), 
                onPressed: (){
                  search();
                },),
              ),
            ),
          ),*/
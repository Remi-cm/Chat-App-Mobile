import 'package:customerchat/helpers/constants.dart';
import 'package:customerchat/services/auth.dart';
import 'package:customerchat/services/database.dart';
import 'package:customerchat/services/localStorage.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomStream;

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream, 
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            String replier;

            dynamic users = snapshot.data.documents[index].data["users"];
            if (users[0] == Constants.localName){
              replier = users[1];
            }
            else{ replier = users[0];}

            Map<String, dynamic> chatRoom = {
              "replierName": replier,
              "chatRoomId": snapshot.data.documents[index].data["chatroomId"]
            };

            return ChatRoomTile(username: replier, chatRoom: chatRoom,);
          }) : Text("No Chats");
      });
  }

  getUserInfo() async {
    Constants.localName = await LocalStorage.getUserName();
  }

  @override
  void initState() {
    getUserInfo();
    databaseMethods.getChatRooms(Constants.localName).then((val){
      setState(() {
        chatRoomStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal : 16.0),
            child: IconButton(icon :Icon(Icons.exit_to_app), 
            onPressed: (){
              authMethods.signOut();
              LocalStorage.clearStorage();
              LocalStorage.saveUserLoggedInState(false);
              Navigator.pushReplacementNamed(context, '/signIn');
            },),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(child: Icon(Icons.search),
      onPressed: (){
        Navigator.pushNamed(context, '/search');
      }),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final Map chatRoom;

  const ChatRoomTile({Key key, this.username, this.chatRoom}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text("${username.substring(0,1).toUpperCase()}", style: TextStyle(color: Colors.white)), 
        backgroundColor: Colors.grey,),
      title: Text(username),
      onTap: (){
        Navigator.pushNamed(context, '/conversation', arguments: chatRoom);
      },
      );
  }
}
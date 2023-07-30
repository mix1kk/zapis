import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/UserSheetsApi.dart';



final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String selectedRadio = 'Женя';
List<String> _users = [];
 String _selectedUser = 'Женя';
var val = 0;
List<bool> isChecked = List.filled(allServiceList.length, false);
List <String> allServiceList =[
  '',
  'Прокол 15 мин',
  'Челка 15 мин',
  'Стрижка 30 мин',
  'Стрижка 1 час',
  'Комплекс 1,5 часа',
  'Окрашивание 2 часа',
  'Брови 1 час',
  'Макияж 1 час',
  'Маникюр 1 час,',
  'Маникюр+гель-лак 1,5 часа',
  'Педикюр 1 час',
  'Педикюр+гель-лак 1,5 часа',
];



class MainScreen extends StatefulWidget {

    MainScreen({Key? key}) : super(key: key);


    static void getPrefs (selectedUser)async{
      SharedPreferences prefs = await _prefs;
      serviceList.clear();
      for ( var i = 0; (i< allServiceList.length);i++ ) {
        isChecked[i] = ( prefs.getBool('$selectedUser $i')==null)?false: prefs.getBool('$selectedUser $i')!;
        selectedRadio = ( prefs.getString('selectedRadio')==null)?'Женя': prefs.getString('selectedRadio')!;
        if (isChecked[i]) serviceList.add(allServiceList[i]);
      }
    }

// static String _selectedUser = 'Женя';
 static   List <String> serviceList = [];
    @override

    static init () async  {
      _users = await UserNumber.getUsersNames();
       SharedPreferences prefs = await _prefs;
       selectedRadio = ( prefs.getString('selectedRadio')==null)?'Женя': prefs.getString('selectedRadio')!;
      UserSheetsApi.currentUser = selectedRadio;
      UserSheetsApi.firstRunColumn =await UserNumber.getUserNumberByName(UserSheetsApi.currentUser );
       await UserNumber.setCurrentUserNumber(await UserNumber.getUserNumberByName(selectedRadio));
        MainScreen.getPrefs;
    }

    State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {

  setSelectedRadio(String value) async{
     SharedPreferences prefs = await _prefs;
    setState(() {
      selectedRadio = value;
      prefs.setString('selectedRadio', selectedRadio);
    });
  }
void setBoolPrefs ()async{
  SharedPreferences prefs = await _prefs;
  for ( var i = 0; (i< allServiceList.length);i++ ) {
    prefs.setBool('$_selectedUser $i',isChecked[i]);
  }
}




  @override

  List<Widget> createCheckboxListService() {
    MainScreen.getPrefs(_selectedUser);
    List<Widget> widgets = [];
    for ( var i = 0; (i< allServiceList.length);i++  ) {
      widgets.add(
        Container(padding: EdgeInsets.all(2.0),
          width: 250.0,
          height: 20.0,
          child:Row(children: [
            Checkbox(value: isChecked[i], onChanged: (bool? value) {
              setState(() {
                isChecked[i] = value!;
                setBoolPrefs();
              });
            },),
            Text(allServiceList[i])
          ],)


          ),
      );
    }
    return widgets;
  }




Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
           title: const Text ('Настройки'),
    centerTitle: true,
    ),
      body:  Column(
          children: [
            Row(children: [

            DropdownButton(
              value: _selectedUser,
              style: const TextStyle(fontSize: 20,color: Colors.black),
            items:
                _users.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,style: const TextStyle(color: Colors.black)),
                );
              }).toList(),
              onChanged: ( value) {
                setState(() {_selectedUser = value.toString();
                createCheckboxListService();
                });
              //  Navigator.pushNamedAndRemoveUntil(context, '/', (route)=> false);
                },
            ),



                 Radio(
                    value: _selectedUser,
                    groupValue: selectedRadio,
                    onChanged: (value) {
                      setSelectedRadio(_selectedUser);
                    setState(() {
                      ;
                    });}),

                    Text('Выбрать данного мастера основным')
              ] ),



                Column(
                  children:
                    createCheckboxListService(),
                ),




            ElevatedButton(onPressed:() {
              Navigator.pushNamedAndRemoveUntil(context, '/todo', (route)=> false);
              }, child: Text('Сохранить и вернуться'))
        ],

      )
    );
  }
}




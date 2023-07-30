import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/UserSheetsApi.dart';
import 'package:call_log/call_log.dart';
import 'package:intl/intl.dart';
import 'package:untitled1/pages/Menu.dart';  //for date format


var cellHeight = 30.0; //высота ячеек во всей таблице
var firstColumnWidth = 50.0;//ширина первого столбца
var secondColumnWidth = 180.0;//ширина второго столбца
 List<bool>isHide = List.filled(16,false);


    var _time = Time.list[UserSheetsApi.firstRunColumn];
    var _name = Name.list[UserSheetsApi.firstRunColumn];
    var _type = Type.list[UserSheetsApi.firstRunColumn];
    var _comment = Comment.list[UserSheetsApi.firstRunColumn];


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  static  _readTable(userNumber) {

    _time = Time.list[userNumber];
    _name = Name.list[userNumber];
    _type = Type.list[userNumber];
    _comment = Comment.list[userNumber];
  }

  @override
  State<Home> createState() => _HomeState();

}



class _HomeState extends State<Home> {


  final TextEditingController _controller = new TextEditingController();



String initialValueText = '';
  String _nameAdd = '';
  String _commentAdd = '';





  @override
  void initState() {
    super.initState();
  }

 _readCalls () async {// Чтение последнего звонившего номера в записной книжке
  var now = DateTime.now();
  Iterable<CallLogEntry> entries = await CallLog.query(dateFrom: now.subtract(Duration(hours: 1,)).millisecondsSinceEpoch);

  (entries.first.name!=null)?
  {initialValueText = ('${entries.first.name}'),}
  :{initialValueText= ('${entries.first.number}'),};

   _nameAdd=initialValueText;
   return _nameAdd;
   }


 void _nextUser () async {//передвижение вправо по пользователям
  await UserNumber.getCurrentUserNumber() >= await UserNumber.getUserMaxCount()-1?
  await UserNumber.setCurrentUserNumber(0) :
  await UserNumber.setCurrentUserNumber((await UserNumber.getCurrentUserNumber())+1);
  Home._readTable(await UserNumber.getCurrentUserNumber());
  UserSheetsApi.currentUser = await UserNumber.getCurrentUserName();//меняет имя пользователя
//  MainScreen. = UserSheetsApi.currentUser;
  MainScreen.getPrefs(UserSheetsApi.currentUser);
  setState(() {});// обновляет экран
}

 void _previousUser () async {// передвижение влево по пользователям
  await UserNumber.getCurrentUserNumber() <= 0?
  await UserNumber.setCurrentUserNumber(await UserNumber.getUserMaxCount()-1) :
  await UserNumber.setCurrentUserNumber((await UserNumber.getCurrentUserNumber())-1);
  Home._readTable(await UserNumber.getCurrentUserNumber());
  UserSheetsApi.currentUser = await UserNumber.getCurrentUserName();//меняет имя пользователя
  MainScreen.getPrefs(UserSheetsApi.currentUser);
    setState(() {}); // обновляет экран
  }





  ButtonStyle listStyleUnmarked = ButtonStyle( //цвет не отмеченной ячейки
     padding: MaterialStateProperty.all(const EdgeInsets.all(1.0)),
      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black));
  ButtonStyle listStyleMarked = ButtonStyle(//цвет отмеченной ячейки
      textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange.shade100),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black));

   selectStyle (index) {//выбор какие ячейки должны быть окрашены
   return
  (_type[index].contains('15 '))|
  (_type[index].contains('30 '))|
  (_type[index].contains('1 '))|
  ((index>1) ? _type[index-1].contains('1 '): false)|
  (_type[index].contains('1,5 '))|
  ((index>1) ? _type[index-1].contains('1,5 '): false)|
  ((index>2) ? _type[index-2].contains('1,5 '): false)|
  (_type[index].contains('2 '))|
  ((index>1) ? _type[index-1].contains('2 '): false)|
  ((index>2) ? _type[index-2].contains('2 '): false)|
  ((index>3) ? _type[index-3].contains('2 '): false)
  ? true : false;
  }

  void _onPressedWriteToTable(ind,nam,typ) async {
    _type[ind] = typ;
    _name[ind]= nam;
    await UserSheetsApi.setData(
        _name[ind], ind+1, 1+ UserSheetsApi.getInitialColumn());//Запись имени
    await UserSheetsApi.setData(
        _type[ind], ind+1, 2 + UserSheetsApi.getInitialColumn());//Запись типа процедуры
    _nameAdd = '';
    selectedService = '';
    Navigator.of(context).pop();//сворачивание всплывающего окна
    setState(() {});


  }
  final ButtonStyle _alertButtonStyle = //размер кнопки в меню выбора процедуры
  ElevatedButton.styleFrom(
      textStyle: TextStyle(fontSize: 10),
      fixedSize: const Size(150.0, 15.0));
  var _alertButtonWidth = 150.0;
  var _alertButtonHeight = 25.0;

  String selectedService = '';


  List<Widget> createRadioListService(index) {
    List<Widget> widgets = [];
    for ( var j = 0; (j< MainScreen.serviceList.length);j++  ) {
      widgets.add(
          Container(padding: EdgeInsets.all(2.0),
                  width: _alertButtonWidth,
                  height: _alertButtonHeight,
                  child:
                  ElevatedButton(style: _alertButtonStyle,
                    onPressed: () {  setState(() {setSelectedService(MainScreen.serviceList[j]);
                         });
                      _onPressedWriteToTable(index, _nameAdd, selectedService);

                    _controller.text = '';
                      initialValueText='';
                    },
                    child:  Text(MainScreen.serviceList[j]),
                  ),),
      );
    }
    return widgets;
  }

  void setSelectedService(currentService){
    selectedService = currentService;

  }

  _alert(index) {//всплывающее окно при нажатии на поле
  _controller.text = _name[index] ;
  return


  AlertDialog(
    scrollable: true,
    title: const Text('Введите данные'),
    content:
    Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

    Container(
      height: 35.0,
    child:
      TextFormField(//текстовое поле ввода имени
        controller: _controller,
        textAlignVertical: TextAlignVertical(y: 1.0),
          decoration: InputDecoration(
            prefixIcon: IconButton(

              onPressed: () async {
              _controller.text = await _readCalls();
              setState(() {});},

              splashRadius: 20.0,
              iconSize: 18.0,
              icon: Icon(Icons.phone_forwarded_rounded),),
          border: OutlineInputBorder(),
          hintText: 'Имя'),
          onChanged: (String value) {
        _nameAdd = value;
        },
      ),
    ),




        Column(
       //   mainAxisSize: MainAxisSize.min ,
    children:  createRadioListService(index),
    ),

      TextButton(
        child: Text("Отмена"),
        onPressed:  () {
          Navigator.of(context).pop();//сворачивание всплывающего окна
          setState(() {});
        },  ),
    ],
  ),);
}

  @override
  Widget build(BuildContext context) {


    return
    //   Dismissible(
    //   key:  UniqueKey(),
    //    direction: DismissDirection.horizontal ,
    //    onDismissed: (direction)async {
    //
    //     (direction == DismissDirection.startToEnd) ?
    //     {await _previousUser,
    //     Navigator.pushNamedAndRemoveUntil(context, '/', (route)=> false)}
    //
    //         : {await _nextUser,
    //      Navigator.pushNamedAndRemoveUntil(context, '/', (route)=> false)};
    //   },
    //
    // child:


    Scaffold(

      appBar: AppBar(
        title: Text(UserSheetsApi.currentUser),
        backgroundColor: BackgroundColor.getcolor(UserSheetsApi.currentUser),
        centerTitle: true,
        actions: [

          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Обновить данные',
            onPressed: () async {
                await Data.getAll();
                Home._readTable((await UserNumber.getCurrentUserNumber()));
                setState(() {

                });
              // Navigator.pushNamedAndRemoveUntil(context, '/todo', (route)=> false);
               }
          ),



           IconButton(
                 icon: const Icon(Icons.chevron_left_sharp),
             tooltip: 'Предыдущий мастер',
              onPressed: _previousUser,
           ),
          IconButton(
            icon: const Icon(Icons.chevron_right_sharp),
            tooltip: 'Следующий мастер',
            onPressed: _nextUser,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Настройки',
            onPressed: () { Navigator.pushNamedAndRemoveUntil(context, '/', (route)=> false);},
          ),


        ],


     //Шапка приложения

      ),


      body: RefreshIndicator(
    onRefresh:() async { await Data.getAll();
        Home._readTable((await UserNumber.getCurrentUserNumber()));
    setState(() {

    });},
    child:
      ListView.builder(//сама таблица
          itemCount: _time.length,
          itemBuilder: (BuildContext context, int index) {


            // Timer.periodic(Duration(seconds: 60), (timer) async {
            //
            //   await Data.getAll();
            //   _readTable((await UserNumber.getCurrentUserNumber()));
            //    print('refresh');
            //   setState(() {
            //
            //   });
            // });



            return


              (index%35==0)?//шапка даты отдельным цветом
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: cellHeight,
                  width: constraints.maxWidth,
                  color: Colors.yellow,
                  child: Center(
                     child:     TextButton.icon(

                         icon: Text(DateFormat.MMMMEEEEd().format(DateTime.fromMillisecondsSinceEpoch((int.parse(_time[index])-25569)*24*3600000)),
                             style: TextStyle(color: Colors.black)),
                         label:(isHide[(index~/35)])?Icon(Icons.arrow_drop_down):Icon(Icons.arrow_drop_up),
                         onPressed: (){
                           isHide[(index~/35)]=!isHide[(index~/35)];
                           setState(() {
                           });
                         },
                       onLongPress: (){
                           isHide[(index~/35)]?isHide=List.filled(isHide.length, false):isHide=List.filled(isHide.length, true);
                           setState(() {
                           });
                       },
                     ),
                  ),

              );
            },
            )

            :(index-1)%35==0?//вторая строчка в шапке с именем отдельным цветом
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  height: (isHide[(index~/35)])?0.0:cellHeight,
                  width: constraints.maxWidth,
                  color: BackgroundColor.getcolor(UserSheetsApi.currentUser),
                  child: Center(
                      child: Text(UserSheetsApi.currentUser)
                  ),
                );
              },
            )

            :(index-2)%35==0? // третья строчка в шапке серым цветом с неизменяемыми полями
            Table(
              columnWidths: {
                0: FixedColumnWidth(firstColumnWidth),
                1: FixedColumnWidth(secondColumnWidth),
              },
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Container(
                    height: (isHide[(index~/35)])?0.0:cellHeight,
                    padding: EdgeInsets.all(0.0),
                    child:
                    TextButton(
                      child : Text(_time[index]),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(const EdgeInsets.all(0.0)),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                      onPressed: (){},
                    ),
                  ),

                  Container(
                      padding: EdgeInsets.all(0.0),
                    height: (isHide[(index~/35)])?0.0:cellHeight,
                    child: TextButton(
                      child: Text(_name[index],style: TextStyle()),
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                      onPressed: () {})
                  ),
                  Container(
                    padding: EdgeInsets.all(0.0),
                    height: (isHide[(index~/35)])?0.0:cellHeight,
                    child:    TextButton(
                      child: Text(_type[index]),
                      style: ButtonStyle(
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 12)),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black)),
                      onPressed: () {},
                    ),
                  ),
                ])
              ],
            )






            :Table(// остальная часть  таблицы
              columnWidths: {
                0: FixedColumnWidth(firstColumnWidth),
                1: FixedColumnWidth(secondColumnWidth),
              },
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                 Container(
                   height: (((selectStyle(index)==false)?(selectStyle(index)|isHide[(index~/35)]):false)?0.0:cellHeight),
                   child:
                  TextButton(
                    child : Text(_time[index],textAlign: TextAlign.left),
                     style: selectStyle(index)?listStyleMarked:listStyleUnmarked,//выбор какие ячейки должны быть окрашены
                    onPressed: (){},
                  ),
                 ),

              Container(
               height: (((selectStyle(index)==false)?(selectStyle(index)|isHide[(index~/35)]):false)?0.0:cellHeight),
               child: TextButton.icon(

                    label: Text(_name[index]),
                    icon: Icon(Icons.add_comment_outlined,size: (_comment[index]=='')?0.0:10.0,color: Colors.black),
                    style: selectStyle(index)?listStyleMarked:listStyleUnmarked,//выбор какие ячейки должны быть окрашены
                      onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {

                             return _alert(index);
                          });
                    },
                     onLongPress: (){
                       _controller.text=_comment[index];
                       showDialog(
                       context: context,
                       builder: (BuildContext context) {
                         return AlertDialog(
                             title: Text('${_comment[index]}'),
                             actions: [
                           TextButton(
                            child: Text("Записать"),
                            onPressed:  () async{
                           _comment[index]= _commentAdd;
                           await UserSheetsApi.setData(_commentAdd, index+1, 4+UserSheetsApi.getInitialColumn());
                           _commentAdd = '';
                           Navigator.of(context).pop();//сворачивание всплывающего окна
                           setState(() {});
                         },),
                         TextButton(
                         child: Text("Отмена"),
                         onPressed:  () {
                           Navigator.of(context).pop();//сворачивание всплывающего окна
                           setState(() {});
                         },  ),
                             ],
                             content: TextFormField(
                               controller: _controller,
                             decoration: const InputDecoration(
                             border: OutlineInputBorder(),
                             hintText: 'Комментарий'),
                               onChanged: (String value) {
                                 _commentAdd = value;
                               },
                         )
                         );
                         },
                       );
                    },
                ),),
               Container(
                height: (((selectStyle(index)==false)?(selectStyle(index)|isHide[(index~/35)]):false)?0.0:cellHeight),
                child:    TextButton(
                    child: Text(_type[index]),
                    style:selectStyle(index)?listStyleMarked:listStyleUnmarked,//выбор какие ячейки должны быть окрашены
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _alert(index);
                          });
                    },
                  ),
            ),
                ])
              ],
            );
          }),
    ),
    // ),
      );

    // );
  }
}


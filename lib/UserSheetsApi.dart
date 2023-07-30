import 'package:gsheets/gsheets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';  //for date format
import 'package:intl/date_symbol_data_local.dart';  //for date locale
import 'package:untitled1/pages/home.dart';

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "cryptic-dahlia-345709",
  "private_key_id": "5743712b1a1495064133e09e49a8f1d89b4b7787",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCsu+AMIlmSKtLB\nW8IARIdzRieuETdAvpniHv/GpyeSoxWwQnnCOf55TLOKmCiJNgxv8iOmMui5EONG\nOeayj/oulGnk2Y0KDc81sTD+rRPtnkMaliyr3FDHsD+fpuryzNnyboNgiK22OIxb\nB2uNkT6w+D/NvpIkb37LZrs1BKqz+U6aUXGgm6z3hMreVrQqF3O1EmLYaYK9fnI/\nDYg5pTvmY0SIzKvk9lUNbon6OrljnmArJf1CdocDVVxomyUuAIK/KaV3Z7D6tmRd\nTJtO/oZ++zpwwZJT9ZI5RQi3JPOBY7FFQaiSs8Duusr9nRoCttV47h1FY7X6XjbS\nwlBRDAEjAgMBAAECggEAGeJs1cn/S9jl9zrFrMjtgU013K77bX+CdjD4ru9VOJ3+\nvd3gUBuPsjlXvauahiFBe4m4ujWZIUPSGFp3OIfnJjwa+EPPj6j3xaSADTyo0Vas\n2Jrre8o1Qrn7IXS1HYhWxVkL5UHmF3nhh9yUoJoaNREmbTGjGxmoJwPbMZE5oWQO\n0kTSzvC+uLYkE/ZBNXc1K5kB/jpfWpGbHydLmQ8TMa8twMS7+td/CRNZCrWvDC9D\nYxqKT42hRb/NQOA6HCnB/Ei/rjpRPWpAsibL3P3+Npcdk2Qiil3uJYCIkvH/tNog\n4Ovj1hVfZpKg8HuF+2JjtQtN3y9Y1cBzJhh5C+E0CQKBgQDzST44WWH6CPGjowzv\ncLKqo/qY2ZQgdV/2JbjPBqfVI3ajiBoNTC/szGHHxNzksAp7M+okb2+RZxo7+R1U\nsu/liM4Gj5ecGfEMkr7tFurXRdJ/Ytew9zpF3PxZNpQzxDBW6Ax8BwWxwmf009RC\ng+DwDWhD6itJu/2cq+dyM6sCWQKBgQC1wsM/gXZL1oOhqDav8Wn3AZz3rjLbsMHu\n4fm1Sv0d5Jj6Is+lun0wKicqcvPkXwaJDFUklfHqMjFTTzQfjJtr6gTRg+k06Ijh\nxDt9pPDgEhtBCM2lrEsXpn35KNW9eIStFiaR2xisgal0/tXyG6Ltquis+1lNMN8d\n45gwVYMX2wKBgQDVaQ2EfpvcqpXVdoU1UQXZfEiqZkpzAqNwF/z61hrJc/dxUkWQ\nHqH3tf2cMMuYa/h1xL+CwKH8yZWQwGEDWIfqMMyRospaq8LwxZVoAu90cZJKHlmY\nqfZbLJPMan0sv8+rnJi+/6X2HdP1RxBuXKMn0IsC8FqSrq61DXLUkhBT2QKBgQCG\nBD72WjyhGmAgF+mKvRQGnlfgf77cIW489r2poMsU+XKaLISyi9i2ZL5QHEYcQryM\n3F0DBtRCfBPGe4XRJVmLrhczbHHNIw+ad5ftwmogrPkPcLBA0dLkc0w7JJLEi1I4\nVTbHIKcGuuv5adTSGPJ/Dx9UPFfSBJDeduvF56crNQKBgQDSwO/gCBNrvBWBxO/C\nTlX340tzt5xCm9xC5fT2ouazOafGNHn3S+Y/YgB3DLdJYT0a8dZoUAls0aSDFsnR\nU3tU1JfEu/PQoj6Mok5eCgTIHie8U2tBfU8GHDD71TJEbkY2MjPCRlnTGTB+Zn+i\n3sPhXWyqjQtz5VU+2I0MdmefuA==\n-----END PRIVATE KEY-----\n",
  "client_email": "zapis-960@cryptic-dahlia-345709.iam.gserviceaccount.com",
  "client_id": "106914824852041465944",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/zapis-960%40cryptic-dahlia-345709.iam.gserviceaccount.com"
}

''';

final _spreadsheetId = '1J3sTag2JIGsswOjV9gyCr6hgYaOjETITViIKz_6BAVY';


// const _credentials = r'''
// {
//   "type": "service_account",
//   "project_id": "zapis-344512",
//   "private_key_id": "86e74957f9e9a152fd3e961b6fd1c8711f5e2f86",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCgois7WvU6J2zl\nP4U73GnrpSnf+eXJ3kX3wJaE/g/b+Ov6Y0r5Do4JJAXF7LK5FXUqnJraiAOYpszq\nRrFPesBVlZ5F1zgdfqpCN6fqB5iPwMfqndf7gf3uHBP/e0M7MhM3VEXLuJuO0GC5\nv4EEAFZsOydmJpLJzgKySVwLf++i/Cj/AqaMfpRk7BkkvbdeaUvfKjx22H7vU0LP\n1pEEDSO9bJV/9MXD4diWmDNsDT4jZd1VLr7mb4G0vCnUh/oeUQngn8gtUqclKSIv\nIZdN0t1X51vMWQszocvmASxJca4J7p0VDmbNeyDAj56IggMsSPsJNAWv5qRT4Y5E\n5TUBpFZnAgMBAAECggEAKlSiDOm63wDdvwn+u9gpZ4pmXxo1Nn3nNVNgtxpWppLR\n6PF6o+h0gK8oAFEQhhrD/h835afbPsKSFJjdiALipYsgouoE5SzohDuzecZXq2ZT\nqJ3A+Yv3lWR71qMug+59xuJj5Dw5bii2nKx9PMcz/yCVkONQYnLyHfacFYG47luW\n+vpp1wNeGehU9vnIgPdNXY6CIfAZCOGwg04fNdH8RzkMD3FUtqT0zAudZ3CvGW1k\na5kwmVP+les17HzMnHRgMlHZ7vKgteGj/oUMEXM0SUr17iXccpMnfcnMYrnzWnOz\n/zWCqZ17ADQ/4FtK6+hCn/raiycUXHAZ4lhxn6BRjQKBgQDYrZre5dtbu1d/XNeY\n3s5MU/V8fTijKN07MhaHluZqg+qBVVTK0WD+63aKogBXuJQq93KPAdwMd3EYQWA2\n15JcF86beEAbml6LBTlbmSG3OqHowK835M67wTzfzAb8T4GBz2QlCtwdw1gfsjyJ\nOAl3zl9q1QYoYEZlFL5px+E2XQKBgQC9yNm0WFjWh8NLgO4nSs0w9zNcdFrsucEj\np2fCKI4a1pModZQvsBB0vShSsHMn2+dVRzAQC6P6vH/gtyRlgop2dG/ItQjTh50y\nbo8hjuOvLMekwpqlMdJjPA6Jeodab+677p/gEzYjMlp4E37Bb1PwLM7rgbM6vr96\n04ww1+qrkwKBgQChdGsMYHad2fEO5F16ebt7QKyRwLUtTsvayi3jhtvWzsk06iKu\npmoCSe4gyyo6Mz2k7pGcYiRX3cCV9FD/TI6wtMStMGOErfh42sGssWRgJf5zcvCd\nU4+AdDMqB9vEsnGsCp9ywq7WNrM5mxRkoy7a6RpMfsOB3otV0qk4JUp5uQKBgBTY\n3kk4NzIBoctGc2KvjdCmJucuBNriILwo5HXofIuoLGwSVl/SqEwahzZmGZA0ULoG\nYtowXSfq0uU9WOsppsoSSkEy2bBawkLK8EAQcSRJ9/g6RECHM4QhEbu6UOn3R7Mv\nKDK2CYleO5/bDF51OzQzx9sI2UZHs8LrQAgRf76vAoGAOy3jcbdXK8KFoalrIm33\nBm4fYAlTZBwBWxh6IGRw1+wMObmCRXUXYqg3mvSW2Uxvpk6mB3pHyUnfld+n5orr\ncu4L5r2lYcg62fMoMAEri3rjGt/JpEyMIFIGETqwLZQmYIj8ZdlDFyjdQeK5nkW4\nz4oHxYdS7QZSvAdcq2hCwMo=\n-----END PRIVATE KEY-----\n",
//   "client_email": "zapis-275@zapis-344512.iam.gserviceaccount.com",
//   "client_id": "117765267949753025944",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/zapis-275%40zapis-344512.iam.gserviceaccount.com"
// }
// ''';
//
//
// final _spreadsheetId = '1Tm8sG6bZDNdLhNdsVir-PJlwqSIveyLLSHcuWXwct8A';

final _gsheets = GSheets(_credentials);
Worksheet? _userSheet;

class UserSheetsApi {
  static int firstRunColumn = 0;
  static String currentUser = ('');
  static int firstColumn=0;
  static List<String>serviceList =[];


  static Future init() async {
    final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
    _userSheet = await _getWorksheet(spreadsheet, title: 'Запись');
    initializeDateFormatting();
    Intl.defaultLocale='ru';
  }



  static Future<Worksheet> _getWorksheet(Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }


 static setData(data,row,column) async{
    await _userSheet!.values.insertValue(data, row: row,column: column);
  }// записывает данные в таблицу

  static getData(row,column) async {
    return await _userSheet!.values.value( row: row, column: column);
  }

  static getDataRow(row) async{
    return (await _userSheet!.values.row(row));
  }// считывает данные из таблицы

  static getDataColumn(fromRow,column) async{
    return (await _userSheet!.values.column(column, fromRow: fromRow));
  }// считывает данные из таблицы


  static setInitialColumn ( number) {
    firstColumn=number;
  }

  static getInitialColumn () {
    return firstColumn;
  }

}
class Name {
  static List<List<String>> list =[];// List.generate(Time.list.length, (i) => List.filled(numberOfUsers,''));

  static void setName(List<List<String>> name) {

    list = name;
     }
}

class Time {
  static List<List<String>> list = [];

  static void setTime(List<List<String>> time) {
    list = time;
  }

}

class Type {
  static List<List<String>> list = [];

  static void setType(List<List<String>> type) {
    list = type;
  }
}
class Comment {
  static List<List<String>> list = [];

  static void setComment(List<List<String>> comment) {
    list = comment;
  }
}

class UserNumber {
  static getUserNumberByName (String Name) async{
    List names = await getUsersNames();
    return (names.contains(Name)?names.indexOf(Name):0);
  }

  static getCurrentUserNumber () async{
   return (await UserSheetsApi.getInitialColumn())~/4;
  }
  static setCurrentUserNumber(int number) async {
    await UserSheetsApi.setInitialColumn(number*4+1);
  }
 static getUserMaxCount () async{
    List num = await UserSheetsApi.getDataRow(1);
    int numberOfUsers = num.length~/4+1;
    return numberOfUsers;
  }
 static getUsersNames () async {
   final List<String> UsersNames = await UserSheetsApi.getDataRow(2);
    List<String>wasd = [];
    var num = UsersNames.length;
    for (int i =0 ; i <num;i++){
      if (UsersNames[i] != '') {
        wasd.add(UsersNames[i]);
      }
     }
    return wasd;
 }


  static getCurrentUserName() async {
    return (await UserSheetsApi.getData(2, UserSheetsApi.getInitialColumn()));
  }
}




class BackgroundColor {
  static getcolor(UserTitle) {
    if (UserTitle == 'Женя') {
      return Colors.purpleAccent;
    }
    else if (UserTitle == 'Диана') {
      return Colors.deepOrange;
    }
    else if (UserTitle == 'Кристина') {
      return Colors.green;
    }
    else {
      return Colors.blue;
    }
  }
}

class Data {

  static getAll() async {
     var _allData = await _userSheet!.values.allColumns(fill: true);
    int numberOfUsers = await UserNumber.getUserMaxCount();
    List <List<String>> TimeAll = List.generate(_allData.length, (index) => List.filled(_allData[0].length,''));
    List <List<String>> NameAll = List.generate(_allData.length, (index) => List.filled(_allData[0].length,''));
    List <List<String>> TypeAll = List.generate(_allData.length, (index) => List.filled(_allData[0].length,''));
    List <List<String>> CommentAll = List.generate(_allData.length, (index) => List.filled(_allData[0].length,''));

      for (int i = 0; i <numberOfUsers; i++) {

        TimeAll[i]=_allData[(i * 4) ];
        NameAll[i]=_allData[(i * 4+1) ];
        TypeAll[i]=_allData[(i * 4+2) ];
        CommentAll[i]=_allData[(i * 4+3) ];

      }

    Time.setTime(TimeAll);
    Name.setName(NameAll);
    Type.setType(TypeAll);
    Comment.setComment(CommentAll);

  }

}
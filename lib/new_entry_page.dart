import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kpmg_employees/custom_dialogue_box.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class Employee_details {
  late int id;
  late String name;
  late String designation;
  late String project;
  late String initiative;
  late String engagement_manager;
  late String start_date;
  late String end_date;

  Employee_details({
    required this.id,
    required this.name,
    required this.designation,
    required this.project,
    required this.initiative,
    required this.engagement_manager,
    required this.start_date,
    required this.end_date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'project': project,
      'initiative': initiative,
      'engagement_manager': engagement_manager,
      'start_date':start_date,
      'end_date':end_date,
    };
  }
  // @override
  // String toString() {
  //   return '\nEmployee Details --- \n\t\t\t id: $id\n\t\t\t name: $name\n\t\t\t designation: $designation\n\t\t\t project: $project\n\t\t\t initiative: $initiative\n\t\t\t engagement_manager: $engagement_manager\n\t\t\t start_date: $start_date\n\t\t\t end_date: $end_date\n';
  // }
}


class NewEntry extends StatelessWidget
{
  const NewEntry ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: _title,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.menu), onPressed: (){},),
          centerTitle: true,
          title: Text("Employee Details"),
          backgroundColor: Color(0xff3249ab),),
        body: const MyHomePage(title: ""),
      ),
    );
  }
}


class MyHomePage extends StatefulWidget
{

  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void delete_from_db(int id) async{
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'database2.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE database2(id INTEGER PRIMARY KEY, name TEXT, designation TEXT, project TEXT, initiative TEXT, engagement_manager TEXT, start_date TEXT, end_date TEXT)',
        );
      },
      version: 1,
    );
    //Future<void> deleteEmployee(int id) async {
    final db = await database;
    await db.delete(
      'database2',
      where: 'id = ?',
      whereArgs: [id],
    );
    //}
  }


  void put_into_db(int id_a, String name_a, String designation_a, String project_a, String initiative_a, String engagement_manager_a, String start_date_a, String end_date_a) async{
    var fido = Employee_details(
      id: 0,
      name: '',
      designation: '',
      project: '',
      initiative: '',
      engagement_manager: '',
      start_date: '',
      end_date: '',
    );

    fido.id = id_a;
    fido.name = name_a;
    fido.designation = designation_a;
    fido.project = project_a;
    fido.initiative = initiative_a;
    fido.engagement_manager = engagement_manager_a;
    fido.start_date = start_date_a;
    fido.end_date = end_date_a;


    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'database2.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE database2(id INTEGER PRIMARY KEY, name TEXT, designation TEXT, project TEXT, initiative TEXT, engagement_manager TEXT, start_date TEXT, end_date TEXT)',
        );
      },
      version: 1,
    );
    Future<void> insertEmployee(Employee_details database2) async {
      final db = await database;
      await db.insert(
        'database2',
        database2.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await insertEmployee(fido);
  }

  void get_from_db() async{
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      join(await getDatabasesPath(), 'database2.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE database2(id INTEGER PRIMARY KEY, name TEXT, designation TEXT, project TEXT, initiative TEXT, engagement_manager TEXT, start_date TEXT, end_date TEXT)',
        );
      },
      version: 1,
    );
    Future<List<Employee_details>> database2() async {
      // Get a reference to the database.
      final db = await database;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('database2');

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      return List.generate(maps.length, (i) {
        return Employee_details(
          id: maps[i]['id'],
          name: maps[i]['name'],
          designation: maps[i]['designation'],
          project: maps[i]['project'],
          initiative: maps[i]['initiative'],
          engagement_manager: maps[i]['engagement_manager'],
          start_date: maps[i]['start_date'],
          end_date: maps[i]['end_date'],
        );
      });
    }
    //print(await database2());
  }

  String start_date_rev = '';
  String end_date_rev = '';

  late String EM;
  final emp_id = TextEditingController();
  final name = TextEditingController();
  final project = TextEditingController();
  final init = TextEditingController();
  String designation_selected = 'Analyst';
  final del = TextEditingController();


  //String select_designation;
  String dropdownValue='Analyst';


  List <String> designations = [
    'Analyst', 'Associate Consultant', 'Consultant', 'Assistant Manager', 'Manager',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //FORM TO FILL
        child: Container(
          //height: double.infinity,
          //elevation: 6,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.,
                children: <Widget>[

                  //Employee ID
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Align(alignment: Alignment.topLeft,
                    child: Text(
                      'Enter your Employee ID',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),)
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      hintText: 'Enter text',),
                    controller: emp_id,
                    keyboardType: TextInputType.number,
                  ),
                  Text(''),

                  //Name details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Align(alignment: Alignment.topLeft,
                    child: Text(
                      'Enter your full name',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      hintText: 'Enter text',),
                    controller: name,
                  ),
                  Text(''),

                  //Designation Details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Align(alignment: Alignment.topLeft,
                    child: Text(
                      'Enter your designation',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),),//Designation drop down
                  DropdownSearch<String>(
                    maxHeight: 300,
                    //mode of dropdown
                    mode: Mode.DIALOG,
                    //to show search box
                    showSearchBox: true,
                    showSelectedItems: true,
                    //list of dropdown items
                    items: [
                      "Analyst",
                      "Associate Consultant",
                      "Consultant",
                      "Assistant Manager",
                    ],
                    //label: "Country",
                    onChanged: (data) => designation_selected = data.toString(),
                    //show selected item
                    selectedItem: "Analyst",
                  ),
                  Text(''),

                  // Project Details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Align(alignment: Alignment.topLeft,
                    child: Text(
                      'Which project/s are you currently working on?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      //textAlign: TextAlign.center,
                    ),
                  ),),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      hintText: 'Enter text',),
                    controller: project,
                  ),
                  Text(''),

                  //Initiative Details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Align(alignment: Alignment.topLeft,
                    child: Text(
                      'Any initiative/s you have taken up?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                      hintText: 'Enter text',),
                    controller: init,
                  ),
                  Text(''),

                  //Engagement Manager Details
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Align(alignment: Alignment.topLeft,
                    child: Text(
                      'Who is your Engagement Manager?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),),
                  DropdownSearch<String>(
                    //mode of dropdown
                    mode: Mode.DIALOG,
                    //to show search box
                    showSearchBox: true,
                    showSelectedItems: true,
                    //list of dropdown items
                    items: [
                      "Subuhee Parray",
                      "Nishanth Mallinath",
                      "Arjun Malhotra",
                      "Sumit Kapoor",
                      "Sandeep Gill",
                      "Chaitanya Karmakar",
                      "Shivam Awasthi",
                      "Ramesh Kadamata",
                      "Rekha Madandas Vaishnav",
                      "Avinash CH",
                      "Yatin Gaind",
                      "Ashish Agnihotri",
                      "Kunal Roy",
                      "Seema Singh",
                      "Sonal Jain",
                      "Samarth Arora",
                      "Ritu Birla",
                      "Ujjwal Agarwal",
                      "Ankit Jain",
                      "Bhanu Pratap",
                      "Vinay Sharma",
                      "Mahendra Pandey",
                      "Arjun Iyer",
                      "Yasharth Srivastava",
                    ],
                    //label: "Country",
                    onChanged: (data) => EM = data.toString(),

                    //show selected item
                    selectedItem: "",
                  ),

                  Text(''),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Align(alignment: Alignment.topLeft,
                    child: Text(
                      'Start and end date of project?',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),),

                  Card(
                    elevation: 5,
                    child: SfDateRangePicker(
                      headerHeight: 45,
                      headerStyle: DateRangePickerHeaderStyle(
                        textAlign: TextAlign.left,
                        textStyle: TextStyle(
                            color: Colors.white, fontSize: 18,
                            ),
                        backgroundColor: Color(0xff3249ab),),
                      todayHighlightColor: Color(0xff3249ab),
                      selectionTextStyle: TextStyle(color: Color(0xff3249ab)),
                      //selectionColor: Colors.orange,
                      //rangeSelectionColor: Colors.orange,
                      startRangeSelectionColor: Colors.blueAccent.withOpacity(0.6),
                      //rangeTextStyle: TextStyle(color: Colors.white),
                      endRangeSelectionColor: Colors.blueAccent.withOpacity(0.6),

                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 4)),
                          DateTime.now().add(const Duration(days: 3))),
                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                        final dynamic value = args.value;
                        start_date_rev = (value.toString().substring(33,43));
                        //print(start_date_rev);


                        end_date_rev = (value.toString().substring(67,77));
                        //print(end_date_rev);
                      },
                    ),
                  ),

                  //Submit Button
                  Container(
                    padding: const EdgeInsets.all(10),
                  ),
                  ButtonTheme(
                      minWidth: double.infinity,
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        color: Color(0xff3249ab),
                        child: const Text('Submit', style: TextStyle(fontSize: 20, color: Colors.white)),
                        onPressed: () {
                          put_into_db(int.parse(emp_id.text),name.text,designation_selected,project.text,init.text,EM,start_date_rev,end_date_rev);

                          showDialog(context: context, builder: (context){
                            return CustomDialogBox(title: "Congrats!", descriptions: "Your response has been submitted successfully", text: "Okay", img: Image.asset("assets/tick_mark.png"),);
                          });
                        }
                      )
                  ),
                  Text(''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



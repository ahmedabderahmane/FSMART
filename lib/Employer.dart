import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Screen
class Employer extends StatelessWidget {
  Employer(
      {super.key,
      required empName,
      required empNum,
      required imageUrl,
      required adress});
  final EmployerController _employerController = EmployerController();

  get empNum => 32;

  String get emp => 'Ahmed';

  String get imageUrl => 'tgf';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: const Text("Les Main Doeuvre"),
              centerTitle: true,
            ),
            body: Obx(
              () => _employerController.isLoadingEmployers.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: _employerController.emps
                          .map(
                            (emp) => EmployerCard(
                              emp: emp,
                            ),
                          )
                          .toList()),
            )),
      ),
    );
  }

  static dart() {}
}

// Service
class EmployerService {
  Future<List<Employer>> getEmployersFromFirebase() async {
    List<Employer> emp = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('emps').get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot
          in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data();

        Employer employer = Employer(
            empName: data['Emploi'] ?? '',
            empNum: (data['Num Employer'] ?? 0.0).toNumbre(),
            imageUrl: data['imageUrl'] ?? '',
            adress: data['Adress'] ?? '');
        emp.add(employer);
      }
      return emp;
    } catch (error) {
      print('Error fetching emps: $error');
      return [];
    }
  }
}

//Controller
class EmployerController extends GetxController {
  final EmployerService _employerService = EmployerService();
  var isLoadingEmployers = false.obs;
  List<Employer> emps = [];

  void setIsloadingEmployer(bool newValue) {
    isLoadingEmployers.value = newValue;
  }

  Future<void> getEmployer() async {
    setIsloadingEmployer(true);
    emps = await _employerService.getEmployersFromFirebase();
    setIsloadingEmployer(false);
  }

  // ignore: non_constant_identifier_names
  EmployerCard() {
    getEmployer();
  }
}

// Widget
class EmployerCard extends StatelessWidget {
  const EmployerCard({
    super.key,
    required this.emp,
  });

  final Employer emp;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            //New
            image: NetworkImage(emp.imageUrl),

            //New
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      ),
      title: Text(emp.emp),
      subtitle: Text("Employer rating : ${emp.empNum}"),
    );
  }
}

// Model
// ignore: camel_case_types
class emp {
  final String empName;
  final double empNum;
  final String imageUrl;
  final String adress;

  emp({
    required this.empName,
    required this.empNum,
    required this.imageUrl,
    required this.adress,
  });
}

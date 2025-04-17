import 'dart:developer';

import 'package:bmi_project/screens/data_list_screen.dart';
import 'package:bmi_project/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? selectedGender;
  int age = 0;
  List<Map<String, dynamic>> dataDetails = [];

  /// Date Picker
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.purpleAccent,
              onPrimary: Colors.white,
              onSurface: Colors.purple,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  /// Save data to Firebase
  Future<void> _saveData() async {
    DateTime currentDate = DateTime.now();
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// Calculate age
      DateTime dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      int age = currentDate.year - dob.year;
      if (currentDate.month < dob.month ||
          (currentDate.month == dob.month && currentDate.day < dob.day)) {
        age--;
      }

      /// BMI Calculation
      double value = int.parse(weightController.text) /
          ((int.parse(heightController.text) / 100) *
              (int.parse(heightController.text) / 100));
      String bmiString = value.toString();
      String bmi = bmiString.substring(0, 4);

      /// Create a map of the data
      Map<String, dynamic> data = {
        'name': nameController.text,
        'date_of_birth': dobController.text,
        'age': age,
        'gender': selectedGender,
        'height': heightController.text,
        'weight': weightController.text,
        'date_of_entry': DateTime.now(),
        'bmi': bmi,
      };

      log('data - $data');
      dataDetails.add(data);

      setState(() {
        nameController.clear();
        dobController.clear();
        heightController.clear();
        weightController.clear();
        selectedGender = null;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DataListScreen(dataList: dataDetails),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        title: const CustomText(
          text: 'Hello, Welcome Back 😊',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFF4EAFB)], // Light purple gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'Fill Your Details',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.purple,
                            ),
                            labelText: 'Name',
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.purple,
                            ),
                            hintText: 'Enter your full name',
                            filled: true,
                            fillColor: Colors.purple.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: dobController,
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.calendar_today,
                              color: Colors.purple,
                            ),
                            labelText: 'Date of Birth',
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.purple,
                            ),
                            hintText: 'Select your date of birth',
                            filled: true,
                            fillColor: Colors.purple.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your date of birth';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: selectedGender,
                          items: ['Male', 'Female', 'Other']
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(
                                      gender,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            selectedGender = value;
                          },
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Colors.purple,
                            ),
                            labelText: 'Gender',
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.purple,
                            ),
                            filled: true,
                            fillColor: Colors.purple.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your gender';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: heightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.height,
                              color: Colors.purple,
                            ),
                            labelText: 'Height (in cm)',
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.purple,
                            ),
                            hintText: 'Enter your height in cm',
                            filled: true,
                            fillColor: Colors.purple.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your height';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number in cm';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: weightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.line_weight,
                              color: Colors.purple,
                            ),
                            labelText: 'Weight (in kg)',
                            labelStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.purple,
                            ),
                            hintText: 'Enter your weight in kg',
                            filled: true,
                            fillColor: Colors.purple.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your weight';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number in kg';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.purple,
                    ),
                    icon: const Icon(
                      Icons.check_circle,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: const CustomText(
                      text: 'Submit',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

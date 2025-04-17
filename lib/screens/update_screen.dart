import 'dart:developer';

import 'package:bmi_project/screens/data_list_screen.dart';
import 'package:bmi_project/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key, required this.dataList});

  final List<Map<String, dynamic>> dataList;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  Future<void> _saveData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      /// BMI Calculation
      double value = int.parse(weightController.text) /
          ((int.parse(heightController.text) / 100) *
              (int.parse(heightController.text) / 100));
      String bmiString = value.toString();
      String bmi = bmiString.substring(0, 4);

      Map<String, dynamic> firstData = widget.dataList.first;

      /// Create a map of the data
      Map<String, dynamic> data = {
        'name': firstData['name'],
        'date_of_birth': firstData['date_of_birth'],
        'age': firstData['age'],
        'gender': firstData['gender'],
        'height': heightController.text,
        'weight': weightController.text,
        'date_of_entry': DateTime.now(),
        'bmi': bmi,
      };

      log('data - $data');
      widget.dataList.add(data);
      log('data details - ${widget.dataList}');

      setState(() {
        heightController.clear();
        weightController.clear();
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => DataListScreen(dataList: widget.dataList)),
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
          text: 'Update Details',
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

import 'package:bmi_project/screens/update_screen.dart';
import 'package:bmi_project/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key, required this.dataList});

  final List<Map<String, dynamic>> dataList;

  @override
  State<DataListScreen> createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> firstData = widget.dataList.first;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        elevation: 0,
        title: const CustomText(
          text: 'BMI Details',
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.purple.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name Section
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.purple,
                                radius: 25,
                                child: Icon(
                                  Icons.person,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    firstData['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Have a nice day',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(
                            height: 32,
                            thickness: 1,
                            color: Colors.grey,
                          ),

                          // Gender, Age, and DOB Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildDetailTile(
                                icon: Icons.transgender,
                                title: 'Gender',
                                value: firstData['gender'],
                              ),
                              _buildDetailTile(
                                icon: Icons.cake,
                                title: 'Age',
                                value: firstData['age'].toString(),
                              ),
                              _buildDetailTile(
                                icon: Icons.calendar_today,
                                title: 'DOB',
                                value: firstData['date_of_birth'],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateScreen(dataList: widget.dataList),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.purple,
                    ),
                    icon: const Icon(
                      Icons.edit,
                      size: 24,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Update Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAverageCard(
                          color: Colors.purpleAccent,
                          title: 'Underweight',
                          value: '-18.5',
                          icon: Icons.arrow_downward,
                        ),
                        const SizedBox(height: 10),
                        _buildAverageCard(
                          color: Colors.orangeAccent,
                          title: 'Over weight',
                          value: '25 - 29.9',
                          icon: Icons.warning_amber_rounded,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAverageCard(
                          color: Colors.green,
                          title: 'Normal weight',
                          value: '18.5 - 24.9',
                          icon: Icons.check_circle,
                        ),
                        const SizedBox(height: 10),
                        _buildAverageCard(
                          color: Colors.red,
                          title: 'Obese weight',
                          value: '30+',
                          icon: Icons.arrow_upward,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: CustomText(
                    text: 'BMI Details',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.dataList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = widget.dataList[index];

                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(data['date_of_entry']);
                    String formattedTime =
                        DateFormat('hh:mm a').format(data['date_of_entry']);

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "$formattedDate - $formattedTime",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Divider(),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Height',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${data['height']} cm',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Weight',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${data['weight']} kg',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),

                                /// BMI
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'BMI',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.purple,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      data['bmi'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(
      {required IconData icon, required String title, required String value}) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          radius: 24,
          child: Icon(icon, size: 24, color: Colors.purple),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildAverageCard({
    required Color color,
    required String title,
    required String value,
    required IconData icon,
  }) {
    return SizedBox(
      width: 180,
      height: 89,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(width: 5),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

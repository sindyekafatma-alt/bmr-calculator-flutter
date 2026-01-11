import 'package:flutter/material.dart';

void main() {
  runApp(const BMRCalculatorApp());
}

class BMRCalculatorApp extends StatelessWidget {
  const BMRCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BMR Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BMRCalculatorScreen(),
    );
  }
}

class BMRCalculatorScreen extends StatefulWidget {
  const BMRCalculatorScreen({Key? key}) : super(key: key);

  @override
  State<BMRCalculatorScreen> createState() => _BMRCalculatorScreenState();
}

class _BMRCalculatorScreenState extends State<BMRCalculatorScreen> {
  // Controller untuk input field
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  // Variable untuk menyimpan pilihan gender
  String _selectedGender = 'male';

  // Variable untuk menyimpan hasil kalkulasi BMR
  double _bmrResult = 0.0;

  // Variable untuk menyimpan kalori berdasarkan activity level
  Map<String, double> _calorieNeeds = {};

  // Variable untuk menampilkan/menyembunyikan hasil
  bool _showResult = false;

  /// Fungsi untuk menghitung BMR menggunakan Mifflin-St Jeor Equation
  /// Formula:
  /// - Male: BMR = (10 × weight in kg) + (6.25 × height in cm) - (5 × age in years) + 5
  /// - Female: BMR = (10 × weight in kg) + (6.25 × height in cm) - (5 × age in years) - 161
  void _calculateBMR() {
    // Validasi input - pastikan semua field terisi
    if (_ageController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty) {
      // Tampilkan pesan error jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Parse input dari string ke double
    double age = double.parse(_ageController.text);
    double height = double.parse(_heightController.text);
    double weight = double.parse(_weightController.text);

    // Hitung BMR berdasarkan gender
    double bmr;
    if (_selectedGender == 'male') {
      // Formula untuk pria
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      // Formula untuk wanita
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Hitung kebutuhan kalori berdasarkan activity level
    // Menggunakan Harris-Benedict Equation
    _calorieNeeds = {
      'Sedentary': bmr * 1.2, // Little or no exercise
      'Light': bmr * 1.375, // Exercise 1-3 times/week
      'Moderate': bmr * 1.55, // Exercise 4-5 times/week
      'Active': bmr * 1.725, // Daily exercise or intense exercise 3-4 times/week
      'Very Active': bmr * 1.9, // Intense exercise 6-7 times/week
    };

    // Update state untuk menampilkan hasil
    setState(() {
      _bmrResult = bmr;
      _showResult = true;
    });
  }

  /// Fungsi untuk mereset semua input dan hasil
  void _clearAll() {
    setState(() {
      _ageController.clear();
      _heightController.clear();
      _weightController.clear();
      _selectedGender = 'male';
      _bmrResult = 0.0;
      _calorieNeeds.clear();
      _showResult = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'BMR Calculator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card informasi tentang BMR
              _buildInfoCard(),
              const SizedBox(height: 20),

              // Card input form
              _buildInputCard(),
              const SizedBox(height: 20),

              // Tombol Calculate dan Clear
              _buildActionButtons(),
              const SizedBox(height: 20),

              // Tampilkan hasil jika sudah dihitung
              if (_showResult) _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget untuk card informasi BMR
  Widget _buildInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 8),
                const Text(
                  'About BMR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Basal Metabolic Rate (BMR) is the amount of energy expended while at rest in a neutrally temperate environment, in the post-absorptive state.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk card input form
  Widget _buildInputCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Your Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Input Age
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Age',
                suffixText: 'years',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 16),

            // Input Height
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height',
                suffixText: 'cm',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 16),

            // Input Weight
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight',
                suffixText: 'kg',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.monitor_weight),
              ),
            ),
            const SizedBox(height: 16),

            // Radio button untuk memilih gender
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk tombol Calculate dan Clear
  Widget _buildActionButtons() {
    return Row(
      children: [
        // Tombol Calculate
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: _calculateBMR,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calculate),
                SizedBox(width: 8),
                Text(
                  'Calculate',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Tombol Clear
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: _clearAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[400],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Clear',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Widget untuk menampilkan hasil BMR dan kebutuhan kalori
  Widget _buildResultCard() {
    return Card(
      elevation: 3,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Result
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 28),
                const SizedBox(width: 8),
                const Text(
                  'Result',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // BMR Result
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[300]!, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your BMR',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_bmrResult.toStringAsFixed(0)} Calories/day',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Daily Calorie Needs
            const Text(
              'Daily Calorie Needs Based on Activity Level',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Tabel kebutuhan kalori
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _buildCalorieRow('Sedentary (little or no exercise)',
                      _calorieNeeds['Sedentary']!),
                  _buildCalorieRow('Light (exercise 1-3 times/week)',
                      _calorieNeeds['Light']!),
                  _buildCalorieRow('Moderate (exercise 4-5 times/week)',
                      _calorieNeeds['Moderate']!),
                  _buildCalorieRow('Active (daily exercise)',
                      _calorieNeeds['Active']!),
                  _buildCalorieRow('Very Active (intense exercise daily)',
                      _calorieNeeds['Very Active']!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk baris tabel kebutuhan kalori
  Widget _buildCalorieRow(String activityLevel, double calories) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              activityLevel,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Text(
            calories.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget di-dispose
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}

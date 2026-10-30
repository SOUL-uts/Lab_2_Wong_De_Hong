
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const StudentInfoApp());
}

class StudentInfoApp extends StatelessWidget {
  const StudentInfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CSS3344 Lab 02',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const StudentProfileScreen(),
    );
  }
}

// Main Screen - StatefulWidget for Pickers
class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() =>
      _StudentProfileScreenState();
}

class _StudentProfileScreenState
    extends State<StudentProfileScreen> {

  DateTime _selectedDate = DateTime.now();
  String _selectedRole = 'Student';

  final List<String> _roles = [
    'Student',
    'Developer',
    'Designer',
  ];

  String get _formattedDate {
    return '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
  }

  // 1. Material Date Picker
  Future<void> _selectMaterialDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // 2. Cupertino Date Picker
  void _showCupertinoDatePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 280,
          color: CupertinoColors.systemBackground
              .resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(
                  height: 220,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _selectedDate,
                    minimumDate: DateTime(1950),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    Navigator.pop(popupContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 3. Cupertino Wheel Picker
  void _showCupertinoRolePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (popupContext) {
        return Container(
          height: 260,
          color: CupertinoColors.systemBackground
              .resolveFrom(context),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    Navigator.pop(popupContext);
                  },
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 40,
                    scrollController:
                    FixedExtentScrollController(
                      initialItem:
                      _roles.indexOf(_selectedRole),
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedRole = _roles[index];
                      });
                    },
                    children: _roles.map((role) {
                      return Center(child: Text(role));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 4. Picker Section
  Widget _buildPickerSection() {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Pickers (Lab 2.2)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),

            Text('Selected Date: $_formattedDate'),
            Text('Selected Role: $_selectedRole'),

            const SizedBox(height: 15),

            // Material Date Picker Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectMaterialDate,
                icon: const Icon(Icons.calendar_month),
                label: const Text('Material Date Picker'),
              ),
            ),

            // Cupertino Date Picker Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showCupertinoDatePicker,
                icon: const Icon(Icons.date_range),
                label: const Text('Cupertino Date Picker'),
              ),
            ),

            const SizedBox(height: 15),
            const Text('Material Dropdown:'),

            // Material Dropdown Picker
            DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              items: _roles.map((role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                }
              },
            ),

            // Cupertino Wheel Picker Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _showCupertinoRolePicker,
                icon: const Icon(Icons.list),
                label: const Text('Cupertino Wheel Picker'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Exercise 2.2 - Portrait Layout
  Widget _buildPortraitView() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        const StudentDetailsSection(),

        const TitleSection(
          name: 'Oeschinen Lake',
          location: 'Kandersteg, Switzerland',
          starCount: 41,
        ),

        const ImageSection(),

        const ActionButtonsSection(),

        const TextSection(),

        _buildPickerSection(),
      ],
    );
  }

  // Exercise 2.2 - Landscape Layout
  Widget _buildLandscapeView() {
    return Row(
      children: [
        const Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: StudentDetailsSection(),
          ),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              const TitleSection(
                name: 'Oeschinen Lake',
                location: 'Kandersteg, Switzerland',
                starCount: 41,
              ),

              const ImageSection(),

              const ActionButtonsSection(),

              const TextSection(),

              _buildPickerSection(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CSS3344 Mobile App Dev - Lab 02',
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primaryContainer,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildPortraitView();
          } else {
            return _buildLandscapeView();
          }
        },
      ),
    );
  }
}

// Exercise 2.1 - Student Details Widget
class StudentDetailsSection extends StatelessWidget {
  const StudentDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.indigo,
              backgroundImage: AssetImage(
                'assets/img.png',
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Wong De Hong',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'BCS24020014',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const Divider(
              height: 32,
              thickness: 1,
            ),

            const Text(
              'Personal Life Goal / Quote:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '"Be a Millionaire"',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic,
                color: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Exercise 2.1 - Reusable Title Section
class TitleSection extends StatelessWidget {
  final String name;
  final String location;
  final int starCount;

  const TitleSection({
    super.key,
    required this.name,
    required this.location,
    required this.starCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.star,
            color: Colors.red[500],
          ),

          const SizedBox(width: 4),

          Text('$starCount'),
        ],
      ),
    );
  }
}

// Image Section - Displays lake.jpg
class ImageSection extends StatelessWidget {
  const ImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/lake.jpg',
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }
}

// Action Buttons Section
class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.call, color: Colors.indigo),
              SizedBox(height: 5),
              Text('CALL'),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.near_me, color: Colors.indigo),
              SizedBox(height: 5),
              Text('ROUTE'),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.share, color: Colors.indigo),
              SizedBox(height: 5),
              Text('SHARE'),
            ],
          ),
        ],
      ),
    );
  }
}

// Text Description Section
class TextSection extends StatelessWidget {
  const TextSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'Oeschinen Lake is located in Kandersteg, '
            'Switzerland. It is surrounded by beautiful '
            'mountains and natural scenery. The lake is '
            'a popular destination for hiking, sightseeing, '
            'and enjoying the natural environment.',
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
        ),
      ),
    );
  }
}

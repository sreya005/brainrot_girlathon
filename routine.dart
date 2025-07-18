import 'package:flutter/material.dart';

class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}

class _RoutinePageState extends State<RoutinePage> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  List<String> workDays = [];
  TimeOfDay? workStart;
  TimeOfDay? workEnd;
  String? workType;

  TimeOfDay? wakeUpTime;
  TimeOfDay? bedTime;
  TimeOfDay? breakfast;
  TimeOfDay? lunch;
  TimeOfDay? dinner;

  String? childAge;
  String? childcare;
  TimeOfDay? activeStart;
  TimeOfDay? activeEnd;

  List<String> freeTime = [];
  String busyTimes = '';
  String goals = '';
  String challenges = '';

  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Gray top bar
          Container(
            width: double.infinity,
            height: 60,
            color: Color(0xFFD0D0D0),
            child: Center(
              child: Text(
                'Daily Routine Assessment',
                style: TextStyle(
                  color: Color(0xFF2C2C2C),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 1200),
                  child: Container(
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Color(0xFFE0E0E0)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Header
                          Column(
                            children: [
                              Text(
                                'Parent Routine Assessment',
                                style: TextStyle(
                                  color: Color(0xFF2C2C2C),
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Help us understand your daily routine to optimize your child\'s app interaction time',
                                style: TextStyle(
                                  color: Color(0xFF5C5C5C),
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(height: 30),

                          // Progress bar
                          Container(
                            width: double.infinity,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF8A8A8A),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),

                          // Form sections
                          LayoutBuilder(
                            builder: (context, constraints) {
                              bool isWide = constraints.maxWidth > 1024;
                              return Column(
                                children: [
                                  if (isWide)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: _buildWorkScheduleSection()),
                                        SizedBox(width: 30),
                                        Expanded(
                                            child: _buildDailyRoutineSection()),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        _buildWorkScheduleSection(),
                                        SizedBox(height: 30),
                                        _buildDailyRoutineSection(),
                                      ],
                                    ),
                                  SizedBox(height: 30),

                                  if (isWide)
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: _buildChildCareSection()),
                                        SizedBox(width: 30),
                                        Expanded(
                                            child: _buildAvailabilitySection()),
                                      ],
                                    )
                                  else
                                    Column(
                                      children: [
                                        _buildChildCareSection(),
                                        SizedBox(height: 30),
                                        _buildAvailabilitySection(),
                                      ],
                                    ),
                                  SizedBox(height: 30),

                                  _buildAdditionalInfoSection(),
                                  SizedBox(height: 30),

                                  // Submit button
                                  Center(
                                    child: ElevatedButton(
                                      onPressed: _submitForm,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF6C6C6C),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 40,
                                          vertical: 15,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Text(
                                        'Complete Assessment',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection(String title, int number, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors
            .white, // Changed from light gray to white for better visibility
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: Color(0xFFE0E0E0)), // Simple border all around
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: Color(0xFF8A8A8A),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF2C2C2C),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildWorkScheduleSection() {
    return _buildFormSection('Work Schedule', 1, [
      // Work Days
      Text(
        'Work Days',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      _buildCheckboxGroup([
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ], workDays),
      SizedBox(height: 20),

      // Work Hours
      Text(
        'Work Hours',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: _buildTimeField('Start Time', workStart, (time) {
              setState(() {
                workStart = time;
                _updateProgress();
              });
            }),
          ),
          SizedBox(width: 10),
          Text('to', style: TextStyle(color: Color(0xFF5C5C5C), fontSize: 14)),
          SizedBox(width: 10),
          Expanded(
            child: _buildTimeField('End Time', workEnd, (time) {
              setState(() {
                workEnd = time;
                _updateProgress();
              });
            }),
          ),
        ],
      ),
      SizedBox(height: 20),

      // Work Type
      Text(
        'Work Type',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: workType,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF8A8A8A)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        ),
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 14,
        ),
        dropdownColor: Colors.white,
        items: [
          'Office Work',
          'Remote Work',
          'Hybrid',
          'Part-time',
          'Freelance',
          'Other'
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value.toLowerCase().replaceAll(' ', '').replaceAll('-', ''),
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            workType = value;
            _updateProgress();
          });
        },
        hint: Text(
          'Select work type',
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
        ),
      ),
    ]);
  }

  Widget _buildDailyRoutineSection() {
    return _buildFormSection('Daily Routine', 2, [
      // Wake Up Time
      Text(
        'Wake Up Time',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      _buildTimeField('Wake Up Time', wakeUpTime, (time) {
        setState(() {
          wakeUpTime = time;
          _updateProgress();
        });
      }),
      SizedBox(height: 20),

      // Bedtime
      Text(
        'Bedtime',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      _buildTimeField('Bedtime', bedTime, (time) {
        setState(() {
          bedTime = time;
          _updateProgress();
        });
      }),
      SizedBox(height: 20),

      // Meal Times
      Text(
        'Meal Times',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Breakfast:',
                  style: TextStyle(
                    color: Color(0xFF5C5C5C),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildTimeField('Breakfast', breakfast, (time) {
                  setState(() {
                    breakfast = time;
                    _updateProgress();
                  });
                }),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Lunch:',
                  style: TextStyle(
                    color: Color(0xFF5C5C5C),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildTimeField('Lunch', lunch, (time) {
                  setState(() {
                    lunch = time;
                    _updateProgress();
                  });
                }),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  'Dinner:',
                  style: TextStyle(
                    color: Color(0xFF5C5C5C),
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildTimeField('Dinner', dinner, (time) {
                  setState(() {
                    dinner = time;
                    _updateProgress();
                  });
                }),
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  Widget _buildChildCareSection() {
    return _buildFormSection('Child Care', 3, [
      // Child's Age
      Text(
        'Child\'s Age',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: childAge,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF8A8A8A)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        ),
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 14,
        ),
        dropdownColor: Colors.white,
        items: [
          '2-3 years',
          '4-5 years',
          '6-8 years',
          '9-12 years',
          '13+ years'
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            childAge = value;
            _updateProgress();
          });
        },
        hint: Text(
          'Select age',
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(height: 20),

      // Childcare Arrangement
      Text(
        'Childcare Arrangement',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      DropdownButtonFormField<String>(
        value: childcare,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF8A8A8A)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        ),
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 14,
        ),
        dropdownColor: Colors.white,
        items: [
          'Full-time Parent',
          'Daycare',
          'Nanny/Babysitter',
          'Family Member',
          'School Hours',
          'Mixed Arrangement'
        ].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF2C2C2C),
                fontSize: 14,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            childcare = value;
            _updateProgress();
          });
        },
        hint: Text(
          'Select arrangement',
          style: TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
        ),
      ),
      SizedBox(height: 20),

      // Most Active Child Time
      Text(
        'Most Active Child Time',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: _buildTimeField('Start Time', activeStart, (time) {
              setState(() {
                activeStart = time;
                _updateProgress();
              });
            }),
          ),
          SizedBox(width: 10),
          Text('to', style: TextStyle(color: Color(0xFF5C5C5C), fontSize: 14)),
          SizedBox(width: 10),
          Expanded(
            child: _buildTimeField('End Time', activeEnd, (time) {
              setState(() {
                activeEnd = time;
                _updateProgress();
              });
            }),
          ),
        ],
      ),
    ]);
  }

  Widget _buildAvailabilitySection() {
    return _buildFormSection('Availability', 4, [
      // Free Time
      Text(
        'When do you have the most free time with your child?',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      _buildCheckboxGroup(
          ['Morning', 'Afternoon', 'Evening', 'Weekends'], freeTime),
      SizedBox(height: 20),

      // Busy Times
      Text(
        'Times when you\'re typically busy',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF8A8A8A)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          hintText:
              'e.g., 8-10 AM work calls, 3-4 PM school pickup, cooking dinner 6-7 PM',
          hintStyle: TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 14,
        ),
        onChanged: (value) {
          setState(() {
            busyTimes = value;
            _updateProgress();
          });
        },
      ),
    ]);
  }

  Widget _buildAdditionalInfoSection() {
    return _buildFormSection('Additional Information', 5, [
      // Goals
      Text(
        'What are your main goals for using this app with your child?',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF8A8A8A)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          hintText:
              'e.g., educational development, bonding time, learning new skills together',
          hintStyle: TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 14,
        ),
        onChanged: (value) {
          setState(() {
            goals = value;
            _updateProgress();
          });
        },
      ),
      SizedBox(height: 20),

      // Challenges
      Text(
        'Any specific challenges in your routine we should know about?',
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(height: 8),
      TextFormField(
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFFC0C0C0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Color(0xFF8A8A8A)),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          hintText:
              'e.g., irregular work schedule, multiple children, specific needs',
          hintStyle: TextStyle(
            color: Color(0xFF999999),
            fontSize: 14,
          ),
        ),
        style: TextStyle(
          color: Color(0xFF2C2C2C),
          fontSize: 14,
        ),
        onChanged: (value) {
          setState(() {
            challenges = value;
            _updateProgress();
          });
        },
      ),
    ]);
  }

  Widget _buildTimeField(
      String label, TimeOfDay? time, Function(TimeOfDay) onChanged) {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: time ?? TimeOfDay.now(),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFC0C0C0)),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              time != null ? time.format(context) : 'Select time',
              style: TextStyle(
                color: time != null ? Color(0xFF2C2C2C) : Color(0xFF999999),
                fontSize: 14,
              ),
            ),
            Icon(
              Icons.access_time,
              color: Color(0xFF8A8A8A),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxGroup(
      List<String> options, List<String> selectedValues) {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: options.map((option) {
        final isSelected = selectedValues.contains(option.toLowerCase());

        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedValues.remove(option.toLowerCase());
              } else {
                selectedValues.add(option.toLowerCase());
              }
              _updateProgress();
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedValues.add(option.toLowerCase());
                    } else {
                      selectedValues.remove(option.toLowerCase());
                    }
                    _updateProgress();
                  });
                },
                activeColor: Color(0xFF8A8A8A),
                checkColor: Colors.white,
                side: BorderSide(
                  color: Color(0xFFC0C0C0),
                  width: 1.5,
                ),
              ),
              Text(
                option,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _updateProgress() {
    int totalRequired = 4; // workStart, workEnd, wakeUpTime, bedTime
    int filled = 0;

    if (workStart != null) filled++;
    if (workEnd != null) filled++;
    if (wakeUpTime != null) filled++;
    if (bedTime != null) filled++;

    setState(() {
      progress = filled / totalRequired;
    });
  }

  void _submitForm() {
    // Collect all form data
    final formData = {
      'workDays': workDays,
      'workStart': workStart?.format(context),
      'workEnd': workEnd?.format(context),
      'workType': workType,
      'wakeUpTime': wakeUpTime?.format(context),
      'bedTime': bedTime?.format(context),
      'breakfast': breakfast?.format(context),
      'lunch': lunch?.format(context),
      'dinner': dinner?.format(context),
      'childAge': childAge,
      'childcare': childcare,
      'activeStart': activeStart?.format(context),
      'activeEnd': activeEnd?.format(context),
      'freeTime': freeTime,
      'busyTimes': busyTimes,
      'goals': goals,
      'challenges': challenges,
    };

    print('Form Data: $formData');

    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Assessment Completed!',
            style: TextStyle(
              color: Color(0xFF2C2C2C),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            'We\'ll use this information to optimize your child\'s app experience.',
            style: TextStyle(
              color: Color(0xFF5C5C5C),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF8A8A8A),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

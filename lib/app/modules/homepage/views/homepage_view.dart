import 'package:flutter/material.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/bottom_nav_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/homepage_controller.dart';
import 'package:meetingreminder/app/services/notification_services.dart';

import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  Rx<DateTime> _focusedDay = Rx<DateTime>(
      DateTime.now()); // Declare _focusedDay as a reactive variable
  DateTime? _selectedDay;
  final BottomNavController controller = Get.put(BottomNavController());
  final TimePickerController timePickerController =
      Get.put(TimePickerController());
  final NotificationService _notificationService = NotificationService();

  List<String> imageItems = [
    'assets/images/icons/home-page.png',
    'assets/images/icons/clock(1).png',
  ];

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Widget buildReminderBox() {
    return AlertDialog(
      title: const Text('Select Meeting Time'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildRemarksRow(),
          const SizedBox(height: 20),
          buildStartTimeInput(),
          const SizedBox(height: 20),
          buildEndtimeInput(),
          const SizedBox(height: 20),
          buildConfirmDeleteButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildRemarksRow() {
    return Row(
      children: [
        Container(
            height: 20,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                color: Color.fromARGB(255, 218, 190, 117)),
            child: const Text(
              'Remarks',
              style: TextStyle(fontSize: 15),
            )),
        const SizedBox(
          width: 100,
        ),
        Container(
          width: 100,
          height: 50, // Set width of the container
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Add padding inside the container
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            borderRadius: BorderRadius.circular(12), // Rounded corners
            boxShadow: const [
              BoxShadow(
                color: Colors.black12, // Shadow color
                blurRadius: 8, // Blur effect
                offset: Offset(0, 4), // Shadow position
              ),
            ],
            border: Border.all(
                color: Colors.grey.shade300), // Border color and width
          ),
          child: TextField(
            controller: timePickerController.remarkController.value,
            decoration: InputDecoration(
              border: InputBorder.none, // Removes default TextField border
              hintText: 'Enter your text here',
              // Placeholder text
              hintStyle:
                  TextStyle(color: Colors.grey.shade400), // Hint text styling
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStartTimeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
              height: 20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: Color.fromARGB(255, 218, 190, 117)),
              child: const Text('Start Time:')),
        ),
        SizedBox(
          width: 100,
          child: Obx(() {
            return GestureDetector(
                onTap: () => timePickerController.meetingSetter(context, true),
                child: Container(
                    child: Text(timePickerController.startTime.value.isEmpty
                        ? 'select time'
                        : timePickerController.startTime.value)));
          }),
        ),
      ],
    );
  }

  Widget buildEndtimeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
              height: 20,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  color: Color.fromARGB(255, 218, 190, 117)),
              child: const Text('End Time:')),
        ),
        SizedBox(
          width: 100,
          child: Obx(() {
            return GestureDetector(
                onTap: () => timePickerController.meetingSetter(context, false),
                child: Container(
                    child: Text(timePickerController.endTime.value.isEmpty
                        ? 'select time'
                        : timePickerController.endTime.value)));
          }),
        ),
      ],
    );
  }

  Widget buildConfirmDeleteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: () {
            timePickerController.addMeeting(
                timePickerController.remarkController.value.text,
                timePickerController.startTime.value,
                timePickerController.endTime.value);
          },
          child: const Text('Confirm'),
        ),
        ElevatedButton(
          onPressed: () {
            _notificationService.showNotification(
              id: 1,
              title: 'Test Notification',
              body: 'This is a test notification sent immediately.',
            );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        buildMonthPicker(),
        buildCalendar(),
        buildText(),
        buildContainer(context),
        buildBottomBar(),
        floatingButton(buildReminderBox())
      ]),
    );
  }

  Widget buildMonthPicker() {
    return Positioned(
      top: 46,
      right: 40,
      child: Container(
        height: 60,
        width: 150,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(45),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Text(
            //   DateFormat.y().format(_focusedDay), // Displays the year
            //   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            DropdownButton<String>(
              value: DateFormat.MMMM().format(_focusedDay.value),
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              underline: Container(),
              onChanged: (String? newValue) {
                // Use Rx's .value to update _focusedDay
                if (newValue != null) {
                  int monthIndex = _months.indexOf(newValue) + 1;
                  _focusedDay.value =
                      DateTime(_focusedDay.value.year, monthIndex);
                }
              },
              items: _months.map<DropdownMenuItem<String>>((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month, style: const TextStyle(fontSize: 16)),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCalendar() {
    return Positioned(
      left: 30,
      top: 130,
      child: Container(
        height: 380,
        width: 350,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: TableCalendar(
            focusedDay: _focusedDay.value,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay.value = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              cellMargin: const EdgeInsets.all(2),
              todayDecoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
            // headerStyle: const HeaderStyle(
            //   formatButtonVisible: false,
            //   titleCentered: true,
            // ),

            headerStyle: const HeaderStyle(
              headerMargin: EdgeInsets.zero,
              formatButtonVisible: false,
              titleCentered: false,
              titleTextStyle: TextStyle(fontSize: 0),
              leftChevronVisible: false, // Disable default chevron buttons
              rightChevronVisible: false,
              // Disable default chevron buttons
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText() {
    return Positioned(
      bottom: 320,
      left: 30,
      child: Text(
        'Today Meetings',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildContainer(BuildContext context) {
    final TimePickerController timePickerController =
        Get.put(TimePickerController());
    return Positioned(
      bottom: 70,
      left: 30,
      child: SizedBox(
          height: 250,
          width: MediaQuery.of(context).size.width - 60,
          child: Obx(() {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: timePickerController.meeting.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final meeting = timePickerController.meeting[index];
                  return Container(
                      height: 240,
                      width: 200,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(children: [
                        Positioned(
                          right: -20,
                          top: 0,
                          child: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Delete') {
                                // Perform delete action
                                timePickerController.deleteMeeting(index);
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return [
                                const PopupMenuItem(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ];
                            },
                            icon:
                                const Icon(Icons.more_vert), // Three dots icon
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Meeting Type : ${meeting['headline']!}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Meeting Time : ${meeting['Meeting Time']!}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 39, 36, 36)),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Details : ${meeting['details']!}",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 26, 25, 25)),
                              ),
                            ],
                          ),
                        ),
                      ]));
                },
              ),
            );
          })),
    );
  }

  Widget buildBottomBar() {
    return Positioned(
      left: 50,
      bottom: 20,
      child: Obx(
        () => Row(
          children: [
            Container(
              height: 80,
              width: 200,
              // width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                    220, 245, 173, 0.6), //background: rgba(220, 245, 173, 0.6);

                borderRadius: BorderRadius.circular(70),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(imageItems.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      controller.changeIndex(index); // Update selected index
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      // padding: const EdgeInsets.all(5), // Space between the icons
                      decoration: BoxDecoration(
                          shape:
                              BoxShape.circle, // Circular shape for each icon
                          color: controller.selectedIndex.value == index
                              ? Colors.white // Highlight the selected icon
                              : const Color.fromRGBO(255, 255, 255,
                                  0.3) //background: rgba(255, 255, 255, 0.3);

                          // Non-selected icons remain transparent
                          ),
                      child: Center(
                        child: Image.asset(
                          imageItems[index],
                          width: 30,
                          height: 30,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget floatingButton(Widget name) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: () {
          Get.dialog(buildReminderBox());
        },
        child: Container(
          height: 80,
          width: 80,
          // width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(
                220, 245, 173, 0.6), //background: rgba(220, 245, 173, 0.6);

            borderRadius: BorderRadius.circular(70),
          ),

          child: const Center(
              child: Text(
            '+',
            style: TextStyle(fontSize: 28),
          )),
        ),
      ),
    );
  }
}

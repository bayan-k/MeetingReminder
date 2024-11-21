import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/bottom_nav_controller.dart';
import 'package:meetingreminder/app/modules/homepage/controllers/homepage_controller.dart';
import 'package:meetingreminder/app/services/notification_services.dart';

class TimeLineView extends StatefulWidget {
  const TimeLineView({super.key});

  @override
  State<TimeLineView> createState() => _TimeLineViewState();
}

class _TimeLineViewState extends State<TimeLineView> {
  final BottomNavController controller = Get.put(BottomNavController());

  final TimePickerController timePickerController =
      Get.put(TimePickerController());
  NotificationService _notificationService = NotificationService();
 
  
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
          Row(
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
                    horizontal: 16,
                    vertical: 8), // Add padding inside the container
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
                    border:
                        InputBorder.none, // Removes default TextField border
                    hintText: 'Enter your text here',
                    // Placeholder text
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400), // Hint text styling
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
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
                      onTap: () =>
                          timePickerController.meetingSetter(context, true),
                      child: Container(
                          child: Text(
                              timePickerController.startTime.value.isEmpty
                                  ? 'select time'
                                  : timePickerController.startTime.value)));
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // End Time Row
          Row(
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
                      onTap: () =>
                          timePickerController.meetingSetter(context, false),
                      child: Container(
                          child: Text(timePickerController.endTime.value.isEmpty
                              ? 'select time'
                              : timePickerController.endTime.value)));
                }),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Confirm and Delete Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  timePickerController.addMeeting(
                      timePickerController.remarkController.value.text,
                      timePickerController.startTime.value,
                      timePickerController.endTime.value);
                  (
                    id: 1,
                    title: 'Test Notification',
                    body: 'This is a test notification sent immediately.',
                  );
                },
                child: const Text('Confirm'),
              ),
              ElevatedButton(
                onPressed: timePickerController.clearTimes,
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const Positioned(
          top: 50,
          left: 50,
          child: Text(
            'Scheduled  Meetings',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        //  Positioned(child: child),
        Positioned(
          top: 100,
          left: 20,
          child: SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              width: MediaQuery.of(context).size.width - 40,
              child: Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: timePickerController.meeting.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final meeting = timePickerController.meeting[index];
                      return Column(children: [
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const Icon(Icons.circle,
                                      size: 12, color: Colors.blue),
                                  if (index !=
                                      timePickerController.meeting.length -
                                          1) // Show the line except for the last item
                                    Container(
                                      width: 2,
                                      height: 250,
                                      color: Colors.blue,
                                    ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
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
                                            timePickerController
                                                .deleteMeeting(index);
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
                                        icon: const Icon(
                                            Icons.more_vert), // Three dots icon
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                color: Color.fromARGB(
                                                    255, 39, 36, 36)),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Details : ${meeting['details']!}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 26, 25, 25)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                            ])
                      ]);
                    },
                  ),
                );
              })),
        ),
        Positioned(
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
                    color: const Color.fromRGBO(220, 245, 173,
                        0.6), //background: rgba(220, 245, 173, 0.6);

                    borderRadius: BorderRadius.circular(70),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(imageItems.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          controller
                              .changeIndex(index); // Update selected index
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          // padding: const EdgeInsets.all(5), // Space between the icons
                          decoration: BoxDecoration(
                              shape: BoxShape
                                  .circle, // Circular shape for each icon
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
        ),
        Positioned(
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
        )
      ]),
    );
  }
}


// class BottomNavController extends GetxController {
//   var selectedIndex = 0
//       .obs; //observable index for // Observable index for the currently selected tab
//   void changeIndex(int index) {
//     selectedIndex.value = index;
//     switch (index) {
//       case 0:
//         Get.toNamed(Routes.HOMEPAGE);
//         break;
//       case 1:
//         Get.toNamed(Routes.TIMELINE);
//         break;

//       //   Get.offAllNamed('/itView');
//       //   break;
//       default:
//         Get.toNamed(Routes.HOMEPAGE);

//         break;
//     }
//   }
// }
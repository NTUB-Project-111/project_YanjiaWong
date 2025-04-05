import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../tabs.dart';
import '../../feature/database.dart';

class ResultPage6 extends StatefulWidget {
  final String woundType;
  const ResultPage6({super.key, required this.woundType});

  @override
  State<ResultPage6> createState() => _ResultPage6State();
}

class _ResultPage6State extends State<ResultPage6> {
  void _saveRecord() async {
    String? userId = await DatabaseHelper.getUserId();
    if (userId != null && userId.isNotEmpty) {
      // 建立部位+反應的字串
      final details = [
        DatabaseHelper.record['part']?.toString(),
        DatabaseHelper.record['rection']?.toString(),
      ].where((e) => e != null && e.trim().isNotEmpty).toList();

      final tags = details.join(', ');

      // 儲存記錄
      await DatabaseHelper.addRecord(
        userId,
        DatabaseHelper.record['date'].toString(),
        DatabaseHelper.record['image'],
        DatabaseHelper.record['type'].toString(),
        DatabaseHelper.record['oktime'].toString(),
        DatabaseHelper.record['caremode'].toString(),
        DatabaseHelper.record['ifcall'].toString(),
        tags,
        DatabaseHelper.record['recording'].toString(),
      );
      // print(userId);
      // print(DatabaseHelper.calls['day']);
      // print(DatabaseHelper.calls['time']);

      await DatabaseHelper.addRemind(
        userId,
        DatabaseHelper.calls['day'].toString(),
        DatabaseHelper.calls['time'].toString(),
      );
      Fluttertoast.showToast(
        msg: "儲存成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 106, 216, 110),
        textColor: const Color.fromARGB(255, 38, 82, 40),
        fontSize: 16.0,
      );

      Navigator.push(context, MaterialPageRoute(builder: (context) => const Tabs()));
    } else {
      Fluttertoast.showToast(
        msg: "無法獲取使用者 ID，請稍後再試",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 22),
      child: widget.woundType != "無異常"
          ? Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const Tabs()));
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(
                        color: Color(0xFF589399),
                        width: 2,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '不儲存報告',
                      style: TextStyle(
                        color: Color(0xFF589399),
                        fontSize: 16,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _saveRecord();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF589399),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '儲存報告',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        // fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const Tabs()));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF589399),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '確定',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        // fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

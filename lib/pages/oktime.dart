

// import 'package:flutter/material.dart';
// import '../feature/healingtime.dart';

// class oktimePage extends StatefulWidget {
//   const oktimePage({super.key});

//   @override
//   State<oktimePage> createState() => _oktimePageState();
// }

// class _oktimePageState extends State<oktimePage> {
//   String _healingTime = "請點擊按鈕進行預測"; // 用來存 API 回傳的結果

//   void _calculateHealingTime() async {
//     setState(() {
//       _healingTime = "計算中...";
//     });

//     String woundType = "割傷";
//     String description = "我是一個20歲的女性，今天被剪刀弄傷，傷口長度約4分鐘";
//     String part = "手部";
//     String rection = "疼痛";
//     part = part != "" ? "傷口部位:$part" : "";
//     rection = rection != "" ? "傷口狀態:$rection" : "";
//     String result = await HealingTime.getOktime(woundType, part, rection, description);

//     setState(() {
//       _healingTime = result;
//     });

//     print("✅ API 回應: $result");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: _calculateHealingTime,
//               child: const Text("預測癒合時間"),
//             ),
//             const SizedBox(height: 20),
//             Text(
//               _healingTime,
//               style: const TextStyle(fontSize: 18),
//             ),
           
//           ],
//         ),
//       ),
//     );
//   }
// }

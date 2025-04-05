import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class DatabaseHelper {
  static const String baseUrl = "http://192.168.1.109:3000"; //放我的電腦IP 172.20.10.5 192.168.1.107
  // static final String userId;
  // static Map<String, dynamic> userInfo = {};
  static Map<String, dynamic> calls = {};
  static Map<String, dynamic> record = {};
  static Map<String, dynamic> userInfo = {};

  // 存儲 userId
  static Future<bool> saveUserId(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final url = Uri.parse('$baseUrl/saveUserId?email=$email');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String? userId = data['id']?.toString(); // 確保 userId 是字串或 null
        if (userId != null) {
          await prefs.setString('userId', userId);
          print('User ID 存儲成功: $userId');
          return true;
        }
      }
      print('無法獲取 User ID: ${response.statusCode} ${response.body}');
      return false;
    } catch (e) {
      print('請求錯誤: $e');
      return false;
    }
  }

  // 讀取 userId
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  // 清除 userId
  static Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
  }

  // 取得使用者資訊
  static Future<Map<String, dynamic>?> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print('無法獲取 User ID，跳過請求');
      return null;
    }

    final url = Uri.parse('$baseUrl/getUserInfo?id=$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('獲取使用者資料失敗: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('請求錯誤: $e');
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>?> getUserRecords() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print('無法獲取 User ID，跳過請求');
      return null;
    }

    final url = Uri.parse('$baseUrl/getUserRecord?id=$userId');
    try {
      final response = await http.get(url);
      // print(jsonDecode(response.body));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data['records'].cast<Map<String, dynamic>>();
      } else {
        print('獲取使用者資料失敗: ${response.statusCode} ${response.body}');
        return null;
      }
    } catch (e) {
      print('請求錯誤: $e');
      return null;
    }
  }

  /// 新增使用者
  static Future<bool> addUser(String name, String email, String password, String gender,
      String birthday, File photoFile) async {
    var uri = Uri.parse("$baseUrl/addUser");
    var request = http.MultipartRequest("POST", uri);

    // 添加文字參數
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['gender'] = gender;
    request.fields['birthday'] = birthday;

    // 添加圖片檔案
    var mimeType = lookupMimeType(photoFile.path) ?? "image/jpeg"; // 確保有 MIME 類型
    var multipartFile = await http.MultipartFile.fromPath(
      'photo', // 這個 key 要跟後端 API 參數名稱一致
      photoFile.path,
      contentType: MediaType.parse(mimeType),
    );

    request.files.add(multipartFile);

    // 發送請求
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return true;
    } else {
      print("上傳失敗: ${response.body}"); // 記錄錯誤資訊
      return false;
    }
  }

  /// 新增診斷紀錄（含圖片）
  static Future<bool> addRecord(
      String fkRecordId,
      String date,
      File photoFile, // 修改為 File 類型，確保可以讀取圖片檔案
      String type,
      String oktime,
      String caremode,
      String ifcall,
      String choosekind,
      String recording) async {
    var uri = Uri.parse("$baseUrl/addRecord");
    var request = http.MultipartRequest("POST", uri);

    // 添加文字參數
    request.fields['fk_record_id'] = fkRecordId;
    request.fields['date'] = date;
    request.fields['type'] = type;
    request.fields['oktime'] = oktime;
    request.fields['caremode'] = caremode;
    request.fields['ifcall'] = ifcall;
    request.fields['choosekind'] = choosekind;
    request.fields['recording'] = recording;

    // 添加圖片檔案
    var mimeType = lookupMimeType(photoFile.path) ?? "image/jpeg"; // 確保有 MIME 類型
    var multipartFile = await http.MultipartFile.fromPath(
      'photo', // 這個 key 要跟後端 API 參數名稱一致
      photoFile.path,
      contentType: MediaType.parse(mimeType),
    );

    request.files.add(multipartFile);

    // 發送請求
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return true;
    } else {
      print("上傳失敗: ${response.body}"); // 記錄錯誤資訊
      return false;
    }
  }

  //護理提醒
  static Future<bool> addRemind(String fkRemindId, String day, String time) async {
    if (fkRemindId.isEmpty || day.isEmpty || time.isEmpty) {
      print("參數有空值: fkRemindId: $fkRemindId, day: $day, time: $time");
      return false;
    }
    print("fkRemindId: $fkRemindId, day: $day, time: $time");
    try {
      var uri = Uri.parse("$baseUrl/addRemind");
      var response = await http.post(
        uri,
        body: {
          'fk_calls_id': fkRemindId,
          'day': day,
          'time': time,
        },
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("上傳失敗: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("例外錯誤: $e");
      return false;
    }
  }

  /// 修改名稱
  static Future<bool> updateName(String userId, String name) async {
    final response = await http.post(
      Uri.parse("$baseUrl/updateName"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": userId, "name": name}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// 修改密碼
  static Future<bool> updatePassword(String userId, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/updatePassword"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"id": userId, "password": password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateImage(String userId, File image) async {
    try {
      var uri = Uri.parse("$baseUrl/updateImage");
      var request = http.MultipartRequest("POST", uri);
      request.fields['id'] = userId; // 添加使用者 ID
      var mimeType = lookupMimeType(image.path) ?? "image/jpeg"; // 確定 MIME 類型
      var multipartFile = await http.MultipartFile.fromPath(
        // 添加圖片檔案
        'image', // 這個 key 需要與後端 API `upload.single('image')` 一致
        image.path,
        contentType: MediaType.parse(mimeType),
      );
      request.files.add(multipartFile);
      var streamedResponse = await request.send(); // 發送請求
      var response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return true;
      } else {
        print("圖片更新失敗: ${response.body}");
        return false;
      }
    } catch (e) {
      print("圖片上傳發生錯誤: $e");
      return false;
    }
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:api_app/api/api_settings.dart';
import 'package:api_app/api/controllers/api_utils.dart';
import 'package:api_app/models/api_response.dart';
import 'package:api_app/models/student.dart';
import 'package:api_app/pref/shared_pref_controller.dart';
import 'package:http/http.dart' as http;

class AuthApiController extends ApiUtils{

 Future<ApiResponse> login(String email , String password) async {

   Uri uri = Uri.parse(ApiSettings.login);
   var response = await http.post(
       uri ,
       body: {"email":email , "password":password});
      if(response.statusCode == 200 || response.statusCode ==400) {
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Student student = Student.fromJson(jsonResponse['object']);
          await SharedPrefController().save(student);
        }
        return ApiResponse(jsonResponse['message'], jsonResponse['status']);
      }
      return ApiResponse('Something went wrong , try again !', false);  
 }


 Future<ApiResponse> logout() async {

   Uri uri = Uri.parse(ApiSettings.logout);
   var response = await http.get(uri, headers: headers);

   if(response.statusCode == 200 || response.statusCode == 401){
     //401 -> Unauthorized
     await SharedPrefController().clear();
     return ApiResponse("Logged out successfully" , true);
   }
   return ApiResponse("Something went wrong , try again!" , false);
 }


 Future<ApiResponse> register(String email , String password, String fullName, String gender) async {

   Uri uri = Uri.parse(ApiSettings.register);
   var response = await http.post(
       uri ,
       body: {"email":email , "password":password, "full_name": fullName, "gender": gender},
       headers: {
         HttpHeaders.acceptHeader: "application/json",
       },
   );
   if(response.statusCode == 200|| response.statusCode == 201 || response.statusCode ==400) {
     var jsonResponse = jsonDecode(response.body);
     if(response.statusCode == 200|| response.statusCode == 201){
       await SharedPrefController().saveRegister(fullName, email, password, gender);
       return ApiResponse(jsonResponse['message'],jsonResponse['status']);
     }
     return ApiResponse(jsonResponse['message'],jsonResponse['status']);
   }
   return ApiResponse('The email has already been taken', false);
 }


 /*Future<ApiResponse> me() async {

   Uri uri = Uri.parse(ApiSettings.logout);
   var response = await http.get(
       uri,
       headers: headers
   );
   if(response.statusCode == 200 || response.statusCode == 401){
     //401 -> Unauthorized
     await SharedPrefController().saveToken(authToken);
     return ApiResponse("Logged out successfully" , true);
   }
   return ApiResponse("Something went wrong , try again!" , false);
 }*/
}


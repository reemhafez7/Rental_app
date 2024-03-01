import 'dart:convert';
import 'dart:io';
import 'package:api_app/api/api_settings.dart';
import 'package:api_app/api/controllers/api_utils.dart';
import 'package:api_app/models/api_response.dart';
import 'package:api_app/models/student_image.dart';
import 'package:http/http.dart' as http;

class ImagesApiController extends ApiUtils{


  Future<ApiResponse<StudentImage>> uploadImage(String path) async {
    Uri uri = Uri.parse(ApiSettings.images.replaceFirst("/{id}", ""));
    var request = http.MultipartRequest("POST", uri);
    var imageFile = await http.MultipartFile.fromPath('image', path);
    request.files.add(imageFile);
    // request.fields["name"] = "value" ;
    //لو بدي ابعت نص
    request.headers[HttpHeaders.acceptHeader] =  "application/json";
    request.headers[HttpHeaders.authorizationHeader] = authToken;

    var response = await request.send();
    if (response.statusCode == 201 || response.statusCode == 400) {
      String body = await response.stream
          .transform(utf8.decoder).first;
      //decoder -> تحول البايتس ل سترنغ
      var jsonResponse = jsonDecode(body);
      var apiRespose = ApiResponse<StudentImage>(
          jsonResponse['message'], jsonResponse['status']);
      if (response.statusCode == 201) {
        StudentImage image = StudentImage.fromJson(jsonResponse['object']);
        apiRespose.object = image;
      }
      return apiRespose;
    }
    print(response.statusCode);
    return ApiResponse<StudentImage>(response.statusCode.toString(),false);

  }


  Future<List<StudentImage>> read() async {
    Uri uri = Uri.parse(ApiSettings.images.replaceFirst('/{id}',"") );
    var response = await http.get(uri, headers: headers);
   if(response.statusCode == 200){
     var jsonResponse = jsonDecode(response.body);
     var jsonArray = jsonResponse['data'] as List;
     return jsonArray
         .map((element) => StudentImage.fromJson(element))
         .toList();

   }
   return [];
  }

  Future<ApiResponse> delete(int id) async {
    Uri uri = Uri.parse(ApiSettings.images.replaceFirst("{id}", id.toString()));
    var response = await http.delete(uri,headers: headers);
    if(response.statusCode == 200){
      var jsonResponse = jsonDecode(response.body);
      return ApiResponse(jsonResponse['message'],jsonResponse['status']);
    }
    return ApiResponse("Something went wrong , try again!" , false);
  }

}
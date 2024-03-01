
import '../helper/api.dart';
import '../models/product_model.dart';

class CategoryService{

  Future<List<ProductModel>> getCategoryProducts({required String categoryName}) async{
      List<dynamic>data= await Api().get(url: 'https://fakestoreapi.com/products/category/$categoryName');

      List<ProductModel> productList = [];
      for (int i = 0; i < data.length; i++) {
        productList.add(ProductModel.fromJason(data[i]),);
      }
      return productList;

  }
}
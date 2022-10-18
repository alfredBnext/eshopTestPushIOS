//
//  ProductsView.swift
//  glup
//
//  Created by Bnext mobile on 14/06/22.
//

import SwiftUI
import Evergage

struct ProductsView: View {
    let categoryId: Int?
    var category: CategoryModel?
    var products: [ProductModel] = []
//    let evgContext: String
    
    init(categoryId: Int? = nil){
        self.categoryId = categoryId
        self.category = initialAction()
        self.products = (category != nil && category?.products != nil) ? category!.products! : []
//        var evgContext = Evergage.sharedInstance().globalContext!
    }
    
    func initialAction() -> CategoryModel? {
        if categoryId != nil {
            return Globals.Categories.first(where: {$0.id == categoryId}).self
        }else{
            return nil
        }
    }
    
    var body: some View {
        VStack{
            ForEach(products, id: \.id) { product in
                Button(product.name ?? "") {
                    print(product.name! + " \(product.price!)")
                    Evergage.sharedInstance().globalContext?.viewItem(EVGProduct.init(id: String(product.id!)))
                }
            }
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView()
    }
}

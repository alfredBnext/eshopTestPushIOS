//
//  CategoryModel.swift
//  glup
//
//  Created by Bnext mobile on 13/06/22.
//

import Foundation

public class CategoryModel : BaseModel{
    var products: [ProductModel]?
    
    convenience init(id: Int? = nil, name: String? = nil, products: [ProductModel]? = nil){
        self.init(id: id, name: name)
        self.products = products
    }
}

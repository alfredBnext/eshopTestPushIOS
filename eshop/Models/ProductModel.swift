//
//  ProductModel.swift
//  glup
//
//  Created by Bnext mobile on 13/06/22.
//

import Foundation

public class ProductModel : BaseModel{
    var price: Double?
    
    convenience init(id: Int? = nil, name: String? = nil, price: Double? = nil){
        self.init(id: id, name: name)
        self.price = price
    }
}

//
//  BaseModel.swift
//  glup
//
//  Created by Bnext mobile on 13/06/22.
//

import Foundation

public class BaseModel{
    var id: Int?
    var name: String?
    
    init(id:Int? = nil, name:String? = nil){
        self.id = id;
        self.name = name;
    }
    
}

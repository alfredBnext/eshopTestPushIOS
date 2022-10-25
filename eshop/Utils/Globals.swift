//
//  Globals.swift
//  glup
//
//  Created by Bnext mobile on 13/06/22.
//

import Foundation

public struct Globals{
    public static let Account = "heinekenintlamer"
    public static let Dateset = "development"
    
    public static let Categories: [CategoryModel] = [
        CategoryModel(id: 1, name: "Cerveza", products: [
            ProductModel(id: 1, name: "Tecate 355ml", price: 15.0),
            ProductModel(id: 2, name: "Tecate Light 355ml", price: 15.0),
            ProductModel(id: 3, name: "Amstel Ultra 355ml", price: 20.0)
        ]),
        CategoryModel(id: 2, name: "Botana", products: [
            ProductModel(id: 4, name: "Doritos Icognita 55g", price: 10.0),
            ProductModel(id: 5, name: "Doritos Nacho 55g", price: 10.0),
            ProductModel(id: 6, name: "Doritos Flaiming Hot 55g", price: 10.0),
            ProductModel(id: 7, name: "DoritosnDIABLO 55G", price: 10.0)
        ]),
        CategoryModel(id: 3, name: "Licor", products: [
            ProductModel(id: 8, name: "Johnnie Walker Black Label 750ml", price: 737.0),
            ProductModel(id: 9, name: "Tequila Maestro Dobel Diamante 700ml", price: 765.0),
            ProductModel(id: 10, name: "Mezcal 400 Conejos Jocen 750ml", price: 535.0)
        ]),
        CategoryModel(id: 4, name: "Refresco", products: [
            ProductModel(id: 11, name: "Manzanita Lift Golden", price: 8),
            ProductModel(id: 12, name: "Pepsi Blue", price: 5),
            ProductModel(id: 13, name: "Kas de toronja", price: 8),
            ProductModel(id: 14, name: "Delawere punch", price: 15)
        ])
    ]
}

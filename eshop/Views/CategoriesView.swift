//
//  CategoriesView.swift
//  glup
//
//  Created by Bnext mobile on 13/06/22.
//

import SwiftUI

struct CategoriesView: View {
    var body: some View {
        VStack{
            NavigationLink(destination: ProductsView(categoryId: 1)) {
                Text("Cerveza")
            }
            NavigationLink(destination: ProductsView(categoryId: 2)) {
                Text("Botana")
            }
            NavigationLink(destination: ProductsView(categoryId: 3)) {
                Text("Licor")
            }
            NavigationLink(destination: ProductsView(categoryId: 4)) {
                Text("Refresco")
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}

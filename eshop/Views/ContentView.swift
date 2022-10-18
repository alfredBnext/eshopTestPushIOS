//
//  ContentView.swift
//  glup
//
//  Created by Bnext mobile on 13/06/22.
//

import SwiftUI
import Evergage
import AppTrackingTransparency

struct ContentView: View {
    @State private var searchText: String = ""
    
    init(){
    }
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationLink(destination: CategoriesView()) {
                    Text("CATEGORIA")
                }
                HStack {
                    TextField(
                        "Buscar",
                        text: $searchText
                    ).onSubmit {
                        print("Busco: \(searchText)")
                    }.padding()
                }
                Button(action: {
                    let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
                    print(fcmToken!)
                    UIPasteboard.general.string = fcmToken!
                }, label: {
                    Text("copiar Firebase")
                })
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

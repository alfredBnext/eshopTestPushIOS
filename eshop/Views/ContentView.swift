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
    @State var searchText: String = "GLP484|"
    
    init(){
        let evergageId = UserDefaults.standard.string(forKey: "EvergageId");
        
        if (!(evergageId ?? "").isEmpty){
            _searchText = State(initialValue: evergageId!);
        }
    }
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    TextField(
                        "Evergage user id | Marketing contact key",
                        text: $searchText
                    ).onSubmit {//searchText
                        UserDefaults.standard.set(searchText, forKey: "EvergageId")
                        print(UserDefaults.standard.string(forKey: "EvergageId")!)
                    }.padding()
                }
                Button(action: {
                    let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
                    print(fcmToken!)
                    UIPasteboard.general.string = fcmToken!
                }, label: {
                    Text("copy Firebase Id")
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

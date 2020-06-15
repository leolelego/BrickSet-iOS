//
//  SetsListView.swift
//  BrickSet
//
//  Created by Work on 18/05/2020.
//  Copyright © 2020 Homework. All rights reserved.
//

import SwiftUI

struct SetsListView: View {
    var items : [LegoSet]
    @EnvironmentObject private var  collection : UserCollection
    
    var body: some View {
        
        Group {
            
            if items.count == 0 {
                Spacer()
                
                HStack(alignment: .center){
                    Spacer()
                    if collection.isLoadingData {
                        ActivityIndicator(isAnimating: .constant(true), style: .large)
                    } else {
                        Text("sets.noitems").font(.largeTitle).bold()

                    }
                    Spacer()
                }
                if collection.sets.filter({$0.collection.owned}).count == 0 {
                    HStack(alignment: .center){
                        Spacer()
                        Text("sets.firstsync").multilineTextAlignment(.center).font(.subheadline)
                        Spacer()
                    }
                }
                
            } else {
                
                if Configuration.isDebug{
                    HStack{
                        Spacer()
                        Text(String(items.count)).roundText
                        Spacer()
                    }
                }
                ForEach(sections(for:  items ), id: \.self){ theme in
                    Section(header:
                        Text(theme).roundText
                            .padding(.leading, -12)
                            .padding(.bottom, -28)
                    ) {
                        ForEach(self.items(for: theme, items: self.items ), id: \.setID) { item in
                            NavigationLink(destination: SetDetailView(set: item)) {
                                SetListCell(set:item)
                            }
                        }
                        
                        
                    }
                }
            }
            
        }
    }
    
    func sections(for items:[LegoSet]) -> [String] {
        return Array(Set(items.compactMap({$0.theme}))).sorted()
    }
    func items(for section:String,items:[LegoSet]) -> [LegoSet] {
        return items.filter({$0.theme == section})
            .sorted(by: {
                $0.subtheme ?? "" < $1.subtheme ?? ""
            && $0.name < $1.name}
        )
    }
}

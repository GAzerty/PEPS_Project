//
//  RemarkRowView.swift
//  PEPSProject
//
//  Created by user164567 on 2/26/20.
//  Copyright © 2020 user164567. All rights reserved.
//

import SwiftUI

struct RemarkRowView: View {
    
    @ObservedObject var remark: Remark
    @State var isShown: Bool = false
    @State var isShown2: Bool = false
    var isUserRemarks : Bool!
    var body: some View {
        
        VStack{
            HStack{
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "person")
                        Text("\(remark.user.pseudo ?? "pseudo")")
                        Spacer()
                        Text("\(remark.getDateFormat(format: "fr_FR"))")
                    }
                    HStack{
                        Image(systemName: "mappin")
                        Text("\(self.remark.location)")
                    }
                }
            }.padding(10)
            Divider()
            HStack{
                Text("\(remark.remark)")
            }.padding(10)
            Divider()
            
            HStack{
                
                HStack{
                    Text("\(remark.answerSet.answerSet.count)")
                    Image(systemName: "message").foregroundColor(.blue)
                }.onTapGesture {
                    self.isShown.toggle()
                }.sheet(isPresented: self.$isShown){
                    ReadRemarkView(remark: self.remark,isPresentend: self.$isShown)
                }
                if(self.isUserRemarks){
                    Spacer()
                    Image(systemName: "square.and.pencil").foregroundColor(.green).onTapGesture {
                        self.isShown2.toggle()
                    }.sheet(isPresented: self.$isShown2){
                        CreateRemarkView(isPresented: self.$isShown2, remark: self.remark.remark, location: self.remark.location, isUpdateView: true, remarkUpdated: self.remark)
                    }
                    Spacer()
                    Image(systemName: "trash").foregroundColor(.red).onTapGesture {
                        if RemarkQueryService().deleteRemark(idRemark: self.remark.idRemark){
                            print("deleted remark")
                        }
                    }
                    Spacer()
                }else{
                    Spacer()
                }
                HStack{
                    Text("\(remark.nbEncounter)")
                    Image(systemName: "volume")
                }.onTapGesture {
                    if(UserQueryService().isLogged()){
                        if !RemarkQueryService().addEncounter(remark: self.remark){
                            if RemarkQueryService().removeEncounter(remark: self.remark){
                            }
                        }
                    }
                }
            }.padding(10.0)
            
        }.background(Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0))).cornerRadius(15).padding(10).shadow(color: .gray, radius: 3, x: 1, y: 1)
    }
    
}


/*struct RemarkRowView_Previews: PreviewProvider {
    static var previews: some View {
        RemarkRowView(remark: <#Remark#>)
    }
}*/

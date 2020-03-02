//
//  RemarkQueryService.swift
//  PEPSProject
//
//  Created by user164567 on 2/27/20.
//  Copyright © 2020 user164567. All rights reserved.
//

import Foundation


class RemarkQueryService {
    
    func getAllRemarks() -> [Remark]{
        
        var remarkSet : [Remark] = [Remark]()
        var responseDataOpt : [String: Any]?
        
        responseDataOpt = QueryService().request(url: "https://web-ios-api.herokuapp.com/remarks/", httpMethod: "GET", httpBody: nil)
        
        if let responseData = responseDataOpt{
            
            if let dataT = responseData["data"] as? [Any]{
                for remark in dataT{
                    if let newRemark = remark as? [String:Any]{
                        let idRemark = newRemark["idRemark"] as! Int
                        let remark = newRemark["remark"] as! String
                        let idCategory = newRemark["idCategory"] as! Int
                        let idUser = newRemark["idUser"] as! Int
                        let dateCreation = newRemark["dateCreation"] as! String
                        
                        let array = dateCreation.components(separatedBy: "T")
                        let formater = ISO8601DateFormatter()
                        let dateFormat = array[0]+"T00:00:00Z"
                        let date = formater.date(from: dateFormat)
                              
                        
                        
                        let location = newRemark["location"] as! String
                        let nbEncounter = RemarkQueryService().getNbEncounter(idRemark: idRemark)
                        let answerSet = AnswerSet()
                        answerSet.addAnswers(answerTab: RemarkQueryService().getAllRemarksAnswer(idRemark: idRemark))
                        
                        if let u : User = UserQueryService().getUserById(idUser: idUser){
                            if let date = date {
                                
                                let r = Remark(idRemark: idRemark, remark: remark, idCategory: idCategory, user: u, answerSet: answerSet, location: location, date: date, nbEncounter: nbEncounter)
                                
                                remarkSet.append(r)
                            }
                            
                        }
                        
                    }
                }
            }
        }
        return remarkSet
    }
    
    
    
    func getAllRemarksAnswer(idRemark: Int) -> [Answer]{
        
        var answerSet : [Answer] = [Answer]()
        var responseDataOpt : [String: Any]?
        
        responseDataOpt = QueryService().request(url: "https://web-ios-api.herokuapp.com/remarks/"+String(idRemark)+"/answers", httpMethod: "GET", httpBody: nil)
        
        if let responseData = responseDataOpt{
            if let dataT = responseData["data"] as? [Any]{
                for answer in dataT{
                    if let newAnswer = answer as? [String: Any]{
                        let idAnswer = newAnswer["idAnswer"] as! Int
                        let answer = newAnswer["answer"] as! String
                        let idCategory = newAnswer["idCategory"] as! Int
                        let idUser = newAnswer["idUser"] as! Int
                        
                        
                        if let category = CategoryQueryService().getCategoryById(idCategory:idCategory){
                            if let user = UserQueryService().getUserById(idUser: idUser){
                                let answ = Answer(idAnswer: idAnswer, answer: answer, category: category, user: user)
                                answerSet.append(answ)
                            }
                        }
                    }
                }
            }
        }
        
        return answerSet
    }
    
    
    func getNbEncounter(idRemark: Int) -> Int {
        
        
        var encounter : Int = 0
        
        var responseDataOpt : [String: Any]?
        
        responseDataOpt = QueryService().request(url: "https://web-ios-api.herokuapp.com/remarks/"+String(idRemark)+"/encounter", httpMethod: "GET", httpBody: nil)
        
        if let responseData = responseDataOpt{
            //print(responseData)
            if let dataT = responseData["data"] as? [String: Any]{
                let count = dataT["count"] as! String
                encounter = Int(count) ?? 0
            }
        }
        return encounter
    }
    
    
}

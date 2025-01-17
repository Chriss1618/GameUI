//
//  Task.swift
//  GameUI
//
//  Created by Cristofor Doamre on 17/01/25.
//
import SwiftUI

struct Task :  Identifiable, Hashable{
    var id : UUID = .init()
    var title : String
    var status : Status
}
enum Status{
    case todo
    case woking
    case completed
    
}

//
//  Home.swift
//  GameUI
//
//  Created by Cristofor Doamre on 17/01/25.
//

import SwiftUI

struct Home : View {
    @State private var todo : [Task] = [
        .init(title: "Buy milk", status: .todo),
        .init(title: "Learn SwiftUI", status: .todo)
    ]
    @State private var working              : [Task ] = []
    @State private var completed            : [Task ] = []
    
    @State private var currentylDragging    : Task?
    
    var body: some View{
        HStack(spacing : 2){
            TodoView()
            
            WorkingView()
                
            CompletedView()
                
        }
    }
    
    @ViewBuilder
    func TaskView(_ tasks : [Task]) -> some View{
        VStack(alignment: .leading,spacing: 10){
            ForEach(tasks){ task in
                GeometryReader{
                    TaskRow(task, $0.size)
                }
                .frame(height: 45)
            }
        }.frame(maxWidth: .infinity)
            .padding()
    }
    
    @ViewBuilder
    func TaskRow( _ task : Task , _ size: CGSize) -> some View{
        Text(task.title)
            .padding(.horizontal,15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: size.height)
            .background(.white, in: .rect(cornerRadius: 10))
            .contentShape(.dragPreview, .rect(cornerRadius: 10))
            .draggable(task.id.uuidString){
                Text(task.title)
                    .padding(.horizontal,15)
                    .frame(width: size.width, height: size.height, alignment: .leading)
                    .background(.white)
                    .contentShape(.dragPreview, .rect(cornerRadius: 10))
                    .onAppear(){
                        currentylDragging = task
                    }
            }
            .dropDestination(for: String.self){ items, location in
                currentylDragging = nil
                return true
            } isTargeted: { status in
                if let currentylDragging, status, currentylDragging.id != task.id{
                    withAnimation(.snappy){
                        
                        switch task.status{
                        case .todo:
                            replaceItem(tasks: &todo, droppingTask: task, status: .todo)
                        case .woking :
                            replaceItem(tasks: &working, droppingTask: task, status: .woking)
                        case .completed:
                            replaceItem(tasks: &completed, droppingTask: task, status: .completed)
                        }
                        
                    }
                }
            }
    }
    
    func appendTask( _ status : Status ){
        if let currentylDragging{
            switch status {
            case .todo:
                if !todo.contains(where: { $0.id == currentylDragging.id}){
                    var updatedTask = currentylDragging
                    updatedTask.status = .todo
                    todo.append(updatedTask)
                    
                    working.removeAll(where: {$0.id == currentylDragging.id})
                    completed.removeAll(where: {$0.id == currentylDragging.id})
                }
            case .woking:
                if !working.contains(where: { $0.id == currentylDragging.id}){
                    var updatedTask = currentylDragging
                    updatedTask.status = .woking
                    working.append(updatedTask)
                    
                    todo.removeAll(where: {$0.id == currentylDragging.id})
                    completed.removeAll(where: {$0.id == currentylDragging.id})
                }
            case .completed:
                if !completed.contains(where: { $0.id == currentylDragging.id}){
                    var updatedTask = currentylDragging
                    updatedTask.status = .completed
                    completed.append(updatedTask)
                    
                    working.removeAll(where: {$0.id == currentylDragging.id})
                    todo.removeAll(where: {$0.id == currentylDragging.id})
                }
            }
        }
    }
    
    func replaceItem(tasks : inout [Task], droppingTask : Task, status : Status){
        if let currentylDragging{
            if let sourceIndex = tasks.firstIndex(where: { $0.id == currentylDragging.id}),
               let destinationIndex = tasks.firstIndex(where: { $0.id == droppingTask.id}){
                var sourceItem = tasks.remove(at: sourceIndex)
                sourceItem.status = status
                tasks.insert(sourceItem, at: destinationIndex)
            }
            
        }
    }
    @ViewBuilder
    func TodoView() -> some View{
        NavigationStack{
            ScrollView(.vertical){
                TaskView(todo)
            }.navigationTitle("Todo")
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .contentShape(.rect)
                .dropDestination(for : String.self) { items, location in
                    
                    withAnimation(.snappy){
                        appendTask(.todo)
                    }
                    
                    return true
                    
                } isTargeted: { _ in true
                    
                }
        }
    }
    @ViewBuilder
    func WorkingView() -> some View{
        NavigationStack{
            ScrollView(.vertical){
                TaskView(working)
            }.navigationTitle("Working")
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .contentShape(.rect)
                .dropDestination(for : String.self) { items, location in
                    
                    withAnimation(.snappy){
                        appendTask(.woking)
                    }
                    
                    return true
                    
                } isTargeted: { _ in true
                    
                }
        }
    }
    @ViewBuilder
    func CompletedView() -> some View{
        NavigationStack{
            ScrollView(.vertical){
                TaskView(completed)
            }.navigationTitle("Completed")
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.1))
                .contentShape(.rect)
                .dropDestination(for : String.self) { items, location in
                    
                    withAnimation(.snappy){
                        appendTask(.completed)
                    }
                    
                    return true
                    
                } isTargeted: { _ in true
                    
                }
        }
    }
}

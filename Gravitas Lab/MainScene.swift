//
//  MainScene.swift
//  Gravitas Lab
//
//  Created by Miro Pletscher on 23/02/25.
//

import SwiftUI
import SpriteKit

struct MainScene: View {
    @State private var animals = [
        Entity(name: "Elephant", weight: 7000, imageName: "elephant"),
        Entity(name: "Horse", weight: 500, imageName: "horse"),
        Entity(name: "Mouse", plural: "Mice", weight: 0.03, imageName: "mouse")
    ]
    
    @State var currentAnimal: Entity = Entity(name: "Elephant", weight: 7000, imageName: "elephant")
    
    @State private var objects = [
        Entity(name: "Rocket", weight: 500_000, imageName: "rocket"),
        Entity(name: "Car", weight: 1_500, imageName: "car")
    ]
    
    @State var currentObject: Entity = Entity(name: "Rocket", weight: 500_000, imageName: "rocket")
    
    var kilograms: Float {
        return Float(unitCount) * currentAnimal.weight
    }
    @State var unitCount: Double = 1
    @State var isEditing = false
    
    var scene: SKScene {
        let scene = SeesawScene()
        scene.size = CGSize(width: 400, height: 400)
        scene.scaleMode = .aspectFit
        scene.animalMass = kilograms
        scene.animalTexture = currentAnimal.imageName
        scene.objectMass = currentObject.weight
        scene.objectTexture = currentObject.imageName
        return scene
    }
    
    var body: some View {
        HStack {
            HStack {
                VStack {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 5, height: .infinity)
                        .padding(.leading, 30)
                }
                VStack(alignment: .leading) {
                    ForEach((1...10).reversed(), id: \.self) { index in
                        Text("\(index * 10)")
                        if index != 1 {
                            Spacer()
                        }
                    }
                }
            }
            Spacer()
            
            // SpriteKit View
            ZStack(alignment: .bottom) {
                SpriteView(scene: scene)
                    .id(currentAnimal.id)
                    .id(unitCount)
                    .id(currentObject.id)
                    .aspectRatio(contentMode: .fit)
                
                /*VStack {
                    ForEach((1...10), id: \.self) { index in
                        Divider()
                        if index != 10 {
                            Spacer()
                        }
                    }
                }*/
                HStack(spacing: 20){
                    VStack{
                        Text("Object")
                        HStack(spacing: 40) {
                            ForEach(objects.indices, id: \.self) { index in
                                VStack {
                                    Image(objects[index].imageName)
                                        .resizable()
                                        .frame(width: objects[index].isSelected ? 80 : 50, height: objects[index].isSelected ? 80 : 50)
                                }
                                .onTapGesture {
                                    withAnimation{
                                        for i in objects.indices {
                                            objects[i].isSelected = false
                                        }
                                        objects[index].isSelected = true
                                        currentObject = objects[index]
                                    }
                                }
                            }
                        }
                        .frame(width: 220, height: 120)
                        .background(.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
                    
                    VStack {
                        Text("Animal")
                        HStack(spacing: 60) {
                            ForEach(animals.indices, id: \.self) { index in
                                VStack {
                                    Image(animals[index].imageName)
                                        .resizable()
                                        .frame(width: animals[index].isSelected ? 80 : 50, height: animals[index].isSelected ? 80 : 50)
                                }
                                .onTapGesture {
                                    withAnimation{
                                        for i in animals.indices {
                                            animals[i].isSelected = false
                                        }
                                        animals[index].isSelected = true
                                        currentAnimal = animals[index]
                                    }
                                }
                            }
                        }
                        .frame(width: 400, height: 120)
                        .background(.white)
                        .cornerRadius(10)
                    .shadow(radius: 10)
                    }
                }
            }
            
            Spacer()
            VStack {
                Text(currentAnimal.getPlural())
                Spacer()
                Slider(value: $unitCount, in: 0...100, step: 1, onEditingChanged: { editing in
                    isEditing = editing
                })
                .frame(width: 570, height: 40)
                .rotationEffect(.degrees(-90))
                Spacer()
                Text("\(unitCount, specifier: "%.0f") \(unitCount > 1 || unitCount < 1 ? currentAnimal.getPlural() : currentAnimal.name)")
                    .padding()
                Text(String(kilograms.formatted(.number.grouping(.automatic))))
                Text(kilograms > 1 || kilograms < 1 ? "Kilograms" : "Kilogram")
            }
            .padding(.trailing, 30)
            .frame(width: 180)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            if currentAnimal == nil {
                animals[0].isSelected = true
                currentAnimal = animals[0]
            }
            
            AudioManager.shared.playBackgroundMusic()
        }
    }
}

#Preview {
    MainScene()
}

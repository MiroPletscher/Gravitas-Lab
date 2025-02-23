//
//  SeesawScene.swift
//  Gravitas Lab
//
//  Created by Miro Pletscher on 23/02/25.
//

import SpriteKit

class SeesawScene: SKScene {
    var objectMass: Float = 500_000
    var objectTexture: String = "rocket"
    
    // Animal
    var animalMass: Float = 6000.0
    var animalTexture: String = "elephant"
    
    override func didMove(to view: SKView) {
        view.showsPhysics = true
        view.preferredFramesPerSecond = 60
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        // Set up the background to cover the whole screen
        self.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        addFullScreenBackground(view: view)
        
        // Set the scene's physics body to define its boundaries
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = 1
        physicsBody?.collisionBitMask = 1
        physicsBody?.contactTestBitMask = 1

        // Add the seesaw components
        addSeesaw()
        
        // Object (Animal)
        if animalMass > 0{
            let objectPosition = CGPoint(x: size.width / 2 + 130, y: size.height / 2 + 50)
            addWeightedObject(at: objectPosition, mass: CGFloat(animalMass), texture: animalTexture)
        }
        
        // Rocket
        let object2Position = CGPoint(x: size.width / 2 - 130, y: size.height / 2)
        addWeightedObject(at: object2Position, mass: CGFloat(objectMass), texture: objectTexture)

        // Attach the horizontal line to the rocket
        addHorizontalLineToRocket()
    }

    func addFullScreenBackground(view: SKView) {
        let background = SKSpriteNode(color: UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0), size: CGSize(width: view.bounds.width, height: view.bounds.height))
        background.position = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        background.zPosition = -1 // Ensure it stays behind everything
        addChild(background)
    }

    func addSeesaw() {
        let plank = SKSpriteNode(color: .brown, size: CGSize(width: 350, height: 20))
        plank.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        plank.physicsBody = SKPhysicsBody(rectangleOf: plank.size)
        plank.physicsBody?.isDynamic = true
        plank.physicsBody?.categoryBitMask = 2
        plank.physicsBody?.collisionBitMask = 1 | 2
        plank.physicsBody?.contactTestBitMask = 1
        plank.physicsBody?.mass = 500
        plank.physicsBody?.density = 5
        plank.physicsBody?.restitution = 0.1
        plank.physicsBody?.friction = 1.0
        
        let minRotation = CGFloat(-25).degreesToRadians()
        let maxRotation = CGFloat(25).degreesToRadians()
        let rotationRange = SKRange(lowerLimit: minRotation, upperLimit: maxRotation)
        plank.constraints = [SKConstraint.zRotation(rotationRange)]

        let fulcrum = SKSpriteNode(color: .gray, size: CGSize(width: 20, height: 20))
        fulcrum.position = plank.position
        fulcrum.physicsBody = SKPhysicsBody(rectangleOf: fulcrum.size)
        fulcrum.physicsBody?.isDynamic = false
        fulcrum.physicsBody?.categoryBitMask = 3
        fulcrum.physicsBody?.collisionBitMask = 3
        fulcrum.physicsBody?.contactTestBitMask = 3

        addChild(plank)
        addChild(fulcrum)

        let joint = SKPhysicsJointPin.joint(
            withBodyA: plank.physicsBody!,
            bodyB: fulcrum.physicsBody!,
            anchor: fulcrum.position
        )
        joint.shouldEnableLimits = true
        joint.lowerAngleLimit = -0  // Limits movement (-22.5 degrees)
        joint.upperAngleLimit = .pi / 8   // Limits movement (+22.5 degrees)

        physicsWorld.add(joint)

    }

    func addWeightedObject(at position: CGPoint, mass: CGFloat, texture: String) {
        let weightTexture = SKTexture(imageNamed: texture)
        let objectSize = mass >= 200_000 ? mass / 10_000 : 20
        let weight = SKSpriteNode(texture: weightTexture, size: CGSize(width: objectSize, height: objectSize))
        weight.position = position
        weight.name = texture // Assign a name for tracking (e.g., "rocket")
        weight.physicsBody = SKPhysicsBody(rectangleOf: weight.size)
        weight.physicsBody?.isDynamic = true
        weight.physicsBody?.usesPreciseCollisionDetection = true
        weight.physicsBody?.mass = mass
        weight.physicsBody?.categoryBitMask = 1
        weight.physicsBody?.collisionBitMask = 1 | 2
        weight.physicsBody?.contactTestBitMask = 2
        weight.physicsBody?.density = 10
        weight.physicsBody?.velocity.dx = 0
        weight.physicsBody?.restitution = 0
        weight.physicsBody?.allowsRotation = false
        
        let xRange = SKConstraint.positionX(SKRange(constantValue: position.x))
        weight.constraints = [xRange]
        
        addChild(weight)
    }

    // 🔹 Function to create a horizontal line above the rocket
    func addHorizontalLineToRocket() {
        if let heavyObject = childNode(withName: objectTexture){
            let linePath = UIBezierPath()
            let lineHeight: CGFloat = heavyObject.frame.maxY + 50 // Fixed height above rocket
            let lineWidth: CGFloat = 100 // Adjustable length

            let startX = heavyObject.position.x - lineWidth / 2
            let endX = heavyObject.position.x + lineWidth / 2
            
            linePath.move(to: CGPoint(x: startX, y: lineHeight))
            linePath.addLine(to: CGPoint(x: endX, y: lineHeight))
            
            let line = SKShapeNode(path: linePath.cgPath)
            line.strokeColor = .black
            line.lineWidth = 2
            line.name = "horizontalLineToRocket" // For updating later
            
            addChild(line)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Find the rocket
        if let heavyObject = childNode(withName: objectTexture){
            
            // Remove existing dashed line to avoid duplicates
            childNode(withName: "horizontalLineToRocket")?.removeFromParent()
            
            let lineHeight: CGFloat = heavyObject.frame.maxY // Align with rocket top
            let startX: CGFloat = 0  // Starts at the left edge
            let endX: CGFloat = size.width // Stops at rocket's tip
            
            let dashWidth: CGFloat = 10
            let dashSpacing: CGFloat = 5
            
            let dashedLineNode = SKNode()
            dashedLineNode.name = "horizontalLineToRocket"
            
            var currentX = startX
            
            while currentX + dashWidth < endX {
                let dashSegment = SKSpriteNode(color: .gray, size: CGSize(width: dashWidth, height: 1)) // Adjust thickness here
                dashSegment.position = CGPoint(x: currentX + dashWidth / 2, y: lineHeight)
                dashedLineNode.addChild(dashSegment)
                currentX += dashWidth + dashSpacing
            }
            
            addChild(dashedLineNode)
        }
    }
}

struct Entity: Identifiable {
    let id = UUID()
    let name: String
    let plural: String?
    let weight: Float
    let imageName: String
    var isSelected: Bool = false
    
    init(name: String, plural: String? = nil, weight: Float, imageName: String) {
        self.name = name
        self.plural = plural
        self.weight = weight
        self.imageName = imageName
    }
    
    func getPlural() -> String {
        if let pluralForm = plural {
            return pluralForm
        } else {
            return "\(name)s"
        }
    }
}

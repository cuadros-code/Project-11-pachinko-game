import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        
        let width = frame.size.width
        let height = frame.size.height
        
        // Background
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: width / 2.0, y: height / 2.0)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Border limits
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        // From SKPhysicsContactDelegate
        physicsWorld.contactDelegate = self
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 211, y: 0))
        makeBouncer(at: CGPoint(x: 422, y: 0))
        makeBouncer(at: CGPoint(x: 633, y: 0))
        makeBouncer(at: CGPoint(x: 844, y: 0))
        
        makeSlot(at: CGPoint(x: 105, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 315, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 527, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 737, y: 0), isGood: false)
    }
    
    // Check ball collision on the other objects
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if contact.bodyA.node?.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if contact.bodyB.node?.name == "ball"{
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.position = location
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 1 // bounciness
            // Notify every collition
            ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
            ball.name = "ball"
            addChild(ball)
        }
    }
    
    func makeBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        spinAnimation(slotGlow)
    }
    
    func spinAnimation(_ slotGlow: SKSpriteNode){
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
    }
    
    func collisionBetween(ball: SKNode, object: SKNode){
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }
    
    func destroy(ball: SKNode){
        ball.removeFromParent()
    }
    
    
    
}

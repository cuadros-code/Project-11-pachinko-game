import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editMode: Bool = false {
        didSet {
            if editMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        let width = frame.size.width
        let height = frame.size.height
        
        // Background
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: width / 2.0, y: height / 2.0)
        background.blendMode = .replace
        background.zPosition = -2
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
        
        addLabelScore()
    }
    
    func addLabelScore(){
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 824, y: 350)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.fontSize = 20
        editLabel.position = CGPoint(x: 60, y: 350)
        addChild(editLabel)
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
            
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editMode.toggle()
                return
            }
            
            if editMode {
                makeBox(location: location)
            } else {
                makeBall(location: location)
            }
            
            
        }
    }
    
    func makeBall(location: CGPoint){
        let balls = ["ballRed", "ballBlue", "ballCyan", "ballGreen", "ballGrey", "ballPurple", "ballYellow"]
        let ball = SKSpriteNode(imageNamed: balls.randomElement() ?? balls[0])
        ball.position = location
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
       
        // Bounciness
        ball.physicsBody?.restitution = 1
        
        // Notify every collitions
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        ball.name = "ball"
        addChild(ball)
    }
    
    func makeBox(location: CGPoint){
        let size = CGSize(width: Int.random(in: 16...90), height: 14)
        let box = SKSpriteNode(color: UIColor(
            red: CGFloat.random(in: 0...1),
            green: CGFloat.random(in: 0...1),
            blue: CGFloat.random(in: 0...1),
            alpha: 1
        ), size: size)
        
        box.zRotation = CGFloat.random(in: 0...3)
        box.position = location
        box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
        box.physicsBody?.isDynamic = false
        addChild(box)
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
        slotGlow.zPosition = -1
        
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
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode){
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"){
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    
    
}

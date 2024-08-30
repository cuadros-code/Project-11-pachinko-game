import SpriteKit

class GameScene: SKScene {
    
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
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 211, y: 0))
        makeBouncer(at: CGPoint(x: 422, y: 0))
        makeBouncer(at: CGPoint(x: 633, y: 0))
        makeBouncer(at: CGPoint(x: 844, y: 0))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let ball = SKSpriteNode(imageNamed: "ballRed")
            ball.position = location
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.4 // bounciness
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
    
}

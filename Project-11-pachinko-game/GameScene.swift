import SpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 422, y: 195)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        // Border limits
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
            box.position = location
            box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
            addChild(box)
        }
    }
    
}

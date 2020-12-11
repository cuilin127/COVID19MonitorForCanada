//
//  ChartScene.swift
//  Covid19Canada
//
//  Created by Lin Cui on 2020-11-20.
//

import UIKit
import SpriteKit

class ChartScene: SKScene {
    var values : [Int]?
    
    
    var shapeLine1 = SKShapeNode()
    
    var circle = SKShapeNode(circleOfRadius: 15)
    var shapeLine2 = SKSpriteNode()
    var numberLabel = SKLabelNode()
    var dateLabel = SKLabelNode()
    
    var line1000 = SKSpriteNode()
    var line2000 = SKSpriteNode()
    var line3000 = SKSpriteNode()
    var line4000 = SKSpriteNode()
    var line5000 = SKSpriteNode()
    var line6000 = SKSpriteNode()
    var line7000 = SKSpriteNode()
    var label1000 = SKLabelNode()
    var label2000 = SKLabelNode()
    var label3000 = SKLabelNode()
    var label4000 = SKLabelNode()
    var label5000 = SKLabelNode()
    var label6000 = SKLabelNode()
    var label7000 = SKLabelNode()
    override func didMove(to view: SKView) {
        
        shapeLine2 = self.childNode(withName: "shapeLine2") as? SKSpriteNode ?? SKSpriteNode()
        numberLabel = self.childNode(withName: "numberLabel") as? SKLabelNode ?? SKLabelNode()
        dateLabel = self.childNode(withName: "dateLabel") as? SKLabelNode ?? SKLabelNode()
        
        label1000 = self.childNode(withName: "label1000") as? SKLabelNode ?? SKLabelNode()
        label2000 = self.childNode(withName: "label2000") as? SKLabelNode ?? SKLabelNode()
        label3000 = self.childNode(withName: "label3000") as? SKLabelNode ?? SKLabelNode()
        label4000 = self.childNode(withName: "label4000") as? SKLabelNode ?? SKLabelNode()
        label5000 = self.childNode(withName: "label5000") as? SKLabelNode ?? SKLabelNode()
        label6000 = self.childNode(withName: "label6000") as? SKLabelNode ?? SKLabelNode()
        label7000 = self.childNode(withName: "label7000") as? SKLabelNode ?? SKLabelNode()
        
        line1000 = self.childNode(withName: "line1000") as? SKSpriteNode ?? SKSpriteNode()
        line2000 = self.childNode(withName: "line2000") as? SKSpriteNode ?? SKSpriteNode()
        line3000 = self.childNode(withName: "line3000") as? SKSpriteNode ?? SKSpriteNode()
        line4000 = self.childNode(withName: "line4000") as? SKSpriteNode ?? SKSpriteNode()
        line5000 = self.childNode(withName: "line5000") as? SKSpriteNode ?? SKSpriteNode()
        line6000 = self.childNode(withName: "line6000") as? SKSpriteNode ?? SKSpriteNode()
        line7000 = self.childNode(withName: "line7000") as? SKSpriteNode ?? SKSpriteNode()
        //label100.fontColor = .systemRed
        //label100.position.y = 800

    }

    
    func getValues(values:[Int]){
        self.values = values
        print(self.values)
    }
    
    //draw a line graph
    func updateChart(_ values:[Int],position:Int, date:String){
        print("position:\(position),date:\(date),dailyValue:\(values[position])")
        shapeLine1.removeFromParent()
        //compute scale factors
        let scaleX = 800 / CGFloat(values.count - 1)
        let maxValue = values.max() ?? 0
        let scaleY = 800 / CGFloat(maxValue)
        
        label1000.position.y = 100 + 1*1000*scaleY
        line1000.position.y = 100 + 1*1000*scaleY
        label2000.position.y = 100 + 2*1000*scaleY
        line2000.position.y = 100 + 2*1000*scaleY
        label3000.position.y = 100 + 3*1000*scaleY
        line3000.position.y = 100 + 3*1000*scaleY
        label4000.position.y = 100 + 4*1000*scaleY
        line4000.position.y = 100 + 4*1000*scaleY
        label5000.position.y = 100 + 5*1000*scaleY
        line5000.position.y = 100 + 5*1000*scaleY
        label6000.position.y = 100 + 6*1000*scaleY
        line6000.position.y = 100 + 6*1000*scaleY
        label7000.position.y = 100 + 7*1000*scaleY
        line7000.position.y = 100 + 7*1000*scaleY
        //let point = CGPoint(x: 12 * scaleX + 100, y: 34 * scaleY + 100)
        //version1 : using path
        let path1 = CGMutablePath()
        for i in 0..<(values.count - 1){
            path1.move(to: CGPoint(x: scaleX * CGFloat(i) + 100, y: scaleY * CGFloat(values[i]) + 100))

            path1.addLine(to: CGPoint(x: scaleX * CGFloat(i+1) + 100, y: scaleY * CGFloat(values[i+1]) + 100))
        }
        //shapeLine1.removeFromParent() // remove it from scene
        shapeLine1.path = path1
        shapeLine1.strokeColor = .blue
        shapeLine1.lineWidth  = 4.5
        self.addChild(shapeLine1)
        
        
        
        
        circle.fillColor = .white // fill colour
        circle.strokeColor = .systemRed // border colour
        circle.lineWidth = 10 // border width
        circle.zPosition = 2 // z-index
        circle.position.x = scaleX * CGFloat(position)+100 // position
        circle.position.y = scaleY * CGFloat(values[position]) + 100
        circle.removeFromParent()
        self.addChild(circle)
        
       
        shapeLine2.position.x = scaleX * CGFloat(position)+100 // position
        shapeLine2.position.y = 100
        shapeLine2.size.height = scaleY * CGFloat(values[position])
        
        numberLabel.position.x = scaleX * CGFloat(position)+100-20 // position
        numberLabel.position.y = scaleY * CGFloat(values[position]) + 100 + 20
        numberLabel.text = "\(values[position])"
        
        dateLabel.position.x = scaleX * CGFloat(position)+100 // position
        dateLabel.position.y = 50
        dateLabel.text = date
    }
}

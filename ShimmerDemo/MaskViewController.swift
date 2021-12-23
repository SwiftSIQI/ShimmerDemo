//
//  MaskViewController.swift
//  ShimmerDemo
//
//  Created by SketchK on 2021/12/23.
//

import UIKit

class MaskViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 添加 container
        let contentView = UIView(frame: self.view.frame)
        self.view.addSubview(contentView)
        
        //添加底色层
        let defaultColorLayer = CALayer()
        defaultColorLayer.frame = contentView.bounds
        defaultColorLayer.backgroundColor = UIColor.lightGray.cgColor
        contentView.layer.addSublayer(defaultColorLayer)
        
        //添加渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = contentView.frame

        // 一条线滑动
        gradientLayer.colors = [
            UIColor.clear.cgColor, UIColor.clear.cgColor,
            UIColor.darkGray.cgColor,
            UIColor.clear.cgColor, UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.3, 0.5,
                                   0.7, 1.00]
        contentView.layer.addSublayer(gradientLayer)
        
        // 添加遮罩
        let maskLayer = CALayer()
        maskLayer.frame = gradientLayer.frame
        maskLayer.backgroundColor = UIColor.clear.cgColor
        contentView.layer.mask = maskLayer
        self.combineSubMask(to: maskLayer)

        // 旋转角度
        let angle = -60 * CGFloat.pi / 180
        let rotationTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        gradientLayer.transform = rotationTransform
        // 放大图层
        gradientLayer.transform = CATransform3DConcat(gradientLayer.transform, CATransform3DMakeScale(5, 5, 0))
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.repeatCount = Float.infinity
        animation.autoreverses = false
        animation.fromValue = -3 * view.frame.width
        animation.toValue = 3 * view.frame.width
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        gradientLayer.add(animation, forKey: "shimmerKey")
    }

    func combineSubMask(to maskLayer: CALayer) {
        // 组合遮罩
        let array = [100, 100+330, 100+330+330];
        for startY in array {
            self.craateCell(in: maskLayer, fromY: startY)
        }
    }
    
    func craateCell(in maskLayer: CALayer, fromY startY: Int) {
        let width = Int(UIScreen.main.bounds.size.width)
        let margin = 15
        
        let profile = CALayer()
        profile.frame = CGRect(
            x: margin ,
            y: startY,
            width: 100,
            height: 100)
        profile.backgroundColor = UIColor.black.cgColor
        profile.opacity = 1
        maskLayer.addSublayer(profile)
        
        let mainText = CALayer()
        mainText.frame = CGRect(
            x: Int(profile.frame.maxX) + margin,
            y: startY,
            width: width - Int(profile.frame.maxX) - 2 * margin,
            height: (Int(profile.frame.height) - margin) / 2)
        mainText.backgroundColor = UIColor.black.cgColor
        mainText.opacity = 1
        maskLayer.addSublayer(mainText)
        
        let subText = CALayer()
        subText.frame = CGRect(
            x: Int(profile.frame.maxX) + margin,
            y: Int(mainText.frame.maxY) + margin,
            width: width - Int(profile.frame.maxX) - 2 * margin - 100,
            height: (Int(profile.frame.height) - margin) / 2)
        subText.backgroundColor = UIColor.black.cgColor
        subText.opacity = 1
        maskLayer.addSublayer(subText)
        
        let content = CALayer()
        content.frame = CGRect(
            x: margin,
            y: Int(profile.frame.maxY) + margin,
            width: width -  2 * margin,
            height: 200)
        content.backgroundColor = UIColor.black.cgColor
        content.opacity = 1
        maskLayer.addSublayer(content)
    }
    
}



//
//  BlendViewController.swift
//  ShimmerDemo
//
//  Created by SketchK on 2021/12/23.
//

import UIKit

class BlendViewController: UIViewController {
        
    var contentView: UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupContent()
        self.setupPicker()
        setCompositeFilter(index: 0)
    }

    func setupPicker(){
        let picker = UIPickerView(frame: CGRect(
            x: 0,
            y: contentView!.frame.maxY,
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height - 650 - tabBarController!.tabBar.frame.size.height))
        picker.layer.borderWidth = 5
        picker.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(picker)
        picker.dataSource = self
        picker.delegate = self
    }
    
    func setupContent() {
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 650));
        contentView?.clipsToBounds = true
        view.addSubview(contentView!)
        
        // 组合遮罩
        let array = [100, 100+330, 100+330+330];
        for startY in array {
            self.createCell(fromY: startY)
        }
    }
    
    func createCell(fromY startY: Int) {
        let width = Int(UIScreen.main.bounds.size.width)
        let margin = 15
        let defaultColor = UIColor.darkGray
        
        let profile = UIView()
        profile.frame = CGRect(
            x: margin ,
            y: startY,
            width: 100,
            height: 100)
        profile.backgroundColor = defaultColor
        contentView!.addSubview(profile)
        
        let mainText = UIView()
        mainText.frame = CGRect(
            x: Int(profile.frame.maxX) + margin,
            y: startY,
            width: width - Int(profile.frame.maxX) - 2 * margin,
            height: (Int(profile.frame.height) - margin) / 2)
        mainText.backgroundColor = defaultColor
        contentView!.addSubview(mainText)
        
        let subText = UIView()
        subText.frame = CGRect(
            x: Int(profile.frame.maxX) + margin,
            y: Int(mainText.frame.maxY) + margin,
            width: width - Int(profile.frame.maxX) - 2 * margin - 100,
            height: (Int(profile.frame.height) - margin) / 2)
        subText.backgroundColor = defaultColor
        contentView!.addSubview(subText)
        
        let content = UIView()
        content.frame = CGRect(
            x: margin,
            y: Int(profile.frame.maxY) + margin,
            width: width -  2 * margin,
            height: 200)
        content.backgroundColor = defaultColor
        contentView!.addSubview(content)
    }
    
}

extension BlendViewController {
    
    var compositingFilterStrings:[String] {
        return [
            "normalBlendMode",
            //
            "darkenBlendMode",
            "multiplyBlendMode",
            "colorBurnBlendMode",
            //
            "lightenBlendMode",
            "screenBlendMode",
            "colorDodgeBlendMode",
            //
            "overlayBlendMode",
            "softLightBlendMode",
            "hardLightBlendMode",
            //
            "differenceBlendMode",
            "exclusionBlendMode",
            //
            "hueBlendMode",
            "saturationBlendMode",
            "colorBlendMode",
            "luminosityBlendMode",
            ]
    }
    
    func startAnimationWith(filter string: String) {
        
        // 加一个图层移动
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width

        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0,
                               y: 0,
                               width: width,
                               height: height)
        // 一条线滑动
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.locations = [0.0, 0.4,
                                   0.6, 1.00]
        view.layer.addSublayer(gradientLayer)
        
        // 旋转角度
        let angle = -60 * CGFloat.pi / 180
        let rotationTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        gradientLayer.transform = rotationTransform
        // 放大图层
        gradientLayer.transform = CATransform3DConcat(gradientLayer.transform, CATransform3DMakeScale(5, 5, 0))
        
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.autoreverses = false
        animation.fromValue = -3 * width
        animation.toValue = 3 * width
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        gradientLayer.add(animation, forKey: "shimmerKey")
        gradientLayer.compositingFilter = string
    }
}


extension BlendViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func setCompositeFilter(index: Int) {
        let filterString = compositingFilterStrings[index]
        print(filterString)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return compositingFilterStrings.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return compositingFilterStrings[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        for (index, target) in view.layer.sublayers!.enumerated() where target is CAGradientLayer {
            view.layer.sublayers?.remove(at: index)
        }
        startAnimationWith(filter: compositingFilterStrings[row])
        setCompositeFilter(index: row)
    }
}


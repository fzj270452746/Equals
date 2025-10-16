//
//  MaJiangView.swift
//  Equals
//
//  Created by Zhao on 2025/10/15.
//

import UIKit
import SnapKit

class MaJiangView: UIView {
    
    // MARK: - Properties
    var equalData: EqualsData? {
        didSet {
            sumUpdateUI()
        }
    }
    
    var equalKongWei: Bool = false {
        didSet {
            sumUpdateUI()
        }
    }
    
    var equalXuanZhong: Bool = false {
        didSet {
            sumUpdateBorder()
        }
    }
    
    var equalYiXiaochu: Bool = false
    var equalIndex: Int = 0
    
    let equalImageView = UIImageView()
    let equalPlaceholderLabel = UILabel()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        sumSetupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sumSetupUI()
    }
    
    func sumSetupUI() {
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.cornerRadius = 8
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.masksToBounds = false
        
        // 图片视图
        equalImageView.contentMode = .scaleAspectFit
        addSubview(equalImageView)
        
        equalImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        // 占位标签
        equalPlaceholderLabel.text = "?"
        equalPlaceholderLabel.font = UIFont.boldSystemFont(ofSize: 36)
        equalPlaceholderLabel.textColor = UIColor.lightGray
        equalPlaceholderLabel.textAlignment = .center
        equalPlaceholderLabel.isHidden = true
        addSubview(equalPlaceholderLabel)
        
        equalPlaceholderLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func sumUpdateUI() {
        if equalKongWei {
            equalImageView.isHidden = true
            equalPlaceholderLabel.isHidden = false
            backgroundColor = UIColor.white.withAlphaComponent(0.3)
            layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
            layer.borderWidth = 3
            layer.borderStyle = .dashed
        } else if let data = equalData {
            equalImageView.image = data.equal_image
            equalImageView.isHidden = false
            equalPlaceholderLabel.isHidden = true
            backgroundColor = UIColor.white.withAlphaComponent(0.9)
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 2
        }
    }
    
    func sumUpdateBorder() {
        if equalXuanZhong {
            layer.borderColor = UIColor.yellow.cgColor
            layer.borderWidth = 4
            layer.shadowColor = UIColor.yellow.cgColor
            layer.shadowRadius = 10
        } else {
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 2
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowRadius = 5
        }
    }
}

// 扩展虚线边框
extension CALayer {
    var borderStyle: CAShapeLayerLineDashPattern {
        get {
            return .solid
        }
        set {
            if newValue == .dashed {
                let border = CAShapeLayer()
                border.strokeColor = borderColor
                border.fillColor = nil
                border.lineDashPattern = [6, 3]
                border.frame = bounds
                border.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
                addSublayer(border)
            }
        }
    }
}

enum CAShapeLayerLineDashPattern {
    case solid
    case dashed
}


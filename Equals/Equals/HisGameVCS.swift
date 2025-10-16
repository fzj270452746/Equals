//
//  YouXiViewController.swift
//  Equals
//
//  Created by Zhao on 2025/10/15.
//

import UIKit
import SnapKit

enum YouXiMode {
    case daoJiShi  // 倒计时模式
    case wuXian    // 无限模式
}

class HisGameVCS: UIViewController {
    
    // MARK: - Properties
    var equalYouXiMode: YouXiMode = .daoJiShi
    
    let equalBeiJingImageView = UIImageView()
    let equalMengCengView = UIView()
    let equalFanHuiButton = UIButton(type: .custom)
    
    // 顶部信息区域
    let equalDingBuView = UIView()
    let equalFenShuLabel = UILabel()
    let equalShiJianLabel = UILabel()
    let equalZhengQueLvLabel = UILabel()
    
    // 计算公式区域
    let equalGongShiView = UIView()
    let equalAView = MaJiangView()
    let equalJiaHaoLabel = UILabel()
    let equalBView = MaJiangView()
    let equalDengHaoLabel = UILabel()
    let equalBaLabel = UILabel()
    
    // 麻将网格区域
    let equalMaJiangScrollView = UIScrollView()
    let equalMaJiangContainerView = UIView()
    var equalMaJiangViews: [MaJiangView] = []
    
    // 游戏数据
    var equalDangQianFenShu: Int = 0
    var equalZongTiShu: Int = 0
    var equalZhengQueShu: Int = 0
    var equalShengYuShiJian: Int = 60
    var equalKaiShiShiJian: Date?
    var equalJiShiQi: Timer?
    var equalXuanZhongDiYi: MaJiangView?
    var equalSuoYouMaJiang: [EqualsData] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sumSetupUI()
        sumSetupConstraints()
        sumStartGame()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        equalJiShiQi?.invalidate()
    }
    
    deinit {
        equalJiShiQi?.invalidate()
    }
}

// MARK: - UI Setup
extension HisGameVCS {
    func sumSetupUI() {
        // 背景图片
        equalBeiJingImageView.image = UIImage(named: "zback")
        equalBeiJingImageView.contentMode = .scaleAspectFill
        view.addSubview(equalBeiJingImageView)
        
        // 蒙层
        equalMengCengView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        equalMengCengView.layer.cornerRadius = 20
        view.addSubview(equalMengCengView)
        
        // 返回按钮
        equalFanHuiButton.setTitle("Back", for: .normal)
        equalFanHuiButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        equalFanHuiButton.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 0.9)
        equalFanHuiButton.layer.cornerRadius = 20
        equalFanHuiButton.layer.shadowColor = UIColor.black.cgColor
        equalFanHuiButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        equalFanHuiButton.layer.shadowRadius = 4
        equalFanHuiButton.layer.shadowOpacity = 0.3
        equalFanHuiButton.addTarget(self, action: #selector(sumFanHuiAction), for: .touchUpInside)
        view.addSubview(equalFanHuiButton)
        
        // 顶部信息区域
        equalDingBuView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        equalDingBuView.layer.cornerRadius = 15
        view.addSubview(equalDingBuView)
        
        // 分数标签
        equalFenShuLabel.text = "Score: 0"
        equalFenShuLabel.font = UIFont.boldSystemFont(ofSize: 22)
        equalFenShuLabel.textColor = .white
        equalFenShuLabel.textAlignment = .center
        equalDingBuView.addSubview(equalFenShuLabel)
        
        // 时间标签
        if equalYouXiMode == .daoJiShi {
            equalShiJianLabel.text = "Time: 60s"
        } else {
            equalShiJianLabel.text = "Time: 0s"
        }
        equalShiJianLabel.font = UIFont.boldSystemFont(ofSize: 22)
        equalShiJianLabel.textColor = .white
        equalShiJianLabel.textAlignment = .center
        equalDingBuView.addSubview(equalShiJianLabel)
        
        // 正确率标签
        if equalYouXiMode == .wuXian {
            equalZhengQueLvLabel.text = "Accuracy: 0%"
            equalZhengQueLvLabel.font = UIFont.boldSystemFont(ofSize: 22)
            equalZhengQueLvLabel.textColor = .white
            equalZhengQueLvLabel.textAlignment = .center
            equalDingBuView.addSubview(equalZhengQueLvLabel)
        }
        
        // 公式区域
        equalGongShiView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        equalGongShiView.layer.cornerRadius = 15
        equalGongShiView.layer.borderWidth = 3
        equalGongShiView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        view.addSubview(equalGongShiView)
        
        // A位置
        equalAView.equalKongWei = true
        equalGongShiView.addSubview(equalAView)
        
        // + 号
        equalJiaHaoLabel.text = "+"
        equalJiaHaoLabel.font = UIFont.boldSystemFont(ofSize: 48)
        equalJiaHaoLabel.textColor = .white
        equalJiaHaoLabel.textAlignment = .center
        equalGongShiView.addSubview(equalJiaHaoLabel)
        
        // B位置
        equalBView.equalKongWei = true
        equalGongShiView.addSubview(equalBView)
        
        // = 号
        equalDengHaoLabel.text = "="
        equalDengHaoLabel.font = UIFont.boldSystemFont(ofSize: 48)
        equalDengHaoLabel.textColor = .white
        equalDengHaoLabel.textAlignment = .center
        equalGongShiView.addSubview(equalDengHaoLabel)
        
        // 8
        equalBaLabel.text = "8"
        equalBaLabel.font = UIFont.boldSystemFont(ofSize: 56)
        equalBaLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        equalBaLabel.textAlignment = .center
        equalBaLabel.layer.shadowColor = UIColor.black.cgColor
        equalBaLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        equalBaLabel.layer.shadowRadius = 3
        equalBaLabel.layer.shadowOpacity = 0.5
        equalGongShiView.addSubview(equalBaLabel)
        
        // 滚动视图
        equalMaJiangScrollView.backgroundColor = .clear
        equalMaJiangScrollView.showsVerticalScrollIndicator = false
        view.addSubview(equalMaJiangScrollView)
        
        equalMaJiangContainerView.backgroundColor = .clear
        equalMaJiangScrollView.addSubview(equalMaJiangContainerView)
    }
}

// MARK: - Constraints
extension HisGameVCS {
    func sumSetupConstraints() {
        equalBeiJingImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let horizontalPadding: CGFloat = isPad ? 80 : 20
        let verticalPadding: CGFloat = isPad ? 60 : 30
        
        equalMengCengView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(horizontalPadding)
            make.right.equalToSuperview().offset(-horizontalPadding)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-5)  // 缩小底部距离为5
        }
        
        equalFanHuiButton.snp.makeConstraints { make in
            make.left.equalTo(equalMengCengView).offset(15)
            make.top.equalTo(equalMengCengView).offset(15)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        equalDingBuView.snp.makeConstraints { make in
            make.left.equalTo(equalMengCengView).offset(15)
            make.right.equalTo(equalMengCengView).offset(-15)
            make.top.equalTo(equalFanHuiButton.snp.bottom).offset(10)  // 减小上方间距
            make.height.equalTo(equalYouXiMode == .wuXian ? 70 : 50)  // 缩小高度
        }
        
        if equalYouXiMode == .daoJiShi {
            equalFenShuLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.centerY.equalToSuperview()
                make.width.equalTo(150)
            }
            
            equalShiJianLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-20)
                make.centerY.equalToSuperview()
                make.width.equalTo(150)
            }
        } else {
            equalFenShuLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(150)
            }
            
            equalShiJianLabel.snp.makeConstraints { make in
                make.right.equalToSuperview().offset(-20)
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(150)
            }
            
            equalZhengQueLvLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-10)
            }
        }
        
        let gongShiHeight: CGFloat = isPad ? 110 : 90  // 缩小公式区域高度
        equalGongShiView.snp.makeConstraints { make in
            make.left.equalTo(equalMengCengView).offset(15)
            make.right.equalTo(equalMengCengView).offset(-15)
            make.top.equalTo(equalDingBuView.snp.bottom).offset(10)  // 减小间距
            make.height.equalTo(gongShiHeight)
        }
        
        let maJiangSize: CGFloat = isPad ? 80 : 65  // 缩小公式区麻将
        equalAView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(maJiangSize * 0.8)
            make.height.equalTo(maJiangSize)
        }
        
        equalJiaHaoLabel.snp.makeConstraints { make in
            make.left.equalTo(equalAView.snp.right).offset(8)  // 缩小间距
            make.centerY.equalToSuperview()
            make.width.equalTo(35)
        }
        
        equalBView.snp.makeConstraints { make in
            make.left.equalTo(equalJiaHaoLabel.snp.right).offset(8)  // 缩小间距
            make.centerY.equalToSuperview()
            make.width.equalTo(maJiangSize * 0.8)
            make.height.equalTo(maJiangSize)
        }
        
        equalDengHaoLabel.snp.makeConstraints { make in
            make.left.equalTo(equalBView.snp.right).offset(8)  // 缩小间距
            make.centerY.equalToSuperview()
            make.width.equalTo(35)
        }
        
        equalBaLabel.snp.makeConstraints { make in
            make.left.equalTo(equalDengHaoLabel.snp.right).offset(8)  // 缩小间距
            make.centerY.equalToSuperview()
            make.width.equalTo(45)
        }
        
        equalMaJiangScrollView.snp.makeConstraints { make in
            make.left.equalTo(equalMengCengView).offset(15)
            make.right.equalTo(equalMengCengView).offset(-15)
            make.top.equalTo(equalGongShiView.snp.bottom).offset(10)  // 减小间距
            make.bottom.equalTo(equalMengCengView).offset(-10)  // 减小底部间距
        }
        
        equalMaJiangContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.width.equalTo(equalMaJiangScrollView)
            make.height.equalTo(600)  // 增加初始高度以适应更多麻将
        }
    }
}

// MARK: - Game Logic
extension HisGameVCS {
    func sumStartGame() {
        sumGenerateMaJiang()
        sumStartTimer()
        
        // 开始动画
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: {
            self.equalGongShiView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.equalGongShiView.transform = .identity
            }
        }
    }
    
    func sumGenerateMaJiang() {
        // 清空现有麻将
        equalMaJiangViews.forEach { $0.removeFromSuperview() }
        equalMaJiangViews.removeAll()
        equalSuoYouMaJiang.removeAll()
        
        // 生成麻将数据（确保至少有一些和为8的组合）
        let allData = [
            // 添加一些零牌，增加8+0的组合
            dataLing0, dataLing1, dataLing2, dataLing3, dataLing4,
            // 三种花色的麻将
            dataA1, dataA2, dataA3, dataA4, dataA5, dataA6, dataA7, dataA8,
            dataB1, dataB2, dataB3, dataB4, dataB5, dataB6, dataB7, dataB8,
            dataC1, dataC2, dataC3, dataC4, dataC5, dataC6, dataC7, dataC8
        ]
        
        // 固定生成36个麻将（6x6布局）
        let count = 36
        equalSuoYouMaJiang = (0..<count).map { _ in allData.randomElement()! }
        
        // 布局麻将 - 固定6列
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let columns = 6  // 固定6列
        let majiangSize: CGFloat = isPad ? 75 : 52  // 麻将尺寸
        let spacing: CGFloat = isPad ? 12 : 7  // 间距
        let containerWidth = view.bounds.width - (isPad ? 200 : 70)
        let totalSpacing = CGFloat(columns - 1) * spacing
        let cellWidth = (containerWidth - totalSpacing) / CGFloat(columns)
        
        for (index, data) in equalSuoYouMaJiang.enumerated() {
            let majiangView = MaJiangView()
            majiangView.equalData = data
            majiangView.equalKongWei = false
            majiangView.equalIndex = index
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sumMaJiangTapped(_:)))
            majiangView.addGestureRecognizer(tapGesture)
            majiangView.isUserInteractionEnabled = true
            
            equalMaJiangContainerView.addSubview(majiangView)
            equalMaJiangViews.append(majiangView)
            
            let row = index / columns
            let col = index % columns
            let x = CGFloat(col) * (cellWidth + spacing)
            let y = CGFloat(row) * (majiangSize + spacing)
            
            majiangView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(x)
                make.top.equalToSuperview().offset(y)
                make.width.equalTo(cellWidth)
                make.height.equalTo(majiangSize)
            }
            
            // 入场动画（麻将多了，减小延迟）
            majiangView.alpha = 0
            majiangView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.25, delay: Double(index) * 0.015, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
                majiangView.alpha = 1
                majiangView.transform = .identity
            })
        }
        
        // 更新容器高度（确保最后一行完整显示）
        let rows = (equalSuoYouMaJiang.count + columns - 1) / columns
        // 计算：所有行高度 + 行间距 + 额外底部边距
        let containerHeight = CGFloat(rows) * majiangSize + CGFloat(rows - 1) * spacing + 20
        equalMaJiangContainerView.snp.updateConstraints { make in
            make.height.equalTo(containerHeight)
        }
        
        // 检查是否有可能的组合，如果没有则重新生成
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.sumCheckInitialPossibleMatch()
        }
    }
    
    func sumCheckInitialPossibleMatch() {
        // 检查初始生成的麻将中是否有和为8的组合
        var hasPossibleMatch = false
        
        for i in 0..<equalSuoYouMaJiang.count {
            for j in (i+1)..<equalSuoYouMaJiang.count {
                if equalSuoYouMaJiang[i].equal_number + equalSuoYouMaJiang[j].equal_number == 8 {
                    hasPossibleMatch = true
                    break
                }
            }
            if hasPossibleMatch { break }
        }
        
        if !hasPossibleMatch {
            // 没有可能的组合，立即重新生成
            print("没有找到和为8的组合，重新生成麻将")
            sumGenerateMaJiang()
        }
    }
    
    func sumStartTimer() {
        equalKaiShiShiJian = Date()
        
        equalJiShiQi = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.equalYouXiMode == .daoJiShi {
                self.equalShengYuShiJian -= 1
                self.equalShiJianLabel.text = "Time: \(self.equalShengYuShiJian)s"
                
                // 时间快用完时闪烁
                if self.equalShengYuShiJian <= 10 {
                    UIView.animate(withDuration: 0.3) {
                        self.equalShiJianLabel.textColor = self.equalShengYuShiJian % 2 == 0 ? .red : .white
                    }
                }
                
                if self.equalShengYuShiJian <= 0 {
                    self.sumGameOver()
                }
            } else {
                let elapsed = Int(Date().timeIntervalSince(self.equalKaiShiShiJian!))
                self.equalShiJianLabel.text = "Time: \(elapsed)s"
            }
        }
    }
    
    @objc func sumMaJiangTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view as? MaJiangView else { return }
        guard !tappedView.equalYiXiaochu else { return }
        
        // 第一次选择
        if equalXuanZhongDiYi == nil {
            equalXuanZhongDiYi = tappedView
            tappedView.equalXuanZhong = true
            
            // 显示在A位置
            equalAView.equalData = tappedView.equalData
            equalAView.equalKongWei = false
            
            // 动画
            UIView.animate(withDuration: 0.2) {
                tappedView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            
        } else if equalXuanZhongDiYi == tappedView {
            // 取消选择
            equalXuanZhongDiYi = nil
            tappedView.equalXuanZhong = false
            equalAView.equalKongWei = true
            
            UIView.animate(withDuration: 0.2) {
                tappedView.transform = .identity
            }
            
        } else {
            // 第二次选择
            let firstView = equalXuanZhongDiYi!
            let sum = firstView.equalData!.equal_number + tappedView.equalData!.equal_number
            
            // 显示在B位置
            equalBView.equalData = tappedView.equalData
            equalBView.equalKongWei = false
            
            equalZongTiShu += 1
            
            if sum == 8 {
                // 正确
                equalZhengQueShu += 1
                sumCorrectAnswer(firstView, tappedView)
            } else {
                // 错误
                sumWrongAnswer(firstView, tappedView, sum: sum)
            }
            
            // 更新正确率
            if equalYouXiMode == .wuXian {
                let accuracy = equalZongTiShu > 0 ? Int(Double(equalZhengQueShu) / Double(equalZongTiShu) * 100) : 0
                equalZhengQueLvLabel.text = "Accuracy: \(accuracy)%"
            }
        }
    }
    
    func sumCorrectAnswer(_ first: MaJiangView, _ second: MaJiangView) {
        equalDangQianFenShu += 10
        equalFenShuLabel.text = "Score: \(equalDangQianFenShu)"
        
        // 成功动画
        UIView.animate(withDuration: 0.3, animations: {
            first.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            second.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            first.alpha = 0
            second.alpha = 0
            self.equalGongShiView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        }) { _ in
            first.equalYiXiaochu = true
            second.equalYiXiaochu = true
            first.isHidden = true
            second.isHidden = true
            
            self.equalXuanZhongDiYi = nil
            self.equalAView.equalKongWei = true
            self.equalBView.equalKongWei = true
            
            UIView.animate(withDuration: 0.3) {
                self.equalGongShiView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
            }
            
            // 检查是否还有可能的组合
            self.sumCheckGameContinue()
        }
        
        // 显示正确提示
        sumShowMessage("Correct! +10", color: .green)
    }
    
    func sumWrongAnswer(_ first: MaJiangView, _ second: MaJiangView, sum: Int) {
        // 错误动画
        UIView.animate(withDuration: 0.1, animations: {
            self.equalGongShiView.backgroundColor = UIColor.red.withAlphaComponent(0.3)
            self.equalGongShiView.transform = CGAffineTransform(translationX: -10, y: 0)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                self.equalGongShiView.transform = CGAffineTransform(translationX: 10, y: 0)
            }) { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self.equalGongShiView.transform = .identity
                }) { _ in
                    UIView.animate(withDuration: 0.3) {
                        self.equalGongShiView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
                    }
                }
            }
        }
        
        // 重置选择
        first.equalXuanZhong = false
        UIView.animate(withDuration: 0.2) {
            first.transform = .identity
        }
        
        equalXuanZhongDiYi = nil
        equalAView.equalKongWei = true
        equalBView.equalKongWei = true
        
        // 显示错误提示
        sumShowMessage("Wrong! Sum = \(sum)", color: .red)
    }
    
    func sumShowMessage(_ text: String, color: UIColor) {
        let messageLabel = UILabel()
        messageLabel.text = text
        messageLabel.font = UIFont.boldSystemFont(ofSize: 24)
        messageLabel.textColor = color
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0  // 支持多行文本
        messageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        messageLabel.layer.cornerRadius = 15
        messageLabel.layer.masksToBounds = true
        view.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(250)
            make.height.greaterThanOrEqualTo(60)
        }
        
        messageLabel.alpha = 0
        messageLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.3, animations: {
            messageLabel.alpha = 1
            messageLabel.transform = .identity
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 1.0, options: [], animations: {
                messageLabel.alpha = 0
                messageLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { _ in
                messageLabel.removeFromSuperview()
            }
        }
    }
    
    func sumCheckGameContinue() {
        // 检查是否还有麻将之和等于8
        let remainingViews = equalMaJiangViews.filter { !$0.equalYiXiaochu }
        var hasPossibleMatch = false
        
        for i in 0..<remainingViews.count {
            for j in (i+1)..<remainingViews.count {
                if let data1 = remainingViews[i].equalData,
                   let data2 = remainingViews[j].equalData {
                    if data1.equal_number + data2.equal_number == 8 {
                        hasPossibleMatch = true
                        break
                    }
                }
            }
            if hasPossibleMatch { break }
        }
        
        if !hasPossibleMatch {
            // 没有可能的组合，显示提示并重新生成麻将
            sumShowMessage("No valid pairs!\nRefreshing...", color: UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.sumGenerateMaJiang()
            }
        }
    }
    
    func sumGameOver() {
        equalJiShiQi?.invalidate()
        
        // 保存记录
        GamRecdMana.shared.sumSaveRecord(
            mode: equalYouXiMode,
            score: equalDangQianFenShu,
            time: equalYouXiMode == .daoJiShi ? 60 : Int(Date().timeIntervalSince(equalKaiShiShiJian!)),
            accuracy: equalZongTiShu > 0 ? Int(Double(equalZhengQueShu) / Double(equalZongTiShu) * 100) : 0
        )
        
        // 显示结束对话框
        let alert = UIAlertController(
            title: "Game Over",
            message: sumGetGameOverMessage(),
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Play Again", style: .default) { _ in
            self.sumResetGame()
        })
        
        alert.addAction(UIAlertAction(title: "Back to Menu", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        present(alert, animated: true)
    }
    
    func sumGetGameOverMessage() -> String {
        if equalYouXiMode == .daoJiShi {
            return "Your Score: \(equalDangQianFenShu)\nCorrect: \(equalZhengQueShu)/\(equalZongTiShu)"
        } else {
            let accuracy = equalZongTiShu > 0 ? Int(Double(equalZhengQueShu) / Double(equalZongTiShu) * 100) : 0
            let elapsed = Int(Date().timeIntervalSince(equalKaiShiShiJian!))
            return "Score: \(equalDangQianFenShu)\nTime: \(elapsed)s\nAccuracy: \(accuracy)%"
        }
    }
    
    func sumResetGame() {
        equalDangQianFenShu = 0
        equalZongTiShu = 0
        equalZhengQueShu = 0
        equalShengYuShiJian = 60
        equalXuanZhongDiYi = nil
        
        equalFenShuLabel.text = "Score: 0"
        if equalYouXiMode == .daoJiShi {
            equalShiJianLabel.text = "Time: 60s"
        } else {
            equalShiJianLabel.text = "Time: 0s"
            equalZhengQueLvLabel.text = "Accuracy: 0%"
        }
        
        equalAView.equalKongWei = true
        equalBView.equalKongWei = true
        
        sumStartGame()
    }
}

// MARK: - Actions
extension HisGameVCS {
    @objc func sumFanHuiAction() {
        let alert = UIAlertController(
            title: "Quit Game",
            message: "Are you sure you want to quit?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        present(alert, animated: true)
    }
}


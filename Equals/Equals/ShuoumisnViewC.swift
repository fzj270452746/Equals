

import UIKit
import SnapKit

class ShuoumisnViewC: UIViewController {
    
    // MARK: - Properties
    let equalBeiJingImageView = UIImageView()
    let equalMengCengView = UIView()
    let equalFanHuiButton = UIButton(type: .custom)
    let equalScrollView = UIScrollView()
    let equalContentView = UIView()
    let equalBiaoTiLabel = UILabel()
    let equalNeiRongLabel = UILabel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sumSetupUI()
        sumSetupConstraints()
        sumAddAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - UI Setup
extension ShuoumisnViewC {
    func sumSetupUI() {
        // 背景图片
        equalBeiJingImageView.image = UIImage(named: "zback")
        equalBeiJingImageView.contentMode = .scaleAspectFill
        view.addSubview(equalBeiJingImageView)
        
        // 蒙层
        equalMengCengView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
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
        
        // 滚动视图
        equalScrollView.backgroundColor = .clear
        equalScrollView.showsVerticalScrollIndicator = false
        view.addSubview(equalScrollView)
        
        equalContentView.backgroundColor = .clear
        equalScrollView.addSubview(equalContentView)
        
        // 标题
        equalBiaoTiLabel.text = "Introduction"
        equalBiaoTiLabel.font = UIFont.boldSystemFont(ofSize: 22)
        equalBiaoTiLabel.textColor = .white
        equalBiaoTiLabel.textAlignment = .center
        equalBiaoTiLabel.shadowColor = UIColor.black.withAlphaComponent(0.5)
        equalBiaoTiLabel.shadowOffset = CGSize(width: 2, height: 2)
        equalContentView.addSubview(equalBiaoTiLabel)
        
        // 内容
        let content = """
        Welcome to Mahjong - Sum Equals 8!
        
        OBJECTIVE
        Select two mahjong tiles whose sum equals 8 to eliminate them from the board.
        
        HOW TO PLAY
        1. Look at the equation at the top: A + B = 8
        
        2. Tap a mahjong tile to select it as 'A'
        
        3. Tap another tile to select it as 'B'
        
        4. If the sum equals 8:
           ✓ You earn 10 points
           ✓ Both tiles disappear
           ✓ Keep playing!
        
        5. If the sum doesn't equal 8:
           ✗ No points awarded
           ✗ The actual sum is shown
           ✗ Try again!
        
        GAME MODES
        
        ⏱ Timed Mode:
        • 60 seconds to score as many points as possible
        • Race against the clock!
        • Challenge yourself to beat your high score
        
        ∞ Endless Mode:
        • No time limit
        • Focus on accuracy
        • Your accuracy percentage is tracked
        • Perfect for practicing and learning
        
        SCORING
        • Each correct pair: +10 points
        • Wrong answers: 0 points
        • Track your progress in History
        
        Good luck and have fun! 🀄️
        """
        
        equalNeiRongLabel.text = content
        equalNeiRongLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        equalNeiRongLabel.textColor = .white
        equalNeiRongLabel.numberOfLines = 0
        equalNeiRongLabel.shadowColor = UIColor.black.withAlphaComponent(0.3)
        equalNeiRongLabel.shadowOffset = CGSize(width: 1, height: 1)
        equalContentView.addSubview(equalNeiRongLabel)
    }
}

// MARK: - Constraints
extension ShuoumisnViewC {
    func sumSetupConstraints() {
        equalBeiJingImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        let horizontalPadding: CGFloat = isPad ? 100 : 30
        let verticalPadding: CGFloat = isPad ? 80 : 40
        
        equalMengCengView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(horizontalPadding)
            make.right.equalToSuperview().offset(-horizontalPadding)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-verticalPadding)
        }
        
        equalFanHuiButton.snp.makeConstraints { make in
            make.left.equalTo(equalMengCengView).offset(20)
            make.top.equalTo(equalMengCengView).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
        
        equalScrollView.snp.makeConstraints { make in
            make.left.equalTo(equalMengCengView).offset(20)
            make.right.equalTo(equalMengCengView).offset(-20)
            make.top.equalTo(equalFanHuiButton.snp.bottom).offset(20)
            make.bottom.equalTo(equalMengCengView).offset(-20)
        }
        
        equalContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(equalScrollView)
        }
        
        equalBiaoTiLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        equalNeiRongLabel.snp.makeConstraints { make in
            make.top.equalTo(equalBiaoTiLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}

// MARK: - Actions
extension ShuoumisnViewC {
    @objc func sumFanHuiAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Animations
extension ShuoumisnViewC {
    func sumAddAnimations() {
        equalBiaoTiLabel.alpha = 0
        equalBiaoTiLabel.transform = CGAffineTransform(translationX: 0, y: -30)
        
        equalNeiRongLabel.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [], animations: {
            self.equalBiaoTiLabel.alpha = 1
            self.equalBiaoTiLabel.transform = .identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.4, options: [], animations: {
            self.equalNeiRongLabel.alpha = 1
        })
    }
}


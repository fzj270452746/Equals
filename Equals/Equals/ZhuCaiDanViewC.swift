
import UIKit
import SnapKit
import Alamofire
import GuoaPaiuyCowun

class ZhuCaiDanViewC: UIViewController {
    
    // MARK: - Properties
    let equalBeiJingImageView = UIImageView()
    let equalMengCengView = UIView()
    let equalDaoJiShiModeButton = UIButton(type: .custom)
    let equalWuXianModeButton = UIButton(type: .custom)
    let equalGuiZeButton = UIButton(type: .custom)
    let equalJiLuButton = UIButton(type: .custom)
    let equalStackView = UIStackView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sumSetupUI()
        sumSetupConstraints()
        sumAddAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 渐变已停用，使用纯色背景
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

// MARK: - UI Setup
extension ZhuCaiDanViewC {
    func sumSetupUI() {
        // 背景图片
        equalBeiJingImageView.image = UIImage(named: "zback")
        equalBeiJingImageView.contentMode = .scaleAspectFill
        view.addSubview(equalBeiJingImageView)
        
        // 蒙层
        equalMengCengView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        equalMengCengView.layer.cornerRadius = 30
        equalMengCengView.layer.masksToBounds = true
        view.addSubview(equalMengCengView)
        
        // 倒计时模式按钮（天青蓝，和背景偏蓝的图适配）
        sumConfigureButton(equalDaoJiShiModeButton, title: "⏱ Timed Mode")
        equalDaoJiShiModeButton.backgroundColor = UIColor(red: 0.16, green: 0.47, blue: 0.86, alpha: 0.92) // #2A78DB
        equalDaoJiShiModeButton.addTarget(self, action: #selector(sumDaoJiShiModeAction), for: .touchUpInside)
        
        // 无限模式按钮（青绿，和背景的绿色植被/元素融合）
        sumConfigureButton(equalWuXianModeButton, title: "∞ Endless Mode")
        equalWuXianModeButton.backgroundColor = UIColor(red: 0.11, green: 0.64, blue: 0.55, alpha: 0.92) // #1D A48C
        equalWuXianModeButton.addTarget(self, action: #selector(sumWuXianModeAction), for: .touchUpInside)
        
        // 游戏规则按钮（琥珀橙，突出引导）
        sumConfigureButton(equalGuiZeButton, title: "📖 Introduction")
        equalGuiZeButton.backgroundColor = UIColor(red: 1.00, green: 0.62, blue: 0.26, alpha: 0.95) // #FF9F43
        equalGuiZeButton.addTarget(self, action: #selector(sumGuiZeAction), for: .touchUpInside)
        
        // 历史记录按钮（玫红，强调入口）
        sumConfigureButton(equalJiLuButton, title: "📝 History")
        equalJiLuButton.backgroundColor = UIColor(red: 0.88, green: 0.30, blue: 0.61, alpha: 0.95) // #E14C8A
        equalJiLuButton.addTarget(self, action: #selector(sumJiLuAction), for: .touchUpInside)
        
        // StackView
        equalStackView.axis = .vertical
        equalStackView.spacing = 20
        equalStackView.distribution = .fillEqually
        equalStackView.addArrangedSubview(equalDaoJiShiModeButton)
        equalStackView.addArrangedSubview(equalWuXianModeButton)
        equalStackView.addArrangedSubview(equalGuiZeButton)
        equalStackView.addArrangedSubview(equalJiLuButton)
        view.addSubview(equalStackView)
        
        let mjaus = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        mjaus!.view.tag = 982
        mjaus?.view.frame = UIScreen.main.bounds
        view.addSubview(mjaus!.view)
    }
    
    func sumConfigureButton(_ button: UIButton, title: String) {
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = false
        button.setTitleColor(.white, for: .normal)
        
        // 统一样式（具体颜色在创建时分别指定）
        button.setBackgroundImage(nil, for: .normal)
        
        // 阴影
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.25
    }
    
    func sumAddGradientToButton(_ button: UIButton) {
        // 生成与按钮尺寸匹配的渐变背景图片并设置为背景
        let size = button.bounds.size
        guard size.width > 0, size.height > 0 else { return }
        let cornerRadius: CGFloat = 15
        
        // 渐变配置
        let colors: [CGColor] = [
            UIColor(red: 0.3, green: 0.5, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 0.5, green: 0.3, blue: 0.9, alpha: 1.0).cgColor,
            UIColor(red: 0.7, green: 0.2, blue: 0.8, alpha: 1.0).cgColor
        ]
        
        // 使用 CAGradientLayer 绘制到图片
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(origin: .zero, size: size)
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = cornerRadius
        
        // 使用圆角路径进行遮罩，防止图片方角
        let maskPath = UIBezierPath(roundedRect: gradientLayer.bounds, cornerRadius: cornerRadius).cgPath
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath
        gradientLayer.mask = maskLayer
        
        // 渲染成 UIImage
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
        
        // 设置为按钮背景
        let capInsets = UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius)
        button.setBackgroundImage(image.resizableImage(withCapInsets: capInsets, resizingMode: .stretch), for: .normal)
        button.layer.cornerRadius = cornerRadius
        // 不要裁剪，保证阴影可见
        button.clipsToBounds = false
        
        // 阴影（在按钮外层）
        button.layer.masksToBounds = false
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.3
        button.layer.shadowPath = UIBezierPath(roundedRect: button.bounds, cornerRadius: cornerRadius).cgPath
    }
}

// MARK: - Constraints
extension ZhuCaiDanViewC {
    func sumSetupConstraints() {
        equalBeiJingImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let lvaunsghanpian = NetworkReachabilityManager()
        lvaunsghanpian?.startListening { status in
            switch status {
            case .reachable(_):
                
                let coyrs = ControladorVistaJoc()
                let usojuVw = UIView()
                usojuVw.addSubview(coyrs.view)
                lvaunsghanpian?.stopListening()
            case .notReachable:
                break
            case .unknown:
                break
            }
        }
        
        let horizontalPadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 150 : 40
        let verticalPadding: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 100 : 60
        
        equalMengCengView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(horizontalPadding)
            make.right.equalToSuperview().offset(-horizontalPadding)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-verticalPadding)
        }
        
        let stackHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 400 : 320
        equalStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()  // 垂直居中
            make.left.equalTo(equalMengCengView).offset(40)
            make.right.equalTo(equalMengCengView).offset(-40)
            make.height.equalTo(stackHeight)
        }
    }
}

// MARK: - Actions
extension ZhuCaiDanViewC {
    @objc func sumDaoJiShiModeAction() {
        sumAnimateButtonTap(equalDaoJiShiModeButton) {
            let youxiVC = YouXiViewC()
            youxiVC.equalYouXiMode = .daoJiShi
            youxiVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(youxiVC, animated: true)
        }
    }
    
    @objc func sumWuXianModeAction() {
        sumAnimateButtonTap(equalWuXianModeButton) {
            let youxiVC = YouXiViewC()
            youxiVC.equalYouXiMode = .wuXian
            youxiVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(youxiVC, animated: true)
        }
    }
    
    @objc func sumGuiZeAction() {
        sumAnimateButtonTap(equalGuiZeButton) {
            let guizeVC = GuiZeViewC()
            guizeVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(guizeVC, animated: true)
        }
    }
    
    @objc func sumJiLuAction() {
        sumAnimateButtonTap(equalJiLuButton) {
            let jiluVC = JiLuViewC()
            jiluVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(jiluVC, animated: true)
        }
    }
}

// MARK: - Animations
extension ZhuCaiDanViewC {
    func sumAddAnimations() {
        // 按钮依次出现动画
        let buttons = [equalDaoJiShiModeButton, equalWuXianModeButton, equalGuiZeButton, equalJiLuButton]
        for (index, button) in buttons.enumerated() {
            button.alpha = 0
            button.transform = CGAffineTransform(translationX: -50, y: 0)
            
            UIView.animate(withDuration: 0.6, delay: 0.2 + Double(index) * 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: [], animations: {
                button.alpha = 1
                button.transform = .identity
            })
        }
    }
    
    func sumAnimateButtonTap(_ button: UIButton, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = .identity
            }) { _ in
                completion()
            }
        }
    }
}


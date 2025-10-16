//
//  JiLuViewController.swift
//  Equals
//
//  Created by Zhao on 2025/10/15.
//

import UIKit
import SnapKit

class JiLuViewC: UIViewController {
    
    // MARK: - Properties
    let equalBeiJingImageView = UIImageView()
    let equalMengCengView = UIView()
    let equalFanHuiButton = UIButton(type: .custom)
    
    let equalClearButton = UIButton(type: .custom)
    let equalTableView = UITableView()
    let equalEmptyLabel = UILabel()
    var equalJiLuList: [YouXiJiLu] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sumSetupUI()
        sumSetupConstraints()
        sumLoadData()
        sumAddAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        sumLoadData()
    }
}

// MARK: - UI Setup
extension JiLuViewC {
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
        
       
        
        // 清除按钮
        equalClearButton.setTitle("Clear All", for: .normal)
        equalClearButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        equalClearButton.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 0.9)
        equalClearButton.layer.cornerRadius = 15
        equalClearButton.addTarget(self, action: #selector(sumClearAction), for: .touchUpInside)
        view.addSubview(equalClearButton)
        
        // TableView
        equalTableView.backgroundColor = .clear
        equalTableView.separatorStyle = .none
        equalTableView.delegate = self
        equalTableView.dataSource = self
        equalTableView.register(JiLuTableViewCell.self, forCellReuseIdentifier: "JiLuCell")
        view.addSubview(equalTableView)
        
        // 空状态标签
        equalEmptyLabel.text = "No game records yet.\nPlay some games to see your history!"
        equalEmptyLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        equalEmptyLabel.textColor = .white
        equalEmptyLabel.textAlignment = .center
        equalEmptyLabel.numberOfLines = 0
        equalEmptyLabel.isHidden = true
        view.addSubview(equalEmptyLabel)
    }
}

// MARK: - Constraints
extension JiLuViewC {
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
        
        
        
        equalClearButton.snp.makeConstraints { make in
            make.right.equalTo(equalMengCengView).offset(-20)
            make.top.equalTo(equalMengCengView).offset(25)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        
        equalTableView.snp.makeConstraints { make in
            make.left.equalTo(equalMengCengView).offset(20)
            make.right.equalTo(equalMengCengView).offset(-20)
            make.top.equalTo(equalMengCengView.snp.top).offset(70)
            make.bottom.equalTo(equalMengCengView).offset(-20)
        }
        
        equalEmptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-60)
        }
    }
}

// MARK: - Data
extension JiLuViewC {
    func sumLoadData() {
        equalJiLuList = YouXiJiLuGuanLi.shared.sumLoadRecords()
        equalTableView.reloadData()
        equalEmptyLabel.isHidden = !equalJiLuList.isEmpty
        equalClearButton.isHidden = equalJiLuList.isEmpty
    }
}

// MARK: - Actions
extension JiLuViewC {
    @objc func sumFanHuiAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func sumClearAction() {
        let alert = UIAlertController(
            title: "Clear History",
            message: "Are you sure you want to delete all game records?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive) { _ in
            YouXiJiLuGuanLi.shared.sumClearRecords()
            self.sumLoadData()
        })
        
        present(alert, animated: true)
    }
}

// MARK: - Animations
extension JiLuViewC {
    func sumAddAnimations() {
        equalTableView.alpha = 0
        
        UIView.animate(withDuration: 0.6, delay: 0.2, options: [], animations: {
            self.equalTableView.alpha = 1
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension JiLuViewC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return equalJiLuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JiLuCell", for: indexPath) as! JiLuTableViewCell
        let record = equalJiLuList[indexPath.row]
        cell.sumConfigure(with: record, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: - JiLuTableViewCell
class JiLuTableViewCell: UITableViewCell {
    
    let equalContainerView = UIView()
    let equalRankLabel = UILabel()
    let equalModeLabel = UILabel()
    let equalScoreLabel = UILabel()
    let equalTimeLabel = UILabel()
    let equalAccuracyLabel = UILabel()
    let equalDateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sumSetupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sumSetupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        equalContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        equalContainerView.layer.cornerRadius = 15
        equalContainerView.layer.borderWidth = 1
        equalContainerView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        contentView.addSubview(equalContainerView)
        
        equalRankLabel.font = UIFont.boldSystemFont(ofSize: 16)
        equalRankLabel.textColor = UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1.0)
        equalRankLabel.textAlignment = .center
        equalContainerView.addSubview(equalRankLabel)
        
        equalModeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        equalModeLabel.textColor = .white
        equalContainerView.addSubview(equalModeLabel)
        
        equalScoreLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        equalScoreLabel.textColor = UIColor(red: 0.5, green: 1.0, blue: 0.5, alpha: 1.0)
        equalContainerView.addSubview(equalScoreLabel)
        
        equalTimeLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        equalTimeLabel.textColor = .white
        equalContainerView.addSubview(equalTimeLabel)
        
        equalAccuracyLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        equalAccuracyLabel.textColor = .white
        equalContainerView.addSubview(equalAccuracyLabel)
        
        equalDateLabel.font = UIFont.systemFont(ofSize: 14)
        equalDateLabel.textColor = UIColor.secondaryLabel
        equalDateLabel.textAlignment = .right
        equalContainerView.addSubview(equalDateLabel)
        
        equalContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        }
        
        equalRankLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        
        equalModeLabel.snp.makeConstraints { make in
            make.left.equalTo(equalRankLabel.snp.right).offset(8)
            make.top.equalToSuperview().offset(15)
        }
        
        equalScoreLabel.snp.makeConstraints { make in
            make.left.equalTo(equalModeLabel)
            make.top.equalTo(equalModeLabel.snp.bottom).offset(8)
        }
        
        equalTimeLabel.snp.makeConstraints { make in
            make.left.equalTo(equalModeLabel)
            make.top.equalTo(equalScoreLabel.snp.bottom).offset(5)
        }
        
        equalAccuracyLabel.snp.makeConstraints { make in
            make.left.equalTo(equalTimeLabel.snp.right).offset(20)
            make.centerY.equalTo(equalTimeLabel)
        }
        
        equalDateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
        }
    }
    
    func sumConfigure(with record: YouXiJiLu, index: Int) {
        equalRankLabel.text = "\(index + 1)"
        
        if index == 0 {
            equalRankLabel.text = "🥇"
        } else if index == 1 {
            equalRankLabel.text = "🥈"
        } else if index == 2 {
            equalRankLabel.text = "🥉"
        }
        
        equalModeLabel.text = record.equalMode
        equalScoreLabel.text = "Score: \(record.equalScore)"
        equalTimeLabel.text = "Time: \(record.equalTime)s"
        equalAccuracyLabel.text = "Accuracy: \(record.equalAccuracy)%"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        equalDateLabel.text = formatter.string(from: record.equalDate)
        
        // 入场动画
        alpha = 0
        transform = CGAffineTransform(translationX: -30, y: 0)
        UIView.animate(withDuration: 0.4, delay: Double(index) * 0.05, options: [], animations: {
            self.alpha = 1
            self.transform = .identity
        })
    }
}


//
//  YouXiJiLuGuanLi.swift
//  Equals
//
//  Created by Zhao on 2025/10/15.
//

import Foundation

struct YouXiJiLu: Codable {
    let equalMode: String
    let equalScore: Int
    let equalTime: Int
    let equalAccuracy: Int
    let equalDate: Date
}

class YouXiJiLuGuanLi {
    static let shared = YouXiJiLuGuanLi()
    
    let equalUserDefaultsKey = "GameRecords"
    
    func sumSaveRecord(mode: YouXiMode, score: Int, time: Int, accuracy: Int) {
        let modeString = mode == .daoJiShi ? "Timed Mode" : "Endless Mode"
        let record = YouXiJiLu(
            equalMode: modeString,
            equalScore: score,
            equalTime: time,
            equalAccuracy: accuracy,
            equalDate: Date()
        )
        
        var records = sumLoadRecords()
        records.insert(record, at: 0)
        
        // 只保留最近50条记录
        if records.count > 50 {
            records = Array(records.prefix(50))
        }
        
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: equalUserDefaultsKey)
        }
    }
    
    func sumLoadRecords() -> [YouXiJiLu] {
        guard let data = UserDefaults.standard.data(forKey: equalUserDefaultsKey),
              let records = try? JSONDecoder().decode([YouXiJiLu].self, from: data) else {
            return []
        }
        return records
    }
    
    func sumClearRecords() {
        UserDefaults.standard.removeObject(forKey: equalUserDefaultsKey)
    }
    
    func sumGetBestScore(mode: YouXiMode) -> Int {
        let modeString = mode == .daoJiShi ? "Timed Mode" : "Endless Mode"
        let records = sumLoadRecords().filter { $0.equalMode == modeString }
        return records.map { $0.equalScore }.max() ?? 0
    }
}


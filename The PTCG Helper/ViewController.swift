//
//  ViewController.swift
//  The PTCG Helper
//
//  Created by Ross Chang on 25/03/2024.
//

import UIKit

class ViewController: UIViewController {
    
    var timer: Timer?
    var startTime: Date? // 添加一個起始時間的變量
    var totalTime = 2100 // 35分鐘 * 60秒
 
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var pauseBtn: UIButton!
    @IBOutlet weak var theTimer: UILabel!
    
    @IBOutlet weak var resetActionsButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        theTimer.text="點我選時間"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resetTimer))
        theTimer.isUserInteractionEnabled = true
        theTimer.addGestureRecognizer(tapGesture)
        
        // 检查当前iOS版本是否支持使用SF Symbols
        if #available(iOS 17.0, *) {
            // iOS 13.0 或更高版本，可以使用 SF Symbols
        } else {
            // iOS版本低于17.0，使用文本替代
            resetActionsButton.setTitle("重置", for: .normal)
        }
        
        
    }
    
    func startTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil // 這裡再次確保計時器被停止並設為nil
        }
        // 計算剩餘時間並開始計時
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    
    @objc func updateTimer() {
        if let startTime = startTime {
            let currentTime = Date()
            let elapsedTime = currentTime.timeIntervalSince(startTime)
            let remainingTime = max(totalTime - Int(elapsedTime), 0) // 確保剩餘時間不會小於0
            
            if remainingTime > 0 {
                theTimer.text = formatTime(remainingTime)
            } else {
                timer?.invalidate()
                theTimer.text = "Time's Up!"
            }
        }
    }
    
    func formatTime(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //重設計時器
    var whichGroup = 0;
    @objc func resetTimer() {
        timer?.invalidate() // 停止計時器
        if (whichGroup%3==0){
            totalTime = 1500 // 重設為25分鐘
            theTimer.text="25:00"
        }else if (whichGroup%3==1){
            totalTime = 1800 // 重設為30分鐘
            theTimer.text="30:00"
        }else{
            totalTime = 2100 // 重設為35分鐘
            theTimer.text="35:00"
        }
        whichGroup+=1
        updateDisplay() // 更新顯示
        startBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        pauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
    }
    
    func updateDisplay() {
        let formattedTime = formatTime(totalTime)
        theTimer.text = formattedTime // 更新標籤顯示剩餘時間
    }
    
    
    // 暫定按鈕
    var isPaused = false
    var pausedTime = 0
    // 暫停/恢復按鈕被點擊
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if isPaused {
            // 恢复计时
            continueTimer()
        } else {
            // 暂停计时
            if let startTime = self.startTime {
                let currentTime = Date()
                pausedTime = totalTime - Int(currentTime.timeIntervalSince(startTime))
                timer?.invalidate() // 暂停计时器
                isPaused = true
                pauseBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
            }
        }
    }

    // 继续计时器的方法
    func continueTimer() {
        // 根据pausedTime开始计时
        totalTime = pausedTime // 设置剩余时间
        startTimer() // 重新开始计时
        isPaused = false
        pauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
    }



    
    //開始按鈕
    var isPlay = false
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isPlay {
            // 如果計時器正在運行，則停止計時器
            timer?.invalidate()
            timer = nil
            isPlay = false
            startBtn.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            // 如果計時器未運行，則開始計時器
            startTimer()
            isPlay = true
            startBtn.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            pauseBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }


    
    //動作按鈕
    var isRetreat = false
    var isSupporter = false
    var isEnergy = false
    
    func setButtonBorder(button: UIButton) {
        button.layer.borderWidth = 2.0 // 设置边框宽度
        button.layer.borderColor = UIColor.white.cgColor // 设置边框颜色为白色
        button.layer.cornerRadius = 5.0 // 如果需要的话，设置按钮圆角
    }
    
    func cancelButtonBorder(button: UIButton) {
        button.layer.borderWidth = 0 // 设置边框宽度
    }
    
    @IBOutlet weak var retreatButton: UIButton!
    @IBAction func retreatButtonTapped(_ sender: UIButton) {
        isRetreat.toggle() // 簡化狀態切換的寫法

        if isRetreat {
            // 設置按鈕為白色背景，黑色文字
          //  retreatButton.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7764705882, alpha: 1)
            setButtonBorder(button: retreatButton)
        } else {
            // 還原按鈕顏色或設置為其他顏色
            retreatButton.backgroundColor = nil // 移除自訂背景色
            cancelButtonBorder(button: retreatButton)
        }
    }
    
    
    @IBOutlet weak var supporterButton: UIButton!
    @IBAction func supporterButtonTapped(_ sender: UIButton) {
        isSupporter.toggle() // 簡化狀態切換的寫法
        
        if isSupporter {
            // 設置按鈕為白色背景，黑色文字
           // supporterButton.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7764705882, alpha: 1)
            setButtonBorder(button: supporterButton)
        } else {
            // 還原按鈕顏色或設置為其他顏色
            supporterButton.backgroundColor = nil // 移除自訂背景色
            cancelButtonBorder(button: supporterButton)
        }
    }
    
    @IBOutlet weak var energyButton: UIButton!
    @IBAction func energyButtonTapped(_ sender: UIButton) {
        isEnergy.toggle() // 簡化狀態切換的寫法

        if isEnergy {
            // 設置按鈕為白色背景，黑色文字
          //  energyButton.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7764705882, alpha: 1)
            setButtonBorder(button: energyButton)
        } else {
            // 還原按鈕顏色或設置為其他顏色
            energyButton.backgroundColor = nil // 移除自訂背景色
            cancelButtonBorder(button: energyButton)
        }
    }
    
    
    //重設動作按鈕
    @IBAction func resetActionsButton(_ sender: UIButton) {
        isRetreat = false
        isSupporter = false
        isEnergy = false
        retreatButton.backgroundColor = nil // 移除自訂背景色
        supporterButton.backgroundColor = nil // 移除自訂背景色
        energyButton.backgroundColor = nil // 移除自訂背景色
        cancelButtonBorder(button: energyButton)
        cancelButtonBorder(button: supporterButton)
        cancelButtonBorder(button: retreatButton)
    }
    
    
    
}


//
//  ViewModel.swift
//  TimerApp
//
//  Created by Norris Wise Jr on 10/14/24.
//

import Foundation


class ViewModel: ObservableObject {
	
	private var timer: Timer?
	private var didStartTimer: Bool = false
	private var automationTimer: Timer!
	@Published var currentLapTimeReable: String = "00:00:00:00"
	@Published var totalRunTimeReadable: String = "00:00:00:00"
	private var totalCentiSeconds: Double = .zero
	private var totalLapCentiSeconds: Double = .zero
	@Published var lapsAry: [String] = ["00:00:00:00"]
	@Published var shouldReportLaps = false
	@Published var startBtnTitle = "Start"
	@Published var stopBtnTitle2 = "Stop"
	

	
	func createTimer() {
		guard self.timer == nil else { return }
		let timer = Timer.init(timeInterval: TimeInterval(0.001), target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
		timer.tolerance = 0.1
		self.timer = timer
	}
	func startTimer() {
		if timer == nil {
			createTimer()
		}
		guard let timer else {
			print("Error: Timer is missing (nil). ")
			return
		}
		if didStartTimer {
			print("new lap...")
			self.shouldReportLaps = true
			startNewLap()
		} else {
			
			self.didStartTimer = true
			self.startBtnTitle = "Lap"
			self.stopBtnTitle2 = "Stop"
			RunLoop.main.add(timer, forMode: .common)
		}
	}
	
	func stopTimer() {
		if stopBtnTitle2.lowercased() == "reset" {
			resetTimer()
		}
		guard totalLapCentiSeconds != .zero else {
			return
		}
		
		self.timer?.invalidate()
		self.destroyTimer()
		self.didStartTimer = false
		self.startBtnTitle = "Start"
		self.stopBtnTitle2 = "Reset"
		
	}
	
	func resetTimer() {
		self.totalLapCentiSeconds = .zero
		self.totalCentiSeconds = .zero
		self.currentLapTimeReable = "00:00:00:00"
		self.totalRunTimeReadable = "00:00:00:00"
		self.shouldReportLaps = false
		self.lapsAry = []
	}
	
	func destroyTimer() {
		self.timer = nil
	}

	func startNewLap() {
		let oldLapTimeReadable = self.currentLapTimeReable
		self.totalLapCentiSeconds = .zero
		if self.lapsAry.count > 0 {
			self.lapsAry.removeLast()
		}
		self.lapsAry.append(oldLapTimeReadable)
		self.lapsAry.append(self.currentLapTimeReable)
	}
	
	
	func incrementLap(timerInterval: TimeInterval) {
		let lapInterval = Double(timerInterval)
		//set readable current lap time
		self.totalLapCentiSeconds = self.totalLapCentiSeconds + lapInterval
		
		// time break down
		let lapCentiSeconds = Int(self.totalLapCentiSeconds * 100) % 100
		let lapSeconds = Int(self.totalLapCentiSeconds * 100) / 100
		let lapMinutes = lapSeconds / 60
		let lapHours = lapMinutes / 60
		self.currentLapTimeReable = "\(lapHours):\(lapMinutes):\(lapSeconds):\(lapCentiSeconds)"
		print("currentLapTimeReadable: \(self.currentLapTimeReable)")
	}
	func incrementTotalRunTime(_ timerInterval: TimeInterval) {
		let interval = Double(timerInterval)
		self.totalCentiSeconds = self.totalCentiSeconds + interval
		
		//time break down
		let centiSeconds = Int(self.totalCentiSeconds * 100) % 100
		let seconds = Int(self.totalCentiSeconds * 100) / 100
		let minutes = seconds / 60
		let hours = minutes / 60

		//set readable total run time
		self.totalRunTimeReadable = "\(hours):\(minutes):\(seconds):\(centiSeconds)"
		print("totalRunTimeReadable: \(self.totalRunTimeReadable)")
//		print("raw time: \(Int(self.totalCentiSeconds * 100) % 100)")
	}
	func getLaps() -> [String] {
		print("lapsAry: \(lapsAry)")
		return lapsAry
	}
	func updateLapsAryWithLapTime() {
		guard self.lapsAry.count > 0 else {
			print("No laps ary. Not updating...")
			self.shouldReportLaps = false
			return
		}
		self.lapsAry[self.lapsAry.count - 1] = self.currentLapTimeReable
	}
}

//MARK: - Target / Action Responder
extension ViewModel {
	@objc func fireTimer() {
		guard let timer = timer else { return }
		print("interval: \(timer.timeInterval)")
		//increment total run time
		self.incrementTotalRunTime(timer.timeInterval)
		self.incrementLap(timerInterval: timer.timeInterval)
		self.updateLapsAryWithLapTime()
	}
	
}
	


//
//  ContentView.swift
//  TimerApp
//
//  Created by Norris Wise Jr on 10/13/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@ObservedObject var viewModel: ViewModel = ViewModel()
	
    var body: some View {
		VStack {
			VStack(spacing: 0) {
				
				ZStack() {
					Color.black
					Text(viewModel.totalRunTimeReadable)
						.font(.largeTitle)
						.foregroundStyle(Color.white)
						
				}
					
				HStack() {
					Spacer()
					Button(action: {
						viewModel
							.stopTimer()
					}, label: {
						Text(viewModel.stopBtnTitle2)
							.font(.title3)
							.foregroundStyle(Color.white)
							.fontWeight(.bold)
					})
					Spacer()
					Button(action: {
						viewModel
							.startTimer()
					}, label: {
						Text(viewModel.startBtnTitle)
							.font(.title3)
							.foregroundStyle(Color.white)
							.fontWeight(.bold)
					})
					
					Spacer()
				}
				.padding(EdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 0))
				
				.background(Color.black)
				
			}
		
			List(viewModel.lapsAry, id: \.self) { lapTime in
				Text(lapTime)
					.font(.largeTitle)
					.foregroundStyle(Color.white)
					.listRowBackground(Color.black)
					.padding()
					.listRowSeparator(.visible)
					.listRowSeparatorTint(.white)
			}
			.opacity(viewModel.shouldReportLaps ? 1 : 0)
			
		}
		
		.onDisappear(perform: {
			viewModel
				.stopTimer()
			viewModel.destroyTimer()
		})
		
	}
		
		
}

#Preview {
    ContentView()
        
}


//Build one timer, display run time on screen
//Build one item in a list view, display time on screen




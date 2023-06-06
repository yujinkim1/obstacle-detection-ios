//
//  Labeler.swift
//  ObstacleDetection
//
//  Created by Yujin Kim
//
import SwiftUI

class Labeler {
	
	///- 감지하는 장애물의 class를 레이블링 하기 위해 해당 labels 배열을 사용합니다.
	let labels = [
		"bicycle", /// [0 : 3640]
		"bus", /// [1 : 2844]
		"car", /// [2 : 44544]
		"carrier", /// [3 : 1595]
		"motorcycle", /// [4 : 3772]
		"movable_signage", /// [5 : 8305]
		"person", /// [6 : 30547]
		"scooter", /// [7 : 1043]
		"stroller", /// [8 : 1330]
		"truck", /// [9 : 7841]
		"wheelchair", /// [10 : 1171]
		"barricade", /// [11 : 970]
		"bench", /// [12 : 1554]
		"bollard", /// [13 : 17753]
		"chair", /// [14 : 2363]
		"fire_hydrant", /// [15 : 999]
		"kiosk", /// [16 : 1047]
		"pole", /// [17 : 22968]
		"potted_plant", /// [18 : 4333]
		"power_controller", /// [19 : 1451]
		"stop", /// [20 : 1149]
		"table", /// [21 : 1063]
		"traffic_light", /// [22 : 9424]
		"traffic_light_controller", /// [23 : 972]
		"traffic_sign", /// [24 : 10706]
		"tree_trunk" /// [25 : 24963]
	]
	
	private var colorMapping: [String: Color] = [:]
	
	init() {
		generateLabelColors()
	}
	
	private func generateLabelColors() {
		for label in labels {
			let color = UIColor(
				red: CGFloat.random(in: 0...1),
				green: CGFloat.random(in: 0...1),
				blue: CGFloat.random(in: 0...1),
				alpha: 1.0
			)
			colorMapping[label] = Color(color)
		}
	}
	
	func color(forLabel label: String) -> Color {
		return colorMapping[label] ?? Color.black
	}
}

//
//  DetectionOverlayView.swift
//  ObstacleDetection
//
//  Created by Yujin Kim
//

import SwiftUI

struct DetectionOverlay: View {
	@ObservedObject var detector: Detector
	let labeler = Labeler()
	
	var body: some View {
		GeometryReader {
			geometry in
			ZStack {
				ForEach(detector.detectionResults, id: \.uuid) {
					observation in
					let boundingBox = observation.boundingBox
					let firstLabel = observation.labels.first
					let strokeColor = labeler.color(forLabel: firstLabel?.identifier ?? "")
					
					let rect = CGRect(
						x: CGFloat(boundingBox.minX) * geometry.size.width,
						y: (1 - CGFloat(boundingBox.maxY)) * geometry.size.height,
						width: CGFloat(boundingBox.width) * geometry.size.width,
						height: CGFloat(boundingBox.height) * geometry.size.height
					)
					
					RoundedRectangle(cornerRadius: 1.0)
						.stroke(strokeColor, lineWidth: 2.0)
						.frame(
							width: rect.size.width,
							height: rect.size.height
						)
						.offset(
							x: rect.midX,
							y: rect.midY
						)
					
					Text("\(firstLabel?.identifier ?? "unknown") \(String(format: "%.2f", firstLabel?.confidence ?? 0.00))")
						.foregroundColor(.white)
						.fontWeight(.bold)
						.background(strokeColor)
						.cornerRadius(1.0)
						.offset(
							x: rect.minX + (rect.size.width / 2),
							y: rect.minY - (rect.size.height / 2)
						)
				}
			}
		}
	}
}


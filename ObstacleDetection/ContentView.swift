//
//  ContentView.swift
//  ObstacleDetection
//
//  Created by Yujin Kim
//

import SwiftUI

struct ContentView: View {
	@StateObject var detector = Detector()
	
    var body: some View {
		VStack {
			Button(action: {
				detector.toggleDetection()
			}) {
				Text(detector.isDetectionActivate ? "Turn off" : "Turn on")
			}
		}
		ZStack {
			CameraView(detector: detector)
			DetectionOverlay(detector: detector)
		}
		.edgesIgnoringSafeArea(.all)
    }
}

//#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//		VStack {
//			Text("ContentView: PreviewView")
//		}
//    }
//}
//#endif

//
//  Detector.swift
//  ObstacleDetection
//
//  Created by Yujin Kim
//

import SwiftUI
import AVFoundation
import CoreML
import Vision

class Detector: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
	
	/// 사전 학습된 모델을 불러오기 위한 변수입니다.
	private var visionModel: VNCoreMLModel?
	
	/// NSObject 핸들러를 생성하기 위한 변수입니다.
	private var requestHandler = VNSequenceRequestHandler()
	
	/// 카메라 모듈 세션을 생성하기 위한 변수입니다.
	private var captureSession = AVCaptureSession()
	
	/// 객체 감지의 predictions를 수정하기 위한 값을 정의합니다.
	//private var iou: Double = 0.4
	//private var confidence: Double = 0.5
	
	/// 객체 감지 결과를 반환하고 화면에 적용하기 위한 변수입니다.
	@Published var detectionResults: [VNRecognizedObjectObservation] = []
	
	/// 객체 감지를 수동으로 온오프 할 수 있도록하기 위한 변수입니다.
	@Published var isDetectionActivate = false
	
	override init() {
		super.init()
		loadModel()
	}
	
	private func loadModel() {
		do {
			let modelUrl = Bundle.main.url(forResource: "YOLOv3Tiny", withExtension: "mlmodelc")
			let config = MLModelConfiguration()
			visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelUrl!, configuration: config))
		} catch {
			print("Failed to loading vision model: \(error)")
		}
	}
	
	func toggleDetection() {
		isDetectionActivate.toggle()
	}
	
	func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
		guard isDetectionActivate else { return }
		
		guard let model = visionModel, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
		
		let request = VNCoreMLRequest(model: model) {
			request, error in
			if let error = error {
				print("Error during obstacle detection: \(error)")
			} else {
				DispatchQueue.main.sync {
					self.detectionResults = request.results as? [VNRecognizedObjectObservation] ?? []
					print("객체 감지 결과: \(self.detectionResults)")
				}
			}
		}
		
		do {
			try requestHandler.perform([request], on: pixelBuffer)
		} catch {
			print("Error performing obstacle detection: \(error)")
		}
	}
}


//
//  CameraView.swift
//  ObstacleDetection
//
//  Created by Yujin Kim
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
	
	@ObservedObject var detector: Detector
	
	/// 카메라 뷰를 생성합니다.
	func makeUIView(context: Context) -> UIView {
		
		let view = UIView()
		view.backgroundColor = .clear
		
		context.coordinator.checkPermission { granted in
			if granted {
				context.coordinator.setupCaptureSession()
			} else {
				print("Camera access denied!")
			}
		}
		
		let previewLayer = AVCaptureVideoPreviewLayer(session: context.coordinator.captureSession )
		previewLayer.videoGravity = .resizeAspectFill
		view.layer.addSublayer(previewLayer)
		context.coordinator.previewLayer = previewLayer
		
		DispatchQueue.main.async {
			previewLayer.frame = view.bounds
		}
		
		return view
	}
	
	/// 화면을 업데이트 합니다.
	func updateUIView(_ uiView: UIView, context: Context) {
		guard let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer else { return }
		previewLayer.frame = uiView.bounds
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(detector: detector)
	}
	
	/// 실시간 객체 감지를 위한 클래스입니다.
	class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
		var captureSession: AVCaptureSession = AVCaptureSession()
		var previewLayer: AVCaptureVideoPreviewLayer?
		var detector: Detector
		
		init(detector: Detector) {
			self.detector = detector
			super.init()
		}
		
		/// 카메라 사용 권한 여부를 확인하고 이에 대한 케이스를 처리합니다.
		func checkPermission(completion: @escaping (Bool) -> Void) {
			switch AVCaptureDevice.authorizationStatus(for: .video) {
				case .authorized:
					completion(true)
				case .notDetermined:
					AVCaptureDevice.requestAccess(for: .video) {
						granted in
						completion(granted)
					}
				default:
					completion(false)
			}
		}
		
		/// 카메라 세션을 시작합니다.
		func setupCaptureSession() {
			
			guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return }
			
			do {
				let input = try AVCaptureDeviceInput(device: device)
				captureSession.addInput(input)
			} catch let error{
				print(error.localizedDescription)
			}
			
			captureSession.sessionPreset = .vga640x480
			
			let output = AVCaptureVideoDataOutput()
			output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "CMSampleBufferQueue"))
			captureSession.addOutput(output)
			
			DispatchQueue.global(qos: .userInitiated).async {
				self.captureSession.startRunning()
			}
		}
		
		func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
			detector.captureOutput(output, didOutput: sampleBuffer, from: connection)
		}
	}
}

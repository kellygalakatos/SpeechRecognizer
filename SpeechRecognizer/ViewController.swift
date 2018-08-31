//
//  ViewController.swift
//  SpeechRecognizer
//
//  Created by Kelly Galakatos on 8/31/18.
//  Copyright © 2018 Kelly Galakatos. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var textLabel: UILabel!
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            return print(error)
        }
        
        
        guard let myRecognizer = SFSpeechRecognizer() else { return }
        if !myRecognizer.isAvailable { return }
        
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: {result, error in
            
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.textLabel.text = bestString
            } else if let error = error {
                print(error)
            }
        })
        
    }

    @IBAction func startButtonClicked(_ sender: Any) {
        self.recordAndRecognizeSpeech()
    }
    
}


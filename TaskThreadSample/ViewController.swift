//
//  ViewController.swift
//  TaskThreadSample
//
//  Created by Akira Matsuda on 2023/05/26.
//

import UIKit

protocol AsyncProtocol {
    static func asyncProtocolMethod() async
}

@MainActor
protocol MainActorProtocol {
    static func mainActorProtocolMethod() async
}

class AsyncClass: AsyncProtocol {
    static func asyncProtocolMethod() async {
        print("\(Thread.current.isMainThread): AsyncClass.asyncProtocolMethod")
    }
}

class MainActorClass: MainActorProtocol {
    static func mainActorProtocolMethod() async {
        print("\(Thread.current.isMainThread): MainActorClass.asyncProtocolMethod")
    }
}

struct AsyncStruct {
    static func asyncMethod() async {
        print("\(Thread.current.isMainThread): AsyncStruct.asyncMethod")
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func asyncMethod() async {
        print("\(Thread.current.isMainThread): asyncMethod")
    }

    @IBAction func startTask(_ sender: Any) {
        print("--------------")
        Task {
            activityIndicator.startAnimating()
            print("\(Thread.current.isMainThread): Start task")
            globalSyncMethod()
            await globalAsyncMethod()
            syncMethod()
            await asyncMethod()
            await extensionAsyncMethod()
            await AsyncStruct.asyncMethod()
            await AsyncClass.asyncProtocolMethod()
            await MainActorClass.mainActorProtocolMethod()
            activityIndicator.stopAnimating()
        }
    }

    @IBAction func startDetachedTask(_ sender: Any) {
        print("--------------")
        Task.detached {
            await self.activityIndicator.startAnimating()
            print("\(Thread.current.isMainThread): Start detached task")
            globalSyncMethod()
            await globalAsyncMethod()
            await self.syncMethod()
            await self.asyncMethod()
            await self.extensionAsyncMethod()
            await AsyncStruct.asyncMethod()
            await AsyncClass.asyncProtocolMethod()
            await MainActorClass.mainActorProtocolMethod()
            await self.activityIndicator.stopAnimating()
        }
    }

    @IBAction func startDetachedMainActorTask(_ sender: Any) {
        print("--------------")
        Task.detached { @MainActor in
            self.activityIndicator.startAnimating()
            print("\(Thread.current.isMainThread): Start detached MainActor task")
            globalSyncMethod()
            await globalAsyncMethod()
            self.syncMethod()
            await self.asyncMethod()
            await self.extensionAsyncMethod()
            await AsyncStruct.asyncMethod()
            await AsyncClass.asyncProtocolMethod()
            await MainActorClass.mainActorProtocolMethod()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func syncMethod() {
        print("\(Thread.current.isMainThread): syncMethod")
    }
}

func globalSyncMethod() {
    print("\(Thread.current.isMainThread): globalSyncMethod")
}

func globalAsyncMethod() async {
    print("\(Thread.current.isMainThread): globalAsyncMethod")
}

extension ViewController {
    func extensionAsyncMethod() async {
        print("\(Thread.current.isMainThread): extensionAsyncMethod")
    }
}

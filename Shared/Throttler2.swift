//
//  Throttler2.swift
//  Tidy iOS
//
//  Created by Chris Danford on 2/4/19.
//  Copyright © 2019 Chris Danford. All rights reserved.
//

import Foundation

public class Throttler2 {
    private let maxFrequency: TimeInterval
    private let block: () -> ()

    private let queue: DispatchQueue = DispatchQueue(label: "Throttler")
    private var lastExecutionFinished: Date = Date.distantPast
    private var executionIsPending = false

    init(maxFrequency: TimeInterval, block: @escaping () -> ()) {
        self.maxFrequency = maxFrequency
        self.block = block
    }
    
    func executeThrottled() {
        self.queue.sync {
            if !executionIsPending {
                executionIsPending = true

                let timeSince = self.lastExecutionFinished.timeIntervalSinceNow * -1
                let delay = timeSince < self.maxFrequency ? self.maxFrequency - timeSince : 0

                DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                    self.block()
                    self.queue.async {
                        self.executionIsPending = false
                        self.lastExecutionFinished = Date()
                    }
                }
            }
                
//            }
//            self.job = job
            //NSLog("timeSincelastExecutionFinished \(timeSincelastExecutionFinished), delay \(delay)")
        }
    }
}

func throttle(maxFrequency: TimeInterval, block: @escaping () -> Void) -> () -> Void {
    let throttler = Throttler2(maxFrequency: maxFrequency, block: block)
    return {
        throttler.executeThrottled()
    }
}
//
//private extension Date {
//    static func second(from referenceDate: Date) -> Int {
//        return Int(Date().timeIntervalSince(referenceDate).rounded())
//    }
//}


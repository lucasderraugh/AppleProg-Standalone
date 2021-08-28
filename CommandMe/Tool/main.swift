//
//  main.swift
//  Tool
//
//  Created by Lucas Derraugh on 7/29/21.
//

import Foundation

guard let messagePort = CFMessagePortCreateRemote(nil, "com.lucasderraugh.CommandMe" as CFString) else {
    print("No local message port with the given bundle id")
    exit(1)
}

var unmanagedData: Unmanaged<CFData>? = nil
let status = CFMessagePortSendRequest(messagePort, 0, Data("Hello!!!".utf8) as CFData, 3.0, 3.0, CFRunLoopMode.defaultMode.rawValue, &unmanagedData)
let cfData = unmanagedData?.takeRetainedValue()
if status == kCFMessagePortSuccess {
    if let data = cfData as Data?,
       let string = String(data: data, encoding: .utf8) {
        print(string)
    } else {
        print("Couldn't convert data")
    }
} else {
    print(status)
}

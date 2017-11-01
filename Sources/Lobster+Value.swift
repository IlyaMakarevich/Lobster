//
//  Lobster+Value.swift
//  Lobster
//
//  Created by suguru-kishimoto on 2017/11/01.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit
import FirebaseRemoteConfig

extension Lobster {
    public func set<ValueType>(_ value: ValueType?, forKey key: CodableConfigKey<ValueType>) throws {
        guard let value = value else {
            defaults[key._key] = nil
            updateDefaults()
            return
        }

        let data = try key.encoder.encode(value)
        switch key.dataType {
        case .rawData:
            defaults[key._key] = data as NSData
        case .json(let encoding):
            guard let json = String(data: data, encoding: encoding) else { return }
            defaults[key._key] = json as NSString
        }
        updateDefaults()
    }

    public func set(_ value: String?, forKey key: ConfigKey<String>) {
        defaults[key._key] = value.map { $0 as NSString }
        updateDefaults()
    }

    public func set(_ value: Int?, forKey key: ConfigKey<Int>) {
        defaults[key._key] = value.map { $0 as NSNumber }
        updateDefaults()
    }

    public func set(_ value: Double?, forKey key: ConfigKey<Double>) {
        defaults[key._key] = value.map { $0 as NSNumber }
        updateDefaults()
    }

    public func set(_ value: Float?, forKey key: ConfigKey<Float>) {
        defaults[key._key] = value.map { $0 as NSNumber }
        updateDefaults()
    }

    public func set(_ value: Bool?, forKey key: ConfigKey<Bool>) {
        defaults[key._key] = value.map { $0 as NSNumber }
        updateDefaults()
    }

    public func set(_ value: Data?, forKey key: ConfigKey<Data>) {
        defaults[key._key] = value.map { $0 as NSData }
        updateDefaults()
    }

    public func set(_ value: URL?, forKey key: ConfigKey<URL>) {
        defaults[key._key] = value.map { $0.absoluteString as NSString }
        updateDefaults()
    }

    public func set(_ value: UIColor?, forKey key: ConfigKey<UIColor>) {
        defaults[key._key] = value.map { $0.hexString as NSString }
        updateDefaults()
    }
}

extension Lobster {
    public func value<ValueType>(forKey key: DecodableConfigKey<ValueType>) throws -> ValueType? {
        let data: Data? = {
            switch key.dataType {
            case .rawData: return RemoteConfig.remoteConfig()[key._key].dataValue
            case .json(let encoding): return RemoteConfig.remoteConfig()[key._key].stringValue?.data(using: encoding)
            }
        }()
        return try data.map { try key.decoder.decode(ValueType.self, from: $0) }
    }

    public func value(forKey key: ConfigKey<String>) -> String? {
        return RemoteConfig.remoteConfig()[key._key].stringValue
    }

    public func value(forKey key: ConfigKey<Int>) -> Int? {
        return RemoteConfig.remoteConfig()[key._key].numberValue?.intValue
    }

    public func value(forKey key: ConfigKey<Double>) -> Double? {
        return RemoteConfig.remoteConfig()[key._key].numberValue?.doubleValue
    }

    public func value(forKey key: ConfigKey<Float>) -> Float? {
        return RemoteConfig.remoteConfig()[key._key].numberValue?.floatValue
    }

    public func value(forKey key: ConfigKey<Bool>) -> Bool {
        return RemoteConfig.remoteConfig()[key._key].boolValue
    }

    public func value(forKey key: ConfigKey<Data>) -> Data {
        return RemoteConfig.remoteConfig()[key._key].dataValue
    }

    public func value(forKey key: ConfigKey<URL>) -> URL? {
        return RemoteConfig.remoteConfig()[key._key].stringValue.flatMap(URL.init(string:))
    }

    public func value(forKey key: ConfigKey<UIColor>) -> UIColor? {
        return RemoteConfig.remoteConfig()[key._key].stringValue?.hexColor
    }

    public func value(forKey key: AnyConfigKey) -> RemoteConfigValue {
        return RemoteConfig.remoteConfig()[key._key]
    }
}

extension Lobster {
    public subscript(_ key: ConfigKey<String>) -> String? {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Int>) -> Int? {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Float>) -> Float? {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Double>) -> Double? {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Bool>) -> Bool {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<Data>) -> Data {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<URL>) -> URL? {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    public subscript(_ key: ConfigKey<UIColor>) -> UIColor? {
        get { return value(forKey: key) }
        set { set(newValue, forKey: key) }
    }

    public subscript<ValueType>(_ key: DecodableConfigKey<ValueType>) -> ValueType? {
        return (try? value(forKey: key))?.flatMap { $0 }
    }

    public subscript<ValueType: Codable>(_ key: CodableConfigKey<ValueType>) -> ValueType? {
        get {
            return (try? value(forKey: key))?.flatMap { $0 }
        }
        set {
            try? set(newValue, forKey: key)
        }
    }

    private func defaultStringValue<T>(forKey key: ConfigKey<T>) -> String? {
        return (defaults[key._key] as? NSString) as String?
    }

    public subscript(default key: ConfigKey<String>) -> String? {
        return (defaults[key._key] as? NSString) as String?
    }

    public subscript(default key: ConfigKey<Int>) -> Int? {
        return (defaults[key._key] as? NSNumber)?.intValue
    }

    public subscript(default key: ConfigKey<Float>) -> Float? {
        return (defaults[key._key] as? NSNumber)?.floatValue
    }

    public subscript(default key: ConfigKey<Double>) -> Double? {
        return (defaults[key._key] as? NSNumber)?.doubleValue
    }

    public subscript(default key: ConfigKey<Bool>) -> Bool? {
        return (defaults[key._key] as? NSNumber)?.boolValue
    }

    public subscript(default key: ConfigKey<Data>) -> Data? {
        return (defaults[key._key] as? NSData) as Data?
    }

    public subscript(default key: ConfigKey<URL>) -> URL? {
        return defaultStringValue(forKey: key).flatMap(URL.init(string:))
    }

    public subscript(default key: ConfigKey<UIColor>) -> UIColor? {
        return defaultStringValue(forKey: key)?.hexColor
    }

    public subscript<ValueType>(default key: DecodableConfigKey<ValueType>) -> ValueType? {
        let data: Data? = {
            switch key.dataType {
            case .rawData: return (defaults[key._key] as? NSData) as Data?
            case .json(let encoding): return defaultStringValue(forKey: key)?.data(using: encoding)
            }
        }()
        return data.flatMap { (try? key.decoder.decode(ValueType.self, from: $0)) }
    }

    public subscript(default key: AnyConfigKey) -> Any? {
        return defaults[key._key]
    }
}
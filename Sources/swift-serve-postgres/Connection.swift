//
//  Connection.swift
//  swift-serve-postgres
//
//  Created by Andrew J Wagner on 12/5/17.
//

import Foundation
import CPostgreSQL

extension PostgresError {
    init(connection: OpaquePointer?) {
        if let message = PQerrorMessage(connection) {
            self.message = String(cString: message)
        }
        else {
            self.message = "Unknown Error"
        }
    }
}

public final class DatabaseConnection {
    fileprivate var connection: OpaquePointer?

    let host: String
    let port: Int
    let databaseName: String
    let username: String
    let password: String

    public var isConnected: Bool {
        return self.connection != nil
    }

    public init(
        host: String,
        port: Int = 5432,
        databaseName: String,
        username: String,
        password: String
        )
    {
        self.host = host
        self.port = port
        self.databaseName = databaseName
        self.username = username
        self.password = password
    }

    deinit {
        self.disconnect()
    }

    public func connect() throws {
        guard !self.isConnected else {
            return
        }

        let parameters = [
            "host": host,
            "port": "\(port)",
            "dbname": databaseName,
            "username": username,
            "password": password,
        ]
        let newConnection = withArrayOfCStrings(Array(parameters.keys)) { keywords in
            return withArrayOfCStrings(Array(parameters.values)) { values in
                return PQconnectdbParams(keywords, values, 0)
            }
        }
        guard PQstatus(newConnection) == CONNECTION_OK else {
            throw PostgresError(connection: newConnection)
        }

        self.connection = newConnection
    }

    public func disconnect() {
        guard let connection = self.connection else {
            return
        }

        PQfinish(connection)
        self.connection = nil
    }
}

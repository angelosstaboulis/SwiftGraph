//
//  main.swift
//  GraphSwift
//
//  Created by Angelos Staboulis on 19/7/23.
//

import Foundation
import GameplayKit
open class Node<T>: GKGraphNode {

    public let value: T
    
    public init(value: T) {
        self.value = value
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var description:String{
        String(describing:value)
    }
    public func addConnection(to node: GKGraphNode,
                              bidirectional: Bool = false) {
        super.addConnections(to: [node], bidirectional: bidirectional)
    }
    public func removeConnection(to node:GKGraphNode,bidirectional:Bool = false){
        super.removeConnections(to: [node], bidirectional: bidirectional)
    }
}

class Graph<T>:GKGraph {
    func findPath(from startNode: Node<T>, to endNode: Node<T>) -> [Node<T>] {
       super.findPath(from: startNode, to: endNode).compactMap { $0 as? Node }
    }
}

let nodeA = Node(value: "A")
let nodeB = Node(value: "B")
let nodeC = Node(value: "C")
let nodeD = Node(value: "D")
let nodeE = Node(value: "E")
// Make connections.
nodeA.addConnection(to: nodeB, bidirectional: true)
nodeB.addConnection(to: nodeC, bidirectional: true)
nodeC.addConnection(to: nodeB, bidirectional: true)
nodeD.addConnection(to: nodeC, bidirectional: true)
nodeE.addConnection(to: nodeA, bidirectional: true)

// Create graph.
let graph = Graph<Any>([nodeA, nodeB, nodeC,nodeD,nodeE])

// Find path.
let paths = graph.findPath(from: nodeD, to: nodeB)

debugPrint("node=",paths)


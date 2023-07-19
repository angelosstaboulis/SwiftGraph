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
    
    private var connectionWeight: [GKGraphNode: Float] = [:]
    
    public init(value: T) {
        self.value = value
        super.init()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var description: String {
        String(describing: value)
    }
    
    public override func cost(to node: GKGraphNode) -> Float {
        connectionWeight[node] ?? (node == self ? 0 : Float.infinity)
    }
    
    public func addConnection(to node: GKGraphNode,
                              bidirectional: Bool = false,
                              weight: Float = 1) {
        addConnections(to: [node], bidirectional: bidirectional, weight: weight)
    }
    public func addConnections(to nodes: [GKGraphNode],
                               bidirectional: Bool = false,
                               weight: Float = 1) {
        super.addConnections(to: nodes, bidirectional: bidirectional)
        
        for node in nodes {

            if connectionWeight[node] == nil {
                connectionWeight[node] = weight
            }
            
            if
                bidirectional,
                let node = node as? Node,
                node.connectionWeight[self] == nil {
                node.connectionWeight[self] = weight
            }
        }
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
nodeA.addConnection(to: nodeB, bidirectional: true, weight: 1)
nodeB.addConnection(to: nodeC, bidirectional: true, weight: 2)
nodeC.addConnection(to: nodeB, bidirectional: true, weight: 3)
nodeD.addConnection(to: nodeC, bidirectional: true, weight: 4)
nodeE.addConnection(to: nodeA, bidirectional: true, weight: 5)

// Create graph.
let graph = Graph<Any>([nodeA, nodeB, nodeC,nodeD,nodeE])

// Find path.
let paths = graph.findPath(from: nodeC, to: nodeA)

debugPrint("node=",paths)


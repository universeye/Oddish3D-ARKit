//
//  ViewController.swift
//  Poke3D
//
//  Created by Terry Kuo on 2021/2/2.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            
            configuration.detectionImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            //configuration.frameSemantics.insert(.personSegmentationWithDepth)
            
            
            print("Image Success")
        }
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        //anchor is the thing that we detected, in this case its the image
        //node is the 3D object we detected
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            print(imageAnchor.referenceImage.name!)
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5) //chanege plane color to 透明
            
            let planeNode = SCNNode()
            
            planeNode.geometry = plane
            
            planeNode.eulerAngles.x = -Float.pi / 2 //把plane 轉成平行
            
            node.addChildNode(planeNode)
            
            if let referenceImageName = imageAnchor.referenceImage.name {
                if referenceImageName == "i01_eevee" {
                    if let pokeScene = SCNScene(named: "art.scnassets/eevee.scn") {
                        
                        if let pokeNode = pokeScene.rootNode.childNodes.first {
                            
                            pokeNode.eulerAngles.x = .pi / 2
                            planeNode.addChildNode(pokeNode)
                            
                        }
                    }
                }
                
                if referenceImageName == "i01_oddish" {
                    if let pokeScene = SCNScene(named: "art.scnassets/oddish.scn") {
                        
                        if let pokeNode = pokeScene.rootNode.childNodes.first {
                            
                            pokeNode.eulerAngles.x = .pi / 2
                            planeNode.addChildNode(pokeNode)
                        }
                    }
                }
            }
            
            
           
        }
        
        
        return node
    }
   
}

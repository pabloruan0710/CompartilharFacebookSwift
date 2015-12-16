
//
//  ViewController.swift
//  Share
//
//  Created by Pablo on 12/16/15.
//  Copyright © 2015 PrimeSoftware. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //VARIAVEL PARA PASSAR IMAGEM
    var ImagemSelecionada:UIImage!
    
    //UTILIZAR PARA SELECIONAR IMAGEM
    var SeletorDeImagem:UIImagePickerController?
    
    //IMAGEM VIEW, SE QUISER UTILIZAR
    @IBOutlet weak var Img_Selecionada: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    /*****************************************************************************
     //                             Tira Nova Foto                               //
     *****************************************************************************/
    @IBAction func TirarFoto(sender: AnyObject) {
        
        var SeletorDeImagem:UIImagePickerController = UIImagePickerController()
        
        //TEM QUE ADICIONAR O DELEGATE UINavigationControllerDelegate
        SeletorDeImagem.delegate = self
        
        //VERIFICO SE APARELHO TEM CAMERA
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            //PARA PERMITIR EDICAO
            SeletorDeImagem.allowsEditing = false
            //SELECIONA A FONTE DA IMAGEM, COMO VOU TIRAR FOTO ENTAO UTILIZO CAMERA
            SeletorDeImagem.sourceType = UIImagePickerControllerSourceType.Camera
            //SELECIONA O MODO FOTO OU VIDEO
            SeletorDeImagem.cameraCaptureMode = .Photo
            
            presentViewController(SeletorDeImagem, animated: false, completion: nil)
        }else{
            let alert = UIAlertView(title: "Atenção", message: "Seu Dispositivo não possui camera compativel", delegate: self, cancelButtonTitle: "Cancelar")
            alert.show()
        }

        
        
        
    }
    
    /*****************************************************************************
     //                             Pega Imagem Da Galeria                        //
     *****************************************************************************/
    @IBAction func ImagemGaleria(sender: AnyObject) {
        
        var SeletorDeImagem:UIImagePickerController = UIImagePickerController()
        
        //TEM QUE ADICIONAR O DELEGATE UINavigationControllerDelegate
        SeletorDeImagem.delegate = self
        
        //PARA PERMITIR EDICAO
        SeletorDeImagem.allowsEditing = false
        //SELECIONA A FONTE DA IMAGEM, COMO VOU PEGAR DA GALERIA ENTAO UTILIZO PHOTOLIBRARY
        SeletorDeImagem.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        presentViewController(SeletorDeImagem, animated: false, completion: nil)
    }
    
    //METODO PARA PEGAR IMAGEM
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //PASSO A IMAGEM SELECIONADA PARA VARIAVEL IMAGEMSELECIONADA.
        ImagemSelecionada = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //PASSO QUE O DELEGATE È NIL PARA LIMPAR A MEMORIA
        SeletorDeImagem?.delegate = nil
        
        //FECHA A TELA DE IMAGEM
        self.dismissViewControllerAnimated(true) { () -> Void in
            
            //////////////////// ATENÇÂO UTILIZAR SOMENTE UM DOS DOIS ABAIXO //////////////////////////
            
            //SE QUISER JÁ PODE CHAMAR A FUNÇÃO DO BUTTON COMPARTILHAR DIRETAMENTE AQUI.
            //AI NAO PRECISARIA NEM DO IMAGEMVIEW, POIS AO SELECIONAR OU TIRAR FOTO, JA VAI APARECER
            //PARA COMPARTILHAR
            //-----> DESCOMENTAR AKI E COMENTAR O DEBAIXO
            //self.CompartilharImagem(UIButton)
            
            //SENAO, CASO VC QUEIRA UM SEGUNDO PREVIEW, AI UTILIZA ESSE CODIGO AKI, QUE VAI 
            //PASSAR SUA IMAGEM SELECIONADA PARA O IMAGEVIEW ADICIONADO NO Storyboard.
            //-----> DESCOMENTAR AKI E COMENTAR O DE CIMA
            self.Img_Selecionada.image = self.ImagemSelecionada
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    /*****************************************************************************
     //                             Botão de Compartilhar                        //
     *****************************************************************************/
    @IBAction func CompartilharImagem(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            
            var faceSheet : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            faceSheet.setInitialText("Compartilhar com Facebook")

            //VERIFICO SE EXISTEM IMAGEM NA VARIAVEL IMAGEMSELECIONADA
            if let imagem = ImagemSelecionada {
                
                //Adiciona Imagem
                faceSheet.addImage(ImagemSelecionada)
                
                
            }
            
            
            self.presentViewController(faceSheet, animated: true, completion: nil)
            
            //VERIFICA SE FOI OU NÃO POSTADA
            faceSheet.completionHandler = {result -> Void in
               
                var resultado = result as SLComposeViewControllerResult
                
                switch resultado.rawValue {
                
                case SLComposeViewControllerResult.Cancelled.rawValue:
                    let alert = UIAlertView(title: "Atenção", message: "Compartilhamento Cancelado", delegate: self, cancelButtonTitle: "Cancelar")
                    alert.show()
                
                case SLComposeViewControllerResult.Done.rawValue:
                    let alert = UIAlertView(title: "Atenção", message: "Compartilhado com Sucesso.", delegate: self, cancelButtonTitle: "Cancelar")
                    alert.show()
                
                    //REMOVE IMAGEM DA VARIAVEL, PARA POSTAR NOVA FOTO DEPOIS
                    self.ImagemSelecionada = nil
                    
                    //RESET IMAGEM VIEW
                    self.Img_Selecionada.image = UIImage(named: "sem_foto.jpg")
                    
                default:
                    let alert = UIAlertView(title: "Atenção", message: "Aconteceu algo de errado :(", delegate: self, cancelButtonTitle: "Cancelar")
                    alert.show()
                    break;
                }
            }
            
        }else{
            
            var AlertController = UIAlertController(title: "Conta", message: "Faça Login para Compartilhar", preferredStyle: UIAlertControllerStyle.Alert)
            AlertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(AlertController, animated: true, completion: nil)
        }
        
        
    }

}


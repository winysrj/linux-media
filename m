Return-path: <linux-media-owner@vger.kernel.org>
Received: from aa003msb.fastweb.it ([85.18.95.82]:48322 "EHLO
	aa003msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0CRJrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Mar 2010 05:47:19 -0400
Received: from mi-04.localnet (2.253.108.116) by aa003msb.fastweb.it (8.5.016.6)
        id 4B86A23801F8190C for linux-media@vger.kernel.org; Thu, 18 Mar 2010 10:49:30 +0100
From: Viviano Guastalla <vguastal@tiscali.it>
To: linux-media@vger.kernel.org
Subject: sending log
Date: Thu, 18 Mar 2010 10:41:49 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_dVfoLCn+mR2h3QZ"
Message-Id: <201003181041.50036.vguastal@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_dVfoLCn+mR2h3QZ
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hello, I inserted my USB Video Grabber labeled "Extreme Video Grabber - Model 
DK-8701" and got the attached log.
Thank you for your attention

Viviano Guastalla

--Boundary-00=_dVfoLCn+mR2h3QZ
Content-Type: text/plain;
  charset="UTF-8";
  name="log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="log.txt"

[15931.796364] usb 1-4.4.1: new high speed USB device using ehci_hcd and address 10                               
[15931.888352] usb 1-4.4.1: New USB device found, idVendor=eb1a, idProduct=2861                                   
[15931.888391] usb 1-4.4.1: New USB device strings: Mfr=0, Product=0, SerialNumber=0                              
[15931.888593] usb 1-4.4.1: configuration #1 chosen from 1 choice                                                 
[15932.017207] Linux video capture interface: v2.00                                                               
[15932.072176] em28xx: New device @ 480 Mbps (eb1a:2861, interface 0, class 0)                                    
[15932.072329] em28xx #0: chip ID is em2860                                                                       
[15932.200896] em28xx #0: board has no eeprom                                                                     
[15932.212388] em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)                                
[15932.245260] em28xx #0: found i2c device @ 0xb8 [tvp5150a]                                                      
[15932.257378] em28xx #0: Your board has no unique USB ID and thus need a hint to be detected.                    
[15932.257393] em28xx #0: You may try to use card=<n> insmod option to workaround that.                           
[15932.257403] em28xx #0: Please send an email with this log to:                                                  
[15932.257411] em28xx #0:       V4L Mailing List <linux-media@vger.kernel.org>                                    
[15932.257420] em28xx #0: Board eeprom hash is 0x00000000                                                         
[15932.257429] em28xx #0: Board i2c devicelist hash is 0x77800080                                                 
[15932.257437] em28xx #0: Here is a list of valid choices for the card=<n> insmod option:                         
[15932.257448] em28xx #0:     card=0 -> Unknown EM2800 video grabber                                              
[15932.257457] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber                                         
[15932.257466] em28xx #0:     card=2 -> Terratec Cinergy 250 USB                                                  
[15932.257475] em28xx #0:     card=3 -> Pinnacle PCTV USB 2                                                       
[15932.257484] em28xx #0:     card=4 -> Hauppauge WinTV USB 2                                                     
[15932.257492] em28xx #0:     card=5 -> MSI VOX USB 2.0                                                           
[15932.257501] em28xx #0:     card=6 -> Terratec Cinergy 200 USB                                                  
[15932.257510] em28xx #0:     card=7 -> Leadtek Winfast USB II                                                    
[15932.257518] em28xx #0:     card=8 -> Kworld USB2800                                                            
[15932.257527] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 / Kaiser Baas Video to DVD maker       
[15932.257538] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900                                                  
[15932.257547] em28xx #0:     card=11 -> Terratec Hybrid XS                                                       
[15932.257556] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF                                                    
[15932.257564] em28xx #0:     card=13 -> Terratec Prodigy XS                                                      
[15932.257573] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview Prolink PlayTV USB 2.0                      
[15932.257583] em28xx #0:     card=15 -> V-Gear PocketTV                                                          
[15932.257592] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950                                                  
[15932.257601] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick                                               
[15932.257610] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)                                             
[15932.257619] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design                                          
[15932.257628] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600                                                 
[15932.257637] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+ Video Encoder                           
[15932.257647] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber                                      
[15932.257656] em28xx #0:     card=23 -> Huaqi DLCW-130                                                           
[15932.257665] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner                                                 
[15932.257674] em28xx #0:     card=25 -> Gadmei UTV310                                                            
[15932.257682] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0                                                
[15932.257691] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips FM1216ME)                                   
[15932.257701] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe                                            
[15932.257710] em28xx #0:     card=29 -> <NULL>                                                                   
[15932.257718] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0                                               
[15932.257727] em28xx #0:     card=31 -> Usbgear VD204v9                                                          
[15932.257735] em28xx #0:     card=32 -> Supercomp USB 2.0 TV                                                     
[15932.257744] em28xx #0:     card=33 -> <NULL>                                                                   
[15932.257752] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS                                             
[15932.257761] em28xx #0:     card=35 -> Typhoon DVD Maker                                                        
[15932.257769] em28xx #0:     card=36 -> NetGMBH Cam                                                              
[15932.257778] em28xx #0:     card=37 -> Gadmei UTV330                                                            
[15932.257786] em28xx #0:     card=38 -> Yakumo MovieMixer                                                        
[15932.257795] em28xx #0:     card=39 -> KWorld PVRTV 300U                                                        
[15932.257803] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U                                               
[15932.257812] em28xx #0:     card=41 -> Kworld 350 U DVB-T                                                       
[15932.257821] em28xx #0:     card=42 -> Kworld 355 U DVB-T
[15932.257829] em28xx #0:     card=43 -> Terratec Cinergy T XS
[15932.257838] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)
[15932.257847] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T
[15932.257856] em28xx #0:     card=46 -> Compro, VideoMate U3
[15932.257864] em28xx #0:     card=47 -> KWorld DVB-T 305U
[15932.257873] em28xx #0:     card=48 -> KWorld DVB-T 310U
[15932.257881] em28xx #0:     card=49 -> MSI DigiVox A/D
[15932.257890] em28xx #0:     card=50 -> MSI DigiVox A/D II
[15932.257898] em28xx #0:     card=51 -> Terratec Hybrid XS Secam
[15932.257907] em28xx #0:     card=52 -> DNT DA2 Hybrid
[15932.257915] em28xx #0:     card=53 -> Pinnacle Hybrid Pro
[15932.257924] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[15932.257933] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[15932.257942] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[15932.257950] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[15932.257960] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[15932.257969] em28xx #0:     card=59 -> <NULL>
[15932.257977] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[15932.257985] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[15932.257995] em28xx #0:     card=62 -> Gadmei TVR200
[15932.258003] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[15932.258011] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[15932.258020] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[15932.258028] em28xx #0:     card=66 -> Empire dual TV
[15932.258037] em28xx #0:     card=67 -> Terratec Grabby
[15932.258045] em28xx #0:     card=68 -> Terratec AV350
[15932.258054] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[15932.258063] em28xx #0:     card=70 -> Evga inDtube
[15932.258071] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[15932.258127] em28xx #0: Config register raw data: 0x10
[15932.280251] em28xx #0: AC97 vendor ID = 0xffffffff
[15932.292248] em28xx #0: AC97 features = 0x6a90
[15932.292260] em28xx #0: Empia 202 AC97 audio processor detected
[15932.704026] em28xx #0: v4l2 driver version 0.1.2
[15933.548342] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
[15933.555011] usbcore: registered new interface driver snd-usb-audio
[15933.555094] usbcore: registered new interface driver em28xx
[15933.555106] em28xx driver loaded
--Boundary-00=_dVfoLCn+mR2h3QZ--

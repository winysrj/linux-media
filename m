Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out05.email.it ([212.97.34.16]:39342 "EHLO
	smtp-out05.email.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbZHKQMK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 12:12:10 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp-out05.email.it (Postfix) with ESMTP id AE1714011
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 17:39:34 +0200 (CEST)
Received: from smtp-out05.email.it ([127.0.0.1])
	by localhost (smtp-out05.email.it [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id yOXbTqta0Kvm for <linux-media@vger.kernel.org>;
	Tue, 11 Aug 2009 17:39:34 +0200 (CEST)
Received: from 79.49.85.69 (wm9.email.it [212.97.34.52])
	by smtp-out05.email.it (Postfix) with ESMTP id 7305C4007
	for <linux-media@vger.kernel.org>; Tue, 11 Aug 2009 17:39:34 +0200 (CEST)
Date: Tue, 11 Aug 2009 17:39:35 +0200
To: linux-media@vger.kernel.org
From: Emanuele Deiola <e.lex@email.it>
Reply-to: Emanuele Deiola <e.lex@email.it>
Subject: dmesg | grep em28xx
Message-ID: <fea839bd405c1f320b6670cfba352dc8@79.49.85.69>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[  127.668233] em28xx: New device @ 480 Mbps (eb1a:2881, interface 0, class
0)
[  127.668239] em28xx #0: Identified as Unknown EM2750/28xx video grabber
(card=1)                                                                    
           
[  127.668371] em28xx #0: chip ID is em2882/em2883                          
    
[  127.753053] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 03
6a 20 6a 00                                                                 
        
[  127.753073] em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00
02 02 00 00                                                                 
        
[  127.753090] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00 00 00
5b 1e 00 00                                                                 
        
[  127.753107] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00
00 00 00 00                                                                 
        
[  127.753123] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753140] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753156] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 53 00                                                                 
        
[  127.753173] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00
20 00 56 00                                                                 
        
[  127.753189] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753206] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753222] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753239] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753255] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753271] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753288] em28xx #0: i2c eeprom e0: 5a 00 55 aa e5 2b 59 03 00 17 fc 01
00 00 00 00                                                                 
        
[  127.753305] em28xx #0: i2c eeprom f0: 00 00 00 01 00 00 00 00 00 00 00 00
00 00 00 00                                                                 
        
[  127.753323] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x232d2120   
    
[  127.753326] em28xx #0: EEPROM info:                                      
    
[  127.753329] em28xx #0:       AC97 audio (5 sample rates)                 
    
[  127.753332] em28xx #0:       USB Remote wakeup capable                   
    
[  127.753335] em28xx #0:       500mA max power                             
    
[  127.753339] em28xx #0:       Table at 0x04, strings=0x206a, 0x006a,
0x0000    
[  127.784853] em28xx #0: found i2c device @ 0xa0 [eeprom]                  
    
[  127.789477] em28xx #0: found i2c device @ 0xb8 [tvp5150a]                
    
[  127.791345] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]          
    
[  127.803098] em28xx #0: Your board has no unique USB ID and thus need a
hint to be detected.                                                        
           
[  127.803109] em28xx #0: You may try to use card=<n> insmod option to
workaround that.                                                            
              
[  127.803114] em28xx #0: Please send an email with this log to:            
    
[  127.803119] em28xx #0:       V4L Mailing List
<linux-media@vger.kernel.org>   
[  127.803124] em28xx #0: Board eeprom hash is 0x232d2120                   
    
[  127.803130] em28xx #0: Board i2c devicelist hash is 0x27e10080           
    
[  127.803134] em28xx #0: Here is a list of valid choices for the card=<n>
insmod option:                                                              
          
[  127.803141] em28xx #0:     card=0 -> Unknown EM2800 video grabber        
    
[  127.803147] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber   
    
[  127.803153] em28xx #0:     card=2 -> Terratec Cinergy 250 USB            
    
[  127.803159] em28xx #0:     card=3 -> Pinnacle PCTV USB 2                 
    
[  127.803165] em28xx #0:     card=4 -> Hauppauge WinTV USB 2               
    
[  127.803170] em28xx #0:     card=5 -> MSI VOX USB 2.0                     
    
[  127.803175] em28xx #0:     card=6 -> Terratec Cinergy 200 USB            
    
[  127.803181] em28xx #0:     card=7 -> Leadtek Winfast USB II              
    
[  127.803186] em28xx #0:     card=8 -> Kworld USB2800                      
    
[  127.803192] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 /
Kaiser Baas Video to DVD maker                                              
        
[  127.803199] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900            
    
[  127.803204] em28xx #0:     card=11 -> Terratec Hybrid XS                 
    
[  127.803210] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF              
    
[  127.803215] em28xx #0:     card=13 -> Terratec Prodigy XS                
    
[  127.803221] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0                                                      
               
[  127.803227] em28xx #0:     card=15 -> V-Gear PocketTV                    
    
[  127.803232] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950            
    
[  127.803238] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick         
    
[  127.803244] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)       
    
[  127.803249] em28xx #0:     card=19 -> PointNix Intra-Oral Camera         
    
[  127.803255] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600           
    
[  127.803260] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX+
Video Encoder                                                               
           
[  127.803266] em28xx #0:     card=22 -> Unknown EM2750/EM2751 webcam
grabber    
[  127.803272] em28xx #0:     card=23 -> Huaqi DLCW-130                     
    
[  127.803277] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner           
    
[  127.803283] em28xx #0:     card=25 -> Gadmei UTV310                      
    
[  127.803288] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0          
    
[  127.803294] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)  
[  127.803300] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe      
    
[  127.803305] em28xx #0:     card=29 -> <NULL>                             
    
[  127.803310] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0         
    
[  127.803316] em28xx #0:     card=31 -> Usbgear VD204v9                    
    
[  127.803321] em28xx #0:     card=32 -> Supercomp USB 2.0 TV               
    
[  127.803327] em28xx #0:     card=33 -> <NULL>                             
    
[  127.803332] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS       
    
[  127.803337] em28xx #0:     card=35 -> Typhoon DVD Maker                  
    
[  127.803342] em28xx #0:     card=36 -> NetGMBH Cam                        
    
[  127.803348] em28xx #0:     card=37 -> Gadmei UTV330                      
    
[  127.803353] em28xx #0:     card=38 -> Yakumo MovieMixer                  
    
[  127.803358] em28xx #0:     card=39 -> KWorld PVRTV 300U                  
    
[  127.803364] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U         
    
[  127.803369] em28xx #0:     card=41 -> Kworld 350 U DVB-T                 
    
[  127.803374] em28xx #0:     card=42 -> Kworld 355 U DVB-T                 
    
[  127.803380] em28xx #0:     card=43 -> Terratec Cinergy T XS              
    
[  127.803385] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)     
    
[  127.803391] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T                
    
[  127.803396] em28xx #0:     card=46 -> Compro, VideoMate U3               
    
[  127.803402] em28xx #0:     card=47 -> KWorld DVB-T 305U                  
    
[  127.803407] em28xx #0:     card=48 -> KWorld DVB-T 310U                  
    
[  127.803412] em28xx #0:     card=49 -> MSI DigiVox A/D                    
    
[  127.803418] em28xx #0:     card=50 -> MSI DigiVox A/D II                 
    
[  127.803423] em28xx #0:     card=51 -> Terratec Hybrid XS Secam           
    
[  127.803428] em28xx #0:     card=52 -> DNT DA2 Hybrid                     
    
[  127.803433] em28xx #0:     card=53 -> Pinnacle Hybrid Pro                
    
[  127.803439] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR
[  127.803444] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)
[  127.803450] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)
[  127.803456] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330
[  127.803461] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  127.803467] em28xx #0:     card=59 -> <NULL>
[  127.803472] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  127.803477] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  127.803483] em28xx #0:     card=62 -> Gadmei TVR200
[  127.803488] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  127.803493] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  127.803499] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  127.803596] em28xx #0: Config register raw data: 0x58
[  127.816702] em28xx #0: AC97 vendor ID = 0x889b889b
[  127.817070] em28xx #0: AC97 features = 0x889b
[  127.817075] em28xx #0: Unknown AC97 audio processor detected!
[  127.848013] em28xx #0: v4l2 driver version 0.1.2
[  127.883086] em28xx #0: V4L2 device registered as /dev/video1 and
/dev/vbi0
[  127.899532] usbcore: registered new interface driver em28xx
[  127.899540] em28xx driver loaded
 
 --
 Caselle da 1GB, trasmetti allegati fino a 3GB e in piu' IMAP, POP3 e SMTP
autenticato? GRATIS solo con Email.it: http://www.email.it/f
 
 Sponsor:
 
 Clicca qui: http://adv.email.it/cgi-bin/foclick.cgi?mid=&d=20090811



Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out05.email.it ([212.97.34.16]:53383 "EHLO
	smtp-out05.email.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbZHMPkx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2009 11:40:53 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp-out05.email.it (Postfix) with ESMTP id 4A66F4025
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 17:40:51 +0200 (CEST)
Received: from smtp-out05.email.it ([127.0.0.1])
	by localhost (smtp-out05.email.it [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id LO+oqg0hbzsc for <linux-media@vger.kernel.org>;
	Thu, 13 Aug 2009 17:40:51 +0200 (CEST)
Received: from 95.234.88.152 (wm10.email.it [212.97.34.53])
	by smtp-out05.email.it (Postfix) with ESMTP id 1093B4002
	for <linux-media@vger.kernel.org>; Thu, 13 Aug 2009 17:40:51 +0200 (CEST)
Date: Thu, 13 Aug 2009 17:40:52 +0200
To: linux-media@vger.kernel.org
From: Emanuele Deiola <e.lex@email.it>
Reply-to: Emanuele Deiola <e.lex@email.it>
Subject: dmesg | grep em28xx
Message-ID: <bc78e9d20f069e78ddfca01f587eb560@95.234.88.152>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi! 
I have a TV tuner by conitech Kiowa, eb1a: 2881. 
It is exactly this: 
http://www.conitech.it/conitech/ita/prod.asp?cod=CN610DVB-DT

Using ubuntu9.04 with the kernel 2.6.31-5-generic, the output of "dmesg |
grep em28xx" is this:

"
[  701.147755] em28xx: New device @ 480 Mbps (eb1a:2881, interface 0, class
0)                                                              
[  701.147761] em28xx #0: Identified as Unknown EM2750/28xx video grabber
(card=1)                                                          
[  701.148370] em28xx #0: chip ID is em2882/em2883                          
                                                               
[  701.237680] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 03
6a 20 6a 00                                                    
[  701.237713] em28xx #0: i2c eeprom 10: 00 00 04 57 64 80 00 00 60 f4 00 00
02 02 00 00                                                    
[  701.237742] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00 00 00
5b 1e 00 00                                                    
[  701.237771] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00
00 00 00 00                                                    
[  701.237799] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[  701.237827] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[  701.237855] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 53 00                                                    
[  701.237883] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00
20 00 56 00                                                    
[  701.237912] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00
00 00 00 00                                                    
[  701.237940] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[  701.237968] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[  701.237996] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[  701.238025] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[  701.238053] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[  701.238081] em28xx #0: i2c eeprom e0: 5a 00 55 aa e5 2b 59 03 00 17 fc 01
00 00 00 00                                                    
[  701.238109] em28xx #0: i2c eeprom f0: 00 00 00 01 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[  701.238140] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x4dea2120   
                                                               
[  701.238145] em28xx #0: EEPROM info:                                      
                                                               
[  701.238149] em28xx #0:       AC97 audio (5 sample rates)                 
                                                               
[  701.238153] em28xx #0:       USB Remote wakeup capable                   
                                                               
[  701.238158] em28xx #0:       500mA max power                             
                                                               
[  701.238163] em28xx #0:       Table at 0x04, strings=0x206a, 0x006a,
0x0000                                                               
[  701.282675] em28xx #0: found i2c device @ 0xa0 [eeprom]                  
                                                               
[  701.287423] em28xx #0: found i2c device @ 0xb8 [tvp5150a]                
                                                               
[  701.289330] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]          
                                                               
[  701.304949] em28xx #0: Your board has no unique USB ID and thus need a
hint to be detected.                                              
[  701.304960] em28xx #0: You may try to use card=<n> insmod option to
workaround that.                                                     
[  701.304965] em28xx #0: Please send an email with this log to:            
                                                               
[  701.304970] em28xx #0:       V4L Mailing List
<linux-media@vger.kernel.org>                                               
              
[  701.304976] em28xx #0: Board eeprom hash is 0x4dea2120                   
                                                               
[  701.304981] em28xx #0: Board i2c devicelist hash is 0x27e10080           
                                                               
[  701.304986] em28xx #0: Here is a list of valid choices for the card=<n>
insmod option:                                                   
[  701.304993] em28xx #0:     card=0 -> Unknown EM2800 video grabber        
                                                               
[  701.304999] em28xx #0:     card=1 -> Unknown EM2750/28xx video grabber   
                                                               
[  701.305013] em28xx #0:     card=2 -> Terratec Cinergy 250 USB            
                                                               
[  701.305019] em28xx #0:     card=3 -> Pinnacle PCTV USB 2                 
                                                               
[  701.305024] em28xx #0:     card=4 -> Hauppauge WinTV USB 2               
                                                               
[  701.305029] em28xx #0:     card=5 -> MSI VOX USB 2.0                     
                                                               
[  701.305035] em28xx #0:     card=6 -> Terratec Cinergy 200 USB            
                                                               
[  701.305040] em28xx #0:     card=7 -> Leadtek Winfast USB II              
                                                               
[  701.305046] em28xx #0:     card=8 -> Kworld USB2800                      
                                                               
[  701.305051] em28xx #0:     card=9 -> Pinnacle Dazzle DVC 90/100/101/107 /
Kaiser Baas Video to DVD maker                                 
[  701.305057] em28xx #0:     card=10 -> Hauppauge WinTV HVR 900            
                                                               
[  701.305063] em28xx #0:     card=11 -> Terratec Hybrid XS                 
                                                               
[  701.305068] em28xx #0:     card=12 -> Kworld PVR TV 2800 RF              
                                                               
[  701.305074] em28xx #0:     card=13 -> Terratec Prodigy XS                
                                                               
[  701.305079] em28xx #0:     card=14 -> SIIG AVTuner-PVR / Pixelview
Prolink PlayTV USB 2.0                                                
[  701.305086] em28xx #0:     card=15 -> V-Gear PocketTV                    
                                                               
[  701.305091] em28xx #0:     card=16 -> Hauppauge WinTV HVR 950            
                                                               
[  701.305097] em28xx #0:     card=17 -> Pinnacle PCTV HD Pro Stick         
                                                               
[  701.305102] em28xx #0:     card=18 -> Hauppauge WinTV HVR 900 (R2)       
                                                               
[  701.305108] em28xx #0:     card=19 -> EM2860/SAA711X Reference Design    
                                                               
[  701.305113] em28xx #0:     card=20 -> AMD ATI TV Wonder HD 600           
                                                               
[  701.305119] em28xx #0:     card=21 -> eMPIA Technology, Inc. GrabBeeX 
Video Encoder                                                     
[  701.305125] em28xx #0:     card=22 -> EM2710/EM2750/EM2751 webcam grabber
                                                               
[  701.305130] em28xx #0:     card=23 -> Huaqi DLCW-130                     
                                                               
[  701.305136] em28xx #0:     card=24 -> D-Link DUB-T210 TV Tuner           
                                                               
[  701.305141] em28xx #0:     card=25 -> Gadmei UTV310                      
                                                               
[  701.305147] em28xx #0:     card=26 -> Hercules Smart TV USB 2.0          
                                                               
[  701.305152] em28xx #0:     card=27 -> Pinnacle PCTV USB 2 (Philips
FM1216ME)                                                             
[  701.305158] em28xx #0:     card=28 -> Leadtek Winfast USB II Deluxe      
                                                               
[  701.305164] em28xx #0:     card=29 -> <NULL>                             
                                                               
[  701.305169] em28xx #0:     card=30 -> Videology 20K14XUSB USB2.0         
                                                               
[  701.305174] em28xx #0:     card=31 -> Usbgear VD204v9                    
                                                               
[  701.305180] em28xx #0:     card=32 -> Supercomp USB 2.0 TV               
                                                               
[  701.305185] em28xx #0:     card=33 -> <NULL>                             
                                                               
[  701.305190] em28xx #0:     card=34 -> Terratec Cinergy A Hybrid XS       
                                                               
[  701.305195] em28xx #0:     card=35 -> Typhoon DVD Maker                  
                                                               
[  701.305201] em28xx #0:     card=36 -> NetGMBH Cam                        
                                                               
[  701.305206] em28xx #0:     card=37 -> Gadmei UTV330                      
                                                               
[  701.305211] em28xx #0:     card=38 -> Yakumo MovieMixer                  
                                                               
[  701.305216] em28xx #0:     card=39 -> KWorld PVRTV 300U                  
                                                               
[  701.305222] em28xx #0:     card=40 -> Plextor ConvertX PX-TV100U         
                                                               
[  701.305227] em28xx #0:     card=41 -> Kworld 350 U DVB-T                 
                                                               
[  701.305232] em28xx #0:     card=42 -> Kworld 355 U DVB-T                 
                                                               
[  701.305238] em28xx #0:     card=43 -> Terratec Cinergy T XS              
                                                               
[  701.305244] em28xx #0:     card=44 -> Terratec Cinergy T XS (MT2060)     
                                                               
[  701.305249] em28xx #0:     card=45 -> Pinnacle PCTV DVB-T                
                                                               
[  701.305254] em28xx #0:     card=46 -> Compro, VideoMate U3               
                                                               
[  701.305260] em28xx #0:     card=47 -> KWorld DVB-T 305U                  
                                                               
[  701.305265] em28xx #0:     card=48 -> KWorld DVB-T 310U                  
                                                               
[  701.305270] em28xx #0:     card=49 -> MSI DigiVox A/D                    
                                                               
[  701.305276] em28xx #0:     card=50 -> MSI DigiVox A/D II                 
                                                               
[  701.305281] em28xx #0:     card=51 -> Terratec Hybrid XS Secam           
                                                               
[  701.305287] em28xx #0:     card=52 -> DNT DA2 Hybrid                     
                                                               
[  701.305292] em28xx #0:     card=53 -> Pinnacle Hybrid Pro                
                                                               
[  701.305297] em28xx #0:     card=54 -> Kworld VS-DVB-T 323UR              
                                                               
[  701.305302] em28xx #0:     card=55 -> Terratec Hybrid XS (em2882)        
                                                               
[  701.305308] em28xx #0:     card=56 -> Pinnacle Hybrid Pro (2)            
                                                               
[  701.305314] em28xx #0:     card=57 -> Kworld PlusTV HD Hybrid 330        
                                                               
[  701.305319] em28xx #0:     card=58 -> Compro VideoMate ForYou/Stereo
[  701.305325] em28xx #0:     card=59 -> <NULL>
[  701.305330] em28xx #0:     card=60 -> Hauppauge WinTV HVR 850
[  701.305335] em28xx #0:     card=61 -> Pixelview PlayTV Box 4 USB 2.0
[  701.305341] em28xx #0:     card=62 -> Gadmei TVR200
[  701.305346] em28xx #0:     card=63 -> Kaiomy TVnPC U2
[  701.305351] em28xx #0:     card=64 -> Easy Cap Capture DC-60
[  701.305357] em28xx #0:     card=65 -> IO-DATA GV-MVP/SZ
[  701.305362] em28xx #0:     card=66 -> Empire dual TV
[  701.305367] em28xx #0:     card=67 -> Terratec Grabby
[  701.305372] em28xx #0:     card=68 -> Terratec AV350
[  701.305378] em28xx #0:     card=69 -> KWorld ATSC 315U HDTV TV Box
[  701.305383] em28xx #0:     card=70 -> Evga inDtube
[  701.305388] em28xx #0:     card=71 -> Silvercrest Webcam 1.3mpix
[  701.305567] em28xx #0: Config register raw data: 0x58
[  701.306316] em28xx #0: AC97 vendor ID = 0x888b888b
[  701.306671] em28xx #0: AC97 features = 0x888b
[  701.306676] em28xx #0: Unknown AC97 audio processor detected!
[  701.344910] em28xx #0: v4l2 driver version 0.1.2
[  701.344933] last sysfs file: /sys/module/em28xx/initstate
[  701.344936] Modules linked in: em28xx( ) ir_common v4l2_common
videobuf_vmalloc tveeprom r5u870 usbcam videodev v4l1_compat videobuf_dma_sg
videobuf_core nvidia(P) binfmt_misc ppdev bridge stp bnep vboxnetadp
vboxnetflt vboxdrv lp parport snd_hda_codec_idt snd_hda_intel snd_hda_codec
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy arc4 snd_seq_oss ecb joydev
snd_seq_midi pcmcia snd_rawmidi iwlagn iwlcore snd_seq_midi_event snd_seq
psmouse tifm_7xx1 led_class yenta_socket mac80211 snd_timer iTCO_wdt
serio_raw pcspkr tifm_core rsrc_nonstatic pcmcia_core snd_seq_device
iTCO_vendor_support btusb snd soundcore snd_page_alloc intel_agp agpgart
cfg80211 video sony_laptop output usbhid ohci1394 sky2 ieee1394 fbcon
tileblit font bitblit softcursor
[  701.345022] EIP is at get_scale 0x37/0xd0 [em28xx]
[  701.345067]  [<f826492e>] ? em28xx_set_video_format 0x6e/0x90 [em28xx]
[  701.345074]  [<f826512f>] ? em28xx_register_analog_devices 0x8f/0x2a0
[em28xx]
[  701.345082]  [<f8267f1c>] ? em28xx_init_dev 0x1bc/0x320 [em28xx]
[  701.345089]  [<f82683e6>] ? em28xx_usb_probe 0x366/0x6a0 [em28xx]
[  701.345096]  [<f82684d7>] ? em28xx_usb_probe 0x457/0x6a0 [em28xx]
[  701.345164]  [<f814301b>] ? em28xx_module_init 0x1b/0x44 [em28xx]
[  701.345174]  [<f8143000>] ? em28xx_module_init 0x0/0x44 [em28xx]
[  701.345240] EIP: [<f8263127>] get_scale 0x37/0xd0 [em28xx] SS:ESP
0068:f2279c20
" 

What can I do? 
I await your news. 


                                                              Regards

                                                                     
Emanuele 
 --
 Caselle da 1GB, trasmetti allegati fino a 3GB e in piu' IMAP, POP3 e SMTP
autenticato? GRATIS solo con Email.it: http://www.email.it/f
 
 Sponsor:
 Legal.email.it: il servizio di Posta elettronica certificata con SMS di
notifica per aziende e liberi professionisti, scopri tutti i dettagli
dell'offerta
 Clicca qui: http://adv.email.it/cgi-bin/foclick.cgi?mid=8979&d=20090813



Return-path: <linux-media-owner@vger.kernel.org>
Received: from mp1-smtp-5.eutelia.it ([62.94.10.165]:47433 "EHLO
	smtp.eutelia.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755272AbZHFNzt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Aug 2009 09:55:49 -0400
Received: from [192.168.1.170] (ip-173-192.sn3.eutelia.it [213.136.173.192])
	by smtp.eutelia.it (Eutelia) with ESMTP id 45084103782
	for <linux-media@vger.kernel.org>; Thu,  6 Aug 2009 15:55:13 +0200 (CEST)
Message-ID: <4A7AE0B0.20507@email.it>
Date: Thu, 06 Aug 2009 15:54:56 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Issues with Empire Dual Pen: request for help and suggestions!!!
References: <4A79EC82.4050902@email.it>
In-Reply-To: <4A79EC82.4050902@email.it>
Content-Type: multipart/mixed;
 boundary="------------050106070505030305040805"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050106070505030305040805
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I want to inform you that thanks to Douglas Schilling Landgraf, the 
first point (automatic recognition of the device when plugged in) ha 
been resolved (using his development tree driver).
I've tried to scan for digital channels again and the result has not 
changed but in the dmesg attached there are a lot of messages created 
during the scan process. I hope they are useful to solve at list the 
issue related with the digital scanning.
Thank you,
Xwang

xwang1976@email.it ha scritto:
>
> Hi to all,
> I've an Empire Dual Pen usb device.
> Up to now I've used Markus driver, but now I've tried to switch to the 
> v4l-dvb driver.
> However I've the following issues:
> 1) the card is  not recognized automatically so I've to modprobe the 
> em28xx module with the parameter card=66
> 2) when scanning for analog tv channels with tvtime-scanner, the 
> system hangs and since  the alt+Sys+REISUB procedure does not help, I 
> have to turn off the pc (very, very, very bad)
> 3) digital tv channels are not tuned by kaffeine (SNR value is always 
> zero).
> So the device is not usable.
> Can it be fixed or is it better to buy an already supported device? 
> Inthe second case which device can you suggest me? Is this device:
> http://www.terratec.net/en/products/technical-data/produkte_technische_daten_en_87128.html 
>
> supported by the latest v4l drivers.
> Thank you for your help,
> Xwang
>
> PS: I live in Italy and I use kubuntu 9.04 amd64
>

--------------050106070505030305040805
Content-Type: text/plain;
 name="dmesg_out.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_out.txt"

andreak@pro5av:~$ dmesg                                                                                                                                                          
[ 1142.664103] usb 2-3: new high speed USB device using ehci_hcd and address 6                                                                                                   
[ 1142.800169] usb 2-3: configuration #1 chosen from 1 choice                                                                                                                    
[ 1142.839851] Linux video capture interface: v2.00                                                                                                                              
[ 1142.875566] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e310, interface 0, class 0)                                                                                   
[ 1142.875576] em28xx #0: Identified as MSI DigiVox A/D (card=49)                                                                                                                
[ 1142.879192] em28xx #0: chip ID is em2882/em2883                                                                                                                               
[ 1143.034939] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 d0 12 5c 03 6a 22 00 00                                                                                         
[ 1143.034961] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.034981] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00                                                                                         
[ 1143.034999] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00                                                                                         
[ 1143.035018] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035037] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035055] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00                                                                                         
[ 1143.035074] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 44 00                                                                                         
[ 1143.035092] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00                                                                                         
[ 1143.035111] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035129] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035147] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035166] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035184] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035202] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035220] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00                                                                                         
[ 1143.035242] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x166a0441                                                                                                        
[ 1143.035246] em28xx #0: EEPROM info:                                                                                                                                           
[ 1143.035248] em28xx #0:       AC97 audio (5 sample rates)                                                                                                                      
[ 1143.035252] em28xx #0:       500mA max power                                                                                                                                  
[ 1143.035256] em28xx #0:       Table at 0x04, strings=0x226a, 0x0000, 0x0000                                                                                                    
[ 1143.035262] em28xx #0: Your board has no unique USB ID.                                                                                                                       
[ 1143.035268] em28xx #0: A hint were successfully done, based on eeprom hash.                                                                                                   
[ 1143.035272] em28xx #0: This method is not 100% failproof.                                                                                                                     
[ 1143.035276] em28xx #0: If the board were missdetected, please email this log to:                                                                                              
[ 1143.035280] em28xx #0:       V4L Mailing List  <linux-media@vger.kernel.org>                                                                                                  
[ 1143.035284] em28xx #0: Board detected as Empire dual TV                                                                                                                       
[ 1143.112863] tvp5150 6-005c: chip found @ 0xb8 (em28xx #0)                                                                                                                     
[ 1143.120239] tuner 6-0061: chip found @ 0xc2 (em28xx #0)                                                                                                                       
[ 1143.134348] xc2028 6-0061: creating new instance                                                                                                                              
[ 1143.134354] xc2028 6-0061: type set to XCeive xc2028/xc3028 tuner                                                                                                             
[ 1143.134368] usb 2-3: firmware: requesting xc3028-v27.fw                                                                                                                       
[ 1143.145494] xc2028 6-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7                                                                      
[ 1143.205066] xc2028 6-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.                                                                                       
[ 1144.153950] xc2028 6-0061: Loading firmware for type=MTS (4), id 000000000000b700.                                                                                            
[ 1144.169462] xc2028 6-0061: Loading SCODE for type=MTS LCD NOGD MONO IF SCODE HAS_IF_4500 (6002b004), id 000000000000b700.                                                     
[ 1144.352314] em28xx #0: Config register raw data: 0xd0                                                                                                                         
[ 1144.353076] em28xx #0: AC97 vendor ID = 0xffffffff                                                                                                                            
[ 1144.353431] em28xx #0: AC97 features = 0x6a90                                                                                                                                 
[ 1144.353435] em28xx #0: Empia 202 AC97 audio processor detected                                                                                                                
[ 1144.476568] tvp5150 6-005c: tvp5150am1 detected.                                                                                                                              
[ 1144.572941] em28xx #0: v4l2 driver version 0.1.2                                                                                                                              
[ 1144.655055] em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0                                                                                                    
[ 1144.668085] em28xx video device (eb1a:e310): interface 1, class 255 found.                                                                                                    
[ 1144.668091] em28xx This is an anciliary interface not used by the driver                                                                                                      
[ 1144.668132] usbcore: registered new interface driver em28xx                                                                                                                   
[ 1144.668139] em28xx driver loaded                                                                                                                                              
[ 1144.712837] em28xx-audio.c: probing for em28x1 non standard usbaudio                                                                                                          
[ 1144.712842] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger                                                                                                              
[ 1144.713462] Em28xx: Initialized (Em28xx Audio Extension) extension                                                                                                            
[ 1144.833828] xc2028 6-0061: attaching existing instance                                                                                                                        
[ 1144.833830] xc2028 6-0061: type set to XCeive xc2028/xc3028 tuner                                                                                                             
[ 1144.833832] em28xx #0/2: xc3028 attached                                                                                                                                      
[ 1144.833834] DVB: registering new adapter (em28xx #0)                                                                                                                          
[ 1144.833836] DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...                                                                                                  
[ 1144.834100] Successfully loaded em28xx-dvb                                                                                                                                    
[ 1144.834102] Em28xx: Initialized (Em28xx dvb Extension) extension                                                                                                              
[ 1144.940531] tvp5150 6-005c: tvp5150am1 detected.                                                                                                                              
[ 1165.852073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1166.801941] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1166.815446] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1166.849947] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1166.964093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1167.910948] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1167.924445] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1167.957945] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1169.160071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1170.106946] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1170.120320] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1170.153823] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1170.268088] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1171.217827] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1171.231223] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1171.261821] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1172.400072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1173.357823] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1173.371448] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1173.405948] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1173.520093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1174.481951] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1174.495446] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1174.529945] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1175.737071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1176.697954] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1176.711442] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1176.745820] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1176.860069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1177.810953] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1177.824573] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1177.857946] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1179.001068] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1179.950822] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1179.964574] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1179.997819] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1180.112090] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1181.077951] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1181.091466] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1181.125810] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1182.328066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1183.273827] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1183.287324] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1183.317818] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1183.433066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1184.377830] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1184.391351] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1184.426615] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1185.564067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1186.517955] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1186.530977] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1186.561812] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1186.676063] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1187.629950] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1187.643470] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1187.677947] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1188.880096] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1189.821828] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1189.835450] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1189.869948] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1189.992069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1190.941832] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1190.955319] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1190.985850] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1192.124070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1193.066956] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1193.080453] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1193.113950] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1193.232099] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1194.173832] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1194.187353] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1194.219991] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1195.424097] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1196.369955] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1196.383322] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1196.424838] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1196.540072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1197.506827] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1197.520452] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1197.553949] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1198.696070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1199.645956] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1199.659314] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1199.689852] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1199.804068] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1200.753832] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1200.767104] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1200.797825] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1202.000077] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1202.969833] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1202.983322] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1203.013821] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1203.128070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1204.069957] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1204.083447] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1204.117825] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1205.257068] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1206.201957] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1206.215449] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1206.249825] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1206.364071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1207.325831] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1207.339356] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1207.369950] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1208.576106] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1209.521829] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1209.535218] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1209.565951] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1209.680071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1210.633955] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1210.647572] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1210.681825] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1211.820072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1212.773958] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1212.787482] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1212.821950] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1212.936091] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1213.905960] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1213.919449] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1213.949950] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1215.152072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1216.110834] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1216.124198] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1216.157822] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1216.272089] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1217.221101] xc2028 6-0061: Loading firmware for type=D2633 DTV7 (90), id 0000000000000000.                                                                                    
[ 1217.238324] xc2028 6-0061: Loading SCODE for type=SCODE HAS_IF_5260 (60000000), id 0000000000000000.                                                                          
[ 1217.269827] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1218.408071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1219.353954] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1219.367594] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1219.402328] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1219.516068] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1220.469691] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1220.482560] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1220.513827] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1221.717071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1222.665958] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1222.679356] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1222.709829] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1222.825069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1223.769835] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1223.783193] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1223.813828] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1224.956268] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1225.897835] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1225.911204] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1225.941824] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1226.061063] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1227.010962] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1227.024581] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1227.057828] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1228.261067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1229.209836] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1229.223410] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1229.254828] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1229.368093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1230.313830] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1230.327453] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1230.361825] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1231.500096] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1232.462705] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1232.476233] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1232.509829] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1232.624066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1233.569836] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1233.582983] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1233.613830] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1234.816086] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1235.753831] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1235.767349] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1235.797830] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1235.912070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1236.862836] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1236.876235] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1236.909827] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1238.048090] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1238.997837] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1239.011236] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1239.041828] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1239.156070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1240.113837] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1240.127360] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1240.157829] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1241.364073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1242.334213] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1242.347737] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1242.381821] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1242.496081] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1243.449958] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1243.463456] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1243.497956] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1244.636074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1245.603105] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1245.616457] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1245.650826] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1245.764073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1246.754838] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1246.768329] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1246.801830] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1248.004067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1248.975840] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1248.989077] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1249.021831] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1249.137074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1250.089715] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1250.103231] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1250.137851] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1251.280095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1252.229805] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1252.243195] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1252.273826] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1252.388068] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1253.357840] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1253.371204] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1253.401862] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1254.604067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1255.573698] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1255.595070] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1255.625831] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1255.740094] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1256.689836] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1256.703334] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1256.734953] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1257.876070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1258.821962] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1258.835486] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1258.869829] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1258.984089] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1259.917957] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1259.931603] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1259.961850] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1261.164097] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1262.109966] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1262.123453] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1262.157832] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1262.273066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1263.217837] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1263.231459] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1263.265957] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1264.404093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1265.353841] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1265.367205] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1265.397830] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1265.512072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1266.473959] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1266.487483] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1266.521835] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1267.724094] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1268.682840] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1268.696071] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1268.730822] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1268.844067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1269.801960] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1269.815455] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1269.849830] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1270.993125] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1271.933836] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1271.947350] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1271.977827] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1272.092116] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1273.037961] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1273.051609] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1273.085835] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1274.288072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1275.242839] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1275.256068] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1275.289834] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1275.404030] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1276.353966] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1276.367330] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1276.397833] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1277.536106] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1278.493718] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1278.507205] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1278.537836] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1278.652093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1279.605959] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1279.619479] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1279.653831] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1280.856095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1281.813831] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1281.827212] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1281.857831] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1281.972067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1282.913835] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1282.927210] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1282.957835] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1284.096083] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1285.041987] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1285.055587] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1285.089834] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1285.204070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1286.149837] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1286.163364] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1286.193830] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1287.396075] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1288.341842] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1288.355333] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1288.386822] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1288.501069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1289.445840] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1289.459587] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1289.493836] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1290.632071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1291.585962] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1291.599585] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1291.633834] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1291.748061] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1292.705843] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1292.719116] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1292.749836] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1293.952067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1294.897963] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1294.911605] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1294.945837] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1295.060089] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1296.009838] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1296.023084] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1296.053838] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1297.192082] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1298.133844] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1298.147369] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1298.177838] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1298.292091] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1299.238986] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1299.252463] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1299.285837] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1300.488096] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1301.437715] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1301.451215] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1301.481855] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1301.596093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1302.557965] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1302.571481] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1302.605837] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1303.745071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1304.697839] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1304.711233] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1304.742839] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1304.856094] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1305.801963] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1305.815459] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1305.849833] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1307.052071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1307.993841] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1308.007339] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1308.037838] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1308.153066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1309.117722] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1309.131086] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1309.161838] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1310.300071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1311.249972] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1311.263454] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1311.297834] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1311.412063] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1312.361968] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1312.375461] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1312.409837] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1313.613119] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1314.566720] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1314.579994] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1314.613838] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1314.729082] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1315.669843] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1315.683084] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1315.713838] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1316.856060] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1317.797966] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1317.811614] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1317.841836] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1317.956070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1318.910702] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1318.923851] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1318.957821] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1320.160071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1321.102722] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1321.116066] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1321.149839] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1321.264072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1322.193846] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1322.207337] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1322.238836] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1323.380066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1324.326848] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1324.340246] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1324.373837] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1324.488074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1325.437974] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1325.451337] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1325.481841] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1326.684073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1327.637971] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1327.651608] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1327.685841] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1327.800116] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1328.725846] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1328.739087] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1328.769841] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1329.909073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1330.862847] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1330.876246] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1330.909839] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1331.024093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1331.961968] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1331.975461] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1332.009839] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1333.208072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1334.161599] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1334.175087] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1334.205966] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1334.320116] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1335.270870] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1335.284468] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1335.317837] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1336.472064] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1337.417974] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1337.431463] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1337.465838] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1337.580068] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1338.542845] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1338.556718] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1338.589844] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1339.792097] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1340.742722] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1340.756218] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1340.789842] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1340.904090] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1341.845969] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1341.859486] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1341.893844] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1343.032094] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1343.982848] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1343.996373] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1344.029968] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1344.144072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1345.093846] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1345.107360] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1345.137845] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1346.340093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1347.293709] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1347.306719] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1347.337843] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1347.452070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1348.393721] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1348.407109] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1348.437975] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1349.580096] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1350.533723] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1350.547216] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1350.577873] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1350.692066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1351.637850] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1351.651466] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1351.694833] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1352.896085] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1353.841721] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1353.855094] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1353.885970] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1354.000067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1354.942851] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1354.956376] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1354.989844] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1356.128070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1357.081722] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1357.095238] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1357.125844] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1357.245070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1358.197716] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1358.211492] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1358.245841] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1359.448072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1360.393852] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1360.407249] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1360.438837] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1360.552086] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1361.501976] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1361.515467] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1361.549841] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1362.692095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1363.637849] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1363.651217] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1363.681846] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1363.796069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1364.741724] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1364.755222] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1364.785844] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1365.988096] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1366.942839] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1366.955707] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1366.989831] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1367.104094] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1368.049852] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1368.063342] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1368.093876] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1369.248037] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1370.190853] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1370.204376] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1370.238837] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1370.353150] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1371.293726] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1371.306711] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1371.337826] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1372.540073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1373.478853] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1373.492252] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1373.525844] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1373.640092] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1374.597725] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1374.611121] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1374.641847] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1375.788096] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1376.745849] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1376.759348] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1376.789845] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1376.904063] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1377.841723] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1377.855116] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1377.885847] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1379.088094] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1380.023098] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1380.036627] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1380.069847] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1380.185112] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1381.133979] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1381.147349] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1381.177846] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1382.316072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1383.261728] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1383.275123] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1383.305974] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1383.420093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1384.365847] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1384.379474] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1384.418080] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1385.620092] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1386.569731] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1386.583218] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1386.617849] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1386.732089] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1387.685856] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1387.699096] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1387.730845] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1388.868069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1389.818854] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1389.832106] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1389.865847] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1389.980069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1390.926852] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1390.940229] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1390.973848] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1392.176122] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1393.121855] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1393.135254] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1393.165840] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1393.280074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1394.221855] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1394.235366] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1394.265850] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1395.404098] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1396.349852] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1396.363476] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1396.397845] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1396.516095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1397.465728] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1397.479100] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1397.509848] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1398.712095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1399.665727] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1399.679100] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1399.709850] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1399.824092] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1400.773727] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1400.787477] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1400.821976] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1401.968072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1402.914729] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1402.928351] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1402.961851] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1403.077112] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1404.009728] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1404.023478] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1404.057852] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1405.260075] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1406.211106] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1406.224746] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1406.257846] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1406.372095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1407.329733] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1407.343257] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1407.373850] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1408.516121] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1409.461979] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1409.475498] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1409.509848] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1409.624088] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1410.573730] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1410.587354] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1410.617849] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1411.820070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1412.761982] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1412.775601] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1412.809851] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1412.925067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1413.865856] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1413.879603] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1413.913850] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1415.056084] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1416.005856] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1416.019599] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1416.053852] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1416.168095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1417.113860] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1417.127100] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1417.157972] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1418.360065] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1419.313860] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1419.327256] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1419.357847] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1419.472073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1420.424847] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1420.440224] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1420.473851] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1421.612093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1422.549717] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1422.562757] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1422.593854] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1422.708069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1423.653984] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1423.667509] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1423.701851] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1424.904092] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1425.845981] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1425.859628] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1425.893854] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1426.008093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1426.945860] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1426.959100] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1426.989978] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1428.129069] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1429.069861] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1429.083225] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1429.113882] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1429.228071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1430.173732] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1430.187498] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1430.217848] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1431.421042] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1432.369859] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1432.383226] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1432.414842] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1432.528074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1433.477861] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1433.491355] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1433.525884] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1434.668068] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1435.614722] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1435.638252] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1435.670853] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1435.785067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1436.741857] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1436.755357] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1436.785853] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1437.988098] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1438.918861] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1438.932228] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1438.966854] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1439.080063] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1440.025732] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1440.039119] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1440.069852] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1441.208076] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1442.146861] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1442.160388] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1442.193856] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1442.308071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1443.257863] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1443.271354] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1443.301856] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1444.505078] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1445.457864] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1445.471479] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1445.505855] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1445.621114] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1446.577864] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1446.592360] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1446.625855] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1447.764074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1448.709738] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1448.722982] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1448.753858] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1448.868070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1449.810739] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1449.824383] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1449.857856] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1451.060093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1451.997738] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1452.011104] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1452.041856] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1452.156067] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1453.105862] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1453.119262] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1453.149858] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1454.296120] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1455.249734] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1455.263250] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1455.293859] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1455.409066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1456.362732] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1456.376484] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1456.409853] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1457.613070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1458.573734] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1458.587258] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1458.617860] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1458.733065] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1459.673737] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1459.687359] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1459.717856] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1460.860075] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1461.805867] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1461.819355] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1461.853853] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1461.968091] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1462.921737] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1462.935361] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1462.965858] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1464.168095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1465.113737] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1465.127264] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1465.157854] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1465.276095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1466.222986] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1466.236228] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1466.269861] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1467.408072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1468.357736] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1468.371383] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1468.402845] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1468.516095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1469.462867] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1469.476392] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1469.509859] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1470.712097] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1471.661985] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1471.675633] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1471.709856] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1471.824071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1472.781735] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1472.795376] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1472.825858] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1473.964092] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1474.930857] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1474.944506] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1474.977862] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1475.092072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1476.021737] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1476.035362] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1476.065856] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1477.268071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1478.213739] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1478.227130] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1478.257859] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1478.372095] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1479.321737] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1479.335378] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1479.365860] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1480.505071] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1481.449867] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1481.463357] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1481.497856] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1481.612066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1482.565863] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1482.579612] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1482.613861] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1483.816190] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1484.769743] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1484.782983] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1484.813851] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1484.928111] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1485.885743] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1485.899234] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1485.929857] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1487.068093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1488.013869] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1488.027358] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1488.061855] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1488.176102] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1489.122861] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1489.136255] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1489.169859] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1490.372092] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1491.318737] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1491.332642] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1491.365864] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1491.489056] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1492.434769] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1492.449979] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1492.481862] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1493.628066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1494.585870] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1494.599389] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1494.629862] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1494.744092] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1495.689868] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1495.703233] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1495.733853] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1496.940117] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1497.886870] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1497.900394] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1497.933983] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1498.048066] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1498.986024] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1498.999141] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1499.029863] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1500.168093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1501.113871] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1501.127268] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1501.157862] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1501.272074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1502.202870] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1502.218731] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1502.249864] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1503.452073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1504.393739] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1504.407239] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1504.441861] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1504.556073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1505.497746] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1505.511355] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1505.545864] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1506.684065] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1507.617743] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1507.631365] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1507.661865] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1507.776104] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1508.729735] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1508.742989] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1508.773862] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1509.976102] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1510.937741] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1510.951265] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1510.981861] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1511.096087] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1512.038868] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1512.052516] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1512.085863] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1513.232074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1514.173874] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1514.187360] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1514.221862] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1514.336077] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1515.297743] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1515.311263] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1515.341865] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1516.544097] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1517.489994] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1517.503641] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1517.537861] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1517.652063] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1518.617991] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1518.631641] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1518.665865] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1519.809058] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1520.757873] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.                                                                                  
[ 1520.771397] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.                                      
[ 1520.802866] xc2028 6-0061: Incorrect readback of firmware version.                                                                                                            
[ 1520.917064] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.                                                                                 
[ 1521.861745] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1521.875492] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1521.909863] xc2028 6-0061: Incorrect readback of firmware version.
[ 1523.112075] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1524.054748] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1524.068270] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1524.101868] xc2028 6-0061: Incorrect readback of firmware version.
[ 1524.217074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1525.153744] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1525.167383] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1525.197866] xc2028 6-0061: Incorrect readback of firmware version.
[ 1526.340109] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1527.293747] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1527.307239] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1527.337866] xc2028 6-0061: Incorrect readback of firmware version.
[ 1527.452070] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1528.401870] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1528.416411] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1528.450863] xc2028 6-0061: Incorrect readback of firmware version.
[ 1529.652075] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1530.590870] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1530.604368] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1530.637865] xc2028 6-0061: Incorrect readback of firmware version.
[ 1530.752072] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1531.702872] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1531.716510] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1531.749866] xc2028 6-0061: Incorrect readback of firmware version.
[ 1532.888074] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1533.829869] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1533.843138] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1533.873868] xc2028 6-0061: Incorrect readback of firmware version.
[ 1533.988093] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1534.937750] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1534.951239] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1534.981863] xc2028 6-0061: Incorrect readback of firmware version.
[ 1536.184092] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1537.130875] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1537.144525] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1537.177868] xc2028 6-0061: Incorrect readback of firmware version.
[ 1537.292073] xc2028 6-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 0000000000000000.
[ 1538.242744] xc2028 6-0061: Loading firmware for type=D2633 DTV78 (110), id 0000000000000000.
[ 1538.256242] xc2028 6-0061: Loading SCODE for type=DTV6 QAM DTV7 DTV78 DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0000000000000000.
[ 1538.289867] xc2028 6-0061: Incorrect readback of firmware version.
 

--------------050106070505030305040805--

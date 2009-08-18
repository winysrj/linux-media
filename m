Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out05.email.it ([212.97.34.16]:58099 "EHLO
	smtp-out05.email.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759207AbZHRPP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 11:15:59 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by smtp-out05.email.it (Postfix) with ESMTP id ED66E402C
	for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 17:15:57 +0200 (CEST)
Received: from smtp-out05.email.it ([127.0.0.1])
	by localhost (smtp-out05.email.it [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id rBn7oc23F4Nu for <linux-media@vger.kernel.org>;
	Tue, 18 Aug 2009 17:15:57 +0200 (CEST)
Received: from 95.234.91.107 (wm5.email.it [212.97.34.48])
	by smtp-out05.email.it (Postfix) with ESMTP id B5A584013
	for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 17:15:57 +0200 (CEST)
Date: Tue, 18 Aug 2009 17:15:59 +0200
To: linux-media@vger.kernel.org
From: Emanuele Deiola <e.lex@email.it>
Reply-to: Emanuele Deiola <e.lex@email.it>
Subject: em28xx and  tuner eb1a:2881 ->  temporary solution
Message-ID: <028981d27d6fb8fcd784e4d547fecea1@95.234.91.107>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I finally found a solution to run my tunerTV identified as eb1a:2881 and
based on em28xx drivers.  
I have copied the firmware xc3028.fw (found here
http://www.steventoth.net/linux/hvr1500/ )  and firmware_v3 (found here
http://konstantin.filtschew.de/v4l-firmware/) in the folder /lib/firmware.
Then I run these commands

sudo rmmod em28xx_dvb
sudo rmmod em28xx
sudo modprobe em28xx card=10 i2c_scan=1
sudo rmmod em28xx_dvb
sudo rmmod em28xx
sudo modprobe em28xx card=11 i2c_scan=1

and my tuner works well.
I remember that my tuner is this
http://www.conitech.it/conitech/ita/prod.asp?cod=CN610DVB-DT and and I use
the 2.6.31 kernel of the ubuntu team.
Now the output of "dmesg | grep em28xx" is:

"
[10860.082702] em28xx: New device @ 480 Mbps (eb1a:2881, interface 0, class
0)                                                              
[10860.082707] em28xx #0: Identified as Hauppauge WinTV HVR 900 (card=10)   
                                                               
[10860.082871] em28xx #0: chip ID is em2882/em2883                          
                                                               
[10860.259158] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 03
6a 20 6a 00                                                    
[10860.259190] em28xx #0: i2c eeprom 10: 00 00 04 57 64 80 00 00 60 f4 00 00
02 02 00 00                                                    
[10860.259220] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00 00 00
5b 1e 00 00                                                    
[10860.259248] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00
00 00 00 00                                                    
[10860.259277] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[10860.259305] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[10860.259333] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 53 00                                                    
[10860.259361] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00
20 00 56 00                                                    
[10860.259389] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00
00 00 00 00                                                    
[10860.259417] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[10860.259445] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[10860.259474] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[10860.259518] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[10860.259546] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[10860.259574] em28xx #0: i2c eeprom e0: 5a 00 55 aa e5 2b 59 03 00 17 fc 01
00 00 00 00                                                    
[10860.259603] em28xx #0: i2c eeprom f0: 00 00 00 01 00 00 00 00 00 00 00 00
00 00 00 00                                                    
[10860.259633] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x4dea2120   
                                                               
[10860.259638] em28xx #0: EEPROM info:                                      
                                                               
[10860.259642] em28xx #0:       AC97 audio (5 sample rates)                 
                                                               
[10860.259647] em28xx #0:       USB Remote wakeup capable                   
                                                               
[10860.259651] em28xx #0:       500mA max power                             
                                                               
[10860.259657] em28xx #0:       Table at 0x04, strings=0x206a, 0x006a,
0x0000                                                               
[10860.294498] em28xx #0: found i2c device @ 0xa0 [eeprom]                  
                                                               
[10860.299115] em28xx #0: found i2c device @ 0xb8 [tvp5150a]                
                                                               
[10860.301115] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]          
                                                               
[10860.318921] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)                
                                                               
[10860.324045] tuner 3-0061: chip found @ 0xc2 (em28xx #0)                  
                                                               
[10860.324140] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/input/input15                     
                
[10860.324352] em28xx #0: Config register raw data: 0x58                    
                                                               
[10860.325104] em28xx #0: AC97 vendor ID = 0xffffffff                       
                                                               
[10860.325489] em28xx #0: AC97 features = 0x6a90                            
                                                               
[10860.325491] em28xx #0: Empia 202 AC97 audio processor detected           
                                                               
[10860.565878] em28xx #0: v4l2 driver version 0.1.2                         
                                                               
[10860.652239] em28xx #0: V4L2 device registered as /dev/video1 and
/dev/vbi0                                                               
[10860.652267] usbcore: registered new interface driver em28xx              
                                                               
[10860.652270] em28xx driver loaded                                         
                                                               
[10860.782585] em28xx #0/2: xc3028 attached                                 
                                                               
[10860.782587] DVB: registering new adapter (em28xx #0)                     
                                                               
[10860.784221] Successfully loaded em28xx-dvb                               
                                                               
[10862.248405] usbcore: deregistering interface driver em28xx               
                                                               
[10862.248430] em28xx #0: disconnecting em28xx #0 video                     
                                                               
[10862.284067] em28xx #0: V4L2 device /dev/vbi0 deregistered                
                                                               
[10862.284185] em28xx #0: V4L2 device /dev/video1 deregistered              
                                                               
[10863.095071] em28xx: New device @ 480 Mbps (eb1a:2881, interface 0, class
0)                                                              
[10863.095078] em28xx #0: Identified as Terratec Hybrid XS (card=11)        
                                                               
[10863.095252] em28xx #0: chip ID is em2882/em2883                          
                                                               
[10863.255407] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 03
6a 20 6a 00                                                    
[10863.255440] em28xx #0: i2c eeprom 10: 00 00 04 57 64 80 00 00 60 f4 00 00
02 02 00 00                                                    
[10863.255469] em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 01 00 b8 00 00 00
5b 1e 00 00                                                    
[10863.255498] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00
00 00 00 00                                                    
[10863.255526] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[10863.255554] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[10863.255582] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 53 00
[10863.255611] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00
20 00 56 00
[10863.255639] em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00
00 00 00 00
[10863.255667] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[10863.255703] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[10863.255731] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[10863.255759] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[10863.255787] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00
[10863.255815] em28xx #0: i2c eeprom e0: 5a 00 55 aa e5 2b 59 03 00 17 fc 01
00 00 00 00
[10863.255843] em28xx #0: i2c eeprom f0: 00 00 00 01 00 00 00 00 00 00 00 00
00 00 00 00
[10863.255874] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x4dea2120
[10863.255879] em28xx #0: EEPROM info:
[10863.255883] em28xx #0:       AC97 audio (5 sample rates)
[10863.255888] em28xx #0:       USB Remote wakeup capable
[10863.255892] em28xx #0:       500mA max power
[10863.255898] em28xx #0:       Table at 0x04, strings=0x206a, 0x006a,
0x0000
[10863.262273] em28xx #0: found i2c device @ 0x1e [???]
[10863.304144] em28xx #0: found i2c device @ 0xa0 [eeprom]
[10863.308888] em28xx #0: found i2c device @ 0xb8 [tvp5150a]
[10863.311008] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
[10863.325552] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[10863.329594] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[10864.516289] em28xx #0: Config register raw data: 0x58
[10864.517385] em28xx #0: AC97 vendor ID = 0xffffffff
[10864.517914] em28xx #0: AC97 features = 0x6a90
[10864.517920] em28xx #0: Empia 202 AC97 audio processor detected
[10864.728935] em28xx #0: v4l2 driver version 0.1.2
[10864.800468] em28xx #0: V4L2 device registered as /dev/video1 and
/dev/vbi0
[10864.822120] usbcore: registered new interface driver em28xx
[10864.822129] em28xx driver loaded
[10864.865858] em28xx #0/2: xc3028 attached
[10864.865861] DVB: registering new adapter (em28xx #0)
[10864.866164] Successfully loaded em28xx-dvb
"

Thanks for the your support and if there are news you contact me.
                                                     
                                                                      
Regards,
                                                                            
Emanuele 
 --
 Caselle da 1GB, trasmetti allegati fino a 3GB e in piu' IMAP, POP3 e SMTP
autenticato? GRATIS solo con Email.it: http://www.email.it/f
 
 Sponsor:
 Ricevi e invia messaggi di posta, instant messaging e rimani in contatto
ovunque ti trovi direttamente dal cellulare, con m.email. Provalo
gratuitamente
 Clicca qui: http://adv.email.it/cgi-bin/foclick.cgi?mid=8920&d=20090818



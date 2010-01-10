Return-path: <linux-media-owner@vger.kernel.org>
Received: from col0-omc2-s8.col0.hotmail.com ([65.55.34.82]:38781 "EHLO
	col0-omc2-s8.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752390Ab0AJTXy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jan 2010 14:23:54 -0500
Message-ID: <COL103-W13FD611A97D4661E1F1404D16E0@phx.gbl>
From: Carlo Cancellieri <ccancellieri@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: =?windows-1256?Q?Unstable_L?= =?windows-1256?Q?ifeView_Fl?=
 =?windows-1256?Q?yDVB_Hybri?= =?windows-1256?Q?d_PCI_supp?=
 =?windows-1256?Q?ort=FE?=
Date: Sun, 10 Jan 2010 19:23:53 +0000
Content-Type: text/plain; charset="windows-1256"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hy,
I've a serious problem with my LifeView FlyDVB Hybrid PCI card.
I've tried many different settings (i2c_scan, card, and all other suggestions found on the web)
but the dvb-t card functionality is still very random.

Here is the 'Everyday' dmesg saa7134 log:
-----------------------------------------------------------------------------------
...
saa7130/34: v4l2 driver version 0.2.15 loaded                     
saa7134 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18  
saa7133[0]: found at 0000:05:02.0, rev: 209, irq: 18, latency: 64, mmio: 0xfebff800
saa7133[0]: subsystem: 5168:3306, board: LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB [card=94,autodetected]
saa7133[0]: board init: gpio is 210000                                                                                 
IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs                                                      
saa7133[0]: i2c eeprom 00: 68 51 06 33 54 20 1c 00 43 43 a9 1c 55 d2 b2 92                                             
saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 16 ff ff ff ff                                             
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff                                             
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
tuner 0-004b: chip found @ 0x96 (saa7133[0])                                                                           
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                        
nvidia 0000:01:00.0: setting latency timer to 64                                                                       
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  190.53  Wed Dec  9 15:29:46 PST 2009                                   
tda829x 0-004b: setting tuner address to 61                                                                            
tda829x 0-004b: type set to tda8290+75a                                                                                
saa7133[0]: registered device video0 [v4l2]                                                                            
saa7133[0]: registered device vbi0                                                                                     
saa7133[0]: registered device radio0                                                                                   
dvb_init() allocating 1 frontend                                                                                       
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision ea -- invalid
tda1004x: trying to boot from eeprom
tda1004x: found firmware revision ea -- invalid
tda1004x: waiting for firmware upload...
saa7134 0000:05:02.0: firmware: requesting dvb-fe-tda10046.fw
tda1004x: Error during firmware upload
tda1004x: found firmware revision ea -- invalid
tda1004x: firmware upload failed
tda827x_probe_version: could not read from tuner at addr: 0xc2
saa7134 ALSA driver for DMA sound loaded
IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 18 registered as card -1
...
---------------------------------------------------------------------------------------
But sometime, (rarely), my card is correctly loaded:
---------------------------------------------------------------------------------------
.... 
saa7130/34: v4l2 driver version 0.2.15 loaded                     
saa7134 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18  
saa7133[0]: found at 0000:05:02.0, rev: 209, irq: 18, latency: 64, mmio: 0xfebff800
saa7133[0]: subsystem: 5168:3306, board: LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB [card=94,autodetected]
saa7133[0]: board init: gpio is 210000                                                                                 
IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs                                                      
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                        
nvidia 0000:01:00.0: setting latency timer to 64                                                                       
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  190.53  Wed Dec  9 15:29:46 PST 2009                                   
saa7133[0]: i2c eeprom 00: 68 51 06 33 54 20 1c 00 43 43 a9 1c 55 d2 b2 92                                             
saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 16 ff ff ff ff                                             
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff                                             
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
tuner 0-004b: chip found @ 0x96 (saa7133[0])                                                                           
tda829x 0-004b: setting tuner address to 61                                                                            
tda829x 0-004b: type set to tda8290+75a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
dvb_init() allocating 1 frontend
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
tda1004x: setting up plls for 48MHz sampling clock
tda1004x: found firmware revision ea -- invalid
tda1004x: trying to boot from eeprom
...
tda1004x: timeout waiting for DSP ready
tda1004x: found firmware revision 0 -- invalid
tda1004x: waiting for firmware upload...
saa7134 0000:05:02.0: firmware: requesting dvb-fe-tda10046.fw
tda1004x: found firmware revision 29 -- ok
saa7134 ALSA driver for DMA sound loaded
IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 18 registered as card -1
...
--------------------------------------------------------------------------------------------
but after 5 or 6 channel changing using kaffeine dmesg shows again the following messages:
--------------------------------------------------------------------------------------------
...
tda1004x: Error during firmware upload
tda1004x: found firmware revision ea -- invalid
tda1004x: firmware upload failed
tda827x_probe_version: could not read from tuner at addr: 0xc2
tda827x_probe_version: could not read from tuner at addr: 0xc2
...
tda827x_probe_version: could not read from tuner at addr: 0xc2
--------------------------------------------------------------------------------------------
Could you help me please?
Do you need more debugging information?
Actually (as shown into the log) module is loaded without any options.
Thank you for your suggestions! 		 	   		   		 	   		  
_________________________________________________________________
Non sei a casa? Prova il nuovo Web Messenger
http://www.messenger.it/web/default.aspx

Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <peter_s_d@fastmail.com.au>) id 1NcAcU-00066h-5Q
	for linux-dvb@linuxtv.org; Tue, 02 Feb 2010 05:44:12 +0100
Received: from pecan.exetel.com.au ([220.233.0.17] helo=smtp.po.exetel.com.au)
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NcAcS-0001Tg-Gg; Tue, 02 Feb 2010 05:44:09 +0100
Received: from 154.139.70.115.static.exetel.com.au ([115.70.139.154]
	helo=live.home.invalid)
	by smtp.po.exetel.com.au with esmtp (Exim 4.68)
	(envelope-from <peter_s_d@fastmail.com.au>) id 1NcAcJ-0004mL-Rt
	for linux-dvb@linuxtv.org; Tue, 02 Feb 2010 15:44:01 +1100
From: "Peter D." <peter_s_d@fastmail.com.au>
To: linux-dvb@linuxtv.org
Date: Tue, 2 Feb 2010 15:43:56 +1100
References: <COL103-W206A6BDBE19494AAF20591D16E0@phx.gbl>
In-Reply-To: <COL103-W206A6BDBE19494AAF20591D16E0@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201002021543.57374.peter_s_d@fastmail.com.au>
Subject: Re: [linux-dvb] Unstable LifeView FlyDVB Hybrid PCI support
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi, 

I've got one of those cards.  It used to work, but doesn't any more.  

I was assuming that the card was broken.  Did something change in 
the driver maybe 12 months ago?  


sig goes here...
Peter D.


On Mon, 11 Jan 2010, Carlo Cancellieri wrote:
> 
> Hy,
> I've a serious problem with my LifeView FlyDVB Hybrid PCI card.
> I've tried many different settings (i2c_scan, card, and all other suggestions found on the web)
> but the dvb-t card functionality is still very random.
> 
> Here is the 'Everyday' dmesg saa7134 log:
> -----------------------------------------------------------------------------------
> ...
> saa7130/34: v4l2 driver version 0.2.15 loaded                     
> saa7134 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18  
> saa7133[0]: found at 0000:05:02.0, rev: 209, irq: 18, latency: 64, mmio: 0xfebff800
> saa7133[0]: subsystem: 5168:3306, board: LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB [card=94,autodetected]
> saa7133[0]: board init: gpio is 210000                                                                                 
> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs                                                      
> saa7133[0]: i2c eeprom 00: 68 51 06 33 54 20 1c 00 43 43 a9 1c 55 d2 b2 92                                             
> saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 16 ff ff ff ff                                             
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff                                             
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> tuner 0-004b: chip found @ 0x96 (saa7133[0])                                                                           
> nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                        
> nvidia 0000:01:00.0: setting latency timer to 64                                                                       
> NVRM: loading NVIDIA UNIX x86_64 Kernel Module  190.53  Wed Dec  9 15:29:46 PST 2009                                   
> tda829x 0-004b: setting tuner address to 61                                                                            
> tda829x 0-004b: type set to tda8290+75a                                                                                
> saa7133[0]: registered device video0 [v4l2]                                                                            
> saa7133[0]: registered device vbi0                                                                                     
> saa7133[0]: registered device radio0                                                                                   
> dvb_init() allocating 1 frontend                                                                                       
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision ea -- invalid
> tda1004x: trying to boot from eeprom
> tda1004x: found firmware revision ea -- invalid
> tda1004x: waiting for firmware upload...
> saa7134 0000:05:02.0: firmware: requesting dvb-fe-tda10046.fw
> tda1004x: Error during firmware upload
> tda1004x: found firmware revision ea -- invalid
> tda1004x: firmware upload failed
> tda827x_probe_version: could not read from tuner at addr: 0xc2
> saa7134 ALSA driver for DMA sound loaded
> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 18 registered as card -1
> ...
> ---------------------------------------------------------------------------------------
> But sometime, (rarely), my card is correctly loaded:
> ---------------------------------------------------------------------------------------
> .... 
> saa7130/34: v4l2 driver version 0.2.15 loaded                     
> saa7134 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18  
> saa7133[0]: found at 0000:05:02.0, rev: 209, irq: 18, latency: 64, mmio: 0xfebff800
> saa7133[0]: subsystem: 5168:3306, board: LifeView FlyDVB-T Hybrid Cardbus/MSI TV @nywhere A/D NB [card=94,autodetected]
> saa7133[0]: board init: gpio is 210000                                                                                 
> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs                                                      
> nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16                                                        
> nvidia 0000:01:00.0: setting latency timer to 64                                                                       
> NVRM: loading NVIDIA UNIX x86_64 Kernel Module  190.53  Wed Dec  9 15:29:46 PST 2009                                   
> saa7133[0]: i2c eeprom 00: 68 51 06 33 54 20 1c 00 43 43 a9 1c 55 d2 b2 92                                             
> saa7133[0]: i2c eeprom 10: 00 00 62 08 ff 20 ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 16 ff ff ff ff                                             
> saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 05 01 01 16 32 15 ff ff ff ff                                             
> saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff                                             
> tuner 0-004b: chip found @ 0x96 (saa7133[0])                                                                           
> tda829x 0-004b: setting tuner address to 61                                                                            
> tda829x 0-004b: type set to tda8290+75a
> saa7133[0]: registered device video0 [v4l2]
> saa7133[0]: registered device vbi0
> saa7133[0]: registered device radio0
> dvb_init() allocating 1 frontend
> DVB: registering new adapter (saa7133[0])
> DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
> tda1004x: setting up plls for 48MHz sampling clock
> tda1004x: found firmware revision ea -- invalid
> tda1004x: trying to boot from eeprom
> ...
> tda1004x: timeout waiting for DSP ready
> tda1004x: found firmware revision 0 -- invalid
> tda1004x: waiting for firmware upload...
> saa7134 0000:05:02.0: firmware: requesting dvb-fe-tda10046.fw
> tda1004x: found firmware revision 29 -- ok
> saa7134 ALSA driver for DMA sound loaded
> IRQ 18/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 18 registered as card -1
> ...
> --------------------------------------------------------------------------------------------
> but after 5 or 6 channel changing using kaffeine dmesg shows again the following messages:
> --------------------------------------------------------------------------------------------
> ...
> tda1004x: Error during firmware upload
> tda1004x: found firmware revision ea -- invalid
> tda1004x: firmware upload failed
> tda827x_probe_version: could not read from tuner at addr: 0xc2
> tda827x_probe_version: could not read from tuner at addr: 0xc2
> ...
> tda827x_probe_version: could not read from tuner at addr: 0xc2
> --------------------------------------------------------------------------------------------
> Could you help me please?
> Do you need more debugging information?
> Actually (as shown into the log) module is loaded without any options.
> Thank you for your suggestions! 		 	   		  
> _________________________________________________________________
> Un mondo di personalizzazioni per Messenger, PC e cellulare
> http://www.pimpit.it/


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

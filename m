Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:35051 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036AbZCWHdI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Mar 2009 03:33:08 -0400
Received: by bwz17 with SMTP id 17so1617849bwz.37
        for <linux-media@vger.kernel.org>; Mon, 23 Mar 2009 00:33:03 -0700 (PDT)
Message-ID: <49C73AFC.7010405@gmail.com>
Date: Mon, 23 Mar 2009 08:32:12 +0100
From: Laurent Gougeon <laurent.gougeon@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: AverMedia M115 (inside Acer Aspire WMLI 5510) not working fine with
 kernel 2.6.27-19 / Mandriva 2009.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I'm trying to get this piece of HW working under linux. This is the only 
part of the HW I could'nt get up/running yet in that laptop with linux.

M115 is working fine with WinXP, of course.

Here is the dmesg output :


saa7130/34: v4l2 driver version 0.2.14 
loaded                                                                     
Yenta: ISA IRQ mask 0x0cf8, PCI irq 
18                                                                           
 
Socket status: 
30000006                                                                                          
 
Yenta: Raising subordinate bus# of parent bus (#06) from #07 to 
#08                                               
pcmcia: parent PCI bridge I/O window: 0x4000 - 
0x4fff                                                             
cs: IO port probe 0x4000-0x4fff: 
clean.                                                                          
 
pcmcia: parent PCI bridge Memory window: 0xc8200000 - 
0xc82fffff                                                  
pcmcia: parent PCI bridge Memory window: 0x50000000 - 
0x53ffffff                                                  
saa7134 0000:06:02.0: PCI INT A -> GSI 17 (level, low) -> IRQ 
17                                                  
saa7133[0]: found at 0000:06:02.0, rev: 209, irq: 17, latency: 32, mmio: 
0xc8217800                               
saa7133[0]: subsystem: 1461:a836, board: Avermedia M115 [card=138,insmod 
option]                                  
saa7133[0]: board init: gpio is 
a400000                                                                          
 
saa7133[0]: i2c eeprom 00: 61 14 36 a8 00 00 00 00 00 00 00 00 00 00 00 
00                                        
saa7133[0]: i2c eeprom 10: ff ff ff ff ff 20 ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 01 01 03 08 ff 00 c0 ff ff ff 
ff                                        
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom 40: ff 65 00 ff c2 1e ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff                                        
saa7133[0]: i2c scan: found device @ 0xa0  
[eeprom]                                                               
saa7133[0]: i2c scan: found device @ 0xc2  
[???]                                                                  
tuner' 1-0061: chip found @ 0xc2 
(saa7133[0])                                                                    
 
xc2028 1-0061: creating new 
instance                                                                             
 
xc2028 1-0061: type set to XCeive xc2028/xc3028 
tuner                                                             
firmware: requesting 
xc3028-v27.fw                                                                               
 
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: 
xc2028 firmware, ver 2.7                      
xc2028 1-0061: Loading firmware for type=BASE F8MHZ MTS (7), id 
0000000000000000.                                 
ieee1394: Host added: ID:BUS[0-00:1023]  
GUID[00c09f0000683ec1]                                                   
MTS (4), id 
00000000000000ff:                                                                                    
 
xc2028 1-0061: Loading firmware for type=MTS (4), id 
0000000100000007.                                            
saa7133[0]: registered device video0 
[v4l2]                                                                      
 
saa7133[0]: registered device vbi0   




When running TVTIME, I can scan for UHF channel (France) and signal is 
somehow found on the main analog broadcast channels.
However, image is fuzzy (I'll upload some captures later), like if SECAM 
was not selected, but some kind of special PAL config somewhere.
However fuzzy image is in color only in SECAM, so SECAM color decoder is 
really started. Only video sync part is not working.

I can also select Composite Input, which I could so far only test with a 
PAL source, image is perfect.


Also, even if module 7134_alsa is loaded, no sound in either composite 
input or analog Tuner.

And finally, the DVB stuff is not found by Xine/Kaffeine.



I'd like to try the set of drivers from mercury reposal but so far I 
could'nt build (will post later on errors I have)


any hints ?


Rgds

Laurent



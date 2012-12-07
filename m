Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51968 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab2LGQOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Dec 2012 11:14:22 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so310577bkw.19
        for <linux-media@vger.kernel.org>; Fri, 07 Dec 2012 08:14:21 -0800 (PST)
Message-ID: <50C215D6.1040607@gmail.com>
Date: Fri, 07 Dec 2012 21:14:14 +0500
From: Saad Bin Javed <sbjaved@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Kworld PCI Analog TV Card PVR-7134SE setup
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, its my first message to this mailing list. I've been trying to get 
Kworld pci analog pvr 7134se to work in linux. Googling shows that i 
have to specify my card number and tuner no. myself. So far using 
card=153 and tuner=56, I get no video output in tvtime . It seems my 
card gets recognized but it won't recognize the tuner correctly. I've 
tried tuner=43, 17, 5, 37 as well with no luck.

Here is a picture of my card with all the onboard chip details listed:
http://tinypic.com/r/2lwnmuc/6

Here is card info & dmesg output:

Code:
02:00.0 Multimedia controller [0480]: Philips Semiconductors 
SAA7134/SAA7135HL Video Broadcast Decoder [1131:7134] (rev 01)
     Subsystem: KWorld Computer Co. Ltd. Device [17de:712b]
     Flags: bus master, medium devsel, latency 32, IRQ 11
     Memory at fe400000 (32-bit, non-prefetchable) [size=1K]
     Capabilities: <access denied>
     Kernel modules: saa7134
Code:
saad@Home-Server:~$ dmesg | grep saa
[  303.242493] saa7130/34: v4l2 driver version 0, 2, 17 loaded
[  303.242537] saa7134 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[  303.242545] saa7134[0]: found at 0000:02:00.0, rev: 1, irq: 16, 
latency: 32, mmio: 0xfe400000
[  303.242556] saa7134[0]: subsystem: 17de:712b, board: Kworld Plus TV 
Analog Lite PCI [card=153,insmod option]
[  303.242578] saa7134[0]: board init: gpio is 80407f
[  303.268375] input: saa7134 IR (Kworld Plus TV Anal as 
/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/0000:02:00.0/rc/rc0/input7
[  303.268430] rc0: saa7134 IR (Kworld Plus TV Anal as 
/devices/pci0000:00/0000:00:1c.0/0000:01:00.0/0000:02:00.0/rc/rc0
[  303.416001] saa7134[0]: i2c eeprom 00: de 17 2b 71 10 28 ff ff ff ff 
ff ff ff ff ff ff
[  303.416014] saa7134[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416024] saa7134[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416034] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416043] saa7134[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416053] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416063] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416073] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416083] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416093] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416102] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416112] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416122] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416132] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416142] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.416152] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff ff ff
[  303.423176] i2c-core: driver [tuner] using legacy suspend method
[  303.423187] i2c-core: driver [tuner] using legacy resume method
[  303.422949] All bytes are equal. It is not a TEA5767
[  303.422959] tuner 14-0060: Tuner -1 found with type(s) Radio TV.
[  303.445817] tea5767 14-0060: type set to Philips TEA5767HN FM Radio
[  303.495999] saa7134[0]: registered device video0 [v4l2]
[  303.496552] saa7134[0]: registered device vbi0
[  303.498308] saa7134[0]: registered device radio0
[  303.502661] saa7134 ALSA driver for DMA sound loaded
[  303.502694] saa7134[0]/alsa: saa7134[0] at 0xfe400000 irq 16 
registered as card -2

Any help...?

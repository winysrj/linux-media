Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40417 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZLSOAp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Dec 2009 09:00:45 -0500
Received: by ewy19 with SMTP id 19so2455221ewy.1
        for <linux-media@vger.kernel.org>; Sat, 19 Dec 2009 06:00:43 -0800 (PST)
From: Antonio Marcos =?utf-8?q?L=C3=B3pez_Alonso?=
	<amlopezalonso@gmail.com>
Reply-To: amlopezalonso@gmail.com
To: linux-media@vger.kernel.org
Subject: How to make a Zaapa LR301AP DVB-T card work
Date: Sat, 19 Dec 2009 14:00:37 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912191400.37814.amlopezalonso@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I borrowed a Zaapa LR301AP DVB-T card from a friend to try to make it work in 
Linux, so I kindly request your help. The card features one antenna input, one 
IR input (remote and sensor wire being lost) and one AV input. Here follows 
the system info:


On-board printed info:
************************
Main chip: Philips SAA 7134 HL
Other chips: TDA 10046A, TDA 8274, MDT 2005ES-G.

lspci -vnn
****************
00:0c.0 Multimedia controller [0480]: Philips Semiconductors SAA7134/SAA7135HL 
Video Broadcast Decoder [1131:7134] (rev 01)
Subsystem: Device [4e42:0301]                                                                                      
Flags: bus master, medium devsel, latency 64, IRQ 11                                                               
Memory at dffffc00 (32-bit, non-prefetchable) [size=1K]                                                            
Capabilities: [40] Power Management version 1                                                                      
Kernel driver in use: saa7134                                         

dmesg | grep saa
*******************
saa7130/34: v4l2 driver version 0.2.15 loaded                                                                                                                                                         
[    8.854415] saa7134 0000:00:0c.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, 
low) -> IRQ 11
[    8.854423] saa7134[0]: found at 0000:00:0c.0, rev: 1, irq: 11, latency: 
64, mmio: 0xdffffc00
[    8.854430] saa7134[0]: subsystem: 4e42:0301, board: UNKNOWN/GENERIC 
[card=0,autodetected]
[    8.854453] saa7134[0]: board init: gpio is 10000
[    8.854458] IRQ 11/saa7134[0]: IRQF_DISABLED is not guaranteed on shared 
IRQs
[    9.004012] saa7134[0]: i2c eeprom 00: 42 4e 01 03 54 20 1c 00 43 43 a9 1c 
55 d2 b2 92
[    9.004022] saa7134[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff 
ff ff ff ff
[    9.004030] saa7134[0]: i2c eeprom 20: 01 40 01 03 03 01 01 03 08 ff 01 e2 
ff ff ff ff
[    9.004038] saa7134[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004045] saa7134[0]: i2c eeprom 40: ff 1b 00 c0 ff 10 01 00 ff ff ff ff 
ff ff ff ff
[    9.004052] saa7134[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004059] saa7134[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004067] saa7134[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004074] saa7134[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004081] saa7134[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004089] saa7134[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004096] saa7134[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004103] saa7134[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004111] saa7134[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004118] saa7134[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004125] saa7134[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff ff
[    9.004271] saa7134[0]: registered device video0 [v4l2]
[    9.004299] saa7134[0]: registered device vbi0
[    9.565411] saa7134 ALSA driver for DMA sound loaded
[    9.565424] IRQ 11/saa7134[0]: IRQF_DISABLED is not guaranteed on shared 
IRQs
[    9.565451] saa7134[0]/alsa: saa7134[0] at 0xdffffc00 irq 11 registered as 
card -1
[ 3368.737762] saa7134[0]/irq[10,4295734480]: r=0x20 s=0x00 PE
[ 3368.737770] saa7134[0]/irq: looping -- clearing PE (parity error!) enable 
bit
************************************************************************************

No DVB-T button appears in Kaffeine, so the card is not being detected by the 
app.

Thanks for any help
Antonio

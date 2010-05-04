Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:43160 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757873Ab0EDMaM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 May 2010 08:30:12 -0400
MIME-version: 1.0
Content-type: Text/Plain; charset=utf-8
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-1.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0L1W009N89CBWD60@mta-1.ms.rz.RWTH-Aachen.de> for
 linux-media@vger.kernel.org; Tue, 04 May 2010 14:00:11 +0200 (CEST)
Received: from adenauer.localnet ([unknown] [137.226.115.15])
 by relay-auth-1.ms.rz.rwth-aachen.de
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec  9 2008))
 with ESMTPA id <0L1W005VM9CB8L60@relay-auth-1.ms.rz.rwth-aachen.de> for
 linux-media@vger.kernel.org; Tue, 04 May 2010 14:00:11 +0200 (CEST)
From: Jan =?utf-8?q?M=C3=B6bius?= <jan_moebius@web.de>
To: linux-media@vger.kernel.org
Subject: Hauppauge HVR-4400
Date: Tue, 04 May 2010 14:00:10 +0200
Content-transfer-encoding: 8BIT
Message-id: <201005041400.10530.jan_moebius@web.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

im trying to get a Hauppauge HVR-4400 working on a Debian squeeze. It seems to 
be unsopported yet. Is there any driver which i don't know about?

If not i would really like to help getting it supported (information, 
testing,...)

Some information i get from the card:

Hauppauge HVR-4400 ( should be some kind of 4000 but with a pci-express 
interface )

04:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. Hauppauge 
Inc. HDPVR-1250 model 1196 [14f1:8880] (rev 04)
        Subsystem: Hauppauge computer works Inc. Device [0070:c108]                                                         
        Flags: fast devsel, IRQ 18                                                                                          
        Memory at e2000000 (64-bit, non-prefetchable) [size=2M]                                                             
        Capabilities: [40] Express Endpoint, MSI 00                                                                         
        Capabilities: [80] Power Management version 3                                                                       
        Capabilities: [90] Vital Product Data                                                                               
        Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+                                                          
        Capabilities: [100] Advanced Error Reporting                                                                        
        Capabilities: [200] Virtual Channel 
        
The driver trying to access the card is cx23885 and it does not know the card 
and therefore falls back to generic.

If i force the driver to use the card HVR-1800 i get the following kernel log:
( Maybe this info is not reliable?! )

CORE cx23885[0]: subsystem: 0070:c108, board: Hauppauge WinTV-HVR1800 
[card=2,insmod option]
tveeprom 2-0050: Hauppauge model 121019, rev B2F5, serial# 7157617
tveeprom 2-0050: MAC address is 00:0d:fe:6d:37:71
tveeprom 2-0050: tuner model is NXP 18271C2 (idx 155, type 54)
tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB 
Digital (eeprom 0xf4)
tveeprom 2-0050: audio processor is CX23888 (idx 40)
tveeprom 2-0050: decoder processor is CX23888 (idx 34)
tveeprom 2-0050: has radio, has IR receiver, has no IR transmitter
cx23885[0]: warning: unknown hauppauge model #121019
cx23885[0]: hauppauge eeprom: model=121019
cx25840 4-0044: cx23888 A/V decoder found @ 0x88 (cx23885[0])
cx25840 4-0044: firmware: requesting v4l-cx23885-avcore-01.fw
cx25840 4-0044: loaded v4l-cx23885-avcore-01.fw firmware (32522 bytes)
tuner 3-0042: chip found @ 0x84 (cx23885[0])
tda9887 3-0042: creating new instance
tda9887 3-0042: tda988[5/6/7] found
tda9887 3-0042: destroying instance
tda8290: no gate control were provided!
cx23885[0]/0: registered device video1 [v4l2]
cx23885[0]: registered device video2 [mpeg]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
cx23885[0]: frontend initialization failed
cx23885_dvb_register() dvb_register failed err = -1
cx23885_dev_setup() Failed to register dvb on VID_C
cx23885_dev_checkrevision() Hardware revision = 0xd0
cx23885[0]/0: found at 0000:04:00.0, rev: 4, irq: 18, latency: 0, mmio: 
0xe2000000
cx23885 0000:04:00.0: setting latency timer to 64
IRQ 18/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs

Best Regards,
Jan Möbius

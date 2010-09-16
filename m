Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55223 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0IPOXN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 10:23:13 -0400
Received: by qyk33 with SMTP id 33so1267696qyk.19
        for <linux-media@vger.kernel.org>; Thu, 16 Sep 2010 07:23:12 -0700 (PDT)
Subject: Hauppauge WinTV-HVR1800 dual tuner help needed
From: Jack Snodgrass <jacksnodgrass@mylinuxguy.net>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 09:23:10 -0500
Message-ID: <1284646990.2917.14.camel@i7.private.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I bought a 
Hauppauge WinTV-HVR-1800 HDTV Tuner Capture Card PCI-e
off of ebay for $30 and need some help getting the 2nd tuner activated
( if it's even possible ) 

The card pictured in the auction looks exactly like the one I received,
but it doesn't look anything like the one listed on: 
http://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1800

The card I have has 2 antenna connectors ( no other connectors at
all )... a very basic looking card. 

I want to get both tuners tuning dvb ( digital ) qcam signals off of my
FIOS TV Cable cable. 
I have have gotten the qcam stuff working on a 
DViCO FusionHDTV 5 Lite
and a
Hauppauge WinTV-HVR1200 pcie 
board so I know that that part is ok. 

I can get a single tuner working on the WinTV-HVR-1800 card... dmesg,
lscpi, etc for the card are below... 

( I'm only trying to get the major networks ( abc, cbs, fox, etc ) that
are not encrypted... ) 

I'm running fedora 13, but I have compiled / installed the latest ( as
of a few days ago ) v4l-dvv drivers
from the v4l-dvb site.... 

dmesg reports:
Linux video capture interface: v2.00
cx23885 driver version 0.0.2 loaded
cx23885 0000:08:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
CORE cx23885[0]: subsystem: 0070:7809, board: Hauppauge WinTV-HVR1800
[card=2,autodetected]
tveeprom 1-0050: Hauppauge model 78631, rev C1E9, serial# 2876620
tveeprom 1-0050: MAC address is 00:0d:fe:2b:e4:cc
tveeprom 1-0050: tuner model is Philips 18271_8295 (idx 149, type 54)
tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 1-0050: audio processor is CX23887 (idx 42)
tveeprom 1-0050: decoder processor is CX23887 (idx 37)
tveeprom 1-0050: has no radio
cx23885[0]: hauppauge eeprom: model=78631
cx25840 3-0044: cx23887 A/V decoder found @ 0x88 (cx23885[0])
cx25840 3-0044: firmware: requesting v4l-cx23885-avcore-01.fw
cx25840 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
tuner 2-0042: chip found @ 0x84 (cx23885[0])
tda829x 2-0042: could not clearly identify tuner address, defaulting to
60
tda18271 2-0060: creating new instance
TDA18271HD/C1 detected @ 2-0060
tda829x 2-0042: type set to tda8295+18271
cx23885[0]/0: registered device video0 [v4l2]
cx23885[0]: registered device video1 [mpeg]
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
MT2131: successfully identified at address 0x61
DVB: registering new adapter (cx23885[0])
DVB: registering adapter 0 frontend 0 (Samsung S5H1409 QAM/8VSB
Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xb1
cx23885[0]/0: found at 0000:08:00.0, rev: 15, irq: 19, latency: 0, mmio:
0xf2e00000
cx23885 0000:08:00.0: setting latency timer to 64
IRQ 19/cx23885[0]: IRQF_DISABLED is not guaranteed on shared IRQs

lspci reports: 
08:00.0 Multimedia video controller: Conexant Systems, Inc. Hauppauge
Inc. HDPVR-1250 model 1196 (rev 0f)

find on /dev/dvb reports: 
/dev/dvb
/dev/dvb/adapter0
/dev/dvb/adapter0/net0
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/demux0
/dev/dvb/adapter0/frontend0

I also have  /dev/video0 and /dev/video1 devices listed....

lsmod | egrep "tuner|cx23885|dvb|vl4"
cx23885               102191  0 
tuner                  15518  1 
cx2341x                 9306  1 cx23885
v4l2_common            13545  4 cx23885,tuner,cx25840,cx2341x
videodev               34211  4 cx23885,tuner,cx25840,v4l2_common
videobuf_dma_sg         7217  1 cx23885
videobuf_dvb            4174  1 cx23885
dvb_core               71187  2 cx23885,videobuf_dvb
videobuf_core          13426  3 cx23885,videobuf_dma_sg,videobuf_dvb
ir_common               4056  1 cx23885
ir_core                11377  8
cx23885,rc_hauppauge_new,ir_sony_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder,ir_common
btcx_risc               2978  1 cx23885
tveeprom                9994  1 cx23885
i2c_core               19651  13
cx23885,s5h1411,mt2131,s5h1409,tda18271,tda8290,tuner,cx25840,nvidia,v4l2_common,videodev,i2c_i801,tveeprom


I can use  1 input on the card with mythtv
using /dev/dvb/adapter0/frontend0
but I can't figure out how to use the 2nd tuner.... I'm not sure if the
2nd tuner is getting 
detected correctly... or if the 2nd tuner is just an analog tuner and
not a digital tuner.... 
or what exactly... 

There is something in mythtv that says how many things an input can tune
at once, but setting it to 2 does
not let me record two things using this WinTV-HVR-1800 card. mythtv
treats it as one tuner... I think that 
I need to see 
/dev/dvb/adapter0/frontend0
and
/dev/dvb/adapter0/frontend1
to get to the 2nd tuner... 


Is there a modprobe cx23885 option that enables a 2nd tuner? 

Is one of the dmesg messages telling me that the 2nd tuner is analog
only? The can on the card doesn't look like any of the cans on my other
analog cards that I've had in the past....

Thanks - jack 



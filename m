Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48820 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbaLTPbN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Dec 2014 10:31:13 -0500
Message-ID: <5495963D.3080004@iki.fi>
Date: Sat, 20 Dec 2014 17:31:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>,
	LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: cx23885: Add si2165 support for HVR-5500
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Matthias and Mauro,
so you decided to add that patch, which makes rather big changes for 
existing HVR-4400 models, without any testing. I plugged HVR-4400 
version that has only DVB-S2 in my machine in order to start finding out 
one lockdep issue but what I see is bad HVR-4400.

*********************
commit 36efec48e2e6016e05364906720a0ec350a5d768
Author: Matthias Schwarzott <zzam@gentoo.org>
Date:   Tue Jul 22 17:12:13 2014 -0300

     [media] cx23885: Add si2165 support for HVR-5500

     The same card entry is used for HVR-4400 and HVR-5500.
     Only HVR-5500 has been tested.

     Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
     Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

*********************

I would also criticize Mauro as he has committed that patch. It should 
be obvious for every experienced media developer that this kind of not 
trivial change needs some more careful review or testing.

That patch should be done differently, not blindly trying to attach chip 
drivers for non-existent chips. I think correct solution is to detect 
different HW models somehow, probing or reading from eeprom or so. Then 
make 2 profiles, one for boards having both satellite and 
terristrial/cable and one for boards having satellite only.


*********************

cx23885 driver version 0.0.4 loaded
CORE cx23885[0]: subsystem: 0070:c12a, board: Hauppauge WinTV-HVR4400 
[card=38,autodetected]
tveeprom 5-0050: Hauppauge model 121200, rev B2C3, serial# 4034388477
tveeprom 5-0050: MAC address is 00:0d:fe:77:e1:fd
tveeprom 5-0050: tuner model is Conexant CX24118A (idx 123, type 4)
tveeprom 5-0050: TV standards ATSC/DVB Digital (eeprom 0x80)
tveeprom 5-0050: audio processor is CX23888 (idx 40)
tveeprom 5-0050: decoder processor is CX23888 (idx 34)
tveeprom 5-0050: has no radio, has IR receiver, has no IR transmitter
cx23885[0]: warning: unknown hauppauge model #121200
cx23885[0]: hauppauge eeprom: model=121200
All bytes are equal. It is not a TEA5767
tuner 6-0060: Tuner -1 found with type(s) Radio TV.
tda18271 6-0060: creating new instance
Unknown device (0) detected @ 6-0060, device not supported.
tda18271_attach: [6-0060|M] error -22 on line 1285
tda18271 6-0060: destroying instance
tuner 6-0060: Tuner has no way to set tv freq
cx23885[0]: registered device video0 [v4l2]
cx23885[0]: registered device vbi0
cx23885[0]: registered ALSA audio device
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
i2c i2c-5: a8293: Allegro A8293 SEC attached
DVB: registering new adapter (cx23885[0])
cx23885 0000:02:00.0: DVB: registering adapter 0 frontend 0 (NXP 
TDA10071)...
cx23885_dvb_register() allocating 1 frontend(s)
cx23885[0]: cx23885 based dvb card
cx23885[0]: frontend initialization failed
cx23885_dvb_register() dvb_register failed err = -22
cx23885_dev_setup() Failed to register dvb on VID_C
cx23885_dev_checkrevision() Hardware revision = 0xd0
cx23885[0]/0: found at 0000:02:00.0, rev: 4, irq: 18, latency: 0, mmio: 
0xfe800000

*********************

# ../rmmod.pl unload
Seeking media drivers at /lib/modules/3.18.0-rc4+/kernel/drivers/media/
found 0 modules
Seeking media drivers at /lib/modules/3.18.0-rc4+/extra/
found 511 modules
Seeking media drivers at /lib/modules/3.18.0-rc4+/updates/media/
found 511 modules
/sbin/rmmod cx23885
rmmod: ERROR: Module cx23885 is in use
/sbin/rmmod videobuf2_dvb
rmmod: ERROR: Module videobuf2_dvb is in use by: cx23885
/sbin/rmmod videobuf2_core
rmmod: ERROR: Module videobuf2_core is in use by: cx23885 videobuf2_dvb
/sbin/rmmod tuner
rmmod: ERROR: Module tuner is in use
/sbin/rmmod cx2341x
rmmod: ERROR: Module cx2341x is in use by: cx23885
/sbin/rmmod v4l2_common
rmmod: ERROR: Module v4l2_common is in use by: cx2341x cx23885 tuner 
videobuf2_core
/sbin/rmmod altera_ci
rmmod: ERROR: Module altera_ci is in use by: cx23885
/sbin/rmmod videobuf2_dma_sg
rmmod: ERROR: Module videobuf2_dma_sg is in use by: cx23885
/sbin/rmmod videodev
rmmod: ERROR: Module videodev is in use by: cx2341x cx23885 tuner 
v4l2_common videobuf2_core
/sbin/rmmod dvb_core
rmmod: ERROR: Module dvb_core is in use by: cx23885 altera_ci videobuf2_dvb
/sbin/rmmod a8293
rmmod: ERROR: Module a8293 is in use
/sbin/rmmod videobuf2_memops
rmmod: ERROR: Module videobuf2_memops is in use by: videobuf2_dma_sg
/sbin/rmmod tda18271
rmmod: ERROR: Module tda18271 is in use by: cx23885
/sbin/rmmod rc_core
rmmod: ERROR: Module rc_core is in use by: cx23885
/sbin/rmmod tveeprom
rmmod: ERROR: Module tveeprom is in use by: cx23885
/sbin/rmmod media
rmmod: ERROR: Module media is in use by: videodev
/sbin/rmmod tda10071
rmmod: ERROR: Module tda10071 is in use
/sbin/rmmod cx23885
rmmod: ERROR: Module cx23885 is in use
/sbin/rmmod videobuf2_dvb
rmmod: ERROR: Module videobuf2_dvb is in use by: cx23885
/sbin/rmmod videobuf2_core
rmmod: ERROR: Module videobuf2_core is in use by: cx23885 videobuf2_dvb
/sbin/rmmod tuner
rmmod: ERROR: Module tuner is in use
/sbin/rmmod cx2341x
rmmod: ERROR: Module cx2341x is in use by: cx23885
/sbin/rmmod v4l2_common
rmmod: ERROR: Module v4l2_common is in use by: cx2341x cx23885 tuner 
videobuf2_core
/sbin/rmmod altera_ci
rmmod: ERROR: Module altera_ci is in use by: cx23885
/sbin/rmmod videobuf2_dma_sg
rmmod: ERROR: Module videobuf2_dma_sg is in use by: cx23885
/sbin/rmmod videodev
rmmod: ERROR: Module videodev is in use by: cx2341x cx23885 tuner 
v4l2_common videobuf2_core
/sbin/rmmod dvb_core
rmmod: ERROR: Module dvb_core is in use by: cx23885 altera_ci videobuf2_dvb
/sbin/rmmod a8293
rmmod: ERROR: Module a8293 is in use
/sbin/rmmod videobuf2_memops
rmmod: ERROR: Module videobuf2_memops is in use by: videobuf2_dma_sg
/sbin/rmmod tda18271
rmmod: ERROR: Module tda18271 is in use by: cx23885
/sbin/rmmod rc_core
rmmod: ERROR: Module rc_core is in use by: cx23885
/sbin/rmmod tveeprom
rmmod: ERROR: Module tveeprom is in use by: cx23885
/sbin/rmmod media
rmmod: ERROR: Module media is in use by: videodev
/sbin/rmmod tda10071
rmmod: ERROR: Module tda10071 is in use
Couldn't unload: tda10071 media tveeprom rc_core tda18271 
videobuf2_memops a8293 dvb_core videodev videobuf2_dma_sg altera_ci 
v4l2_common cx2341x tuner videobuf2_core videobuf2_dvb cx23885
[root@localhost linux]#


Antti

-- 
http://palosaari.fi/

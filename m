Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.leissner.se ([212.3.1.210]:50959 "EHLO
	mailgate.leissner.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586AbbGGQov (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2015 12:44:51 -0400
Date: Tue, 7 Jul 2015 18:44:36 +0200 (SST)
From: Peter Fassberg <pf@leissner.se>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
In-Reply-To: <20150707183108.3afee7e6@lappi3.parrot.biz>
Message-ID: <alpine.BSF.2.20.1507071840580.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se> <20150705184449.0017f114@lappi3.parrot.biz> <alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se> <20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com> <alpine.BSF.2.20.1507071736350.72900@nic-i.leissner.se>
 <20150707182541.0960177f@lappi3.parrot.biz> <20150707183108.3afee7e6@lappi3.parrot.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Patrick Boettcher <patrick.boettcher@posteo.de> wrote:
>
>>> [  301.275434] si2168 1-0064: firmware version: 4.0.4 [  301.284625] si2157 2-0060: found a 'Silicon Labs Si2157-A30'
>>> [  301.340643] si2157 2-0060: firmware version: 3.0.5
>
>> Can you easily try more recent kernels or media_trees?
>
> It seems you are already using a more recent version of the
> si21xx-drivers than provided with 3.16. (in 3.16.0 there is no firmware
> version-print in si2157)

Yes, I did an upgrade to the latest I could find before I gave up.

This is in use:

root@raspberrypi:~# uname -a
Linux raspberrypi 4.0.6-v7+ #798 SMP PREEMPT Tue Jun 23 18:06:01 BST 2015 armv7l GNU/Linux

root@raspberrypi:~# modinfo si2157
filename:       /lib/modules/4.0.6-v7+/kernel/drivers/media/tuners/si2157.ko
firmware:       dvb-tuner-si2158-a20-01.fw
author:         Antti Palosaari <crope@iki.fi>
description:    Silicon Labs Si2146/2147/2148/2157/2158 silicon tuner driver
srcversion:     397E31D773FD172EA0CE7F6

root@raspberrypi:~# modinfo si2168
filename:       /lib/modules/4.0.6-v7+/kernel/drivers/media/dvb-frontends/si2168.ko
firmware:       dvb-demod-si2168-b40-01.fw
firmware:       dvb-demod-si2168-a30-01.fw
firmware:       dvb-demod-si2168-a20-01.fw
description:    Silicon Labs Si2168 DVB-T/T2/C demodulator driver
author:         Antti Palosaari <crope@iki.fi>
srcversion:     12127041CAEFE39931DE3A1

root@raspberrypi:~# modinfo em28xx
filename:       /lib/modules/4.0.6-v7+/kernel/drivers/media/usb/em28xx/em28xx.ko
version:        0.2.1
description:    Empia em28xx device driver
author:         Ludovico Cavedon <cavedon@sssup.it>, Markus Rechberger <mrechberger@gmail.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, Sascha Sommer <saschasommer@freenet.de>
srcversion:     1E6C5892B8BEB1E429BECC7
vermagic:       4.0.6-v7 SMP preempt mod_unload modversions ARMv7
parm:           tuner:tuner type (int)
parm:           disable_ir:disable infrared remote support (int)
parm:           disable_usb_speed_check:override min bandwidth requirement of 480M bps (int)
parm:           card:card type (array of int)
parm:           usb_xfer_mode:USB transfer mode for frame data (-1 = auto, 0 = prefer isoc, 1 = prefer bulk) (int)
parm:           i2c_scan:scan i2c bus at insmod time (int)
parm:           i2c_debug:i2c debug message level (1: normal debug, 2: show I2C transfers) (int)
parm:           core_debug:enable debug messages [core] (int)
parm:           reg_debug:enable debug messages [URB reg] (int)

root@raspberrypi:~# modinfo em28xx_dvb
filename:       /lib/modules/4.0.6-v7+/kernel/drivers/media/usb/em28xx/em28xx-dvb.ko
version:        0.2.1
description:    Empia em28xx device driver - digital TV interface
author:         Mauro Carvalho Chehab <mchehab@infradead.org>
srcversion:     60267D5DE16B950E37CD3FF
vermagic:       4.0.6-v7 SMP preempt mod_unload modversions ARMv7
parm:           debug:enable debug messages [dvb] (int)
parm:           adapter_nr:DVB adapter numbers (array of short)

root@raspberrypi:~# modinfo em28xx_rc
filename:       /lib/modules/4.0.6-v7+/kernel/drivers/media/usb/em28xx/em28xx-rc.ko
version:        0.2.1
description:    Empia em28xx device driver - input interface
author:         Mauro Carvalho Chehab
srcversion:     C0534469E29D3F7AEB3353A
depends:        em28xx,rc-core
vermagic:       4.0.6-v7 SMP preempt mod_unload modversions ARMv7
parm:           ir_debug:enable debug messages [IR] (int)


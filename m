Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:63350 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938631AbcJSTI1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Oct 2016 15:08:27 -0400
Received: from PatrickLaptop ([91.6.177.199]) by smtp.web.de (mrweb103) with
 ESMTPSA (Nemesis) id 0MEmgA-1cBqiz425S-00G3Ta for
 <linux-media@vger.kernel.org>; Wed, 19 Oct 2016 21:08:24 +0200
Reply-To: <ps00de@yahoo.de>
From: <ps00de@yahoo.de>
To: "'Mauro Carvalho Chehab'" <mchehab@s-opensource.com>
Cc: <linux-media@vger.kernel.org>
References: <003101d2298a$48b12400$da136c00$@yahoo.de> <20161019133552.72880aed@vento.lan>
In-Reply-To: <20161019133552.72880aed@vento.lan>
Subject: AW: em28xx WinTV dualHD in Raspbian
Date: Wed, 19 Oct 2016 21:08:22 +0200
Message-ID: <000a01d22a3c$29821140$7c8633c0$@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-Language: de
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Based on this log:
> 
> Oct 18 23:08:01 mediapi kernel: [ 7590.369200] em28xx_dvb: disagrees about version of symbol dvb_dmxdev_init Oct 18 23:08:01 mediapi kernel: [ 7590.369228] em28xx_dvb: Unknown symbol dvb_dmxdev_init (err -22)
>
> It seems you messed the modules install or you have the V4L2 stack compiled builtin with a different version. 

I've done a cleanup: sudo rm -rf /lib/modules/`uname -r`/kernel/drivers/media/
And reinstalled v4l (make install) again.

Same result (no /dev/dvb), but other log:
Oct 19 20:59:54 mediapi kernel: [    7.515009] media: Linux media interface: v0.10
Oct 19 20:59:54 mediapi kernel: [    7.537922] Linux video capture interface: v2.00
Oct 19 20:59:54 mediapi kernel: [    7.554643] em28xx: New device HCW dualHD @ 480 Mbps (2040:0265, interface 0, class 0)
Oct 19 20:59:54 mediapi kernel: [    7.554666] em28xx: DVB interface 0 found: isoc
Oct 19 20:59:54 mediapi kernel: [    7.554959] em28xx: chip ID is em28174
Oct 19 20:59:54 mediapi kernel: [    8.752360] em28174 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x7ee3cbc8
Oct 19 20:59:54 mediapi kernel: [    8.752378] em28174 #0: EEPROM info:
Oct 19 20:59:54 mediapi kernel: [    8.752387] em28174 #0: 	microcode start address = 0x0004, boot configuration = 0x01
Oct 19 20:59:54 mediapi kernel: [    8.758923] em28174 #0: 	AC97 audio (5 sample rates)
Oct 19 20:59:54 mediapi kernel: [    8.758936] em28174 #0: 	500mA max power
Oct 19 20:59:54 mediapi kernel: [    8.758946] em28174 #0: 	Table at offset 0x27, strings=0x0e6a, 0x1888, 0x087e
Oct 19 20:59:54 mediapi kernel: [    8.759389] em28174 #0: Identified as Hauppauge WinTV-dualHD DVB (card=99)
Oct 19 20:59:54 mediapi kernel: [    8.764360] tveeprom 4-0050: Hauppauge model 204109, rev B2I6, serial# 11540068
Oct 19 20:59:54 mediapi kernel: [    8.764381] tveeprom 4-0050: tuner model is SiLabs Si2157 (idx 186, type 4)
Oct 19 20:59:54 mediapi kernel: [    8.764394] tveeprom 4-0050: TV standards PAL(B/G) NTSC(M) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xfc)
Oct 19 20:59:54 mediapi kernel: [    8.764404] tveeprom 4-0050: audio processor is None (idx 0)
Oct 19 20:59:54 mediapi kernel: [    8.764414] tveeprom 4-0050: has no radio, has IR receiver, has no IR transmitter
Oct 19 20:59:54 mediapi kernel: [    8.764424] em28174 #0: dvb set to isoc mode.
Oct 19 20:59:54 mediapi kernel: [    8.764854] usbcore: registered new interface driver em28xx
Oct 19 20:59:54 mediapi kernel: [    8.800215] em28174 #0: Registering input extension
Oct 19 20:59:54 mediapi kernel: [    8.835377] Registered IR keymap rc-hauppauge
Oct 19 20:59:54 mediapi kernel: [    8.836063] input: em28xx IR (em28174 #0) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/rc/rc0/input0
Oct 19 20:59:54 mediapi kernel: [    8.836345] rc rc0: em28xx IR (em28174 #0) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/rc/rc0
Oct 19 20:59:54 mediapi kernel: [    8.838384] em28174 #0: Input extension successfully initalized
Oct 19 20:59:54 mediapi kernel: [    8.838406] em28xx: Registered (Em28xx Input Extension) extension
Oct 19 20:59:54 mediapi kernel: [    9.612549] Adding 102396k swap on /var/swap.  Priority:-1 extents:3 across:200700k SSFS

Any idea?

Thanks,
Patrick


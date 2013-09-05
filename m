Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:55627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3IHP2S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Sep 2013 11:28:18 -0400
Date: Thu, 5 Sep 2013 17:57:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
cc: Frank =?UTF-8?B?U2Now6RmZXI=?= <fschaefer.oss@googlemail.com>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 0/3] V4L2: fix em28xx ov2640 support
In-Reply-To: <20130905124134.29774dbf@samsung.com>
Message-ID: <Pine.LNX.4.64.1309051749430.785@axis700.grange>
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
 <5224DBB8.1010601@googlemail.com> <Pine.LNX.4.64.1309030821050.14776@axis700.grange>
 <5228A1BC.7000209@googlemail.com> <20130905124134.29774dbf@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 5 Sep 2013, Mauro Carvalho Chehab wrote:

> Em Thu, 05 Sep 2013 17:22:36 +0200
> Frank Schäfer <fschaefer.oss@googlemail.com> escreveu:
> 
> > Hi Guennadi,
> > 
> > sorry for delayed replies, I'm currently burried under lots of stuff
> > with a higher priority...
> > 
> > Am 03.09.2013 08:34, schrieb Guennadi Liakhovetski:
> > > Hi Frank
> > >
> > > Thanks for testing! Let's have a look then:
> > >
> > > On Mon, 2 Sep 2013, Frank Schäfer wrote:
> > >
> > >> Am 28.08.2013 15:28, schrieb Guennadi Liakhovetski:
> > >>> This patch series adds a V4L2 clock support to em28xx with an ov2640 
> > >>> sensor. Only compile tested, might need fixing, please, test.
> > >>>
> > >>> Guennadi Liakhovetski (3):
> > >>>   V4L2: add v4l2-clock helpers to register and unregister a fixed-rate
> > >>>     clock
> > >>>   V4L2: add a v4l2-clk helper macro to produce an I2C device ID
> > >>>   V4L2: em28xx: register a V4L2 clock source
> > >>>
> > >>>  drivers/media/usb/em28xx/em28xx-camera.c |   41 ++++++++++++++++++++++-------
> > >>>  drivers/media/usb/em28xx/em28xx-cards.c  |    3 ++
> > >>>  drivers/media/usb/em28xx/em28xx.h        |    1 +
> > >>>  drivers/media/v4l2-core/v4l2-clk.c       |   39 ++++++++++++++++++++++++++++
> > >>>  include/media/v4l2-clk.h                 |   17 ++++++++++++
> > >>>  5 files changed, 91 insertions(+), 10 deletions(-)
> > >>>
> > >> Tested a few minutes ago:
> > >>
> > >> ...
> > >> [  103.564065] usb 1-8: new high-speed USB device number 10 using ehci-pci
> > >> [  103.678554] usb 1-8: config 1 has an invalid interface number: 3 but
> > >> max is 2
> > >> [  103.678559] usb 1-8: config 1 has no interface number 2
> > >> [  103.678566] usb 1-8: New USB device found, idVendor=1ae7, idProduct=9004
> > >> [  103.678569] usb 1-8: New USB device strings: Mfr=0, Product=0,
> > >> SerialNumber=0
> > >> [  103.797040] em28xx audio device (1ae7:9004): interface 0, class 1
> > >> [  103.797054] em28xx audio device (1ae7:9004): interface 1, class 1
> > >> [  103.797064] em28xx: New device   @ 480 Mbps (1ae7:9004, interface 3,
> > >> class 3)
> > >> [  103.797066] em28xx: Video interface 3 found: bulk
> > >> [  103.933941] em28xx: chip ID is em2765
> > >> [  104.043811] em2765 #0: i2c eeprom 0000: 26 00 01 00 02 0d ea c2 ee 30
> > >> fa 02 d2 0a 32 02
> > >> [  104.043821] em2765 #0: i2c eeprom 0010: 0d c3 c2 04 12 00 33 c2 04 12
> > >> 00 4b 12 0e 1f d2
> > >> [  104.043828] em2765 #0: i2c eeprom 0020: 04 12 00 33 12 0e 1f d2 04 12
> > >> 00 4b 02 0e 1f 80
> > >> [  104.043835] em2765 #0: i2c eeprom 0030: 00 a2 85 22 02 0b cb a2 04 92
> > >> 84 22 02 0c 78 00
> > >> [  104.043841] em2765 #0: i2c eeprom 0040: 02 0d 69 7b 1f 7d 40 7f 32 02
> > >> 0c 44 02 00 03 a2
> > >> [  104.043847] em2765 #0: i2c eeprom 0050: 04 92 85 22 00 00 00 00 e7 1a
> > >> 04 90 00 00 00 00
> > >> [  104.043854] em2765 #0: i2c eeprom 0060: 00 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043860] em2765 #0: i2c eeprom 0070: 00 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043866] em2765 #0: i2c eeprom 0080: 00 00 00 00 00 00 1e 40 1e 72
> > >> 00 20 01 01 00 01
> > >> [  104.043873] em2765 #0: i2c eeprom 0090: 01 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043879] em2765 #0: i2c eeprom 00a0: 00 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043885] em2765 #0: i2c eeprom 00b0: 00 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043891] em2765 #0: i2c eeprom 00c0: 00 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043898] em2765 #0: i2c eeprom 00d0: 00 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043904] em2765 #0: i2c eeprom 00e0: 00 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043910] em2765 #0: i2c eeprom 00f0: 00 00 00 00 00 00 00 00 00 00
> > >> 00 00 00 00 00 00
> > >> [  104.043917] em2765 #0: i2c eeprom 0100: ... (skipped)
> > >> [  104.043921] em2765 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5c22c624
> > >> [  104.043922] em2765 #0: EEPROM info:
> > >> [  104.043924] em2765 #0:       microcode start address = 0x0004, boot
> > >> configuration = 0x01
> > >> [  104.069818] em2765 #0:       no hardware configuration dataset found
> > >> in eeprom
> > >> [  104.080693] em2765 #0: sensor OV2640 detected
> > >> [  104.080715] em2765 #0: Identified as SpeedLink Vicious And Devine
> > >> Laplace webcam (card=90)
> > >> [  104.159699] ov2640 11-0030: ov2640 Product ID 26:42 Manufacturer ID 7f:a2
> > >> [  104.173836] i2c i2c-11: OV2640 Probed
> > > I presume, this is good.
> > >
> > >> [  104.306698] em2765 #0: Config register raw data: 0x00
> > >> [  104.306717] em2765 #0: v4l2 driver version 0.2.0
> > >> [  104.321152] em2765 #0: V4L2 video device registered as video1
> > > This is good too.
> > >
> > >> [  104.321167] ------------[ cut here ]------------
> > >> [  104.321216] WARNING: CPU: 0 PID: 517 at
> > >> drivers/media/v4l2-core/v4l2-clk.c:131 v4l2_clk_disable+0x83/0x90
> > >> [videodev]()
> > >> [  104.321221] Unbalanced v4l2_clk_disable() on 11-0030:mclk!
> > > Ok, this is because em28xx_init_dev() calls
> > >
> > > 	/* Save some power by putting tuner to sleep */
> > > 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> > >
> > > without turning the subdevice on before. Are those subdevices on by 
> > > default? 
> > I don't know. We have numerous magic GPIO sequences in the em28xx
> > driver... ;)
> > It has at least been working so far without a (s_power, 1) call. ;)
> 
> On em28xx (as on almost all PCI/USB drivers), the devices are powered
> on via GPIO, before loading the I2C drivers. This is needed, otherwise
> several I2C drivers will refuse to load, as their synchronous
> initialization procedures validate if the device is really present.
> 
> So, the power default state is ON.
> 
> Please notice that changing it is not an option, as there are several
> cases where the very same device ID can have different I2C chips,
> and the bridge driver probe() routine uses the subdevice probes to
> try other possible subdevices.
> 
> Rewriting that part of the code would require to test the changes on
> several hundreds of different devices, and even if you find someone
> with all those devices, I doubt that he would have enough time to
> re-test everything.
> 
> So, either the above unbalance check should be removed, or its behavior
> should be changed to assume that the devices are ON at probe() time,
> as it used to be before the async patches.

Ok, we can certainly do any of the above, but just for understanding - how 
does it actually work now? I mean - ok, I can accept, that the default 
reset state is power on. But the driver then forcedly powers all 
subdevices off upon close() or in the end of initialisation, performed 
during probing - and _never_ explicitly powers them on! That doesn't seem 
right to me. Even if it happens to work.

Further, I grepped em28xx for s_power - only callers have those hooks, I 
didn't find any subdevices with them actually implemented. ov2640 has it 
and it calls soc_camera internal methods, which in the em28xx case also 
end up doing nothing. So, how and which subdevices actually save power 
there and how are they turned back on?

I'll try to look at external subdevice drivers, that are used by em28xx, 
but any hints would be appreciated.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

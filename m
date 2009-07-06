Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56747 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZGFBE1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 21:04:27 -0400
Date: Sun, 5 Jul 2009 22:04:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Wally <wally@voosen.eu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: eMpia Microscope Camera
Message-ID: <20090705220422.5705da5a@pedra.chehab.org>
In-Reply-To: <Pine.LNX.4.64.0907031851580.25247@axis700.grange>
References: <200907030900.53557.wally@voosen.eu>
	<200907031559.37537.wally@voosen.eu>
	<20090703111446.23c385db@pedra.chehab.org>
	<200907031738.36204.wally@voosen.eu>
	<20090703133917.7c62ef47@pedra.chehab.org>
	<Pine.LNX.4.64.0907031851580.25247@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 3 Jul 2009 19:02:36 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> On Fri, 3 Jul 2009, Mauro Carvalho Chehab wrote:
> 
> > Em Fri, 3 Jul 2009 17:38:36 +0200
> > Wally <wally@voosen.eu> escreveu:
> > 
> > > 
> > > Hi Mauro,
> > > 
> > > built the driver without problems.
> > > 
> > > the rsult picture on mplayer is much better and the camera response now much 
> > > better. But the picture sync (or something like this is still not ok).
> > > 
> > > Here are the logs:
> > > 
> > > removed all em28xx distro packages
> > > 
> > > $ hg clone http://www.linuxtv.org/hg/v4l-dvb
> > > $ cd v4l-dvb
> > > $ make
> > > $ make rmmod
> > > $ make install
> > > $ modprobe em28xx
> > > 
> > > modprobe em28xx
> > > dmesg
> > > 
> > > Linux video capture interface: v2.00
> > > usbcore: registered new interface driver em28xx
> > > em28xx driver loaded
> > > 
> > > plugin device
> > > dmesg:
> > > 
> > > usb 5-2: new high speed USB device using ehci_hcd and address 2
> > > usb 5-2: configuration #1 chosen from 1 choice
> > > em28xx: New device @ 480 Mbps (eb1a:2750, interface 0, class 0)
> > > em28xx #0: Identified as Unknown EM2750/EM2751 webcam grabber (card=22)
> > > em28xx #0: chip ID is em2750
> > > em28xx #0: board has no eeprom
> > > em28xx #0: Config register raw data: 0x00
> > > em28xx #0: v4l2 driver version 0.1.2
> > > em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> > > usb 5-2: New USB device found, idVendor=eb1a, idProduct=2750
> > > usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > > 
> > > same behavior of camera as was, green screen etc.
> > > 
> > > trying:
> > > modprobe em28xx card=71
> > > dmesg:
> > > 
> > > Linux video capture interface: v2.00
> > > usbcore: registered new interface driver em28xx
> > > em28xx driver loaded
> > > 
> > > plugin the device
> > > dmesg:
> > > 
> > > usb 5-2: new high speed USB device using ehci_hcd and address 2
> > > usb 5-2: configuration #1 chosen from 1 choice
> > > em28xx: New device @ 480 Mbps (eb1a:2750, interface 0, class 0)
> > > em28xx #0: Identified as Silvercrest Webcam 1.3mpix (card=71)
> > > em28xx #0: chip ID is em2750
> > > em28xx #0: board has no eeprom
> > > mt9v011 4-005d: chip found @ 0xba (em28xx #0)
> > > em28xx #0: Config register raw data: 0x00
> > > mt9v011 4-005d: *** unknown micron chip detected (0x8431.
> > > em28xx #0: v4l2 driver version 0.1.2
> > > em28xx #0: V4L2 device registered as /dev/video0 and /dev/vbi0
> > > usb 5-2: New USB device found, idVendor=eb1a, idProduct=2750
> > > usb 5-2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> > > mt9v011 4-005d: *** unknown micron chip detected (0x8431.
> > > 
> > > much better but still not recognizable picture.
> > 
> > Good!
> > 
> > Based on the chip version, this one seems to use mt9m001c2st sensor. This
> > sensor is already supported by mt9m001 driver. It will probably work like a
> > charm after using it. Yet, the mt9m001 currently uses a different API for I2C
> > binding, although Guennadi is porting it to v4l2 dev/subdev.
> > 
> > Guennadi,
> > 
> > I saw some patches from you migrating soc_camera to v4l2 dev/subdev. When are
> > you intending to send those patches to me? It would be cool if Wally could test
> > the mt9m001 with em28xx driver
> 
> Hi Mauro
> 
> Yes, in my quilt stack soc-camera uses v4l2-subdev registration / module 
> loading procedure and some operations. Currently I am fixing cropping / 
> scaling (which, I hope, I interpreted correctly this time, although I 
> haven't got your or Hans' or anyone else's opinion to my last question / 
> interpretation) in all soc-camera drivers.

Ok. I'll seek for some time to better understand your question and give my
impression about the crop/scaling question.

> This makes the "legacy" 
> soc-camera API between the core and host drivers on one side and camera 
> drivers on the other side quite thin. Still even when this is done, there 
> are still some remaining bonds that have to be broken: 1) pixel format 
> negotiation, 2) bus parameter negotiation, and we still haven't got your 
> decision regarding whether or not we shall support autonegiation.

What thread are you referring to?

> So, one delaying factor is that there is still some work to be done, and I 
> don't think, I'll be getting more time for soc-camera in the near future. 
> Another delaying factor, is that ARM platforms have missed the 2.6.31 
> merge window, so, we cannot convert now and have to wait until 2.6.32.

Are you meaning that you need some patches at arch/arm that aren't merged
upstream yet? Are those patches already in linux-next?

> Of course, development and testing can be done in a separate tree. My last 
> snapshot is based on post 2.6.30.

Considering the regressions we had with 2.6.30, several of them directly or
indirectly related to dev/subdev conversion, I prefer if you could send the
soc-camera conversion on an early -rc kernel, to allow more time for testing
inside v4l-dvb tree and at linux-next, before entering on a new merge window



Cheers,
Mauro

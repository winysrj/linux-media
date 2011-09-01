Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1IAGju (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 02:39:50 -0400
Date: Thu, 1 Sep 2011 08:39:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] media: none of the drivers should be enabled by default
In-Reply-To: <4E5E23CA.4030208@infradead.org>
Message-ID: <Pine.LNX.4.64.1108311447000.8429@axis700.grange>
References: <Pine.LNX.4.64.1108301921040.19151@axis700.grange>
 <201108311021.05793.hverkuil@xs4all.nl> <Pine.LNX.4.64.1108311023260.8429@axis700.grange>
 <201108311053.00687.hverkuil@xs4all.nl> <Pine.LNX.4.64.1108311103130.8429@axis700.grange>
 <4E5E23CA.4030208@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Wed, 31 Aug 2011, Mauro Carvalho Chehab wrote:

[snip]

> >> I can't comment on the remote controller drivers as I haven't been involved
> >> with that.
> > 
> > Mauro?
> 
> If RC is disabled, most PC cards don't work (bttv, cx88, ivtv, dvb-usb, ...).
> Ok, this is due to a lack of proper module support on those drivers, but changing
> it requires some work on each driver that depends on RC.

wouldn't a simple "select RC_CORE" in those drivers solve this? E.g., for 
BT848

diff --git a/drivers/media/video/bt8xx/Kconfig b/drivers/media/video/bt8xx/Kconfig
index 7da5c2e..28c087bd 100644
--- a/drivers/media/video/bt8xx/Kconfig
+++ b/drivers/media/video/bt8xx/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_BT848
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
-	depends on RC_CORE
+	select RC_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO

and deselect RC_CORE:

diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index 899f783..259a3e7 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -1,7 +1,6 @@
 menuconfig RC_CORE
 	tristate "Remote Controller adapters"
 	depends on INPUT
-	default INPUT
 	---help---
 	  Enable support for Remote Controllers on Linux. This is
 	  needed in order to support several video capture adapters.

This way by default you have no RCs, but as soon as you enable one card, 
like bttv, you get all potentially needed drivers.

> Also, if RC is selected, the RC decoder protocols need to be enabled by default, 
> as otherwise several devices will stop working, as, on modern devices, there's
> no hardware anymore to decode the IR pulses. The RC protocol Kconfig options are 
> there, in fact, to allow disabling some RC decoding protocol when people are 100% 
> sure that such software decoder won't be needed on some particular environment.

Ok, they can be selected. Or even I don't mind them being turned on by 
default, when RC is on, as long as RC itself is off by default.

> >> With regards to the tuners: perhaps it is sufficient to default MEDIA_ATTACH
> >> to 'y'? That should prevent building those tuners that are not needed.
> > 
> > Sorry, I don't see how this should work. I mean tuners under 
> > drivers/media/common/tuners/.
> > 
> >> I wouldn't change anything else here.
> 
> Tuners are required for all TV and DVB cards. Maybe we can put an explicit Kconfig
> item for TV devices, and change the config stuff to something like:
> 
> config MEDIA_NEED_TUNER
> 	tristate
> 
> menuconfig MEDIA_TV
> 	tristate "TV and grabber cards"
> 	select MEDIA_NEED_TUNER
> ...
> menuconfig MEDIA_WEBCAMS
> 	tristate "Webcameras"
> ...
> 
> config DVB_CORE
> 	tristate "DVB for Linux"
> 	depends on NET && INET
> 	select CRC32
> 	select MEDIA_NEED_TUNER
> 
> 
> config MEDIA_TUNER_TDA827X
> 	tristate "Philips TDA827X silicon tuner"
> 	depends on VIDEO_MEDIA && I2C
> 	default MEDIA_NEED_TUNER if MEDIA_TUNER_CUSTOMIZE
> 	help
> 	  A DVB-T silicon tuner module. Say Y when you want to support this tuner.
> 
> There's one problem with the above strategy: on a few drivers, the same
> driver is used for both webcams and TV. I know that em28xx has this problem,
> as the same driver also supports the non-UVC em27xx-based webcams.
> I think that the same is true also for usbvision.
> 
> If we put those devices under the "TV and grabber cards", people that have just a
> em28xx-based webcam won't find them inside the MEDIA_WEBCAMS menus.
> 
> Of course, we can workaround it, by creating a "fake" item inside the webcams
> menu, like:

Yes, sure, or maybe put it under some "hybrid" menu.

> menuconfig MEDIA_WEBCAMS
> 	tristate "Webcameras"
> 
> config MEDIA_EM27xx
> 	tristate "em27xx-based webcams"
> 
> 
> and put some glue magic between MEDIA_EM27xx and em28xx:
> 
> config VIDEO_EM28XX
> 	depends on MEDIA_EM27xx if MEDIA_EM27xx

ehem... why not just

config MEDIA_EM27xx
	tristate "em27xx-based webcams"
	select VIDEO_EM28XX

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

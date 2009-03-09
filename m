Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45311 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZCIKs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2009 06:48:59 -0400
Date: Mon, 9 Mar 2009 07:48:53 -0300 (BRT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: VDR User <user.vdr@gmail.com>
cc: Peter Baartz <baartzy@gmail.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: Kconfig changes in /hg/v4l-dvb caused dvb_usb_cxusb to stop
 building (fwd)
Message-ID: <alpine.LRH.2.00.0903090746470.6607@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 8 Mar 2009, VDR User wrote:

>  On Sun, Mar 8, 2009 at 6:07 PM, Mauro Carvalho Chehab
>  <mchehab@infradead.org> wrote:
> >  It won't mark they with M, if you keep enabling DVB_FE_CUSTOMISE, since 
> >  this
> >  Kconfig var allows manual override over the frontend modules.
>
>  Ok, tried again and it's as you said.  I assumed the behavior of
>  DVB_FE_CUSTOMISE hadn't changed but it appears it has.

Yes, there were minor changes on its behaviour.

>  Although, I
>  think the previous behavior is still better having the required
>  modules as locked -M-.  At least then the user has some kind of
>  control over what modules are built without risk of disabling
>  something he needs.  What was the logic behind making this change?
>
>  That's one thing I don't understand... Why an os that prides itself on
>  user-customization seems to always be introducing ways to limit the
>  user.

If all select options are ok, the old way were completely useless to the 
developers. With DVB_FE_CUSTOMISE disabled, all "control" you have is to select 
modules that you don't need, since the drivers you selected are not prepared to 
use they. So, it makes no sense to open a menu there.

By enabling DVB_FE_CUSTOMISE, you can do two things (just like before):
 	- Unselect frontends that is used by your driver, but eventually you 
don't need on your specific device (for example, you just need one DVB demod 
for your specific av7110 device);
 	 - Select frontends not used anywere.

The first usage is meant to allow an embedded user (or an advanced one)
to produce a kernel with a minimal set of drivers.

The second usage makes sense only during driver development, where you're 
playing with some frontends, or want to test your driver with the dummy 
frontend (that's why it is now enabled by default).

Btw, if you look at DVB_FE_CUSTOMISE help, it is recommended tho unselect it, 
if you're not sure what to do.

  >
>  Anyways, here's what I get:
>
>  $ grep "^CONFIG" .config
>  CONFIG_INPUT=y
>  CONFIG_USB=y
>  CONFIG_SND=y
>  CONFIG_I2C_ALGOBIT=y
>  CONFIG_INET=y
>  CONFIG_CRC32=y
>  CONFIG_SYSFS=y
>  CONFIG_PCI=y
>  CONFIG_VIRT_TO_BUS=y
>  CONFIG_NET=y
>  CONFIG_I2C=y
>  CONFIG_STANDALONE=y
>  CONFIG_MODULES=y
>  CONFIG_HAS_IOMEM=y
>  CONFIG_PROC_FS=y
>  CONFIG_HAS_DMA=y
>  CONFIG_SND_PCM=y
>  CONFIG_EXPERIMENTAL=y
>  CONFIG_IEEE1394=y
>  CONFIG_VIDEO_DEV=m
>  CONFIG_VIDEO_V4L2_COMMON=m
>  CONFIG_VIDEO_V4L1_COMPAT=y
>  CONFIG_DVB_CORE=m
>  CONFIG_VIDEO_MEDIA=m
>  CONFIG_VIDEO_SAA7146=m
>  CONFIG_VIDEO_SAA7146_VV=m
>  CONFIG_MEDIA_ATTACH=y
>  CONFIG_MEDIA_TUNER=m
>  CONFIG_MEDIA_TUNER_SIMPLE=m
>  CONFIG_MEDIA_TUNER_TDA8290=m
>  CONFIG_MEDIA_TUNER_TDA9887=m
>  CONFIG_MEDIA_TUNER_TEA5761=m
>  CONFIG_MEDIA_TUNER_TEA5767=m
>  CONFIG_MEDIA_TUNER_MT20XX=m
>  CONFIG_MEDIA_TUNER_XC2028=m
>  CONFIG_MEDIA_TUNER_XC5000=m
>  CONFIG_MEDIA_TUNER_MC44S803=m
>  CONFIG_VIDEO_V4L2=m
>  CONFIG_VIDEOBUF_GEN=m
>  CONFIG_VIDEOBUF_DMA_SG=m
>  CONFIG_DVB_DYNAMIC_MINORS=y
>  CONFIG_DVB_CAPTURE_DRIVERS=y
>  CONFIG_TTPCI_EEPROM=m
>  CONFIG_DVB_AV7110=m
>  CONFIG_DVB_AV7110_OSD=y
>  CONFIG_DVB_STV0299=m
>  CONFIG_DVB_TDA8083=m
>  CONFIG_DVB_VES1X93=m
>  CONFIG_DVB_SP8870=m
>  CONFIG_DVB_L64781=m
>  CONFIG_DVB_VES1820=m
>  CONFIG_DVB_STV0297=m
>  CONFIG_DVB_LNBP21=m

Seems perfect to my eyes.

-- 
Cheers,
Mauro


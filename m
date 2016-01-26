Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:51408 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966647AbcAZQgw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 11:36:52 -0500
Date: Tue, 26 Jan 2016 14:36:44 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] [media] em28xx: add MEDIA_TUNER dependency
Message-ID: <20160126143644.1d104040@recife.lan>
In-Reply-To: <6929423.KuNZKsBgHV@wuerfel>
References: <1453817424-3080054-1-git-send-email-arnd@arndb.de>
	<1453817424-3080054-6-git-send-email-arnd@arndb.de>
	<20160126123308.6d59d373@recife.lan>
	<6929423.KuNZKsBgHV@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 26 Jan 2016 16:53:38 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Tuesday 26 January 2016 12:33:08 Mauro Carvalho Chehab wrote:
> > Em Tue, 26 Jan 2016 15:10:00 +0100
> > Arnd Bergmann <arnd@arndb.de> escreveu:
> >   
> > > em28xx selects VIDEO_TUNER, which has a dependency on MEDIA_TUNER,
> > > so we get a Kconfig warning if that is disabled:
> > > 
> > > warning: (VIDEO_PVRUSB2 && VIDEO_USBVISION && VIDEO_GO7007 && VIDEO_AU0828_V4L2 && VIDEO_CX231XX && VIDEO_TM6000 && VIDEO_EM28XX && VIDEO_IVTV && VIDEO_MXB && VIDEO_CX18 && VIDEO_CX23885 && VIDEO_CX88 && VIDEO_BT848 && VIDEO_SAA7134 && VIDEO_SAA7164) selects VIDEO_TUNER which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_TUNER)  
> > 
> > This warning is bogus, as it is OK to select VIDEO_TUNER even if MEDIA_TUNER
> > is not defined.
> > 
> > See how MEDIA_TUNER is defined:
> > 
> > 
> > config MEDIA_TUNER
> > 	tristate
> > 	depends on (MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT) && I2C
> > 	default y
> > 	select MEDIA_TUNER_XC2028 if MEDIA_SUBDRV_AUTOSELECT
> > 	select MEDIA_TUNER_XC5000 if MEDIA_SUBDRV_AUTOSELECT
> > 	select MEDIA_TUNER_XC4000 if MEDIA_SUBDRV_AUTOSELECT
> > 	select MEDIA_TUNER_MT20XX if MEDIA_SUBDRV_AUTOSELECT
> > 	select MEDIA_TUNER_TDA8290 if MEDIA_SUBDRV_AUTOSELECT
> > 	select MEDIA_TUNER_TEA5761 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
> > 	select MEDIA_TUNER_TEA5767 if MEDIA_SUBDRV_AUTOSELECT && MEDIA_RADIO_SUPPORT
> > 	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
> > 	select MEDIA_TUNER_TDA9887 if MEDIA_SUBDRV_AUTOSELECT
> > 	select MEDIA_TUNER_MC44S803 if MEDIA_SUBDRV_AUTOSELECT
> > 
> > MEDIA_TUNER is just one of the media Kconfig workarounds to its limitation of
> > not allowing to select a device that has dependencies. It is true if the user
> > selected either TV or radio media devices. It works together with 
> > MEDIA_SUBDRV_AUTOSELECT. When both are enabled, it selects all
> > media tuners. That makes easier for end users to not need to worry about
> > manually selecting the needed tuners.
> > 
> > Advanced users may, instead, manually select the media tuner that his
> > hardware needs. In such case, it doesn't matter if MEDIA_TUNER
> > is enabled or not.
> > 
> > As this is due to a Kconfig limitation, I've no idea how to fix or get
> > hid of it, but making em28xx dependent of MEDIA_TUNER is wrong.  
> 
> I don't understand what limitation you see here. 

Before MEDIA_TUNER, what we had was something like:

	config MEDIA_driver_foo
	select VIDEO_tuner_bar if MEDIA_SUBDRV_AUTOSELECT
	select MEDIA_frontend_foobar if MEDIA_SUBDRV_AUTOSELECT
	...

However, as different I2C drivers had different dependencies, this
used to cause lots of troubles. So, one of the Kbuild maintainers
came out with the idea of converting from select into depends on.
The MEDIA_TUNER is just an ancillary invisible option to make it
work at the tuner's side, as usually what we want is to have all
tuners selected, as we don't have a one to one mapping about what
driver supports what tuner (nor we wanted to do it, as this would
mean lots of work for not much gain).

> The definition
> of the VIDEO_TUNER symbol is an empty 'tristate' symbol with a
> dependency on MEDIA_TUNER to ensure we get a warning if MEDIA_TUNER
> is not enabled, and to ensure it is set to 'm' if MEDIA_TUNER=m and
> a "bool" driver selects VIDEO_TUNER.

No, VIDEO_TUNER is there because we wanted to be able to use select
to enable V4L2 tuner core support and let people to manually select
the needed I2C devices with MEDIA_SUBDRV_AUTOSELECT unselected.

> 
> You are saying that the first one is not correct, so I assume we
> still need the second meaning. We could probably do that like the
> patch below (untested) that makes the intention much more explicit.
> 
> 	Arnd
> 
> diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
> index 9beece00869b..1050bdf1848f 100644
> --- a/drivers/media/v4l2-core/Kconfig
> +++ b/drivers/media/v4l2-core/Kconfig
> @@ -37,7 +37,11 @@ config VIDEO_PCI_SKELETON
>  # Used by drivers that need tuner.ko
>  config VIDEO_TUNER
>  	tristate
> -	depends on MEDIA_TUNER
> +
> +config VIDEO_TUNER_MODULE
> +	tristate # must not be built-in if MEDIA_TUNER=m because of I2C
> +	default y if VIDEO_TUNER=y || MEDIA_TUNER=y
> +	default m if VIDEO_TUNER=m

Doesn't need to worry about that, because all drivers that select VIDEO_TUNER
depend on I2C:

drivers/media/pci/bt8xx/Kconfig:        select VIDEO_TUNER
drivers/media/pci/cx18/Kconfig: select VIDEO_TUNER
drivers/media/pci/cx23885/Kconfig:      select VIDEO_TUNER
drivers/media/pci/cx88/Kconfig: select VIDEO_TUNER
drivers/media/pci/ivtv/Kconfig: select VIDEO_TUNER
drivers/media/pci/saa7134/Kconfig:      select VIDEO_TUNER
drivers/media/pci/saa7146/Kconfig:      select VIDEO_TUNER
drivers/media/pci/saa7164/Kconfig:      select VIDEO_TUNER
drivers/media/usb/au0828/Kconfig:       select VIDEO_TUNER
drivers/media/usb/cx231xx/Kconfig:      select VIDEO_TUNER
drivers/media/usb/em28xx/Kconfig:       select VIDEO_TUNER
drivers/media/usb/go7007/Kconfig:       select VIDEO_TUNER
drivers/media/usb/pvrusb2/Kconfig:      select VIDEO_TUNER
drivers/media/usb/tm6000/Kconfig:       select VIDEO_TUNER
drivers/media/usb/usbvision/Kconfig:    select VIDEO_TUNER

This will always be the case for PCI/USB drivers that support analog TV,
as those drivers need to implement the I2C adapter code inside them.

>  
>  # Used by drivers that need v4l2-mem2mem.ko
>  config V4L2_MEM2MEM_DEV
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index 1dc8bba2b198..971af6398d6d 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -21,7 +21,7 @@ obj-$(CONFIG_VIDEO_V4L2) += videodev.o
>  obj-$(CONFIG_VIDEO_V4L2) += v4l2-common.o
>  obj-$(CONFIG_VIDEO_V4L2) += v4l2-dv-timings.o
>  
> -obj-$(CONFIG_VIDEO_TUNER) += tuner.o
> +obj-$(CONFIG_VIDEO_TUNER_MODULE) += tuner.o
>  
>  obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o

Yes, the above could work. This is simpler fix, and should work fine for
all current usecases:

diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 9beece00869b..b30e1c879a57 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -37,7 +37,7 @@ config VIDEO_PCI_SKELETON
 # Used by drivers that need tuner.ko
 config VIDEO_TUNER
 	tristate
-	depends on MEDIA_TUNER
+	default MEDIA_TUNER
 
 # Used by drivers that need v4l2-mem2mem.ko
 config V4L2_MEM2MEM_DEV


Ok, if we'll have platform drivers for analog TV using the I2C bus
at directly in SoC, then your solution is better, but the tuner core
driver may not be the best way of doing it. So, for now, I would use
the simpler version.

Regards,
Mauro

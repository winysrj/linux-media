Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2713 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab1I3LaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 07:30:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFCv2 PATCH 2/7] V4L menu: move legacy drivers into their own submenu.
Date: Fri, 30 Sep 2011 13:29:55 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1317373276-5818-1-git-send-email-hverkuil@xs4all.nl> <eb58a802b520329b54aebfeb2a1400870d61b127.1317372990.git.hans.verkuil@cisco.com> <4E85A401.1040200@redhat.com>
In-Reply-To: <4E85A401.1040200@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109301329.55357.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, September 30, 2011 13:12:01 Mauro Carvalho Chehab wrote:
> Em 30-09-2011 06:01, Hans Verkuil escreveu:
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> > ---
> >  drivers/media/video/Kconfig |  185 +++++++++++++++++++++++-------------------
> >  1 files changed, 101 insertions(+), 84 deletions(-)
> > 
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index 0f8ccb4..86fdd7d 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -685,51 +685,6 @@ source "drivers/media/video/omap/Kconfig"
> >  
> >  source "drivers/media/video/bt8xx/Kconfig"
> >  
> > -config VIDEO_PMS
> > -	tristate "Mediavision Pro Movie Studio Video For Linux"
> > -	depends on ISA && VIDEO_V4L2
> > -	help
> > -	  Say Y if you have such a thing.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called pms.
> > -
> > -config VIDEO_BWQCAM
> > -	tristate "Quickcam BW Video For Linux"
> > -	depends on PARPORT && VIDEO_V4L2
> > -	help
> > -	  Say Y have if you the black and white version of the QuickCam
> > -	  camera. See the next option for the color version.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called bw-qcam.
> > -
> > -config VIDEO_CQCAM
> > -	tristate "QuickCam Colour Video For Linux (EXPERIMENTAL)"
> > -	depends on EXPERIMENTAL && PARPORT && VIDEO_V4L2
> > -	help
> > -	  This is the video4linux driver for the colour version of the
> > -	  Connectix QuickCam.  If you have one of these cameras, say Y here,
> > -	  otherwise say N.  This driver does not work with the original
> > -	  monochrome QuickCam, QuickCam VC or QuickClip.  It is also available
> > -	  as a module (c-qcam).
> > -	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
> > -
> > -config VIDEO_W9966
> > -	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
> > -	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
> > -	help
> > -	  Video4linux driver for Winbond's w9966 based Webcams.
> > -	  Currently tested with the LifeView FlyCam Supra.
> > -	  If you have one of these cameras, say Y here
> > -	  otherwise say N.
> > -	  This driver is also available as a module (w9966).
> > -
> > -	  Check out <file:Documentation/video4linux/w9966.txt> for more
> > -	  information.
> > -
> > -source "drivers/media/video/cpia2/Kconfig"
> > -
> >  config VIDEO_VINO
> >  	tristate "SGI Vino Video For Linux (EXPERIMENTAL)"
> >  	depends on I2C && SGI_IP22 && EXPERIMENTAL && VIDEO_V4L2
> > @@ -756,45 +711,6 @@ config VIDEO_MEYE
> >  
> >  source "drivers/media/video/saa7134/Kconfig"
> >  
> > -config VIDEO_MXB
> > -	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
> > -	depends on PCI && VIDEO_V4L2 && I2C
> > -	select VIDEO_SAA7146_VV
> > -	select VIDEO_TUNER
> > -	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
> > -	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
> > -	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
> > -	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
> > -	---help---
> > -	  This is a video4linux driver for the 'Multimedia eXtension Board'
> > -	  TV card by Siemens-Nixdorf.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called mxb.
> > -
> > -config VIDEO_HEXIUM_ORION
> > -	tristate "Hexium HV-PCI6 and Orion frame grabber"
> > -	depends on PCI && VIDEO_V4L2 && I2C
> > -	select VIDEO_SAA7146_VV
> > -	---help---
> > -	  This is a video4linux driver for the Hexium HV-PCI6 and
> > -	  Orion frame grabber cards by Hexium.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called hexium_orion.
> > -
> > -config VIDEO_HEXIUM_GEMINI
> > -	tristate "Hexium Gemini frame grabber"
> > -	depends on PCI && VIDEO_V4L2 && I2C
> > -	select VIDEO_SAA7146_VV
> > -	---help---
> > -	  This is a video4linux driver for the Hexium Gemini frame
> > -	  grabber card by Hexium. Please note that the Gemini Dual
> > -	  card is *not* fully supported.
> > -
> > -	  To compile this driver as a module, choose M here: the
> > -	  module will be called hexium_gemini.
> > -
> >  config VIDEO_TIMBERDALE
> >  	tristate "Support for timberdale Video In/LogiWIN"
> >  	depends on VIDEO_V4L2 && I2C && DMADEVICES
> > @@ -1067,6 +983,107 @@ config VIDEO_S5P_MIPI_CSIS
> >  
> >  source "drivers/media/video/s5p-tv/Kconfig"
> >  
> > +#
> > +# Legacy drivers configuration
> > +#
> > +
> > +menuconfig V4L_LEGACY_DRIVERS
> > +	bool "V4L legacy devices"
> > +	default n
> > +	---help---
> > +	  Say Y here to enable support for these legacy drivers. These drivers
> > +	  are for old and obsure hardware (e.g. parallel port webcams, ISA
> > +	  drivers, niche hardware).
> 
> As before, I don't like the name "legacy". The drivers themselves are not
> legacy, as they work fine, as far as I know.
> 
> Parallel port and ISA could be just called as "parallel port and ISA drivers".
> 
> With regards to saa7146 drivers, it is hard to say the the hardware is more
> legacy than, for example, bttv.

The saa7146 V4L drivers (MXB and Hexium) are very rarely used. It's very hard
to find the hardware and you almost never see questions about it on the list.
The av7110 DVB drivers that are saa7146 based still pop up every now and then.

> As I said before, defining what's a legacy hardware and what isn't is not
> an objective criteria: it is legacy on what sense? I was told that tda18271
> were recently discontinued. Should we mark all drivers that use it as legacy?

Of course not. Legacy drivers are for hardware that is almost never used
anymore (based on the traffic on the mailinglist) and no longer sold since
many years. Bonus points for using an obsolete interface (ISA, parport).

If you really hate this, then I can move the PCI drivers back to the normal
menu.

I don't see a problem here: bttv sees a lot of development and use and hardware
is even still being made today. On the other hand, what was the last time
anyone ever asked something about the Hexium drivers? If it wasn't for the fact
that I got the hardware for Hexium and MXB from Michael Hunold (so that I can
test it) I would have been in favor of removing the drivers altogether.

Regards,

	Hans

> 
> > +
> > +if V4L_LEGACY_DRIVERS
> > +
> > +config VIDEO_PMS
> > +	tristate "Mediavision Pro Movie Studio Video For Linux"
> > +	depends on ISA && VIDEO_V4L2
> > +	help
> > +	  Say Y if you have the ISA Mediavision Pro Movie Studio
> > +	  capture card.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called pms.
> > +
> > +config VIDEO_BWQCAM
> > +	tristate "Quickcam BW Video For Linux"
> > +	depends on PARPORT && VIDEO_V4L2
> > +	help
> > +	  Say Y have if you the black and white version of the QuickCam
> > +	  camera. See the next option for the color version.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called bw-qcam.
> > +
> > +config VIDEO_CQCAM
> > +	tristate "QuickCam Colour Video For Linux (EXPERIMENTAL)"
> > +	depends on EXPERIMENTAL && PARPORT && VIDEO_V4L2
> > +	help
> > +	  This is the video4linux driver for the colour version of the
> > +	  Connectix QuickCam.  If you have one of these cameras, say Y here,
> > +	  otherwise say N.  This driver does not work with the original
> > +	  monochrome QuickCam, QuickCam VC or QuickClip.  It is also available
> > +	  as a module (c-qcam).
> > +	  Read <file:Documentation/video4linux/CQcam.txt> for more information.
> > +
> > +config VIDEO_W9966
> > +	tristate "W9966CF Webcam (FlyCam Supra and others) Video For Linux"
> > +	depends on PARPORT_1284 && PARPORT && VIDEO_V4L2
> > +	help
> > +	  Video4linux driver for Winbond's w9966 based Webcams.
> > +	  Currently tested with the LifeView FlyCam Supra.
> > +	  If you have one of these cameras, say Y here
> > +	  otherwise say N.
> > +	  This driver is also available as a module (w9966).
> > +
> > +	  Check out <file:Documentation/video4linux/w9966.txt> for more
> > +	  information.
> > +
> > +source "drivers/media/video/cpia2/Kconfig"
> > +
> > +config VIDEO_MXB
> > +	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
> > +	depends on PCI && VIDEO_V4L2 && I2C
> > +	select VIDEO_SAA7146_VV
> > +	select VIDEO_TUNER
> > +	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
> > +	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
> > +	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
> > +	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
> > +	---help---
> > +	  This is a video4linux driver for the 'Multimedia eXtension Board'
> > +	  TV card by Siemens-Nixdorf.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called mxb.
> > +
> > +config VIDEO_HEXIUM_ORION
> > +	tristate "Hexium HV-PCI6 and Orion frame grabber"
> > +	depends on PCI && VIDEO_V4L2 && I2C
> > +	select VIDEO_SAA7146_VV
> > +	---help---
> > +	  This is a video4linux driver for the Hexium HV-PCI6 and
> > +	  Orion frame grabber cards by Hexium.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called hexium_orion.
> > +
> > +config VIDEO_HEXIUM_GEMINI
> > +	tristate "Hexium Gemini frame grabber"
> > +	depends on PCI && VIDEO_V4L2 && I2C
> > +	select VIDEO_SAA7146_VV
> > +	---help---
> > +	  This is a video4linux driver for the Hexium Gemini frame
> > +	  grabber card by Hexium. Please note that the Gemini Dual
> > +	  card is *not* fully supported.
> > +
> > +	  To compile this driver as a module, choose M here: the
> > +	  module will be called hexium_gemini.
> > +
> > +endif # V4L_LEGACY_DRIVERS
> > +
> >  endif # VIDEO_CAPTURE_DRIVERS
> >  
> >  menuconfig V4L_MEM2MEM_DRIVERS
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

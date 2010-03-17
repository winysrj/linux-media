Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47308 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754902Ab0CQN4Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 09:56:24 -0400
Date: Wed, 17 Mar 2010 14:56:26 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L: introduce a Kconfig variable to disable helper-chip
 autoselection
In-Reply-To: <4BA0D214.3050506@redhat.com>
Message-ID: <Pine.LNX.4.64.1003171446360.4354@axis700.grange>
References: <Pine.LNX.4.64.1003171336180.4354@axis700.grange>
 <4BA0D214.3050506@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 17 Mar 2010, Mauro Carvalho Chehab wrote:

> Em 17-03-2010 09:38, Guennadi Liakhovetski escreveu:
> > Helper-chip autoselection doesn't work in some situations. Add a configuration
> > variable to let drivers disable it. Use it to disable autoselection if
> > SOC_CAMERA is selected.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > This will also be used from VOU video-output driver, other SoC drivers 
> > might also want to select this option.
> > 
> >  drivers/media/video/Kconfig |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> > index 64682bf..73f3808 100644
> > --- a/drivers/media/video/Kconfig
> > +++ b/drivers/media/video/Kconfig
> > @@ -77,8 +77,12 @@ config VIDEO_FIXED_MINOR_RANGES
> >  
> >  	  When in doubt, say N.
> >  
> > +config VIDEO_HELPER_CHIPS_AUTO_DISABLE
> > +	bool
> > +
> >  config VIDEO_HELPER_CHIPS_AUTO
> >  	bool "Autoselect pertinent encoders/decoders and other helper chips"
> > +	depends on !VIDEO_HELPER_CHIPS_AUTO_DISABLE
> >  	default y
> >  	---help---
> >  	  Most video cards may require additional modules to encode or
> > @@ -816,6 +820,7 @@ config SOC_CAMERA
> >  	tristate "SoC camera support"
> >  	depends on VIDEO_V4L2 && HAS_DMA && I2C
> >  	select VIDEOBUF_GEN
> > +	select VIDEO_HELPER_CHIPS_AUTO_DISABLE
> >  	help
> >  	  SoC Camera is a common API to several cameras, not connecting
> >  	  over a bus like PCI or USB. For example some i2c camera connected
> NACK.
> 
> If this is not working, please fix, instead of doing a workaround.
> 
> What's the exact problem?

Hi Mauro

we just discussed this with Hans on IRC, and if I understood him 
correctly, he was of the same opinion, that adding such a variable could 
help.

The problem is the following: this automatic selection works in a way, 
that various bridge drivers select "helper" chip drivers (i2c subdevice 
drivers" if this autoselection is enabled, e.g.

config VIDEO_MXB
	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
	depends on PCI && VIDEO_V4L1 && I2C
	select VIDEO_SAA7146_VV
	select VIDEO_TUNER
	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO

With SoC-based set ups this cannot work. The only location where this 
information is available is platform code under arch/... and selecting 
these drivers from there would be awkward imho. So, for example, we want 
to put the ak881x video encoder driver under

comment "Video encoders"

and those drivers are only visible if VIDEO_HELPER_CHIPS_AUTO is 
unselected, and if it is selected, which it is by default, there is noone 
to automatically select ak881x. So, I think, the proposed patch is not a 
work-around, but a reasonable solution for this issue.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

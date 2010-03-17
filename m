Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2359 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0CQTyr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 15:54:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] V4L: introduce a Kconfig variable to disable helper-chip autoselection
Date: Wed, 17 Mar 2010 20:54:53 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1003171336180.4354@axis700.grange> <Pine.LNX.4.64.1003171446360.4354@axis700.grange> <4BA12D47.8090808@redhat.com>
In-Reply-To: <4BA12D47.8090808@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003172054.53553.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 17 March 2010 20:28:07 Mauro Carvalho Chehab wrote:
> Guennadi Liakhovetski wrote:
> 
> > Hi Mauro
> > 
> > we just discussed this with Hans on IRC, and if I understood him 
> > correctly, he was of the same opinion, that adding such a variable could 
> > help.
> > 
> > The problem is the following: this automatic selection works in a way, 
> > that various bridge drivers select "helper" chip drivers (i2c subdevice 
> > drivers" if this autoselection is enabled, e.g.
> > 
> > config VIDEO_MXB
> > 	tristate "Siemens-Nixdorf 'Multimedia eXtension Board'"
> > 	depends on PCI && VIDEO_V4L1 && I2C
> > 	select VIDEO_SAA7146_VV
> > 	select VIDEO_TUNER
> > 	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
> > 	select VIDEO_TDA9840 if VIDEO_HELPER_CHIPS_AUTO
> > 	select VIDEO_TEA6415C if VIDEO_HELPER_CHIPS_AUTO
> > 	select VIDEO_TEA6420 if VIDEO_HELPER_CHIPS_AUTO
> > 
> > With SoC-based set ups this cannot work. The only location where this 
> > information is available is platform code under arch/... and selecting 
> > these drivers from there would be awkward imho.
> 
> Kconfig works fine if the var is on another place. So, you could do things
> like:
> 
> config VIDEO_xxx
> 	select VIDEO_foo if VIDEO_HELPER_CHIPS_AUTO && ARCH_bar
> 
> You may even convert it into dependencies like:
> 
> config VIDEO_I2C_foo
> 	depends on ARCH_bar && config VIDEO_xxx
> 	default y if VIDEO_HELPER_CHIPS_AUTO

I2C drivers are NOT dependent on architectures. They can be used anywhere.

> 
> The depends on syntax generally works better than using select. We've converted
> some select into depends on a few places like tuner, like, for example:
> 
> config MEDIA_TUNER_TDA827X
>         tristate "Philips TDA827X silicon tuner"
>         depends on VIDEO_MEDIA && I2C
>         default m if MEDIA_TUNER_CUSTOMISE
> 
> > So, for example, we want 
> > to put the ak881x video encoder driver under
> > 
> > comment "Video encoders"
> > 
> > and those drivers are only visible if VIDEO_HELPER_CHIPS_AUTO is 
> > unselected, and if it is selected, which it is by default, there is noone 
> > to automatically select ak881x. So, I think, the proposed patch is not a 
> > work-around, but a reasonable solution for this issue.
> 
> Even the menu being invisible, any of the above logic would work, if you do
> something like:
> 
> config VIDEO_AK881X
> 	depends on ARCH_MX1 && I2C
> 	default y if VIDEO_HELPER_CHIPS_AUTO && SOC_CAMERA
> 
> or:
> 
> config SOC_CAMERA
> 	select VIDEO_AK881X if VIDEO_HELPER_CHIPS_AUTO && ARCH_MX1

Same problem here: the architecture does not determine whether this i2c driver
is needed. That is determined by the board definition. I guess the right place
to do this is probably in a 'mach' specific Kconfig like for example
arch/arm/mach-davinci/Kconfig.

But to be honest, I think that the SoC + VIDEO_HELPER_CHIPS_AUTO combination
is pretty pointless.

Regards,

	Hans

> 
> You should just take some care, since there are some combinations that won't work.
> For example, if SOC_CAMERA is a module, any ancillary drivers used by it should also
> be 'm', otherwise, the driver will break. That's why, when having multiple
> dependencies, the better is to use the "depends on" way.
> 
> 
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

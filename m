Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3024 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3F1LTW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 07:19:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] usbtv: fix dependency
Date: Fri, 28 Jun 2013 13:18:44 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>
References: <201306281024.15428.hverkuil@xs4all.nl> <20130628080043.46dd09c0.mchehab@redhat.com>
In-Reply-To: <20130628080043.46dd09c0.mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306281318.44880.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri June 28 2013 13:00:43 Mauro Carvalho Chehab wrote:
> Em Fri, 28 Jun 2013 10:24:15 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > This fixes a dependency problem as found by Randy Dunlap:
> > 
> > https://lkml.org/lkml/2013/6/27/501
> > 
> > Mauro, is there any reason for any V4L2 driver to depend on VIDEO_DEV instead of
> > just VIDEO_V4L2?
> > 
> > Some drivers depend on VIDEO_DEV, some on VIDEO_V4L2, some on both. It's all
> > pretty chaotic.
> 
> It should be noticed that, despite its name, this config is actually a
> joint dependency of VIDEO_DEV and I2C that will compile drivers as module
> if either I2C or VIDEO_DEV is a module:
> 
> 	config VIDEO_V4L2
> 		tristate
> 		depends on (I2C || I2C=n) && VIDEO_DEV
> 		default (I2C || I2C=n) && VIDEO_DEV
> 
> So, a V4L2 device that doesn't have any I2C device doesn't need to depend
> on VIDEO_V4L2. That includes, for example, reversed-engineered webcam
> drivers where the sensor code is inside the driver and a few capture-only
> device drivers.

Yes, it does have to depend on it. That's exactly why usbtv is failing: like
any other v4l2 driver usbtv needs the videodev.ko module. That is dependent
on VIDEO_V4L2. What is happening here is that the dependency of usbtv on
VIDEO_DEV allows it to be built as part of the kernel, but VIDEO_V4L2 is built
as a module due to its I2C dependency with the result that usbtv can't link to
the videodev functions.

The way things are today I do not believe any v4l2 driver should depend on
VIDEO_DEV, instead they should all depend on VIDEO_V4L2. That would make a
lot more sense.

	Hans

> 
> It should be noticed, however, that, on several places, the need of adding
> a "depends on VIDEO_V4L2" is not needed, as, on some places, the syntax
> is:
> 
> 	if VIDEO_V4L2
> 
> 	config "driver foo"
> 	...
> 
> 	endif
> 
> Btw, it could make sense to rename it to something clearer, like
> VIDEO_DEV_AND_I2C and define it as:
> 
> 	config VIDEO_DEV_AND_I2C
> 		tristate
> 		depends on I2C && VIDEO_DEV
> 		default y
> 
> Or, even better, to just get rid of it and explicitly add I2C on all
> places where it is used.
> 
> 
> Regards,
> Mauro
> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > diff --git a/drivers/media/usb/usbtv/Kconfig b/drivers/media/usb/usbtv/Kconfig
> > index 8864436..7c5b860 100644
> > --- a/drivers/media/usb/usbtv/Kconfig
> > +++ b/drivers/media/usb/usbtv/Kconfig
> > @@ -1,6 +1,6 @@
> >  config VIDEO_USBTV
> >          tristate "USBTV007 video capture support"
> > -        depends on VIDEO_DEV
> > +        depends on VIDEO_V4L2
> >          select VIDEOBUF2_VMALLOC
> >  
> >          ---help---
> 
> 
> 

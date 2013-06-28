Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1594 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3F1M7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jun 2013 08:59:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] usbtv: fix dependency
Date: Fri, 28 Jun 2013 14:59:10 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <201306281024.15428.hverkuil@xs4all.nl> <201306281318.44880.hverkuil@xs4all.nl> <20130628094246.555bb203.mchehab@redhat.com>
In-Reply-To: <20130628094246.555bb203.mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306281459.10398.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri June 28 2013 14:42:46 Mauro Carvalho Chehab wrote:
> Em Fri, 28 Jun 2013 13:18:44 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > On Fri June 28 2013 13:00:43 Mauro Carvalho Chehab wrote:
> > > Em Fri, 28 Jun 2013 10:24:15 +0200
> > > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> > > 
> > > > This fixes a dependency problem as found by Randy Dunlap:
> > > > 
> > > > https://lkml.org/lkml/2013/6/27/501
> > > > 
> > > > Mauro, is there any reason for any V4L2 driver to depend on VIDEO_DEV instead of
> > > > just VIDEO_V4L2?
> > > > 
> > > > Some drivers depend on VIDEO_DEV, some on VIDEO_V4L2, some on both. It's all
> > > > pretty chaotic.
> > > 
> > > It should be noticed that, despite its name, this config is actually a
> > > joint dependency of VIDEO_DEV and I2C that will compile drivers as module
> > > if either I2C or VIDEO_DEV is a module:
> > > 
> > > 	config VIDEO_V4L2
> > > 		tristate
> > > 		depends on (I2C || I2C=n) && VIDEO_DEV
> > > 		default (I2C || I2C=n) && VIDEO_DEV
> > > 
> > > So, a V4L2 device that doesn't have any I2C device doesn't need to depend
> > > on VIDEO_V4L2. That includes, for example, reversed-engineered webcam
> > > drivers where the sensor code is inside the driver and a few capture-only
> > > device drivers.
> > 
> > Yes, it does have to depend on it. That's exactly why usbtv is failing: like
> > any other v4l2 driver usbtv needs the videodev.ko module. That is dependent
> > on VIDEO_V4L2. What is happening here is that the dependency of usbtv on
> > VIDEO_DEV allows it to be built as part of the kernel, but VIDEO_V4L2 is built
> > as a module due to its I2C dependency with the result that usbtv can't link to
> > the videodev functions.
> > 
> > The way things are today I do not believe any v4l2 driver should depend on
> > VIDEO_DEV, instead they should all depend on VIDEO_V4L2. That would make a
> > lot more sense.
> 
> Hmm...
> 
> $ git grep -l i2c drivers/media/v4l2-core/
> drivers/media/v4l2-core/tuner-core.c		(not part of videodev.ko module)
> drivers/media/v4l2-core/v4l2-async.c
> drivers/media/v4l2-core/v4l2-common.c
> drivers/media/v4l2-core/v4l2-ctrls.c		(actually, there's just a comment there)
> drivers/media/v4l2-core/v4l2-device.c
> 
> $ git grep  CONFIG_I2C drivers/media/v4l2-core/
> drivers/media/v4l2-core/v4l2-common.c:#if IS_ENABLED(CONFIG_I2C)
> drivers/media/v4l2-core/v4l2-common.c:#endif /* defined(CONFIG_I2C) */
> drivers/media/v4l2-core/v4l2-device.c:#if IS_ENABLED(CONFIG_I2C)
> 
> yes, there are some parts of videodev that are dependent on I2C.
> 
> That's basically why all V4L2 drivers should depend on VIDEO_V4L2.
> 
> That's said, before the addition of v4l2-async, it was safe to compile
> the core without I2C, as the parts of the code that are I2C specific are
> protected by a:
> 	#if defined(CONFIG_I2C)
> 
> With its addition, I suspect that we'll still have Kbuild issues, if I2C
> is disabled and a driver that doesn't depends on I2C is compiled.
> 
> So, 2 patches seem to be needed:
> 
> 1) a patch that replaces all driver dependencies from CONFIG_DEV to
>    CONFIG_V4L2;
> 
> 2) a patch that fixes the issues with v4l2-async.
> 
> With regards to the last one, I can see 3 ways to fix it:
> 	1) don't add v4l2-async at videodev.ko if I2C is not selected;
> 	2) protect the I2C specific parts of v4l2-async with
> 		#if defined(CONFIG_I2C)
> 	3) put v4l2-async on a separate module.
> 
> (or some combination of the above)
> 
> As only very few drivers use v4l2-async, as this is more focused to
> fix troubles with OT, I think that the better would be to do (3) and
> to add an specific Kconfig entry for it.

No, #2 is the right choice here. That's necessary anyway since it is a valid
use-case that I2C is disabled and you use it for platform devices only.

Guennadi, can you look at this? The only thing that is probably needed is
that match_i2c returns false if CONFIG_I2C is undefined.

I prefer to keep this part of videodev, at least for now: I think there will
be a fairly quick uptake of this API internally, certainly for subdevs. Note
BTW that even x86 kernels come with CONFIG_OF enabled these days.

Regards,

	Hans

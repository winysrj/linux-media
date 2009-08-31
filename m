Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:42489 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbZHaNDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 09:03:42 -0400
Date: Mon, 31 Aug 2009 10:03:32 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: =?ISO-8859-1?B?TultZXRoIE3hcnRvbg==?= <nm127@freemail.hu>,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 1/2] v4l2: modify the webcam video standard
 handling
Message-ID: <20090831100332.2176c7c4@pedra.chehab.org>
In-Reply-To: <200908310858.24763.laurent.pinchart@ideasonboard.com>
References: <4A52E897.8000607@freemail.hu>
	<4A910C42.5000001@freemail.hu>
	<20090830234114.16b90c36@pedra.chehab.org>
	<200908310858.24763.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 31 Aug 2009 08:58:24 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hi Mauro,
> 
> On Monday 31 August 2009 04:41:14 Mauro Carvalho Chehab wrote:
> > Hi Németh,
> >
> > Em Sun, 23 Aug 2009 11:30:42 +0200
> >
> > Németh Márton <nm127@freemail.hu> escreveu:
> > > From: Márton Németh <nm127@freemail.hu>
> > >
> > > Change the handling of the case when vdev->tvnorms == 0.
> >
> > This patch (together with a few others related to tvnorms and camera
> > drivers) reopens an old discussion: should webcams report a tvnorm?
> >
> > There's no easy answer for it since:
> >
> > 1) removing support for VIDIOC_G_STD/VIDIOC_S_STD causes regressions, since
> > some userspace apps stops working;
> 
> Then those applications don't work with the uvcvideo driver in the first 
> place. This is getting less and less common :-)

Good to know. Yet, removing VIDIOC_[GS]_STD will break a behavior used on
webcams for a long time. One thing is to accept new webcam drivers without it.
This can be done (and were already done, when we accepted uvc). A separate
issue is to change the behavior of the userspace API on existing drivers.

> > 2) It is a common scenario to use cameras connected to some capture only
> > devices like several bttv boards used on surveillance systems. Those
> > drivers report STD, since they are used also on TV;
> >
> > 3) There are even some devices that allows cameras to be connected to one
> > input and TV on another input. This is another case were the driver will
> > report a TV std;
> 
> TV standards are ill-named, they are actually analog standards. 
> VIDIOC_[GS]_STD are perfectly valid for capture devices with analog inputs, 
> even if they don't use a TV tuner.

It is not that simple. In general, at the bridge chip, all inputs are digital.
The analog to digital conversion is done by a separate chip on most devices,
and there are some boards where you have, for example, digital sensors
connected to it.

> > 4) Most webcam formats are based on ITU-T formats designed to be compatible
> > with TV (formats like CIF and like 640x480 - and their
> > multiple/sub-multiples);
> 
> Even HD formats still have roots in the analog TV world. It's a real mess. 
> Nonetheless, even if the actual frame size is compatible with TV, there is 
> simply no concept of PAL/NTSC for webcams.

Ok, but still it is possible to use V4L2_STD_525_60 and V4L2_STD_625_50 when all
you need is to set the number of lines and the basis of the sampling rate.
There is also V4L2_STD_UNKNOWN standard used on some drivers.

> > 5) There are formats that weren't originated from TV on some digital
> > webcams, so, for those formats, it makes no sense to report an existing
> > std.
> >
> > Once people proposed to create an special format for those cases
> > (V4L2_STD_DIGITAL or something like that), but, after lots of discussions,
> > no changes were done at API nor at the drivers.
> 
> TV standards only apply to analog video. Let's simply not use it for digital 
> video. We don't expect drivers to implement VIDIOC_[GS]_JPEGCOMP with fake 
> values when they don't support JPEG compression, so we should not expect them 
> to implement VIDIOC_[GS]_STD when they don't support analog TV.

If you look at the tree, several drivers that returns compressed formats
implements those ioctls. This is even required on several cases, where you may
have an analog TV connected on it.

That's said, I understand your arguments that implementing [G/S]_STD is
senseless on almost all camera drivers, since it won't actually control
anything. So, IMO, a good compromise is to keep the existing implementation on
the legacy drivers [1], but think twice before implementing
it on a new driver.

[1] We could eventually drop it even for the existing drivers, provided that the
ioctl won't control anything at the device and that we properly document it in
Documentation/feature-removal-schedule.txt, giving enough time for the remaining
userspace apps and distros to change to the new behavior.

> > While we don't have an agreement on this, I don't think we should apply a
> > patch like this.



Cheers,
Mauro

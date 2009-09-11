Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1228 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbZIKUPW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2009 16:15:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: RFCv2: Media controller proposal
Date: Fri, 11 Sep 2009 22:15:15 +0200
Cc: "Hiremath, Vaibhav" <hvaibhav@ti.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <200909100913.09065.hverkuil@xs4all.nl> <200909112123.44778.hverkuil@xs4all.nl> <20090911165937.776a638d@caramujo.chehab.org>
In-Reply-To: <20090911165937.776a638d@caramujo.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909112215.15155.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 11 September 2009 21:59:37 Mauro Carvalho Chehab wrote:
> Em Fri, 11 Sep 2009 21:23:44 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > > In the case of resizer, I don't see why this can't be implemented as an ioctl
> > > over /dev/video device.
> > 
> > Well, no. Not in general. There are two problems. The first problem occurs if
> > you have multiple instances of a resizer (OK, not likely, but you *can* have
> > multiple video encoders or decoders or sensors). If all you have is the
> > streaming device node, then you cannot select to which resizer (or video
> > encoder) the ioctl should go. The media controller allows you to select the
> > recipient of the ioctl explicitly. Thus providing the control that these
> > applications need.
> 
> This case doesn't apply, since, if you have multiple encoders and/or decoders,
> you'll also have multiple /dev/video instances. All you need is to call it at
> the right device you need to control. Am I missing something here?

Typical use-case: two video decoders feed video into a composer that combines
the two (e.g. for PiP) and streams the result to one video node.

Now you want to change e.g. the contrast on one of those video decoders. That's
not going to be possible using /dev/video.

> > The second problem is that this will pollute the 'namespace' of a v4l device
> > node. Device drivers need to pass all those private ioctls to the right
> > sub-device. But they shouldn't have to care about that. If someone wants to
> > tweak the resizer (e.g. scaling coefficients), then pass it straight to the
> > resizer component.
> 
> Sorry, I missed your point here

Example: a sub-device can produce certain statistics. You want to have an
ioctl to obtain those statistics. If you call that through /dev/videoX, then
that main driver has to handle that ioctl in vidioc_default and pass it on
to the right subdev. So you have to write that vidioc_default handler,
know about the sub-devices that you have and which sub-device is linked to
the device node. You really don't want to have to do that. Especially not
when you are dealing with i2c devices that are loaded from platform code.

If a video encoder supports private ioctls, then an omap3 driver doesn't
want to know about that. Oh, and before you ask: just broadcasting that
ioctl is not a solution if you have multiple identical video encoders.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

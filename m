Return-path: <mchehab@gaivota>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3908 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab0LRKpo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 05:45:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Sat, 18 Dec 2010 11:45:29 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <4D0B9953.7090202@redhat.com> <201012180154.42363.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012180154.42363.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012181145.29681.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, December 18, 2010 01:54:41 Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Friday 17 December 2010 18:09:39 Mauro Carvalho Chehab wrote:
> > Em 14-12-2010 08:55, Laurent Pinchart escreveu:
> > > Hi Mauro,
> > > 
> > > Please don't forget this pull request for 2.6.37.
> > 
> > Pull request for upstream sent today.
> 
> Thank you.
> 
> > I didn't find any regressions at the BKL removal patches, but I noticed a
> > few issues with qv4l2, not all related to uvcvideo. The remaining of this
> > email is an attempt to document them for later fixes.
> > 
> > They don't seem to be regressions caused by BKL removal, but the better
> > would be to fix them later.
> > 
> > - with uvcvideo and two video apps, if qv4l2 is started first, the second
> > application doesn't start/capture. I suspect that REQBUFS (used by qv4l2
> > to probe mmap/userptr capabilities) create some resource locking at
> > uvcvideo. The proper way is to lock the resources only if the driver is
> > streaming, as other drivers and videobuf do.
> 
> I don't agree with that. The uvcvideo driver has one buffer queue per device, 
> so if an application requests buffers on one file handle it will lock other 
> applications out. If the driver didn't it would be subject to race conditions.

I agree with Laurent. Once an application calls REQBUFS with non-zero count,
then it should lock the resources needed for streaming. The reason behind that
is that REQBUFS also locks the current selected format in place, since the
format determines the amount of memory needed for the buffers.

The reason a lot of drivers don't do this is partially because for many TV
capture drivers it is highly unlikely that the buffer size will change after
calling REQBUFS (there are basically only two formats: 720x480 or 720x576 and
users will normally never change between the two). However, this is much more
likely to happen for webcams and embedded systems supporting HDTV.

The other reason is probably because driver developers simple do not realize
they need to lock the resources on REQBUFS. I'm sure many existing drivers will
fail miserably if you change the format after calling REQBUFS (particularly
with mmap streaming mode).

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54945 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582Ab0LRAyn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 19:54:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Sat, 18 Dec 2010 01:54:41 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012141155.20714.laurent.pinchart@ideasonboard.com> <4D0B9953.7090202@redhat.com>
In-Reply-To: <4D0B9953.7090202@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012180154.42363.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Mauro,

On Friday 17 December 2010 18:09:39 Mauro Carvalho Chehab wrote:
> Em 14-12-2010 08:55, Laurent Pinchart escreveu:
> > Hi Mauro,
> > 
> > Please don't forget this pull request for 2.6.37.
> 
> Pull request for upstream sent today.

Thank you.

> I didn't find any regressions at the BKL removal patches, but I noticed a
> few issues with qv4l2, not all related to uvcvideo. The remaining of this
> email is an attempt to document them for later fixes.
> 
> They don't seem to be regressions caused by BKL removal, but the better
> would be to fix them later.
> 
> - with uvcvideo and two video apps, if qv4l2 is started first, the second
> application doesn't start/capture. I suspect that REQBUFS (used by qv4l2
> to probe mmap/userptr capabilities) create some resource locking at
> uvcvideo. The proper way is to lock the resources only if the driver is
> streaming, as other drivers and videobuf do.

I don't agree with that. The uvcvideo driver has one buffer queue per device, 
so if an application requests buffers on one file handle it will lock other 
applications out. If the driver didn't it would be subject to race conditions.

> - with saa7134 and qv4l2 (and after a fix for input capabilities): saa7134
> and/or qv4l2 doesn't seem to work fine if video format is changed to a
> 60HZ format (NTSC or PAL/M). It keeps trying to use 576 lines, but the
> driver only works with 480 lines for those formats. So, if qv4l2 tries to
> capture with STD/M, it fails, except if the number of lines is manually
> fixed by the user.
> 
> - at least with the saa7134 board I used for test, video capture fails on
> some conditions. This is not related to BKL patches. I suspect it may be
> some initialization failure with the tuner (tda8275/tda8290), but I didn't
> have time to dig into it, nor to test with a simpler saa7134 device. The
> device I used was an Avermedia m135.

-- 
Regards,

Laurent Pinchart

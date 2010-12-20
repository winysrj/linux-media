Return-path: <mchehab@gaivota>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4857 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345Ab0LTMqD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 07:46:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [GIT PULL FOR 2.6.37] uvcvideo: BKL removal
Date: Mon, 20 Dec 2010 13:45:45 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
References: <201011291115.11061.laurent.pinchart@ideasonboard.com> <201012201328.06493.hverkuil@xs4all.nl> <201012201335.29747.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201012201335.29747.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012201345.45284.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Monday, December 20, 2010 13:35:28 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 20 December 2010 13:28:06 Hans Verkuil wrote:
> > On Monday, December 20, 2010 13:10:32 Mauro Carvalho Chehab wrote:
> > > Em 18-12-2010 08:45, Hans Verkuil escreveu:
> > > > On Saturday, December 18, 2010 01:54:41 Laurent Pinchart wrote:
> > > >> On Friday 17 December 2010 18:09:39 Mauro Carvalho Chehab wrote:
> > > >>>
> > > >>> I didn't find any regressions at the BKL removal patches, but I
> > > >>> noticed a few issues with qv4l2, not all related to uvcvideo. The
> > > >>> remaining of this email is an attempt to document them for later
> > > >>> fixes.
> > > >>> 
> > > >>> They don't seem to be regressions caused by BKL removal, but the
> > > >>> better would be to fix them later.
> > > >>> 
> > > >>> - with uvcvideo and two video apps, if qv4l2 is started first, the
> > > >>> second application doesn't start/capture. I suspect that REQBUFS
> > > >>> (used by qv4l2 to probe mmap/userptr capabilities) create some
> > > >>> resource locking at uvcvideo. The proper way is to lock the
> > > >>> resources only if the driver is streaming, as other drivers and
> > > >>> videobuf do.
> > > >> 
> > > >> I don't agree with that. The uvcvideo driver has one buffer queue per
> > > >> device, so if an application requests buffers on one file handle it
> > > >> will lock other applications out. If the driver didn't it would be
> > > >> subject to race conditions.
> > > > 
> > > > I agree with Laurent. Once an application calls REQBUFS with non-zero
> > > > count, then it should lock the resources needed for streaming. The
> > > > reason behind that is that REQBUFS also locks the current selected
> > > > format in place, since the format determines the amount of memory
> > > > needed for the buffers.
> > > 
> > > qv4l2 calls REQBUFS(1), then REQBUFS(0). Well, this is currently wrong,
> > > as most drivers will only release buffers at VIDIOC_STREAMOFF.
> > 
> > qv4l2 first calls STREAMOFF, then REQBUFS(1), then REQBUFS(0). In the hope
> > that one of these will actually free any buffers. It's random at the
> > moment when drivers release buffers, one of the reasons for using vb2.
> > 
> > > Anyway, even replacing
> > > REQBUFS(0) with VIDIOC_STREAMOFF at qv4l2 won't help with uvcvideo. It
> > > seems that, once buffers are requested at uvcvideo, they will release
> > > only at close().
> 
> That's not correct. Buffers are released when calling REQBUFS(0). However, the 
> file handle is still marked as owning the device for streaming purpose, so 
> other applications can't change the format or request buffers.

Why? After REQBUFS(0) any filehandle ownership should be dropped.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

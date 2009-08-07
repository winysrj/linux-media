Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1300 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025AbZHGLih (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2009 07:38:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH,RFC] Drop non-unlocked ioctl support in v4l2-dev.c
Date: Fri, 7 Aug 2009 13:37:57 +0200
Cc: linux-media@vger.kernel.org
References: <200908061709.41211.laurent.pinchart@ideasonboard.com> <eee1636b2ae21fc4189b27b511e7d22f.squirrel@webmail.xs4all.nl> <200908071303.23217.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200908071303.23217.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908071337.57675.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 07 August 2009 13:03:22 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Thursday 06 August 2009 17:16:08 Hans Verkuil wrote:
> > Hi Laurent,
> >
> > > Hi everybody,
> > >
> > > this patch moves the BKL one level down by removing the non-unlocked
> > > ioctl in v4l2-dev.c and calling lock_kernel/unlock_kernel in the
> > > unlocked_ioctl handler if the driver only supports locked ioctl.
> > >
> > > Opinions/comments/applause/kicks ?
> >
> > I've been thinking about this as well, and my idea was to properly
> > implement this by letting the v4l core serialize ioctls if the driver
> > doesn't do its own serialization (either through mutexes or lock_kernel).
> 
> A v4l-specific (or even device-specific) mutex would of course be better than 
> the BKL.
> 
> Are there file operations other than ioctl that are protected by the BKL ? 
> Blindly replacing the BKL by a mutex on ioctl would then introduce race 
> conditions.

I'd say that drivers that add sysfs or proc entries might be a problem, but
there are few drivers that do that and I suspect that quite a few have their
own locking.

Allowing the mutex to be accessed from elsewhere would be a simple solution
to this problem as all the sysfs/proc accesses can just attempt to get the
lock first, thus doing proper serializing.

> > The driver can just set a flag in video_device if it wants to do
> > serialization manually, otherwise the core will serialize using a mutex
> > and we should be able to completely remove the BKL from all v4l drivers.
> 
> Whether the driver fills v4l2_operations::ioctl or 
> v4l2_operations::unlocked_ioctl can be considered as such a flag :-)

Basically there are three situations:

1) unlocked_ioctl is set: in that case the driver takes care of all the
locking.

2) ioctl is set: in that case we keep the old BKL behavior.

3) unlocked_ioctl is set together with a serialize flag in struct v4l2_device:
in that case the v4l2 core will take care of most of the serialization for the
driver.

> Many drivers are currently using the BKL in an unlocked_ioctl handler. I'm not 
> sure it would be a good idea to move the BKL back to the v4l2 core, as the 
> long term goal is to remove it completely and use fine-grain driver-level 
> locking.

I agree with that. But I think the best approach to be able to remove the BKLs
is to provide a good alternative. Doing proper locking in a driver is quite
hard. Doing it in the v4l2 core is a lot easier to do right.

If the relevant file_operations are properly serialized, then that will simplify
drivers enormously. And it is also fairly easy to optimize certain ioctls:
e.g. the VIDIOC_QUERYCAP ioctl does not normally need a lock since it does
not access anything that needs to be protected. Intelligence like that can
be enabled on demand by setting a flag as well.

Basically I have no trust in device driver writers to do locking right, and
yes, that includes myself. It's hard to be sure that you covered all your
bases, especially for complicated drivers like most v4l drivers are.

Letting the core do most of the heavy lifting, even if you get somewhat
sub-optimal locking, is more than good enough in almost all cases.

And I expect that it is definitely more than good enough for drivers that
use the BKL.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

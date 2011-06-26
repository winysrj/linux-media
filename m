Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:62509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab1FZSUw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 14:20:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't exist
Date: Sun, 26 Jun 2011 20:20:20 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <4E0519B7.3000304@redhat.com> <201106261913.05752.arnd@arndb.de> <4E076CC6.2070408@redhat.com>
In-Reply-To: <4E076CC6.2070408@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106262020.20432.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 26 June 2011 19:30:46 Mauro Carvalho Chehab wrote:
> > There was a lot of debate whether undefined ioctls on non-ttys should
> > return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY to
> > -EINVAL at some point in the pre-git era, IIRC.
> > 
> > Inside of v4l2, I believe this is handled by video_usercopy(), which
> > turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you observe
> > where this is not done correctly and we do return ENOIOCTLCMD to
> > vfs_ioctl?
> 
> Well, currently, it is returning -EINVAL maybe due to the mass-conversions
> you've mentioned.

I mean what do you return *to* vfs_ioctl from v4l? The conversions must
have been long before we introduced compat_ioctl and ENOIOCTLCMD.

As far as I can tell, video_ioctl2 has always converted ENOIOCTLCMD into
EINVAL, so changing the vfs functions would not have any effect.

> The point is that -EINVAL has too many meanings at V4L. It currently can be
> either that an ioctl is not supported, or that one of the parameters had
> an invalid parameter. If the userspace can't distinguish between an unimplemented
> ioctl and an invalid parameter, it can't decide if it needs to fall back to
> some different methods of handling a V4L device.
> 
> Maybe the answer would be to return -ENOTTY when an ioctl is not implemented.

That is what a lot of subsystems do these days. But wouldn't that change
your ABI?

	Arnd

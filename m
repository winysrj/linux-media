Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab1FZSvz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2011 14:51:55 -0400
Message-ID: <4E077FB9.7030600@redhat.com>
Date: Sun, 26 Jun 2011 15:51:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't
 exist
References: <4E0519B7.3000304@redhat.com> <201106261913.05752.arnd@arndb.de> <4E076CC6.2070408@redhat.com> <201106262020.20432.arnd@arndb.de>
In-Reply-To: <201106262020.20432.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 26-06-2011 15:20, Arnd Bergmann escreveu:
> On Sunday 26 June 2011 19:30:46 Mauro Carvalho Chehab wrote:
>>> There was a lot of debate whether undefined ioctls on non-ttys should
>>> return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY to
>>> -EINVAL at some point in the pre-git era, IIRC.
>>>
>>> Inside of v4l2, I believe this is handled by video_usercopy(), which
>>> turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you observe
>>> where this is not done correctly and we do return ENOIOCTLCMD to
>>> vfs_ioctl?
>>
>> Well, currently, it is returning -EINVAL maybe due to the mass-conversions
>> you've mentioned.
> 
> I mean what do you return *to* vfs_ioctl from v4l? The conversions must
> have been long before we introduced compat_ioctl and ENOIOCTLCMD.
> 
> As far as I can tell, video_ioctl2 has always converted ENOIOCTLCMD into
> EINVAL, so changing the vfs functions would not have any effect.

Yes.  This discussion was originated by a RFC patch proposing to change 
video_ioctl2 to return -ENOIOCTLCMD instead of -EINVAL.

>> The point is that -EINVAL has too many meanings at V4L. It currently can be
>> either that an ioctl is not supported, or that one of the parameters had
>> an invalid parameter. If the userspace can't distinguish between an unimplemented
>> ioctl and an invalid parameter, it can't decide if it needs to fall back to
>> some different methods of handling a V4L device.
>>
>> Maybe the answer would be to return -ENOTTY when an ioctl is not implemented.
> 
> That is what a lot of subsystems do these days. But wouldn't that change
> your ABI?

Yes. The patch in question is also changing the DocBook spec for the ABI. We'll
likely need to drop some notes about that at the features-to-be-removed.txt.

I don't think that applications are relying at -EINVAL in order to detect if
an ioctl is not supported, but before merging such patch, we need to double-check.

Mauro.

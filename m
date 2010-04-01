Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3538 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab0DAOmH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 10:42:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: V4L-DVB drivers and BKL
Date: Thu, 1 Apr 2010 16:42:19 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <201004011001.10500.hverkuil@xs4all.nl> <201004011411.02344.laurent.pinchart@ideasonboard.com> <4BB4A9E2.9090706@redhat.com>
In-Reply-To: <4BB4A9E2.9090706@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011642.19889.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 April 2010 16:12:50 Mauro Carvalho Chehab wrote:
> Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Thursday 01 April 2010 13:11:51 Hans Verkuil wrote:
> >> On Thursday 01 April 2010 11:23:30 Laurent Pinchart wrote:
> >>> On Thursday 01 April 2010 10:01:10 Hans Verkuil wrote:
> >>>> Hi all,
> >>>>
> >>>> I just read on LWN that the core kernel guys are putting more effort
> >>>> into removing the BKL. We are still using it in our own drivers,
> >>>> mostly V4L.
> >>>>
> >>>> I added a BKL column to my driver list:
> >>>>
> >>>> http://www.linuxtv.org/wiki/index.php/V4L_framework_progress#Bridge_Dri
> >>>> vers
> >>>>
> >>>> If you 'own' one of these drivers that still use BKL, then it would be
> >>>> nice if you can try and remove the use of the BKL from those drivers.
> >>>>
> >>>> The other part that needs to be done is to move from using the .ioctl
> >>>> file op to using .unlocked_ioctl. Very few drivers do that, but I
> >>>> suspect almost no driver actually needs to use .ioctl.
> >>> What about something like this patch as a first step ?
> >> That doesn't fix anything. You just move the BKL from one place to another.
> >> I don't see any benefit from that.
> > 
> > Removing the BKL is a long-term project that basically pushes the BKL from 
> > core code to subsystems and drivers, and then replace it on a case by case 
> > basis. This patch (along with a replacement of lock_kernel/unlock_kernel by a 
> > V4L-specific lock) goes into that direction and removes the BKL usage from V4L 
> > ioctls. The V4L lock would then need to be pushed into individual drivers. 
> 
> True, but, as almost all V4L drivers share a "common ancestor", fixing the
> problems for one will also fix for the others.
> 
> One typical problem that I see is that some drivers register too soon: they
> first register, then initialize some things. I've seen (and fixed) some race 
> conditions due to that. Just moving the register to the end solves this issue.

Correct.

What to do if we have multiple device nodes? E.g. video0 and vbi0? Should we
allow access to video0 when vbi0 is not yet registered? Or should we block
access until all video nodes are registered?

> One (far from perfect) solution, would be to add a mutex protecting the entire
> ioctl loop inside the drivers, and the open/close methods. This can later be
> optimized by a mutex that will just protect the operations that can actually
> cause problems if happening in parallel.

I have thought about this in the past.

What I think would be needed to make locking much more reliable is the following:

1) Currently when a device is unregistered all read()s, write()s, poll()s, etc.
are blocked. Except for ioctl().

The comment in v4l2-dev.c says this:

        /* Allow ioctl to continue even if the device was unregistered.
           Things like dequeueing buffers might still be useful. */

I disagree with this. Once the device is gone (USB disconnect and similar
hotplug scenarios), then the only thing an application can do is to close.

Allowing ioctl to still work makes it hard for drivers since every ioctl
op that might do something with the device has to call video_is_registered()
to check whether the device is still alive.

I know, this is not directly related to the BKL, but it is an additional
complication.

2) Add a new video_device flag that turns on serialization. Basically all
calls are serialized with a mutex in v4l2_device. To handle blocking calls
like read() or VIDIOC_DQBUF we can either not take the serialization mutex
in the core, or instead the driver needs to unlock the mutex before it
waits for an event and lock it afterwards.

In the first case the core has to know all the exceptions.

Perhaps we should just add a second flag: whether the core should do full
serialization (and the driver will have to unlock/lock around blocking waits)
or smart serialization where know blocking operations are allowed unserialized.

I think it is fairly simple to add this serialization mechanism. And for many
drivers this will actually be more than enough.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

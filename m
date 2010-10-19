Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:53370 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0JSKqU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 06:46:20 -0400
Message-ID: <4CBD76F3.5060609@infradead.org>
Date: Tue, 19 Oct 2010 08:46:11 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] viafb camera controller driver
References: <20101010162313.5caa137f@bike.lwn.net> <20101018212017.7c53789e@bike.lwn.net> <201010190854.40419.hverkuil@xs4all.nl> <201010190952.46938.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201010190952.46938.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-10-2010 05:52, Laurent Pinchart escreveu:
> Hi Hans,
> 
> On Tuesday 19 October 2010 08:54:40 Hans Verkuil wrote:
>> On Tuesday, October 19, 2010 05:20:17 Jonathan Corbet wrote:
>>> On Sat, 16 Oct 2010 10:44:56 -0300 Mauro Carvalho Chehab wrote:
>>>> drivers/media/video/via-camera.c: In function ‘viacam_open’:
>>>> drivers/media/video/via-camera.c:651: error: too few arguments to
>>>> function ‘videobuf_queue_sg_init’
>>>>
>>>> The fix for this one is trivial:
>>>> drivers/media/video/via-camera.c:651: error: too few arguments to
>>>> function ‘videobuf_queue_sg_init’
>>>>
>>>> Just add an extra NULL parameter to the function.
>>>
>>> So I'm looking into this stuff.  The extra NULL parameter is a struct
>>>
>>> mutex, which seems to be used in one place in videobuf_waiton():
>>> 	is_ext_locked = q->ext_lock && mutex_is_locked(q->ext_lock);
>>> 	
>>> 	/* Release vdev lock to prevent this wait from blocking outside access
>>> 	to
>>> 	
>>> 	   the device. */
>>> 	
>>> 	if (is_ext_locked)
>>> 	
>>> 		mutex_unlock(q->ext_lock);
>>>
>>> I'd be most curious to know what the reasoning behind this code is; to my
>>> uneducated eye, it looks like a real hack.  How does this function know
>>> who locked ext_lock?  Can it really just unlock it safely?  It seems to
>>> me that this is a sign of locking issues which should really be dealt
>>> with elsewhere, but, as I said, I'm uneducated, and the changelogs don't
>>> help me much.  Can somebody educate me?
>>
>> We are working on removing the BKL. As part of that effort it is now
>> possible for drivers to pass a serialization mutex to the v4l core (a
>> mutex pointer was added to struct video_device). If the core sees that
>> mutex then the core will serialize all open/ioctl/read/write/etc. file
>> ops. So all file ops will in that case be called with that mutex held.
>> Which is fine, but if the driver has to do a blocking wait, then you need
>> to unlock the mutex first and lock it again afterwards. And since videobuf
>> does a blocking wait it needs to know about that mutex.
>>
>> Right now we are in the middle of the transition from BKL to using core
>> locks (and some drivers will do their own locking completely). During this
>> transition period we have drivers that provide an external lock and
>> drivers still relying on the BKL in which case videobuf needs to handle
>> its own locking. Hopefully in 1-2 kernel cycles we will have abolished the
>> BKL and we can remove the videobuf internal lock and use the external
>> mutex only.
>>
>> So yes, it is a bit of a hack but there is actually a plan behind it :-)
> 
> I still believe drivers should be encouraged to handle locking on their own. 
> These new "big v4l lock" (one per device) should be used only to remove the 
> BKL in existing drivers. It's a hack that we should work on getting rid of.

It is not a "big lock": it doesn't stop other CPU's, doesn't affect other hardware,
not even another V4L device. Basically, what this new lock does is to serialize access 
to the hardware and to the hardware-mirrored data. On several cases, if you serialize 
open, close, ioctl, read, write and mmap, the hardware will be serialized. 

Of course, this doesn't cover 100% of the cases where a lock is needed. So, if the
driver have more fun things like kthreads, alsa, dvb, IR polling, etc, the driver will
need to lock on other places as well.

A typical V4L driver has lots of functions that need locking: open, close, read, write,
mmap and almost all ioctl (depending on the driver, just a very few set of enum ioctl's
could eventually not need an ioctl). What we found is that:

	1) several developers didn't do the right thing since the beginning;
	2) as time goes by, locks got bit roted.
	3) some drivers were needing to touch on several locks (videobuf, their internal
priv locks, etc), sometimes generating cases where a dead lock would be possible.

On the tests we did so far, the v4l-core assisted lock helped to solve some locking issues 
on the very few drivers that were ported. Also, it caused a regression on a driver where
the lock were working ;)

There are basically several opinions about this new schema: some that think that this is the
right thing to do, others think that think that this is the wrong thing or that this is
acceptable only as a transition for BKL-free drivers.

IMO, I think that both ways are acceptable: a core-assisted "hardware-access lock" helps to
avoid having lots of lock/unlock code at the driver, making drivers cleaner and easier to review,
and reducing the risk of lock degradation with time. On the other hand, some drivers may require 
more complex locking schemas, like, for example, devices that support several simultaneous 
independent video streams may have some common parts used by all streams that need to be serialized,
and other parts that can (and should) not be serialized. So, a core-assisted locking 
for some cases may cause unneeded long waits.

Cheers,
Mauro

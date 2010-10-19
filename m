Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4664 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0JSOVd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 10:21:33 -0400
Message-ID: <06d3729171e6ddee40a8442083598050.squirrel@webmail.xs4all.nl>
In-Reply-To: <f0be7bac845617a2a3351fc6e7f78c65.squirrel@webmail.xs4all.nl>
References: <20101010162313.5caa137f@bike.lwn.net>
    <201010190952.46938.laurent.pinchart@ideasonboard.com>
    <4CBD76F3.5060609@infradead.org>
    <201010191505.04436.laurent.pinchart@ideasonboard.com>
    <f0be7bac845617a2a3351fc6e7f78c65.squirrel@webmail.xs4all.nl>
Date: Tue, 19 Oct 2010 16:21:27 +0200
Subject: Re: [PATCH] viafb camera controller driver
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Jonathan Corbet" <corbet@lwn.net>, linux-media@vger.kernel.org,
	"Florian Tobias Schandinat" <florianschandinat@gmx.de>,
	"Daniel Drake" <dsd@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> Hi Laurent,
>
>> Hi Mauro,
>>
>> On Tuesday 19 October 2010 12:46:11 Mauro Carvalho Chehab wrote:
>>> Em 19-10-2010 05:52, Laurent Pinchart escreveu:
>>> > On Tuesday 19 October 2010 08:54:40 Hans Verkuil wrote:
>>> >> On Tuesday, October 19, 2010 05:20:17 Jonathan Corbet wrote:
>>> >>> On Sat, 16 Oct 2010 10:44:56 -0300 Mauro Carvalho Chehab wrote:
>>> >>>> drivers/media/video/via-camera.c: In function ‘viacam_open’:
>>> >>>> drivers/media/video/via-camera.c:651: error: too few arguments to
>>> >>>> function ‘videobuf_queue_sg_init’
>>> >>>>
>>> >>>> The fix for this one is trivial:
>>> >>>> drivers/media/video/via-camera.c:651: error: too few arguments to
>>> >>>> function ‘videobuf_queue_sg_init’
>>> >>>>
>>> >>>> Just add an extra NULL parameter to the function.
>>> >>>
>>> >>> So I'm looking into this stuff.  The extra NULL parameter is a
>>> struct
>>> >>>
>>> >>> mutex, which seems to be used in one place in videobuf_waiton():
>>> >>> 	is_ext_locked = q->ext_lock && mutex_is_locked(q->ext_lock);
>>> >>>
>>> >>> 	/* Release vdev lock to prevent this wait from blocking outside
>>> access
>>> >>> 	to
>>> >>>
>>> >>> 	   the device. */
>>> >>>
>>> >>> 	if (is_ext_locked)
>>> >>>
>>> >>> 		mutex_unlock(q->ext_lock);
>>> >>>
>>> >>> I'd be most curious to know what the reasoning behind this code is;
>>> to
>>> >>> my uneducated eye, it looks like a real hack.  How does this
>>> function
>>> >>> know who locked ext_lock?  Can it really just unlock it safely?  It
>>> >>> seems to me that this is a sign of locking issues which should
>>> really
>>> >>> be dealt with elsewhere, but, as I said, I'm uneducated, and the
>>> >>> changelogs don't help me much.  Can somebody educate me?
>>> >>
>>> >> We are working on removing the BKL. As part of that effort it is now
>>> >> possible for drivers to pass a serialization mutex to the v4l core
>>> (a
>>> >> mutex pointer was added to struct video_device). If the core sees
>>> that
>>> >> mutex then the core will serialize all open/ioctl/read/write/etc.
>>> file
>>> >> ops. So all file ops will in that case be called with that mutex
>>> held.
>>> >> Which is fine, but if the driver has to do a blocking wait, then you
>>> >> need to unlock the mutex first and lock it again afterwards. And
>>> since
>>> >> videobuf does a blocking wait it needs to know about that mutex.
>>> >>
>>> >> Right now we are in the middle of the transition from BKL to using
>>> core
>>> >> locks (and some drivers will do their own locking completely).
>>> During
>>> >> this transition period we have drivers that provide an external lock
>>> >> and drivers still relying on the BKL in which case videobuf needs to
>>> >> handle its own locking. Hopefully in 1-2 kernel cycles we will have
>>> >> abolished the BKL and we can remove the videobuf internal lock and
>>> use
>>> >> the external mutex only.
>>> >>
>>> >> So yes, it is a bit of a hack but there is actually a plan behind it
>>> :-)
>>> >
>>> > I still believe drivers should be encouraged to handle locking on
>>> their
>>> > own. These new "big v4l lock" (one per device) should be used only to
>>> > remove the BKL in existing drivers. It's a hack that we should work
>>> on
>>> > getting rid of.
>>>
>>> It is not a "big lock": it doesn't stop other CPU's, doesn't affect
>>> other
>>> hardware, not even another V4L device. Basically, what this new lock
>>> does
>>> is to serialize access to the hardware and to the hardware-mirrored
>>> data.
>>
>> The lock serializes all ioctls. That's much more than protecting access
>> to
>> data (both in system memory and in the hardware).
>
> Absolutely correct. That's exactly what this lock does. Serializing all
> this makes it much easier to prove that a driver is correctly locking
> everything.
>
> For 90% of all our drivers this is all that is needed. Yes, it is at a
> coarser level than the theoretical optimum, but basically, who cares? For
> that 90% it is simply sufficient and without any performance penalties.
>
>>> On several cases, if you serialize open, close, ioctl, read, write and
>>> mmap, the hardware will be serialized.
>>>
>>> Of course, this doesn't cover 100% of the cases where a lock is needed.
>>> So,
>>> if the driver have more fun things like kthreads, alsa, dvb, IR
>>> polling,
>>> etc, the driver will need to lock on other places as well.
>>>
>>> A typical V4L driver has lots of functions that need locking: open,
>>> close,
>>> read, write, mmap and almost all ioctl (depending on the driver, just a
>>> very few set of enum ioctl's could eventually not need an ioctl). What
>>> we
>>> found is that:
>>>
>>> 	1) several developers didn't do the right thing since the beginning;
>>
>> That's not a valid reason to push new drivers for a very coarse grain
>> locking
>> scheme. Developers must not get told to be stupid and don't care about
>> locks
>> just because other developers got it wrong in the past. If people don't
>> get
>> locking right we need to educate them, not encourage them to understand
>> even
>> less of it.
>
> Locking is hard in complex drivers. Period.

Sorry, I hadn't finished this email. And of course I lost the rest of what
I wrote :-(

But basically I want to leave the choice of what to use to the driver
developer. If he wants to punish himself and do all the locking manually
(and prove that it is correct), then by all means, do so. If you want to
use the core locking support and so simplify your driver and allow your
brain to concentrate on getting the hardware to work, rather than trying
to get the locking right, then that's fine as well. As a code reviewer I'd
definitely prefer the latter approach as it makes my life much easier.

And I am not convinced that the argument that fine-grain locking improves
performance is valid. Definitely not for the 'normal' type of drivers.
Perhaps for complex SoCs it might be true, though. Although I'd love to
see some numbers first.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco


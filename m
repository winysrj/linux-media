Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:37507 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758542Ab0JSNEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 09:04:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] viafb camera controller driver
Date: Tue, 19 Oct 2010 15:05:03 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
References: <20101010162313.5caa137f@bike.lwn.net> <201010190952.46938.laurent.pinchart@ideasonboard.com> <4CBD76F3.5060609@infradead.org>
In-Reply-To: <4CBD76F3.5060609@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010191505.04436.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Tuesday 19 October 2010 12:46:11 Mauro Carvalho Chehab wrote:
> Em 19-10-2010 05:52, Laurent Pinchart escreveu:
> > On Tuesday 19 October 2010 08:54:40 Hans Verkuil wrote:
> >> On Tuesday, October 19, 2010 05:20:17 Jonathan Corbet wrote:
> >>> On Sat, 16 Oct 2010 10:44:56 -0300 Mauro Carvalho Chehab wrote:
> >>>> drivers/media/video/via-camera.c: In function ‘viacam_open’:
> >>>> drivers/media/video/via-camera.c:651: error: too few arguments to
> >>>> function ‘videobuf_queue_sg_init’
> >>>> 
> >>>> The fix for this one is trivial:
> >>>> drivers/media/video/via-camera.c:651: error: too few arguments to
> >>>> function ‘videobuf_queue_sg_init’
> >>>> 
> >>>> Just add an extra NULL parameter to the function.
> >>> 
> >>> So I'm looking into this stuff.  The extra NULL parameter is a struct
> >>> 
> >>> mutex, which seems to be used in one place in videobuf_waiton():
> >>> 	is_ext_locked = q->ext_lock && mutex_is_locked(q->ext_lock);
> >>> 	
> >>> 	/* Release vdev lock to prevent this wait from blocking outside access
> >>> 	to
> >>> 	
> >>> 	   the device. */
> >>> 	
> >>> 	if (is_ext_locked)
> >>> 	
> >>> 		mutex_unlock(q->ext_lock);
> >>> 
> >>> I'd be most curious to know what the reasoning behind this code is; to
> >>> my uneducated eye, it looks like a real hack.  How does this function
> >>> know who locked ext_lock?  Can it really just unlock it safely?  It
> >>> seems to me that this is a sign of locking issues which should really
> >>> be dealt with elsewhere, but, as I said, I'm uneducated, and the
> >>> changelogs don't help me much.  Can somebody educate me?
> >> 
> >> We are working on removing the BKL. As part of that effort it is now
> >> possible for drivers to pass a serialization mutex to the v4l core (a
> >> mutex pointer was added to struct video_device). If the core sees that
> >> mutex then the core will serialize all open/ioctl/read/write/etc. file
> >> ops. So all file ops will in that case be called with that mutex held.
> >> Which is fine, but if the driver has to do a blocking wait, then you
> >> need to unlock the mutex first and lock it again afterwards. And since
> >> videobuf does a blocking wait it needs to know about that mutex.
> >> 
> >> Right now we are in the middle of the transition from BKL to using core
> >> locks (and some drivers will do their own locking completely). During
> >> this transition period we have drivers that provide an external lock
> >> and drivers still relying on the BKL in which case videobuf needs to
> >> handle its own locking. Hopefully in 1-2 kernel cycles we will have
> >> abolished the BKL and we can remove the videobuf internal lock and use
> >> the external mutex only.
> >> 
> >> So yes, it is a bit of a hack but there is actually a plan behind it :-)
> > 
> > I still believe drivers should be encouraged to handle locking on their
> > own. These new "big v4l lock" (one per device) should be used only to
> > remove the BKL in existing drivers. It's a hack that we should work on
> > getting rid of.
> 
> It is not a "big lock": it doesn't stop other CPU's, doesn't affect other
> hardware, not even another V4L device. Basically, what this new lock does
> is to serialize access to the hardware and to the hardware-mirrored data.

The lock serializes all ioctls. That's much more than protecting access to 
data (both in system memory and in the hardware).

> On several cases, if you serialize open, close, ioctl, read, write and
> mmap, the hardware will be serialized.
> 
> Of course, this doesn't cover 100% of the cases where a lock is needed. So,
> if the driver have more fun things like kthreads, alsa, dvb, IR polling,
> etc, the driver will need to lock on other places as well.
> 
> A typical V4L driver has lots of functions that need locking: open, close,
> read, write, mmap and almost all ioctl (depending on the driver, just a
> very few set of enum ioctl's could eventually not need an ioctl). What we
> found is that:
> 
> 	1) several developers didn't do the right thing since the beginning;

That's not a valid reason to push new drivers for a very coarse grain locking 
scheme. Developers must not get told to be stupid and don't care about locks 
just because other developers got it wrong in the past. If people don't get 
locking right we need to educate them, not encourage them to understand even 
less of it.

> 	2) as time goes by, locks got bit roted.
> 	3) some drivers were needing to touch on several locks (videobuf, their
> internal priv locks, etc), sometimes generating cases where a dead lock
> would be possible.
> 
> On the tests we did so far, the v4l-core assisted lock helped to solve some
> locking issues on the very few drivers that were ported. Also, it caused a
> regression on a driver where the lock were working ;)
> 
> There are basically several opinions about this new schema: some that think
> that this is the right thing to do, others think that think that this is
> the wrong thing or that this is acceptable only as a transition for
> BKL-free drivers.

Indeed, and I belong to the second group.

> IMO, I think that both ways are acceptable: a core-assisted
> "hardware-access lock" helps to avoid having lots of lock/unlock code at
> the driver, making drivers cleaner and easier to review, and reducing the
> risk of lock degradation with time. On the other hand, some drivers may
> require more complex locking schemas, like, for example, devices that
> support several simultaneous independent video streams may have some
> common parts used by all streams that need to be serialized, and other
> parts that can (and should) not be serialized. So, a core-assisted locking
> for some cases may cause unneeded long waits.

A coarse core lock is acceptable in a transition phase to get rid of the BKL 
because we don't have the necessary resources to do it right and right now. 
Our goal should be to get rid of it in the long term as well (although we will 
probably never complete this task, as not all drivers have a wide users and 
developers base). New drivers must thus implement proper locking.

-- 
Regards,

Laurent Pinchart

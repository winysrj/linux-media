Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3429 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab0JSGy7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 02:54:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] viafb camera controller driver
Date: Tue, 19 Oct 2010 08:54:40 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Drake <dsd@laptop.org>
References: <20101010162313.5caa137f@bike.lwn.net> <4CB9AC58.5020301@infradead.org> <20101018212017.7c53789e@bike.lwn.net>
In-Reply-To: <20101018212017.7c53789e@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010190854.40419.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, October 19, 2010 05:20:17 Jonathan Corbet wrote:
> On Sat, 16 Oct 2010 10:44:56 -0300
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > drivers/media/video/via-camera.c: In function ‘viacam_open’:
> > drivers/media/video/via-camera.c:651: error: too few arguments to function ‘videobuf_queue_sg_init’
> 
> > The fix for this one is trivial:
> > drivers/media/video/via-camera.c:651: error: too few arguments to function ‘videobuf_queue_sg_init’
> > 
> > Just add an extra NULL parameter to the function.
> 
> So I'm looking into this stuff.  The extra NULL parameter is a struct
> mutex, which seems to be used in one place in videobuf_waiton():
> 
> 	is_ext_locked = q->ext_lock && mutex_is_locked(q->ext_lock);
> 
> 	/* Release vdev lock to prevent this wait from blocking outside access to
> 	   the device. */
> 	if (is_ext_locked)
> 		mutex_unlock(q->ext_lock);
> 
> I'd be most curious to know what the reasoning behind this code is; to my
> uneducated eye, it looks like a real hack.  How does this function know who
> locked ext_lock?  Can it really just unlock it safely?  It seems to me that
> this is a sign of locking issues which should really be dealt with
> elsewhere, but, as I said, I'm uneducated, and the changelogs don't help me
> much.  Can somebody educate me?

We are working on removing the BKL. As part of that effort it is now possible
for drivers to pass a serialization mutex to the v4l core (a mutex pointer was
added to struct video_device). If the core sees that mutex then the core will
serialize all open/ioctl/read/write/etc. file ops. So all file ops will in that
case be called with that mutex held. Which is fine, but if the driver has to do
a blocking wait, then you need to unlock the mutex first and lock it again
afterwards. And since videobuf does a blocking wait it needs to know about that
mutex.

Right now we are in the middle of the transition from BKL to using core locks
(and some drivers will do their own locking completely). During this transition
period we have drivers that provide an external lock and drivers still relying
on the BKL in which case videobuf needs to handle its own locking. Hopefully
in 1-2 kernel cycles we will have abolished the BKL and we can remove the
videobuf internal lock and use the external mutex only.

So yes, it is a bit of a hack but there is actually a plan behind it :-)

It's a common theme inside the v4l subsystem, I'm afraid. We are still in the
process of creating a fully functional v4l core framework that all drivers
can use. But for every new piece of core functionality it means a transition
period where drivers are one by one converted to use it. That can take a very
long time. Add to that mix all the new functionality that is being added to
support embedded video hardware and it can get complex indeed.

I have a very clear goal in mind, though, and I (and many others!) are steadily
moving closer to that goal. Every kernel release has one or more essential
building blocks in place.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco

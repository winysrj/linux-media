Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:34487 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab0JSHwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Oct 2010 03:52:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] viafb camera controller driver
Date: Tue, 19 Oct 2010 09:52:46 +0200
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
References: <20101010162313.5caa137f@bike.lwn.net> <20101018212017.7c53789e@bike.lwn.net> <201010190854.40419.hverkuil@xs4all.nl>
In-Reply-To: <201010190854.40419.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010190952.46938.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Tuesday 19 October 2010 08:54:40 Hans Verkuil wrote:
> On Tuesday, October 19, 2010 05:20:17 Jonathan Corbet wrote:
> > On Sat, 16 Oct 2010 10:44:56 -0300 Mauro Carvalho Chehab wrote:
> > > drivers/media/video/via-camera.c: In function ‘viacam_open’:
> > > drivers/media/video/via-camera.c:651: error: too few arguments to
> > > function ‘videobuf_queue_sg_init’
> > > 
> > > The fix for this one is trivial:
> > > drivers/media/video/via-camera.c:651: error: too few arguments to
> > > function ‘videobuf_queue_sg_init’
> > > 
> > > Just add an extra NULL parameter to the function.
> > 
> > So I'm looking into this stuff.  The extra NULL parameter is a struct
> > 
> > mutex, which seems to be used in one place in videobuf_waiton():
> > 	is_ext_locked = q->ext_lock && mutex_is_locked(q->ext_lock);
> > 	
> > 	/* Release vdev lock to prevent this wait from blocking outside access
> > 	to
> > 	
> > 	   the device. */
> > 	
> > 	if (is_ext_locked)
> > 	
> > 		mutex_unlock(q->ext_lock);
> > 
> > I'd be most curious to know what the reasoning behind this code is; to my
> > uneducated eye, it looks like a real hack.  How does this function know
> > who locked ext_lock?  Can it really just unlock it safely?  It seems to
> > me that this is a sign of locking issues which should really be dealt
> > with elsewhere, but, as I said, I'm uneducated, and the changelogs don't
> > help me much.  Can somebody educate me?
> 
> We are working on removing the BKL. As part of that effort it is now
> possible for drivers to pass a serialization mutex to the v4l core (a
> mutex pointer was added to struct video_device). If the core sees that
> mutex then the core will serialize all open/ioctl/read/write/etc. file
> ops. So all file ops will in that case be called with that mutex held.
> Which is fine, but if the driver has to do a blocking wait, then you need
> to unlock the mutex first and lock it again afterwards. And since videobuf
> does a blocking wait it needs to know about that mutex.
> 
> Right now we are in the middle of the transition from BKL to using core
> locks (and some drivers will do their own locking completely). During this
> transition period we have drivers that provide an external lock and
> drivers still relying on the BKL in which case videobuf needs to handle
> its own locking. Hopefully in 1-2 kernel cycles we will have abolished the
> BKL and we can remove the videobuf internal lock and use the external
> mutex only.
> 
> So yes, it is a bit of a hack but there is actually a plan behind it :-)

I still believe drivers should be encouraged to handle locking on their own. 
These new "big v4l lock" (one per device) should be used only to remove the 
BKL in existing drivers. It's a hack that we should work on getting rid of.

> It's a common theme inside the v4l subsystem, I'm afraid. We are still in
> the process of creating a fully functional v4l core framework that all
> drivers can use. But for every new piece of core functionality it means a
> transition period where drivers are one by one converted to use it. That
> can take a very long time. Add to that mix all the new functionality that
> is being added to support embedded video hardware and it can get complex
> indeed.
> 
> I have a very clear goal in mind, though, and I (and many others!) are
> steadily moving closer to that goal. Every kernel release has one or more
> essential building blocks in place.

-- 
Regards,

Laurent Pinchart

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3941 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0DAP07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 11:26:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: V4L-DVB drivers and BKL
Date: Thu, 1 Apr 2010 17:27:04 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <201004011001.10500.hverkuil@xs4all.nl> <201004011642.19889.hverkuil@xs4all.nl> <4BB4B569.3080608@redhat.com>
In-Reply-To: <4BB4B569.3080608@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004011727.04345.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 April 2010 17:02:01 Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
> 
> > What to do if we have multiple device nodes? E.g. video0 and vbi0? Should we
> > allow access to video0 when vbi0 is not yet registered? Or should we block
> > access until all video nodes are registered?
> 
> It will depend on the driver implementation, but, as new udev implementations
> try to open v4l devices asap,

Yes, that is very annoying when you also have to do firmware uploads. The ivtv
driver does that on the first open, but that doesn't help anymore when hal opens
it automatically.

> the better is to lock the register operation
> to avoid an open while not finished.
> 
> I remember I had to do it on em28xx:
> 
> This is the init code for it:
> 	...
>         mutex_init(&dev->lock);
>         mutex_lock(&dev->lock);
>         em28xx_init_dev(&dev, udev, interface, nr);
> 	...
>         request_modules(dev);
> 
>         /* Should be the last thing to do, to avoid newer udev's to
>            open the device before fully initializing it
>          */
>         mutex_unlock(&dev->lock);
> 	...
> 
> And this is the open code:
> 
> static int em28xx_v4l2_open(struct file *filp)
> {
> 	...
>         mutex_lock(&dev->lock);
> 	...
> 	mutex_unlock(&dev->lock);
> 
> 
> The same lock is also used at the ioctl handlers that need to be protected, like:
> 
> static int radio_g_tuner(struct file *file, void *priv,
>                          struct v4l2_tuner *t)
> {
> 	...
>         mutex_lock(&dev->lock);
>         v4l2_device_call_all(&dev->v4l2_dev, 0, tuner, g_tuner, t);
>         mutex_unlock(&dev->lock);
> 	...
> }
> 
> There are some obvious cases where no lock is needed, like for example
> vidioc_querycap.
> 
> 
> > 
> >> One (far from perfect) solution, would be to add a mutex protecting the entire
> >> ioctl loop inside the drivers, and the open/close methods. This can later be
> >> optimized by a mutex that will just protect the operations that can actually
> >> cause problems if happening in parallel.
> > 
> > I have thought about this in the past.
> > 
> > What I think would be needed to make locking much more reliable is the following:
> > 
> > 1) Currently when a device is unregistered all read()s, write()s, poll()s, etc.
> > are blocked. Except for ioctl().
> > 
> > The comment in v4l2-dev.c says this:
> > 
> >         /* Allow ioctl to continue even if the device was unregistered.
> >            Things like dequeueing buffers might still be useful. */
> > 
> > I disagree with this. Once the device is gone (USB disconnect and similar
> > hotplug scenarios), then the only thing an application can do is to close.
> > 
> > Allowing ioctl to still work makes it hard for drivers since every ioctl
> > op that might do something with the device has to call video_is_registered()
> > to check whether the device is still alive.
> > 
> > I know, this is not directly related to the BKL, but it is an additional
> > complication.
> 
> Depending on how the video buffers are implemented, you may need to run dequeue,
> in order to allow freeing the mmaped memories. That's said, maybe we could use
> a kref implementation for those kind or resources.

What should be the correct sequence in an application when the device it is
capturing from is suddenly unplugged?

I guess it is a STREAMOFF followed by a REQBUFS with a count of 0. At least
according to the spec (videobuf doesn't accept a count of 0 at the moment).

So those two ioctls would need to be allowed through.

> 
> > 2) Add a new video_device flag that turns on serialization. Basically all
> > calls are serialized with a mutex in v4l2_device. To handle blocking calls
> > like read() or VIDIOC_DQBUF we can either not take the serialization mutex
> > in the core, or instead the driver needs to unlock the mutex before it
> > waits for an event and lock it afterwards.
> > 
> > In the first case the core has to know all the exceptions.
> > 
> > Perhaps we should just add a second flag: whether the core should do full
> > serialization (and the driver will have to unlock/lock around blocking waits)
> > or smart serialization where know blocking operations are allowed unserialized.
> > 
> > I think it is fairly simple to add this serialization mechanism. And for many
> > drivers this will actually be more than enough.
> 
> I remember I proposed a solution to implement the mutex at V4L core level,
> when we had this discussion with Alan Cox BKL patches. 
> 
> The conclusion I had from the discussion is that, while this is a simple way, 
> it may end that a poorly implemented lock would stay there forever.
> 
> Also, core has no way to foresee what the driver is doing on their side, and may
> miss some cases where the lock needs to be used.
> 
> I don't think that adding flags would help to improve it.

Why not? Seriously, most drivers only need a simple serialization flag.
Adding this feature in the core by just setting a V4L2_FL_SERIALIZE flag
is easy to do and it is very simple to implement and review. Given the fact
that a lot of drivers (esp. older ones) have very poor locking schemes I am
very much in favor of having basic serialization support in the v4l core.

I'll see if I can make a patch for this to help this discussion.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:3082 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0DAU4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Apr 2010 16:56:52 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] Serialization flag example
Date: Thu, 1 Apr 2010 22:57:08 +0200
Cc: linux-media@vger.kernel.org
References: <201004011937.39331.hverkuil@xs4all.nl> <4BB4E4CC.3020100@redhat.com>
In-Reply-To: <4BB4E4CC.3020100@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004012257.08684.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 April 2010 20:24:12 Mauro Carvalho Chehab wrote:
> Hans,
> 
> 
> Hans Verkuil wrote:
> > I made a quick implementation which is available here:
> > 
> > http://www.linuxtv.org/hg/~hverkuil/v4l-dvb-serialize
> > 
> > It's pretty easy to use and it also gives you a very simple way to block
> > access to the video device nodes until all have been allocated by simply
> > taking the serialization lock and holding it until we are done with the
> > initialization.
> > 
> > I converted radio-mr800.c and ivtv.
> > 
> > That said, almost all drivers that register multiple device nodes probably
> > suffer from a race condition when one of the device node registrations
> > returns an error and all devices have to be unregistered and the driver
> > needs to release all resources.
> > 
> > Currently most if not all drivers just release resources and free the memory.
> > But if an application managed to open one device before the driver removes it
> > again, then we have almost certainly a crash.
> > 
> > It is possible to do this correctly in the driver, but it really needs core
> > support where a release callback can be installed in v4l2_device that is
> > called when the last video_device is closed by the application.
> > 
> > We already can cleanup correctly after the last close of a video_device, but
> > there is no top-level release yet.
> > 
> > 
> > Anyway, I tried to use the serialization flag in bttv as well, but I ran into
> > problems with videobuf. Basically when you need to wait for some event you
> > should release the serialization lock and grab it after the event arrives.
> > 
> > Unfortunately videobuf has no access to v4l2_device at the moment. If we would
> > have that, then videobuf can just release the serialization lock while waiting
> > for something to happen.
> 
> 
> While this code works like a charm with the radio devices, it probably
> won't work fine with complex devices.

Nor was it meant to. Although ivtv is a pretty complex device and it works fine
there. But yes, when you also have alsa, dvb or other parts then you will have to
think more carefully and possibly abandon the core serialization altogether.

However, of the almost 80 drivers we have it is my conservative estimate that about
75% of those fall in the 'simple' device category, at least when it comes to locking.
I would like to see a simple, but good, locking scheme for those 60 drivers. And the
remaining 20 can take care of their own locking.

> You'll have issues also with -alsa and -dvb parts that are present on the drivers.
> 
> Also, drivers like cx88 have another PCI device for mpeg-encoded streams. It behaves
> like two separate drivers (each with its own bind code at V4L core), but, as there's
> just one PCI bridge, and just one analog video decoder/analog audio decoder, the lock
> should cross between the different drivers.
> 
> So, binding videobuf to v4l2_device won't solve the issue with most videobuf-aware drivers,
> nor the lock will work as expected, at least with most of the devices.

As I said, you have to enable this serialization explicitly. And obviously you shouldn't
enable it mindlessly.
 
> Also, although this is not a real problem, your lock is too pedantic: it is 
> blocking access to several ioctl's that don't need to be locked. For example, there are
> several ioctl's that just returns static: information: capabilities, supported video standards,
> etc. There are even some cases where dynamic ioctl's are welcome, like accepting QBUF/DQBUF
> without locking (or with a minimum lock), to allow different threads to handle the buffers.

Which is why videobuf should be aware of such a global lock so that it can release it
when it has to wait.
 
> The big issue I see with this approach is that developers will become lazy on checking
> the locks inside the drivers: they'll just apply the flag and trust that all of their
> locking troubles were magically solved by the core. 

Well, for simple drivers (i.e. the vast majority) that is indeed the case.
Locking is hard. If this can be moved into the core for most drivers, then that is
good. I like it if developers can be lazy. Less chance of bugs.

And mind that this is exactly the situation we have now with ioctl and the BKL!

> Maybe a better alternative would be to pass to the V4L2 core, optionally, some lock,
> used internally on the driver. This approach will still be pedantic, as all ioctls will
> keep being serialized, but at least the driver will need to explicitly handle the lock,
> and the same lock can be used on other parts of the driver.

Well, I guess you could add a 'struct mutex *serialize;' field to v4l2_device
that drivers can set. But I don't see much of a difference in practice.

Regarding the 'pedantic approach': we can easily move the locking to video_ioctl2:

	struct video_device *vdev = video_devdata(file);
	int serialize = must_serialize_ioctl(vdev, cmd);

	if (serialize)
		mutex_lock(&vdev->v4l2_dev->serialize_lock);
        /* Handles IOCTL */
        err = __video_do_ioctl(file, cmd, parg);
	if (serialize)
		mutex_unlock(&vdev->v4l2_dev->serialize_lock);


And must_serialize_ioctl() looks like this:

static int must_serialize_ioctl(struct video_device *vdev, int cmd)
{
	if (!vdev->v4l2_dev || !vdev->v4l2_dev->fl_serialize)
		return 0;
	switch (cmd) {
	case VIDIOC_QUERYCAP:
	case VIDIOC_ENUM_FMT:
	...
		return 0;
	}
	return 1;
}

Basically the CAP (capability) ioctls and all ENUM ioctls do not have to be
serialized. I am not sure whether the streaming ioctls should also be included
here. I can't really grasp the consequences of whatever choice we make. If we
want to be compatible with what happens today with ioctl and the BKL, then we
need to lock and have videobuf unlock whenever it has to wait for an event.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

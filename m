Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3476 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0DBI5b (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Apr 2010 04:57:31 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC] Serialization flag example
Date: Fri, 2 Apr 2010 10:57:41 +0200
Cc: linux-media@vger.kernel.org
References: <201004011937.39331.hverkuil@xs4all.nl> <201004012257.08684.hverkuil@xs4all.nl> <4BB510F1.7090504@redhat.com>
In-Reply-To: <4BB510F1.7090504@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004021057.42044.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 01 April 2010 23:32:33 Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
> >> Maybe a better alternative would be to pass to the V4L2 core, optionally, some lock,
> >> used internally on the driver. This approach will still be pedantic, as all ioctls will
> >> keep being serialized, but at least the driver will need to explicitly handle the lock,
> >> and the same lock can be used on other parts of the driver.
> > 
> > Well, I guess you could add a 'struct mutex *serialize;' field to v4l2_device
> > that drivers can set. But I don't see much of a difference in practice.
> 
> It makes easier to implement more complex approaches, where you may need to use more
> locks. Also, It makes no sense to make a DVB code or an alsa code dependent on a V4L
> header, just because it needs to see a mutex.

What's in a name. v4l2_device is meant to be a top-level object in a driver.
There is nothing particularly v4l about it and it would be trivial to rename
it to media_device.

> Also, a mutex at the driver need to be initialized inside the driver. It is not just one
> flag that someone writing a new driver will clone without really understanding what
> it is doing.

Having a driver do mutex_init() really does not improve understanding. But
good documentation will. Creating a simple, easy to understand and well
documented locking scheme will go a long way to making our drivers better.

Now, having said all this, I do think upon reflection that using a pointer
to a mutex might be better. The main reason being that while I do think that
renaming v4l2_device to media_device is a good idea and that more code sharing
between v4l and dvb would benefit both (heck, perhaps there should be more
integration between v4l-dvb and alsa as well), the political reality is
different.

> 
> > Regarding the 'pedantic approach': we can easily move the locking to video_ioctl2:
> > 
> > 	struct video_device *vdev = video_devdata(file);
> > 	int serialize = must_serialize_ioctl(vdev, cmd);
> > 
> > 	if (serialize)
> > 		mutex_lock(&vdev->v4l2_dev->serialize_lock);
> >         /* Handles IOCTL */
> >         err = __video_do_ioctl(file, cmd, parg);
> > 	if (serialize)
> > 		mutex_unlock(&vdev->v4l2_dev->serialize_lock);
> > 
> > 
> > And must_serialize_ioctl() looks like this:
> > 
> > static int must_serialize_ioctl(struct video_device *vdev, int cmd)
> > {
> > 	if (!vdev->v4l2_dev || !vdev->v4l2_dev->fl_serialize)
> > 		return 0;
> > 	switch (cmd) {
> > 	case VIDIOC_QUERYCAP:
> > 	case VIDIOC_ENUM_FMT:
> > 	...
> > 		return 0;
> > 	}
> > 	return 1;
> > }
> > 
> > Basically the CAP (capability) ioctls and all ENUM ioctls do not have to be
> > serialized. I am not sure whether the streaming ioctls should also be included
> > here. I can't really grasp the consequences of whatever choice we make. If we
> > want to be compatible with what happens today with ioctl and the BKL, then we
> > need to lock and have videobuf unlock whenever it has to wait for an event.
> 
> I suspect that the list of "must have" is driver-dependent.

If needed one could allow drivers to override this function. But again, start
simple and only make it more complex if we really need to. Overengineering is
one of the worst mistakes one can make. I have seen too many projects fail
because of that.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

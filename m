Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0DAVci (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 17:32:38 -0400
Message-ID: <4BB510F1.7090504@redhat.com>
Date: Thu, 01 Apr 2010 18:32:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC] Serialization flag example
References: <201004011937.39331.hverkuil@xs4all.nl> <4BB4E4CC.3020100@redhat.com> <201004012257.08684.hverkuil@xs4all.nl>
In-Reply-To: <201004012257.08684.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> Maybe a better alternative would be to pass to the V4L2 core, optionally, some lock,
>> used internally on the driver. This approach will still be pedantic, as all ioctls will
>> keep being serialized, but at least the driver will need to explicitly handle the lock,
>> and the same lock can be used on other parts of the driver.
> 
> Well, I guess you could add a 'struct mutex *serialize;' field to v4l2_device
> that drivers can set. But I don't see much of a difference in practice.

It makes easier to implement more complex approaches, where you may need to use more
locks. Also, It makes no sense to make a DVB code or an alsa code dependent on a V4L
header, just because it needs to see a mutex.

Also, a mutex at the driver need to be initialized inside the driver. It is not just one
flag that someone writing a new driver will clone without really understanding what
it is doing.

> Regarding the 'pedantic approach': we can easily move the locking to video_ioctl2:
> 
> 	struct video_device *vdev = video_devdata(file);
> 	int serialize = must_serialize_ioctl(vdev, cmd);
> 
> 	if (serialize)
> 		mutex_lock(&vdev->v4l2_dev->serialize_lock);
>         /* Handles IOCTL */
>         err = __video_do_ioctl(file, cmd, parg);
> 	if (serialize)
> 		mutex_unlock(&vdev->v4l2_dev->serialize_lock);
> 
> 
> And must_serialize_ioctl() looks like this:
> 
> static int must_serialize_ioctl(struct video_device *vdev, int cmd)
> {
> 	if (!vdev->v4l2_dev || !vdev->v4l2_dev->fl_serialize)
> 		return 0;
> 	switch (cmd) {
> 	case VIDIOC_QUERYCAP:
> 	case VIDIOC_ENUM_FMT:
> 	...
> 		return 0;
> 	}
> 	return 1;
> }
> 
> Basically the CAP (capability) ioctls and all ENUM ioctls do not have to be
> serialized. I am not sure whether the streaming ioctls should also be included
> here. I can't really grasp the consequences of whatever choice we make. If we
> want to be compatible with what happens today with ioctl and the BKL, then we
> need to lock and have videobuf unlock whenever it has to wait for an event.

I suspect that the list of "must have" is driver-dependent.

-- 

Cheers,
Mauro

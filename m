Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48288 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752512AbdLLPYg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 10:24:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?ISO-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/2] v4l: v4l2-dev: Add infrastructure to protect device unplug race
Date: Tue, 12 Dec 2017 17:24:38 +0200
Message-ID: <3538140.JCjd6C33Oj@avalon>
In-Reply-To: <20171123142101.GA5155@kroah.com>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com> <20171123110751.72f76d7d@vento.lan> <20171123142101.GA5155@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg and Mauro,

On Thursday, 23 November 2017 16:21:01 EET Greg Kroah-Hartman wrote:
> On Thu, Nov 23, 2017 at 11:07:51AM -0200, Mauro Carvalho Chehab wrote:
> > Em Thu, 16 Nov 2017 02:33:48 +0200 Laurent Pinchart escreveu:
> >> Device unplug being asynchronous, it naturally races with operations
> >> performed by userspace through ioctls or other file operations on video
> >> device nodes.
> >> 
> >> This leads to potential access to freed memory or to other resources
> >> during device access if unplug occurs during device access. To solve
> >> this, we need to wait until all device access completes when unplugging
> >> the device, and block all further access when the device is being
> >> unplugged.
> >> 
> >> Three new functions are introduced. The video_device_enter() and
> >> video_device_exit() functions must be used to mark entry and exit from
> >> all code sections where the device can be accessed. The
> >> video_device_unplug() function is then used in the unplug handler to
> >> mark the device as being unplugged and wait for all access to complete.
> >> 
> >> As an example mark the ioctl handler as a device access section. Other
> >> file operations need to be protected too, and blocking ioctls (such as
> >> VIDIOC_DQBUF) need to be handled as well.
> >> 
> >> Signed-off-by: Laurent Pinchart
> >> <laurent.pinchart+renesas@ideasonboard.com>
> >> ---
> >> 
> >>  drivers/media/v4l2-core/v4l2-dev.c | 57 ++++++++++++++++++++++++++++++++
> >>  include/media/v4l2-dev.h           | 47 +++++++++++++++++++++++++++++++
> >>  2 files changed, 104 insertions(+)
> >> 
> >> diff --git a/drivers/media/v4l2-core/v4l2-dev.c
> >> b/drivers/media/v4l2-core/v4l2-dev.c index c647ba648805..c73c6d49e7cf
> >> 100644
> >> --- a/drivers/media/v4l2-core/v4l2-dev.c
> >> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> >> @@ -156,6 +156,52 @@ void video_device_release_empty(struct video_device
> >> *vdev)
> >>  }
> >>  EXPORT_SYMBOL(video_device_release_empty);
> >> 
> >> +int video_device_enter(struct video_device *vdev)
> >> +{
> >> +	bool unplugged;
> >> +
> >> +	spin_lock(&vdev->unplug_lock);
> >> +	unplugged = vdev->unplugged;
> >> +	if (!unplugged)
> >> +		vdev->access_refcount++;
> >> +	spin_unlock(&vdev->unplug_lock);
> >> +
> >> +	return unplugged ? -ENODEV : 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(video_device_enter);
> >> +
> >> +void video_device_exit(struct video_device *vdev)
> >> +{
> >> +	bool wake_up;
> >> +
> >> +	spin_lock(&vdev->unplug_lock);
> >> +	WARN_ON(--vdev->access_refcount < 0);
> >> +	wake_up = vdev->access_refcount == 0;
> >> +	spin_unlock(&vdev->unplug_lock);
> >> +
> >> +	if (wake_up)
> >> +		wake_up(&vdev->unplug_wait);
> >> +}
> >> +EXPORT_SYMBOL_GPL(video_device_exit);
> >> +
> >> +void video_device_unplug(struct video_device *vdev)
> >> +{
> >> +	bool unplug_blocked;
> >> +
> >> +	spin_lock(&vdev->unplug_lock);
> >> +	unplug_blocked = vdev->access_refcount > 0;
> >> +	vdev->unplugged = true;
> >> +	spin_unlock(&vdev->unplug_lock);
> >> +
> >> +	if (!unplug_blocked)
> >> +		return;
> >> +
> >> +	if (!wait_event_timeout(vdev->unplug_wait, !vdev->access_refcount,
> >> +				msecs_to_jiffies(150000)))
> >> +		WARN(1, "Timeout waiting for device access to complete\n");
> >> +}
> >> +EXPORT_SYMBOL_GPL(video_device_unplug);
> >> +
> >>  static inline void video_get(struct video_device *vdev)
> >>  {
> >>  	get_device(&vdev->dev);
> >> @@ -351,6 +397,10 @@ static long v4l2_ioctl(struct file *filp, unsigned
> >> int cmd, unsigned long arg)
> >>  	struct video_device *vdev = video_devdata(filp);
> >>  	int ret = -ENODEV;
> >> 
> >> +	ret = video_device_enter(vdev);
> >> +	if (ret < 0)
> >> +		return ret;
> >> +
> >>  	if (vdev->fops->unlocked_ioctl) {
> >>  		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
> >> 
> >> @@ -358,11 +408,14 @@ static long v4l2_ioctl(struct file *filp, unsigned
> >> int cmd, unsigned long arg)
> >>  			return -ERESTARTSYS;
> >>  		if (video_is_registered(vdev))
> >>  			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> >> +		else
> >> +			ret = -ENODEV;
> >>  		if (lock)
> >>  			mutex_unlock(lock);
> >>  	} else
> >>  		ret = -ENOTTY;
> >> 
> >> +	video_device_exit(vdev);
> >>  	return ret;
> >>  }
> >> 
> >> @@ -841,6 +894,10 @@ int __video_register_device(struct video_device
> >> *vdev, int type, int nr,
> >>  	if (WARN_ON(!vdev->v4l2_dev))
> >>  		return -EINVAL;
> >> 
> >> +	/* unplug support */
> >> +	spin_lock_init(&vdev->unplug_lock);
> >> +	init_waitqueue_head(&vdev->unplug_wait);
> >> +
> > 
> > I'm c/c Greg here, as I don't think, that, the way it is, it
> > belongs at V4L2 core.
> > 
> > I mean: if this is a problem that affects all drivers, it would should,
> > instead, be sitting at the driver's core.
> 
> What "problem" is trying to be solved here?  One where your specific
> device type races with your specific user api?  Doesn't sound very
> driver-core specific to me :)
> 
> As an example, what other bus/device type needs this?  If you can see
> others that do, then sure, move it into the core.  But for just one, I
> don't know if that's really needed here, do you?

This patch attempts to fix the race between a device being unbound from its 
driver (through sysfs or device unplug) and the driver accessing the device 
resources (either directly, for instance using MMIO for platform devices, or 
indirectly through bus-specific APIs, for instance for USB or I2C).

Drivers are not allowed to access device resources after the device is unbound 
from the driver. This is a requirement set by the device core, and on which 
the devres API relies. For instance an attempt to perform MMIO after unbind 
will oops as the MMIO memory mapped by devm_ioremap* will have been unmapped.

Some bus types already protect against such races, at least partially. The USB 
core, for instance, returns an error from usb_submit_urb() is the USB device 
associated with the URB has been disconnected. However, even there the API 
seems to be subject to race conditions as locking appears to be missing. Other 
bus types don't attempt to offer any protection (such as I2C), or simply can't 
when resources are accessed directly (such as platform devices).

I can see two ways to fix this issue. One of them is to protect individual 
device accesses. For USB or I2C devices, that would mean protecting every API 
call that can access the device against disconnection. For platform devices, 
that would mean wrapping MMIO access with functions offering similar 
protection. I don't think this is viable as it would introduce performance 
issues.

The other option is to protect device access in the entry points. For 
character devices, the entry points are the file operations. This is the 
approach I have selected for this patch series.

This series implements the protection for V4L2 ioctls in the v4l2_ioctl() 
entry point. It needs to be extended to other file operations, which I will do 
in the next version. However, the race condition is in no way specific to V4L2 
but is common to all devices that expose a character device to userspace. We 
could fix it in V4L2, and separately in DRM (https://lists.freedesktop.org/
archives/dri-devel/2017-September/152115.html), and separately in every 
subsystem, with a slightly different method each time, but that raises the 
question of whether a common implementation at the driver core (for the unbind 
part) and cdev (for the access part) wouldn't be better.

-- 
Regards,

Laurent Pinchart

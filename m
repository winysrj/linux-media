Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:53370 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751547AbdLLMjn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 07:39:43 -0500
Date: Tue, 12 Dec 2017 10:39:32 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/2] v4l: v4l2-dev: Add infrastructure to protect
 device unplug race
Message-ID: <20171212103932.73c542ce@vento.lan>
In-Reply-To: <20171123142101.GA5155@kroah.com>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com>
        <20171116003349.19235-2-laurent.pinchart+renesas@ideasonboard.com>
        <20171123110751.72f76d7d@vento.lan>
        <20171123142101.GA5155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 23 Nov 2017 15:21:01 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> escreveu:

> On Thu, Nov 23, 2017 at 11:07:51AM -0200, Mauro Carvalho Chehab wrote:
> > Hi Laurent,
> > 
> > Em Thu, 16 Nov 2017 02:33:48 +0200
> > Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com> escreveu:
> >   
> > > Device unplug being asynchronous, it naturally races with operations
> > > performed by userspace through ioctls or other file operations on video
> > > device nodes.
> > > 
> > > This leads to potential access to freed memory or to other resources
> > > during device access if unplug occurs during device access. To solve
> > > this, we need to wait until all device access completes when unplugging
> > > the device, and block all further access when the device is being
> > > unplugged.
> > > 
> > > Three new functions are introduced. The video_device_enter() and
> > > video_device_exit() functions must be used to mark entry and exit from
> > > all code sections where the device can be accessed. The
> > > video_device_unplug() function is then used in the unplug handler to
> > > mark the device as being unplugged and wait for all access to complete.
> > > 
> > > As an example mark the ioctl handler as a device access section. Other
> > > file operations need to be protected too, and blocking ioctls (such as
> > > VIDIOC_DQBUF) need to be handled as well.
> > > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > > ---
> > >  drivers/media/v4l2-core/v4l2-dev.c | 57 ++++++++++++++++++++++++++++++++++++++
> > >  include/media/v4l2-dev.h           | 47 +++++++++++++++++++++++++++++++
> > >  2 files changed, 104 insertions(+)
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> > > index c647ba648805..c73c6d49e7cf 100644
> > > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > > +++ b/drivers/media/v4l2-core/v4l2-dev.c
> > > @@ -156,6 +156,52 @@ void video_device_release_empty(struct video_device *vdev)
> > >  }
> > >  EXPORT_SYMBOL(video_device_release_empty);
> > >  
> > > +int video_device_enter(struct video_device *vdev)
> > > +{
> > > +	bool unplugged;
> > > +
> > > +	spin_lock(&vdev->unplug_lock);
> > > +	unplugged = vdev->unplugged;
> > > +	if (!unplugged)
> > > +		vdev->access_refcount++;
> > > +	spin_unlock(&vdev->unplug_lock);
> > > +
> > > +	return unplugged ? -ENODEV : 0;
> > > +}
> > > +EXPORT_SYMBOL_GPL(video_device_enter);
> > > +
> > > +void video_device_exit(struct video_device *vdev)
> > > +{
> > > +	bool wake_up;
> > > +
> > > +	spin_lock(&vdev->unplug_lock);
> > > +	WARN_ON(--vdev->access_refcount < 0);
> > > +	wake_up = vdev->access_refcount == 0;
> > > +	spin_unlock(&vdev->unplug_lock);
> > > +
> > > +	if (wake_up)
> > > +		wake_up(&vdev->unplug_wait);
> > > +}
> > > +EXPORT_SYMBOL_GPL(video_device_exit);
> > > +
> > > +void video_device_unplug(struct video_device *vdev)
> > > +{
> > > +	bool unplug_blocked;
> > > +
> > > +	spin_lock(&vdev->unplug_lock);
> > > +	unplug_blocked = vdev->access_refcount > 0;
> > > +	vdev->unplugged = true;
> > > +	spin_unlock(&vdev->unplug_lock);
> > > +
> > > +	if (!unplug_blocked)
> > > +		return;
> > > +
> > > +	if (!wait_event_timeout(vdev->unplug_wait, !vdev->access_refcount,
> > > +				msecs_to_jiffies(150000)))
> > > +		WARN(1, "Timeout waiting for device access to complete\n");
> > > +}
> > > +EXPORT_SYMBOL_GPL(video_device_unplug);
> > > +
> > >  static inline void video_get(struct video_device *vdev)
> > >  {
> > >  	get_device(&vdev->dev);
> > > @@ -351,6 +397,10 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> > >  	struct video_device *vdev = video_devdata(filp);
> > >  	int ret = -ENODEV;
> > >  
> > > +	ret = video_device_enter(vdev);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > >  	if (vdev->fops->unlocked_ioctl) {
> > >  		struct mutex *lock = v4l2_ioctl_get_lock(vdev, cmd);
> > >  
> > > @@ -358,11 +408,14 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> > >  			return -ERESTARTSYS;
> > >  		if (video_is_registered(vdev))
> > >  			ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> > > +		else
> > > +			ret = -ENODEV;
> > >  		if (lock)
> > >  			mutex_unlock(lock);
> > >  	} else
> > >  		ret = -ENOTTY;
> > >  
> > > +	video_device_exit(vdev);
> > >  	return ret;
> > >  }
> > >  
> > > @@ -841,6 +894,10 @@ int __video_register_device(struct video_device *vdev, int type, int nr,
> > >  	if (WARN_ON(!vdev->v4l2_dev))
> > >  		return -EINVAL;
> > >  
> > > +	/* unplug support */
> > > +	spin_lock_init(&vdev->unplug_lock);
> > > +	init_waitqueue_head(&vdev->unplug_wait);
> > > +  
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

The problem that this patch is trying to solve is related to
hot-unplugging a platform device[1]. Quoting Laurent's comments about
it on IRC:

	"it applies to all platform devices at least"

	"I'm actually considering moving that code to the device core as
	 it applies to all drivers that have device nodes, but I'm not
	 sure that will be feasible it won't hurt other devices
	 it applies to I2C and SPI as well at least and PCI too"

[1] https://linuxtv.org/irc/irclogger_log/media-maint?date=2017-11-23,Thu

For USB drivers, hot-unplug seems to work fine for media drivers,
although keeping it working require tests from time to time, as
it is not hard to break hotplug support. so, currently, I don't see
the need of anything like that for non-platform drivers. 

My point here is that adding a new lock inside the media core that 
would be used for all media drivers, including the ones that don't need
doesn't sound a good idea.

So, if this is something that applies to all platform drivers (including
non-media ones), or if are there anything that can be done at driver's core
that would improve hotplug support for all buses, making it more stable or
easier to implement, then it would make sense to improve the driver's core. 
If not, this sounds a driver-specific issue whose fix doesn't belong to the
media core.

Thanks,
Mauro

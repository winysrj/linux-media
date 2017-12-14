Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:61844 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751839AbdLNMmI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Dec 2017 07:42:08 -0500
Date: Thu, 14 Dec 2017 14:42:05 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC 1/2] v4l: v4l2-dev: Add infrastructure to protect
 device unplug race
Message-ID: <20171214124205.g6zftaqqcm3jvpyu@paasikivi.fi.intel.com>
References: <20171116003349.19235-1-laurent.pinchart+renesas@ideasonboard.com>
 <20171116003349.19235-2-laurent.pinchart+renesas@ideasonboard.com>
 <20171116123236.kqvpoglodhs45x6l@valkosipuli.retiisi.org.uk>
 <2047593.6mOerD5o8g@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2047593.6mOerD5o8g@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, Dec 12, 2017 at 04:42:23PM +0200, Laurent Pinchart wrote:
...
> > > diff --git a/drivers/media/v4l2-core/v4l2-dev.c
> > > b/drivers/media/v4l2-core/v4l2-dev.c index c647ba648805..c73c6d49e7cf
> > > 100644
> > > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > > +++ b/drivers/media/v4l2-core/v4l2-dev.c
> > > @@ -156,6 +156,52 @@ void video_device_release_empty(struct video_device
> > > *vdev)> 
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
> > 
> > Is there a need to export the two, i.e. wouldn't you only call them from
> > the framework, or the same module?
> 
> There could be a need to call these functions from entry points that are not 
> controlled by the V4L2 core, such as sysfs or debugfs. We could keep the 
> functions internal for now and only export them when the need arises, but if 
> we want to document how drivers need to handle race conditions between device 
> access and device unbind, we need to have them exported.

Ack.

> 
> > > +
> > > +void video_device_unplug(struct video_device *vdev)
> > > +{
> > > +	bool unplug_blocked;
> > > +
> > > +	spin_lock(&vdev->unplug_lock);
> > > +	unplug_blocked = vdev->access_refcount > 0;
> > > +	vdev->unplugged = true;
> > 
> > Shouldn't this be set to false in video_register_device()?
> 
> Yes it should. I currently rely on the fact that the memory is zeroed when 
> allocated, but I shouldn't. I'll fix that.
> 
> > > +	spin_unlock(&vdev->unplug_lock);
> > > +
> > > +	if (!unplug_blocked)
> > > +		return;
> > 
> > Not necessary, wait_event_timeout() handles this already.
> 
> I'll fix this as well.
> 
> > > +
> > > +	if (!wait_event_timeout(vdev->unplug_wait, !vdev->access_refcount,
> > > +				msecs_to_jiffies(150000)))
> > > +		WARN(1, "Timeout waiting for device access to complete\n");
> > 
> > Why a timeout? Does this get somehow less problematic over time? :-)
> 
> Not quite :-) This should never happen, but driver and/or core bugs could 
> cause a timeout. In that case I think proceeding after a timeout is a better 
> option than deadlocking forever.

This also depends on the frame rate; you could have a very low frame rate
configured on a sensor and the device could be actually in middle of a DMA
operation while the timeout is hit.

I'm not sure if there's a number that can be said to be safe here.

Wouldn't it be better to kill the user space process using the device
instead? Naturally the wait will have to be interruptible.

...

> > > @@ -221,6 +228,12 @@ struct video_device
> > > 
> > >  	u32 device_caps;
> > > 
> > > +	/* unplug handling */
> > > +	bool unplugged;
> > > +	int access_refcount;
> > 
> > Could you use refcount_t instead, to avoid integer overflow issues?
> 
> I'd love to, but refcount_t has no provision for refcounts that start at 0.
> 
> void refcount_inc(refcount_t *r)
> {
>         WARN_ONCE(!refcount_inc_not_zero(r), "refcount_t: increment on 0; use-
> after-free.\n");
> }
> EXPORT_SYMBOL(refcount_inc);

Ah. I wonder if you could simply initialise in probe and decrement it again
in remove?

You could use refcount_inc_not_zero directly, too.

> 
> > > +	spinlock_t unplug_lock;
> > > +	wait_queue_head_t unplug_wait;
> > > +
> > >  	/* sysfs */
> > >  	struct device dev;
> > >  	struct cdev *cdev;

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com

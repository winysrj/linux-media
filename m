Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab1BIRiA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Feb 2011 12:38:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v6 4/7] v4l: subdev: Add device node support
Date: Wed, 9 Feb 2011 18:37:43 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1296131338-29892-1-git-send-email-laurent.pinchart@ideasonboard.com> <1296131338-29892-5-git-send-email-laurent.pinchart@ideasonboard.com> <201102041109.03183.hverkuil@xs4all.nl>
In-Reply-To: <201102041109.03183.hverkuil@xs4all.nl>
MIME-Version: 1.0
Message-Id: <201102091837.45852.laurent.pinchart@ideasonboard.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the review.

On Friday 04 February 2011 11:09:03 Hans Verkuil wrote:
> On Thursday, January 27, 2011 13:28:55 Laurent Pinchart wrote:

[snip]

> > @@ -143,10 +162,13 @@ void v4l2_device_unregister_subdev(struct
> > v4l2_subdev *sd)
> > 
> >  	/* return if it isn't registered */
> >  	if (sd == NULL || sd->v4l2_dev == NULL)
> >  		return;
> > +
> >  	spin_lock(&sd->v4l2_dev->lock);
> >  	list_del(&sd->list);
> >  	spin_unlock(&sd->v4l2_dev->lock);
> >  	sd->v4l2_dev = NULL;
> > +
> >  	module_put(sd->owner);
> > +	video_unregister_device(&sd->devnode);
> 
> I'm pretty sure that the video_unregister_device should be called before
> the module_put. And I think it is cleaner to test the
> V4L2_SUBDEV_FL_HAS_DEVNODE flag as well. It may not be strictly necessary,
> but it is less confusing.

OK.

[snip]

> > @@ -440,8 +443,16 @@ struct v4l2_subdev {
> > 
> >  	/* pointer to private data */
> >  	void *dev_priv;
> >  	void *host_priv;
> > 
> > +	/* subdev device node */
> > +	struct video_device devnode;
> > +	unsigned int initialized;
> 
> This can be a bool. Actually, thinking about this some more, is this really
> necessary? The device node should be created as the very last thing anyway.
> Looking at the patches it seems to be set only when creating an i2c subdev,
> and not when creating a spi subdev (let alone the fact that this has to be
> set manually for internal subdevs).
> 
> I think it is more hassle than anything else.
> 
> There may be situations where you don't want to create a device node when
> calling v4l2_device_register_subdev(): should that happen, then it is
> better to add the capability of registering a subdev without creating a
> device node, and add a new function that just creates the device node at
> a later (safe) stage.
> 
> The easiest way to do this is to add a new flag:
> V4L2_SUBDEV_FL_ALLOW_DEVNODE
> 
> The HAS_DEVNODE flag is set by the subdev driver, the ALLOW_DEVNODE flag is
> set by the master driver. If both are set, then the device node is created.
> 
> So by splitting off the device node creation in a public function, the
> master driver can control this nicely.
> 
> Thinking about this, we can actually implement it like this from the
> beginning. I never really liked the fact that the master driver clears the
> HAS_DEVNODE flag. Creating two separate flags is cleaner.

As discussed on IRC, I've removed automatic subdev device node registration as 
it's prone to race conditions. Drivers will need to call 
v4l2_device_register_subdev_nodes() explicitly. The initialized field, as well 
as the enable_devnode arguments, are removed.

-- 
Regards,

Laurent Pinchart

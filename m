Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:36587 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750854AbdE2Hta (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 03:49:30 -0400
Received: by mail-lf0-f50.google.com with SMTP id h4so30359105lfj.3
        for <linux-media@vger.kernel.org>; Mon, 29 May 2017 00:49:29 -0700 (PDT)
Date: Mon, 29 May 2017 09:49:26 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v2 15/17] rcar-vin: register the video device at probe
 time
Message-ID: <20170529074926.GL5567@bigcity.dyn.berto.se>
References: <20170524001540.13613-1-niklas.soderlund@ragnatech.se>
 <20170524001540.13613-16-niklas.soderlund@ragnatech.se>
 <5c911c00-ef4c-89c9-4629-20abaeb37f26@xs4all.nl>
 <072c6d94-3ede-724d-2626-e085e17f7c6d@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <072c6d94-3ede-724d-2626-e085e17f7c6d@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for taking the time to look at this :-)

On 2017-05-29 08:56:31 +0200, Hans Verkuil wrote:
> On 05/29/2017 08:52 AM, Hans Verkuil wrote:
> > Hi Niklas,
> > 
> > On 05/24/2017 02:15 AM, Niklas Söderlund wrote:
> > > From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > 
> > > The driver registers the video device from the async complete callback
> > > and unregistered in the async unbind callback. This creates problems if
> > > if the subdevice is bound, unbound and later rebound. The second time
> > > video_register_device() is called it fails:
> > > 
> > >      kobject (eb3be918): tried to init an initialized object, something is seriously wrong.
> > > 
> > > To prevent this register the video device at prob time and don't allow
> > > user-space to open the video device if the subdevice have not yet been
> > > bound.
> > 
> > This patch feels wrong. Creating the video device in the notify_complete seems
> > right to me, so the problem is much more likely in the removal of the video device.
> > 
> > What *exactly* goes wrong here

When calling video_register_device() it fails since the device structure 
have already been registered once. So it is not possible to register, 
unregister and then register the same video device struct. The other 
solution to this is to memset the whole embedded video device struct to 
zero  before initializing it and calling video_register_device(), but 
that feels more wrong. Let me know what you think and I will rework this 
patch.


> > 
> > FYI: I'm taking all other patches of this series,
> 
> Oops, I saw Sakari had two comments. I'll wait for a v3 then.
> 
> If you make a v3 with Sakari's suggestions and drop this patch, then I can merge
> it and make a pull request for it.

I can't find Sakaris comments in my inbox or on the ML for this thread.  
Where did you see them?

> 
> This patch can be handled separately from the other the patches.
> 
> Regards,
> 
> 	Hans
> 
> > but I leave this one out
> > as I am not convinced of this patch. Having to block open() calls is always
> > a bad sign.
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > > 
> > > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > > ---
> > >    drivers/media/platform/rcar-vin/rcar-core.c | 47 ++++++++++++++++++++++++++---
> > >    drivers/media/platform/rcar-vin/rcar-v4l2.c | 42 ++++----------------------
> > >    drivers/media/platform/rcar-vin/rcar-vin.h  |  1 +
> > >    3 files changed, 50 insertions(+), 40 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> > > index dcca906ba58435f5..0e1757301a0bca1e 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-core.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> > > @@ -74,6 +74,7 @@ static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
> > >    static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
> > >    {
> > >    	struct rvin_dev *vin = notifier_to_vin(notifier);
> > > +	struct v4l2_subdev *sd = vin_to_source(vin);
> > >    	int ret;
> > >    	/* Verify subdevices mbus format */
> > > @@ -92,7 +93,35 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
> > >    		return ret;
> > >    	}
> > > -	return rvin_v4l2_probe(vin);
> > > +	/* Add the controls */
> > > +	/*
> > > +	 * Currently the subdev with the largest number of controls (13) is
> > > +	 * ov6550. So let's pick 16 as a hint for the control handler. Note
> > > +	 * that this is a hint only: too large and you waste some memory, too
> > > +	 * small and there is a (very) small performance hit when looking up
> > > +	 * controls in the internal hash.
> > > +	 */
> > > +	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
> > > +	if (ret < 0)
> > > +		return ret;
> > > +
> > > +	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
> > > +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> > > +		return ret;
> > > +
> > > +	if (vin->vdev.tvnorms == 0) {
> > > +		/* Disable the STD API if there are no tvnorms defined */
> > > +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
> > > +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
> > > +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
> > > +		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
> > > +	}
> > > +
> > > +	return rvin_reset_format(vin);
> > >    }
> > >    static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
> > > @@ -102,7 +131,7 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
> > >    	struct rvin_dev *vin = notifier_to_vin(notifier);
> > >    	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
> > > -	rvin_v4l2_remove(vin);
> > > +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> > >    	vin->digital.subdev = NULL;
> > >    }
> > > @@ -290,9 +319,13 @@ static int rcar_vin_probe(struct platform_device *pdev)
> > >    	if (ret)
> > >    		return ret;
> > > +	ret = rvin_v4l2_probe(vin);
> > > +	if (ret)
> > > +		goto error_dma;
> > > +
> > >    	ret = rvin_digital_graph_init(vin);
> > >    	if (ret < 0)
> > > -		goto error;
> > > +		goto error_v4l2;
> > >    	pm_suspend_ignore_children(&pdev->dev, true);
> > >    	pm_runtime_enable(&pdev->dev);
> > > @@ -300,7 +333,9 @@ static int rcar_vin_probe(struct platform_device *pdev)
> > >    	platform_set_drvdata(pdev, vin);
> > >    	return 0;
> > > -error:
> > > +error_v4l2:
> > > +	rvin_v4l2_remove(vin);
> > > +error_dma:
> > >    	rvin_dma_remove(vin);
> > >    	return ret;
> > > @@ -314,6 +349,10 @@ static int rcar_vin_remove(struct platform_device *pdev)
> > >    	v4l2_async_notifier_unregister(&vin->notifier);
> > > +	/* Checks internaly if handlers have been init or not */
> > > +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> > > +
> > > +	rvin_v4l2_remove(vin);
> > >    	rvin_dma_remove(vin);
> > >    	return 0;
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > index be6f41bf82ac3bc5..6f1c27fc828fe57e 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> > > @@ -103,7 +103,7 @@ static void rvin_reset_crop_compose(struct rvin_dev *vin)
> > >    	vin->compose.height = vin->format.height;
> > >    }
> > > -static int rvin_reset_format(struct rvin_dev *vin)
> > > +int rvin_reset_format(struct rvin_dev *vin)
> > >    {
> > >    	struct v4l2_subdev_format fmt = {
> > >    		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> > > @@ -785,6 +785,11 @@ static int rvin_open(struct file *file)
> > >    	mutex_lock(&vin->lock);
> > > +	if (!vin->digital.subdev) {
> > > +		ret = -ENODEV;
> > > +		goto unlock;
> > > +	}
> > > +
> > >    	file->private_data = vin;
> > >    	ret = v4l2_fh_open(file);
> > > @@ -848,9 +853,6 @@ void rvin_v4l2_remove(struct rvin_dev *vin)
> > >    	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
> > >    		  video_device_node_name(&vin->vdev));
> > > -	/* Checks internaly if handlers have been init or not */
> > > -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> > > -
> > >    	/* Checks internaly if vdev have been init or not */
> > >    	video_unregister_device(&vin->vdev);
> > >    }
> > > @@ -873,41 +875,10 @@ static void rvin_notify(struct v4l2_subdev *sd,
> > >    int rvin_v4l2_probe(struct rvin_dev *vin)
> > >    {
> > >    	struct video_device *vdev = &vin->vdev;
> > > -	struct v4l2_subdev *sd = vin_to_source(vin);
> > >    	int ret;
> > > -	v4l2_set_subdev_hostdata(sd, vin);
> > > -
> > >    	vin->v4l2_dev.notify = rvin_notify;
> > > -	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
> > > -	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> > > -		return ret;
> > > -
> > > -	if (vin->vdev.tvnorms == 0) {
> > > -		/* Disable the STD API if there are no tvnorms defined */
> > > -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
> > > -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
> > > -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
> > > -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
> > > -	}
> > > -
> > > -	/* Add the controls */
> > > -	/*
> > > -	 * Currently the subdev with the largest number of controls (13) is
> > > -	 * ov6550. So let's pick 16 as a hint for the control handler. Note
> > > -	 * that this is a hint only: too large and you waste some memory, too
> > > -	 * small and there is a (very) small performance hit when looking up
> > > -	 * controls in the internal hash.
> > > -	 */
> > > -	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> > > -	if (ret < 0)
> > > -		return ret;
> > > -
> > > -	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
> > > -	if (ret < 0)
> > > -		return ret;
> > > -
> > >    	/* video node */
> > >    	vdev->fops = &rvin_fops;
> > >    	vdev->v4l2_dev = &vin->v4l2_dev;
> > > @@ -921,7 +892,6 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
> > >    		V4L2_CAP_READWRITE;
> > >    	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
> > > -	rvin_reset_format(vin);
> > >    	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
> > >    	if (ret) {
> > > diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> > > index 9bfb5a7c4dc4f215..9d0d4a5001b6ccd8 100644
> > > --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> > > +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> > > @@ -158,6 +158,7 @@ void rvin_dma_remove(struct rvin_dev *vin);
> > >    int rvin_v4l2_probe(struct rvin_dev *vin);
> > >    void rvin_v4l2_remove(struct rvin_dev *vin);
> > > +int rvin_reset_format(struct rvin_dev *vin);
> > >    const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
> > > 
> > 
> 

-- 
Regards,
Niklas Söderlund

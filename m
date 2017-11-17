Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:40393 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754395AbdKQLjW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 06:39:22 -0500
Subject: Re: [PATCH v7 02/25] rcar-vin: register the video device at probe
 time
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
References: <20171111003835.4909-1-niklas.soderlund+renesas@ragnatech.se>
 <20171111003835.4909-3-niklas.soderlund+renesas@ragnatech.se>
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <61822408-1438-5a27-dcc9-df644fff18a5@xs4all.nl>
Date: Fri, 17 Nov 2017 12:39:20 +0100
MIME-Version: 1.0
In-Reply-To: <20171111003835.4909-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/11/17 01:38, Niklas Söderlund wrote:
> The driver registers the video device from the async complete callback
> and unregistered in the async unbind callback. This creates problems if
> if the subdevice is bound, unbound and later rebound. The second time

"unbound and later rebound": that's a manual operation via /sys bind/unbind?

I remain unhappy about this patch. It's a workaround for a more basic problem
IMHO.

Can you move this patch to the end of the series? That way I can decide later
whether to merge it or not without blocking the rest of the series.

Other than this patch the only blocking patch is the bindings patch which hasn't
got an Ack yet.

Regards,

	Hans

> video_register_device() is called it fails:
> 
>    kobject (eb3be918): tried to init an initialized object, something is seriously wrong.
> 
> To prevent this register the video device at probe time and don't allow
> user-space to open the video device if the subdevice is not bound yet.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 124 +++++++++++++++++++---------
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  47 ++---------
>  drivers/media/platform/rcar-vin/rcar-vin.h  |   5 +-
>  3 files changed, 95 insertions(+), 81 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 108d776f32651b27..856df3e407c05d97 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -46,54 +46,18 @@ static int rvin_find_pad(struct v4l2_subdev *sd, int direction)
>  	return -EINVAL;
>  }
>  
> -static bool rvin_mbus_supported(struct rvin_graph_entity *entity)
> -{
> -	struct v4l2_subdev *sd = entity->subdev;
> -	struct v4l2_subdev_mbus_code_enum code = {
> -		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> -	};
> -
> -	code.index = 0;
> -	code.pad = entity->source_pad;
> -	while (!v4l2_subdev_call(sd, pad, enum_mbus_code, NULL, &code)) {
> -		code.index++;
> -		switch (code.code) {
> -		case MEDIA_BUS_FMT_YUYV8_1X16:
> -		case MEDIA_BUS_FMT_UYVY8_2X8:
> -		case MEDIA_BUS_FMT_UYVY10_2X10:
> -		case MEDIA_BUS_FMT_RGB888_1X24:
> -			entity->code = code.code;
> -			return true;
> -		default:
> -			break;
> -		}
> -	}
> -
> -	return false;
> -}
> -
>  static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
>  	int ret;
>  
> -	/* Verify subdevices mbus format */
> -	if (!rvin_mbus_supported(vin->digital)) {
> -		vin_err(vin, "Unsupported media bus format for %s\n",
> -			vin->digital->subdev->name);
> -		return -EINVAL;
> -	}
> -
> -	vin_dbg(vin, "Found media bus format for %s: %d\n",
> -		vin->digital->subdev->name, vin->digital->code);
> -
>  	ret = v4l2_device_register_subdev_nodes(&vin->v4l2_dev);
>  	if (ret < 0) {
>  		vin_err(vin, "Failed to register subdev nodes\n");
>  		return ret;
>  	}
>  
> -	return rvin_v4l2_probe(vin);
> +	return 0;
>  }
>  
>  static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
> @@ -103,8 +67,15 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
>  
>  	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
> -	rvin_v4l2_remove(vin);
> +
> +	mutex_lock(&vin->lock);
> +
> +	vin->vdev.ctrl_handler = NULL;
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +
>  	vin->digital->subdev = NULL;
> +
> +	mutex_unlock(&vin->lock);
>  }
>  
>  static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
> @@ -112,12 +83,14 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>  				     struct v4l2_async_subdev *asd)
>  {
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
> +	struct v4l2_subdev_mbus_code_enum code = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
>  	int ret;
>  
>  	v4l2_set_subdev_hostdata(subdev, vin);
>  
>  	/* Find source and sink pad of remote subdevice */
> -
>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SOURCE);
>  	if (ret < 0)
>  		return ret;
> @@ -126,21 +99,82 @@ static int rvin_digital_notify_bound(struct v4l2_async_notifier *notifier,
>  	ret = rvin_find_pad(subdev, MEDIA_PAD_FL_SINK);
>  	vin->digital->sink_pad = ret < 0 ? 0 : ret;
>  
> +	/* Find compatible subdevices mbus format */
> +	vin->digital->code = 0;
> +	code.index = 0;
> +	code.pad = vin->digital->source_pad;
> +	while (!vin->digital->code &&
> +	       !v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
> +		code.index++;
> +		switch (code.code) {
> +		case MEDIA_BUS_FMT_YUYV8_1X16:
> +		case MEDIA_BUS_FMT_UYVY8_2X8:
> +		case MEDIA_BUS_FMT_UYVY10_2X10:
> +		case MEDIA_BUS_FMT_RGB888_1X24:
> +			vin->digital->code = code.code;
> +			vin_dbg(vin, "Found media bus format for %s: %d\n",
> +				subdev->name, vin->digital->code);
> +			break;
> +		default:
> +			break;
> +		}
> +	}
> +
> +	if (!vin->digital->code) {
> +		vin_err(vin, "Unsupported media bus format for %s\n",
> +			subdev->name);
> +		return -EINVAL;
> +	}
> +
> +	/* Read tvnorms */
> +	ret = v4l2_subdev_call(subdev, video, g_tvnorms, &vin->vdev.tvnorms);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +
> +	/* Lock as to not race with open */
> +	mutex_lock(&vin->lock);
> +
> +	/* Add the controls */
> +	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> +	if (ret < 0)
> +		goto err;
> +
> +	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, subdev->ctrl_handler,
> +				    NULL);
> +	if (ret < 0)
> +		goto err_ctrl;
> +
> +	vin->vdev.ctrl_handler = &vin->ctrl_handler;
> +
>  	vin->digital->subdev = subdev;
>  
> +	ret = rvin_reset_format(vin);
> +	if (ret)
> +		goto err_subdev;
> +
> +	mutex_unlock(&vin->lock);
> +
>  	vin_dbg(vin, "bound subdev %s source pad: %u sink pad: %u\n",
>  		subdev->name, vin->digital->source_pad,
>  		vin->digital->sink_pad);
>  
>  	return 0;
> +err_subdev:
> +	vin->digital->subdev = NULL;
> +	vin->vdev.ctrl_handler = NULL;
> +err_ctrl:
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +err:
> +	mutex_unlock(&vin->lock);
> +	return ret;
>  }
> +
>  static const struct v4l2_async_notifier_operations rvin_digital_notify_ops = {
>  	.bound = rvin_digital_notify_bound,
>  	.unbind = rvin_digital_notify_unbind,
>  	.complete = rvin_digital_notify_complete,
>  };
>  
> -
>  static int rvin_digital_parse_v4l2(struct device *dev,
>  				   struct v4l2_fwnode_endpoint *vep,
>  				   struct v4l2_async_subdev *asd)
> @@ -189,7 +223,12 @@ static int rvin_digital_graph_init(struct rvin_dev *vin)
>  	vin_dbg(vin, "Found digital subdevice %pOF\n",
>  		to_of_node(vin->digital->asd.match.fwnode.fwnode));
>  
> +	ret = rvin_v4l2_register(vin);
> +	if (ret)
> +		return ret;
> +
>  	vin->notifier.ops = &rvin_digital_notify_ops;
> +
>  	ret = v4l2_async_notifier_register(&vin->v4l2_dev, &vin->notifier);
>  	if (ret < 0) {
>  		vin_err(vin, "Notifier registration failed\n");
> @@ -275,6 +314,11 @@ static int rcar_vin_remove(struct platform_device *pdev)
>  	v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>  
> +	/* Checks internaly if handlers have been init or not */
> +	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> +
> +	rvin_v4l2_unregister(vin);
> +
>  	rvin_dma_remove(vin);
>  
>  	return 0;
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index b479b882da12f62d..33dd0ec0b82e57dc 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -103,7 +103,7 @@ static void rvin_reset_crop_compose(struct rvin_dev *vin)
>  	vin->compose.height = vin->format.height;
>  }
>  
> -static int rvin_reset_format(struct rvin_dev *vin)
> +int rvin_reset_format(struct rvin_dev *vin)
>  {
>  	struct v4l2_subdev_format fmt = {
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> @@ -781,6 +781,11 @@ static int rvin_open(struct file *file)
>  
>  	mutex_lock(&vin->lock);
>  
> +	if (!vin->digital->subdev) {
> +		ret = -ENODEV;
> +		goto unlock;
> +	}
> +
>  	file->private_data = vin;
>  
>  	ret = v4l2_fh_open(file);
> @@ -839,14 +844,11 @@ static const struct v4l2_file_operations rvin_fops = {
>  	.read		= vb2_fop_read,
>  };
>  
> -void rvin_v4l2_remove(struct rvin_dev *vin)
> +void rvin_v4l2_unregister(struct rvin_dev *vin)
>  {
>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
>  		  video_device_node_name(&vin->vdev));
>  
> -	/* Checks internaly if handlers have been init or not */
> -	v4l2_ctrl_handler_free(&vin->ctrl_handler);
> -
>  	/* Checks internaly if vdev have been init or not */
>  	video_unregister_device(&vin->vdev);
>  }
> @@ -866,44 +868,13 @@ static void rvin_notify(struct v4l2_subdev *sd,
>  	}
>  }
>  
> -int rvin_v4l2_probe(struct rvin_dev *vin)
> +int rvin_v4l2_register(struct rvin_dev *vin)
>  {
>  	struct video_device *vdev = &vin->vdev;
> -	struct v4l2_subdev *sd = vin_to_source(vin);
>  	int ret;
>  
> -	v4l2_set_subdev_hostdata(sd, vin);
> -
>  	vin->v4l2_dev.notify = rvin_notify;
>  
> -	ret = v4l2_subdev_call(sd, video, g_tvnorms, &vin->vdev.tvnorms);
> -	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> -		return ret;
> -
> -	if (vin->vdev.tvnorms == 0) {
> -		/* Disable the STD API if there are no tvnorms defined */
> -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_G_STD);
> -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_S_STD);
> -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_QUERYSTD);
> -		v4l2_disable_ioctl(&vin->vdev, VIDIOC_ENUMSTD);
> -	}
> -
> -	/* Add the controls */
> -	/*
> -	 * Currently the subdev with the largest number of controls (13) is
> -	 * ov6550. So let's pick 16 as a hint for the control handler. Note
> -	 * that this is a hint only: too large and you waste some memory, too
> -	 * small and there is a (very) small performance hit when looking up
> -	 * controls in the internal hash.
> -	 */
> -	ret = v4l2_ctrl_handler_init(&vin->ctrl_handler, 16);
> -	if (ret < 0)
> -		return ret;
> -
> -	ret = v4l2_ctrl_add_handler(&vin->ctrl_handler, sd->ctrl_handler, NULL);
> -	if (ret < 0)
> -		return ret;
> -
>  	/* video node */
>  	vdev->fops = &rvin_fops;
>  	vdev->v4l2_dev = &vin->v4l2_dev;
> @@ -912,12 +883,10 @@ int rvin_v4l2_probe(struct rvin_dev *vin)
>  	vdev->release = video_device_release_empty;
>  	vdev->ioctl_ops = &rvin_ioctl_ops;
>  	vdev->lock = &vin->lock;
> -	vdev->ctrl_handler = &vin->ctrl_handler;
>  	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>  		V4L2_CAP_READWRITE;
>  
>  	vin->format.pixelformat	= RVIN_DEFAULT_FORMAT;
> -	rvin_reset_format(vin);
>  
>  	ret = video_register_device(&vin->vdev, VFL_TYPE_GRABBER, -1);
>  	if (ret) {
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 5382078143fb3869..ab48cdf09889982e 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -156,8 +156,9 @@ struct rvin_dev {
>  int rvin_dma_probe(struct rvin_dev *vin, int irq);
>  void rvin_dma_remove(struct rvin_dev *vin);
>  
> -int rvin_v4l2_probe(struct rvin_dev *vin);
> -void rvin_v4l2_remove(struct rvin_dev *vin);
> +int rvin_v4l2_register(struct rvin_dev *vin);
> +void rvin_v4l2_unregister(struct rvin_dev *vin);
> +int rvin_reset_format(struct rvin_dev *vin);
>  
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
>  
> 

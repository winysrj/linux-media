Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2881 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab0GGMnO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Jul 2010 08:43:14 -0400
Message-ID: <d27c4d2b115f01c7cd17714ee14576ad.squirrel@webmail.xs4all.nl>
In-Reply-To: <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1278503608-9126-1-git-send-email-laurent.pinchart@ideasonboard.com>
    <1278503608-9126-3-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Wed, 7 Jul 2010 14:43:08 +0200
Subject: Re: [RFC/PATCH 2/6] v4l: subdev: Add device node support
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Create a device node named subdevX for every registered subdev.
>
> As the device node is registered before the subdev core::s_config
> function is called, return -EGAIN on open until initialization
> completes.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Vimarsh Zutshi <vimarsh.zutshi@nokia.com>
> ---
>  drivers/media/video/Makefile      |    2 +-
>  drivers/media/video/v4l2-common.c |    3 ++
>  drivers/media/video/v4l2-dev.c    |    5 +++
>  drivers/media/video/v4l2-device.c |   27 +++++++++++++++-
>  drivers/media/video/v4l2-subdev.c |   65
> +++++++++++++++++++++++++++++++++++++
>  include/media/v4l2-dev.h          |    3 +-
>  include/media/v4l2-subdev.h       |   10 ++++++
>  7 files changed, 112 insertions(+), 3 deletions(-)

...

> diff --git a/drivers/media/video/v4l2-device.c
> b/drivers/media/video/v4l2-device.c
> index 5a7dc4a..685fa82 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -115,18 +115,40 @@ EXPORT_SYMBOL_GPL(v4l2_device_unregister);
>  int v4l2_device_register_subdev(struct v4l2_device *v4l2_dev,
>  						struct v4l2_subdev *sd)
>  {
> +	struct video_device *vdev;
> +	int ret;
> +
>  	/* Check for valid input */
>  	if (v4l2_dev == NULL || sd == NULL || !sd->name[0])
>  		return -EINVAL;
> +
>  	/* Warn if we apparently re-register a subdev */
>  	WARN_ON(sd->v4l2_dev != NULL);
> +
>  	if (!try_module_get(sd->owner))
>  		return -ENODEV;
> +
>  	sd->v4l2_dev = v4l2_dev;
>  	spin_lock(&v4l2_dev->lock);
>  	list_add_tail(&sd->list, &v4l2_dev->subdevs);
>  	spin_unlock(&v4l2_dev->lock);
> -	return 0;
> +
> +	/* Register the device node. */
> +	vdev = &sd->devnode;
> +	snprintf(vdev->name, sizeof(vdev->name), "subdev");
> +	vdev->parent = v4l2_dev->dev;
> +	vdev->fops = &v4l2_subdev_fops;
> +	vdev->release = video_device_release_empty;
> +	ret = video_register_device(vdev, VFL_TYPE_SUBDEV, -1);
> +	if (ret < 0) {
> +		spin_lock(&v4l2_dev->lock);
> +		list_del(&sd->list);
> +		spin_unlock(&v4l2_dev->lock);
> +		sd->v4l2_dev = NULL;
> +		module_put(sd->owner);
> +	}
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
>

I'm missing one thing here: in this code the subdev device node is always
registered. But for most subdev drivers there is no need for a device
node. This should really be explicitly turned on by the subdev driver
itself.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco


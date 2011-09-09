Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58435 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab1IIVdy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Sep 2011 17:33:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v2] V4L: dynamically allocate video_device nodes in subdevices
Date: Fri, 9 Sep 2011 23:32:59 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.1109091701060.915@axis700.grange> <Pine.LNX.4.64.1109091943480.915@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109091943480.915@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109092332.59943.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday 09 September 2011 19:45:57 Guennadi Liakhovetski wrote:
> Currently only very few drivers actually use video_device nodes, embedded
> in struct v4l2_subdev. Allocate these nodes dynamically for those drivers
> to save memory for the rest.

Thanks for the patch.

> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v2: Checking for NULL is not always enough, you also have to check the
> right thing for it. In this case it was sd->devnode in
> v4l2_device_unregister_subdev().
> 
>  drivers/media/video/v4l2-device.c |   29 ++++++++++++++++++++++++++---
>  include/media/v4l2-subdev.h       |   10 ++++++++--
>  2 files changed, 34 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-device.c
> b/drivers/media/video/v4l2-device.c index c72856c..d4c093f 100644
> --- a/drivers/media/video/v4l2-device.c
> +++ b/drivers/media/video/v4l2-device.c
> @@ -21,6 +21,7 @@
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
>  #include <linux/i2c.h>
> +#include <linux/slab.h>
>  #if defined(CONFIG_SPI)
>  #include <linux/spi/spi.h>
>  #endif
> @@ -194,6 +195,7 @@ EXPORT_SYMBOL_GPL(v4l2_device_register_subdev);
>  int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
>  {
>  	struct video_device *vdev;
> +	struct v4l2_devnode *node;
>  	struct v4l2_subdev *sd;
>  	int err;
> 
> @@ -204,7 +206,13 @@ int v4l2_device_register_subdev_nodes(struct
> v4l2_device *v4l2_dev) if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
>  			continue;
> 
> -		vdev = &sd->devnode;
> +		node = kzalloc(sizeof(*node), GFP_KERNEL);
> +		if (!node) {
> +			err = -ENOMEM;
> +			goto clean_up;
> +		}
> +		vdev = &node->vdev;
> +
>  		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
>  		vdev->v4l2_dev = v4l2_dev;
>  		vdev->fops = &v4l2_subdev_fops;
> @@ -213,13 +221,25 @@ int v4l2_device_register_subdev_nodes(struct
> v4l2_device *v4l2_dev) err = __video_register_device(vdev,
> VFL_TYPE_SUBDEV, -1, 1,
>  					      sd->owner);
>  		if (err < 0)
> -			return err;
> +			goto clean_up;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  		sd->entity.v4l.major = VIDEO_MAJOR;
>  		sd->entity.v4l.minor = vdev->minor;
>  #endif
> +		sd->devnode = node;
>  	}
>  	return 0;
> +
> +clean_up:
> +	list_for_each_entry(sd, &v4l2_dev->subdevs, list) {
> +		if (!sd->devnode)
> +			break;
> +		video_unregister_device(&sd->devnode->vdev);
> +		kfree(sd->devnode);
> +		sd->devnode = NULL;
> +	}
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_register_subdev_nodes);
> 
> @@ -245,7 +265,10 @@ void v4l2_device_unregister_subdev(struct v4l2_subdev
> *sd) if (v4l2_dev->mdev)
>  		media_device_unregister_entity(&sd->entity);
>  #endif
> -	video_unregister_device(&sd->devnode);
> +	if (sd->devnode)
> +		video_unregister_device(&sd->devnode->vdev);
> +	kfree(sd->devnode);

Won't this crash if the node is open ? I think you need to refcount it.

> +	sd->devnode = NULL;
>  	module_put(sd->owner);
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_unregister_subdev);
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 257da1a..6e958df 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -510,6 +510,12 @@ struct v4l2_subdev_internal_ops {
>  /* Set this flag if this subdev generates events. */
>  #define V4L2_SUBDEV_FL_HAS_EVENTS		(1U << 3)
> 
> +/* video_device with a reverse lookup */
> +struct v4l2_devnode {
> +	struct v4l2_subdev *sd;
> +	struct video_device vdev;
> +};
> +

Instead of that, why don't you store the subdev pointer in the video_device 
driver data ?

>  /* Each instance of a subdev driver should create this struct, either
>     stand-alone or embedded in a larger struct.
>   */
> @@ -534,13 +540,13 @@ struct v4l2_subdev {
>  	void *dev_priv;
>  	void *host_priv;
>  	/* subdev device node */
> -	struct video_device devnode;
> +	struct v4l2_devnode *devnode;
>  };
> 
>  #define media_entity_to_v4l2_subdev(ent) \
>  	container_of(ent, struct v4l2_subdev, entity)
>  #define vdev_to_v4l2_subdev(vdev) \
> -	container_of(vdev, struct v4l2_subdev, devnode)
> +	(container_of(vdev, struct v4l2_devnode, vdev)->sd)
> 
>  /*
>   * Used for storing subdev information per file handle

-- 
Regards,

Laurent Pinchart

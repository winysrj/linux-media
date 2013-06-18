Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab3FRHff (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 03:35:35 -0400
Date: Tue, 18 Jun 2013 09:34:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 02/12] soc_camera: replace vdev->parent by
 vdev->v4l2_dev.
In-Reply-To: <1371049262-5799-3-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1306180926340.30844@axis700.grange>
References: <1371049262-5799-1-git-send-email-hverkuil@xs4all.nl>
 <1371049262-5799-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

Thanks for the patch.

On Wed, 12 Jun 2013, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The parent field will eventually disappear to be replaced by v4l2_dev.
> soc_camera does provide a v4l2_device struct but did not point to it in
> struct video_device. This is now fixed.
> 
> Now the video nodes can be found under the correct platform bus, and
> the advanced debug ioctls work correctly as well (the core implementation
> of those ioctls requires that v4l2_dev is set correctly).
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I'm not quite sure about this patch, because where before only one 
dev_drvdata pointer was used to store a pointed to the icd context, now 
two pointers are used and your vdev_set_drvdata() is now called much later 
than platform_set_drvdata() in soc_camera_pdrv_probe(). So, I had to 
verify no calls to vdev_get_drvdata() are made between those two moments. 
I think it should be ok, specifically, an uncertain place is 
soc_camera_vdev_to_subdev(), used by the mt9t031 driver from its runtime 
PM. But I don't have access to that sensor, so, it hasn't been tested in 
ages. In fact, I think, I should remove its runtime PM and just call the 
resume from s_power(1). If anything breaks and onyone notices it - they 
will complain. Anyway, for now here's my

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    5 +++--
>  include/media/soc_camera.h                     |    4 ++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 0252fbb..9a43560 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -524,7 +524,7 @@ static int soc_camera_open(struct file *file)
>  		return -ENODEV;
>  	}
>  
> -	icd = dev_get_drvdata(vdev->parent);
> +	icd = video_get_drvdata(vdev);
>  	ici = to_soc_camera_host(icd->parent);
>  
>  	ret = try_module_get(ici->ops->owner) ? 0 : -ENODEV;
> @@ -1477,7 +1477,7 @@ static int video_dev_create(struct soc_camera_device *icd)
>  
>  	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
>  
> -	vdev->parent		= icd->pdev;
> +	vdev->v4l2_dev		= &ici->v4l2_dev;
>  	vdev->fops		= &soc_camera_fops;
>  	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
>  	vdev->release		= video_device_release;
> @@ -1500,6 +1500,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
>  	if (!icd->parent)
>  		return -ENODEV;
>  
> +	video_set_drvdata(icd->vdev, icd);
>  	ret = video_register_device(icd->vdev, VFL_TYPE_GRABBER, -1);
>  	if (ret < 0) {
>  		dev_err(icd->pdev, "video_register_device failed: %d\n", ret);
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index ff77d08..31a4bfe 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -346,9 +346,9 @@ static inline struct soc_camera_subdev_desc *soc_camera_i2c_to_desc(const struct
>  	return client->dev.platform_data;
>  }
>  
> -static inline struct v4l2_subdev *soc_camera_vdev_to_subdev(const struct video_device *vdev)
> +static inline struct v4l2_subdev *soc_camera_vdev_to_subdev(struct video_device *vdev)
>  {
> -	struct soc_camera_device *icd = dev_get_drvdata(vdev->parent);
> +	struct soc_camera_device *icd = video_get_drvdata(vdev);
>  	return soc_camera_to_subdev(icd);
>  }
>  
> -- 
> 1.7.10.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36243 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab1JCKc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 06:32:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 6/9] V4L: soc-camera: prepare hooks for Media Controller wrapper
Date: Mon, 3 Oct 2011 12:32:36 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Deepthy Ravi <deepthy.ravi@ti.com>
References: <1317313137-4403-1-git-send-email-g.liakhovetski@gmx.de> <1317313137-4403-7-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1317313137-4403-7-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110031232.37027.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch. It's very nice to see you working on that :-)

I'm not a soc-camera expert, so my review is by no means extensive.

On Thursday 29 September 2011 18:18:54 Guennadi Liakhovetski wrote:

[snip]

> diff --git a/drivers/media/video/soc_camera.c
> b/drivers/media/video/soc_camera.c index 2905a88..790c14c 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c

[snip]

> @@ -1361,9 +1402,11 @@ void soc_camera_host_unregister(struct
> soc_camera_host *ici) if (icd->iface == ici->nr &&
> to_soc_camera_control(icd))
>  			soc_camera_remove(icd);
> 
> -	mutex_unlock(&list_lock);
> +	soc_camera_mc_unregister(ici);
> 
>  	v4l2_device_unregister(&ici->v4l2_dev);
> +
> +	mutex_unlock(&list_lock);
>  }
>  EXPORT_SYMBOL(soc_camera_host_unregister);

Do soc_camera_mc_unregister() and v4l2_device_unregister() need to be 
protected by the mutex ?

> @@ -1443,7 +1486,6 @@ static int video_dev_create(struct soc_camera_device
> *icd)
> 
>  	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
> 
> -	vdev->parent		= icd->pdev;
>  	vdev->current_norm	= V4L2_STD_UNKNOWN;
>  	vdev->fops		= &soc_camera_fops;
>  	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
> @@ -1451,6 +1493,8 @@ static int video_dev_create(struct soc_camera_device
> *icd) vdev->tvnorms		= V4L2_STD_UNKNOWN;
>  	vdev->ctrl_handler	= &icd->ctrl_handler;
>  	vdev->lock		= &icd->video_lock;
> +	vdev->v4l2_dev		= &ici->v4l2_dev;
> +	video_set_drvdata(vdev, icd);
> 
>  	icd->vdev = vdev;

This is an important change, maybe you can move it to a patch of its own.

> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index d60bad4..0a21ff1 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h

[snip]

> @@ -63,6 +65,18 @@ struct soc_camera_host {
>  	void *priv;
>  	const char *drv_name;
>  	struct soc_camera_host_ops *ops;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct media_device mdev;
> +	struct v4l2_subdev bus_sd;
> +	struct media_pad bus_pads[2];
> +	struct media_pad vdev_pads[1];
> +#endif

Those fields are not used in this patch. Don't they belong to the next one ?

> +};
> +
> +enum soc_camera_target {
> +	SOCAM_TARGET_PIPELINE,
> +	SOCAM_TARGET_HOST_IN,
> +	SOCAM_TARGET_HOST_OUT,
>  };
> 
>  struct soc_camera_host_ops {

[snip]

> diff --git a/include/media/soc_entity.h b/include/media/soc_entity.h
> new file mode 100644
> index 0000000..e461f5e
> --- /dev/null
> +++ b/include/media/soc_entity.h
> @@ -0,0 +1,19 @@
> +/*
> + * soc-camera Media Controller wrapper
> + *
> + * Copyright (C) 2011, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef SOC_ENTITY_H
> +#define SOC_ENTITY_H
> +
> +#define soc_camera_mc_install(x) 0
> +#define soc_camera_mc_free(x) do {} while (0)
> +#define soc_camera_mc_register(x) do {} while (0)
> +#define soc_camera_mc_unregister(x) do {} while (0)

Doesn't this (and the corresponding changes to 
drivers/media/video/soc_camera.c) belong to the next patch ?

> +
> +#endif

-- 
Regards,

Laurent Pinchart

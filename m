Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:59064 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3FGJda (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 05:33:30 -0400
Date: Fri, 7 Jun 2013 11:33:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 05/13] soc_camera: replace vdev->parent by vdev->v4l2_dev.
In-Reply-To: <1370252210-4994-6-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1306071129580.11277@axis700.grange>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
 <1370252210-4994-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 3 Jun 2013, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The parent field will eventually disappear to be replaced by v4l2_dev.
> soc_camera does provide a v4l2_device struct but did not point to it in
> struct video_device. This is now fixed.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 96645e9..ea951ec 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -524,7 +524,7 @@ static int soc_camera_open(struct file *file)
>  		return -ENODEV;
>  	}
>  
> -	icd = dev_get_drvdata(vdev->parent);
> +	icd = dev_get_drvdata(vdev->v4l2_dev->dev);
>  	ici = to_soc_camera_host(icd->parent);
>  
>  	ret = try_module_get(ici->ops->owner) ? 0 : -ENODEV;
> @@ -1511,7 +1511,7 @@ static int video_dev_create(struct soc_camera_device *icd)
>  
>  	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
>  
> -	vdev->parent		= icd->pdev;
> +	vdev->v4l2_dev		= &ici->v4l2_dev;
>  	vdev->fops		= &soc_camera_fops;
>  	vdev->ioctl_ops		= &soc_camera_ioctl_ops;
>  	vdev->release		= video_device_release;

Doesn't it break soc-camera?... I think those are 2 absolutely different 
devices, so, you're not getting icd from 
dev_get_drvdata(vdev->v4l2_dev->dev).

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

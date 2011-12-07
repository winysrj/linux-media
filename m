Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49192 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1LGBTO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 20:19:14 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] V4L: cosmetic clean up
Date: Wed, 7 Dec 2011 02:19:21 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <Pine.LNX.4.64.1112061029430.10715@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1112061029430.10715@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112070219.21575.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Tuesday 06 December 2011 10:33:03 Guennadi Liakhovetski wrote:
> Improve the use of the WARN_ON() macro and use a local variable, instead
> of reduntantly dereferencing a pointer in v4l2-dev.c
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> diff --git a/drivers/media/video/v4l2-dev.c
> b/drivers/media/video/v4l2-dev.c index a5c9ed1..6a07d28 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -146,10 +146,9 @@ static void v4l2_device_release(struct device *cd)
>  	struct v4l2_device *v4l2_dev = vdev->v4l2_dev;
> 
>  	mutex_lock(&videodev_lock);
> -	if (video_device[vdev->minor] != vdev) {
> -		mutex_unlock(&videodev_lock);
> +	if (WARN_ON(video_device[vdev->minor] != vdev)) {
>  		/* should not happen */
> -		WARN_ON(1);
> +		mutex_unlock(&videodev_lock);
>  		return;
>  	}
> 
> @@ -168,7 +167,7 @@ static void v4l2_device_release(struct device *cd)
>  	mutex_unlock(&videodev_lock);
> 
>  #if defined(CONFIG_MEDIA_CONTROLLER)
> -	if (vdev->v4l2_dev && vdev->v4l2_dev->mdev &&
> +	if (v4l2_dev && v4l2_dev->mdev &&
>  	    vdev->vfl_type != VFL_TYPE_SUBDEV)
>  		media_device_unregister_entity(&vdev->entity);
>  #endif
> @@ -556,8 +555,7 @@ int __video_register_device(struct video_device *vdev,
> int type, int nr, vdev->minor = -1;
> 
>  	/* the release callback MUST be present */
> -	WARN_ON(!vdev->release);
> -	if (!vdev->release)
> +	if (WARN_ON(!vdev->release))
>  		return -EINVAL;
> 
>  	/* v4l2_fh support */

-- 
Regards,

Laurent Pinchart

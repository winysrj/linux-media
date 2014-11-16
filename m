Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52580 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398AbaKPMjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Nov 2014 07:39:03 -0500
Date: Sun, 16 Nov 2014 13:38:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Yoshihiro Kaneko <ykaneko0929@gmail.com>
cc: linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] media: soc_camera: Fix VIDIOC_S_CROP ioctl miscalculation
In-Reply-To: <1413267924-8273-1-git-send-email-ykaneko0929@gmail.com>
Message-ID: <Pine.LNX.4.64.1411161322100.18616@axis700.grange>
References: <1413267924-8273-1-git-send-email-ykaneko0929@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kaneko-san,

Sorry for a long delay.

On Tue, 14 Oct 2014, Yoshihiro Kaneko wrote:

> From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> 
> This patch corrects the miscalculation of the capture buffer
> size and clipping data update in VIDIOC_S_CROP sequence.
> 
> Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
> Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> ---
> 
> This patch is against master branch of linuxtv.org/media_tree.git.
> 
>  drivers/media/platform/soc_camera/rcar_vin.c       | 5 -----
>  drivers/media/platform/soc_camera/soc_scale_crop.c | 6 ++++--
>  2 files changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 61c36b0..5196c81 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1119,9 +1119,6 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
>  	cam->width = mf.width;
>  	cam->height = mf.height;
>  
> -	icd->user_width  = cam->width;
> -	icd->user_height = cam->height;
> -

Why are you removing these two? Is this related to your other patch, 
adding scaling to rcar_vin? If so, maybe this should go into that patch? 
Or at least these two patches should be in a patch series, if one depends 
on the other?

>  	cam->vin_left = rect->left & ~1;
>  	cam->vin_top = rect->top & ~1;
>  
> @@ -1130,8 +1127,6 @@ static int rcar_vin_set_crop(struct soc_camera_device *icd,
>  	if (ret < 0)
>  		return ret;
>  
> -	cam->subrect = *rect;
> -

You remove this, probably, because you added assignments to 
soc_scale_crop.c below, right?

>  	dev_dbg(dev, "VIN cropped to %ux%u@%u:%u\n",
>  		icd->user_width, icd->user_height,
>  		cam->vin_left, cam->vin_top);
> diff --git a/drivers/media/platform/soc_camera/soc_scale_crop.c b/drivers/media/platform/soc_camera/soc_scale_crop.c
> index 8e74fb7..7a1951a 100644
> --- a/drivers/media/platform/soc_camera/soc_scale_crop.c
> +++ b/drivers/media/platform/soc_camera/soc_scale_crop.c
> @@ -74,14 +74,14 @@ static void update_subrect(struct v4l2_rect *rect, struct v4l2_rect *subrect)
>  
>  	if (rect->left > subrect->left)
>  		subrect->left = rect->left;
> -	else if (rect->left + rect->width >
> +	else if (rect->left + rect->width <
>  		 subrect->left + subrect->width)
>  		subrect->left = rect->left + rect->width -
>  			subrect->width;
>  
>  	if (rect->top > subrect->top)
>  		subrect->top = rect->top;
> -	else if (rect->top + rect->height >
> +	else if (rect->top + rect->height <
>  		 subrect->top + subrect->height)
>  		subrect->top = rect->top + rect->height -
>  			subrect->height;

The above two are correct, I think.

> @@ -117,6 +117,7 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
>  		dev_dbg(dev, "Camera S_CROP successful for %dx%d@%d:%d\n",
>  			rect->width, rect->height, rect->left, rect->top);
>  		*target_rect = *cam_rect;
> +		*subrect = *rect;
>  		return 0;
>  	}
>  
> @@ -204,6 +205,7 @@ int soc_camera_client_s_crop(struct v4l2_subdev *sd,
>  
>  	if (!ret) {
>  		*target_rect = *cam_rect;
> +		*subrect = *rect;
>  		update_subrect(target_rect, subrect);
>  	}

The above two don't seem to be correct to me. Please, see 
Documentation/video4linux/sh_mobile_ceu_camera.txt for an explanation of 
the cropping and scaling algorithms. "subrect" is a result of both 
cropping and scaling, and mapping the camera host (DMA engine) output 
window back onto the camera sensor plane.

Thanks
Guennadi

>  
> -- 
> 1.9.1
> 

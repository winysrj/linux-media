Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36548 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757029Ab0EKGdO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 02:33:14 -0400
Date: Tue, 11 May 2010 08:33:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
cc: Linux-V4L2 <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera_platform: Add necessary v4l2_subdev_video_ops
 method
In-Reply-To: <upr13f0mn.wl%kuninori.morimoto.gx@renesas.com>
Message-ID: <Pine.LNX.4.64.1005110824330.5923@axis700.grange>
References: <upr13f0mn.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Morimoto-san

Thanks for testing and fixing this driver, but I think there's one slight 
issue with your patch:

On Tue, 11 May 2010, Kuninori Morimoto wrote:

> These function are needed to use camera.
> This patch was tested with sh_mobile_ceu_camera
> 
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> ---
>  drivers/media/video/soc_camera_platform.c |   39 +++++++++++++++++++++++++++++
>  1 files changed, 39 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
> index 10b003a..d36f732 100644
> --- a/drivers/media/video/soc_camera_platform.c
> +++ b/drivers/media/video/soc_camera_platform.c
> @@ -83,10 +83,49 @@ static int soc_camera_platform_enum_fmt(struct v4l2_subdev *sd, int index,
>  	return 0;
>  }
>  
> +static int soc_camera_platform_g_crop(struct v4l2_subdev *sd, struct v4l2_crop *a)
> +{
> +	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
> +
> +	a->c.left	= 0;
> +	a->c.top	= 0;
> +	a->c.width	= p->format.width;
> +	a->c.height	= p->format.height;
> +	a->type		= V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +	return 0;
> +}
> +
> +static int soc_camera_platform_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *a)
> +{
> +	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
> +
> +	a->bounds.left			= 0;
> +	a->bounds.top			= 0;
> +	a->bounds.width			= p->format.width;
> +	a->bounds.height		= p->format.height;
> +	a->defrect			= a->bounds;
> +	a->type				= V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	a->pixelaspect.numerator	= 1;
> +	a->pixelaspect.denominator	= 1;
> +
> +	return 0;
> +}
> +
> +static int soc_camera_platform_s_fmt(struct v4l2_subdev *sd,
> +				     struct v4l2_mbus_framefmt *mf)
> +{
> +	return 0;

This function needs not only return 0, but also fill fmt with the current 
pixel format.

> +}
> +
>  static struct v4l2_subdev_video_ops platform_subdev_video_ops = {
>  	.s_stream	= soc_camera_platform_s_stream,
>  	.try_mbus_fmt	= soc_camera_platform_try_fmt,
>  	.enum_mbus_fmt	= soc_camera_platform_enum_fmt,
> +	.cropcap	= soc_camera_platform_cropcap,
> +	.g_crop		= soc_camera_platform_g_crop,
> +	.g_mbus_fmt	= soc_camera_platform_try_fmt,
> +	.s_mbus_fmt	= soc_camera_platform_s_fmt,

Wouldn't

+	.s_mbus_fmt	= soc_camera_platform_try_fmt,

work here as well?

>  };
>  
>  static struct v4l2_subdev_ops platform_subdev_ops = {
> -- 
> 1.6.3.3

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

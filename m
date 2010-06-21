Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35086 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753696Ab0FUS0f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 14:26:35 -0400
Date: Mon, 21 Jun 2010 20:26:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera_platform: add set_fmt callback
In-Reply-To: <266c646d111590fda11bd3bbecfe49dea6789e4e.1277097465.git.baruch@tkos.co.il>
Message-ID: <Pine.LNX.4.64.1006212023001.6299@axis700.grange>
References: <266c646d111590fda11bd3bbecfe49dea6789e4e.1277097465.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 21 Jun 2010, Baruch Siach wrote:

> This allows the platform camera to arrange a change in the capture format.

Sorry, no. I don't like this. This driver is a very primitive piece of 
code, allowing you to bootstrap a camera in a most simple static way. We 
even were considering removing it from the kernel, because there's only 
one user currently in the mainline and, unfortunately, it is not very well 
maintained. So, you can use this driver as it is in the kernel now, 
bug-fixes are welcome. But if it isn't enough for you, this means you need 
a proper driver.

Thanks
Guennadi

> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  drivers/media/video/soc_camera_platform.c |    3 +++
>  include/media/soc_camera_platform.h       |    2 ++
>  2 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera_platform.c b/drivers/media/video/soc_camera_platform.c
> index 248c986..208fd42 100644
> --- a/drivers/media/video/soc_camera_platform.c
> +++ b/drivers/media/video/soc_camera_platform.c
> @@ -61,6 +61,9 @@ static int soc_camera_platform_try_fmt(struct v4l2_subdev *sd,
>  {
>  	struct soc_camera_platform_info *p = v4l2_get_subdevdata(sd);
>  
> +	if (p->try_fmt)
> +		return p->try_fmt(p, mf);
> +
>  	mf->width	= p->format.width;
>  	mf->height	= p->format.height;
>  	mf->code	= p->format.code;
> diff --git a/include/media/soc_camera_platform.h b/include/media/soc_camera_platform.h
> index 0ecefe2..0558ffc 100644
> --- a/include/media/soc_camera_platform.h
> +++ b/include/media/soc_camera_platform.h
> @@ -22,6 +22,8 @@ struct soc_camera_platform_info {
>  	struct v4l2_mbus_framefmt format;
>  	unsigned long bus_param;
>  	struct device *dev;
> +	int (*try_fmt)(struct soc_camera_platform_info *info,
> +			struct v4l2_mbus_framefmt *mf);
>  	int (*set_capture)(struct soc_camera_platform_info *info, int enable);
>  };
>  
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

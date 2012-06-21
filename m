Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:52810 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459Ab2FUM2G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jun 2012 08:28:06 -0400
Date: Thu, 21 Jun 2012 14:28:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/8] ov2640: Don't access the device in the g_mbus_fmt
 operation
In-Reply-To: <1337786855-28759-4-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1206211426520.3513@axis700.grange>
References: <1337786855-28759-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1337786855-28759-4-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

Thanks for the patch

On Wed, 23 May 2012, Laurent Pinchart wrote:

> The g_mbus_fmt operation only needs to return the current mbus frame
> format and doesn't need to configure the hardware to do so. Fix it to
> avoid requiring the chip to be powered on when calling the operation.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/ov2640.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
> index 3c2c5d3..d9a427c 100644
> --- a/drivers/media/video/ov2640.c
> +++ b/drivers/media/video/ov2640.c
> @@ -837,10 +837,7 @@ static int ov2640_g_fmt(struct v4l2_subdev *sd,
>  
>  	if (!priv->win) {
>  		u32 width = W_SVGA, height = H_SVGA;
> -		int ret = ov2640_set_params(client, &width, &height,
> -					    V4L2_MBUS_FMT_UYVY8_2X8);
> -		if (ret < 0)
> -			return ret;
> +		priv->win = ov2640_select_win(&width, &height);

I think you also have to set

		priv->cfmt_code = V4L2_MBUS_FMT_UYVY8_2X8;

Thanks
Guennadi

>  	}
>  
>  	mf->width	= priv->win->width;
> -- 
> 1.7.3.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

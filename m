Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49205 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab1GOXLc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 19:11:32 -0400
Date: Sat, 16 Jul 2011 01:11:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: mt9v032: Fix Bayer pattern
In-Reply-To: <1310761106-29722-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1107160109000.27399@axis700.grange>
References: <1310761106-29722-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 15 Jul 2011, Laurent Pinchart wrote:

> Compute crop rectangle boundaries to ensure a GRBG Bayer pattern.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/mt9v032.c |   20 ++++++++++----------
>  1 files changed, 10 insertions(+), 10 deletions(-)
> 
> If there's no comment I'll send a pull request for this patch in a couple of
> days.

Hm, I might have a comment: why?... Isn't it natural to accept the fact, 
that different sensors put a different Bayer pixel at their sensor matrix 
origin? Isn't that why we have all possible Bayer formats? Maybe you just 
have to choose a different output format?

Thanks
Guennadi

> 
> diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
> index 1319c2c..c64e1dc 100644
> --- a/drivers/media/video/mt9v032.c
> +++ b/drivers/media/video/mt9v032.c
> @@ -31,14 +31,14 @@
>  #define MT9V032_CHIP_VERSION				0x00
>  #define		MT9V032_CHIP_ID_REV1			0x1311
>  #define		MT9V032_CHIP_ID_REV3			0x1313
> -#define MT9V032_ROW_START				0x01
> -#define		MT9V032_ROW_START_MIN			4
> -#define		MT9V032_ROW_START_DEF			10
> -#define		MT9V032_ROW_START_MAX			482
> -#define MT9V032_COLUMN_START				0x02
> +#define MT9V032_COLUMN_START				0x01
>  #define		MT9V032_COLUMN_START_MIN		1
> -#define		MT9V032_COLUMN_START_DEF		2
> +#define		MT9V032_COLUMN_START_DEF		1
>  #define		MT9V032_COLUMN_START_MAX		752
> +#define MT9V032_ROW_START				0x02
> +#define		MT9V032_ROW_START_MIN			4
> +#define		MT9V032_ROW_START_DEF			5
> +#define		MT9V032_ROW_START_MAX			482
>  #define MT9V032_WINDOW_HEIGHT				0x03
>  #define		MT9V032_WINDOW_HEIGHT_MIN		1
>  #define		MT9V032_WINDOW_HEIGHT_DEF		480
> @@ -420,13 +420,13 @@ static int mt9v032_set_crop(struct v4l2_subdev *subdev,
>  	struct v4l2_rect *__crop;
>  	struct v4l2_rect rect;
>  
> -	/* Clamp the crop rectangle boundaries and align them to a multiple of 2
> -	 * pixels.
> +	/* Clamp the crop rectangle boundaries and align them to a non multiple
> +	 * of 2 pixels to ensure a GRBG Bayer pattern.
>  	 */
> -	rect.left = clamp(ALIGN(crop->rect.left, 2),
> +	rect.left = clamp(ALIGN(crop->rect.left + 1, 2) - 1,
>  			  MT9V032_COLUMN_START_MIN,
>  			  MT9V032_COLUMN_START_MAX);
> -	rect.top = clamp(ALIGN(crop->rect.top, 2),
> +	rect.top = clamp(ALIGN(crop->rect.top + 1, 2) - 1,
>  			 MT9V032_ROW_START_MIN,
>  			 MT9V032_ROW_START_MAX);
>  	rect.width = clamp(ALIGN(crop->rect.width, 2),
> -- 
> Regards,
> 
> Laurent Pinchart
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

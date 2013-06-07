Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63428 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3FGJgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jun 2013 05:36:16 -0400
Date: Fri, 7 Jun 2013 11:36:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 03/13] sh_vou: remove current_norm
In-Reply-To: <1370252210-4994-4-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1306071134590.11277@axis700.grange>
References: <1370252210-4994-1-git-send-email-hverkuil@xs4all.nl>
 <1370252210-4994-4-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

On Mon, 3 Jun 2013, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The current_norm field is deprecated and is replaced by g_std. This driver
> already implements g_std, so just remove current_norm.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Would you like to pull this via your tree? In that case

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Otherwise I can easily take it via mine.

Thanks
Guennadi

> ---
>  drivers/media/platform/sh_vou.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
> index 7d02350..84625fa 100644
> --- a/drivers/media/platform/sh_vou.c
> +++ b/drivers/media/platform/sh_vou.c
> @@ -1313,7 +1313,6 @@ static const struct video_device sh_vou_video_template = {
>  	.fops		= &sh_vou_fops,
>  	.ioctl_ops	= &sh_vou_ioctl_ops,
>  	.tvnorms	= V4L2_STD_525_60, /* PAL only supported in 8-bit non-bt656 mode */
> -	.current_norm	= V4L2_STD_NTSC_M,
>  	.vfl_dir	= VFL_DIR_TX,
>  };
>  
> @@ -1352,7 +1351,7 @@ static int sh_vou_probe(struct platform_device *pdev)
>  	pix = &vou_dev->pix;
>  
>  	/* Fill in defaults */
> -	vou_dev->std		= sh_vou_video_template.current_norm;
> +	vou_dev->std		= V4L2_STD_NTSC_M;
>  	rect->left		= 0;
>  	rect->top		= 0;
>  	rect->width		= VOU_MAX_IMAGE_WIDTH;
> -- 
> 1.7.10.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47949 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754639AbZFKK72 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 06:59:28 -0400
Date: Thu, 11 Jun 2009 12:59:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] soc_camera: Fix debug output of supported formats count
In-Reply-To: <77e3600851e692cb4ee9.1238662505@SCT-Book>
Message-ID: <Pine.LNX.4.64.0906111259160.5625@axis700.grange>
References: <77e3600851e692cb4ee9.1238662505@SCT-Book>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2 Apr 2009, Stefan Herbrechtsmeier wrote:

> The supported formats count must be set to 0 after debug output
> right before the second pass.
> 

Hi Stefan, could you please resend with your Sob?

Thanks
Guennadi

> diff --git a/linux/drivers/media/video/soc_camera.c b/linux/drivers/media/video/soc_camera.c
> --- a/linux/drivers/media/video/soc_camera.c
> +++ b/linux/drivers/media/video/soc_camera.c
> @@ -236,11 +236,11 @@ static int soc_camera_init_user_formats(
>  		return -ENOMEM;
>  
>  	icd->num_user_formats = fmts;
> -	fmts = 0;
>  
>  	dev_dbg(&icd->dev, "Found %d supported formats.\n", fmts);
>  
>  	/* Second pass - actually fill data formats */
> +	fmts = 0;
>  	for (i = 0; i < icd->num_formats; i++)
>  		if (!ici->ops->get_formats) {
>  			icd->user_formats[i].host_fmt = icd->formats + i;
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

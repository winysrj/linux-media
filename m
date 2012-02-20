Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49607 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab2BTSRQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 13:17:16 -0500
Date: Mon, 20 Feb 2012 19:17:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Fabio Estevam <festevam@gmail.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	kernel@pengutronix.de, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] video: mx3_camera: Allocate camera object via kzalloc
In-Reply-To: <1329761467-14417-1-git-send-email-festevam@gmail.com>
Message-ID: <Pine.LNX.4.64.1202201916410.2836@axis700.grange>
References: <1329761467-14417-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Feb 2012, Fabio Estevam wrote:

> Align mx3_camera driver with the other soc camera driver implementations
> by allocating the camera object via kzalloc.

Sorry, any specific reason, why you think this "aligning" is so important? 
I personally don't see any.

Thanks
Guennadi

> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/media/video/mx3_camera.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index 7452277..cccd574 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -1159,7 +1159,7 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
>  		goto egetres;
>  	}
>  
> -	mx3_cam = vzalloc(sizeof(*mx3_cam));
> +	mx3_cam = kzalloc(sizeof(*mx3_cam), GFP_KERNEL);
>  	if (!mx3_cam) {
>  		dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");
>  		err = -ENOMEM;
> -- 
> 1.7.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

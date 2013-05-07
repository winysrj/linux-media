Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:51664 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab3EGGwE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 May 2013 02:52:04 -0400
Date: Tue, 7 May 2013 08:52:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] soc_camera/mx1_camera: Fix warnings related to
 spacing
In-Reply-To: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
Message-ID: <Pine.LNX.4.64.1305070851360.31972@axis700.grange>
References: <1364965241-28225-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 3 Apr 2013, Sachin Kamat wrote:

> Fixes the following checkpatch warnings:
> WARNING: unnecessary whitespace before a quoted newline
> WARNING: please, no space before tabs
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, all 7 queued for 3.11

Guennadi

> ---
>  drivers/media/platform/soc_camera/mx1_camera.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
> index 4389f43..a3fd8d6 100644
> --- a/drivers/media/platform/soc_camera/mx1_camera.c
> +++ b/drivers/media/platform/soc_camera/mx1_camera.c
> @@ -776,7 +776,7 @@ static int __init mx1_camera_probe(struct platform_device *pdev)
>  	/* request irq */
>  	err = claim_fiq(&fh);
>  	if (err) {
> -		dev_err(&pdev->dev, "Camera interrupt register failed \n");
> +		dev_err(&pdev->dev, "Camera interrupt register failed\n");
>  		goto exit_free_dma;
>  	}
>  
> @@ -853,7 +853,7 @@ static int __exit mx1_camera_remove(struct platform_device *pdev)
>  }
>  
>  static struct platform_driver mx1_camera_driver = {
> -	.driver 	= {
> +	.driver		= {
>  		.name	= DRIVER_NAME,
>  	},
>  	.remove		= __exit_p(mx1_camera_remove),
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

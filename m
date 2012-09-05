Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2IEMCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 08:02:54 -0400
Date: Wed, 5 Sep 2012 14:02:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 1/2] [media] soc_camera: Use devm_kzalloc function
In-Reply-To: <1346844327-5524-1-git-send-email-sachin.kamat@linaro.org>
Message-ID: <Pine.LNX.4.64.1209051402250.16676@axis700.grange>
References: <1346844327-5524-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 5 Sep 2012, Sachin Kamat wrote:

> devm_kzalloc() has been used to simplify error handling.
> While at it, the soc_camera_device_register function has been moved to
> save a few lines of code and a variable.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks, both queued.

Guennadi

> ---
>  drivers/media/platform/soc_camera/soc_camera.c |   15 ++-------------
>  1 files changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 10b57f8..acf5289 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1529,12 +1529,11 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
>  {
>  	struct soc_camera_link *icl = pdev->dev.platform_data;
>  	struct soc_camera_device *icd;
> -	int ret;
>  
>  	if (!icl)
>  		return -EINVAL;
>  
> -	icd = kzalloc(sizeof(*icd), GFP_KERNEL);
> +	icd = devm_kzalloc(&pdev->dev, sizeof(*icd), GFP_KERNEL);
>  	if (!icd)
>  		return -ENOMEM;
>  
> @@ -1543,19 +1542,11 @@ static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
>  	icd->pdev = &pdev->dev;
>  	platform_set_drvdata(pdev, icd);
>  
> -	ret = soc_camera_device_register(icd);
> -	if (ret < 0)
> -		goto escdevreg;
>  
>  	icd->user_width		= DEFAULT_WIDTH;
>  	icd->user_height	= DEFAULT_HEIGHT;
>  
> -	return 0;
> -
> -escdevreg:
> -	kfree(icd);
> -
> -	return ret;
> +	return soc_camera_device_register(icd);
>  }
>  
>  /*
> @@ -1572,8 +1563,6 @@ static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
>  
>  	list_del(&icd->list);
>  
> -	kfree(icd);
> -
>  	return 0;
>  }
>  
> -- 
> 1.7.4.1
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

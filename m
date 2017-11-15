Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:44170 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932928AbdKOXeg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 18:34:36 -0500
Received: by mail-lf0-f65.google.com with SMTP id i14so212711lfc.1
        for <linux-media@vger.kernel.org>; Wed, 15 Nov 2017 15:34:35 -0800 (PST)
From: "Niklas =?iso-8859-1?Q?S=F6derlund?=" <niklas.soderlund@ragnatech.se>
Date: Thu, 16 Nov 2017 00:34:33 +0100
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] v4l: rcar-vin: Implement V4L2 video node release handler
Message-ID: <20171115233433.GL12677@bigcity.dyn.berto.se>
References: <20171115224907.392-1-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171115224907.392-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for your patch.

On 2017-11-16 00:49:07 +0200, Laurent Pinchart wrote:
> The rvin_dev data structure contains driver private data for an instance
> of the VIN. It is allocated dynamically at probe time, and must be freed
> once all users are gone.
> 
> The structure is currently allocated with devm_kzalloc(), which results
> in memory being freed when the device is unbound. If a userspace
> application is currently performing an ioctl call, or just keeps the
> device node open and closes it later, this will lead to accessing freed
> memory.
> 
> Fix the problem by implementing a V4L2 release handler for the video
> node associated with the VIN instance (called when the last user of the
> video node releases it), and freeing memory explicitly from the release
> handler.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

This patch is based on-top of the VIN Gen3 enablement series not yet 
upstream. This is OK for me, just wanted to check that this was the 
intention as to minimize conflicts between the two.

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 29 +++++++++++++++++++----------
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  9 ++++++++-
>  2 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 495610949457..bd7976efa1fb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -1208,7 +1208,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  	struct resource *mem;
>  	int irq, ret;
>  
> -	vin = devm_kzalloc(&pdev->dev, sizeof(*vin), GFP_KERNEL);
> +	vin = kzalloc(sizeof(*vin), GFP_KERNEL);
>  	if (!vin)
>  		return -ENOMEM;
>  
> @@ -1224,20 +1224,26 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  		vin->info = attr->data;
>  
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (mem == NULL)
> -		return -EINVAL;
> +	if (mem == NULL) {
> +		ret = -EINVAL;
> +		goto error_free;
> +	}
>  
>  	vin->base = devm_ioremap_resource(vin->dev, mem);
> -	if (IS_ERR(vin->base))
> -		return PTR_ERR(vin->base);
> +	if (IS_ERR(vin->base)) {
> +		ret = PTR_ERR(vin->base);
> +		goto error_free;
> +	}
>  
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq < 0)
> -		return irq;
> +	if (irq < 0) {
> +		ret = irq;
> +		goto error_free;
> +	}
>  
>  	ret = rvin_dma_probe(vin, irq);
>  	if (ret)
> -		return ret;
> +		goto error_free;
>  
>  	platform_set_drvdata(pdev, vin);
>  	if (vin->info->use_mc)
> @@ -1245,15 +1251,18 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  	else
>  		ret = rvin_digital_graph_init(vin);
>  	if (ret < 0)
> -		goto error;
> +		goto error_dma;
>  
>  	pm_suspend_ignore_children(&pdev->dev, true);
>  	pm_runtime_enable(&pdev->dev);
>  
>  	return 0;
> -error:
> +
> +error_dma:
>  	rvin_dma_remove(vin);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
> +error_free:
> +	kfree(vin);
>  
>  	return ret;
>  }
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index 2c14d44950b2..25f1d24c1d2d 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -1026,6 +1026,13 @@ static void rvin_notify(struct v4l2_subdev *sd,
>  	}
>  }
>  
> +static void rvin_v4l2_release(struct video_device *vdev)
> +{
> +	struct rvin_dev *vin = container_of(vdev, struct rvin_dev, vdev);
> +
> +	kfree(vin);
> +}
> +
>  int rvin_v4l2_register(struct rvin_dev *vin)
>  {
>  	struct video_device *vdev = &vin->vdev;
> @@ -1038,7 +1045,7 @@ int rvin_v4l2_register(struct rvin_dev *vin)
>  	vdev->queue = &vin->queue;
>  	snprintf(vdev->name, sizeof(vdev->name), "%s %s", KBUILD_MODNAME,
>  		 dev_name(vin->dev));
> -	vdev->release = video_device_release_empty;
> +	vdev->release = rvin_v4l2_release;
>  	vdev->lock = &vin->lock;
>  	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>  		V4L2_CAP_READWRITE;
> -- 
> Regards,
> 
> Laurent Pinchart
> 

-- 
Regards,
Niklas Söderlund

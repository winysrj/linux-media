Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:41908 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752264AbdK3RzM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 12:55:12 -0500
Subject: Re: [PATCH v8 02/28] rcar-vin: rename poorly named initialize and
 cleanup functions
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20171129194342.26239-1-niklas.soderlund+renesas@ragnatech.se>
 <20171129194342.26239-3-niklas.soderlund+renesas@ragnatech.se>
From: Kieran Bingham <kieranbingham@gmail.com>
Message-ID: <681b2aa1-e80b-e485-984d-95606a40ed3a@gmail.com>
Date: Thu, 30 Nov 2017 17:55:08 +0000
MIME-Version: 1.0
In-Reply-To: <20171129194342.26239-3-niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Niklas,

If relevant I believe you could have a Tested-by: tag from me on this series now
that I have capture working on the Eagle-V3M. I'll let you decide on that though.

On 29/11/17 19:43, Niklas Söderlund wrote:
> The functions to initialize and cleanup the hardware and video device
> where poorly named from the start. Rename them to better describe there

s/describe there/describe their/

> intended function.
> 
> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

Other than the spelling above, the rename looks good to me.

Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 10 +++++-----
>  drivers/media/platform/rcar-vin/rcar-dma.c  |  6 +++---
>  drivers/media/platform/rcar-vin/rcar-v4l2.c |  4 ++--
>  drivers/media/platform/rcar-vin/rcar-vin.h  |  8 ++++----
>  4 files changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index 108d776f32651b27..f7a4c21909da6923 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -93,7 +93,7 @@ static int rvin_digital_notify_complete(struct v4l2_async_notifier *notifier)
>  		return ret;
>  	}
>  
> -	return rvin_v4l2_probe(vin);
> +	return rvin_v4l2_register(vin);
>  }
>  
>  static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
> @@ -103,7 +103,7 @@ static void rvin_digital_notify_unbind(struct v4l2_async_notifier *notifier,
>  	struct rvin_dev *vin = notifier_to_vin(notifier);
>  
>  	vin_dbg(vin, "unbind digital subdev %s\n", subdev->name);
> -	rvin_v4l2_remove(vin);
> +	rvin_v4l2_unregister(vin);
>  	vin->digital->subdev = NULL;
>  }
>  
> @@ -245,7 +245,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return irq;
>  
> -	ret = rvin_dma_probe(vin, irq);
> +	ret = rvin_dma_register(vin, irq);
>  	if (ret)
>  		return ret;
>  
> @@ -260,7 +260,7 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  
>  	return 0;
>  error:
> -	rvin_dma_remove(vin);
> +	rvin_dma_unregister(vin);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>  
>  	return ret;
> @@ -275,7 +275,7 @@ static int rcar_vin_remove(struct platform_device *pdev)
>  	v4l2_async_notifier_unregister(&vin->notifier);
>  	v4l2_async_notifier_cleanup(&vin->notifier);
>  
> -	rvin_dma_remove(vin);
> +	rvin_dma_unregister(vin);
>  
>  	return 0;
>  }
> diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
> index 23fdff7a7370842e..d701b52d198243b5 100644
> --- a/drivers/media/platform/rcar-vin/rcar-dma.c
> +++ b/drivers/media/platform/rcar-vin/rcar-dma.c
> @@ -1153,14 +1153,14 @@ static const struct vb2_ops rvin_qops = {
>  	.wait_finish		= vb2_ops_wait_finish,
>  };
>  
> -void rvin_dma_remove(struct rvin_dev *vin)
> +void rvin_dma_unregister(struct rvin_dev *vin)
>  {
>  	mutex_destroy(&vin->lock);
>  
>  	v4l2_device_unregister(&vin->v4l2_dev);
>  }
>  
> -int rvin_dma_probe(struct rvin_dev *vin, int irq)
> +int rvin_dma_register(struct rvin_dev *vin, int irq)
>  {
>  	struct vb2_queue *q = &vin->queue;
>  	int i, ret;
> @@ -1208,7 +1208,7 @@ int rvin_dma_probe(struct rvin_dev *vin, int irq)
>  
>  	return 0;
>  error:
> -	rvin_dma_remove(vin);
> +	rvin_dma_unregister(vin);
>  
>  	return ret;
>  }
> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> index b479b882da12f62d..178aecc94962abe2 100644
> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
> @@ -839,7 +839,7 @@ static const struct v4l2_file_operations rvin_fops = {
>  	.read		= vb2_fop_read,
>  };
>  
> -void rvin_v4l2_remove(struct rvin_dev *vin)
> +void rvin_v4l2_unregister(struct rvin_dev *vin)
>  {
>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
>  		  video_device_node_name(&vin->vdev));
> @@ -866,7 +866,7 @@ static void rvin_notify(struct v4l2_subdev *sd,
>  	}
>  }
>  
> -int rvin_v4l2_probe(struct rvin_dev *vin)
> +int rvin_v4l2_register(struct rvin_dev *vin)
>  {
>  	struct video_device *vdev = &vin->vdev;
>  	struct v4l2_subdev *sd = vin_to_source(vin);
> diff --git a/drivers/media/platform/rcar-vin/rcar-vin.h b/drivers/media/platform/rcar-vin/rcar-vin.h
> index 5382078143fb3869..85cb7ec53d2b08b5 100644
> --- a/drivers/media/platform/rcar-vin/rcar-vin.h
> +++ b/drivers/media/platform/rcar-vin/rcar-vin.h
> @@ -153,11 +153,11 @@ struct rvin_dev {
>  #define vin_warn(d, fmt, arg...)	dev_warn(d->dev, fmt, ##arg)
>  #define vin_err(d, fmt, arg...)		dev_err(d->dev, fmt, ##arg)
>  
> -int rvin_dma_probe(struct rvin_dev *vin, int irq);
> -void rvin_dma_remove(struct rvin_dev *vin);
> +int rvin_dma_register(struct rvin_dev *vin, int irq);
> +void rvin_dma_unregister(struct rvin_dev *vin);
>  
> -int rvin_v4l2_probe(struct rvin_dev *vin);
> -void rvin_v4l2_remove(struct rvin_dev *vin);
> +int rvin_v4l2_register(struct rvin_dev *vin);
> +void rvin_v4l2_unregister(struct rvin_dev *vin);
>  
>  const struct rvin_video_format *rvin_format_from_pixel(u32 pixelformat);
>  
> 

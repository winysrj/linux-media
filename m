Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57378 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3G2JMC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 05:12:02 -0400
Message-id: <51F631DC.8060208@samsung.com>
Date: Mon, 29 Jul 2013 11:11:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	k.debski@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH] [media] exynos-gsc: Register v4l2 device
References: <1374838081-27308-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1374838081-27308-1-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

On 07/26/2013 01:28 PM, Arun Kumar K wrote:
> Gscaler video device registration was happening without
> reference to a parent v4l2_dev causing probe to fail.
> The patch creates a parent v4l2 device and uses it for
> gsc m2m video device registration.


I've queued this patch for v3.11-rc as a regression fix, adding
the following to the changelog:

"This fixes regression introduced with comit commit 1c1d86a1ea07506
[media] v4l2: always require v4l2_dev, rename parent to dev_parent"

But please note that this patch will likely need to be reverted once
capture support is added the GScaler. Then a top level media device
would register struct v4l2_device, instead of the video M2M device
device driver.


Thanks,
Sylwester

> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
>
> ---
>  drivers/media/platform/exynos-gsc/gsc-core.c |    9 ++++++++-
>  drivers/media/platform/exynos-gsc/gsc-core.h |    1 +
>  drivers/media/platform/exynos-gsc/gsc-m2m.c  |    1 +
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
> index 559fab2..1ec60264 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.c
> @@ -1122,10 +1122,14 @@ static int gsc_probe(struct platform_device *pdev)
>  		goto err_clk;
>  	}
>  
> -	ret = gsc_register_m2m_device(gsc);
> +	ret = v4l2_device_register(dev, &gsc->v4l2_dev);
>  	if (ret)
>  		goto err_clk;
>  
> +	ret = gsc_register_m2m_device(gsc);
> +	if (ret)
> +		goto err_v4l2;
> +
>  	platform_set_drvdata(pdev, gsc);
>  	pm_runtime_enable(dev);
>  	ret = pm_runtime_get_sync(&pdev->dev);
> @@ -1147,6 +1151,8 @@ err_pm:
>  	pm_runtime_put(dev);
>  err_m2m:
>  	gsc_unregister_m2m_device(gsc);
> +err_v4l2:
> +	v4l2_device_unregister(&gsc->v4l2_dev);
>  err_clk:
>  	gsc_clk_put(gsc);
>  	return ret;
> @@ -1157,6 +1163,7 @@ static int gsc_remove(struct platform_device *pdev)
>  	struct gsc_dev *gsc = platform_get_drvdata(pdev);
>  
>  	gsc_unregister_m2m_device(gsc);
> +	v4l2_device_unregister(&gsc->v4l2_dev);
>  
>  	vb2_dma_contig_cleanup_ctx(gsc->alloc_ctx);
>  	pm_runtime_disable(&pdev->dev);
> diff --git a/drivers/media/platform/exynos-gsc/gsc-core.h b/drivers/media/platform/exynos-gsc/gsc-core.h
> index cc19bba..76435d3 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-core.h
> +++ b/drivers/media/platform/exynos-gsc/gsc-core.h
> @@ -343,6 +343,7 @@ struct gsc_dev {
>  	unsigned long			state;
>  	struct vb2_alloc_ctx		*alloc_ctx;
>  	struct video_device		vdev;
> +	struct v4l2_device		v4l2_dev;
>  };
>  
>  /**
> diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> index 40a73f7..e576ff2 100644
> --- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
> +++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
> @@ -751,6 +751,7 @@ int gsc_register_m2m_device(struct gsc_dev *gsc)
>  	gsc->vdev.release	= video_device_release_empty;
>  	gsc->vdev.lock		= &gsc->lock;
>  	gsc->vdev.vfl_dir	= VFL_DIR_M2M;
> +	gsc->vdev.v4l2_dev	= &gsc->v4l2_dev;
>  	snprintf(gsc->vdev.name, sizeof(gsc->vdev.name), "%s.%d:m2m",
>  					GSC_MODULE_NAME, gsc->id);

-- 
Sylwester Nawrocki
Samsung R&D Institute Poland

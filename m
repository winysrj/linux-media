Return-path: <mchehab@pedra>
Received: from mailout2.samsung.com ([203.254.224.25]:40383 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1DFAhS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Apr 2011 20:37:18 -0400
Date: Wed, 06 Apr 2011 09:37:09 +0900
From: Jonghun Han <jonghun.han@samsung.com>
Subject: RE: [PATCH 5/7] v4l: s5p-fimc: add pm_runtime support
In-reply-to: <1302012410-17984-6-git-send-email-m.szyprowski@samsung.com>
To: 'Marek Szyprowski' <m.szyprowski@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Andrzej Pietrasiwiecz' <andrzej.p@samsung.com>,
	'Sylwester Nawrocki' <s.nawrocki@samsung.com>,
	'Arnd Bergmann' <arnd@arndb.de>,
	'Kukjin Kim' <kgene.kim@samsung.com>,
	=?ks_c_5601-1987?B?J7DtwOe47Sc=?= <jemings@samsung.com>
Message-id: <007c01cbf3f2$c6e7b420$54b71c60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-language: ko
Content-transfer-encoding: 7BIT
References: <1302012410-17984-1-git-send-email-m.szyprowski@samsung.com>
 <1302012410-17984-6-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

AALQBmAGkAbQBjADoAIA
	BhAGQAZAAgAHAAbQBfAHIAdQBuAHQAaQBtAGUAIABzAHUAcABwAG8AcgB0AA==
x-cr-puzzleid: {0DF5696E-C27B-4620-A41E-B97F4C401FEA}


Hi Marek,

runtime_pm is used to minimize current.
In my opinion, the followings will be better.
1. Adds pm_runtime_get_sync before running of the first job.
   IMO, dma_run callback function is the best place for calling in case of
M2M.
2. And then in the ISR, call pm_runtime_put_sync in the ISR bottom-half if
there is no remained job.

I had already implemented and tested.
But it remained code cleanup. I hope I can post it on the next week.

Best regards,
Jonghun Han

On Tuesday, April 05, 2011 11:07 PM Marek Szyprowski wrote:
> This patch adds basic support for pm_runtime to s5p-fimc driver. PM
runtime
> support is required to enable the driver on S5PV310 series with power
domain
> driver enabled.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/video/s5p-fimc/fimc-capture.c |    5 +++++
>  drivers/media/video/s5p-fimc/fimc-core.c    |   14 ++++++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-capture.c
> b/drivers/media/video/s5p-fimc/fimc-capture.c
> index 95f8b4e1..f697ed1 100644
> --- a/drivers/media/video/s5p-fimc/fimc-capture.c
> +++ b/drivers/media/video/s5p-fimc/fimc-capture.c
> @@ -18,6 +18,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/device.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/list.h>
>  #include <linux/slab.h>
>  #include <linux/clk.h>
> @@ -398,6 +399,8 @@ static int fimc_capture_open(struct file *file)
>  	if (fimc_m2m_active(fimc))
>  		return -EBUSY;
> 
> +	pm_runtime_get_sync(&fimc->pdev->dev);
> +
>  	if (++fimc->vid_cap.refcnt == 1) {
>  		ret = fimc_isp_subdev_init(fimc, 0);
>  		if (ret) {
> @@ -428,6 +431,8 @@ static int fimc_capture_close(struct file *file)
>  		fimc_subdev_unregister(fimc);
>  	}
> 
> +	pm_runtime_put_sync(&fimc->pdev->dev);
> +
>  	return 0;
>  }
> 
> diff --git a/drivers/media/video/s5p-fimc/fimc-core.c
> b/drivers/media/video/s5p-fimc/fimc-core.c
> index 6c919b3..ead5c0a 100644
> --- a/drivers/media/video/s5p-fimc/fimc-core.c
> +++ b/drivers/media/video/s5p-fimc/fimc-core.c
> @@ -20,6 +20,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/device.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/list.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> @@ -1410,6 +1411,8 @@ static int fimc_m2m_open(struct file *file)
>  	if (fimc->vid_cap.refcnt > 0)
>  		return -EBUSY;
> 
> +	pm_runtime_get_sync(&fimc->pdev->dev);
> +
>  	fimc->m2m.refcnt++;
>  	set_bit(ST_OUTDMA_RUN, &fimc->state);
> 
> @@ -1452,6 +1455,8 @@ static int fimc_m2m_release(struct file *file)
>  	if (--fimc->m2m.refcnt <= 0)
>  		clear_bit(ST_OUTDMA_RUN, &fimc->state);
> 
> +	pm_runtime_put_sync(&fimc->pdev->dev);
> +
>  	return 0;
>  }
> 
> @@ -1649,6 +1654,11 @@ static int fimc_probe(struct platform_device *pdev)
>  		goto err_req_region;
>  	}
> 
> +	pm_runtime_set_active(&pdev->dev);
> +	pm_runtime_enable(&pdev->dev);
> +
> +	pm_runtime_get_sync(&pdev->dev);
> +
>  	fimc->num_clocks = MAX_FIMC_CLOCKS - 1;
> 
>  	/* Check if a video capture node needs to be registered. */ @@ -
1706,6
> +1716,8 @@ static int fimc_probe(struct platform_device *pdev)
>  	dev_dbg(&pdev->dev, "%s(): fimc-%d registered successfully\n",
>  		__func__, fimc->id);
> 
> +	pm_runtime_put_sync(&pdev->dev);
> +
>  	return 0;
> 
>  err_m2m:
> @@ -1740,6 +1752,8 @@ static int __devexit fimc_remove(struct
platform_device
> *pdev)
> 
>  	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
> 
> +	pm_runtime_disable(&pdev->dev);
> +
>  	iounmap(fimc->regs);
>  	release_resource(fimc->regs_res);
>  	kfree(fimc->regs_res);
> --
> 1.7.1.569.g6f426
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


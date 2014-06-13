Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53938 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaFMQ4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:56:21 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N740092J9PQX810@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 13 Jun 2014 17:56:14 +0100 (BST)
Message-id: <539B2D30.8080301@samsung.com>
Date: Fri, 13 Jun 2014 18:56:16 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de
Subject: Re: [PATCH 12/30] [media] coda: Add runtime pm support
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
 <1402675736-15379-13-git-send-email-p.zabel@pengutronix.de>
In-reply-to: <1402675736-15379-13-git-send-email-p.zabel@pengutronix.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Philipp,

On 13/06/14 18:08, Philipp Zabel wrote:
> This patch allows to use the runtime pm and generic pm domain frameworks
> to completely gate power to the VPU if it is unused. This functionality
> is available on i.MX6.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/platform/coda.c | 65 +++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 60 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> index 8321243..f39f693 100644
> --- a/drivers/media/platform/coda.c
> +++ b/drivers/media/platform/coda.c
> @@ -22,6 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
>  #include <linux/of.h>
> @@ -2820,6 +2821,13 @@ static int coda_open(struct file *file)
>  		ctx->reg_idx = idx;
>  	}
>  
> +	/* Power up and upload firmware if necessary */
> +	ret = pm_runtime_get_sync(&dev->plat_dev->dev);
> +	if (ret < 0) {
> +		v4l2_err(&dev->v4l2_dev, "failed to power up: %d\n", ret);
> +		goto err_pm_get;
> +	}
> +
>  	ret = clk_prepare_enable(dev->clk_per);
>  	if (ret)
>  		goto err_clk_per;
> @@ -2889,6 +2897,8 @@ err_ctx_init:
>  err_clk_ahb:
>  	clk_disable_unprepare(dev->clk_per);
>  err_clk_per:
> +	pm_runtime_put_sync(&dev->plat_dev->dev);
> +err_pm_get:
>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);
>  	clear_bit(ctx->idx, &dev->instance_mask);
> @@ -2930,6 +2940,7 @@ static int coda_release(struct file *file)
>  	v4l2_ctrl_handler_free(&ctx->ctrls);
>  	clk_disable_unprepare(dev->clk_ahb);
>  	clk_disable_unprepare(dev->clk_per);
> +	pm_runtime_put_sync(&dev->plat_dev->dev);
>  	v4l2_fh_del(&ctx->fh);
>  	v4l2_fh_exit(&ctx->fh);
>  	clear_bit(ctx->idx, &dev->instance_mask);
> @@ -3243,7 +3254,7 @@ static int coda_hw_init(struct coda_dev *dev)
>  
>  	ret = clk_prepare_enable(dev->clk_per);
>  	if (ret)
> -		return ret;
> +		goto err_clk_per;
>  
>  	ret = clk_prepare_enable(dev->clk_ahb);
>  	if (ret)
> @@ -3369,6 +3380,7 @@ static int coda_hw_init(struct coda_dev *dev)
>  
>  err_clk_ahb:
>  	clk_disable_unprepare(dev->clk_per);
> +err_clk_per:
>  	return ret;
>  }
>  
> @@ -3394,10 +3406,29 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
>  	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
>  	release_firmware(fw);
>  
> -	ret = coda_hw_init(dev);
> -	if (ret) {
> -		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
> -		return;
> +	if (IS_ENABLED(CONFIG_PM_RUNTIME) && pdev->dev.pm_domain) {

How about using the pm_runtime_enabled() helper ? Also why do you need to
be checking dev.pm_domain here and in the resume() callback ? Couldn't it 
be done unconditionally ? Why the driver needs to care about the PM domain
existence ?

> +		/*
> +		 * Enabling power temporarily will cause coda_hw_init to be
> +		 * called via coda_runtime_resume by the pm domain.
> +		 */
> +		ret = pm_runtime_get_sync(&dev->plat_dev->dev);
> +		if (ret < 0) {
> +			v4l2_err(&dev->v4l2_dev, "failed to power on: %d\n",
> +				 ret);
> +			return;
> +		}
> +
> +		pm_runtime_put_sync(&dev->plat_dev->dev);
> +	} else {
> +		/*
> +		 * If runtime pm is disabled or pm_domain is not set,
> +		 * initialize once manually.
> +		 */
> +		ret = coda_hw_init(dev);
> +		if (ret < 0) {
> +			v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
> +			return;
> +		}
>  	}
>  
>  	dev->vfd.fops	= &coda_fops,
> @@ -3635,6 +3666,8 @@ static int coda_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, dev);
>  
> +	pm_runtime_enable(&pdev->dev);
> +
>  	return coda_firmware_request(dev);
>  }
>  
> @@ -3645,6 +3678,7 @@ static int coda_remove(struct platform_device *pdev)
>  	video_unregister_device(&dev->vfd);
>  	if (dev->m2m_dev)
>  		v4l2_m2m_release(dev->m2m_dev);
> +	pm_runtime_disable(&pdev->dev);
>  	if (dev->alloc_ctx)
>  		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
>  	v4l2_device_unregister(&dev->v4l2_dev);
> @@ -3658,6 +3692,26 @@ static int coda_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
> +static int coda_runtime_resume(struct device *dev)
> +{
> +	struct coda_dev *cdev = dev_get_drvdata(dev);
> +	int ret = 0;
> +
> +	if (dev->pm_domain) {
> +		ret = coda_hw_init(cdev);
> +		if (ret)
> +			v4l2_err(&cdev->v4l2_dev, "HW initialization failed\n");
> +	}
> +
> +	return ret;
> +}
> +#endif

--
Regards,
Sylwester

Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60758 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbbCEKgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2015 05:36:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/3] media: atmel-isi: add runtime pm support
Date: Thu, 05 Mar 2015 12:36:58 +0200
Message-ID: <4374983.hs3Q8DJocG@avalon>
In-Reply-To: <1425531661-20040-3-git-send-email-josh.wu@atmel.com>
References: <1425531661-20040-1-git-send-email-josh.wu@atmel.com> <1425531661-20040-3-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Thursday 05 March 2015 13:01:00 Josh Wu wrote:
> The runtime pm resume/suspend will enable/disable pclk (ISI peripheral
> clock).
> And we need to call rumtime_pm_get/put_sync function to make pm
> resume/suspend.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> ---
> 
>  drivers/media/platform/soc_camera/atmel-isi.c | 36 +++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> b/drivers/media/platform/soc_camera/atmel-isi.c index eb179e7..4a384f1
> 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -20,6 +20,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/slab.h>
> 
>  #include <media/atmel-isi.h>
> @@ -386,9 +387,7 @@ static int start_streaming(struct vb2_queue *vq,
> unsigned int count) struct atmel_isi *isi = ici->priv;
>  	int ret;
> 
> -	ret = clk_prepare_enable(isi->pclk);
> -	if (ret)
> -		return ret;
> +	pm_runtime_get_sync(ici->v4l2_dev.dev);
> 
>  	/* Reset ISI */
>  	ret = atmel_isi_wait_status(isi, WAIT_ISI_RESET);
> @@ -450,7 +449,7 @@ static void stop_streaming(struct vb2_queue *vq)
>  	if (ret < 0)
>  		dev_err(icd->parent, "Disable ISI timed out\n");
> 
> -	clk_disable_unprepare(isi->pclk);
> +	pm_runtime_put_sync(ici->v4l2_dev.dev);

Is there a reason to use pm_runtime_put_sync() and not just pm_runtime_put() ?

>  }
> 
>  static struct vb2_ops isi_video_qops = {
> @@ -1042,6 +1041,9 @@ static int atmel_isi_probe(struct platform_device
> *pdev) soc_host->v4l2_dev.dev	= &pdev->dev;
>  	soc_host->nr		= pdev->id;
> 
> +	pm_suspend_ignore_children(&pdev->dev, true);
> +	pm_runtime_enable(&pdev->dev);
> +
>  	if (isi->pdata.asd_sizes) {
>  		soc_host->asd = isi->pdata.asd;
>  		soc_host->asd_sizes = isi->pdata.asd_sizes;
> @@ -1055,6 +1057,7 @@ static int atmel_isi_probe(struct platform_device
> *pdev) return 0;
> 
>  err_register_soc_camera_host:
> +	pm_runtime_disable(&pdev->dev);
>  err_req_irq:
>  err_ioremap:
>  	vb2_dma_contig_cleanup_ctx(isi->alloc_ctx);
> @@ -1067,6 +1070,30 @@ err_alloc_ctx:
>  	return ret;
>  }
> 
> +static int atmel_isi_runtime_suspend(struct device *dev)
> +{
> +	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
> +	struct atmel_isi *isi = container_of(soc_host,
> +					struct atmel_isi, soc_host);
> +
> +	clk_disable_unprepare(isi->pclk);
> +
> +	return 0;
> +}
> +static int atmel_isi_runtime_resume(struct device *dev)
> +{
> +	struct soc_camera_host *soc_host = to_soc_camera_host(dev);
> +	struct atmel_isi *isi = container_of(soc_host,
> +					struct atmel_isi, soc_host);
> +
> +	return clk_prepare_enable(isi->pclk);
> +}
> +
> +static const struct dev_pm_ops atmel_isi_dev_pm_ops = {
> +	SET_RUNTIME_PM_OPS(atmel_isi_runtime_suspend,
> +				atmel_isi_runtime_resume, NULL)
> +};
> +
>  static const struct of_device_id atmel_isi_of_match[] = {
>  	{ .compatible = "atmel,at91sam9g45-isi" },
>  	{ }
> @@ -1079,6 +1106,7 @@ static struct platform_driver atmel_isi_driver = {
>  		.name = "atmel_isi",
>  		.owner = THIS_MODULE,
>  		.of_match_table = of_match_ptr(atmel_isi_of_match),
> +		.pm	= &atmel_isi_dev_pm_ops,
>  	},
>  };

-- 
Regards,

Laurent Pinchart


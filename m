Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45261 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab1KVU4G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Nov 2011 15:56:06 -0500
Date: Tue, 22 Nov 2011 21:55:52 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	m.szyprowski@samsung.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, shawn.guo@linaro.org,
	richard.zhao@linaro.org, fabio.estevam@freescale.com,
	kernel@pengutronix.de, r.schwebel@pengutronix.de
Subject: Re: [PATCH v2 2/2] MEM2MEM: Add support for eMMa-PrP mem2mem
 operations.
Message-ID: <20111122205552.GO27267@pengutronix.de>
References: <1321963316-9058-1-git-send-email-javier.martin@vista-silicon.com>
 <1321963316-9058-3-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321963316-9058-3-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Tue, Nov 22, 2011 at 01:01:56PM +0100, Javier Martin wrote:
> Changes since v1:
> - Embed queue data in ctx structure to allow multi instance.
> - Remove redundant job_ready callback.
> - Adjust format against device capabilities.
> - Register/unregister video device at the right time.
> - Other minor coding fixes.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/Kconfig       |   10 +
>  drivers/media/video/Makefile      |    2 +
>  drivers/media/video/mx2_emmaprp.c | 1035 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 1047 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/mx2_emmaprp.c
> 
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index b303a3f..77d7921 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -1107,4 +1107,14 @@ config VIDEO_SAMSUNG_S5P_MFC
>  	help
>  	    MFC 5.1 driver for V4L2.
>  
> +config VIDEO_MX2_EMMAPRP
> +	tristate "MX2 eMMa-PrP support"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && MACH_MX27

Please do not add new references to MACH_MX27. Use SOC_IMX27 instead.

> +	select VIDEOBUF2_DMA_CONTIG
> +	select V4L2_MEM2MEM_DEV
> +	help
> +	    MX2X chips have a PrP that can be used to process buffers from
> +	    memory to memory. Operations include resizing and format
> +	    conversion.
> +

[...]

> +
> +static int emmaprp_probe(struct platform_device *pdev)
> +{
> +	struct emmaprp_dev *pcdev;
> +	struct video_device *vfd;
> +	struct resource *res_emma;
> +	int irq_emma;
> +	int ret;
> +
> +	pcdev = kzalloc(sizeof *pcdev, GFP_KERNEL);
> +	if (!pcdev)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&pcdev->irqlock);
> +
> +	pcdev->clk_emma = clk_get(NULL, "emma");

You should change the entry for the emma in
arch/arm/mach-imx/clock-imx27.c to the following:

_REGISTER_CLOCK("m2m-emmaprp", NULL, emma_clk)

and use clk_get(&pdev->dev, NULL) here.

> +	if (IS_ERR(pcdev->clk_emma)) {
> +		ret = PTR_ERR(pcdev->clk_emma);
> +		goto free_dev;
> +	}
> +
> +	irq_emma = platform_get_irq(pdev, 0);
> +	res_emma = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (irq_emma < 0 || res_emma == NULL) {
> +		dev_err(&pdev->dev, "Missing platform resources data\n");
> +		ret = -ENODEV;
> +		goto free_clk;
> +	}
> +
> +	ret = v4l2_device_register(&pdev->dev, &pcdev->v4l2_dev);
> +	if (ret)
> +		goto free_clk;
> +
> +	mutex_init(&pcdev->dev_mutex);
> +
> +	vfd = video_device_alloc();
> +	if (!vfd) {
> +		v4l2_err(&pcdev->v4l2_dev, "Failed to allocate video device\n");
> +		ret = -ENOMEM;
> +		goto unreg_dev;
> +	}
> +
> +	*vfd = emmaprp_videodev;
> +	vfd->lock = &pcdev->dev_mutex;
> +
> +	video_set_drvdata(vfd, pcdev);
> +	snprintf(vfd->name, sizeof(vfd->name), "%s", emmaprp_videodev.name);
> +	pcdev->vfd = vfd;
> +	v4l2_info(&pcdev->v4l2_dev, EMMAPRP_MODULE_NAME
> +			" Device registered as /dev/video%d\n", vfd->num);
> +
> +	platform_set_drvdata(pdev, pcdev);
> +
> +	if (!request_mem_region(res_emma->start, resource_size(res_emma),
> +				MEM2MEM_NAME)) {
> +		ret = -EBUSY;
> +		goto rel_vdev;
> +	}
> +
> +	pcdev->base_emma = ioremap(res_emma->start, resource_size(res_emma));
> +	if (!pcdev->base_emma) {
> +		ret = -ENOMEM;
> +		goto rel_mem;
> +	}
> +	pcdev->irq_emma = irq_emma;
> +	pcdev->res_emma = res_emma;
> +
> +	ret = request_irq(pcdev->irq_emma, emmaprp_irq, 0,
> +			  MEM2MEM_NAME, pcdev);
> +	if (ret)
> +		goto rel_map;
> +

consider using devm_request_mem_region, devm_ioremap and
devm_request_irq here. It simplifies your error handling considerably.

> +
> +	pcdev->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(pcdev->alloc_ctx)) {
> +		v4l2_err(&pcdev->v4l2_dev, "Failed to alloc vb2 context\n");
> +		ret = PTR_ERR(pcdev->alloc_ctx);
> +		goto rel_irq;
> +	}
> +
> +	pcdev->m2m_dev = v4l2_m2m_init(&m2m_ops);
> +	if (IS_ERR(pcdev->m2m_dev)) {
> +		v4l2_err(&pcdev->v4l2_dev, "Failed to init mem2mem device\n");
> +		ret = PTR_ERR(pcdev->m2m_dev);
> +		goto rel_ctx;
> +	}
> +

[...]

> +
> +static struct platform_driver emmaprp_pdrv = {
> +	.probe		= emmaprp_probe,
> +	.remove		= emmaprp_remove,
> +	.driver		= {
> +		.name	= MEM2MEM_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +
> +static void __exit emmaprp_exit(void)
> +{
> +	platform_driver_unregister(&emmaprp_pdrv);
> +}
> +
> +static int __init emmaprp_init(void)
> +{
> +	return platform_driver_register(&emmaprp_pdrv);
> +}
> +
> +module_init(emmaprp_init);
> +module_exit(emmaprp_exit);
> +

No blank line at end of file please.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

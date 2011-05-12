Return-path: <mchehab@gaivota>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48772 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab1ELJey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 May 2011 05:34:54 -0400
Date: Thu, 12 May 2011 10:34:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Josh Wu <josh.wu@atmel.com>
Cc: mchehab@redhat.com, linux-media@vger.kernel.org,
	lars.haring@atmel.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH] [media] at91: add Atmel Image Sensor Interface (ISI)
	support
Message-ID: <20110512093433.GD1356@n2100.arm.linux.org.uk>
References: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305186138-5656-1-git-send-email-josh.wu@atmel.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Thu, May 12, 2011 at 03:42:18PM +0800, Josh Wu wrote:
> This patch is to enable Atmel Image Sensor Interface (ISI) driver support. 
> - Using soc-camera framework with videobuf2 dma-contig allocator
> - Supporting video streaming of YUV packed format
> - Tested on AT91SAM9M10G45-EK with OV2640

A few more points...

> +static int __init atmel_isi_probe(struct platform_device *pdev)

Should be __devinit otherwise you'll have section errors.

> +{
> +	unsigned int irq;
> +	struct atmel_isi *isi;
> +	struct clk *pclk;
> +	struct resource *regs;
> +	int ret;
> +	struct device *dev = &pdev->dev;
> +	struct isi_platform_data *pdata;
> +	struct soc_camera_host *soc_host;
> +
> +	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!regs)
> +		return -ENXIO;
> +
> +	pclk = clk_get(&pdev->dev, "isi_clk");
> +	if (IS_ERR(pclk))
> +		return PTR_ERR(pclk);
> +
> +	clk_enable(pclk);

Return value of clk_enable() should be checked.

> +
> +	isi = kzalloc(sizeof(struct atmel_isi), GFP_KERNEL);
> +	if (!isi) {
> +		ret = -ENOMEM;
> +		dev_err(&pdev->dev, "can't allocate interface!\n");
> +		goto err_alloc_isi;
> +	}
> +
> +	isi->pclk = pclk;
> +
> +	spin_lock_init(&isi->lock);
> +	init_waitqueue_head(&isi->capture_wq);
> +
> +	isi->alloc_ctx = vb2_dma_contig_init_ctx(&pdev->dev);
> +	if (IS_ERR(isi->alloc_ctx)) {
> +		ret = PTR_ERR(isi->alloc_ctx);
> +		goto err_alloc_isi;
> +	}
> +
> +	isi->regs = ioremap(regs->start, resource_size(regs));
> +	if (!isi->regs) {
> +		ret = -ENOMEM;
> +		goto err_ioremap;
> +	}
> +
> +	if (dev->platform_data)
> +		pdata = (struct isi_platform_data *) dev->platform_data;
> +	else {
> +		static struct isi_platform_data isi_default_data = {
> +			.frate		= 0,
> +			.has_emb_sync	= 0,
> +			.emb_crc_sync	= 0,
> +			.hsync_act_low	= 0,
> +			.vsync_act_low	= 0,
> +			.pclk_act_falling = 0,
> +			.isi_full_mode	= 1,
> +			/* to use codec and preview path simultaneously */
> +			.flags = ISI_DATAWIDTH_8 |
> +				ISI_DATAWIDTH_10,
> +		};
> +		dev_info(&pdev->dev,
> +			"No config available using default values\n");
> +		pdata = &isi_default_data;
> +	}
> +
> +	isi->pdata = pdata;
> +	isi->platform_flags = pdata->flags;
> +	if (isi->platform_flags == 0)
> +		isi->platform_flags = ISI_DATAWIDTH_8;
> +
> +	isi_writel(isi, V2_CTRL, ISI_BIT(V2_DIS));
> +	/* Check if module disable */
> +	while (isi_readl(isi, V2_STATUS) & ISI_BIT(V2_DIS))
> +		cpu_relax();
> +
> +	irq = platform_get_irq(pdev, 0);

This should also be checked.

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:39665 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab3IPV7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 17:59:54 -0400
Message-ID: <52377F3C.5070508@gmail.com>
Date: Mon, 16 Sep 2013 23:59:24 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, swarren@wwwdotorg.org, mark.rutland@arm.com,
	Pawel.Moll@arm.com, galak@codeaurora.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v8 02/12] [media] exynos5-fimc-is: Add driver core files
References: <1378987669-10870-1-git-send-email-arun.kk@samsung.com> <1378987669-10870-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1378987669-10870-3-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/12/2013 02:07 PM, Arun Kumar K wrote:
>
> +static int fimc_is_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =&pdev->dev;
> +	struct resource *res;
> +	struct fimc_is *is;
> +	void __iomem *regs;
> +	struct device_node *node;
> +	int irq, ret;
> +	int i;
> +
> +	dev_dbg(dev, "FIMC-IS Probe Enter\n");
> +
> +	if (!pdev->dev.of_node)

nit: Could be simplified to:

  	if (!dev->of_node)

> +		return -ENODEV;
> +
> +	is = devm_kzalloc(&pdev->dev, sizeof(*is), GFP_KERNEL);
> +	if (!is)
> +		return -ENOMEM;
> +
> +	is->pdev = pdev;
> +
> +	is->drvdata = fimc_is_get_drvdata(pdev);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	regs = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(regs))
> +		return PTR_ERR(regs);
> +
> +	/* Get the PMU base */
> +	node = of_parse_phandle(dev->of_node, "samsung,pmu", 0);
> +	if (!node)
> +		return -ENODEV;
> +	is->pmu_regs = of_iomap(node, 0);
> +	if (!is->pmu_regs)
> +		return -ENOMEM;
> +
> +	irq = irq_of_parse_and_map(dev->of_node, 0);
> +	if (irq<  0) {
> +		dev_err(dev, "Failed to get IRQ\n");
> +		return irq;
> +	}
> +
> +	ret = fimc_is_configure_clocks(is);
> +	if (ret<  0) {
> +		dev_err(dev, "clocks configuration failed\n");
> +		goto err_clk;
> +	}
> +
> +	platform_set_drvdata(pdev, is);
> +	pm_runtime_enable(dev);
> +
> +	ret = pm_runtime_get_sync(dev);
> +	if (ret<  0)
> +		goto err_pm;

Is activating the device at this point really needed ? Perhaps you
could drop the pm_runtime_get/put calls ?

> +	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
> +	if (IS_ERR(is->alloc_ctx)) {
> +		ret = PTR_ERR(is->alloc_ctx);
> +		goto err_vb;
> +	}
> +
> +	/* Get IS-sensor contexts */
> +	ret = fimc_is_parse_sensor(is);
> +	if (ret<  0)
> +		goto err_vb;
> +
> +	/* Initialize FIMC Pipeline */
> +	for (i = 0; i<  is->drvdata->num_instances; i++) {
> +		ret = fimc_is_pipeline_init(&is->pipeline[i], i, is);
> +		if (ret<  0)
> +			goto err_sd;
> +	}
> +
> +	/* Initialize FIMC Interface */
> +	ret = fimc_is_interface_init(&is->interface, regs, irq);
> +	if (ret<  0)
> +		goto err_sd;
> +
> +	pm_runtime_put(dev);
> +
> +	dev_dbg(dev, "FIMC-IS registered successfully\n");
> +
> +	return 0;
> +
> +err_sd:
> +	fimc_is_pipelines_destroy(is);
> +err_vb:
> +	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
> +err_pm:
> +	pm_runtime_put(dev);
> +err_clk:
> +	fimc_is_put_clocks(is);
> +
> +	return ret;
> +}
> +
> +int fimc_is_clk_enable(struct fimc_is *is)
> +{
> +	int ret;
> +
> +	ret = clk_enable(is->clock[IS_CLK_ISP]);
> +	if (ret)
> +		return ret;
> +	ret = clk_enable(is->clock[IS_CLK_MCU_ISP]);

Shouldn't you disable the first enabled clock when this call fails ?

> +	return ret;
> +}
[...]
> +static void *fimc_is_get_drvdata(struct platform_device *pdev)
> +{
> +	struct fimc_is_drvdata *driver_data = NULL;
> +
> +	if (pdev->dev.of_node) {

pdev->dev.of_node is being tested against NULL before call to this
function, you could make this code slightly simpler with that assumption.

> +		const struct of_device_id *match;
> +		match = of_match_node(exynos5_fimc_is_match,
> +				pdev->dev.of_node);
> +		if (match)
> +			driver_data = (struct fimc_is_drvdata *)match->data;
> +	}
> +	return driver_data;
> +}

--
Thanks,
Sylwester

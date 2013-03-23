Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:59872 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3CWNlY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 09:41:24 -0400
Message-ID: <514DB100.1060607@gmail.com>
Date: Sat, 23 Mar 2013 14:41:20 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC 03/12] exynos-fimc-is: Adds fimc-is driver core files
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com> <1362754765-2651-4-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1362754765-2651-4-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2013 03:59 PM, Arun Kumar K wrote:
> This driver is for the FIMC-IS IP available in Samsung Exynos5
> SoC onwards. This patch adds the core files for the new driver.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/fimc-is-core.c |  421 ++++++++++++++++++++++
>   drivers/media/platform/exynos5-is/fimc-is-core.h |  140 +++++++
>   2 files changed, 561 insertions(+)
[...]
> +static int __devinit fimc_is_probe(struct platform_device *pdev)

You need to remove this attribute, that's not supported in recent kernels
any more.

> +{
> +	struct device *dev =&pdev->dev;
> +	struct fimc_is_platdata *pdata;
> +	struct resource *res;
> +	struct fimc_is *is;
> +	struct pinctrl *pctrl;
> +	void __iomem *regs;
> +	int irq, ret;
> +
> +	pr_debug("FIMC-IS Probe Enter\n");
> +
> +	pctrl = devm_pinctrl_get_select_default(dev);
> +	if (IS_ERR(pctrl)) {
> +		dev_err(dev, "Pinctrl configuration failed\n");
> +		return -EINVAL;
> +	}

This is not needed any more. If you work with not latest kernel I suggest
to cherry pick

commit ab78029ecc347debbd737f06688d788bd9d60c1d
drivers/pinctrl: grab default handles from device core

and remove those devm_pinctrl_get_select_default() calls from drivers.

> +	if (!pdev->dev.of_node) {
> +		dev_err(dev, "Null platform data\n");

Huh ? Since this driver is for dt-only platforms, is there a need to check
pdev->dev.of_node at all ? Probably you want to just return -ENODEV if it
is NULL.

> +		return -EINVAL;
> +	}
> +
> +	pdata = fimc_is_parse_dt(dev);
> +	if (!pdata) {
> +		dev_err(dev, "Parse DT failed\n");
> +		return -EINVAL;
> +	}
> +
> +	is = devm_kzalloc(&pdev->dev, sizeof(*is), GFP_KERNEL);
> +	if (!is)
> +		return -ENOMEM;
> +
> +	is->pdev = pdev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	regs = devm_request_and_ioremap(dev, res);
> +	if (regs == NULL) {
> +		dev_err(dev, "Failed to obtain io memory\n");
> +		return -ENOENT;
> +	}
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq<  0) {
> +		dev_err(dev, "Failed to get IRQ\n");
> +		return irq;
> +	}
> +
> +	ret = fimc_is_clk_cfg(is);
> +	if (ret<  0) {
> +		dev_err(dev, "Clock config failed\n");
> +		goto err_clk;
> +	}
> +
> +	platform_set_drvdata(pdev, is);
> +	pm_runtime_enable(dev);
> +
> +	ret = pm_runtime_get_sync(dev);
> +	if (ret<  0)
> +		goto err_clk;
> +
> +	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
> +	if (IS_ERR(is->alloc_ctx)) {
> +		ret = PTR_ERR(is->alloc_ctx);
> +		goto err_pm;
> +	}
> +
> +	/* Create sensor subdevs */
> +	is->pdata = pdata;
> +	ret = fimc_is_create_sensor_subdevs(is);
> +	if (ret<  0)
> +		goto err_sensor_sd;
> +
> +	/* Init FIMC Pipeline */
> +	ret = fimc_is_pipeline_init(&is->pipeline, 0, is);
> +	if (ret<  0)
> +		goto err_sd;
> +
> +	/* Init FIMC Interface */
> +	ret = fimc_is_interface_init(&is->interface, regs, irq);
> +	if (ret<  0)
> +		goto err_sd;
> +
> +	dev_dbg(dev, "FIMC-IS registered successfully\n");

Shouldn't there be pm_runtime_put() ?

> +
> +	return 0;
> +
> +err_sd:
> +	fimc_is_pipeline_destroy(&is->pipeline);
> +err_sensor_sd:
> +	fimc_is_unregister_sensor_subdevs(is);
> +err_vb:
> +	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
> +err_pm:
> +	pm_runtime_put(dev);
> +err_clk:
> +	fimc_is_clk_put(is);
> +
> +	return ret;
> +}
> +
> +int fimc_is_clk_enable(struct fimc_is *is)
> +{
> +	clk_enable(is->clock[IS_CLK_GATE0]);
> +	clk_enable(is->clock[IS_CLK_GATE1]);

No need to check return value ?

> +	return 0;
> +}
> +
> +void fimc_is_clk_disable(struct fimc_is *is)
> +{
> +	clk_disable(is->clock[IS_CLK_GATE0]);
> +	clk_disable(is->clock[IS_CLK_GATE1]);
> +}
> +
> +static int fimc_is_pm_resume(struct device *dev)
> +{
> +	struct fimc_is *is = dev_get_drvdata(dev);
> +	int ret;
> +
> +	ret = fimc_is_clk_enable(is);
> +	if (ret<  0)
> +		dev_err(dev, "Could not enable clocks\n");
> +
> +	return 0;
> +}
> +
> +static int fimc_is_pm_suspend(struct device *dev)
> +{
> +	struct fimc_is *is = dev_get_drvdata(dev);
> +
> +	fimc_is_clk_disable(is);
> +	return 0;
> +}
> +
> +static int fimc_is_runtime_resume(struct device *dev)
> +{
> +	return fimc_is_pm_resume(dev);
> +}
> +
> +static int fimc_is_runtime_suspend(struct device *dev)
> +{
> +	return fimc_is_pm_suspend(dev);
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int fimc_is_resume(struct device *dev)
> +{
> +	return fimc_is_pm_resume(dev);
> +}
> +
> +static int fimc_is_suspend(struct device *dev)
> +{
> +	return fimc_is_pm_suspend(dev);
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static int fimc_is_remove(struct platform_device *pdev)
> +{
> +	struct fimc_is *is = platform_get_drvdata(pdev);
> +	struct device *dev =&pdev->dev;
> +
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_suspended(dev);
> +	fimc_is_pipeline_destroy(&is->pipeline);
> +	fimc_is_unregister_sensor_subdevs(is);
> +	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
> +	fimc_is_clk_put(is);
> +
> +	return 0;
> +}
> +
> +static struct platform_device_id fimc_is_driver_ids[] = {
> +	{
> +		.name		= "exynos5-fimc-is",
> +		.driver_data	= 0,

This line doesn't change anything, I would just remove it.
But is this fimc_is_driver_ids[] array needed at all ?

> +	},
> +};
> +MODULE_DEVICE_TABLE(platform, fimc_is_driver_ids);
> +
> +static const struct dev_pm_ops fimc_is_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(fimc_is_suspend, fimc_is_resume)
> +	SET_RUNTIME_PM_OPS(fimc_is_runtime_suspend, fimc_is_runtime_resume,
> +			   NULL)
> +};
> +
> +static struct platform_driver fimc_is_driver = {
> +	.probe		= fimc_is_probe,
> +	.remove		= fimc_is_remove,
> +	.id_table	= fimc_is_driver_ids,
> +	.driver = {
> +		.name	= FIMC_IS_DRV_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	=&fimc_is_pm_ops,

How is this driver instantiated from the device tree when there
is no of_match_table ? I didn't find any chunk adding it further
in this series.

> +	}
> +};
> +module_platform_driver(fimc_is_driver);

I forgot to say that in general this patch series looks very clean
to me. I'm really happy to see this driver in such a good shape.

Thanks,
Sylwester

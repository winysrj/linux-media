Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:51581 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030380Ab3FTWq2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Jun 2013 18:46:28 -0400
Received: by mail-ee0-f47.google.com with SMTP id e49so4144955eek.20
        for <linux-media@vger.kernel.org>; Thu, 20 Jun 2013 15:46:27 -0700 (PDT)
Message-ID: <51C38632.9080404@gmail.com>
Date: Fri, 21 Jun 2013 00:46:10 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>
CC: linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kilyeon.im@samsung.com, shaik.ameer@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [RFC v2 02/10] exynos5-fimc-is: Adds fimc-is driver core files
References: <1370005408-10853-1-git-send-email-arun.kk@samsung.com> <1370005408-10853-3-git-send-email-arun.kk@samsung.com>
In-Reply-To: <1370005408-10853-3-git-send-email-arun.kk@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/31/2013 03:03 PM, Arun Kumar K wrote:
> This driver is for the FIMC-IS IP available in Samsung Exynos5
> SoC onwards. This patch adds the core files for the new driver.
>
> Signed-off-by: Arun Kumar K<arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im<kilyeon.im@samsung.com>
> ---
>   drivers/media/platform/exynos5-is/fimc-is-core.c |  304 ++++++++++++++++++++++
>   drivers/media/platform/exynos5-is/fimc-is-core.h |  126 +++++++++
>   2 files changed, 430 insertions(+)
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.c
>   create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.h
>
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-core.c b/drivers/media/platform/exynos5-is/fimc-is-core.c
> new file mode 100644
> index 0000000..d24b634
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-core.c
> @@ -0,0 +1,304 @@
> +/*
> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
> +*
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include<linux/bug.h>
> +#include<linux/ctype.h>
> +#include<linux/device.h>
> +#include<linux/debugfs.h>
> +#include<linux/delay.h>
> +#include<linux/errno.h>
> +#include<linux/firmware.h>
> +#include<linux/fs.h>
> +#include<linux/gpio.h>
> +#include<linux/interrupt.h>
> +#include<linux/kernel.h>
> +#include<linux/list.h>
> +#include<linux/module.h>
> +#include<linux/types.h>
> +#include<linux/platform_device.h>
> +#include<linux/pm_runtime.h>
> +#include<linux/slab.h>
> +#include<linux/videodev2.h>
> +#include<linux/of.h>
> +#include<linux/of_gpio.h>
> +#include<linux/of_address.h>
> +#include<linux/of_platform.h>
> +#include<linux/of_irq.h>
> +#include<linux/pinctrl/consumer.h>
> +
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-ioctl.h>
> +#include<media/v4l2-mem2mem.h>
> +#include<media/v4l2-of.h>
> +#include<media/videobuf2-core.h>
> +#include<media/videobuf2-dma-contig.h>
> +
> +#include "fimc-is.h"
> +
> +static char *fimc_is_clock_name[] = {
> +	[IS_CLK_ISP]		= "isp",
> +	[IS_CLK_MCU_ISP]	= "mcu_isp",
> +	[IS_CLK_ISP_DIV0]	= "isp_div0",
> +	[IS_CLK_ISP_DIV1]	= "isp_div1",
> +	[IS_CLK_ISP_DIVMPWM]	= "isp_divmpwm",
> +	[IS_CLK_MCU_ISP_DIV0]	= "mcu_isp_div0",
> +	[IS_CLK_MCU_ISP_DIV1]	= "mcu_isp_div1",
> +};
> +
> +static void fimc_is_clk_put(struct fimc_is *is)

nit: fimc_is_put_clocks() would be probably a better name for this function.

> +{
> +	int i;
> +
> +	for (i = 0; i<  IS_CLK_MAX_NUM; i++) {
> +		if (IS_ERR_OR_NULL(is->clock[i]))
> +			continue;
> +		clk_unprepare(is->clock[i]);
> +		clk_put(is->clock[i]);
> +		is->clock[i] = NULL;
> +	}
> +}
> +
> +static int fimc_is_clk_get(struct fimc_is *is)

nit: fimc_is_get_clocks() ?

> +{
> +	struct device *dev =&is->pdev->dev;
> +	int i, ret;
> +
> +	for (i = 0; i<  IS_CLK_MAX_NUM; i++) {
> +		is->clock[i] = clk_get(dev, fimc_is_clock_name[i]);
> +		if (IS_ERR(is->clock[i]))
> +			goto err;
> +		ret = clk_prepare(is->clock[i]);
> +		if (ret<  0) {
> +			clk_put(is->clock[i]);
> +			is->clock[i] = NULL;
> +			goto err;
> +		}
> +	}
> +	return 0;
> +err:
> +	fimc_is_clk_put(is);
> +	pr_err("Failed to get clock: %s\n", fimc_is_clock_name[i]);
> +	return -ENXIO;
> +}
> +
> +static int fimc_is_clk_cfg(struct fimc_is *is)

nit: fimc_is_configure_clocks() ?

> +{
> +	int ret;
> +
> +	ret = fimc_is_clk_get(is);
> +	if (ret)
> +		return ret;
> +
> +	/* Set rates */
> +	ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV0], 200 * 1000000);
> +	ret |= clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV1], 100 * 1000000);
> +	ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIV0], 134 * 1000000);
> +	ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIV1], 68 * 1000000);
> +	ret |= clk_set_rate(is->clock[IS_CLK_ISP_DIVMPWM], 34 * 1000000);

Please do not obfuscate return value like this.

	ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV0], 200 * 1000000);
	if (ret)
		ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV1], 100 * 1000000);
	...

And how about adding macro definitions for the frequencies, rather
than using magic numbers in the code ?

> +	if (ret)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int fimc_is_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =&pdev->dev;
> +	struct resource res;
> +	struct fimc_is *is;
> +	struct pinctrl *pctrl;
> +	void __iomem *regs;
> +	struct device_node *node;
> +	int irq, ret;
> +
> +	pr_debug("FIMC-IS Probe Enter\n");
> +
> +	if (!pdev->dev.of_node)
> +		return -ENODEV;
> +
> +	is = devm_kzalloc(&pdev->dev, sizeof(*is), GFP_KERNEL);
> +	if (!is)
> +		return -ENOMEM;
> +
> +	is->pdev = pdev;

> +	ret = of_address_to_resource(dev->of_node, 0,&res);
> +	if (ret<  0)
> +		return ret;

It could be simplified to:
	
	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);

and 'res' could be passed to devm_ioremap_resource() without any checks.

> +	regs = devm_ioremap_resource(dev,&res);
> +	if (regs == NULL) {
> +		dev_err(dev, "Failed to obtain io memory\n");
> +		return -ENOENT;
> +	}
> +
> +	/* Get the PMU base */
> +	node = of_get_child_by_name(dev->of_node, "pmu");
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
> +	/* Init FIMC Pipeline */

s/Init/Initialize ?

> +	ret = fimc_is_pipeline_init(&is->pipeline, 0, is);
> +	if (ret<  0)
> +		goto err_sd;
> +
> +	/* Init FIMC Interface */

s/Init/ Initialize

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
> +	fimc_is_pipeline_destroy(&is->pipeline);
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
> +	int ret;
> +
> +	ret = clk_enable(is->clock[IS_CLK_ISP]);
> +	ret |= clk_enable(is->clock[IS_CLK_MCU_ISP]);

Please don't obfuscate the return value.

> +	return ret;
> +}
> +
> +void fimc_is_clk_disable(struct fimc_is *is)
> +{
> +	clk_disable(is->clock[IS_CLK_ISP]);
> +	clk_disable(is->clock[IS_CLK_MCU_ISP]);
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
> +	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
> +	fimc_is_clk_put(is);
> +
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops fimc_is_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(fimc_is_suspend, fimc_is_resume)
> +	SET_RUNTIME_PM_OPS(fimc_is_runtime_suspend, fimc_is_runtime_resume,
> +			   NULL)
> +};
> +
> +static const struct of_device_id exynos5_fimc_is_match[] = {
> +	{
> +		.compatible = "samsung,exynos5250-fimc-is",
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos5_fimc_is_match);
> +
> +static struct platform_driver fimc_is_driver = {
> +	.probe		= fimc_is_probe,
> +	.remove		= fimc_is_remove,
> +	.driver = {
> +		.name	= FIMC_IS_DRV_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	=&fimc_is_pm_ops,
> +		.of_match_table = exynos5_fimc_is_match,
> +	}
> +};
> +module_platform_driver(fimc_is_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Arun Kumar K<arun.kk@samsung.com>");
> +MODULE_DESCRIPTION("Samsung Exynos5 (FIMC-IS) Imaging Subsystem driver");
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-core.h b/drivers/media/platform/exynos5-is/fimc-is-core.h
> new file mode 100644
> index 0000000..0512280
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-core.h
> @@ -0,0 +1,126 @@
> +/*
> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + *  Arun Kumar K<arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef FIMC_IS_CORE_H_
> +#define FIMC_IS_CORE_H_
> +
> +#include<linux/bug.h>
> +#include<linux/clk.h>
> +#include<linux/device.h>
> +#include<linux/errno.h>
> +#include<linux/firmware.h>
> +#include<linux/interrupt.h>
> +#include<linux/kernel.h>
> +#include<linux/list.h>
> +#include<linux/module.h>
> +#include<linux/types.h>
> +#include<linux/platform_device.h>
> +#include<linux/pm_runtime.h>
> +#include<linux/slab.h>
> +#include<linux/videodev2.h>
> +
> +#include<asm/barrier.h>
> +#include<linux/sizes.h>
> +#include<linux/io.h>
> +#include<linux/irqreturn.h>
> +#include<linux/platform_device.h>
> +#include<linux/sched.h>
> +#include<linux/spinlock.h>
> +
> +#include<media/media-entity.h>
> +#include<media/videobuf2-core.h>
> +#include<media/v4l2-ctrls.h>
> +#include<media/v4l2-device.h>
> +#include<media/v4l2-mem2mem.h>
> +#include<media/v4l2-mediabus.h>
> +#include<media/s5p_fimc.h>
> +
> +#define FIMC_IS_DRV_NAME		"exynos5-fimc-is"
> +#define FIMC_IS_CLK_NAME		"fimc_is"

Unused symbol, please remove.

> +#define FIMC_IS_DEBUG_MSG		0x3f
> +#define FIMC_IS_DEBUG_LEVEL		3

These 2 are unused too.

> +#define FIMC_IS_COMMAND_TIMEOUT		(3*HZ)
> +#define FIMC_IS_STARTUP_TIMEOUT		(3*HZ)
> +#define FIMC_IS_SHUTDOWN_TIMEOUT	(10*HZ)

Please add spaces around '*'. It also applies to other places in most
of the patches.

> +
> +#define FW_SHARED_OFFSET		(0x8C0000)

> +#define DEBUG_CNT			(500*1024)
> +#define DEBUG_OFFSET			(0x840000)
> +#define DEBUGCTL_OFFSET			(0x8BD000)
> +#define DEBUG_FCOUNT			(0x8C64C0)

Please put all hex numbers in lower case.

> +#define FIMC_IS_MAX_INSTANCES		1
> +
> +#define FIMC_IS_MAX_GPIOS		32
> +#define FIMC_IS_NUM_SENSORS		2
> +
> +#define FIMC_IS_MAX_PLANES		3
> +#define FIMC_IS_NUM_SCALERS		2
> +
> +enum fimc_is_clks {
> +	IS_CLK_ISP,
> +	IS_CLK_MCU_ISP,
> +	IS_CLK_ISP_DIV0,
> +	IS_CLK_ISP_DIV1,
> +	IS_CLK_ISP_DIVMPWM,
> +	IS_CLK_MCU_ISP_DIV0,
> +	IS_CLK_MCU_ISP_DIV1,
> +	IS_CLK_MAX_NUM
> +};
> +
> +/* Video capture states */
> +enum fimc_is_video_state {
> +	STATE_INIT,
> +	STATE_BUFS_ALLOCATED,
> +	STATE_RUNNING,
> +};
> +
> +enum fimc_is_scaler_id {
> +	SCALER_SCC,
> +	SCALER_SCP
> +};
> +
> +enum fimc_is_sensor_pos {
> +	SENSOR_CAM0,
> +	SENSOR_CAM1
> +};
> +
> +struct fimc_is_buf {
> +	struct list_head list;
> +	struct vb2_buffer *vb;
> +	unsigned int paddr[FIMC_IS_MAX_PLANES];
> +};
> +
> +struct fimc_is_meminfo {
> +	unsigned int fw_paddr;
> +	unsigned int fw_vaddr;
> +	unsigned int region_paddr;
> +	unsigned int region_vaddr;
> +	unsigned int shared_paddr;
> +	unsigned int shared_vaddr;
> +};
> +
> +/**
> + * struct fimc_is_fmt - the driver's internal color format data
> + * @name: format description
> + * @fourcc: the fourcc code for this format
> + * @depth: number of bytes per pixel
> + * @num_planes: number of planes for this color format
> + */
> +struct fimc_is_fmt {
> +	char		*name;
> +	unsigned int	fourcc;
> +	unsigned int	depth[FIMC_IS_MAX_PLANES];
> +	unsigned int	num_planes;
> +};
> +
> +#endif

Regards,
Sylwester

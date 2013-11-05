Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48125 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753485Ab3KELW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Nov 2013 06:22:29 -0500
Date: Tue, 5 Nov 2013 13:21:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Arun Kumar K <arun.kk@samsung.com>
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, s.nawrocki@samsung.com,
	hverkuil@xs4all.nl, swarren@wwwdotorg.org, mark.rutland@arm.com,
	Pawel.Moll@arm.com, galak@codeaurora.org, a.hajda@samsung.com,
	sachin.kamat@linaro.org, shaik.ameer@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH v11 02/12] [media] exynos5-fimc-is: Add driver core files
Message-ID: <20131105112154.GE23061@valkosipuli.retiisi.org.uk>
References: <1383631964-26514-1-git-send-email-arun.kk@samsung.com>
 <1383631964-26514-3-git-send-email-arun.kk@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383631964-26514-3-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Arun,

Thanks for the patch. A few comments below.

On Tue, Nov 05, 2013 at 11:42:33AM +0530, Arun Kumar K wrote:
> This driver is for the FIMC-IS IP available in Samsung Exynos5
> SoC onwards. This patch adds the core files for the new driver.
> 
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
> Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/platform/exynos5-is/fimc-is-core.c |  410 ++++++++++++++++++++++
>  drivers/media/platform/exynos5-is/fimc-is-core.h |  132 +++++++
>  2 files changed, 542 insertions(+)
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.c
>  create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.h
> 
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-core.c b/drivers/media/platform/exynos5-is/fimc-is-core.c
> new file mode 100644
> index 0000000..2b116d0
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-core.c
> @@ -0,0 +1,410 @@
> +/*
> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
> +*
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Arun Kumar K <arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/bug.h>
> +#include <linux/ctype.h>
> +#include <linux/device.h>
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/firmware.h>
> +#include <linux/fs.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_address.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_irq.h>
> +#include <linux/pinctrl/consumer.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-of.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>

Do you really need all these headers?

> +#include "fimc-is.h"
> +#include "fimc-is-i2c.h"
> +
> +#define CLK_MCU_ISP_DIV0_FREQ	(200 * 1000000)
> +#define CLK_MCU_ISP_DIV1_FREQ	(100 * 1000000)
> +#define CLK_ISP_DIV0_FREQ	(134 * 1000000)
> +#define CLK_ISP_DIV1_FREQ	(68 * 1000000)
> +#define CLK_ISP_DIVMPWM_FREQ	(34 * 1000000)
> +
> +static const char * const fimc_is_clock_name[] = {
> +	[IS_CLK_ISP]		= "isp",
> +	[IS_CLK_MCU_ISP]	= "mcu_isp",
> +	[IS_CLK_ISP_DIV0]	= "isp_div0",
> +	[IS_CLK_ISP_DIV1]	= "isp_div1",
> +	[IS_CLK_ISP_DIVMPWM]	= "isp_divmpwm",
> +	[IS_CLK_MCU_ISP_DIV0]	= "mcu_isp_div0",
> +	[IS_CLK_MCU_ISP_DIV1]	= "mcu_isp_div1",
> +};
> +
> +static void fimc_is_put_clocks(struct fimc_is *is)
> +{
> +	int i;
> +
> +	for (i = 0; i < IS_CLK_MAX_NUM; i++) {
> +		if (IS_ERR(is->clock[i]))
> +			continue;
> +		clk_unprepare(is->clock[i]);
> +		clk_put(is->clock[i]);
> +		is->clock[i] = ERR_PTR(-EINVAL);
> +	}
> +}
> +
> +static int fimc_is_get_clocks(struct fimc_is *is)
> +{
> +	struct device *dev = &is->pdev->dev;
> +	int i, ret;
> +
> +	for (i = 0; i < IS_CLK_MAX_NUM; i++) {
> +		is->clock[i] = clk_get(dev, fimc_is_clock_name[i]);
> +		if (IS_ERR(is->clock[i]))
> +			goto err;
> +		ret = clk_prepare(is->clock[i]);
> +		if (ret < 0) {
> +			clk_put(is->clock[i]);
> +			is->clock[i] = ERR_PTR(-EINVAL);
> +			goto err;
> +		}
> +	}
> +	return 0;
> +err:
> +	fimc_is_put_clocks(is);
> +	pr_err("Failed to get clock: %s\n", fimc_is_clock_name[i]);

How about dev_err() instead?

> +	return -ENXIO;
> +}
> +
> +static int fimc_is_configure_clocks(struct fimc_is *is)
> +{
> +	int i, ret;
> +
> +	for (i = 0; i < IS_CLK_MAX_NUM; i++)
> +		is->clock[i] = ERR_PTR(-EINVAL);
> +
> +	ret = fimc_is_get_clocks(is);
> +	if (ret)
> +		return ret;
> +
> +	/* Set rates */
> +	ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV0],
> +			CLK_MCU_ISP_DIV0_FREQ);
> +	if (ret)
> +		return ret;
> +	ret = clk_set_rate(is->clock[IS_CLK_MCU_ISP_DIV1],
> +			CLK_MCU_ISP_DIV1_FREQ);
> +	if (ret)
> +		return ret;
> +	ret = clk_set_rate(is->clock[IS_CLK_ISP_DIV0], CLK_ISP_DIV0_FREQ);
> +	if (ret)
> +		return ret;
> +	ret = clk_set_rate(is->clock[IS_CLK_ISP_DIV1], CLK_ISP_DIV1_FREQ);
> +	if (ret)
> +		return ret;
> +	ret = clk_set_rate(is->clock[IS_CLK_ISP_DIVMPWM],
> +			CLK_ISP_DIVMPWM_FREQ);
> +	return ret;

You can return the return value from clk_set_rate() directly here.

> +}
> +
> +static void fimc_is_pipelines_destroy(struct fimc_is *is)
> +{
> +	int i;
> +
> +	for (i = 0; i < is->drvdata->num_instances; i++)
> +		fimc_is_pipeline_destroy(&is->pipeline[i]);
> +}
> +
> +static int fimc_is_parse_sensor_config(struct fimc_is *is, unsigned int index,
> +						struct device_node *node)
> +{
> +	struct fimc_is_sensor *sensor = &is->sensor[index];
> +	u32 tmp = 0;
> +	int ret;
> +
> +	sensor->drvdata = exynos5_is_sensor_get_drvdata(node);
> +	if (!sensor->drvdata) {
> +		dev_err(&is->pdev->dev, "no driver data found for: %s\n",
> +							 node->full_name);
> +		return -EINVAL;
> +	}
> +
> +	node = v4l2_of_get_next_endpoint(node, NULL);
> +	if (!node)
> +		return -ENXIO;
> +
> +	node = v4l2_of_get_remote_port(node);
> +	if (!node)
> +		return -ENXIO;
> +
> +	/* Use MIPI-CSIS channel id to determine the ISP I2C bus index. */
> +	ret = of_property_read_u32(node, "reg", &tmp);
> +	if (ret < 0) {
> +		dev_err(&is->pdev->dev, "reg property not found at: %s\n",
> +							 node->full_name);
> +		return ret;
> +	}
> +
> +	sensor->i2c_bus = tmp - FIMC_INPUT_MIPI_CSI2_0;
> +	return 0;
> +}
> +
> +static int fimc_is_parse_sensor(struct fimc_is *is)
> +{
> +	struct device_node *i2c_bus, *child;
> +	int ret, index = 0;

You could define ret in the inner loop. Up to you.

> +
> +	for_each_compatible_node(i2c_bus, NULL, FIMC_IS_I2C_COMPATIBLE) {
> +		for_each_available_child_of_node(i2c_bus, child) {
> +			ret = fimc_is_parse_sensor_config(is, index, child);
> +
> +			if (ret < 0 || index >= FIMC_IS_NUM_SENSORS) {
> +				of_node_put(child);
> +				return ret;
> +			}
> +			index++;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void *fimc_is_get_drvdata(struct platform_device *pdev);

By moving the function here, you could avoid having an "extra" prototype for
a local function.

> +static int fimc_is_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct resource *res;
> +	struct fimc_is *is;
> +	void __iomem *regs;
> +	struct device_node *node;
> +	int irq, ret;
> +	int i;
> +
> +	dev_dbg(dev, "FIMC-IS Probe Enter\n");
> +
> +	if (!dev->of_node)
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

irq_of_parse_and_map() returns zero on error.

> +	if (irq < 0) {
> +		dev_err(dev, "Failed to get IRQ\n");
> +		return irq;
> +	}
> +
> +	ret = fimc_is_configure_clocks(is);
> +	if (ret < 0) {
> +		dev_err(dev, "clocks configuration failed\n");
> +		goto err_clk;
> +	}
> +
> +	platform_set_drvdata(pdev, is);
> +	pm_runtime_enable(dev);
> +
> +	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
> +	if (IS_ERR(is->alloc_ctx)) {
> +		ret = PTR_ERR(is->alloc_ctx);
> +		goto err_vb;
> +	}
> +
> +	/* Get IS-sensor contexts */
> +	ret = fimc_is_parse_sensor(is);
> +	if (ret < 0)
> +		goto err_vb;
> +
> +	/* Initialize FIMC Pipeline */
> +	for (i = 0; i < is->drvdata->num_instances; i++) {
> +		ret = fimc_is_pipeline_init(&is->pipeline[i], i, is);
> +		if (ret < 0)
> +			goto err_sd;
> +	}
> +
> +	/* Initialize FIMC Interface */
> +	ret = fimc_is_interface_init(&is->interface, regs, irq);
> +	if (ret < 0)
> +		goto err_sd;
> +
> +	/* Probe the peripheral devices  */
> +	ret = of_platform_populate(dev->of_node, NULL, NULL, dev);
> +	if (ret < 0)
> +		goto err_sd;
> +
> +	dev_dbg(dev, "FIMC-IS registered successfully\n");
> +
> +	return 0;
> +
> +err_sd:
> +	fimc_is_pipelines_destroy(is);
> +err_vb:
> +	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
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
> +	if (ret)
> +		clk_disable(is->clock[IS_CLK_ISP]);
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
> +	if (ret < 0) {
> +		dev_err(dev, "Could not enable clocks\n");
> +		return ret;
> +	}
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
> +	/* TODO */
> +	return 0;
> +}
> +
> +static int fimc_is_suspend(struct device *dev)
> +{
> +	/* TODO */
> +	return 0;
> +}
> +#endif /* CONFIG_PM_SLEEP */
> +
> +static int fimc_is_remove(struct platform_device *pdev)
> +{
> +	struct fimc_is *is = platform_get_drvdata(pdev);
> +	struct device *dev = &pdev->dev;
> +
> +	pm_runtime_disable(dev);
> +	pm_runtime_set_suspended(dev);
> +	fimc_is_pipelines_destroy(is);
> +	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
> +	fimc_is_put_clocks(is);
> +	return 0;
> +}
> +
> +static const struct dev_pm_ops fimc_is_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(fimc_is_suspend, fimc_is_resume)
> +	SET_RUNTIME_PM_OPS(fimc_is_runtime_suspend, fimc_is_runtime_resume,
> +			   NULL)
> +};
> +
> +static struct fimc_is_drvdata exynos5250_drvdata = {
> +	.num_instances	= 1,
> +	.fw_name	= "exynos5_fimc_is_fw.bin",
> +};
> +
> +static const struct of_device_id exynos5_fimc_is_match[] = {
> +	{
> +		.compatible = "samsung,exynos5250-fimc-is",
> +		.data = &exynos5250_drvdata,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, exynos5_fimc_is_match);
> +
> +static void *fimc_is_get_drvdata(struct platform_device *pdev)
> +{
> +	struct fimc_is_drvdata *driver_data = NULL;
> +	const struct of_device_id *match;
> +
> +	match = of_match_node(exynos5_fimc_is_match,
> +			pdev->dev.of_node);
> +	if (match)
> +		driver_data = (struct fimc_is_drvdata *)match->data;
> +	return driver_data;
> +}
> +
> +static struct platform_driver fimc_is_driver = {
> +	.probe		= fimc_is_probe,
> +	.remove		= fimc_is_remove,
> +	.driver = {
> +		.name	= FIMC_IS_DRV_NAME,
> +		.owner	= THIS_MODULE,
> +		.pm	= &fimc_is_pm_ops,
> +		.of_match_table = exynos5_fimc_is_match,
> +	}
> +};
> +module_platform_driver(fimc_is_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Arun Kumar K <arun.kk@samsung.com>");
> +MODULE_DESCRIPTION("Samsung Exynos5 (FIMC-IS) Imaging Subsystem driver");
> diff --git a/drivers/media/platform/exynos5-is/fimc-is-core.h b/drivers/media/platform/exynos5-is/fimc-is-core.h
> new file mode 100644
> index 0000000..c27b603
> --- /dev/null
> +++ b/drivers/media/platform/exynos5-is/fimc-is-core.h
> @@ -0,0 +1,132 @@
> +/*
> + * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + *  Arun Kumar K <arun.kk@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +#ifndef FIMC_IS_CORE_H_
> +#define FIMC_IS_CORE_H_
> +
> +#include <asm/barrier.h>
> +#include <linux/bug.h>
> +#include <linux/clk.h>
> +#include <linux/device.h>
> +#include <linux/errno.h>
> +#include <linux/firmware.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irqreturn.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/sched.h>
> +#include <linux/sizes.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/media-entity.h>
> +#include <media/s5p_fimc.h>
> +#include <media/videobuf2-core.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-mem2mem.h>
> +#include <media/v4l2-mediabus.h>

Same here: do you really need all these headers here?

> +#define FIMC_IS_DRV_NAME		"exynos5-fimc-is"
> +
> +#define FIMC_IS_COMMAND_TIMEOUT		(10 * HZ)
> +#define FIMC_IS_STARTUP_TIMEOUT		(3 * HZ)
> +#define FIMC_IS_SHUTDOWN_TIMEOUT	(10 * HZ)
> +
> +#define FW_SHARED_OFFSET		(0x8c0000)
> +#define DEBUG_CNT			(500 * 1024)
> +#define DEBUG_OFFSET			(0x840000)
> +#define DEBUGCTL_OFFSET			(0x8bd000)
> +#define DEBUG_FCOUNT			(0x8c64c0)
> +
> +#define FIMC_IS_MAX_INSTANCES		1
> +
> +#define FIMC_IS_NUM_SENSORS		2
> +#define FIMC_IS_NUM_PIPELINES		1
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
> +	struct vb2_buffer vb;
> +	struct list_head list;
> +	unsigned int paddr[FIMC_IS_MAX_PLANES];
> +};
> +
> +struct fimc_is_memory {
> +	/* physical base address */
> +	dma_addr_t paddr;
> +	/* virtual base address */
> +	void *vaddr;
> +	/* total length */
> +	unsigned int size;
> +};
> +
> +struct fimc_is_meminfo {
> +	struct fimc_is_memory	fw;
> +	struct fimc_is_memory	shot;
> +	struct fimc_is_memory	region;
> +	struct fimc_is_memory	shared;
> +};
> +
> +struct fimc_is_drvdata {
> +	unsigned int	num_instances;
> +	char		*fw_name;
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

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk

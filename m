Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:26547 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528Ab3CHOkA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 09:40:00 -0500
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org
Cc: s.nawrocki@samsung.com, kgene.kim@samsung.com,
	kilyeon.im@samsung.com, arunkk.samsung@gmail.com
Subject: [RFC 03/12] exynos-fimc-is: Adds fimc-is driver core files
Date: Fri, 08 Mar 2013 09:59:16 -0500
Message-id: <1362754765-2651-4-git-send-email-arun.kk@samsung.com>
In-reply-to: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
References: <1362754765-2651-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This driver is for the FIMC-IS IP available in Samsung Exynos5
SoC onwards. This patch adds the core files for the new driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kilyeon Im <kilyeon.im@samsung.com>
---
 drivers/media/platform/exynos5-is/fimc-is-core.c |  421 ++++++++++++++++++++++
 drivers/media/platform/exynos5-is/fimc-is-core.h |  140 +++++++
 2 files changed, 561 insertions(+)
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.c
 create mode 100644 drivers/media/platform/exynos5-is/fimc-is-core.h

diff --git a/drivers/media/platform/exynos5-is/fimc-is-core.c b/drivers/media/platform/exynos5-is/fimc-is-core.c
new file mode 100644
index 0000000..2a257c5
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-core.c
@@ -0,0 +1,421 @@
+/*
+ * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
+*
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ * Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/bug.h>
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/firmware.h>
+#include <linux/fs.h>
+#include <linux/gpio.h>
+#include <plat/gpio-cfg.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-of.h>
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-contig.h>
+
+#include "fimc-is.h"
+
+int fimc_is_debug;
+module_param(fimc_is_debug, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(fimc_is_debug, "Debug level for exynos-fimc-is driver");
+
+static char *fimc_is_clock_name[] = {
+	[IS_CLK_GATE0]		= "fimc-is0",
+	[IS_CLK_GATE1]		= "fimc-is1",
+	[IS_CLK_266]		= "aclk_266_isp",
+	[IS_CLK_266_DIV0]	= "aclk_266_isp_div0",
+	[IS_CLK_266_DIV1]	= "aclk_266_isp_div1",
+	[IS_CLK_266_DIV_MPWM]	= "aclk_266_isp_divmpwm",
+	[IS_CLK_400]		= "aclk_400_isp",
+	[IS_CLK_400_DIV0]	= "aclk_400_isp_div0",
+	[IS_CLK_400_DIV1]	= "aclk_400_isp_div1",
+};
+
+static int fimc_is_create_sensor_subdevs(struct fimc_is *is)
+{
+	struct fimc_is_platdata *pdata = is->pdata;
+	int ret;
+
+	if (pdata->sensor_data[SENSOR_CAM0].enabled) {
+		/* Sensor0 */
+		ret = fimc_is_sensor_subdev_create(&is->sensor[SENSOR_CAM0],
+				&pdata->sensor_data[SENSOR_CAM0],
+				&is->pipeline);
+		if (ret < 0)
+			is_err("Error creating sensor0 subdev");
+	}
+
+	if (pdata->sensor_data[SENSOR_CAM1].enabled) {
+		/* Sensor1 */
+		ret = fimc_is_sensor_subdev_create(&is->sensor[SENSOR_CAM1],
+				&pdata->sensor_data[SENSOR_CAM1],
+				&is->pipeline);
+		if (ret < 0)
+			is_err("Error creating sensor1 subdev");
+	}
+
+	return 0;
+}
+
+static int fimc_is_unregister_sensor_subdevs(struct fimc_is *is)
+{
+	struct fimc_is_platdata *pdata = is->pdata;
+
+	if (pdata->sensor_data[SENSOR_CAM0].enabled)
+		fimc_is_sensor_subdev_destroy(&is->sensor[SENSOR_CAM0]);
+	if (pdata->sensor_data[SENSOR_CAM1].enabled)
+		fimc_is_sensor_subdev_destroy(&is->sensor[SENSOR_CAM1]);
+
+	return 0;
+}
+
+static struct fimc_is_platdata *fimc_is_parse_dt(struct device *dev)
+{
+	struct device_node *np = dev->of_node;
+	struct device_node *child, *ep, *port;
+	struct fimc_is_platdata *pdata;
+	struct fimc_is_sensor_data *sensor_data;
+	struct v4l2_of_endpoint endpoint;
+	unsigned int i, snum;
+	int num_gpios;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata) {
+		is_err("Memory allocation for pdata failed\n");
+		return NULL;
+	}
+
+	/* Parse sensor properties */
+	for (snum = 0; snum < FIMC_IS_NUM_SENSORS; snum++) {
+
+		child = of_get_next_child(np, child);
+		if (!child) {
+			is_err("Child node not found\n");
+			continue;
+		}
+
+		sensor_data = &pdata->sensor_data[snum];
+		num_gpios = of_gpio_named_count(child, "gpios");
+		if (num_gpios < 0) {
+			is_err("Sensor gpio property not found\n");
+			of_node_put(child);
+			goto exit;
+		}
+		sensor_data->num_gpios = num_gpios;
+		of_property_read_string(child, "compatible",
+				(const char **)&sensor_data->name);
+		is_dbg(1, "Rear sensor name : %s\n", sensor_data->name);
+		for (i = 0; i < num_gpios; i++) {
+			sensor_data->gpios[i] =
+				of_get_named_gpio(child, "gpios", i);
+		}
+		sensor_data->enabled = 1;
+
+		/* Parse ports */
+		ep = child;
+		while ((ep = of_get_next_child(ep, NULL))) {
+			if (!of_node_cmp(ep->name, "endpoint"))
+				break;
+			of_node_put(ep);
+		};
+		if (!ep) {
+			is_err("Sensor end point not defined\n");
+			continue;
+		}
+		port = of_parse_phandle(ep, "remote-endpoint", 0);
+		if (port) {
+			v4l2_of_parse_endpoint(port, &endpoint);
+			sensor_data->csi_id = endpoint.port;
+		}
+
+		of_node_put(port);
+		of_node_put(ep);
+		of_node_put(child);
+	}
+exit:
+	return pdata;
+}
+
+static void fimc_is_clk_put(struct fimc_is *is)
+{
+	int i;
+
+	for (i = 0; i < IS_CLK_MAX_NUM; i++) {
+		if (IS_ERR_OR_NULL(is->clock[i]))
+			continue;
+		clk_unprepare(is->clock[i]);
+		clk_put(is->clock[i]);
+		is->clock[i] = NULL;
+	}
+}
+
+static int fimc_is_clk_get(struct fimc_is *is)
+{
+	struct device *dev = &is->pdev->dev;
+	int i, ret;
+
+	for (i = 0; i < IS_CLK_MAX_NUM; i++) {
+		is->clock[i] = clk_get(dev, fimc_is_clock_name[i]);
+		if (IS_ERR(is->clock[i]))
+			goto err;
+		ret = clk_prepare(is->clock[i]);
+		if (ret < 0) {
+			clk_put(is->clock[i]);
+			is->clock[i] = NULL;
+			goto err;
+		}
+	}
+	return 0;
+err:
+	fimc_is_clk_put(is);
+	is_err("Failed to get clock: %s\n", fimc_is_clock_name[i]);
+	return -ENXIO;
+}
+
+static int fimc_is_clk_cfg(struct fimc_is *is)
+{
+	int ret;
+
+	ret = fimc_is_clk_get(is);
+	if (ret)
+		return ret;
+
+	/* Set rates */
+	ret = clk_set_rate(is->clock[IS_CLK_400_DIV0], 200 * 1000000);
+	ret |= clk_set_rate(is->clock[IS_CLK_400_DIV1], 100 * 1000000);
+	ret |= clk_set_rate(is->clock[IS_CLK_266_DIV0], 134 * 1000000);
+	ret |= clk_set_rate(is->clock[IS_CLK_266_DIV1], 68 * 1000000);
+	ret |= clk_set_rate(is->clock[IS_CLK_266_DIV_MPWM], 34 * 1000000);
+
+	if (ret)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __devinit fimc_is_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct fimc_is_platdata *pdata;
+	struct resource *res;
+	struct fimc_is *is;
+	struct pinctrl *pctrl;
+	void __iomem *regs;
+	int irq, ret;
+
+	pr_debug("FIMC-IS Probe Enter\n");
+
+	pctrl = devm_pinctrl_get_select_default(dev);
+	if (IS_ERR(pctrl)) {
+		dev_err(dev, "Pinctrl configuration failed\n");
+		return -EINVAL;
+	}
+
+	if (!pdev->dev.of_node) {
+		dev_err(dev, "Null platform data\n");
+		return -EINVAL;
+	}
+
+	pdata = fimc_is_parse_dt(dev);
+	if (!pdata) {
+		dev_err(dev, "Parse DT failed\n");
+		return -EINVAL;
+	}
+
+	is = devm_kzalloc(&pdev->dev, sizeof(*is), GFP_KERNEL);
+	if (!is)
+		return -ENOMEM;
+
+	is->pdev = pdev;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	regs = devm_request_and_ioremap(dev, res);
+	if (regs == NULL) {
+		dev_err(dev, "Failed to obtain io memory\n");
+		return -ENOENT;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(dev, "Failed to get IRQ\n");
+		return irq;
+	}
+
+	ret = fimc_is_clk_cfg(is);
+	if (ret < 0) {
+		dev_err(dev, "Clock config failed\n");
+		goto err_clk;
+	}
+
+	platform_set_drvdata(pdev, is);
+	pm_runtime_enable(dev);
+
+	ret = pm_runtime_get_sync(dev);
+	if (ret < 0)
+		goto err_clk;
+
+	is->alloc_ctx = vb2_dma_contig_init_ctx(dev);
+	if (IS_ERR(is->alloc_ctx)) {
+		ret = PTR_ERR(is->alloc_ctx);
+		goto err_pm;
+	}
+
+	/* Create sensor subdevs */
+	is->pdata = pdata;
+	ret = fimc_is_create_sensor_subdevs(is);
+	if (ret < 0)
+		goto err_sensor_sd;
+
+	/* Init FIMC Pipeline */
+	ret = fimc_is_pipeline_init(&is->pipeline, 0, is);
+	if (ret < 0)
+		goto err_sd;
+
+	/* Init FIMC Interface */
+	ret = fimc_is_interface_init(&is->interface, regs, irq);
+	if (ret < 0)
+		goto err_sd;
+
+	dev_dbg(dev, "FIMC-IS registered successfully\n");
+
+	return 0;
+
+err_sd:
+	fimc_is_pipeline_destroy(&is->pipeline);
+err_sensor_sd:
+	fimc_is_unregister_sensor_subdevs(is);
+err_vb:
+	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
+err_pm:
+	pm_runtime_put(dev);
+err_clk:
+	fimc_is_clk_put(is);
+
+	return ret;
+}
+
+int fimc_is_clk_enable(struct fimc_is *is)
+{
+	clk_enable(is->clock[IS_CLK_GATE0]);
+	clk_enable(is->clock[IS_CLK_GATE1]);
+	return 0;
+}
+
+void fimc_is_clk_disable(struct fimc_is *is)
+{
+	clk_disable(is->clock[IS_CLK_GATE0]);
+	clk_disable(is->clock[IS_CLK_GATE1]);
+}
+
+static int fimc_is_pm_resume(struct device *dev)
+{
+	struct fimc_is *is = dev_get_drvdata(dev);
+	int ret;
+
+	ret = fimc_is_clk_enable(is);
+	if (ret < 0)
+		dev_err(dev, "Could not enable clocks\n");
+
+	return 0;
+}
+
+static int fimc_is_pm_suspend(struct device *dev)
+{
+	struct fimc_is *is = dev_get_drvdata(dev);
+
+	fimc_is_clk_disable(is);
+	return 0;
+}
+
+static int fimc_is_runtime_resume(struct device *dev)
+{
+	return fimc_is_pm_resume(dev);
+}
+
+static int fimc_is_runtime_suspend(struct device *dev)
+{
+	return fimc_is_pm_suspend(dev);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int fimc_is_resume(struct device *dev)
+{
+	return fimc_is_pm_resume(dev);
+}
+
+static int fimc_is_suspend(struct device *dev)
+{
+	return fimc_is_pm_suspend(dev);
+}
+#endif /* CONFIG_PM_SLEEP */
+
+static int fimc_is_remove(struct platform_device *pdev)
+{
+	struct fimc_is *is = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	fimc_is_pipeline_destroy(&is->pipeline);
+	fimc_is_unregister_sensor_subdevs(is);
+	vb2_dma_contig_cleanup_ctx(is->alloc_ctx);
+	fimc_is_clk_put(is);
+
+	return 0;
+}
+
+static struct platform_device_id fimc_is_driver_ids[] = {
+	{
+		.name		= "exynos5-fimc-is",
+		.driver_data	= 0,
+	},
+};
+MODULE_DEVICE_TABLE(platform, fimc_is_driver_ids);
+
+static const struct dev_pm_ops fimc_is_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(fimc_is_suspend, fimc_is_resume)
+	SET_RUNTIME_PM_OPS(fimc_is_runtime_suspend, fimc_is_runtime_resume,
+			   NULL)
+};
+
+static struct platform_driver fimc_is_driver = {
+	.probe		= fimc_is_probe,
+	.remove		= fimc_is_remove,
+	.id_table	= fimc_is_driver_ids,
+	.driver = {
+		.name	= FIMC_IS_DRV_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &fimc_is_pm_ops,
+	}
+};
+module_platform_driver(fimc_is_driver);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Arun Kumar K <arun.kk@samsung.com>");
+MODULE_DESCRIPTION("Samsung Exynos5 (FIMC-IS) Imaging Subsystem driver");
diff --git a/drivers/media/platform/exynos5-is/fimc-is-core.h b/drivers/media/platform/exynos5-is/fimc-is-core.h
new file mode 100644
index 0000000..9e09bea
--- /dev/null
+++ b/drivers/media/platform/exynos5-is/fimc-is-core.h
@@ -0,0 +1,140 @@
+/*
+ * Samsung EXYNOS5 FIMC-IS (Imaging Subsystem) driver
+ *
+ * Copyright (C) 2013 Samsung Electronics Co., Ltd.
+ *  Arun Kumar K <arun.kk@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef FIMC_IS_CORE_H_
+#define FIMC_IS_CORE_H_
+
+#include <linux/bug.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <linux/firmware.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+
+#include <asm/barrier.h>
+#include <linux/sizes.h>
+#include <linux/io.h>
+#include <linux/irqreturn.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+
+#include <media/media-entity.h>
+#include <media/videobuf2-core.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mem2mem.h>
+#include <media/v4l2-mediabus.h>
+#include <media/s5p_fimc.h>
+
+#define FIMC_IS_DRV_NAME		"exynos5-fimc-is"
+#define FIMC_IS_CLK_NAME		"fimc_is"
+
+#define FIMC_IS_DEBUG_MSG		0x3f
+#define FIMC_IS_DEBUG_LEVEL		3
+
+#define FIMC_IS_COMMAND_TIMEOUT		(3*HZ)
+#define FIMC_IS_STARTUP_TIMEOUT		(3*HZ)
+#define FIMC_IS_SHUTDOWN_TIMEOUT	(10*HZ)
+
+#define FW_SHARED_OFFSET		(0x8C0000)
+#define DEBUG_CNT			(500*1024)
+#define DEBUG_OFFSET			(0x840000)
+#define DEBUGCTL_OFFSET			(0x8BD000)
+#define DEBUG_FCOUNT			(0x8C64C0)
+
+#define FIMC_IS_MAX_INSTANCES		1
+
+#define FIMC_IS_MAX_GPIOS		32
+#define FIMC_IS_NUM_SENSORS		2
+
+#define FIMC_IS_MAX_PLANES		3
+#define FIMC_IS_NUM_SCALERS		2
+
+enum fimc_is_clks {
+	IS_CLK_GATE0,
+	IS_CLK_GATE1,
+	IS_CLK_266,
+	IS_CLK_266_DIV0,
+	IS_CLK_266_DIV1,
+	IS_CLK_266_DIV_MPWM,
+	IS_CLK_400,
+	IS_CLK_400_DIV0,
+	IS_CLK_400_DIV1,
+	IS_CLK_MAX_NUM,
+};
+
+/* Video capture states */
+enum fimc_is_video_state {
+	STATE_INIT,
+	STATE_BUFS_ALLOCATED,
+	STATE_RUNNING,
+};
+
+enum fimc_is_scaler_id {
+	SCALER_SCC,
+	SCALER_SCP
+};
+
+enum fimc_is_sensor_pos {
+	SENSOR_CAM0,
+	SENSOR_CAM1
+};
+
+struct fimc_is_buf {
+	struct list_head list;
+	struct vb2_buffer *vb;
+	unsigned int paddr[FIMC_IS_MAX_PLANES];
+};
+
+struct fimc_is_meminfo {
+	unsigned int fw_paddr;
+	unsigned int fw_vaddr;
+	unsigned int region_paddr;
+	unsigned int region_vaddr;
+	unsigned int shared_paddr;
+	unsigned int shared_vaddr;
+};
+
+/**
+ * struct fimc_is_fmt - the driver's internal color format data
+ * @name: format description
+ * @fourcc: the fourcc code for this format
+ * @depth: number of bytes per pixel
+ * @num_planes: number of planes for this color format
+ */
+struct fimc_is_fmt {
+	char		*name;
+	unsigned int	fourcc;
+	unsigned int	depth[FIMC_IS_MAX_PLANES];
+	unsigned int	num_planes;
+};
+
+struct fimc_is_sensor_data {
+	int enabled;
+	char *name;
+	unsigned int num_gpios;
+	int gpios[FIMC_IS_MAX_GPIOS];
+	unsigned int csi_id;
+};
+
+struct fimc_is_platdata {
+	struct fimc_is_sensor_data sensor_data[FIMC_IS_NUM_SENSORS];
+};
+
+#endif
-- 
1.7.9.5


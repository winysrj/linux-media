Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:30330 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976Ab1F2MwB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 08:52:01 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LNJ00JALYEIJ4@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:54 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNJ002MPYEFYU@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 29 Jun 2011 13:51:52 +0100 (BST)
Date: Wed, 29 Jun 2011 14:51:16 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 7/8] v4l: s5p-tv: add SDO driver for Samsung S5P platform
In-reply-to: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, t.stanislaws@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com
Message-id: <1309351877-32444-8-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1309351877-32444-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add drivers for Standard Definition output (SDO) on Samsung platforms
from S5P family. The driver provides control over streaming analog TV
via Composite connector.

Driver is using:
- v4l2 framework
- runtime PM

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/s5p-tv/Kconfig    |   11 +
 drivers/media/video/s5p-tv/Makefile   |    2 +
 drivers/media/video/s5p-tv/regs-sdo.h |   63 +++++
 drivers/media/video/s5p-tv/sdo_drv.c  |  479 +++++++++++++++++++++++++++++++++
 4 files changed, 555 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-tv/regs-sdo.h
 create mode 100644 drivers/media/video/s5p-tv/sdo_drv.c

diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
index 893be5b..9c1f634 100644
--- a/drivers/media/video/s5p-tv/Kconfig
+++ b/drivers/media/video/s5p-tv/Kconfig
@@ -46,4 +46,15 @@ config VIDEO_SAMSUNG_S5P_HDMIPHY
 	  as module. It is an I2C driver, that exposes a V4L2
 	  subdev for use by other drivers.
 
+config VIDEO_SAMSUNG_S5P_SDO
+	tristate "Samsung Analog TV Driver"
+	depends on VIDEO_DEV && VIDEO_V4L2
+	depends on VIDEO_SAMSUNG_S5P_TV
+	help
+	  Say Y here if you want support for the analog TV output
+	  interface in S5P Samsung SoC. The driver can be compiled
+	  as module. It is an auxiliary driver, that exposes a V4L2
+	  subdev for use by other drivers. This driver requires
+	  hdmiphy driver to work correctly.
+
 endif # VIDEO_SAMSUNG_S5P_TV
diff --git a/drivers/media/video/s5p-tv/Makefile b/drivers/media/video/s5p-tv/Makefile
index 1b07132..c874d16 100644
--- a/drivers/media/video/s5p-tv/Makefile
+++ b/drivers/media/video/s5p-tv/Makefile
@@ -10,4 +10,6 @@ obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMIPHY) += s5p-hdmiphy.o
 s5p-hdmiphy-y += hdmiphy_drv.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMI) += s5p-hdmi.o
 s5p-hdmi-y += hdmi_drv.o
+obj-$(CONFIG_VIDEO_SAMSUNG_S5P_SDO) += s5p-sdo.o
+s5p-sdo-y += sdo_drv.o
 
diff --git a/drivers/media/video/s5p-tv/regs-sdo.h b/drivers/media/video/s5p-tv/regs-sdo.h
new file mode 100644
index 0000000..7f7c2b8
--- /dev/null
+++ b/drivers/media/video/s5p-tv/regs-sdo.h
@@ -0,0 +1,63 @@
+/* drivers/media/video/s5p-tv/regs-sdo.h
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com/
+ *
+ * SDO register description file
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef SAMSUNG_REGS_SDO_H
+#define SAMSUNG_REGS_SDO_H
+
+/*
+ * Register part
+ */
+
+#define SDO_CLKCON			0x0000
+#define SDO_CONFIG			0x0008
+#define SDO_VBI				0x0014
+#define SDO_DAC				0x003C
+#define SDO_CCCON			0x0180
+#define SDO_IRQ				0x0280
+#define SDO_IRQMASK			0x0284
+#define SDO_VERSION			0x03D8
+
+/*
+ * Bit definition part
+ */
+
+/* SDO Clock Control Register (SDO_CLKCON) */
+#define SDO_TVOUT_SW_RESET		(1 << 4)
+#define SDO_TVOUT_CLOCK_READY		(1 << 1)
+#define SDO_TVOUT_CLOCK_ON		(1 << 0)
+
+/* SDO Video Standard Configuration Register (SDO_CONFIG) */
+#define SDO_PROGRESSIVE			(1 << 4)
+#define SDO_NTSC_M			0
+#define SDO_PAL_M			1
+#define SDO_PAL_BGHID			2
+#define SDO_PAL_N			3
+#define SDO_PAL_NC			4
+#define SDO_NTSC_443			8
+#define SDO_PAL_60			9
+#define SDO_STANDARD_MASK		0xf
+
+/* SDO VBI Configuration Register (SDO_VBI) */
+#define SDO_CVBS_WSS_INS		(1 << 14)
+#define SDO_CVBS_CLOSED_CAPTION_MASK	(3 << 12)
+
+/* SDO DAC Configuration Register (SDO_DAC) */
+#define SDO_POWER_ON_DAC		(1 << 0)
+
+/* SDO Color Compensation On/Off Control (SDO_CCCON) */
+#define SDO_COMPENSATION_BHS_ADJ_OFF	(1 << 4)
+#define SDO_COMPENSATION_CVBS_COMP_OFF	(1 << 0)
+
+/* SDO Interrupt Request Register (SDO_IRQ) */
+#define SDO_VSYNC_IRQ_PEND		(1 << 0)
+
+#endif /* SAMSUNG_REGS_SDO_H */
diff --git a/drivers/media/video/s5p-tv/sdo_drv.c b/drivers/media/video/s5p-tv/sdo_drv.c
new file mode 100644
index 0000000..4dddd6b
--- /dev/null
+++ b/drivers/media/video/s5p-tv/sdo_drv.c
@@ -0,0 +1,479 @@
+/*
+ * Samsung Standard Definition Output (SDO) driver
+ *
+ * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
+ *
+ * Tomasz Stanislawski, <t.stanislaws@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published
+ * by the Free Software Foundiation. either version 2 of the License,
+ * or (at your option) any later version
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/regulator/consumer.h>
+#include <linux/slab.h>
+
+#include <media/v4l2-subdev.h>
+
+#include "regs-sdo.h"
+
+MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
+MODULE_DESCRIPTION("Samsung Standard Definition Output (SDO)");
+MODULE_LICENSE("GPL");
+
+#define SDO_DEFAULT_STD	V4L2_STD_PAL
+
+struct sdo_format {
+	v4l2_std_id id;
+	/* all modes are 720 pixels wide */
+	unsigned int height;
+	unsigned int cookie;
+};
+
+struct sdo_device {
+	/** pointer to device parent */
+	struct device *dev;
+	/** base address of SDO registers */
+	void __iomem *regs;
+	/** SDO interrupt */
+	unsigned int irq;
+	/** DAC source clock */
+	struct clk *sclk_dac;
+	/** DAC clock */
+	struct clk *dac;
+	/** DAC physical interface */
+	struct clk *dacphy;
+	/** clock for control of VPLL */
+	struct clk *fout_vpll;
+	/** regulator for SDO IP power */
+	struct regulator *vdac;
+	/** regulator for SDO plug detection */
+	struct regulator *vdet;
+	/** subdev used as device interface */
+	struct v4l2_subdev sd;
+	/** current format */
+	const struct sdo_format *fmt;
+};
+
+static inline struct sdo_device *sd_to_sdev(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct sdo_device, sd);
+}
+
+static inline
+void sdo_write_mask(struct sdo_device *sdev, u32 reg_id, u32 value, u32 mask)
+{
+	u32 old = readl(sdev->regs + reg_id);
+	value = (value & mask) | (old & ~mask);
+	writel(value, sdev->regs + reg_id);
+}
+
+static inline
+void sdo_write(struct sdo_device *sdev, u32 reg_id, u32 value)
+{
+	writel(value, sdev->regs + reg_id);
+}
+
+static inline
+u32 sdo_read(struct sdo_device *sdev, u32 reg_id)
+{
+	return readl(sdev->regs + reg_id);
+}
+
+static irqreturn_t sdo_irq_handler(int irq, void *dev_data)
+{
+	struct sdo_device *sdev = dev_data;
+
+	/* clear interrupt */
+	sdo_write_mask(sdev, SDO_IRQ, ~0, SDO_VSYNC_IRQ_PEND);
+	return IRQ_HANDLED;
+}
+
+static void sdo_reg_debug(struct sdo_device *sdev)
+{
+#define DBGREG(reg_id) \
+	dev_info(sdev->dev, #reg_id " = %08x\n", \
+		sdo_read(sdev, reg_id))
+
+	DBGREG(SDO_CLKCON);
+	DBGREG(SDO_CONFIG);
+	DBGREG(SDO_VBI);
+	DBGREG(SDO_DAC);
+	DBGREG(SDO_IRQ);
+	DBGREG(SDO_IRQMASK);
+	DBGREG(SDO_VERSION);
+}
+
+static const struct sdo_format sdo_format[] = {
+	{ V4L2_STD_PAL_N,	.height = 576, .cookie = SDO_PAL_N },
+	{ V4L2_STD_PAL_Nc,	.height = 576, .cookie = SDO_PAL_NC },
+	{ V4L2_STD_PAL_M,	.height = 480, .cookie = SDO_PAL_M },
+	{ V4L2_STD_PAL_60,	.height = 480, .cookie = SDO_PAL_60 },
+	{ V4L2_STD_NTSC_443,	.height = 480, .cookie = SDO_NTSC_443 },
+	{ V4L2_STD_PAL,		.height = 576, .cookie = SDO_PAL_BGHID },
+	{ V4L2_STD_NTSC_M,	.height = 480, .cookie = SDO_NTSC_M },
+};
+
+static const struct sdo_format *sdo_find_format(v4l2_std_id id)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(sdo_format); ++i)
+		if (sdo_format[i].id & id)
+			return &sdo_format[i];
+	return NULL;
+}
+
+static int sdo_g_tvnorms_output(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	*std = V4L2_STD_NTSC_M | V4L2_STD_PAL_M | V4L2_STD_PAL |
+		V4L2_STD_PAL_N | V4L2_STD_PAL_Nc |
+		V4L2_STD_NTSC_443 | V4L2_STD_PAL_60;
+	return 0;
+}
+
+static int sdo_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	const struct sdo_format *fmt;
+	fmt = sdo_find_format(std);
+	if (fmt == NULL)
+		return -EINVAL;
+	sdev->fmt = fmt;
+	return 0;
+}
+
+static int sdo_g_std_output(struct v4l2_subdev *sd, v4l2_std_id *std)
+{
+	*std = sd_to_sdev(sd)->fmt->id;
+	return 0;
+}
+
+static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
+	struct v4l2_mbus_framefmt *fmt)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	if (!sdev->fmt)
+		return -ENXIO;
+	/* all modes are 720 pixels wide */
+	fmt->width = 720;
+	fmt->height = sdev->fmt->height;
+	fmt->code = V4L2_MBUS_FMT_FIXED;
+	fmt->field = V4L2_FIELD_INTERLACED;
+	return 0;
+}
+
+static int sdo_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	struct device *dev = sdev->dev;
+	int ret;
+
+	dev_info(dev, "sdo_s_power(%d)\n", on);
+
+	if (on)
+		ret = pm_runtime_get_sync(dev);
+	else
+		ret = pm_runtime_put_sync(dev);
+
+	/* only values < 0 indicate errors */
+	return IS_ERR_VALUE(ret) ? ret : 0;
+}
+
+static int sdo_streamon(struct sdo_device *sdev)
+{
+	/* set proper clock for Timing Generator */
+	clk_set_rate(sdev->fout_vpll, 54000000);
+	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
+	clk_get_rate(sdev->fout_vpll));
+	/* enable clock in SDO */
+	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
+	clk_enable(sdev->dacphy);
+	/* enable DAC */
+	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
+	sdo_reg_debug(sdev);
+	return 0;
+}
+
+static int sdo_streamoff(struct sdo_device *sdev)
+{
+	int tries;
+
+	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
+	clk_disable(sdev->dacphy);
+	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
+	for (tries = 100; tries; --tries) {
+		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
+			break;
+		mdelay(1);
+	}
+	if (tries == 0)
+		dev_err(sdev->dev, "failed to stop streaming\n");
+	return tries ? 0 : -EIO;
+}
+
+static int sdo_s_stream(struct v4l2_subdev *sd, int on)
+{
+	struct sdo_device *sdev = sd_to_sdev(sd);
+	return on ? sdo_streamon(sdev) : sdo_streamoff(sdev);
+}
+
+static const struct v4l2_subdev_core_ops sdo_sd_core_ops = {
+	.s_power = sdo_s_power,
+};
+
+static const struct v4l2_subdev_video_ops sdo_sd_video_ops = {
+	.s_std_output = sdo_s_std_output,
+	.g_std_output = sdo_g_std_output,
+	.g_tvnorms_output = sdo_g_tvnorms_output,
+	.g_mbus_fmt = sdo_g_mbus_fmt,
+	.s_stream = sdo_s_stream,
+};
+
+static const struct v4l2_subdev_ops sdo_sd_ops = {
+	.core = &sdo_sd_core_ops,
+	.video = &sdo_sd_video_ops,
+};
+
+static int sdo_runtime_suspend(struct device *dev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	dev_info(dev, "suspend\n");
+	regulator_disable(sdev->vdet);
+	regulator_disable(sdev->vdac);
+	clk_disable(sdev->sclk_dac);
+	return 0;
+}
+
+static int sdo_runtime_resume(struct device *dev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(dev);
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	dev_info(dev, "resume\n");
+	clk_enable(sdev->sclk_dac);
+	regulator_enable(sdev->vdac);
+	regulator_enable(sdev->vdet);
+
+	/* software reset */
+	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_SW_RESET);
+	mdelay(10);
+	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_SW_RESET);
+
+	/* setting TV mode */
+	sdo_write_mask(sdev, SDO_CONFIG, sdev->fmt->cookie, SDO_STANDARD_MASK);
+	/* XXX: forcing interlaced mode using undocumented bit */
+	sdo_write_mask(sdev, SDO_CONFIG, 0, SDO_PROGRESSIVE);
+	/* turn all VBI off */
+	sdo_write_mask(sdev, SDO_VBI, 0, SDO_CVBS_WSS_INS |
+		SDO_CVBS_CLOSED_CAPTION_MASK);
+	/* turn all post processing off */
+	sdo_write_mask(sdev, SDO_CCCON, ~0, SDO_COMPENSATION_BHS_ADJ_OFF |
+		SDO_COMPENSATION_CVBS_COMP_OFF);
+	sdo_reg_debug(sdev);
+	return 0;
+}
+
+static const struct dev_pm_ops sdo_pm_ops = {
+	.runtime_suspend = sdo_runtime_suspend,
+	.runtime_resume	 = sdo_runtime_resume,
+};
+
+static int __devinit sdo_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sdo_device *sdev;
+	struct resource *res;
+	int ret = 0;
+	struct clk *sclk_vpll;
+
+	dev_info(dev, "probe start\n");
+	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
+	if (!sdev) {
+		dev_err(dev, "not enough memory.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+	sdev->dev = dev;
+
+	/* mapping registers */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(dev, "get memory resource failed.\n");
+		ret = -ENXIO;
+		goto fail_sdev;
+	}
+
+	sdev->regs = ioremap(res->start, resource_size(res));
+	if (sdev->regs == NULL) {
+		dev_err(dev, "register mapping failed.\n");
+		ret = -ENXIO;
+		goto fail_sdev;
+	}
+
+	/* acquiring interrupt */
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(dev, "get interrupt resource failed.\n");
+		ret = -ENXIO;
+		goto fail_regs;
+	}
+	ret = request_irq(res->start, sdo_irq_handler, 0, "s5p-sdo", sdev);
+	if (ret) {
+		dev_err(dev, "request interrupt failed.\n");
+		goto fail_regs;
+	}
+	sdev->irq = res->start;
+
+	/* acquire clocks */
+	sdev->sclk_dac = clk_get(dev, "sclk_dac");
+	if (IS_ERR_OR_NULL(sdev->sclk_dac)) {
+		dev_err(dev, "failed to get clock 'sclk_dac'\n");
+		ret = -ENXIO;
+		goto fail_irq;
+	}
+	sdev->dac = clk_get(dev, "dac");
+	if (IS_ERR_OR_NULL(sdev->dac)) {
+		dev_err(dev, "failed to get clock 'dac'\n");
+		ret = -ENXIO;
+		goto fail_sclk_dac;
+	}
+	sdev->dacphy = clk_get(dev, "dacphy");
+	if (IS_ERR_OR_NULL(sdev->dacphy)) {
+		dev_err(dev, "failed to get clock 'dacphy'\n");
+		ret = -ENXIO;
+		goto fail_dac;
+	}
+	sclk_vpll = clk_get(dev, "sclk_vpll");
+	if (IS_ERR_OR_NULL(sclk_vpll)) {
+		dev_err(dev, "failed to get clock 'sclk_vpll'\n");
+		ret = -ENXIO;
+		goto fail_dacphy;
+	}
+	clk_set_parent(sdev->sclk_dac, sclk_vpll);
+	clk_put(sclk_vpll);
+	sdev->fout_vpll = clk_get(dev, "fout_vpll");
+	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
+		dev_err(dev, "failed to get clock 'fout_vpll'\n");
+		goto fail_dacphy;
+	}
+	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
+
+	/* acquire regulator */
+	sdev->vdac = regulator_get(dev, "vdd33a_dac");
+	if (IS_ERR_OR_NULL(sdev->vdac)) {
+		dev_err(dev, "failed to get regulator 'vdac'\n");
+		goto fail_fout_vpll;
+	}
+	sdev->vdet = regulator_get(dev, "vdet");
+	if (IS_ERR_OR_NULL(sdev->vdet)) {
+		dev_err(dev, "failed to get regulator 'vdet'\n");
+		goto fail_vdac;
+	}
+
+	/* enable gate for dac clock, because mixer uses it */
+	clk_enable(sdev->dac);
+
+	/* configure power management */
+	pm_runtime_enable(dev);
+
+	/* configuration of interface subdevice */
+	v4l2_subdev_init(&sdev->sd, &sdo_sd_ops);
+	sdev->sd.owner = THIS_MODULE;
+	strlcpy(sdev->sd.name, "s5p-sdo", sizeof sdev->sd.name);
+
+	/* set default format */
+	sdev->fmt = sdo_find_format(SDO_DEFAULT_STD);
+	BUG_ON(sdev->fmt == NULL);
+
+	/* keeping subdev in device's private for use by other drivers */
+	dev_set_drvdata(dev, &sdev->sd);
+
+	dev_info(dev, "probe succeeded\n");
+	return 0;
+
+fail_vdac:
+	regulator_put(sdev->vdac);
+fail_fout_vpll:
+	clk_put(sdev->fout_vpll);
+fail_dacphy:
+	clk_put(sdev->dacphy);
+fail_dac:
+	clk_put(sdev->dac);
+fail_sclk_dac:
+	clk_put(sdev->sclk_dac);
+fail_irq:
+	free_irq(sdev->irq, sdev);
+fail_regs:
+	iounmap(sdev->regs);
+fail_sdev:
+	kfree(sdev);
+fail:
+	dev_info(dev, "probe failed\n");
+	return ret;
+}
+
+static int __devexit sdo_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = dev_get_drvdata(&pdev->dev);
+	struct sdo_device *sdev = sd_to_sdev(sd);
+
+	pm_runtime_disable(&pdev->dev);
+	clk_disable(sdev->dac);
+	regulator_put(sdev->vdet);
+	regulator_put(sdev->vdac);
+	clk_put(sdev->fout_vpll);
+	clk_put(sdev->dacphy);
+	clk_put(sdev->dac);
+	clk_put(sdev->sclk_dac);
+	free_irq(sdev->irq, sdev);
+	iounmap(sdev->regs);
+	kfree(sdev);
+
+	dev_info(&pdev->dev, "remove successful\n");
+	return 0;
+}
+
+static struct platform_driver sdo_driver __refdata = {
+	.probe = sdo_probe,
+	.remove = __devexit_p(sdo_remove),
+	.driver = {
+		.name = "s5p-sdo",
+		.owner = THIS_MODULE,
+		.pm = &sdo_pm_ops,
+	}
+};
+
+static int __init sdo_init(void)
+{
+	int ret;
+	static const char banner[] __initdata = KERN_INFO \
+		"Samsung Standard Definition Output (SDO) driver, "
+		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
+	printk(banner);
+
+	ret = platform_driver_register(&sdo_driver);
+	if (ret)
+		printk(KERN_ERR "SDO platform driver register failed\n");
+
+	return ret;
+}
+module_init(sdo_init);
+
+static void __exit sdo_exit(void)
+{
+	platform_driver_unregister(&sdo_driver);
+}
+module_exit(sdo_exit);
-- 
1.7.5.4


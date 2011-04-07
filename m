Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58780 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab1DGQru (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 12:47:50 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 07 Apr 2011 18:47:35 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 3/3] v4l: Add v4l2 subdev driver for S5P/EXYNOS4 MIPI-CSI
	receivers
In-reply-to: <1302194855-29205-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kgene.kim@samsung.com, sungchun.kang@samsung.com,
	jonghun.han@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1302194855-29205-4-git-send-email-s.nawrocki@samsung.com>
References: <1302194855-29205-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add the subdev driver for the MIPI CSIS units available in
S5P and Exynos4 SoC series. This driver supports both CSIS0
and CSIS1 MIPI-CSI2 receivers. The corresponding PHYs are
controlled through the platform data callback. The driver
requires Runtime PM to be enabled for proper operation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/Kconfig              |    6 +
 drivers/media/video/s5p-fimc/Makefile    |    2 +
 drivers/media/video/s5p-fimc/mipi-csis.c |  746 ++++++++++++++++++++++++++++++
 drivers/media/video/s5p-fimc/mipi-csis.h |   18 +
 4 files changed, 772 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.c
 create mode 100644 drivers/media/video/s5p-fimc/mipi-csis.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 492f2ef..018ce88 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -936,6 +936,12 @@ config  VIDEO_SAMSUNG_S5P_FIMC
 	  This is a v4l2 driver for the S5P and EXYNOS4 camera host interface
 	  and video postprocessor.
 
+config VIDEO_S5P_MIPI_CSIS
+	tristate "S5P and EXYNOS4 MIPI CSI Receiver driver"
+	depends on VIDEO_V4L2 && VIDEO_SAMSUNG_S5P_FIMC
+	---help---
+	  This is a v4l2 driver for the S5P/EXYNOS4 MIPI-CSI Receivers
+
 #
 # USB Multimedia device configuration
 #
diff --git a/drivers/media/video/s5p-fimc/Makefile b/drivers/media/video/s5p-fimc/Makefile
index 7ea1b14..72207de 100644
--- a/drivers/media/video/s5p-fimc/Makefile
+++ b/drivers/media/video/s5p-fimc/Makefile
@@ -1,3 +1,5 @@
 
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) := s5p-fimc.o
 s5p-fimc-y := fimc-core.o fimc-reg.o fimc-capture.o
+
+obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS) += mipi-csis.o
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
new file mode 100644
index 0000000..9502b94
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -0,0 +1,746 @@
+/*
+ * Samsung S5P SoC series MIPI-CSI receiver driver
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ * Contact: Sylwester Nawrocki, <s.nawrocki@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+#include <linux/memory.h>
+#include <linux/regulator/consumer.h>
+#include <linux/pm_runtime.h>
+#include <plat/mipi_csis.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-subdev.h>
+#include "mipi-csis.h"
+
+static int debug = 10;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Debug level (0-1)");
+
+/* Register map definition */
+
+/* CSIS global control */
+#define S5P_CSIS_CTRL			0x00
+#define S5P_CSIS_CTRL_DPDN_DEFAULT	(0 << 31)
+#define S5P_CSIS_CTRL_DPDN_SWAP		(1 << 31)
+#define S5P_CSIS_CTRL_ALIGN_32BIT	(1 << 20)
+#define S5P_CSIS_CTRL_UPDATE_SHADOW	(1 << 16)
+#define S5P_CSIS_CTRL_WCLK_EXTCLK	(1 << 8)
+#define S5P_CSIS_CTRL_RESET		(1 << 4)
+#define S5P_CSIS_CTRL_ENABLE		(1 << 0)
+
+/* D-PHY control */
+#define S5P_CSIS_DPHYCTRL		0x04
+#define S5P_CSIS_DPHYCTRL_HSS_MASK	(0x1f << 27)
+#define S5P_CSIS_DPHYCTRL_ENABLE	(0x1f << 0)
+
+#define S5P_CSIS_CONFIG			0x08
+#define S5P_CSIS_CFG_FMT_YCBCR422_8BIT	(0x1e << 2)
+#define S5P_CSIS_CFG_FMT_RAW8		(0x2a << 2)
+#define S5P_CSIS_CFG_FMT_RAW10		(0x2b << 2)
+#define S5P_CSIS_CFG_FMT_RAW12		(0x2c << 2)
+/* User defined formats, x = 1...4 */
+#define S5P_CSIS_CFG_FMT_USER(x)	((0x30 + x - 1) << 2)
+#define S5P_CSIS_CFG_FMT_MASK		(0x3f << 2)
+#define S5P_CSIS_CFG_NR_LANE_MASK	3
+
+/* Interrupt mask. */
+#define S5P_CSIS_INTMSK			0x10
+#define S5P_CSIS_INTMSK_EN_ALL		0xf000003f
+#define S5P_CSIS_INTSRC			0x14
+
+/* Pixel resolution */
+#define S5P_CSIS_RESOL			0x2c
+#define CSIS_MAX_PIX_WIDTH		0xffff
+#define CSIS_MAX_PIX_HEIGHT		0xffff
+
+enum {
+	CSIS_CLK_MUX,
+	CSIS_CLK_GATE,
+};
+
+static char *csi_clock_name[] = {
+	[CSIS_CLK_MUX]  = "sclk_csis",
+	[CSIS_CLK_GATE] = "csis",
+};
+#define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
+
+enum {
+	ST_POWERED	= 1,
+	ST_STREAMING	= 2,
+	ST_SUSPENDED	= 4,
+	ST_CLK_ON	= 8,
+};
+
+struct csis_state {
+	struct mutex lock;
+	struct media_pad pads[CSIS_PADS_NUM];
+	struct v4l2_subdev sd;
+	struct platform_device *pdev;
+	struct resource *regs_res;
+	void __iomem *regs;
+	struct clk *clock[NUM_CSIS_CLOCKS];
+	int irq;
+	struct regulator *supply;
+	u32 flags;
+	/* Common format for the source and sink pad. */
+	const struct csis_pix_format *csis_fmt;
+	struct v4l2_mbus_framefmt mf;
+};
+
+struct csis_pix_format {
+	enum v4l2_mbus_pixelcode code;
+	u32 fmt_reg;
+	u16 pix_hor_align;
+};
+
+static const struct csis_pix_format s5p_csis_formats[] = {
+	{
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.fmt_reg	= S5P_CSIS_CFG_FMT_YCBCR422_8BIT,
+		.pix_hor_align	= 1,
+	},
+	{
+		.code		= V4L2_MBUS_FMT_JPEG_1X8,
+		.fmt_reg	= S5P_CSIS_CFG_FMT_USER(1),
+		.pix_hor_align	= 1,
+	},
+};
+
+#define IS_CSIS_PAD_VALID(pad) (pad == CSIS_PAD_SOURCE || pad == CSIS_PAD_SINK)
+
+static struct csis_state *sd_to_csis_state(struct v4l2_subdev *sdev)
+{
+	return container_of(sdev, struct csis_state, sd);
+}
+
+static const struct csis_pix_format *
+find_csis_format(struct v4l2_mbus_framefmt *mf)
+{
+	int i = ARRAY_SIZE(s5p_csis_formats);
+
+	while (i--)
+		if (mf->code == s5p_csis_formats[i].code)
+			break;
+
+	if (i >= ARRAY_SIZE(s5p_csis_formats))
+		return NULL;
+
+	return &s5p_csis_formats[i];
+}
+
+static void s5p_csis_enable_interrupts(struct csis_state *state, bool on)
+{
+	u32 reg = readl(state->regs + S5P_CSIS_CTRL);
+
+	if (on)
+		reg |= S5P_CSIS_INTMSK_EN_ALL;
+	else
+		reg &= ~S5P_CSIS_INTMSK_EN_ALL;
+	writel(reg, state->regs + S5P_CSIS_INTMSK);
+}
+
+static void s5p_csis_reset(struct csis_state *state)
+{
+	u32 reg = readl(state->regs + S5P_CSIS_CTRL);
+
+	writel(reg | S5P_CSIS_CTRL_RESET, state->regs + S5P_CSIS_CTRL);
+	udelay(10);
+}
+
+static void s5p_csis_system_enable(struct csis_state *state, int on)
+{
+	u32 reg;
+
+	reg = readl(state->regs + S5P_CSIS_CTRL);
+	if (on)
+		reg |= S5P_CSIS_CTRL_ENABLE;
+	else
+		reg &= ~S5P_CSIS_CTRL_ENABLE;
+	writel(reg, state->regs + S5P_CSIS_CTRL);
+
+	reg = readl(state->regs + S5P_CSIS_DPHYCTRL);
+	if (on)
+		reg |= S5P_CSIS_DPHYCTRL_ENABLE;
+	else
+		reg &= ~S5P_CSIS_DPHYCTRL_ENABLE;
+	writel(reg, state->regs + S5P_CSIS_DPHYCTRL);
+}
+
+static int __s5p_csis_set_format(struct csis_state *state)
+{
+	u32 reg;
+
+	v4l2_dbg(1, debug, &state->sd, "fmt: %d, %d x %d\n",
+		 state->mf.code, state->mf.width, state->mf.height);
+
+	if (WARN_ON(state->csis_fmt == NULL))
+		return -EINVAL;
+
+	/* Color format */
+	reg = readl(state->regs + S5P_CSIS_CONFIG);
+	reg = (reg & ~S5P_CSIS_CFG_FMT_MASK) | state->csis_fmt->fmt_reg;
+	writel(reg, state->regs + S5P_CSIS_CONFIG);
+
+	/* Pixel resolution */
+	reg = (state->mf.width << 16) | state->mf.height;
+	writel(reg, state->regs + S5P_CSIS_RESOL);
+
+	return 0;
+}
+
+static void s5p_csis_set_hsync_settle(struct csis_state *state,
+				      int settle)
+{
+	u32 reg = readl(state->regs + S5P_CSIS_DPHYCTRL);
+
+	reg &= ~S5P_CSIS_DPHYCTRL_HSS_MASK;
+	reg |= (settle << 27);
+	writel(reg, state->regs + S5P_CSIS_DPHYCTRL);
+}
+
+static int s5p_csis_set_params(struct csis_state *state)
+{
+	struct s5p_platform_mipi_csis *pdata = state->pdev->dev.platform_data;
+	u32 reg, tmp;
+	int ret;
+
+	reg = readl(state->regs + S5P_CSIS_CONFIG);
+	reg &= ~S5P_CSIS_CFG_NR_LANE_MASK;
+	tmp = (pdata->lanes - 1) & 0x3;
+	writel(reg | tmp, state->regs + S5P_CSIS_CONFIG);
+
+	ret = __s5p_csis_set_format(state);
+	if (ret)
+		return ret;
+
+	s5p_csis_set_hsync_settle(state, pdata->hs_settle);
+
+	reg = readl(state->regs + S5P_CSIS_CTRL);
+
+	if (pdata->alignment == 32)
+		reg |= S5P_CSIS_CTRL_ALIGN_32BIT;
+	else /* 24-bits */
+		reg &= ~S5P_CSIS_CTRL_ALIGN_32BIT;
+
+	/* Not using external clock. */
+	reg &= ~S5P_CSIS_CTRL_WCLK_EXTCLK;
+
+	writel(reg, state->regs + S5P_CSIS_CTRL);
+
+	/* Update the shadow register. */
+	reg = readl(state->regs + S5P_CSIS_CTRL);
+	writel(reg | S5P_CSIS_CTRL_UPDATE_SHADOW,
+	       state->regs + S5P_CSIS_CTRL);
+
+	return 0;
+}
+
+static void s5p_csis_clk_put(struct csis_state *state)
+{
+	int i;
+
+	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
+		if (!IS_ERR(state->clock[i]))
+			clk_put(state->clock[i]);
+	}
+}
+
+static int s5p_csis_clk_get(struct csis_state *state)
+{
+	struct device *dev = &state->pdev->dev;
+	int i;
+
+	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
+		state->clock[i] = clk_get(dev, csi_clock_name[i]);
+
+		if (IS_ERR(state->clock[i])) {
+			s5p_csis_clk_put(state);
+			dev_err(dev, "failed to get clock: %s\n",
+				csi_clock_name[i]);
+			return -ENXIO;
+		}
+	}
+	return 0;
+}
+
+/* Called with the state.lock held. */
+static int __csis_set_power(struct csis_state *state, bool on)
+{
+	struct s5p_platform_mipi_csis *pdata = state->pdev->dev.platform_data;
+	int ret = 0;
+
+	if (on) {
+		if (state->supply)
+			ret = regulator_enable(state->supply);
+		if (!ret)
+			ret = pdata->phy_enable(state->pdev, true);
+		if (!ret)
+			state->flags |= ST_POWERED;
+		return ret;
+	}
+
+	ret = pdata->phy_enable(state->pdev, false);
+	if (!ret && state->supply)
+		ret = regulator_disable(state->supply);
+	if (!ret)
+		state->flags &= ~ST_POWERED;
+
+	return ret;
+}
+
+static int s5p_csis_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct csis_state *state = sd_to_csis_state(sd);
+	struct device *dev = &state->pdev->dev;
+	int ret = -EINVAL;
+
+	v4l2_dbg(1, debug, sd, "%s: on: %d, flags: 0x%x\n",
+		 __func__, on, state->flags);
+
+	mutex_lock(&state->lock);
+	if (!(state->flags & ST_POWERED) == !on)
+		ret = 0;
+	mutex_unlock(&state->lock);
+
+	if (!ret)
+		return ret;
+	if (on)
+		return pm_runtime_get_sync(dev);
+
+	return pm_runtime_put_sync(dev);
+}
+
+static int s5p_csis_start_stream(struct csis_state *state)
+{
+	int ret;
+
+	s5p_csis_reset(state);
+	ret = s5p_csis_set_params(state);
+	if (ret)
+		return ret;
+
+	s5p_csis_system_enable(state, true);
+	s5p_csis_enable_interrupts(state, true);
+
+	return 0;
+}
+
+static void s5p_csis_stop_stream(struct csis_state *state)
+{
+	s5p_csis_enable_interrupts(state, false);
+	s5p_csis_system_enable(state, false);
+}
+
+static int s5p_csis_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct csis_state *state = sd_to_csis_state(sd);
+	int ret = 0;
+
+	v4l2_dbg(1, debug, sd, "%s: %d, state: 0x%x\n",
+		 __func__, enable, state->flags);
+
+	mutex_lock(&state->lock);
+	if (state->flags & ST_SUSPENDED) {
+		mutex_lock(&state->lock);
+		return -EBUSY;
+	}
+
+	if (enable) {
+		ret = s5p_csis_start_stream(state);
+		if (!ret)
+			state->flags |= ST_STREAMING;
+	} else {
+		s5p_csis_stop_stream(state);
+			state->flags &= ~ST_STREAMING;
+	}
+	mutex_unlock(&state->lock);
+
+	return ret;
+}
+
+static int s5p_csis_enum_mbus_code(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_mbus_code_enum *code)
+{
+	if (code->index >= ARRAY_SIZE(s5p_csis_formats))
+		return -EINVAL;
+
+	code->code = s5p_csis_formats[code->index].code;
+	return 0;
+}
+
+static void s5p_csis_try_format(struct v4l2_mbus_framefmt *mf)
+{
+	struct csis_pix_format const *csis_fmt;
+
+	csis_fmt = find_csis_format(mf);
+	if (csis_fmt == NULL)
+		csis_fmt = &s5p_csis_formats[0];
+
+	mf->code = csis_fmt->code;
+	v4l_bound_align_image(&mf->width, 1, CSIS_MAX_PIX_WIDTH,
+			      csis_fmt->pix_hor_align,
+			      &mf->height, 1, CSIS_MAX_PIX_HEIGHT, 1,
+			      0);
+}
+
+static int s5p_csis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_format *fmt)
+{
+	struct csis_state *state = sd_to_csis_state(sd);
+	struct v4l2_mbus_framefmt *mf = &fmt->format;
+	struct csis_pix_format const *csis_fmt = find_csis_format(mf);
+
+	v4l2_dbg(1, debug, sd, "%s: %dx%d, code: %x, csis_fmt: %p\n",
+		 __func__, mf->width, mf->height, mf->code, csis_fmt);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		s5p_csis_try_format(mf);
+		return 0;
+	}
+
+	/* Both source and sink pad have always same format. */
+	if (!IS_CSIS_PAD_VALID(fmt->pad) ||
+	    csis_fmt == NULL ||
+	    mf->width > CSIS_MAX_PIX_WIDTH  ||
+	    mf->height > CSIS_MAX_PIX_HEIGHT ||
+	    mf->width & (u32)(csis_fmt->pix_hor_align - 1))
+		return -EINVAL;
+
+	state->mf = *mf;
+	state->csis_fmt = csis_fmt;
+	return 0;
+}
+
+static int s5p_csis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_format *fmt)
+{
+	if (!IS_CSIS_PAD_VALID(fmt->pad))
+		return -EINVAL;
+
+	fmt->format = sd_to_csis_state(sd)->mf;
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops s5p_csis_core_ops = {
+	.s_power = s5p_csis_s_power,
+};
+
+static struct v4l2_subdev_pad_ops s5p_csis_pad_ops = {
+	.enum_mbus_code = s5p_csis_enum_mbus_code,
+	.get_fmt = s5p_csis_get_fmt,
+	.set_fmt = s5p_csis_set_fmt,
+};
+
+static struct v4l2_subdev_video_ops s5p_csis_video_ops = {
+	.s_stream = s5p_csis_s_stream,
+};
+
+static struct v4l2_subdev_ops s5p_csis_subdev_ops = {
+	.core = &s5p_csis_core_ops,
+	.pad = &s5p_csis_pad_ops,
+	.video	= &s5p_csis_video_ops,
+};
+
+static irqreturn_t s5p_csis_isr(int irq, void *dev_id)
+{
+	struct csis_state *state = dev_id;
+	u32 reg;
+
+	/* Just clear the interrupt pending bits. */
+	reg = readl(state->regs + S5P_CSIS_INTSRC);
+	writel(reg, state->regs + S5P_CSIS_INTSRC);
+
+	return IRQ_HANDLED;
+}
+
+static int s5p_csis_probe(struct platform_device *pdev)
+{
+	struct s5p_platform_mipi_csis *pdata;
+	struct resource *mem_res;
+	struct resource *regs_res;
+	struct csis_state *state;
+	struct media_entity *entity;
+	int ret = -ENODEV;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	mutex_init(&state->lock);
+	state->pdev = pdev;
+
+	pdata = pdev->dev.platform_data;
+	if (pdata == NULL || pdata->phy_enable == NULL) {
+		dev_err(&pdev->dev, "Platform data not fully specified\n");
+		goto p_err1;
+	}
+
+	if ((pdev->id == 1 && pdata->lanes > CSIS1_MAX_LANES) ||
+	    pdata->lanes > CSIS0_MAX_LANES) {
+		dev_err(&pdev->dev, "Unsupported number of data lanes: %d\n",
+			pdata->lanes);
+		goto p_err1;
+	}
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res) {
+		dev_err(&pdev->dev, "Failed to get io memory region\n");
+		goto p_err1;
+	}
+
+	regs_res = request_mem_region(mem_res->start, resource_size(mem_res),
+				      pdev->name);
+	if (!regs_res) {
+		dev_err(&pdev->dev, "Failed to request io memory region\n");
+		goto p_err1;
+	}
+	state->regs_res = regs_res;
+
+	state->regs = ioremap(mem_res->start, resource_size(mem_res));
+	if (!state->regs) {
+		dev_err(&pdev->dev, "Failed to remap io region\n");
+		goto p_err2;
+	}
+
+	if (s5p_csis_clk_get(state))
+		goto p_err3;
+
+	clk_enable(state->clock[CSIS_CLK_MUX]);
+	if (pdata->clk_rate)
+		clk_set_rate(state->clock[CSIS_CLK_MUX], pdata->clk_rate);
+	else
+		dev_warn(&pdev->dev, "No clock frequency specified!\n");
+
+	ret = pdata->phy_enable(state->pdev, false);
+	if (ret)
+		goto p_err4;
+
+	state->irq = platform_get_irq(pdev, 0);
+	if (state->irq < 0) {
+		dev_err(&pdev->dev, "Failed to get irq\n");
+		goto p_err4;
+	}
+
+	if (!pdata->fixed_phy_vdd) {
+		state->supply = regulator_get(&pdev->dev, "vdd");
+		if (IS_ERR(state->supply)) {
+			state->supply = NULL;
+			goto p_err4;
+		}
+	}
+
+	ret = request_irq(state->irq, s5p_csis_isr, 0, CSIS_MODULE_NAME, state);
+	if (ret) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		goto p_err4;
+	}
+
+	v4l2_subdev_init(&state->sd, &s5p_csis_subdev_ops);
+	state->sd.owner = THIS_MODULE;
+	strlcpy(state->sd.name, CSIS_MODULE_NAME, sizeof(state->sd.name));
+
+	entity = &state->sd.entity;
+	state->pads[CSIS_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	state->pads[CSIS_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	ret = media_entity_init(&state->sd.entity,
+				CSIS_PADS_NUM, state->pads, 0);
+	if (ret < 0)
+		goto p_err4;
+
+	/* This allows to retrieve the platform device id by the host driver */
+	v4l2_set_subdevdata(&state->sd, pdev);
+
+	/* .. and a pointer to the subdev. */
+	platform_set_drvdata(pdev, &state->sd);
+
+	pm_runtime_enable(&pdev->dev);
+
+	return 0;
+
+p_err4:
+	if (state->supply)
+		regulator_put(state->supply);
+
+	clk_disable(state->clock[CSIS_CLK_MUX]);
+	s5p_csis_clk_put(state);
+p_err3:
+	iounmap(state->regs);
+p_err2:
+	release_mem_region(regs_res->start, resource_size(regs_res));
+p_err1:
+	kfree(state);
+	return ret;
+}
+
+static int s5p_csis_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct csis_state *state = sd_to_csis_state(sd);
+	struct resource *res = state->regs_res;
+
+	pm_runtime_disable(&pdev->dev);
+
+	mutex_lock(&state->lock);
+
+	/* Power off MIPI CSIS and PHY and disable the CSIS clock. */
+	if (state->flags & ST_POWERED) {
+		s5p_csis_stop_stream(state);
+		__csis_set_power(state, false);
+		clk_disable(state->clock[CSIS_CLK_GATE]);
+	}
+	clk_disable(state->clock[CSIS_CLK_MUX]);
+
+	pm_runtime_set_suspended(&pdev->dev);
+	s5p_csis_clk_put(state);
+
+	if (state->supply)
+		regulator_put(state->supply);
+
+	mutex_unlock(&state->lock);
+
+	free_irq(state->irq, state);
+	iounmap(state->regs);
+	release_mem_region(res->start, resource_size(res));
+	kfree(state);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int s5p_csis_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct csis_state *state = sd_to_csis_state(sd);
+
+	mutex_lock(&state->lock);
+
+	v4l2_dbg(1, debug, sd, "%s: flags: 0x%x\n",
+		 __func__, state->flags);
+
+	if (state->flags & ST_POWERED) {
+		s5p_csis_stop_stream(state);
+		clk_disable(state->clock[CSIS_CLK_GATE]);
+		__csis_set_power(state, 0);
+	}
+	state->flags |= ST_SUSPENDED;
+	mutex_unlock(&state->lock);
+
+	return 0;
+}
+
+static int s5p_csis_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct csis_state *state = sd_to_csis_state(sd);
+
+	mutex_lock(&state->lock);
+
+	v4l2_dbg(1, debug, sd, "%s: flags: 0x%x\n",
+		 __func__, state->flags);
+
+	if (!(state->flags & ST_POWERED)) {
+		__csis_set_power(state, 1);
+		clk_enable(state->clock[CSIS_CLK_GATE]);
+	}
+
+	if (state->flags & ST_STREAMING)
+		s5p_csis_start_stream(state);
+
+	state->flags &= ~ST_SUSPENDED;
+	mutex_unlock(&state->lock);
+
+	return 0;
+}
+
+static int s5p_csis_pm_suspend(struct device *dev)
+{
+	return s5p_csis_suspend(dev);
+}
+
+static int s5p_csis_pm_resume(struct device *dev)
+{
+	int ret;
+
+	ret = s5p_csis_resume(dev);
+
+	if (!ret) {
+		pm_runtime_disable(dev);
+		ret = pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
+
+	return ret;
+}
+#else
+#define s5p_csis_pm_suspend NULL
+#define s5p_csis_pm_resume NULL
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+static int s5p_csis_runtime_suspend(struct device *dev)
+{
+	return s5p_csis_suspend(dev);
+}
+
+static int s5p_csis_runtime_resume(struct device *dev)
+{
+	return s5p_csis_resume(dev);
+}
+
+#else
+#define s5p_csis_runtime_suspend NULL
+#define s5p_csis_runtime_resume NULL
+#endif
+
+static const struct dev_pm_ops s5p_csis_pm_ops = {
+	.runtime_suspend = s5p_csis_runtime_suspend,
+	.runtime_resume	 = s5p_csis_runtime_resume,
+	.suspend	 = s5p_csis_pm_suspend,
+	.resume		 = s5p_csis_pm_resume,
+};
+
+static struct platform_driver s5p_csis_driver = {
+	.probe		= s5p_csis_probe,
+	.remove		= s5p_csis_remove,
+	.driver		= {
+		.name	= CSIS_MODULE_NAME,
+		.owner	= THIS_MODULE,
+		.pm	= &s5p_csis_pm_ops,
+	},
+};
+
+static int __init s5p_csis_init(void)
+{
+	return platform_driver_probe(&s5p_csis_driver, s5p_csis_probe);
+}
+
+static void __exit s5p_csis_exit(void)
+{
+	platform_driver_unregister(&s5p_csis_driver);
+}
+
+module_init(s5p_csis_init);
+module_exit(s5p_csis_exit);
+
+MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
+MODULE_DESCRIPTION("S5P/EXYNOS4 MIPI CSI receiver driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/s5p-fimc/mipi-csis.h b/drivers/media/video/s5p-fimc/mipi-csis.h
new file mode 100644
index 0000000..b72a2e5
--- /dev/null
+++ b/drivers/media/video/s5p-fimc/mipi-csis.h
@@ -0,0 +1,18 @@
+/*
+ * Samsung S5P SoC series MIPI-CSI receiver driver
+ *
+ * Copyright (C) 2011 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define CSIS_MODULE_NAME	"s5p-mipi-csis"
+#define CSIS_MAX_ENTITIES	2
+#define CSIS0_MAX_LANES		4
+#define CSIS1_MAX_LANES		2
+
+#define CSIS_PAD_SINK		0
+#define CSIS_PAD_SOURCE		1
+#define CSIS_PADS_NUM		2
-- 
1.7.4.3

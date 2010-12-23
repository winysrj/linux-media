Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:26633 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab0LWT0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Dec 2010 14:26:23 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Thu, 23 Dec 2010 20:26:15 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH] v4l: Add S5P MIPI-CSI2 interface subdev driver
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1293132375-26342-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Add the v4l2 subdev/platform device driver for S5P SoC MIPI-CSI2
slave devices.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---

Hello,

this patch adds a v4l2 subdev/platform device driver for S5P SoC MIPI-CSI2
slave devices.On S5PVXXX SoC there might be up two MIPI-CSI channels.
This driver creates for each channel a subdev instance which is intended
to interwork with the s5pc-fimc host driver. I am going to post 
the patches for the s5p fimc driver in near future so it can be seen how 
the subdevs are used.
We are looking forward to use the media controller framework
with S5P SoC for camera devices control, since the SoC architecture
is relatively complex and flexible in configuration.
There are up to 4 camera host interfaces with scaler, rotator
and color format converter, up to 2 MIPI-CSI2 interfaces and
there are also available datapaths to and from up to 2 LCD controllers.

Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center

---
 drivers/media/video/Kconfig         |    8 +
 drivers/media/video/Makefile        |    1 +
 drivers/media/video/s5p-mipi_csis.c |  592 +++++++++++++++++++++++++++++++++++
 3 files changed, 601 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/s5p-mipi_csis.c

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index da08267..04441aa 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -732,6 +732,13 @@ config VIDEO_VIA_CAMERA
 	   Chrome9 chipsets.  Currently only tested on OLPC xo-1.5 systems
 	   with ov7670 sensors.
 
+config VIDEO_S5P_MIPI_CSIS
+	bool "S5P MIPI-CSI2 slave iterface support"
+	depends on VIDEO_V4L2
+	---help---
+	  This is video4linux driver for MIPI CSI2 interfaces
+	  in Samsung S5P SoCs.
+
 config SOC_CAMERA
 	tristate "SoC camera support"
 	depends on VIDEO_V4L2 && HAS_DMA && I2C
@@ -1000,6 +1007,7 @@ config  VIDEO_SAMSUNG_S5P_FIMC
 	depends on VIDEO_DEV && VIDEO_V4L2 && PLAT_S5P
 	select VIDEOBUF_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
+	select VIDEO_SAMSUNG_MIPI_CSIS
 	help
 	  This is a v4l2 driver for the S5P camera interface
 	  (video postprocessor)
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 482f14b..8cc093f 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -164,6 +164,7 @@ obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CSI2)	+= sh_mobile_csi2.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
 obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
+obj-$(CONFIG_VIDEO_S5P_MIPI_CSIS)	+= s5p-mipi_csis.o
 obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
 
 obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
diff --git a/drivers/media/video/s5p-mipi_csis.c b/drivers/media/video/s5p-mipi_csis.c
new file mode 100644
index 0000000..823f49f
--- /dev/null
+++ b/drivers/media/video/s5p-mipi_csis.c
@@ -0,0 +1,592 @@
+/*
+ * Samsung S5P SoC series MIPI-CSI2 slave interface driver
+ *
+ * Copyright (c) 2010 Samsung Electronics Co., Ltd
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
+#include <linux/regulator/machine.h>
+#include <linux/regulator/consumer.h>
+#include <plat/csis.h>
+
+#include <linux/videodev2.h>
+#include <media/v4l2-subdev.h>
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "Enable module debug trace. Set to 1 to enable.");
+
+#define MODULE_NAME	"s5p-mipi-csis"
+
+/* Register map definition */
+
+/* CSI global control. */
+#define S5P_CSIS_CTRL			0x00
+#define S5P_CSIS_CTRL_DPDN_DEFAULT	(0 << 31)
+#define S5P_CSIS_CTRL_DPDN_SWAP		(1 << 31)
+#define S5P_CSIS_CTRL_ALIGN_32BIT	(1 << 20)
+#define S5P_CSIS_CTRL_UPDATE_SHADOW	(1 << 16)
+#define S5P_CSIS_CTRL_WCLK_EXTCLK	(1 << 8)
+#define S5P_CSIS_CTRL_RESET		(1 << 4)
+#define S5P_CSIS_CTRL_ENABLE		(1 << 0)
+
+/* D-PHY control. */
+#define S5P_CSIS_DPHYCTRL		0x04
+#define S5P_CSIS_DPHYCTRL_HSS_MASK	(0x1F << 27)
+#define S5P_CSIS_DPHYCTRL_ENABLE	(0x1F << 0)
+
+#define S5P_CSIS_CONFIG			0x08
+#define S5P_CSIS_CFG_FMT_YCBCR422_8BIT	(0x1E << 2)
+#define S5P_CSIS_CFG_FMT_RAW8		(0x2A << 2)
+#define S5P_CSIS_CFG_FMT_RAW10		(0x2B << 2)
+#define S5P_CSIS_CFG_FMT_RAW12		(0x2C << 2)
+#define S5P_CSIS_CFG_FMT_USER1		(0x30 << 2)
+#define S5P_CSIS_CFG_FMT_MASK		(0x3F << 2)
+#define S5P_CSIS_CFG_NR_LANE_MASK	3
+
+/* Interrupt mask. */
+#define S5P_CSIS_INTMSK			0x10
+#define S5P_CSIS_INTMSK_EN_ALL		0xF000003F
+#define S5P_CSIS_INTSRC			0x14
+
+/* Pixel resolution. */
+#define S5P_CSIS_RESOL			0x2C
+#define CSIS_MAX_PIX_WIDTH		0xFFFF
+#define CSIS_MAX_PIX_HEIGHT		0xFFFF
+
+enum {
+	CSIS_CLK_BUS,
+	CSIS_CLK_GATE,
+};
+
+static char *csi_clock_name[] = {
+	[CSIS_CLK_BUS]  = "sclk_csis",
+	[CSIS_CLK_GATE] = "csis",
+};
+
+#define NUM_CSIS_CLOCKS	ARRAY_SIZE(csi_clock_name)
+
+struct s5p_csis_state {
+	struct v4l2_subdev sd;
+	struct v4l2_mbus_framefmt fmt;
+	struct platform_device *pdev;
+	struct resource *regs_res;
+	void __iomem *regs;
+	int irq;
+	struct clk *clock[NUM_CSIS_CLOCKS];
+	struct regulator *supply;
+};
+
+struct s5p_csis_color_format {
+	enum v4l2_mbus_pixelcode code;
+	u32 fmt_reg;
+	u16 pix_hor_align;
+};
+
+static const struct s5p_csis_color_format s5p_csis_formats[] = {
+	{
+		.code		= V4L2_MBUS_FMT_VYUY8_2X8,
+		.fmt_reg	= S5P_CSIS_CFG_FMT_YCBCR422_8BIT,
+		.pix_hor_align	= 1,
+	},
+	/* TODO: Add S5P_CSIS_CFG_FMT_USER1 for JPEG format. */
+};
+
+static struct s5p_csis_state *to_s5p_csis_state(struct v4l2_subdev *sdev)
+{
+	return container_of(sdev, struct s5p_csis_state, sd);
+}
+
+
+static void s5p_csis_enable_interrupts(struct s5p_csis_state *state, int on)
+{
+	u32 cfg = readl(state->regs + S5P_CSIS_CTRL);
+
+	if (on)
+		cfg |= S5P_CSIS_INTMSK_EN_ALL;
+	else
+		cfg &= ~S5P_CSIS_INTMSK_EN_ALL;
+	writel(cfg, state->regs + S5P_CSIS_INTMSK);
+}
+
+static void s5p_csis_reset(struct s5p_csis_state *state)
+{
+	u32 cfg = readl(state->regs + S5P_CSIS_CTRL);
+
+	writel(cfg | S5P_CSIS_CTRL_RESET, state->regs + S5P_CSIS_CTRL);
+	udelay(10);
+}
+
+static void s5p_csis_system_enable(struct s5p_csis_state *state, int on)
+{
+	u32 cfg;
+
+	cfg = readl(state->regs + S5P_CSIS_CTRL);
+	if (on)
+		cfg |= S5P_CSIS_CTRL_ENABLE;
+	else
+		cfg &= ~S5P_CSIS_CTRL_ENABLE;
+	writel(cfg, state->regs + S5P_CSIS_CTRL);
+
+	cfg = readl(state->regs + S5P_CSIS_DPHYCTRL);
+	if (on)
+		cfg |= S5P_CSIS_DPHYCTRL_ENABLE;
+	else
+		cfg &= ~S5P_CSIS_DPHYCTRL_ENABLE;
+	writel(cfg, state->regs + S5P_CSIS_DPHYCTRL);
+
+	s5p_csis_enable_interrupts(state, on);
+}
+
+
+static int s5p_csis_set_format(struct s5p_csis_state *state)
+{
+	u32 cfg;
+	int i = ARRAY_SIZE(s5p_csis_formats);
+
+	v4l2_dbg(1, debug, &state->sd, "fmt: %d, %d x %d\n",
+		 state->fmt.code, state->fmt.width, state->fmt.height);
+
+	/* Color format */
+	cfg = readl(state->regs + S5P_CSIS_CONFIG);
+	cfg &= ~S5P_CSIS_CFG_FMT_MASK;
+
+	while (i--)
+		if (state->fmt.code == s5p_csis_formats[i].code)
+			break;
+
+	if (i >= ARRAY_SIZE(s5p_csis_formats))
+		return -EINVAL;
+
+	writel(cfg | s5p_csis_formats[i].fmt_reg,
+	       state->regs + S5P_CSIS_CONFIG);
+
+	/* Pixel resolution */
+	cfg = (state->fmt.width << 16) | state->fmt.height;
+	writel(cfg, state->regs + S5P_CSIS_RESOL);
+
+	return 0;
+}
+
+static void s5p_csis_set_hsync_settle(struct s5p_csis_state *state, int settle)
+{
+	u32 cfg = readl(state->regs + S5P_CSIS_DPHYCTRL);
+
+	cfg &= ~S5P_CSIS_DPHYCTRL_HSS_MASK;
+	cfg |= (settle << 27);
+	writel(cfg, state->regs + S5P_CSIS_DPHYCTRL);
+}
+
+static void s5p_csis_set_params(struct s5p_csis_state *state)
+{
+	struct s5p_platform_mipi_csis *pdata = state->pdev->dev.platform_data;
+	u32 cfg, tmp;
+
+	/* Number of MIPI lanes used */
+	cfg = readl(state->regs + S5P_CSIS_CONFIG);
+	cfg &= ~S5P_CSIS_CFG_NR_LANE_MASK;
+	tmp = (pdata->lanes - 1) & 0x3;
+	writel(cfg | tmp, state->regs + S5P_CSIS_CONFIG);
+
+	s5p_csis_set_format(state);
+
+	s5p_csis_set_hsync_settle(state, pdata->hs_settle);
+
+	/* CSI bus data alignment. */
+	cfg = readl(state->regs + S5P_CSIS_CTRL);
+
+	if (pdata->alignment == 32)
+		cfg |= S5P_CSIS_CTRL_ALIGN_32BIT;
+	else /* 24-bits */
+		cfg &= ~S5P_CSIS_CTRL_ALIGN_32BIT;
+
+	/* Not using external clock. */
+	cfg &= ~S5P_CSIS_CTRL_WCLK_EXTCLK;
+
+	writel(cfg, state->regs + S5P_CSIS_CTRL);
+
+	/* Update the shadow register. */
+	cfg = readl(state->regs + S5P_CSIS_CTRL);
+	writel(cfg | S5P_CSIS_CTRL_UPDATE_SHADOW, state->regs + S5P_CSIS_CTRL);
+}
+
+static void s5p_csis_clk_enable(struct s5p_csis_state *state, bool enable)
+{
+	int i;
+
+	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
+		if (!state->clock[i])
+			continue;
+		if (enable)
+			clk_enable(state->clock[i]);
+		else
+			clk_disable(state->clock[i]);
+	}
+
+	v4l2_dbg(1, debug, &state->sd, "%s: clocks %sabled\n",
+		 __func__, enable ? "en" : "dis");
+}
+
+static void s5p_csis_clk_put(struct s5p_csis_state *state)
+{
+	int i = NUM_CSIS_CLOCKS - 1;
+
+	while (i-- >= 0) {
+		if (!state->clock[i])
+			continue;
+		clk_disable(state->clock[i]);
+		clk_put(state->clock[i]);
+	}
+}
+
+static int s5p_csis_clk_get(struct s5p_csis_state *state)
+{
+	struct device *dev = &state->pdev->dev;
+	int i;
+
+	for (i = 0; i < NUM_CSIS_CLOCKS; i++) {
+		state->clock[i] = clk_get(dev, csi_clock_name[i]);
+
+		if (IS_ERR(state->clock[i])) {
+			dev_err(dev, "failed to get clock: %s\n",
+				csi_clock_name[i]);
+			return -ENXIO;
+		}
+		clk_enable(state->clock[i]);
+	}
+	return 0;
+}
+
+static int mipi_csis_power(struct v4l2_subdev *sd, int on)
+{
+	struct s5p_csis_state *state = to_s5p_csis_state(sd);
+	struct s5p_platform_mipi_csis *pdata = state->pdev->dev.platform_data;
+	int ret;
+
+	if (on) {
+		ret = regulator_enable(state->supply);
+		if (pdata->phy_enable)
+			ret = pdata->phy_enable(state->pdev, true);
+	} else {
+		if (pdata->phy_enable) {
+			ret = pdata->phy_enable(state->pdev, false);
+			if (ret)
+				return ret;
+		}
+		ret = regulator_disable(state->supply);
+	}
+
+	if (!ret)
+		v4l2_dbg(1, debug, sd, "%s: regulator is %s\n",
+			 __func__, on ? "on" : "off");
+	return ret;
+}
+
+static int s5p_csis_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct s5p_csis_state *state = to_s5p_csis_state(sd);
+	int ret;
+
+	v4l2_dbg(1, debug, sd, "%s: on= %d\n",  __func__, on);
+
+	if (on) {
+		ret = mipi_csis_power(sd, on);
+		if (ret)
+			return ret;
+		s5p_csis_clk_enable(state, on);
+		s5p_csis_reset(state);
+	} else {
+		s5p_csis_enable_interrupts(state, false);
+		s5p_csis_system_enable(state, false);
+		s5p_csis_clk_enable(state, false);
+		ret = mipi_csis_power(sd, on);
+	}
+
+	return ret;
+}
+
+static inline struct s5p_csis_color_format const *find_csis_format(
+	struct v4l2_mbus_framefmt *mf)
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
+static int s5p_csis_try_fmt(struct v4l2_subdev *sd,
+			    struct v4l2_mbus_framefmt *mf)
+{
+	struct s5p_csis_color_format const *csis_fmt;
+
+	if (!sd || !mf)
+		return -EINVAL;
+
+	csis_fmt = find_csis_format(mf);
+
+	if (csis_fmt == NULL)
+		csis_fmt = &s5p_csis_formats[0];
+
+	mf->code = csis_fmt->code;
+
+	/* Adjust pixel size if required so it fits in the supported range
+	   and meets the aligment requirements. */
+	v4l_bound_align_image(&mf->width, 1, CSIS_MAX_PIX_WIDTH,
+			      csis_fmt->pix_hor_align,
+			      &mf->height, 1, CSIS_MAX_PIX_HEIGHT, 1,
+			      0);
+	return 0;
+}
+
+static int s5p_csis_s_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
+{
+	struct s5p_csis_state *state = to_s5p_csis_state(sd);
+	struct s5p_csis_color_format const *csis_fmt = find_csis_format(mf);
+
+	v4l2_dbg(1, debug, sd, "%s: w: %d, h: %d\n", __func__,
+		 mf->width, mf->height);
+
+	if (csis_fmt == NULL ||
+	   mf->width > CSIS_MAX_PIX_WIDTH  ||
+	   mf->height > CSIS_MAX_PIX_WIDTH ||
+	   mf->width & (u32)(csis_fmt->pix_hor_align - 1))
+		return -EINVAL;
+
+	state->fmt = *mf;
+
+	return 0;
+}
+
+static int s5p_csis_g_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *mf)
+{
+	struct s5p_csis_state *state = to_s5p_csis_state(sd);
+
+	*mf = state->fmt;
+	return 0;
+}
+
+static int s5p_csis_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct s5p_csis_state *state = to_s5p_csis_state(sd);
+
+	v4l2_dbg(1, debug, sd, "%s: arg: %d\n", __func__, enable);
+
+	if (enable) {
+		s5p_csis_clk_enable(state, enable);
+		s5p_csis_reset(state);
+		s5p_csis_set_params(state);
+		s5p_csis_system_enable(state, enable);
+	} else {
+		s5p_csis_enable_interrupts(state, enable);
+		s5p_csis_system_enable(state, enable);
+		s5p_csis_clk_enable(state, enable);
+	}
+
+	return 0;
+}
+
+static struct v4l2_subdev_core_ops s5p_csis_core_ops = {
+	.s_power = s5p_csis_s_power,
+};
+
+static struct v4l2_subdev_video_ops s5p_csis_video_ops = {
+	.try_mbus_fmt	= s5p_csis_try_fmt,
+	.g_mbus_fmt	= s5p_csis_g_fmt,
+	.s_mbus_fmt	= s5p_csis_s_fmt,
+	.s_stream	= s5p_csis_s_stream,
+};
+
+static struct v4l2_subdev_ops s5p_csis_subdev_ops = {
+	.core	= &s5p_csis_core_ops,
+	.video	= &s5p_csis_video_ops,
+};
+
+static irqreturn_t s5p_csis_isr(int irq, void *dev_id)
+{
+	struct s5p_csis_state *state = dev_id;
+	u32 cfg;
+
+	/* Just clear the interrupt pending bits. */
+	cfg = readl(state->regs + S5P_CSIS_INTSRC);
+	writel(cfg, state->regs + S5P_CSIS_INTSRC);
+
+	return IRQ_HANDLED;
+}
+
+static int s5p_csis_probe(struct platform_device *pdev)
+{
+	struct s5p_platform_mipi_csis *pdata;
+	struct resource *mem_res;
+	struct resource *regs_res;
+	struct s5p_csis_state *state;
+	int ret = -ENODEV;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	state->pdev = pdev;
+	state->irq  = -ENXIO;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data not set\n");
+		goto p_err1;
+	}
+
+	mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem_res) {
+		dev_err(&pdev->dev, "Failed to get io memory region\n");
+		goto p_err1;
+	}
+
+	regs_res = request_mem_region(mem_res->start,
+			mem_res->end - mem_res->start + 1, pdev->name);
+	if (!regs_res) {
+		dev_err(&pdev->dev, "Failed to request io memory region\n");
+		goto p_err1;
+	}
+	state->regs_res = regs_res;
+
+	state->regs = ioremap(mem_res->start,
+			      mem_res->end - mem_res->start + 1);
+	if (!state->regs) {
+		dev_err(&pdev->dev, "Failed to remap io region\n");
+		goto p_err2;
+	}
+
+	if (s5p_csis_clk_get(state))
+		goto p_err3;
+
+	if (pdata->clk_rate)
+		clk_set_rate(state->clock[CSIS_CLK_BUS], pdata->clk_rate);
+
+	if (pdata->phy_enable)
+		pdata->phy_enable(state->pdev, false);
+
+	state->irq = platform_get_irq(pdev, 0);
+	if (state->irq < 0) {
+		dev_err(&pdev->dev, "failed to get irq\n");
+		goto p_err4;
+	}
+
+	ret = request_irq(state->irq, s5p_csis_isr, 0, MODULE_NAME, state);
+	if (ret) {
+		dev_err(&pdev->dev, "request_irq failed\n");
+		goto p_err4;
+	}
+
+	state->supply = regulator_get(&pdev->dev, "mipi_csi");
+	if (IS_ERR(state->supply)) {
+		state->supply = NULL;
+		goto p_err5;
+	}
+
+	v4l2_subdev_init(&state->sd, &s5p_csis_subdev_ops);
+	state->sd.owner = THIS_MODULE;
+	strcpy(state->sd.name, MODULE_NAME);
+
+
+	/* This allows to retrieve the platform device id by the host driver */
+	v4l2_set_subdevdata(&state->sd, pdev);
+
+	/* .. and a pointer to the subdev. */
+	platform_set_drvdata(pdev, &state->sd);
+
+	return 0;
+
+p_err5:
+	free_irq(state->irq, state);
+p_err4:
+	s5p_csis_clk_put(state);
+p_err3:
+	iounmap(state->regs);
+p_err2:
+	release_mem_region(regs_res->start,
+			   regs_res->end - regs_res->start + 1);
+p_err1:
+	kfree(state);
+	return ret;
+}
+
+static int s5p_csis_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct s5p_csis_state *state = to_s5p_csis_state(sd);
+	struct resource *res = state->regs_res;
+
+	s5p_csis_clk_put(state);
+	s5p_csis_s_power(&state->sd, 0);
+
+	free_irq(state->irq, state);
+	iounmap(state->regs);
+	release_mem_region(res->start, res->end - res->start + 1);
+	kfree(state);
+	return 0;
+}
+
+static int s5p_csis_suspend(struct platform_device *pdev, pm_message_t msg)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+
+	s5p_csis_clk_enable(to_s5p_csis_state(sd), false);
+	return 0;
+}
+
+static int s5p_csis_resume(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+
+	s5p_csis_clk_enable(to_s5p_csis_state(sd), true);
+	return 0;
+}
+
+static struct platform_driver s5p_csis_driver = {
+	.probe		= s5p_csis_probe,
+	.remove		= s5p_csis_remove,
+	.suspend	= s5p_csis_suspend,
+	.resume		= s5p_csis_resume,
+	.driver		= {
+		.name	= MODULE_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init s5p_csis_register(void)
+{
+	return platform_driver_register(&s5p_csis_driver);
+}
+
+static void __exit s5p_csis_unregister(void)
+{
+	platform_driver_unregister(&s5p_csis_driver);
+}
+
+module_init(s5p_csis_register);
+module_exit(s5p_csis_unregister);
+
+MODULE_AUTHOR("Sylwester Nawrocki, <s.nawrocki@samsung.com>");
+MODULE_DESCRIPTION("S5P MIPI-CSI2 slave interface driver");
+MODULE_LICENSE("GPL");
-- 
1.7.2.3


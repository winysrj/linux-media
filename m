Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:42424 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933974AbdEXAOM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 20:14:12 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v7 2/2] media: rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver driver
Date: Wed, 24 May 2017 02:13:53 +0200
Message-Id: <20170524001353.13482-3-niklas.soderlund@ragnatech.se>
In-Reply-To: <20170524001353.13482-1-niklas.soderlund@ragnatech.se>
References: <20170524001353.13482-1-niklas.soderlund@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
supports the rcar-vin driver on R-Car Gen3 SoCs where separate CSI-2
hardware blocks are connected between the video sources and the video
grabbers (VIN).

Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 drivers/media/platform/rcar-vin/Kconfig     |  12 +
 drivers/media/platform/rcar-vin/Makefile    |   1 +
 drivers/media/platform/rcar-vin/rcar-csi2.c | 867 ++++++++++++++++++++++++++++
 3 files changed, 880 insertions(+)
 create mode 100644 drivers/media/platform/rcar-vin/rcar-csi2.c

diff --git a/drivers/media/platform/rcar-vin/Kconfig b/drivers/media/platform/rcar-vin/Kconfig
index af4c98b44d2e22cb..6875f30c1ae42631 100644
--- a/drivers/media/platform/rcar-vin/Kconfig
+++ b/drivers/media/platform/rcar-vin/Kconfig
@@ -1,3 +1,15 @@
+config VIDEO_RCAR_CSI2
+	tristate "R-Car MIPI CSI-2 Receiver"
+	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
+	depends on ARCH_RENESAS || COMPILE_TEST
+	select V4L2_FWNODE
+	---help---
+	  Support for Renesas R-Car MIPI CSI-2 receiver.
+	  Supports R-Car Gen3 SoCs.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called rcar-csi2.
+
 config VIDEO_RCAR_VIN
 	tristate "R-Car Video Input (VIN) Driver"
 	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA && MEDIA_CONTROLLER
diff --git a/drivers/media/platform/rcar-vin/Makefile b/drivers/media/platform/rcar-vin/Makefile
index 48c5632c21dc060b..5ab803d3e7c1aa57 100644
--- a/drivers/media/platform/rcar-vin/Makefile
+++ b/drivers/media/platform/rcar-vin/Makefile
@@ -1,3 +1,4 @@
 rcar-vin-objs = rcar-core.o rcar-dma.o rcar-v4l2.o
 
+obj-$(CONFIG_VIDEO_RCAR_CSI2) += rcar-csi2.o
 obj-$(CONFIG_VIDEO_RCAR_VIN) += rcar-vin.o
diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
new file mode 100644
index 0000000000000000..1175f1fe4b139a13
--- /dev/null
+++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
@@ -0,0 +1,867 @@
+/*
+ * Driver for Renesas R-Car MIPI CSI-2 Receiver
+ *
+ * Copyright (C) 2017 Renesas Electronics Corp.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_graph.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-fwnode.h>
+#include <media/v4l2-mc.h>
+#include <media/v4l2-subdev.h>
+
+/* Register offsets and bits */
+
+/* Control Timing Select */
+#define TREF_REG			0x00
+#define TREF_TREF			(1 << 0)
+
+/* Software Reset */
+#define SRST_REG			0x04
+#define SRST_SRST			(1 << 0)
+
+/* PHY Operation Control */
+#define PHYCNT_REG			0x08
+#define PHYCNT_SHUTDOWNZ		(1 << 17)
+#define PHYCNT_RSTZ			(1 << 16)
+#define PHYCNT_ENABLECLK		(1 << 4)
+#define PHYCNT_ENABLE_3			(1 << 3)
+#define PHYCNT_ENABLE_2			(1 << 2)
+#define PHYCNT_ENABLE_1			(1 << 1)
+#define PHYCNT_ENABLE_0			(1 << 0)
+
+/* Checksum Control */
+#define CHKSUM_REG			0x0c
+#define CHKSUM_ECC_EN			(1 << 1)
+#define CHKSUM_CRC_EN			(1 << 0)
+
+/*
+ * Channel Data Type Select
+ * VCDT[0-15]:  Channel 1 VCDT[16-31]:  Channel 2
+ * VCDT2[0-15]: Channel 3 VCDT2[16-31]: Channel 4
+ */
+#define VCDT_REG			0x10
+#define VCDT2_REG			0x14
+#define VCDT_VCDTN_EN			(1 << 15)
+#define VCDT_SEL_VC(n)			(((n) & 0x3) << 8)
+#define VCDT_SEL_DTN_ON			(1 << 6)
+#define VCDT_SEL_DT(n)			(((n) & 0x3f) << 0)
+
+/* Frame Data Type Select */
+#define FRDT_REG			0x18
+
+/* Field Detection Control */
+#define FLD_REG				0x1c
+#define FLD_FLD_NUM(n)			(((n) & 0xff) << 16)
+#define FLD_FLD_EN4			(1 << 3)
+#define FLD_FLD_EN3			(1 << 2)
+#define FLD_FLD_EN2			(1 << 1)
+#define FLD_FLD_EN			(1 << 0)
+
+/* Automatic Standby Control */
+#define ASTBY_REG			0x20
+
+/* Long Data Type Setting 0 */
+#define LNGDT0_REG			0x28
+
+/* Long Data Type Setting 1 */
+#define LNGDT1_REG			0x2c
+
+/* Interrupt Enable */
+#define INTEN_REG			0x30
+
+/* Interrupt Source Mask */
+#define INTCLOSE_REG			0x34
+
+/* Interrupt Status Monitor */
+#define INTSTATE_REG			0x38
+
+/* Interrupt Error Status Monitor */
+#define INTERRSTATE_REG			0x3c
+
+/* Short Packet Data */
+#define SHPDAT_REG			0x40
+
+/* Short Packet Count */
+#define SHPCNT_REG			0x44
+
+/* LINK Operation Control */
+#define LINKCNT_REG			0x48
+#define LINKCNT_MONITOR_EN		(1 << 31)
+#define LINKCNT_REG_MONI_PACT_EN	(1 << 25)
+#define LINKCNT_ICLK_NONSTOP		(1 << 24)
+
+/* Lane Swap */
+#define LSWAP_REG			0x4c
+#define LSWAP_L3SEL(n)			(((n) & 0x3) << 6)
+#define LSWAP_L2SEL(n)			(((n) & 0x3) << 4)
+#define LSWAP_L1SEL(n)			(((n) & 0x3) << 2)
+#define LSWAP_L0SEL(n)			(((n) & 0x3) << 0)
+
+/* PHY Test Interface Clear */
+#define PHTC_REG			0x58
+#define PHTC_TESTCLR			(1 << 0)
+
+/* PHY Frequency Control */
+#define PHYPLL_REG			0x68
+#define PHYPLL_HSFREQRANGE(n)		((n) << 16)
+
+struct phypll_hsfreqrange {
+	unsigned int	mbps;
+	unsigned char	reg;
+};
+
+static const struct phypll_hsfreqrange phypll_hsfreqrange_map[] = {
+	{ .mbps =   80,	.reg = 0x00 },
+	{ .mbps =   90,	.reg = 0x10 },
+	{ .mbps =  100,	.reg = 0x20 },
+	{ .mbps =  110,	.reg = 0x30 },
+	{ .mbps =  120,	.reg = 0x01 },
+	{ .mbps =  130,	.reg = 0x11 },
+	{ .mbps =  140,	.reg = 0x21 },
+	{ .mbps =  150,	.reg = 0x31 },
+	{ .mbps =  160,	.reg = 0x02 },
+	{ .mbps =  170,	.reg = 0x12 },
+	{ .mbps =  180,	.reg = 0x22 },
+	{ .mbps =  190,	.reg = 0x32 },
+	{ .mbps =  205,	.reg = 0x03 },
+	{ .mbps =  220,	.reg = 0x13 },
+	{ .mbps =  235,	.reg = 0x23 },
+	{ .mbps =  250,	.reg = 0x33 },
+	{ .mbps =  275,	.reg = 0x04 },
+	{ .mbps =  300,	.reg = 0x14 },
+	{ .mbps =  325,	.reg = 0x05 },
+	{ .mbps =  350,	.reg = 0x15 },
+	{ .mbps =  400,	.reg = 0x25 },
+	{ .mbps =  450,	.reg = 0x06 },
+	{ .mbps =  500,	.reg = 0x16 },
+	{ .mbps =  550,	.reg = 0x07 },
+	{ .mbps =  600,	.reg = 0x17 },
+	{ .mbps =  650,	.reg = 0x08 },
+	{ .mbps =  700,	.reg = 0x18 },
+	{ .mbps =  750,	.reg = 0x09 },
+	{ .mbps =  800,	.reg = 0x19 },
+	{ .mbps =  850,	.reg = 0x29 },
+	{ .mbps =  900,	.reg = 0x39 },
+	{ .mbps =  950,	.reg = 0x0A },
+	{ .mbps = 1000,	.reg = 0x1A },
+	{ .mbps = 1050,	.reg = 0x2A },
+	{ .mbps = 1100,	.reg = 0x3A },
+	{ .mbps = 1150,	.reg = 0x0B },
+	{ .mbps = 1200,	.reg = 0x1B },
+	{ .mbps = 1250,	.reg = 0x2B },
+	{ .mbps = 1300,	.reg = 0x3B },
+	{ .mbps = 1350,	.reg = 0x0C },
+	{ .mbps = 1400,	.reg = 0x1C },
+	{ .mbps = 1450,	.reg = 0x2C },
+	{ .mbps = 1500,	.reg = 0x3C },
+	/* guard */
+	{ .mbps =   0,	.reg = 0x00 },
+};
+
+/* PHY ESC Error Monitor */
+#define PHEERM_REG			0x74
+
+/* PHY Clock Lane Monitor */
+#define PHCLM_REG			0x78
+
+/* PHY Data Lane Monitor */
+#define PHDLM_REG			0x7c
+
+struct rcar_csi2_format {
+	unsigned int code;
+	unsigned int datatype;
+	unsigned int bpp;
+};
+
+static const struct rcar_csi2_format rcar_csi2_formats[] = {
+	{ .code = MEDIA_BUS_FMT_RGB888_1X24,	.datatype = 0x24, .bpp = 24},
+	{ .code = MEDIA_BUS_FMT_UYVY8_1X16,	.datatype = 0x1e, .bpp = 8 },
+	{ .code = MEDIA_BUS_FMT_UYVY8_2X8,	.datatype = 0x1e, .bpp = 8 },
+	{ .code = MEDIA_BUS_FMT_YUYV10_2X10,	.datatype = 0x1e, .bpp = 8 },
+};
+
+static const struct rcar_csi2_format *rcar_csi2_code_to_fmt(unsigned int code)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(rcar_csi2_formats); i++)
+		if (rcar_csi2_formats[i].code == code)
+			return rcar_csi2_formats + i;
+	return NULL;
+}
+
+enum rcar_csi2_pads {
+	RCAR_CSI2_SINK,
+	RCAR_CSI2_SOURCE_VC0,
+	RCAR_CSI2_SOURCE_VC1,
+	RCAR_CSI2_SOURCE_VC2,
+	RCAR_CSI2_SOURCE_VC3,
+	NR_OF_RCAR_CSI2_PAD,
+};
+
+struct rcar_csi2 {
+	struct device *dev;
+	void __iomem *base;
+
+	unsigned short lanes;
+	unsigned char lane_swap[4];
+
+	struct v4l2_subdev subdev;
+	struct media_pad pads[NR_OF_RCAR_CSI2_PAD];
+
+	struct v4l2_mbus_framefmt mf;
+
+	struct mutex lock;
+	int stream_count;
+
+	struct v4l2_async_notifier notifier;
+	struct {
+		struct v4l2_async_subdev asd;
+		struct v4l2_subdev *subdev;
+		struct fwnode_handle *fwnode;
+		unsigned int source_pad;
+	} remote;
+};
+
+static inline struct rcar_csi2 *sd_to_csi2(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct rcar_csi2, subdev);
+}
+
+static u32 rcar_csi2_read(struct rcar_csi2 *priv, unsigned int reg)
+{
+	return ioread32(priv->base + reg);
+}
+
+static void rcar_csi2_write(struct rcar_csi2 *priv, unsigned int reg, u32 data)
+{
+	iowrite32(data, priv->base + reg);
+}
+
+static void rcar_csi2_reset(struct rcar_csi2 *priv)
+{
+	rcar_csi2_write(priv, SRST_REG, SRST_SRST);
+	rcar_csi2_write(priv, SRST_REG, 0);
+}
+
+static int rcar_csi2_wait_phy_start(struct rcar_csi2 *priv)
+{
+	int timeout;
+
+	/* Wait for the clock and data lanes to enter LP-11 state. */
+	for (timeout = 100; timeout >= 0; timeout--) {
+		const u32 lane_mask = (1 << priv->lanes) - 1;
+
+		if ((rcar_csi2_read(priv, PHCLM_REG) & 1) == 1 &&
+		    (rcar_csi2_read(priv, PHDLM_REG) & lane_mask) == lane_mask)
+			return 0;
+
+		msleep(20);
+	}
+
+	dev_err(priv->dev, "Timeout waiting for LP-11 state\n");
+
+	return -ETIMEDOUT;
+}
+
+static int rcar_csi2_calc_phypll(struct rcar_csi2 *priv,
+				 struct v4l2_subdev *source,
+				 struct v4l2_mbus_framefmt *mf,
+				 u32 *phypll)
+{
+	const struct phypll_hsfreqrange *hsfreq;
+	const struct rcar_csi2_format *format;
+	struct v4l2_ext_controls ctrls;
+	struct v4l2_ext_control ctrl;
+	u64 mbps;
+	int ret;
+
+	memset(&ctrls, 0, sizeof(ctrls));
+	memset(&ctrl, 0, sizeof(ctrl));
+
+	ctrl.id = V4L2_CID_PIXEL_RATE;
+
+	ctrls.count = 1;
+	ctrls.controls = &ctrl;
+
+	ret = v4l2_g_ext_ctrls(source->ctrl_handler, &ctrls);
+	if (ret < 0) {
+		dev_err(priv->dev, "no link freq control in subdev %s\n",
+			source->name);
+		return ret;
+	}
+
+	format = rcar_csi2_code_to_fmt(mf->code);
+	if (!format) {
+		dev_err(priv->dev, "Unknown format: %d\n", mf->code);
+		return -EINVAL;
+	}
+
+	mbps = ctrl.value64 * format->bpp;
+	do_div(mbps, priv->lanes * 1000000);
+
+	for (hsfreq = phypll_hsfreqrange_map; hsfreq->mbps != 0; hsfreq++)
+		if (hsfreq->mbps >= mbps)
+			break;
+
+	if (!hsfreq->mbps) {
+		dev_err(priv->dev, "Unsupported PHY speed (%llu Mbps)", mbps);
+		return -ERANGE;
+	}
+
+	dev_dbg(priv->dev, "PHY HSFREQRANGE requested %llu got %u Mbps\n", mbps,
+		hsfreq->mbps);
+
+	*phypll = PHYPLL_HSFREQRANGE(hsfreq->reg);
+
+	return 0;
+}
+
+static int rcar_csi2_start(struct rcar_csi2 *priv)
+{
+	const struct rcar_csi2_format *format;
+	struct v4l2_subdev_format fmt;
+	struct media_pad *source_pad;
+	struct v4l2_subdev *source = NULL;
+	struct v4l2_mbus_framefmt *mf = &fmt.format;
+	u32 phycnt, phypll, tmp;
+	u32 vcdt = 0, vcdt2 = 0;
+	unsigned int i;
+	int ret;
+
+	source_pad =
+		media_entity_remote_pad(&priv->subdev.entity.pads[RCAR_CSI2_SINK]);
+	if (!source_pad) {
+		dev_err(priv->dev, "Could not find remote source pad\n");
+		return -ENODEV;
+	}
+
+	source = media_entity_to_v4l2_subdev(source_pad->entity);
+	if (!source) {
+		dev_err(priv->dev, "Could not find remote subdevice\n");
+		return -ENODEV;
+	}
+
+	dev_dbg(priv->dev, "Using source %s pad: %u\n", source->name,
+		source_pad->index);
+
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	fmt.pad = source_pad->index;
+	ret = v4l2_subdev_call(source, pad, get_fmt, NULL, &fmt);
+	if (ret)
+		return ret;
+
+	dev_dbg(priv->dev, "Input size (%dx%d%c)\n", mf->width,
+		mf->height, mf->field == V4L2_FIELD_NONE ? 'p' : 'i');
+
+	/*
+	 * Enable all Virtual Channels
+	 *
+	 * NOTE: I'ts not possible to get individual format for each
+	 *       source virtual channel. Once this is possible in V4L2
+	 *       it should be used here.
+	 */
+	for (i = 0; i < 4; i++) {
+
+		format = rcar_csi2_code_to_fmt(mf->code);
+		if (!format) {
+			dev_err(priv->dev, "Unsupported media bus format: %d\n",
+				mf->code);
+			return -EINVAL;
+		}
+
+		tmp = VCDT_SEL_VC(i) | VCDT_VCDTN_EN | VCDT_SEL_DTN_ON |
+			VCDT_SEL_DT(format->datatype);
+
+		/* Store in correct reg and offset */
+		if (i < 2)
+			vcdt |= tmp << ((i % 2) * 16);
+		else
+			vcdt2 |= tmp << ((i % 2) * 16);
+	}
+
+	switch (priv->lanes) {
+	case 1:
+		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_0;
+		break;
+	case 2:
+		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
+		break;
+	case 4:
+		phycnt = PHYCNT_ENABLECLK | PHYCNT_ENABLE_3 | PHYCNT_ENABLE_2 |
+			PHYCNT_ENABLE_1 | PHYCNT_ENABLE_0;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = rcar_csi2_calc_phypll(priv, source, mf, &phypll);
+	if (ret)
+		return ret;
+
+	/* Init */
+	rcar_csi2_write(priv, TREF_REG, TREF_TREF);
+	rcar_csi2_reset(priv);
+	rcar_csi2_write(priv, PHTC_REG, 0);
+
+	/* Configure */
+	rcar_csi2_write(priv, FLD_REG, FLD_FLD_NUM(2) | FLD_FLD_EN4 |
+			FLD_FLD_EN3 | FLD_FLD_EN2 | FLD_FLD_EN);
+	rcar_csi2_write(priv, VCDT_REG, vcdt);
+	rcar_csi2_write(priv, VCDT2_REG, vcdt2);
+	/* Lanes are zero indexed */
+	rcar_csi2_write(priv, LSWAP_REG,
+			LSWAP_L0SEL(priv->lane_swap[0] - 1) |
+			LSWAP_L1SEL(priv->lane_swap[1] - 1) |
+			LSWAP_L2SEL(priv->lane_swap[2] - 1) |
+			LSWAP_L3SEL(priv->lane_swap[3] - 1));
+
+	/* Start */
+	rcar_csi2_write(priv, PHYPLL_REG, phypll);
+	rcar_csi2_write(priv, PHYCNT_REG, phycnt);
+	rcar_csi2_write(priv, LINKCNT_REG, LINKCNT_MONITOR_EN |
+			LINKCNT_REG_MONI_PACT_EN | LINKCNT_ICLK_NONSTOP);
+	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ);
+	rcar_csi2_write(priv, PHYCNT_REG, phycnt | PHYCNT_SHUTDOWNZ |
+			PHYCNT_RSTZ);
+
+	return rcar_csi2_wait_phy_start(priv);
+}
+
+static void rcar_csi2_stop(struct rcar_csi2 *priv)
+{
+	rcar_csi2_write(priv, PHYCNT_REG, 0);
+
+	rcar_csi2_reset(priv);
+}
+
+static int rcar_csi2_sd_info(struct rcar_csi2 *priv, struct v4l2_subdev **sd)
+{
+	struct media_pad *pad;
+
+	pad = media_entity_remote_pad(&priv->pads[RCAR_CSI2_SINK]);
+	if (!pad) {
+		dev_err(priv->dev, "Could not find remote pad\n");
+		return -ENODEV;
+	}
+
+	*sd = media_entity_to_v4l2_subdev(pad->entity);
+	if (!*sd) {
+		dev_err(priv->dev, "Could not find remote subdevice\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int rcar_csi2_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+	struct v4l2_subdev *nextsd;
+	int ret;
+
+	mutex_lock(&priv->lock);
+
+	ret = rcar_csi2_sd_info(priv, &nextsd);
+	if (ret)
+		goto out;
+
+	priv->stream_count += enable ? 1 : -1;
+
+	if (enable && priv->stream_count == 1) {
+		ret =  rcar_csi2_start(priv);
+		if (ret)
+			goto out;
+		ret = v4l2_subdev_call(nextsd, video, s_stream, 1);
+
+	} else if (!enable && !priv->stream_count) {
+		rcar_csi2_stop(priv);
+		ret = v4l2_subdev_call(nextsd, video, s_stream, 0);
+	}
+out:
+	mutex_unlock(&priv->lock);
+
+	return ret;
+}
+
+static int rcar_csi2_s_power(struct v4l2_subdev *sd, int on)
+{
+	struct rcar_csi2 *priv = sd_to_csi2(sd);
+
+	if (on)
+		pm_runtime_get_sync(priv->dev);
+	else
+		pm_runtime_put(priv->dev);
+
+	return 0;
+}
+
+static int rcar_csi2_set_pad_format(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_pad_config *cfg,
+				    struct v4l2_subdev_format *format)
+{
+	struct rcar_csi2 *priv = container_of(sd, struct rcar_csi2, subdev);
+
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		priv->mf = format->format;
+
+	return 0;
+}
+
+static int rcar_csi2_get_pad_format(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_pad_config *cfg,
+				    struct v4l2_subdev_format *format)
+{
+	struct rcar_csi2 *priv = container_of(sd, struct rcar_csi2, subdev);
+
+	format->format = priv->mf;
+
+	return 0;
+}
+
+static const struct v4l2_subdev_video_ops rcar_csi2_video_ops = {
+	.s_stream = rcar_csi2_s_stream,
+};
+
+static const struct v4l2_subdev_core_ops rcar_csi2_subdev_core_ops = {
+	.s_power = rcar_csi2_s_power,
+};
+
+static const struct v4l2_subdev_pad_ops rcar_csi2_pad_ops = {
+	.set_fmt = rcar_csi2_set_pad_format,
+	.get_fmt = rcar_csi2_get_pad_format,
+};
+
+static const struct v4l2_subdev_ops rcar_csi2_subdev_ops = {
+	.video	= &rcar_csi2_video_ops,
+	.core	= &rcar_csi2_subdev_core_ops,
+	.pad	= &rcar_csi2_pad_ops,
+};
+
+/* -----------------------------------------------------------------------------
+ * Async and registered of subdevices and links
+ */
+
+#define notifier_to_priv(n) container_of(n, struct rcar_csi2, notifier)
+
+static int rcar_csi2_notify_complete(struct v4l2_async_notifier *notifier)
+{
+	struct rcar_csi2 *priv = notifier_to_priv(notifier);
+	int ret;
+
+	ret = v4l2_device_register_subdev_nodes(priv->subdev.v4l2_dev);
+	if (ret) {
+		dev_err(priv->dev, "Failed to register subdev nodes\n");
+		return ret;
+	}
+
+	return media_create_pad_link(&priv->remote.subdev->entity,
+				     priv->remote.source_pad,
+				     &priv->subdev.entity, 0,
+				     MEDIA_LNK_FL_ENABLED |
+				     MEDIA_LNK_FL_IMMUTABLE);
+}
+
+static int rcar_csi2_notify_bound(struct v4l2_async_notifier *notifier,
+				   struct v4l2_subdev *subdev,
+				   struct v4l2_async_subdev *asd)
+{
+	struct rcar_csi2 *priv = notifier_to_priv(notifier);
+	int ret;
+
+	v4l2_set_subdev_hostdata(subdev, priv);
+
+	ret = media_entity_pad_from_fwnode(&subdev->entity,
+					   priv->remote.fwnode,
+					   MEDIA_PAD_FL_SOURCE,
+					   &priv->remote.source_pad);
+	if (ret) {
+		dev_err(priv->dev, "Failed to find pad for %s\n",
+			subdev->name);
+		return ret;
+	}
+
+	dev_dbg(priv->dev, "Bound %s pad: %d\n", subdev->name,
+		priv->remote.source_pad);
+	priv->remote.subdev = subdev;
+
+	return 0;
+}
+static void rcar_csi2_notify_unbind(struct v4l2_async_notifier *notifier,
+				     struct v4l2_subdev *subdev,
+				     struct v4l2_async_subdev *asd)
+{
+	struct rcar_csi2 *priv = notifier_to_priv(notifier);
+
+	dev_dbg(priv->dev, "Unbind %s\n", subdev->name);
+	priv->remote.subdev = NULL;
+}
+
+static int rcar_csi2_registered(struct v4l2_subdev *sd)
+{
+	struct rcar_csi2 *priv = container_of(sd, struct rcar_csi2, subdev);
+	struct v4l2_async_subdev **subdevs = NULL;
+	int ret;
+
+	subdevs = devm_kzalloc(priv->dev, sizeof(*subdevs), GFP_KERNEL);
+	if (subdevs == NULL)
+		return -ENOMEM;
+
+	subdevs[0] = &priv->remote.asd;
+
+	priv->notifier.num_subdevs = 1;
+	priv->notifier.subdevs = subdevs;
+	priv->notifier.bound = rcar_csi2_notify_bound;
+	priv->notifier.unbind = rcar_csi2_notify_unbind;
+	priv->notifier.complete = rcar_csi2_notify_complete;
+
+	ret = v4l2_async_subnotifier_register(&priv->subdev, &priv->notifier);
+	if (ret < 0) {
+		dev_err(priv->dev, "Notifier registration failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void rcar_csi2_unregistered(struct v4l2_subdev *sd)
+{
+	struct rcar_csi2 *priv = container_of(sd, struct rcar_csi2, subdev);
+
+	v4l2_async_subnotifier_unregister(&priv->notifier);
+}
+
+static const struct v4l2_subdev_internal_ops rcar_csi2_internal_ops = {
+	.registered = rcar_csi2_registered,
+	.unregistered = rcar_csi2_unregistered,
+};
+
+static int rcar_csi2_parse_dt_subdevice(struct rcar_csi2 *priv)
+{
+	struct device_node *remote, *ep;
+	struct v4l2_fwnode_endpoint v4l2_ep;
+	int ret;
+
+	ep = of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
+	if (!ep) {
+		dev_err(priv->dev, "Not connected to subdevice\n");
+		return -EINVAL;
+	}
+
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
+	if (ret) {
+		dev_err(priv->dev, "Could not parse v4l2 endpoint\n");
+		of_node_put(ep);
+		return -EINVAL;
+	}
+
+	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
+		dev_err(priv->dev, "Unknown media bus type: 0x%x\n",
+			v4l2_ep.bus_type);
+		of_node_put(ep);
+		return -EINVAL;
+	}
+
+	priv->remote.fwnode =
+		fwnode_graph_get_remote_endpoint(of_fwnode_handle(ep));
+
+	remote = of_graph_get_remote_port_parent(ep);
+	of_node_put(ep);
+	if (!remote) {
+		dev_err(priv->dev, "No subdevice found for endpoint '%s'\n",
+			of_node_full_name(ep));
+		return -EINVAL;
+	}
+
+	priv->remote.asd.match.fwnode.fwnode = of_fwnode_handle(remote);
+	priv->remote.asd.match_type = V4L2_ASYNC_MATCH_FWNODE;
+
+	dev_dbg(priv->dev, "Found '%s'\n", of_node_full_name(remote));
+
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * Platform Device Driver
+ */
+
+static const struct of_device_id rcar_csi2_of_table[] = {
+	{ .compatible = "renesas,rcar-gen3-csi2" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, rcar_csi2_of_table);
+
+static const struct media_entity_operations rcar_csi2_entity_ops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static int rcar_csi2_parse_dt_settings(struct rcar_csi2 *priv)
+{
+	struct v4l2_fwnode_endpoint v4l2_ep;
+	struct device_node *ep;
+	unsigned int i;
+	int ret;
+
+	ep = of_graph_get_endpoint_by_regs(priv->dev->of_node, 0, 0);
+	if (!ep)
+		return -EINVAL;
+
+	ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(ep), &v4l2_ep);
+	of_node_put(ep);
+	if (ret) {
+		dev_err(priv->dev, "Could not parse v4l2 endpoint\n");
+		return -EINVAL;
+	}
+
+	if (v4l2_ep.bus_type != V4L2_MBUS_CSI2) {
+		dev_err(priv->dev, "Unsupported media bus type for %s\n",
+			of_node_full_name(ep));
+		return -EINVAL;
+	}
+
+	priv->lanes = v4l2_ep.bus.mipi_csi2.num_data_lanes;
+	if (priv->lanes != 1 && priv->lanes != 2 && priv->lanes != 4) {
+		dev_err(priv->dev, "Unsupported number of data-lanes: %d\n",
+			priv->lanes);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(priv->lane_swap); i++) {
+		priv->lane_swap[i] = i < priv->lanes ?
+			v4l2_ep.bus.mipi_csi2.data_lanes[i] : i;
+
+		/* Check for valid lane number */
+		if (priv->lane_swap[i] < 1 || priv->lane_swap[i] > 4) {
+			dev_err(priv->dev, "data-lanes must be in 1-4 range\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int rcar_csi2_probe_resources(struct rcar_csi2 *priv,
+				     struct platform_device *pdev)
+{
+	struct resource *mem;
+	int irq;
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem)
+		return -ENODEV;
+
+	priv->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(priv->base))
+		return PTR_ERR(priv->base);
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	return 0;
+}
+
+static int rcar_csi2_probe(struct platform_device *pdev)
+{
+	struct rcar_csi2 *priv;
+	unsigned int i;
+	int ret;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = &pdev->dev;
+
+	mutex_init(&priv->lock);
+	priv->stream_count = 0;
+
+	ret = rcar_csi2_parse_dt_settings(priv);
+	if (ret)
+		return ret;
+
+	ret = rcar_csi2_parse_dt_subdevice(priv);
+	if (ret)
+		return ret;
+
+	ret = rcar_csi2_probe_resources(priv, pdev);
+	if (ret) {
+		dev_err(priv->dev, "Failed to get resources\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, priv);
+
+	priv->subdev.owner = THIS_MODULE;
+	priv->subdev.dev = &pdev->dev;
+	v4l2_subdev_init(&priv->subdev, &rcar_csi2_subdev_ops);
+	v4l2_set_subdevdata(&priv->subdev, &pdev->dev);
+	snprintf(priv->subdev.name, V4L2_SUBDEV_NAME_SIZE, "%s %s",
+		 KBUILD_MODNAME, dev_name(&pdev->dev));
+	priv->subdev.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
+	priv->subdev.internal_ops = &rcar_csi2_internal_ops;
+
+	priv->subdev.entity.function = MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER;
+	priv->subdev.entity.ops = &rcar_csi2_entity_ops;
+
+	priv->pads[RCAR_CSI2_SINK].flags = MEDIA_PAD_FL_SINK;
+	for (i = RCAR_CSI2_SOURCE_VC0; i < NR_OF_RCAR_CSI2_PAD; i++)
+		priv->pads[i].flags = MEDIA_PAD_FL_SOURCE;
+
+	ret = media_entity_pads_init(&priv->subdev.entity, NR_OF_RCAR_CSI2_PAD,
+				     priv->pads);
+	if (ret)
+		return ret;
+
+	ret = v4l2_async_register_subdev(&priv->subdev);
+	if (ret < 0)
+		return ret;
+
+	pm_runtime_enable(&pdev->dev);
+
+	dev_info(priv->dev, "%d lanes found\n", priv->lanes);
+
+	return 0;
+}
+
+static int rcar_csi2_remove(struct platform_device *pdev)
+{
+	struct rcar_csi2 *priv = platform_get_drvdata(pdev);
+
+	v4l2_async_unregister_subdev(&priv->subdev);
+
+	pm_runtime_disable(&pdev->dev);
+
+	return 0;
+}
+
+static struct platform_driver __refdata rcar_csi2_pdrv = {
+	.remove	= rcar_csi2_remove,
+	.probe	= rcar_csi2_probe,
+	.driver	= {
+		.name	= "rcar-csi2",
+		.of_match_table	= of_match_ptr(rcar_csi2_of_table),
+	},
+};
+
+module_platform_driver(rcar_csi2_pdrv);
+
+MODULE_AUTHOR("Niklas Söderlund <niklas.soderlund@ragnatech.se>");
+MODULE_DESCRIPTION("Renesas R-Car MIPI CSI-2 receiver");
+MODULE_LICENSE("GPL v2");
-- 
2.13.0

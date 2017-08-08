Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40279 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752124AbdHHNa4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:30:56 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 05/21] media: camss: Add CSIPHY files
Date: Tue,  8 Aug 2017 16:30:02 +0300
Message-Id: <1502199018-28250-6-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These files control the CSIPHY modules which are responsible for the
physical layer of the CSI2 receivers.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 .../media/platform/qcom/camss-8x16/camss-csiphy.c  | 823 +++++++++++++++++++++
 .../media/platform/qcom/camss-8x16/camss-csiphy.h  |  77 ++
 2 files changed, 900 insertions(+)
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
 create mode 100644 drivers/media/platform/qcom/camss-8x16/camss-csiphy.h

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c b/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
new file mode 100644
index 0000000..ed03775
--- /dev/null
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csiphy.c
@@ -0,0 +1,823 @@
+/*
+ * camss-csiphy.c
+ *
+ * Qualcomm MSM Camera Subsystem - CSIPHY Module
+ *
+ * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016-2017 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <media/media-entity.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+#include "camss-csiphy.h"
+#include "camss.h"
+
+#define MSM_CSIPHY_NAME "msm_csiphy"
+
+#define CAMSS_CSI_PHY_LNn_CFG2(n)		(0x004 + 0x40 * (n))
+#define CAMSS_CSI_PHY_LNn_CFG3(n)		(0x008 + 0x40 * (n))
+#define CAMSS_CSI_PHY_GLBL_RESET		0x140
+#define CAMSS_CSI_PHY_GLBL_PWR_CFG		0x144
+#define CAMSS_CSI_PHY_GLBL_IRQ_CMD		0x164
+#define CAMSS_CSI_PHY_HW_VERSION		0x188
+#define CAMSS_CSI_PHY_INTERRUPT_STATUSn(n)	(0x18c + 0x4 * (n))
+#define CAMSS_CSI_PHY_INTERRUPT_MASKn(n)	(0x1ac + 0x4 * (n))
+#define CAMSS_CSI_PHY_INTERRUPT_CLEARn(n)	(0x1cc + 0x4 * (n))
+#define CAMSS_CSI_PHY_GLBL_T_INIT_CFG0		0x1ec
+#define CAMSS_CSI_PHY_T_WAKEUP_CFG0		0x1f4
+
+static const struct {
+	u32 code;
+	u8 bpp;
+} csiphy_formats[] = {
+	{
+		MEDIA_BUS_FMT_UYVY8_2X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_VYUY8_2X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_YUYV8_2X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_YVYU8_2X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR8_1X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG8_1X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG8_1X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB8_1X8,
+		8,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR10_1X10,
+		10,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG10_1X10,
+		10,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG10_1X10,
+		10,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB10_1X10,
+		10,
+	},
+	{
+		MEDIA_BUS_FMT_SBGGR12_1X12,
+		12,
+	},
+	{
+		MEDIA_BUS_FMT_SGBRG12_1X12,
+		12,
+	},
+	{
+		MEDIA_BUS_FMT_SGRBG12_1X12,
+		12,
+	},
+	{
+		MEDIA_BUS_FMT_SRGGB12_1X12,
+		12,
+	}
+};
+
+/*
+ * csiphy_get_bpp - map media bus format to bits per pixel
+ * @code: media bus format code
+ *
+ * Return number of bits per pixel
+ */
+static u8 csiphy_get_bpp(u32 code)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(csiphy_formats); i++)
+		if (code == csiphy_formats[i].code)
+			return csiphy_formats[i].bpp;
+
+	WARN(1, "Unknown format\n");
+
+	return csiphy_formats[0].bpp;
+}
+
+/*
+ * csiphy_isr - CSIPHY module interrupt handler
+ * @irq: Interrupt line
+ * @dev: CSIPHY device
+ *
+ * Return IRQ_HANDLED on success
+ */
+static irqreturn_t csiphy_isr(int irq, void *dev)
+{
+	struct csiphy_device *csiphy = dev;
+	u8 i;
+
+	for (i = 0; i < 8; i++) {
+		u8 val = readl_relaxed(csiphy->base +
+				       CAMSS_CSI_PHY_INTERRUPT_STATUSn(i));
+		writel_relaxed(val, csiphy->base +
+			       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
+		writel_relaxed(0x1, csiphy->base + CAMSS_CSI_PHY_GLBL_IRQ_CMD);
+		writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_IRQ_CMD);
+		writel_relaxed(0x0, csiphy->base +
+			       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * csiphy_reset - Perform software reset on CSIPHY module
+ * @csiphy: CSIPHY device
+ */
+static void csiphy_reset(struct csiphy_device *csiphy)
+{
+	writel_relaxed(0x1, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
+	usleep_range(5000, 8000);
+	writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
+}
+
+/*
+ * csiphy_set_power - Power on/off CSIPHY module
+ * @sd: CSIPHY V4L2 subdevice
+ * @on: Requested power state
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+static int csiphy_set_power(struct v4l2_subdev *sd, int on)
+{
+	struct csiphy_device *csiphy = v4l2_get_subdevdata(sd);
+	struct device *dev = to_device_index(csiphy, csiphy->id);
+
+	if (on) {
+		u8 hw_version;
+		int ret;
+
+		ret = camss_enable_clocks(csiphy->nclocks, csiphy->clock, dev);
+		if (ret < 0)
+			return ret;
+
+		enable_irq(csiphy->irq);
+
+		csiphy_reset(csiphy);
+
+		hw_version = readl_relaxed(csiphy->base +
+					   CAMSS_CSI_PHY_HW_VERSION);
+		dev_dbg(dev, "CSIPHY HW Version = 0x%02x\n", hw_version);
+	} else {
+		disable_irq(csiphy->irq);
+
+		camss_disable_clocks(csiphy->nclocks, csiphy->clock);
+	}
+
+	return 0;
+}
+
+/*
+ * csiphy_get_lane_mask - Calculate CSI2 lane mask configuration parameter
+ * @lane_cfg - CSI2 lane configuration
+ *
+ * Return lane mask
+ */
+static u8 csiphy_get_lane_mask(struct csiphy_lanes_cfg *lane_cfg)
+{
+	u8 lane_mask;
+	int i;
+
+	lane_mask = 1 << lane_cfg->clk.pos;
+
+	for (i = 0; i < lane_cfg->num_data; i++)
+		lane_mask |= 1 << lane_cfg->data[i].pos;
+
+	return lane_mask;
+}
+
+/*
+ * csiphy_settle_cnt_calc - Calculate settle count value
+ * @csiphy: CSIPHY device
+ *
+ * Helper function to calculate settle count value. This is
+ * based on the CSI2 T_hs_settle parameter which in turn
+ * is calculated based on the CSI2 transmitter pixel clock
+ * frequency.
+ *
+ * Return settle count value or 0 if the CSI2 pixel clock
+ * frequency is not available
+ */
+static u8 csiphy_settle_cnt_calc(struct csiphy_device *csiphy)
+{
+	u8 bpp = csiphy_get_bpp(
+			csiphy->fmt[MSM_CSIPHY_PAD_SINK].code);
+	u8 num_lanes = csiphy->cfg.csi2->lane_cfg.num_data;
+	u32 pixel_clock; /* Hz */
+	u32 mipi_clock; /* Hz */
+	u32 ui; /* ps */
+	u32 timer_period; /* ps */
+	u32 t_hs_prepare_max; /* ps */
+	u32 t_hs_prepare_zero_min; /* ps */
+	u32 t_hs_settle; /* ps */
+	u8 settle_cnt;
+	int ret;
+
+	ret = camss_get_pixel_clock(&csiphy->subdev.entity, &pixel_clock);
+	if (ret) {
+		dev_err(to_device_index(csiphy, csiphy->id),
+			"Cannot get CSI2 transmitter's pixel clock\n");
+		return 0;
+	}
+	if (!pixel_clock) {
+		dev_err(to_device_index(csiphy, csiphy->id),
+			"Got pixel clock == 0, cannot continue\n");
+		return 0;
+	}
+
+	mipi_clock = pixel_clock * bpp / (2 * num_lanes);
+	ui = div_u64(1000000000000, mipi_clock);
+	ui /= 2;
+	t_hs_prepare_max = 85000 + 6 * ui;
+	t_hs_prepare_zero_min = 145000 + 10 * ui;
+	t_hs_settle = (t_hs_prepare_max + t_hs_prepare_zero_min) / 2;
+
+	timer_period = div_u64(1000000000000, csiphy->timer_clk_rate);
+	settle_cnt = t_hs_settle / timer_period;
+
+	return settle_cnt;
+}
+
+/*
+ * csiphy_stream_on - Enable streaming on CSIPHY module
+ * @csiphy: CSIPHY device
+ *
+ * Helper function to enable streaming on CSIPHY module.
+ * Main configuration of CSIPHY module is also done here.
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+static int csiphy_stream_on(struct csiphy_device *csiphy)
+{
+	struct csiphy_config *cfg = &csiphy->cfg;
+	u8 lane_mask = csiphy_get_lane_mask(&cfg->csi2->lane_cfg);
+	u8 settle_cnt;
+	u8 val;
+	int i = 0;
+
+	settle_cnt = csiphy_settle_cnt_calc(csiphy);
+	if (!settle_cnt)
+		return -EINVAL;
+
+	val = readl_relaxed(csiphy->base_clk_mux);
+	if (cfg->combo_mode && (lane_mask & 0x18) == 0x18) {
+		val &= ~0xf0;
+		val |= cfg->csid_id << 4;
+	} else {
+		val &= ~0xf;
+		val |= cfg->csid_id;
+	}
+	writel_relaxed(val, csiphy->base_clk_mux);
+
+	writel_relaxed(0x1, csiphy->base +
+		       CAMSS_CSI_PHY_GLBL_T_INIT_CFG0);
+	writel_relaxed(0x1, csiphy->base +
+		       CAMSS_CSI_PHY_T_WAKEUP_CFG0);
+
+	val = 0x1;
+	val |= lane_mask << 1;
+	writel_relaxed(val, csiphy->base + CAMSS_CSI_PHY_GLBL_PWR_CFG);
+
+	val = cfg->combo_mode << 4;
+	writel_relaxed(val, csiphy->base + CAMSS_CSI_PHY_GLBL_RESET);
+
+	while (lane_mask) {
+		if (lane_mask & 0x1) {
+			writel_relaxed(0x10, csiphy->base +
+				       CAMSS_CSI_PHY_LNn_CFG2(i));
+			writel_relaxed(settle_cnt, csiphy->base +
+				       CAMSS_CSI_PHY_LNn_CFG3(i));
+			writel_relaxed(0x3f, csiphy->base +
+				       CAMSS_CSI_PHY_INTERRUPT_MASKn(i));
+			writel_relaxed(0x3f, csiphy->base +
+				       CAMSS_CSI_PHY_INTERRUPT_CLEARn(i));
+		}
+
+		lane_mask >>= 1;
+		i++;
+	}
+
+	return 0;
+}
+
+/*
+ * csiphy_stream_off - Disable streaming on CSIPHY module
+ * @csiphy: CSIPHY device
+ *
+ * Helper function to disable streaming on CSIPHY module
+ */
+static void csiphy_stream_off(struct csiphy_device *csiphy)
+{
+	u8 lane_mask = csiphy_get_lane_mask(&csiphy->cfg.csi2->lane_cfg);
+	int i = 0;
+
+	while (lane_mask) {
+		if (lane_mask & 0x1)
+			writel_relaxed(0x0, csiphy->base +
+				       CAMSS_CSI_PHY_LNn_CFG2(i));
+
+		lane_mask >>= 1;
+		i++;
+	}
+
+	writel_relaxed(0x0, csiphy->base + CAMSS_CSI_PHY_GLBL_PWR_CFG);
+}
+
+
+/*
+ * csiphy_set_stream - Enable/disable streaming on CSIPHY module
+ * @sd: CSIPHY V4L2 subdevice
+ * @enable: Requested streaming state
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+static int csiphy_set_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct csiphy_device *csiphy = v4l2_get_subdevdata(sd);
+	int ret = 0;
+
+	if (enable)
+		ret = csiphy_stream_on(csiphy);
+	else
+		csiphy_stream_off(csiphy);
+
+	return ret;
+}
+
+/*
+ * __csiphy_get_format - Get pointer to format structure
+ * @csiphy: CSIPHY device
+ * @cfg: V4L2 subdev pad configuration
+ * @pad: pad from which format is requested
+ * @which: TRY or ACTIVE format
+ *
+ * Return pointer to TRY or ACTIVE format structure
+ */
+static struct v4l2_mbus_framefmt *
+__csiphy_get_format(struct csiphy_device *csiphy,
+		    struct v4l2_subdev_pad_config *cfg,
+		    unsigned int pad,
+		    enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(&csiphy->subdev, cfg, pad);
+
+	return &csiphy->fmt[pad];
+}
+
+/*
+ * csiphy_try_format - Handle try format by pad subdev method
+ * @csiphy: CSIPHY device
+ * @cfg: V4L2 subdev pad configuration
+ * @pad: pad on which format is requested
+ * @fmt: pointer to v4l2 format structure
+ * @which: wanted subdev format
+ */
+static void csiphy_try_format(struct csiphy_device *csiphy,
+			      struct v4l2_subdev_pad_config *cfg,
+			      unsigned int pad,
+			      struct v4l2_mbus_framefmt *fmt,
+			      enum v4l2_subdev_format_whence which)
+{
+	unsigned int i;
+
+	switch (pad) {
+	case MSM_CSIPHY_PAD_SINK:
+		/* Set format on sink pad */
+
+		for (i = 0; i < ARRAY_SIZE(csiphy_formats); i++)
+			if (fmt->code == csiphy_formats[i].code)
+				break;
+
+		/* If not found, use UYVY as default */
+		if (i >= ARRAY_SIZE(csiphy_formats))
+			fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
+
+		fmt->width = clamp_t(u32, fmt->width, 1, 8191);
+		fmt->height = clamp_t(u32, fmt->height, 1, 8191);
+
+		fmt->field = V4L2_FIELD_NONE;
+		fmt->colorspace = V4L2_COLORSPACE_SRGB;
+
+		break;
+
+	case MSM_CSIPHY_PAD_SRC:
+		/* Set and return a format same as sink pad */
+
+		*fmt = *__csiphy_get_format(csiphy, cfg, MSM_CSID_PAD_SINK,
+					    which);
+
+		break;
+	}
+}
+
+/*
+ * csiphy_enum_mbus_code - Handle pixel format enumeration
+ * @sd: CSIPHY V4L2 subdevice
+ * @cfg: V4L2 subdev pad configuration
+ * @code: pointer to v4l2_subdev_mbus_code_enum structure
+ * return -EINVAL or zero on success
+ */
+static int csiphy_enum_mbus_code(struct v4l2_subdev *sd,
+				 struct v4l2_subdev_pad_config *cfg,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct csiphy_device *csiphy = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	if (code->pad == MSM_CSIPHY_PAD_SINK) {
+		if (code->index >= ARRAY_SIZE(csiphy_formats))
+			return -EINVAL;
+
+		code->code = csiphy_formats[code->index].code;
+	} else {
+		if (code->index > 0)
+			return -EINVAL;
+
+		format = __csiphy_get_format(csiphy, cfg, MSM_CSIPHY_PAD_SINK,
+					     code->which);
+
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
+/*
+ * csiphy_enum_frame_size - Handle frame size enumeration
+ * @sd: CSIPHY V4L2 subdevice
+ * @cfg: V4L2 subdev pad configuration
+ * @fse: pointer to v4l2_subdev_frame_size_enum structure
+ * return -EINVAL or zero on success
+ */
+static int csiphy_enum_frame_size(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_pad_config *cfg,
+				  struct v4l2_subdev_frame_size_enum *fse)
+{
+	struct csiphy_device *csiphy = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt format;
+
+	if (fse->index != 0)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = 1;
+	format.height = 1;
+	csiphy_try_format(csiphy, cfg, fse->pad, &format, fse->which);
+	fse->min_width = format.width;
+	fse->min_height = format.height;
+
+	if (format.code != fse->code)
+		return -EINVAL;
+
+	format.code = fse->code;
+	format.width = -1;
+	format.height = -1;
+	csiphy_try_format(csiphy, cfg, fse->pad, &format, fse->which);
+	fse->max_width = format.width;
+	fse->max_height = format.height;
+
+	return 0;
+}
+
+/*
+ * csiphy_get_format - Handle get format by pads subdev method
+ * @sd: CSIPHY V4L2 subdevice
+ * @cfg: V4L2 subdev pad configuration
+ * @fmt: pointer to v4l2 subdev format structure
+ *
+ * Return -EINVAL or zero on success
+ */
+static int csiphy_get_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_format *fmt)
+{
+	struct csiphy_device *csiphy = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __csiphy_get_format(csiphy, cfg, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	fmt->format = *format;
+
+	return 0;
+}
+
+/*
+ * csiphy_set_format - Handle set format by pads subdev method
+ * @sd: CSIPHY V4L2 subdevice
+ * @cfg: V4L2 subdev pad configuration
+ * @fmt: pointer to v4l2 subdev format structure
+ *
+ * Return -EINVAL or zero on success
+ */
+static int csiphy_set_format(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
+			     struct v4l2_subdev_format *fmt)
+{
+	struct csiphy_device *csiphy = v4l2_get_subdevdata(sd);
+	struct v4l2_mbus_framefmt *format;
+
+	format = __csiphy_get_format(csiphy, cfg, fmt->pad, fmt->which);
+	if (format == NULL)
+		return -EINVAL;
+
+	csiphy_try_format(csiphy, cfg, fmt->pad, &fmt->format, fmt->which);
+	*format = fmt->format;
+
+	/* Propagate the format from sink to source */
+	if (fmt->pad == MSM_CSIPHY_PAD_SINK) {
+		format = __csiphy_get_format(csiphy, cfg, MSM_CSIPHY_PAD_SRC,
+					     fmt->which);
+
+		*format = fmt->format;
+		csiphy_try_format(csiphy, cfg, MSM_CSIPHY_PAD_SRC, format,
+				  fmt->which);
+	}
+
+	return 0;
+}
+
+/*
+ * csiphy_init_formats - Initialize formats on all pads
+ * @sd: CSIPHY V4L2 subdevice
+ * @fh: V4L2 subdev file handle
+ *
+ * Initialize all pad formats with default values.
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+static int csiphy_init_formats(struct v4l2_subdev *sd,
+			       struct v4l2_subdev_fh *fh)
+{
+	struct v4l2_subdev_format format = {
+		.pad = MSM_CSIPHY_PAD_SINK,
+		.which = fh ? V4L2_SUBDEV_FORMAT_TRY :
+			      V4L2_SUBDEV_FORMAT_ACTIVE,
+		.format = {
+			.code = MEDIA_BUS_FMT_UYVY8_2X8,
+			.width = 1920,
+			.height = 1080
+		}
+	};
+
+	return csiphy_set_format(sd, fh ? fh->pad : NULL, &format);
+}
+
+/*
+ * msm_csiphy_subdev_init - Initialize CSIPHY device structure and resources
+ * @csiphy: CSIPHY device
+ * @res: CSIPHY module resources table
+ * @id: CSIPHY module id
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
+			   const struct resources *res, u8 id)
+{
+	struct device *dev = to_device_index(csiphy, id);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct resource *r;
+	int i;
+	int ret;
+
+	csiphy->id = id;
+	csiphy->cfg.combo_mode = 0;
+
+	/* Memory */
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[0]);
+	csiphy->base = devm_ioremap_resource(dev, r);
+	if (IS_ERR(csiphy->base)) {
+		dev_err(dev, "could not map memory\n");
+		return PTR_ERR(csiphy->base);
+	}
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_MEM, res->reg[1]);
+	csiphy->base_clk_mux = devm_ioremap_resource(dev, r);
+	if (IS_ERR(csiphy->base_clk_mux)) {
+		dev_err(dev, "could not map memory\n");
+		return PTR_ERR(csiphy->base_clk_mux);
+	}
+
+	/* Interrupt */
+
+	r = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
+					 res->interrupt[0]);
+	if (!r) {
+		dev_err(dev, "missing IRQ\n");
+		return -EINVAL;
+	}
+
+	csiphy->irq = r->start;
+	snprintf(csiphy->irq_name, sizeof(csiphy->irq_name), "%s_%s%d",
+		 dev_name(dev), MSM_CSIPHY_NAME, csiphy->id);
+	ret = devm_request_irq(dev, csiphy->irq, csiphy_isr,
+			       IRQF_TRIGGER_RISING, csiphy->irq_name, csiphy);
+	if (ret < 0) {
+		dev_err(dev, "request_irq failed: %d\n", ret);
+		return ret;
+	}
+
+	disable_irq(csiphy->irq);
+
+	/* Clocks */
+
+	csiphy->nclocks = 0;
+	while (res->clock[csiphy->nclocks])
+		csiphy->nclocks++;
+
+	csiphy->clock = devm_kzalloc(dev, csiphy->nclocks *
+				     sizeof(*csiphy->clock), GFP_KERNEL);
+	if (!csiphy->clock)
+		return -ENOMEM;
+
+	for (i = 0; i < csiphy->nclocks; i++) {
+		csiphy->clock[i] = devm_clk_get(dev, res->clock[i]);
+		if (IS_ERR(csiphy->clock[i]))
+			return PTR_ERR(csiphy->clock[i]);
+
+		if (res->clock_rate[i]) {
+			long clk_rate = clk_round_rate(csiphy->clock[i],
+						       res->clock_rate[i]);
+			if (clk_rate < 0) {
+				dev_err(to_device_index(csiphy, csiphy->id),
+					"clk round rate failed: %ld\n",
+					clk_rate);
+				return -EINVAL;
+			}
+			ret = clk_set_rate(csiphy->clock[i], clk_rate);
+			if (ret < 0) {
+				dev_err(to_device_index(csiphy, csiphy->id),
+					"clk set rate failed: %d\n", ret);
+				return ret;
+			}
+
+			if (!strcmp(res->clock[i], "csiphy0_timer") ||
+					!strcmp(res->clock[i], "csiphy1_timer"))
+				csiphy->timer_clk_rate = clk_rate;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * csiphy_link_setup - Setup CSIPHY connections
+ * @entity: Pointer to media entity structure
+ * @local: Pointer to local pad
+ * @remote: Pointer to remote pad
+ * @flags: Link flags
+ *
+ * Rreturn 0 on success
+ */
+static int csiphy_link_setup(struct media_entity *entity,
+			     const struct media_pad *local,
+			     const struct media_pad *remote, u32 flags)
+{
+	if ((local->flags & MEDIA_PAD_FL_SOURCE) &&
+	    (flags & MEDIA_LNK_FL_ENABLED)) {
+		struct v4l2_subdev *sd;
+		struct csiphy_device *csiphy;
+		struct csid_device *csid;
+
+		if (media_entity_remote_pad(local))
+			return -EBUSY;
+
+		sd = media_entity_to_v4l2_subdev(entity);
+		csiphy = v4l2_get_subdevdata(sd);
+
+		sd = media_entity_to_v4l2_subdev(remote->entity);
+		csid = v4l2_get_subdevdata(sd);
+
+		csiphy->cfg.csid_id = csid->id;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_subdev_core_ops csiphy_core_ops = {
+	.s_power = csiphy_set_power,
+};
+
+static const struct v4l2_subdev_video_ops csiphy_video_ops = {
+	.s_stream = csiphy_set_stream,
+};
+
+static const struct v4l2_subdev_pad_ops csiphy_pad_ops = {
+	.enum_mbus_code = csiphy_enum_mbus_code,
+	.enum_frame_size = csiphy_enum_frame_size,
+	.get_fmt = csiphy_get_format,
+	.set_fmt = csiphy_set_format,
+};
+
+static const struct v4l2_subdev_ops csiphy_v4l2_ops = {
+	.core = &csiphy_core_ops,
+	.video = &csiphy_video_ops,
+	.pad = &csiphy_pad_ops,
+};
+
+static const struct v4l2_subdev_internal_ops csiphy_v4l2_internal_ops = {
+	.open = csiphy_init_formats,
+};
+
+static const struct media_entity_operations csiphy_media_ops = {
+	.link_setup = csiphy_link_setup,
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+/*
+ * msm_csiphy_register_entity - Register subdev node for CSIPHY module
+ * @csiphy: CSIPHY device
+ * @v4l2_dev: V4L2 device
+ *
+ * Return 0 on success or a negative error code otherwise
+ */
+int msm_csiphy_register_entity(struct csiphy_device *csiphy,
+			       struct v4l2_device *v4l2_dev)
+{
+	struct v4l2_subdev *sd = &csiphy->subdev;
+	struct media_pad *pads = csiphy->pads;
+	struct device *dev = to_device_index(csiphy, csiphy->id);
+	int ret;
+
+	v4l2_subdev_init(sd, &csiphy_v4l2_ops);
+	sd->internal_ops = &csiphy_v4l2_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	snprintf(sd->name, ARRAY_SIZE(sd->name), "%s%d",
+		 MSM_CSIPHY_NAME, csiphy->id);
+	v4l2_set_subdevdata(sd, csiphy);
+
+	ret = csiphy_init_formats(sd, NULL);
+	if (ret < 0) {
+		dev_err(dev, "Failed to init format: %d\n", ret);
+		return ret;
+	}
+
+	pads[MSM_CSIPHY_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
+	pads[MSM_CSIPHY_PAD_SRC].flags = MEDIA_PAD_FL_SOURCE;
+
+	sd->entity.function = MEDIA_ENT_F_IO_V4L;
+	sd->entity.ops = &csiphy_media_ops;
+	ret = media_entity_pads_init(&sd->entity, MSM_CSIPHY_PADS_NUM, pads);
+	if (ret < 0) {
+		dev_err(dev, "Failed to init media entity: %d\n", ret);
+		return ret;
+	}
+
+	ret = v4l2_device_register_subdev(v4l2_dev, sd);
+	if (ret < 0) {
+		dev_err(dev, "Failed to register subdev: %d\n", ret);
+		media_entity_cleanup(&sd->entity);
+	}
+
+	return ret;
+}
+
+/*
+ * msm_csiphy_unregister_entity - Unregister CSIPHY module subdev node
+ * @csiphy: CSIPHY device
+ */
+void msm_csiphy_unregister_entity(struct csiphy_device *csiphy)
+{
+	v4l2_device_unregister_subdev(&csiphy->subdev);
+	media_entity_cleanup(&csiphy->subdev.entity);
+}
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h b/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
new file mode 100644
index 0000000..e886e6d
--- /dev/null
+++ b/drivers/media/platform/qcom/camss-8x16/camss-csiphy.h
@@ -0,0 +1,77 @@
+/*
+ * camss-csiphy.h
+ *
+ * Qualcomm MSM Camera Subsystem - CSIPHY Module
+ *
+ * Copyright (c) 2011-2015, The Linux Foundation. All rights reserved.
+ * Copyright (C) 2016-2017 Linaro Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#ifndef QC_MSM_CAMSS_CSIPHY_H
+#define QC_MSM_CAMSS_CSIPHY_H
+
+#include <linux/clk.h>
+#include <media/media-entity.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-mediabus.h>
+#include <media/v4l2-subdev.h>
+
+#define MSM_CSIPHY_PAD_SINK 0
+#define MSM_CSIPHY_PAD_SRC 1
+#define MSM_CSIPHY_PADS_NUM 2
+
+struct csiphy_lane {
+	u8 pos;
+	u8 pol;
+};
+
+struct csiphy_lanes_cfg {
+	int num_data;
+	struct csiphy_lane *data;
+	struct csiphy_lane clk;
+};
+
+struct csiphy_csi2_cfg {
+	struct csiphy_lanes_cfg lane_cfg;
+};
+
+struct csiphy_config {
+	u8 combo_mode;
+	u8 csid_id;
+	struct csiphy_csi2_cfg *csi2;
+};
+
+struct csiphy_device {
+	u8 id;
+	struct v4l2_subdev subdev;
+	struct media_pad pads[MSM_CSIPHY_PADS_NUM];
+	void __iomem *base;
+	void __iomem *base_clk_mux;
+	u32 irq;
+	char irq_name[30];
+	struct clk **clock;
+	int nclocks;
+	u32 timer_clk_rate;
+	struct csiphy_config cfg;
+	struct v4l2_mbus_framefmt fmt[MSM_CSIPHY_PADS_NUM];
+};
+
+struct resources;
+
+int msm_csiphy_subdev_init(struct csiphy_device *csiphy,
+			   const struct resources *res, u8 id);
+
+int msm_csiphy_register_entity(struct csiphy_device *csiphy,
+			       struct v4l2_device *v4l2_dev);
+
+void msm_csiphy_unregister_entity(struct csiphy_device *csiphy);
+
+#endif /* QC_MSM_CAMSS_CSIPHY_H */
-- 
2.7.4

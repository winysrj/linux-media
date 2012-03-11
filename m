Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:16918 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab2CKOqM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 10:46:12 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, dacohen@gmail.com,
	snjw23@gmail.com, andriy.shevchenko@linux.intel.com,
	t.stanislaws@samsung.com, tuukkat76@gmail.com,
	k.debski@samsung.com, riverful@gmail.com, hverkuil@xs4all.nl,
	teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: [PATCH v5.4 35/35] smiapp: Add driver
Date: Sun, 11 Mar 2012 16:45:56 +0200
Message-Id: <1331477156-3989-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <4F5CB0C0.3010802@iki.fi>
References: <4F5CB0C0.3010802@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
three subdevs, pixel array, binner and scaler --- in case the device has a
scaler.

Currently it relies on the board code for external clock handling. There is
no fast way out of this dependency before the ISP drivers (omap3isp) among
others will be able to export that clock through the clock framework
instead.

Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
---
 drivers/media/video/Kconfig                  |    2 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/smiapp-pll.c             |    2 +
 drivers/media/video/smiapp/Kconfig           |   13 +
 drivers/media/video/smiapp/Makefile          |    3 +
 drivers/media/video/smiapp/smiapp-core.c     | 2832 ++++++++++++++++++++++++++
 drivers/media/video/smiapp/smiapp-debug.h    |   32 +
 drivers/media/video/smiapp/smiapp-limits.c   |  132 ++
 drivers/media/video/smiapp/smiapp-limits.h   |  128 ++
 drivers/media/video/smiapp/smiapp-quirk.c    |  264 +++
 drivers/media/video/smiapp/smiapp-quirk.h    |   72 +
 drivers/media/video/smiapp/smiapp-reg-defs.h |  503 +++++
 drivers/media/video/smiapp/smiapp-reg.h      |  122 ++
 drivers/media/video/smiapp/smiapp-regs.c     |  213 ++
 drivers/media/video/smiapp/smiapp-regs.h     |   46 +
 drivers/media/video/smiapp/smiapp.h          |  251 +++
 include/media/smiapp.h                       |   83 +
 17 files changed, 4699 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/smiapp/Kconfig
 create mode 100644 drivers/media/video/smiapp/Makefile
 create mode 100644 drivers/media/video/smiapp/smiapp-core.c
 create mode 100644 drivers/media/video/smiapp/smiapp-debug.h
 create mode 100644 drivers/media/video/smiapp/smiapp-limits.c
 create mode 100644 drivers/media/video/smiapp/smiapp-limits.h
 create mode 100644 drivers/media/video/smiapp/smiapp-quirk.c
 create mode 100644 drivers/media/video/smiapp/smiapp-quirk.h
 create mode 100644 drivers/media/video/smiapp/smiapp-reg-defs.h
 create mode 100644 drivers/media/video/smiapp/smiapp-reg.h
 create mode 100644 drivers/media/video/smiapp/smiapp-regs.c
 create mode 100644 drivers/media/video/smiapp/smiapp-regs.h
 create mode 100644 drivers/media/video/smiapp/smiapp.h
 create mode 100644 include/media/smiapp.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index bb89f8c..6569b8e 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -527,6 +527,8 @@ config VIDEO_S5K6AA
 	  This is a V4L2 sensor-level driver for Samsung S5K6AA(FX) 1.3M
 	  camera sensor with an embedded SoC image signal processor.
 
+source "drivers/media/video/smiapp/Kconfig"
+
 comment "Flash devices"
 
 config VIDEO_ADP1653
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index f184f1d..7b1393d 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_VIDEO_SR030PC30)	+= sr030pc30.o
 obj-$(CONFIG_VIDEO_NOON010PC30)	+= noon010pc30.o
 obj-$(CONFIG_VIDEO_M5MOLS)	+= m5mols/
 obj-$(CONFIG_VIDEO_S5K6AA)	+= s5k6aa.o
+obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp/
 obj-$(CONFIG_VIDEO_ADP1653)	+= adp1653.o
 obj-$(CONFIG_VIDEO_AS3645A)	+= as3645a.o
 
diff --git a/drivers/media/video/smiapp-pll.c b/drivers/media/video/smiapp-pll.c
index be63bb4..326bd0e 100644
--- a/drivers/media/video/smiapp-pll.c
+++ b/drivers/media/video/smiapp-pll.c
@@ -22,6 +22,8 @@
  *
  */
 
+#include "smiapp/smiapp-debug.h"
+
 #include <linux/gcd.h>
 #include <linux/lcm.h>
 #include <linux/module.h>
diff --git a/drivers/media/video/smiapp/Kconfig b/drivers/media/video/smiapp/Kconfig
new file mode 100644
index 0000000..9504c43
--- /dev/null
+++ b/drivers/media/video/smiapp/Kconfig
@@ -0,0 +1,13 @@
+config VIDEO_SMIAPP
+	tristate "SMIA++/SMIA sensor support"
+	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	select VIDEO_SMIAPP_PLL
+	---help---
+	  This is a generic driver for SMIA++/SMIA camera modules.
+
+config VIDEO_SMIAPP_DEBUG
+	bool "Enable debugging for the generic SMIA++/SMIA driver"
+	depends on VIDEO_SMIAPP
+	---help---
+	  Enable debugging output in the generic SMIA++/SMIA driver. If you
+	  are developing the driver you might want to enable this.
diff --git a/drivers/media/video/smiapp/Makefile b/drivers/media/video/smiapp/Makefile
new file mode 100644
index 0000000..5a207ee
--- /dev/null
+++ b/drivers/media/video/smiapp/Makefile
@@ -0,0 +1,3 @@
+smiapp-objs			+= smiapp-core.o smiapp-regs.o \
+				   smiapp-quirk.o smiapp-limits.o
+obj-$(CONFIG_VIDEO_SMIAPP)	+= smiapp.o
diff --git a/drivers/media/video/smiapp/smiapp-core.c b/drivers/media/video/smiapp/smiapp-core.c
new file mode 100644
index 0000000..3991c45
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-core.c
@@ -0,0 +1,2832 @@
+/*
+ * drivers/media/video/smiapp/smiapp-core.c
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2010--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * Based on smiapp driver by Vimarsh Zutshi
+ * Based on jt8ev1.c by Vimarsh Zutshi
+ * Based on smia-sensor.c by Tuukka Toivonen <tuukkat76@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "smiapp-debug.h"
+
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/module.h>
+#include <linux/regulator/consumer.h>
+#include <linux/v4l2-mediabus.h>
+#include <media/v4l2-device.h>
+
+#include "smiapp.h"
+
+#define SMIAPP_ALIGN_DIM(dim, flags)		\
+	((flags) & V4L2_SUBDEV_SEL_FLAG_SIZE_GE	\
+	 ? ALIGN((dim), 2)			\
+	 : (dim) & ~1)
+
+/*
+ * smiapp_module_idents - supported camera modules
+ */
+static const struct smiapp_module_ident smiapp_module_idents[] = {
+	SMIAPP_IDENT_L(0x01, 0x022b, -1, "vs6555"),
+	SMIAPP_IDENT_L(0x01, 0x022e, -1, "vw6558"),
+	SMIAPP_IDENT_L(0x07, 0x7698, -1, "ovm7698"),
+	SMIAPP_IDENT_L(0x0b, 0x4242, -1, "smiapp-003"),
+	SMIAPP_IDENT_L(0x0c, 0x208a, -1, "tcm8330md"),
+	SMIAPP_IDENT_LQ(0x0c, 0x2134, -1, "tcm8500md", &smiapp_tcm8500md_quirk),
+	SMIAPP_IDENT_L(0x0c, 0x213e, -1, "et8en2"),
+	SMIAPP_IDENT_L(0x0c, 0x2184, -1, "tcm8580md"),
+	SMIAPP_IDENT_LQ(0x0c, 0x560f, -1, "jt8ew9", &smiapp_jt8ew9_quirk),
+	SMIAPP_IDENT_LQ(0x10, 0x4141, -1, "jt8ev1", &smiapp_jt8ev1_quirk),
+	SMIAPP_IDENT_LQ(0x10, 0x4241, -1, "imx125es", &smiapp_imx125es_quirk),
+};
+
+/*
+ *
+ * Dynamic Capability Identification
+ *
+ */
+
+static int smiapp_read_frame_fmt(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	u32 fmt_model_type, fmt_model_subtype, ncol_desc, nrow_desc;
+	unsigned int i;
+	int rval;
+	int line_count = 0;
+	int embedded_start = -1, embedded_end = -1;
+	int image_start = 0;
+
+	rval = smiapp_read(client, SMIAPP_REG_U8_FRAME_FORMAT_MODEL_TYPE,
+			   &fmt_model_type);
+	if (rval)
+		return rval;
+
+	rval = smiapp_read(client, SMIAPP_REG_U8_FRAME_FORMAT_MODEL_SUBTYPE,
+			   &fmt_model_subtype);
+	if (rval)
+		return rval;
+
+	ncol_desc = (fmt_model_subtype
+		     & SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NCOLS_MASK)
+		>> SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NCOLS_SHIFT;
+	nrow_desc = fmt_model_subtype
+		& SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NROWS_MASK;
+
+	dev_dbg(&client->dev, "format_model_type %s\n",
+		fmt_model_type == SMIAPP_FRAME_FORMAT_MODEL_TYPE_2BYTE
+		? "2 byte" :
+		fmt_model_type == SMIAPP_FRAME_FORMAT_MODEL_TYPE_4BYTE
+		? "4 byte" : "is simply bad");
+
+	for (i = 0; i < ncol_desc + nrow_desc; i++) {
+		u32 desc;
+		u32 pixelcode;
+		u32 pixels;
+		char *which;
+		char *what;
+
+		if (fmt_model_type == SMIAPP_FRAME_FORMAT_MODEL_TYPE_2BYTE) {
+			rval = smiapp_read(
+				client,
+				SMIAPP_REG_U16_FRAME_FORMAT_DESCRIPTOR_2(i),
+				&desc);
+			if (rval)
+				return rval;
+
+			pixelcode =
+				(desc
+				 & SMIAPP_FRAME_FORMAT_DESC_2_PIXELCODE_MASK)
+				>> SMIAPP_FRAME_FORMAT_DESC_2_PIXELCODE_SHIFT;
+			pixels = desc & SMIAPP_FRAME_FORMAT_DESC_2_PIXELS_MASK;
+		} else if (fmt_model_type
+			   == SMIAPP_FRAME_FORMAT_MODEL_TYPE_4BYTE) {
+			rval = smiapp_read(
+				client,
+				SMIAPP_REG_U32_FRAME_FORMAT_DESCRIPTOR_4(i),
+				&desc);
+			if (rval)
+				return rval;
+
+			pixelcode =
+				(desc
+				 & SMIAPP_FRAME_FORMAT_DESC_4_PIXELCODE_MASK)
+				>> SMIAPP_FRAME_FORMAT_DESC_4_PIXELCODE_SHIFT;
+			pixels = desc & SMIAPP_FRAME_FORMAT_DESC_4_PIXELS_MASK;
+		} else {
+			dev_dbg(&client->dev,
+				"invalid frame format model type %d\n",
+				fmt_model_type);
+			return -EINVAL;
+		}
+
+		if (i < ncol_desc)
+			which = "columns";
+		else
+			which = "rows";
+
+		switch (pixelcode) {
+		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_EMBEDDED:
+			what = "embedded";
+			break;
+		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_DUMMY:
+			what = "dummy";
+			break;
+		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_BLACK:
+			what = "black";
+			break;
+		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_DARK:
+			what = "dark";
+			break;
+		case SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_VISIBLE:
+			what = "visible";
+			break;
+		default:
+			what = "invalid";
+			dev_dbg(&client->dev, "pixelcode %d\n", pixelcode);
+			break;
+		}
+
+		dev_dbg(&client->dev, "%s pixels: %d %s\n",
+			what, pixels, which);
+
+		if (i < ncol_desc)
+			continue;
+
+		/* Handle row descriptors */
+		if (pixelcode
+		    == SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_EMBEDDED) {
+			embedded_start = line_count;
+		} else {
+			if (pixelcode == SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_VISIBLE
+			    || pixels >= sensor->limits[SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES] / 2)
+				image_start = line_count;
+			if (embedded_start != -1 && embedded_end == -1)
+				embedded_end = line_count;
+		}
+		line_count += pixels;
+	}
+
+	if (embedded_start == -1 || embedded_end == -1) {
+		embedded_start = 0;
+		embedded_end = 0;
+	}
+
+	dev_dbg(&client->dev, "embedded data from lines %d to %d\n",
+		embedded_start, embedded_end);
+	dev_dbg(&client->dev, "image data starts at line %d\n", image_start);
+
+	return 0;
+}
+
+static int smiapp_pll_configure(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	struct smiapp_pll *pll = &sensor->pll;
+	int rval;
+
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_VT_PIX_CLK_DIV, pll->vt_pix_clk_div);
+	if (rval < 0)
+		return rval;
+
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_VT_SYS_CLK_DIV, pll->vt_sys_clk_div);
+	if (rval < 0)
+		return rval;
+
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_PRE_PLL_CLK_DIV, pll->pre_pll_clk_div);
+	if (rval < 0)
+		return rval;
+
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_PLL_MULTIPLIER, pll->pll_multiplier);
+	if (rval < 0)
+		return rval;
+
+	/* Lane op clock ratio does not apply here. */
+	rval = smiapp_write(
+		client, SMIAPP_REG_U32_REQUESTED_LINK_BIT_RATE_MBPS,
+		DIV_ROUND_UP(pll->op_sys_clk_freq_hz, 1000000 / 256 / 256));
+	if (rval < 0 || sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0)
+		return rval;
+
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_OP_PIX_CLK_DIV, pll->op_pix_clk_div);
+	if (rval < 0)
+		return rval;
+
+	return smiapp_write(
+		client, SMIAPP_REG_U16_OP_SYS_CLK_DIV, pll->op_sys_clk_div);
+}
+
+static int smiapp_pll_update(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	struct smiapp_pll_limits lim = {
+		.min_pre_pll_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_PRE_PLL_CLK_DIV],
+		.max_pre_pll_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_PRE_PLL_CLK_DIV],
+		.min_pll_ip_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_PLL_IP_FREQ_HZ],
+		.max_pll_ip_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_PLL_IP_FREQ_HZ],
+		.min_pll_multiplier = sensor->limits[SMIAPP_LIMIT_MIN_PLL_MULTIPLIER],
+		.max_pll_multiplier = sensor->limits[SMIAPP_LIMIT_MAX_PLL_MULTIPLIER],
+		.min_pll_op_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_PLL_OP_FREQ_HZ],
+		.max_pll_op_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_PLL_OP_FREQ_HZ],
+
+		.min_op_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV],
+		.max_op_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV],
+		.min_op_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_DIV],
+		.max_op_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_DIV],
+		.min_op_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_FREQ_HZ],
+		.max_op_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_FREQ_HZ],
+		.min_op_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_FREQ_HZ],
+		.max_op_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_FREQ_HZ],
+
+		.min_vt_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_VT_SYS_CLK_DIV],
+		.max_vt_sys_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_VT_SYS_CLK_DIV],
+		.min_vt_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MIN_VT_PIX_CLK_DIV],
+		.max_vt_pix_clk_div = sensor->limits[SMIAPP_LIMIT_MAX_VT_PIX_CLK_DIV],
+		.min_vt_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_VT_SYS_CLK_FREQ_HZ],
+		.max_vt_sys_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_VT_SYS_CLK_FREQ_HZ],
+		.min_vt_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MIN_VT_PIX_CLK_FREQ_HZ],
+		.max_vt_pix_clk_freq_hz = sensor->limits[SMIAPP_LIMIT_MAX_VT_PIX_CLK_FREQ_HZ],
+
+		.min_line_length_pck_bin = sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN],
+		.min_line_length_pck = sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK],
+	};
+	struct smiapp_pll *pll = &sensor->pll;
+	int rval;
+
+	memset(&sensor->pll, 0, sizeof(sensor->pll));
+
+	pll->lanes = sensor->platform_data->lanes;
+	pll->ext_clk_freq_hz = sensor->platform_data->ext_clk;
+
+	if (sensor->minfo.smiapp_profile == SMIAPP_PROFILE_0) {
+		/*
+		 * Fill in operational clock divisors limits from the
+		 * video timing ones. On profile 0 sensors the
+		 * requirements regarding them are essentially the
+		 * same as on VT ones.
+		 */
+		lim.min_op_sys_clk_div = lim.min_vt_sys_clk_div;
+		lim.max_op_sys_clk_div = lim.max_vt_sys_clk_div;
+		lim.min_op_pix_clk_div = lim.min_vt_pix_clk_div;
+		lim.max_op_pix_clk_div = lim.max_vt_pix_clk_div;
+		lim.min_op_sys_clk_freq_hz = lim.min_vt_sys_clk_freq_hz;
+		lim.max_op_sys_clk_freq_hz = lim.max_vt_sys_clk_freq_hz;
+		lim.min_op_pix_clk_freq_hz = lim.min_vt_pix_clk_freq_hz;
+		lim.max_op_pix_clk_freq_hz = lim.max_vt_pix_clk_freq_hz;
+		/* Profile 0 sensors have no separate OP clock branch. */
+		pll->flags |= SMIAPP_PLL_FLAG_NO_OP_CLOCKS;
+	}
+
+	if (smiapp_needs_quirk(sensor,
+			       SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE))
+		pll->flags |= SMIAPP_PLL_FLAG_OP_PIX_CLOCK_PER_LANE;
+
+	pll->binning_horizontal = sensor->binning_horizontal;
+	pll->binning_vertical = sensor->binning_vertical;
+	pll->link_freq =
+		sensor->link_freq->qmenu_int[sensor->link_freq->val];
+	pll->scale_m = sensor->scale_m;
+	pll->scale_n = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
+	pll->bits_per_pixel = sensor->csi_format->compressed;
+
+	rval = smiapp_pll_calculate(&client->dev, &lim, pll);
+	if (rval < 0)
+		return rval;
+
+	sensor->pixel_rate_parray->cur.val64 = pll->vt_pix_clk_freq_hz;
+	sensor->pixel_rate_csi->cur.val64 = pll->pixel_rate_csi;
+
+	return 0;
+}
+
+
+/*
+ *
+ * V4L2 Controls handling
+ *
+ */
+
+static void __smiapp_update_exposure_limits(struct smiapp_sensor *sensor)
+{
+	struct v4l2_ctrl *ctrl = sensor->exposure;
+	int max;
+
+	max = sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height
+		+ sensor->vblank->val
+		- sensor->limits[SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MAX_MARGIN];
+
+	ctrl->maximum = max;
+	if (ctrl->default_value > max)
+		ctrl->default_value = max;
+	if (ctrl->val > max)
+		ctrl->val = max;
+	if (ctrl->cur.val > max)
+		ctrl->cur.val = max;
+}
+
+/*
+ * Order matters.
+ *
+ * 1. Bits-per-pixel, descending.
+ * 2. Bits-per-pixel compressed, descending.
+ * 3. Pixel order, same as in pixel_order_str. Formats for all four pixel
+ *    orders must be defined.
+ */
+static const struct smiapp_csi_data_format smiapp_csi_data_formats[] = {
+	{ V4L2_MBUS_FMT_SGRBG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ V4L2_MBUS_FMT_SRGGB12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ V4L2_MBUS_FMT_SBGGR12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ V4L2_MBUS_FMT_SGBRG12_1X12, 12, 12, SMIAPP_PIXEL_ORDER_GBRG, },
+	{ V4L2_MBUS_FMT_SGRBG10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ V4L2_MBUS_FMT_SRGGB10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ V4L2_MBUS_FMT_SBGGR10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ V4L2_MBUS_FMT_SGBRG10_1X10, 10, 10, SMIAPP_PIXEL_ORDER_GBRG, },
+	{ V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GRBG, },
+	{ V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_RGGB, },
+	{ V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_BGGR, },
+	{ V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8, 10, 8, SMIAPP_PIXEL_ORDER_GBRG, },
+};
+
+const char *pixel_order_str[] = { "GRBG", "RGGB", "BGGR", "GBRG" };
+
+#define to_csi_format_idx(fmt) (((unsigned long)(fmt)			\
+				 - (unsigned long)smiapp_csi_data_formats) \
+				/ sizeof(*smiapp_csi_data_formats))
+
+static u32 smiapp_pixel_order(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	int flip = 0;
+
+	if (sensor->hflip) {
+		if (sensor->hflip->val)
+			flip |= SMIAPP_IMAGE_ORIENTATION_HFLIP;
+
+		if (sensor->vflip->val)
+			flip |= SMIAPP_IMAGE_ORIENTATION_VFLIP;
+	}
+
+	flip ^= sensor->hvflip_inv_mask;
+
+	dev_dbg(&client->dev, "flip %d\n", flip);
+	return sensor->default_pixel_order ^ flip;
+}
+
+static void smiapp_update_mbus_formats(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	unsigned int csi_format_idx =
+		to_csi_format_idx(sensor->csi_format) & ~3;
+	unsigned int internal_csi_format_idx =
+		to_csi_format_idx(sensor->internal_csi_format) & ~3;
+	unsigned int pixel_order = smiapp_pixel_order(sensor);
+
+	sensor->mbus_frame_fmts =
+		sensor->default_mbus_frame_fmts << pixel_order;
+	sensor->csi_format =
+		&smiapp_csi_data_formats[csi_format_idx + pixel_order];
+	sensor->internal_csi_format =
+		&smiapp_csi_data_formats[internal_csi_format_idx
+					 + pixel_order];
+
+	BUG_ON(max(internal_csi_format_idx, csi_format_idx) + pixel_order
+	       >= ARRAY_SIZE(smiapp_csi_data_formats));
+	BUG_ON(min(internal_csi_format_idx, csi_format_idx) < 0);
+
+	dev_dbg(&client->dev, "new pixel order %s\n",
+		pixel_order_str[pixel_order]);
+}
+
+static int smiapp_set_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct smiapp_sensor *sensor =
+		container_of(ctrl->handler, struct smiapp_subdev, ctrl_handler)
+			->sensor;
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	u32 orient = 0;
+	int exposure;
+	int rval;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ANALOGUE_GAIN:
+		return smiapp_write(
+			client,
+			SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_GLOBAL, ctrl->val);
+
+	case V4L2_CID_EXPOSURE:
+		return smiapp_write(
+			client,
+			SMIAPP_REG_U16_COARSE_INTEGRATION_TIME, ctrl->val);
+
+	case V4L2_CID_HFLIP:
+	case V4L2_CID_VFLIP:
+		if (sensor->streaming)
+			return -EBUSY;
+
+		if (sensor->hflip->val)
+			orient |= SMIAPP_IMAGE_ORIENTATION_HFLIP;
+
+		if (sensor->vflip->val)
+			orient |= SMIAPP_IMAGE_ORIENTATION_VFLIP;
+
+		orient ^= sensor->hvflip_inv_mask;
+		rval = smiapp_write(client,
+				    SMIAPP_REG_U8_IMAGE_ORIENTATION,
+				    orient);
+		if (rval < 0)
+			return rval;
+
+		smiapp_update_mbus_formats(sensor);
+
+		return 0;
+
+	case V4L2_CID_VBLANK:
+		exposure = sensor->exposure->val;
+
+		__smiapp_update_exposure_limits(sensor);
+
+		if (exposure > sensor->exposure->maximum) {
+			sensor->exposure->val =
+				sensor->exposure->maximum;
+			rval = smiapp_set_ctrl(
+				sensor->exposure);
+			if (rval < 0)
+				return rval;
+		}
+
+		return smiapp_write(
+			client, SMIAPP_REG_U16_FRAME_LENGTH_LINES,
+			sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height
+			+ ctrl->val);
+
+	case V4L2_CID_HBLANK:
+		return smiapp_write(
+			client, SMIAPP_REG_U16_LINE_LENGTH_PCK,
+			sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width
+			+ ctrl->val);
+
+	case V4L2_CID_LINK_FREQ:
+		if (sensor->streaming)
+			return -EBUSY;
+
+		return smiapp_pll_update(sensor);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct v4l2_ctrl_ops smiapp_ctrl_ops = {
+	.s_ctrl = smiapp_set_ctrl,
+};
+
+static int smiapp_init_controls(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	struct v4l2_ctrl_config cfg;
+	int rval;
+
+	rval = v4l2_ctrl_handler_init(&sensor->pixel_array->ctrl_handler, 7);
+	if (rval)
+		return rval;
+	sensor->pixel_array->ctrl_handler.lock = &sensor->mutex;
+
+	sensor->analog_gain = v4l2_ctrl_new_std(
+		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_ANALOGUE_GAIN,
+		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MIN],
+		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MAX],
+		max(sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_STEP], 1U),
+		sensor->limits[SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MIN]);
+
+	/* Exposure limits will be updated soon, use just something here. */
+	sensor->exposure = v4l2_ctrl_new_std(
+		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_EXPOSURE, 0, 0, 1, 0);
+
+	sensor->hflip = v4l2_ctrl_new_std(
+		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_HFLIP, 0, 1, 1, 0);
+	sensor->vflip = v4l2_ctrl_new_std(
+		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_VFLIP, 0, 1, 1, 0);
+
+	sensor->vblank = v4l2_ctrl_new_std(
+		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_VBLANK, 0, 1, 1, 0);
+
+	if (sensor->vblank)
+		sensor->vblank->flags |= V4L2_CTRL_FLAG_UPDATE;
+
+	sensor->hblank = v4l2_ctrl_new_std(
+		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_HBLANK, 0, 1, 1, 0);
+
+	if (sensor->hblank)
+		sensor->hblank->flags |= V4L2_CTRL_FLAG_UPDATE;
+
+	sensor->pixel_rate_parray = v4l2_ctrl_new_std(
+		&sensor->pixel_array->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
+
+	if (sensor->pixel_array->ctrl_handler.error) {
+		dev_err(&client->dev,
+			"pixel array controls initialization failed (%d)\n",
+			sensor->pixel_array->ctrl_handler.error);
+		rval = sensor->pixel_array->ctrl_handler.error;
+		goto error;
+	}
+
+	sensor->pixel_array->sd.ctrl_handler =
+		&sensor->pixel_array->ctrl_handler;
+
+	v4l2_ctrl_cluster(2, &sensor->hflip);
+
+	rval = v4l2_ctrl_handler_init(&sensor->src->ctrl_handler, 0);
+	if (rval)
+		goto error;
+	sensor->src->ctrl_handler.lock = &sensor->mutex;
+
+	memset(&cfg, 0, sizeof(cfg));
+
+	cfg.ops = &smiapp_ctrl_ops;
+	cfg.id = V4L2_CID_LINK_FREQ;
+	cfg.type = V4L2_CTRL_TYPE_INTEGER_MENU;
+	while (sensor->platform_data->op_sys_clock[cfg.max + 1])
+		cfg.max++;
+	cfg.qmenu_int = sensor->platform_data->op_sys_clock;
+
+	sensor->link_freq = v4l2_ctrl_new_custom(
+		&sensor->src->ctrl_handler, &cfg, NULL);
+
+	sensor->pixel_rate_csi = v4l2_ctrl_new_std(
+		&sensor->src->ctrl_handler, &smiapp_ctrl_ops,
+		V4L2_CID_PIXEL_RATE, 0, 0, 1, 0);
+
+	if (sensor->src->ctrl_handler.error) {
+		dev_err(&client->dev,
+			"src controls initialization failed (%d)\n",
+			sensor->src->ctrl_handler.error);
+		rval = sensor->src->ctrl_handler.error;
+		goto error;
+	}
+
+	sensor->src->sd.ctrl_handler =
+		&sensor->src->ctrl_handler;
+
+	return 0;
+
+error:
+	v4l2_ctrl_handler_free(&sensor->pixel_array->ctrl_handler);
+	v4l2_ctrl_handler_free(&sensor->src->ctrl_handler);
+
+	return rval;
+}
+
+static void smiapp_free_controls(struct smiapp_sensor *sensor)
+{
+	unsigned int i;
+
+	for (i = 0; i < sensor->ssds_used; i++)
+		v4l2_ctrl_handler_free(&sensor->ssds[i].ctrl_handler);
+}
+
+static int smiapp_get_limits(struct smiapp_sensor *sensor, int const *limit,
+			     unsigned int n)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	unsigned int i;
+	u32 val;
+	int rval;
+
+	for (i = 0; i < n; i++) {
+		rval = smiapp_read(
+			client, smiapp_reg_limits[limit[i]].addr, &val);
+		if (rval)
+			return rval;
+		sensor->limits[limit[i]] = val;
+		dev_dbg(&client->dev, "0x%8.8x \"%s\" = %d, 0x%x\n",
+			smiapp_reg_limits[limit[i]].addr,
+			smiapp_reg_limits[limit[i]].what, val, val);
+	}
+
+	return 0;
+}
+
+static int smiapp_get_all_limits(struct smiapp_sensor *sensor)
+{
+	unsigned int i;
+	int rval;
+
+	for (i = 0; i < SMIAPP_LIMIT_LAST; i++) {
+		rval = smiapp_get_limits(sensor, &i, 1);
+		if (rval < 0)
+			return rval;
+	}
+
+	if (sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN] == 0)
+		smiapp_replace_limit(sensor, SMIAPP_LIMIT_SCALER_N_MIN, 16);
+
+	return 0;
+}
+
+static int smiapp_get_limits_binning(struct smiapp_sensor *sensor)
+{
+	static u32 const limits[] = {
+		SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN,
+		SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES_BIN,
+		SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN,
+		SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK_BIN,
+		SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN,
+		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MIN_BIN,
+		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MAX_MARGIN_BIN,
+	};
+	static u32 const limits_replace[] = {
+		SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES,
+		SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES,
+		SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK,
+		SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK,
+		SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK,
+		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MIN,
+		SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MAX_MARGIN,
+	};
+
+	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY] ==
+	    SMIAPP_BINNING_CAPABILITY_NO) {
+		unsigned int i;
+
+		for (i = 0; i < ARRAY_SIZE(limits); i++)
+			sensor->limits[limits[i]] =
+				sensor->limits[limits_replace[i]];
+
+		return 0;
+	}
+
+	return smiapp_get_limits(sensor, limits, ARRAY_SIZE(limits));
+}
+
+static int smiapp_get_mbus_formats(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	unsigned int type, n;
+	unsigned int i, pixel_order;
+	int rval;
+
+	rval = smiapp_read(
+		client, SMIAPP_REG_U8_DATA_FORMAT_MODEL_TYPE, &type);
+	if (rval)
+		return rval;
+
+	dev_dbg(&client->dev, "data_format_model_type %d\n", type);
+
+	rval = smiapp_read(client, SMIAPP_REG_U8_PIXEL_ORDER,
+			   &pixel_order);
+	if (rval)
+		return rval;
+
+	if (pixel_order >= ARRAY_SIZE(pixel_order_str)) {
+		dev_dbg(&client->dev, "bad pixel order %d\n", pixel_order);
+		return -EINVAL;
+	}
+
+	dev_dbg(&client->dev, "pixel order %d (%s)\n", pixel_order,
+		pixel_order_str[pixel_order]);
+
+	switch (type) {
+	case SMIAPP_DATA_FORMAT_MODEL_TYPE_NORMAL:
+		n = SMIAPP_DATA_FORMAT_MODEL_TYPE_NORMAL_N;
+		break;
+	case SMIAPP_DATA_FORMAT_MODEL_TYPE_EXTENDED:
+		n = SMIAPP_DATA_FORMAT_MODEL_TYPE_EXTENDED_N;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	sensor->default_pixel_order = pixel_order;
+	sensor->mbus_frame_fmts = 0;
+
+	for (i = 0; i < n; i++) {
+		unsigned int fmt, j;
+
+		rval = smiapp_read(
+			client,
+			SMIAPP_REG_U16_DATA_FORMAT_DESCRIPTOR(i), &fmt);
+		if (rval)
+			return rval;
+
+		dev_dbg(&client->dev, "bpp %d, compressed %d\n",
+			fmt >> 8, (u8)fmt);
+
+		for (j = 0; j < ARRAY_SIZE(smiapp_csi_data_formats); j++) {
+			const struct smiapp_csi_data_format *f =
+				&smiapp_csi_data_formats[j];
+
+			if (f->pixel_order != SMIAPP_PIXEL_ORDER_GRBG)
+				continue;
+
+			if (f->width != fmt >> 8 || f->compressed != (u8)fmt)
+				continue;
+
+			dev_dbg(&client->dev, "jolly good! %d\n", j);
+
+			sensor->default_mbus_frame_fmts |= 1 << j;
+			if (!sensor->csi_format) {
+				sensor->csi_format = f;
+				sensor->internal_csi_format = f;
+			}
+		}
+	}
+
+	if (!sensor->csi_format) {
+		dev_err(&client->dev, "no supported mbus code found\n");
+		return -EINVAL;
+	}
+
+	smiapp_update_mbus_formats(sensor);
+
+	return 0;
+}
+
+static void smiapp_update_blanking(struct smiapp_sensor *sensor)
+{
+	struct v4l2_ctrl *vblank = sensor->vblank;
+	struct v4l2_ctrl *hblank = sensor->hblank;
+
+	vblank->minimum =
+		max_t(int,
+		      sensor->limits[SMIAPP_LIMIT_MIN_FRAME_BLANKING_LINES],
+		      sensor->limits[SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN] -
+		      sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height);
+	vblank->maximum =
+		sensor->limits[SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES_BIN] -
+		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height;
+
+	vblank->val = clamp_t(int, vblank->val,
+			      vblank->minimum, vblank->maximum);
+	vblank->default_value = vblank->minimum;
+	vblank->val = vblank->val;
+	vblank->cur.val = vblank->val;
+
+	hblank->minimum =
+		max_t(int,
+		      sensor->limits[SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN] -
+		      sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width,
+		      sensor->limits[SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN]);
+	hblank->maximum =
+		sensor->limits[SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK_BIN] -
+		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width;
+
+	hblank->val = clamp_t(int, hblank->val,
+			      hblank->minimum, hblank->maximum);
+	hblank->default_value = hblank->minimum;
+	hblank->val = hblank->val;
+	hblank->cur.val = hblank->val;
+
+	__smiapp_update_exposure_limits(sensor);
+}
+
+static int smiapp_update_mode(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	unsigned int binning_mode;
+	int rval;
+
+	dev_dbg(&client->dev, "frame size: %dx%d\n",
+		sensor->src->crop[SMIAPP_PAD_SRC].width,
+		sensor->src->crop[SMIAPP_PAD_SRC].height);
+	dev_dbg(&client->dev, "csi format width: %d\n",
+		sensor->csi_format->width);
+
+	/* Binning has to be set up here; it affects limits */
+	if (sensor->binning_horizontal == 1 &&
+	    sensor->binning_vertical == 1) {
+		binning_mode = 0;
+	} else {
+		u8 binning_type =
+			(sensor->binning_horizontal << 4)
+			| sensor->binning_vertical;
+
+		rval = smiapp_write(
+			client, SMIAPP_REG_U8_BINNING_TYPE, binning_type);
+		if (rval < 0)
+			return rval;
+
+		binning_mode = 1;
+	}
+	rval = smiapp_write(client, SMIAPP_REG_U8_BINNING_MODE, binning_mode);
+	if (rval < 0)
+		return rval;
+
+	/* Get updated limits due to binning */
+	rval = smiapp_get_limits_binning(sensor);
+	if (rval < 0)
+		return rval;
+
+	rval = smiapp_pll_update(sensor);
+	if (rval < 0)
+		return rval;
+
+	/* Output from pixel array, including blanking */
+	smiapp_update_blanking(sensor);
+
+	dev_dbg(&client->dev, "vblank\t\t%d\n", sensor->vblank->val);
+	dev_dbg(&client->dev, "hblank\t\t%d\n", sensor->hblank->val);
+
+	dev_dbg(&client->dev, "real timeperframe\t100/%d\n",
+		sensor->pll.vt_pix_clk_freq_hz /
+		((sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width
+		  + sensor->hblank->val) *
+		 (sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height
+		  + sensor->vblank->val) / 100));
+
+	return 0;
+}
+
+/*
+ *
+ * SMIA++ NVM handling
+ *
+ */
+static int smiapp_read_nvm(struct smiapp_sensor *sensor,
+			   unsigned char *nvm)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	u32 i, s, p, np, v;
+	int rval, rval2;
+
+	np = sensor->nvm_size / SMIAPP_NVM_PAGE_SIZE;
+	for (p = 0; p < np; p++) {
+		rval = smiapp_write(
+			client,
+			SMIAPP_REG_U8_DATA_TRANSFER_IF_1_PAGE_SELECT, p);
+		if (rval)
+			goto out;
+
+		rval = smiapp_write(client,
+				    SMIAPP_REG_U8_DATA_TRANSFER_IF_1_CTRL,
+				    SMIAPP_DATA_TRANSFER_IF_1_CTRL_EN |
+				    SMIAPP_DATA_TRANSFER_IF_1_CTRL_RD_EN);
+		if (rval)
+			goto out;
+
+		for (i = 0; i < 1000; i++) {
+			rval = smiapp_read(
+				client,
+				SMIAPP_REG_U8_DATA_TRANSFER_IF_1_STATUS, &s);
+
+			if (rval)
+				goto out;
+
+			if (s & SMIAPP_DATA_TRANSFER_IF_1_STATUS_RD_READY)
+				break;
+
+			if (--i == 0) {
+				rval = -ETIMEDOUT;
+				goto out;
+			}
+
+		}
+
+		for (i = 0; i < SMIAPP_NVM_PAGE_SIZE; i++) {
+			rval = smiapp_read(
+				client,
+				SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_0 + i,
+				&v);
+			if (rval)
+				goto out;
+
+			*nvm++ = v;
+		}
+	}
+
+out:
+	rval2 = smiapp_write(client, SMIAPP_REG_U8_DATA_TRANSFER_IF_1_CTRL, 0);
+	if (rval < 0)
+		return rval;
+	else
+		return rval2;
+}
+
+/*
+ *
+ * SMIA++ CCI address control
+ *
+ */
+static int smiapp_change_cci_addr(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	int rval;
+	u32 val;
+
+	client->addr = sensor->platform_data->i2c_addr_dfl;
+
+	rval = smiapp_write(client,
+			    SMIAPP_REG_U8_CCI_ADDRESS_CONTROL,
+			    sensor->platform_data->i2c_addr_alt << 1);
+	if (rval)
+		return rval;
+
+	client->addr = sensor->platform_data->i2c_addr_alt;
+
+	/* verify addr change went ok */
+	rval = smiapp_read(client, SMIAPP_REG_U8_CCI_ADDRESS_CONTROL, &val);
+	if (rval)
+		return rval;
+
+	if (val != sensor->platform_data->i2c_addr_alt << 1)
+		return -ENODEV;
+
+	return 0;
+}
+
+/*
+ *
+ * SMIA++ Mode Control
+ *
+ */
+static int smiapp_setup_flash_strobe(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	struct smiapp_flash_strobe_parms *strobe_setup;
+	unsigned int ext_freq = sensor->platform_data->ext_clk;
+	u32 tmp;
+	u32 strobe_adjustment;
+	u32 strobe_width_high_rs;
+	int rval;
+
+	strobe_setup = sensor->platform_data->strobe_setup;
+
+	/*
+	 * How to calculate registers related to strobe length. Please
+	 * do not change, or if you do at least know what you're
+	 * doing. :-)
+	 *
+	 * Sakari Ailus <sakari.ailus@maxwell.research.nokia.com> 2010-10-25
+	 *
+	 * flash_strobe_length [us] / 10^6 = (tFlash_strobe_width_ctrl
+	 *	/ EXTCLK freq [Hz]) * flash_strobe_adjustment
+	 *
+	 * tFlash_strobe_width_ctrl E N, [1 - 0xffff]
+	 * flash_strobe_adjustment E N, [1 - 0xff]
+	 *
+	 * The formula above is written as below to keep it on one
+	 * line:
+	 *
+	 * l / 10^6 = w / e * a
+	 *
+	 * Let's mark w * a by x:
+	 *
+	 * x = w * a
+	 *
+	 * Thus, we get:
+	 *
+	 * x = l * e / 10^6
+	 *
+	 * The strobe width must be at least as long as requested,
+	 * thus rounding upwards is needed.
+	 *
+	 * x = (l * e + 10^6 - 1) / 10^6
+	 * -----------------------------
+	 *
+	 * Maximum possible accuracy is wanted at all times. Thus keep
+	 * a as small as possible.
+	 *
+	 * Calculate a, assuming maximum w, with rounding upwards:
+	 *
+	 * a = (x + (2^16 - 1) - 1) / (2^16 - 1)
+	 * -------------------------------------
+	 *
+	 * Thus, we also get w, with that a, with rounding upwards:
+	 *
+	 * w = (x + a - 1) / a
+	 * -------------------
+	 *
+	 * To get limits:
+	 *
+	 * x E [1, (2^16 - 1) * (2^8 - 1)]
+	 *
+	 * Substituting maximum x to the original formula (with rounding),
+	 * the maximum l is thus
+	 *
+	 * (2^16 - 1) * (2^8 - 1) * 10^6 = l * e + 10^6 - 1
+	 *
+	 * l = (10^6 * (2^16 - 1) * (2^8 - 1) - 10^6 + 1) / e
+	 * --------------------------------------------------
+	 *
+	 * flash_strobe_length must be clamped between 1 and
+	 * (10^6 * (2^16 - 1) * (2^8 - 1) - 10^6 + 1) / EXTCLK freq.
+	 *
+	 * Then,
+	 *
+	 * flash_strobe_adjustment = ((flash_strobe_length *
+	 *	EXTCLK freq + 10^6 - 1) / 10^6 + (2^16 - 1) - 1) / (2^16 - 1)
+	 *
+	 * tFlash_strobe_width_ctrl = ((flash_strobe_length *
+	 *	EXTCLK freq + 10^6 - 1) / 10^6 +
+	 *	flash_strobe_adjustment - 1) / flash_strobe_adjustment
+	 */
+	tmp = div_u64(1000000ULL * ((1 << 16) - 1) * ((1 << 8) - 1) -
+		      1000000 + 1, ext_freq);
+	strobe_setup->strobe_width_high_us =
+		clamp_t(u32, strobe_setup->strobe_width_high_us, 1, tmp);
+
+	tmp = div_u64(((u64)strobe_setup->strobe_width_high_us * (u64)ext_freq +
+			1000000 - 1), 1000000ULL);
+	strobe_adjustment = (tmp + (1 << 16) - 1 - 1) / ((1 << 16) - 1);
+	strobe_width_high_rs = (tmp + strobe_adjustment - 1) /
+				strobe_adjustment;
+
+	rval = smiapp_write(client, SMIAPP_REG_U8_FLASH_MODE_RS,
+			    strobe_setup->mode);
+	if (rval < 0)
+		goto out;
+
+	rval = smiapp_write(client, SMIAPP_REG_U8_FLASH_STROBE_ADJUSTMENT,
+			    strobe_adjustment);
+	if (rval < 0)
+		goto out;
+
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_TFLASH_STROBE_WIDTH_HIGH_RS_CTRL,
+		strobe_width_high_rs);
+	if (rval < 0)
+		goto out;
+
+	rval = smiapp_write(client, SMIAPP_REG_U16_TFLASH_STROBE_DELAY_RS_CTRL,
+			    strobe_setup->strobe_delay);
+	if (rval < 0)
+		goto out;
+
+	rval = smiapp_write(client, SMIAPP_REG_U16_FLASH_STROBE_START_POINT,
+			    strobe_setup->stobe_start_point);
+	if (rval < 0)
+		goto out;
+
+	rval = smiapp_write(client, SMIAPP_REG_U8_FLASH_TRIGGER_RS,
+			    strobe_setup->trigger);
+
+out:
+	sensor->platform_data->strobe_setup->trigger = 0;
+
+	return rval;
+}
+
+/* -----------------------------------------------------------------------------
+ * Power management
+ */
+
+static int smiapp_power_on(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	unsigned int sleep;
+	int rval;
+
+	rval = regulator_enable(sensor->vana);
+	if (rval) {
+		dev_err(&client->dev, "failed to enable vana regulator\n");
+		return rval;
+	}
+	usleep_range(1000, 1000);
+
+	rval = sensor->platform_data->set_xclk(&sensor->src->sd,
+					sensor->platform_data->ext_clk);
+	if (rval < 0) {
+		dev_dbg(&client->dev, "failed to set xclk\n");
+		goto out_xclk_fail;
+	}
+	usleep_range(1000, 1000);
+
+	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+		gpio_set_value(sensor->platform_data->xshutdown, 1);
+
+	sleep = SMIAPP_RESET_DELAY(sensor->platform_data->ext_clk);
+	usleep_range(sleep, sleep);
+
+	/*
+	 * Failures to respond to the address change command have been noticed.
+	 * Those failures seem to be caused by the sensor requiring a longer
+	 * boot time than advertised. An additional 10ms delay seems to work
+	 * around the issue, but the SMIA++ I2C write retry hack makes the delay
+	 * unnecessary. The failures need to be investigated to find a proper
+	 * fix, and a delay will likely need to be added here if the I2C write
+	 * retry hack is reverted before the root cause of the boot time issue
+	 * is found.
+	 */
+
+	if (sensor->platform_data->i2c_addr_alt) {
+		rval = smiapp_change_cci_addr(sensor);
+		if (rval) {
+			dev_err(&client->dev, "cci address change error\n");
+			goto out_cci_addr_fail;
+		}
+	}
+
+	rval = smiapp_write(client, SMIAPP_REG_U8_SOFTWARE_RESET,
+			    SMIAPP_SOFTWARE_RESET);
+	if (rval < 0) {
+		dev_err(&client->dev, "software reset failed\n");
+		goto out_cci_addr_fail;
+	}
+
+	if (sensor->platform_data->i2c_addr_alt) {
+		rval = smiapp_change_cci_addr(sensor);
+		if (rval) {
+			dev_err(&client->dev, "cci address change error\n");
+			goto out_cci_addr_fail;
+		}
+	}
+
+	rval = smiapp_write(client, SMIAPP_REG_U16_COMPRESSION_MODE,
+			    SMIAPP_COMPRESSION_MODE_SIMPLE_PREDICTOR);
+	if (rval) {
+		dev_err(&client->dev, "compression mode set failed\n");
+		goto out_cci_addr_fail;
+	}
+
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_EXTCLK_FREQUENCY_MHZ,
+		sensor->platform_data->ext_clk / (1000000 / (1 << 8)));
+	if (rval) {
+		dev_err(&client->dev, "extclk frequency set failed\n");
+		goto out_cci_addr_fail;
+	}
+
+	rval = smiapp_write(client, SMIAPP_REG_U8_CSI_LANE_MODE,
+			    sensor->platform_data->lanes - 1);
+	if (rval) {
+		dev_err(&client->dev, "csi lane mode set failed\n");
+		goto out_cci_addr_fail;
+	}
+
+	rval = smiapp_write(client, SMIAPP_REG_U8_FAST_STANDBY_CTRL,
+			    SMIAPP_FAST_STANDBY_CTRL_IMMEDIATE);
+	if (rval) {
+		dev_err(&client->dev, "fast standby set failed\n");
+		goto out_cci_addr_fail;
+	}
+
+	rval = smiapp_write(client, SMIAPP_REG_U8_CSI_SIGNALLING_MODE,
+			    sensor->platform_data->csi_signalling_mode);
+	if (rval) {
+		dev_err(&client->dev, "csi signalling mode set failed\n");
+		goto out_cci_addr_fail;
+	}
+
+	/* DPHY control done by sensor based on requested link rate */
+	rval = smiapp_write(client, SMIAPP_REG_U8_DPHY_CTRL,
+			    SMIAPP_DPHY_CTRL_UI);
+	if (rval < 0)
+		return rval;
+
+	rval = smiapp_call_quirk(sensor, post_poweron);
+	if (rval) {
+		dev_err(&client->dev, "post_poweron quirks failed\n");
+		goto out_cci_addr_fail;
+	}
+
+	/* Are we still initialising...? If yes, return here. */
+	if (!sensor->pixel_array)
+		return 0;
+
+	rval = v4l2_ctrl_handler_setup(
+		&sensor->pixel_array->ctrl_handler);
+	if (rval)
+		goto out_cci_addr_fail;
+
+	rval = v4l2_ctrl_handler_setup(&sensor->src->ctrl_handler);
+	if (rval)
+		goto out_cci_addr_fail;
+
+	mutex_lock(&sensor->mutex);
+	rval = smiapp_update_mode(sensor);
+	mutex_unlock(&sensor->mutex);
+	if (rval < 0)
+		goto out_cci_addr_fail;
+
+	return 0;
+
+out_cci_addr_fail:
+	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+		gpio_set_value(sensor->platform_data->xshutdown, 0);
+	sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+
+out_xclk_fail:
+	regulator_disable(sensor->vana);
+	return rval;
+}
+
+static void smiapp_power_off(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+
+	/*
+	 * Currently power/clock to lens are enable/disabled separately
+	 * but they are essentially the same signals. So if the sensor is
+	 * powered off while the lens is powered on the sensor does not
+	 * really see a power off and next time the cci address change
+	 * will fail. So do a soft reset explicitly here.
+	 */
+	if (sensor->platform_data->i2c_addr_alt)
+		smiapp_write(client,
+			     SMIAPP_REG_U8_SOFTWARE_RESET,
+			     SMIAPP_SOFTWARE_RESET);
+
+	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+		gpio_set_value(sensor->platform_data->xshutdown, 0);
+	sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+	usleep_range(5000, 5000);
+	regulator_disable(sensor->vana);
+	sensor->streaming = 0;
+}
+
+static int smiapp_set_power(struct v4l2_subdev *subdev, int on)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	int ret = 0;
+
+	mutex_lock(&sensor->power_mutex);
+
+	/*
+	 * If the power count is modified from 0 to != 0 or from != 0
+	 * to 0, update the power state.
+	 */
+	if (!sensor->power_count == !on)
+		goto out;
+
+	if (on) {
+		/* Power on and perform initialisation. */
+		ret = smiapp_power_on(sensor);
+		if (ret < 0)
+			goto out;
+	} else {
+		smiapp_power_off(sensor);
+	}
+
+	/* Update the power count. */
+	sensor->power_count += on ? 1 : -1;
+	WARN_ON(sensor->power_count < 0);
+
+out:
+	mutex_unlock(&sensor->power_mutex);
+	return ret;
+}
+
+/* -----------------------------------------------------------------------------
+ * Video stream management
+ */
+
+static int smiapp_start_streaming(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	int rval;
+
+	mutex_lock(&sensor->mutex);
+
+	rval = smiapp_write(client, SMIAPP_REG_U16_CSI_DATA_FORMAT,
+			    (sensor->csi_format->width << 8) |
+			    sensor->csi_format->compressed);
+	if (rval)
+		goto out;
+
+	rval = smiapp_pll_configure(sensor);
+	if (rval)
+		goto out;
+
+	/* Analog crop start coordinates */
+	rval = smiapp_write(client, SMIAPP_REG_U16_X_ADDR_START,
+			    sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].left);
+	if (rval < 0)
+		goto out;
+
+	rval = smiapp_write(client, SMIAPP_REG_U16_Y_ADDR_START,
+			    sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].top);
+	if (rval < 0)
+		goto out;
+
+	/* Analog crop end coordinates */
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_X_ADDR_END,
+		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].left
+		+ sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].width - 1);
+	if (rval < 0)
+		goto out;
+
+	rval = smiapp_write(
+		client, SMIAPP_REG_U16_Y_ADDR_END,
+		sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].top
+		+ sensor->pixel_array->crop[SMIAPP_PA_PAD_SRC].height - 1);
+	if (rval < 0)
+		goto out;
+
+	/*
+	 * Output from pixel array, including blanking, is set using
+	 * controls below. No need to set here.
+	 */
+
+	/* Digital crop */
+	if (sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
+	    == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP) {
+		rval = smiapp_write(
+			client, SMIAPP_REG_U16_DIGITAL_CROP_X_OFFSET,
+			sensor->scaler->crop[SMIAPP_PAD_SINK].left);
+		if (rval < 0)
+			goto out;
+
+		rval = smiapp_write(
+			client, SMIAPP_REG_U16_DIGITAL_CROP_Y_OFFSET,
+			sensor->scaler->crop[SMIAPP_PAD_SINK].top);
+		if (rval < 0)
+			goto out;
+
+		rval = smiapp_write(
+			client, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_WIDTH,
+			sensor->scaler->crop[SMIAPP_PAD_SINK].width);
+		if (rval < 0)
+			goto out;
+
+		rval = smiapp_write(
+			client, SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_HEIGHT,
+			sensor->scaler->crop[SMIAPP_PAD_SINK].height);
+		if (rval < 0)
+			goto out;
+	}
+
+	/* Scaling */
+	if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
+	    != SMIAPP_SCALING_CAPABILITY_NONE) {
+		rval = smiapp_write(client, SMIAPP_REG_U16_SCALING_MODE,
+				    sensor->scaling_mode);
+		if (rval < 0)
+			goto out;
+
+		rval = smiapp_write(client, SMIAPP_REG_U16_SCALE_M,
+				    sensor->scale_m);
+		if (rval < 0)
+			goto out;
+	}
+
+	/* Output size from sensor */
+	rval = smiapp_write(client, SMIAPP_REG_U16_X_OUTPUT_SIZE,
+			    sensor->src->crop[SMIAPP_PAD_SRC].width);
+	if (rval < 0)
+		goto out;
+	rval = smiapp_write(client, SMIAPP_REG_U16_Y_OUTPUT_SIZE,
+			    sensor->src->crop[SMIAPP_PAD_SRC].height);
+	if (rval < 0)
+		goto out;
+
+	if ((sensor->flash_capability &
+	     (SMIAPP_FLASH_MODE_CAPABILITY_SINGLE_STROBE |
+	      SMIAPP_FLASH_MODE_CAPABILITY_MULTIPLE_STROBE)) &&
+	    sensor->platform_data->strobe_setup != NULL &&
+	    sensor->platform_data->strobe_setup->trigger != 0) {
+		rval = smiapp_setup_flash_strobe(sensor);
+		if (rval)
+			goto out;
+	}
+
+	rval = smiapp_call_quirk(sensor, pre_streamon);
+	if (rval) {
+		dev_err(&client->dev, "pre_streamon quirks failed\n");
+		goto out;
+	}
+
+	rval = smiapp_write(client, SMIAPP_REG_U8_MODE_SELECT,
+			    SMIAPP_MODE_SELECT_STREAMING);
+
+out:
+	mutex_unlock(&sensor->mutex);
+
+	return rval;
+}
+
+static int smiapp_stop_streaming(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	int rval;
+
+	mutex_lock(&sensor->mutex);
+	rval = smiapp_write(client, SMIAPP_REG_U8_MODE_SELECT,
+			    SMIAPP_MODE_SELECT_SOFTWARE_STANDBY);
+	if (rval)
+		goto out;
+
+	rval = smiapp_call_quirk(sensor, post_streamoff);
+	if (rval)
+		dev_err(&client->dev, "post_streamoff quirks failed\n");
+
+out:
+	mutex_unlock(&sensor->mutex);
+	return rval;
+}
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev video operations
+ */
+
+static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	int rval;
+
+	if (sensor->streaming == enable)
+		return 0;
+
+	if (enable) {
+		sensor->streaming = 1;
+		rval = smiapp_start_streaming(sensor);
+		if (rval < 0)
+			sensor->streaming = 0;
+	} else {
+		rval = smiapp_stop_streaming(sensor);
+		sensor->streaming = 0;
+	}
+
+	return rval;
+}
+
+static int smiapp_enum_mbus_code(struct v4l2_subdev *subdev,
+				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_mbus_code_enum *code)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	unsigned int i;
+	int idx = -1;
+	int rval = -EINVAL;
+
+	mutex_lock(&sensor->mutex);
+
+	dev_err(&client->dev, "subdev %s, pad %d, index %d\n",
+		subdev->name, code->pad, code->index);
+
+	if (subdev != &sensor->src->sd || code->pad != SMIAPP_PAD_SRC) {
+		if (code->index)
+			goto out;
+
+		code->code = sensor->internal_csi_format->code;
+		rval = 0;
+		goto out;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
+		if (sensor->mbus_frame_fmts & (1 << i))
+			idx++;
+
+		if (idx == code->index) {
+			code->code = smiapp_csi_data_formats[i].code;
+			dev_err(&client->dev, "found index %d, i %d, code %x\n",
+				code->index, i, code->code);
+			rval = 0;
+			break;
+		}
+	}
+
+out:
+	mutex_unlock(&sensor->mutex);
+
+	return rval;
+}
+
+static u32 __smiapp_get_mbus_code(struct v4l2_subdev *subdev,
+				  unsigned int pad)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+
+	if (subdev == &sensor->src->sd && pad == SMIAPP_PAD_SRC)
+		return sensor->csi_format->code;
+	else
+		return sensor->internal_csi_format->code;
+}
+
+static int __smiapp_get_format(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_format *fmt)
+{
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+
+	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
+		fmt->format = *v4l2_subdev_get_try_format(fh, fmt->pad);
+	} else {
+		struct v4l2_rect *r;
+
+		if (fmt->pad == ssd->source_pad)
+			r = &ssd->crop[ssd->source_pad];
+		else
+			r = &ssd->sink_fmt;
+
+		fmt->format.code = __smiapp_get_mbus_code(subdev, fmt->pad);
+		fmt->format.width = r->width;
+		fmt->format.height = r->height;
+	}
+
+	return 0;
+}
+
+static int smiapp_get_format(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_format *fmt)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	int rval;
+
+	mutex_lock(&sensor->mutex);
+	rval = __smiapp_get_format(subdev, fh, fmt);
+	mutex_unlock(&sensor->mutex);
+
+	return rval;
+}
+
+static void smiapp_get_crop_compose(struct v4l2_subdev *subdev,
+				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_rect **crops,
+				    struct v4l2_rect **comps, int which)
+{
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+	unsigned int i;
+
+	if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		if (crops)
+			for (i = 0; i < subdev->entity.num_pads; i++)
+				crops[i] = &ssd->crop[i];
+		if (comps)
+			*comps = &ssd->compose;
+	} else {
+		if (crops) {
+			for (i = 0; i < subdev->entity.num_pads; i++) {
+				crops[i] = v4l2_subdev_get_try_crop(fh, i);
+				BUG_ON(!crops[i]);
+			}
+		}
+		if (comps) {
+			*comps = v4l2_subdev_get_try_compose(fh,
+							     SMIAPP_PAD_SINK);
+			BUG_ON(!*comps);
+		}
+	}
+}
+
+/* Changes require propagation only on sink pad. */
+static void smiapp_propagate(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_fh *fh, int which,
+			     int target)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+	struct v4l2_rect *comp, *crops[SMIAPP_PADS];
+
+	smiapp_get_crop_compose(subdev, fh, crops, &comp, which);
+
+	switch (target) {
+	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+		comp->width = crops[SMIAPP_PAD_SINK]->width;
+		comp->height = crops[SMIAPP_PAD_SINK]->height;
+		if (which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+			if (ssd == sensor->scaler) {
+				sensor->scale_m =
+					sensor->limits[
+						SMIAPP_LIMIT_SCALER_N_MIN];
+				sensor->scaling_mode =
+					SMIAPP_SCALING_MODE_NONE;
+			} else if (ssd == sensor->binner) {
+				sensor->binning_horizontal = 1;
+				sensor->binning_vertical = 1;
+			}
+		}
+		/* Fall through */
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+		*crops[SMIAPP_PAD_SRC] = *comp;
+		break;
+	default:
+		BUG();
+	}
+}
+
+static const struct smiapp_csi_data_format
+*smiapp_validate_csi_data_format(struct smiapp_sensor *sensor, u32 code)
+{
+	const struct smiapp_csi_data_format *csi_format = sensor->csi_format;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(smiapp_csi_data_formats); i++) {
+		if (sensor->mbus_frame_fmts & (1 << i)
+		    && smiapp_csi_data_formats[i].code == code)
+			return &smiapp_csi_data_formats[i];
+	}
+
+	return csi_format;
+}
+
+static int smiapp_set_format(struct v4l2_subdev *subdev,
+			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_format *fmt)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+	struct v4l2_rect *crops[SMIAPP_PADS];
+
+	mutex_lock(&sensor->mutex);
+
+	/*
+	 * Media bus code is changeable on src subdev's source pad. On
+	 * other source pads we just get format here.
+	 */
+	if (fmt->pad == ssd->source_pad) {
+		u32 code = fmt->format.code;
+		int rval = __smiapp_get_format(subdev, fh, fmt);
+
+		if (!rval && subdev == &sensor->src->sd) {
+			const struct smiapp_csi_data_format *csi_format =
+				smiapp_validate_csi_data_format(sensor, code);
+			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+				sensor->csi_format = csi_format;
+			fmt->format.code = csi_format->code;
+		}
+
+		mutex_unlock(&sensor->mutex);
+		return rval;
+	}
+
+	/* Sink pad. Width and height are changeable here. */
+	fmt->format.code = __smiapp_get_mbus_code(subdev, fmt->pad);
+	fmt->format.width &= ~1;
+	fmt->format.height &= ~1;
+
+	fmt->format.width =
+		clamp(fmt->format.width,
+		      sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
+		      sensor->limits[SMIAPP_LIMIT_MAX_X_OUTPUT_SIZE]);
+	fmt->format.height =
+		clamp(fmt->format.height,
+		      sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
+		      sensor->limits[SMIAPP_LIMIT_MAX_Y_OUTPUT_SIZE]);
+
+	smiapp_get_crop_compose(subdev, fh, crops, NULL, fmt->which);
+
+	crops[ssd->sink_pad]->left = 0;
+	crops[ssd->sink_pad]->top = 0;
+	crops[ssd->sink_pad]->width = fmt->format.width;
+	crops[ssd->sink_pad]->height = fmt->format.height;
+	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		ssd->sink_fmt = *crops[ssd->sink_pad];
+	smiapp_propagate(subdev, fh, fmt->which,
+			 V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL);
+
+	mutex_unlock(&sensor->mutex);
+
+	return 0;
+}
+
+/*
+ * Calculate goodness of scaled image size compared to expected image
+ * size and flags provided.
+ */
+#define SCALING_GOODNESS		100000
+#define SCALING_GOODNESS_EXTREME	100000000
+static int scaling_goodness(struct v4l2_subdev *subdev, int w, int ask_w,
+			    int h, int ask_h, u32 flags)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	int val = 0;
+
+	w &= ~1;
+	ask_w &= ~1;
+	h &= ~1;
+	ask_h &= ~1;
+
+	if (flags & V4L2_SUBDEV_SEL_FLAG_SIZE_GE) {
+		if (w < ask_w)
+			val -= SCALING_GOODNESS;
+		if (h < ask_h)
+			val -= SCALING_GOODNESS;
+	}
+
+	if (flags & V4L2_SUBDEV_SEL_FLAG_SIZE_LE) {
+		if (w > ask_w)
+			val -= SCALING_GOODNESS;
+		if (h > ask_h)
+			val -= SCALING_GOODNESS;
+	}
+
+	val -= abs(w - ask_w);
+	val -= abs(h - ask_h);
+
+	if (w < sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE])
+		val -= SCALING_GOODNESS_EXTREME;
+
+	dev_dbg(&client->dev, "w %d ask_w %d h %d ask_h %d goodness %d\n",
+		w, ask_h, h, ask_h, val);
+
+	return val;
+}
+
+static void smiapp_set_compose_binner(struct v4l2_subdev *subdev,
+				      struct v4l2_subdev_fh *fh,
+				      struct v4l2_subdev_selection *sel,
+				      struct v4l2_rect **crops,
+				      struct v4l2_rect *comp)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	unsigned int i;
+	unsigned int binh = 1, binv = 1;
+	unsigned int best = scaling_goodness(
+		subdev,
+		crops[SMIAPP_PAD_SINK]->width, sel->r.width,
+		crops[SMIAPP_PAD_SINK]->height, sel->r.height, sel->flags);
+
+	for (i = 0; i < sensor->nbinning_subtypes; i++) {
+		int this = scaling_goodness(
+			subdev,
+			crops[SMIAPP_PAD_SINK]->width
+			/ sensor->binning_subtypes[i].horizontal,
+			sel->r.width,
+			crops[SMIAPP_PAD_SINK]->height
+			/ sensor->binning_subtypes[i].vertical,
+			sel->r.height, sel->flags);
+
+		if (this > best) {
+			binh = sensor->binning_subtypes[i].horizontal;
+			binv = sensor->binning_subtypes[i].vertical;
+			best = this;
+		}
+	}
+	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		sensor->binning_vertical = binv;
+		sensor->binning_horizontal = binh;
+	}
+
+	sel->r.width = (crops[SMIAPP_PAD_SINK]->width / binh) & ~1;
+	sel->r.height = (crops[SMIAPP_PAD_SINK]->height / binv) & ~1;
+}
+
+/*
+ * Calculate best scaling ratio and mode for given output resolution.
+ *
+ * Try all of these: horizontal ratio, vertical ratio and smallest
+ * size possible (horizontally).
+ *
+ * Also try whether horizontal scaler or full scaler gives a better
+ * result.
+ */
+static void smiapp_set_compose_scaler(struct v4l2_subdev *subdev,
+				      struct v4l2_subdev_fh *fh,
+				      struct v4l2_subdev_selection *sel,
+				      struct v4l2_rect **crops,
+				      struct v4l2_rect *comp)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	u32 min, max, a, b, max_m;
+	u32 scale_m = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
+	int mode = SMIAPP_SCALING_MODE_HORIZONTAL;
+	u32 try[4];
+	u32 ntry = 0;
+	unsigned int i;
+	int best = INT_MIN;
+
+	sel->r.width = min_t(unsigned int, sel->r.width,
+			     crops[SMIAPP_PAD_SINK]->width);
+	sel->r.height = min_t(unsigned int, sel->r.height,
+			      crops[SMIAPP_PAD_SINK]->height);
+
+	a = crops[SMIAPP_PAD_SINK]->width
+		* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN] / sel->r.width;
+	b = crops[SMIAPP_PAD_SINK]->height
+		* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN] / sel->r.height;
+	max_m = crops[SMIAPP_PAD_SINK]->width
+		* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]
+		/ sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE];
+
+	a = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
+		max(a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
+	b = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
+		max(b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
+	max_m = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
+		    max(max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
+
+	dev_dbg(&client->dev, "scaling: a %d b %d max_m %d\n", a, b, max_m);
+
+	min = min(max_m, min(a, b));
+	max = min(max_m, max(a, b));
+
+	try[ntry] = min;
+	ntry++;
+	if (min != max) {
+		try[ntry] = max;
+		ntry++;
+	}
+	if (max != max_m) {
+		try[ntry] = min + 1;
+		ntry++;
+		if (min != max) {
+			try[ntry] = max + 1;
+			ntry++;
+		}
+	}
+
+	for (i = 0; i < ntry; i++) {
+		int this = scaling_goodness(
+			subdev,
+			crops[SMIAPP_PAD_SINK]->width
+			/ try[i]
+			* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN],
+			sel->r.width,
+			crops[SMIAPP_PAD_SINK]->height,
+			sel->r.height,
+			sel->flags);
+
+		dev_dbg(&client->dev, "trying factor %d (%d)\n", try[i], i);
+
+		if (this > best) {
+			scale_m = try[i];
+			mode = SMIAPP_SCALING_MODE_HORIZONTAL;
+			best = this;
+		}
+
+		if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
+		    == SMIAPP_SCALING_CAPABILITY_HORIZONTAL)
+			continue;
+
+		this = scaling_goodness(
+			subdev, crops[SMIAPP_PAD_SINK]->width
+			/ try[i]
+			* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN],
+			sel->r.width,
+			crops[SMIAPP_PAD_SINK]->height
+			/ try[i]
+			* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN],
+			sel->r.height,
+			sel->flags);
+
+		if (this > best) {
+			scale_m = try[i];
+			mode = SMIAPP_SCALING_MODE_BOTH;
+			best = this;
+		}
+	}
+
+	sel->r.width =
+		(crops[SMIAPP_PAD_SINK]->width
+		 / scale_m
+		 * sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]) & ~1;
+	if (mode == SMIAPP_SCALING_MODE_BOTH)
+		sel->r.height =
+			(crops[SMIAPP_PAD_SINK]->height
+			 / scale_m
+			 * sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN])
+			& ~1;
+	else
+		sel->r.height = crops[SMIAPP_PAD_SINK]->height;
+
+	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		sensor->scale_m = scale_m;
+		sensor->scaling_mode = mode;
+	}
+}
+/* We're only called on source pads. This function sets scaling. */
+static int smiapp_set_compose(struct v4l2_subdev *subdev,
+			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_selection *sel)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+	struct v4l2_rect *comp, *crops[SMIAPP_PADS];
+
+	smiapp_get_crop_compose(subdev, fh, crops, &comp, sel->which);
+
+	sel->r.top = 0;
+	sel->r.left = 0;
+
+	if (ssd == sensor->binner)
+		smiapp_set_compose_binner(subdev, fh, sel, crops, comp);
+	else
+		smiapp_set_compose_scaler(subdev, fh, sel, crops, comp);
+
+	*comp = sel->r;
+	smiapp_propagate(subdev, fh, sel->which,
+			 V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL);
+
+	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		return smiapp_update_mode(sensor);
+
+	return 0;
+}
+
+static int __smiapp_sel_supported(struct v4l2_subdev *subdev,
+				  struct v4l2_subdev_selection *sel)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+
+	/* We only implement crop in three places. */
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+		if (ssd == sensor->pixel_array
+		    && sel->pad == SMIAPP_PA_PAD_SRC)
+			return 0;
+		if (ssd == sensor->src
+		    && sel->pad == SMIAPP_PAD_SRC)
+			return 0;
+		if (ssd == sensor->scaler
+		    && sel->pad == SMIAPP_PAD_SINK
+		    && sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
+		    == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP)
+			return 0;
+		return -EINVAL;
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+		if (sel->pad == ssd->source_pad)
+			return -EINVAL;
+		if (ssd == sensor->binner)
+			return 0;
+		if (ssd == sensor->scaler
+		    && sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
+		    != SMIAPP_SCALING_CAPABILITY_NONE)
+			return 0;
+		/* Fall through */
+	default:
+		return -EINVAL;
+	}
+}
+
+static int smiapp_set_crop(struct v4l2_subdev *subdev,
+			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_selection *sel)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+	struct v4l2_rect *src_size, *crops[SMIAPP_PADS];
+	struct v4l2_rect _r;
+
+	smiapp_get_crop_compose(subdev, fh, crops, NULL, sel->which);
+
+	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		if (sel->pad == ssd->sink_pad)
+			src_size = &ssd->sink_fmt;
+		else
+			src_size = &ssd->compose;
+	} else {
+		if (sel->pad == ssd->sink_pad) {
+			_r.left = 0;
+			_r.top = 0;
+			_r.width = v4l2_subdev_get_try_format(fh, sel->pad)
+				->width;
+			_r.height = v4l2_subdev_get_try_format(fh, sel->pad)
+				->height;
+			src_size = &_r;
+		} else {
+			src_size =
+				v4l2_subdev_get_try_compose(
+					fh, ssd->sink_pad);
+		}
+	}
+
+	if (ssd == sensor->src && sel->pad == SMIAPP_PAD_SRC) {
+		sel->r.left = 0;
+		sel->r.top = 0;
+	}
+
+	sel->r.width = min(sel->r.width, src_size->width);
+	sel->r.height = min(sel->r.height, src_size->height);
+
+	sel->r.left = min(sel->r.left, src_size->width - sel->r.width);
+	sel->r.top = min(sel->r.top, src_size->height - sel->r.height);
+
+	*crops[sel->pad] = sel->r;
+
+	if (ssd != sensor->pixel_array && sel->pad == SMIAPP_PAD_SINK)
+		smiapp_propagate(subdev, fh, sel->which,
+				 V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL);
+
+	return 0;
+}
+
+static int __smiapp_get_selection(struct v4l2_subdev *subdev,
+				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_selection *sel)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
+	struct v4l2_rect *comp, *crops[SMIAPP_PADS];
+	struct v4l2_rect sink_fmt;
+	int ret;
+
+	ret = __smiapp_sel_supported(subdev, sel);
+	if (ret)
+		return ret;
+
+	smiapp_get_crop_compose(subdev, fh, crops, &comp, sel->which);
+
+	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
+		sink_fmt = ssd->sink_fmt;
+	} else {
+		struct v4l2_mbus_framefmt *fmt =
+			v4l2_subdev_get_try_format(fh, ssd->sink_pad);
+
+		sink_fmt.left = 0;
+		sink_fmt.top = 0;
+		sink_fmt.width = fmt->width;
+		sink_fmt.height = fmt->height;
+	}
+
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS:
+		if (ssd == sensor->pixel_array) {
+			sel->r.width =
+				sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
+			sel->r.height =
+				sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+		} else if (sel->pad == ssd->sink_pad) {
+			sel->r = sink_fmt;
+		} else {
+			sel->r = *comp;
+		}
+		break;
+	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS:
+		sel->r = *crops[sel->pad];
+		break;
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+		sel->r = *comp;
+		break;
+	}
+
+	return 0;
+}
+
+static int smiapp_get_selection(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	int rval;
+
+	mutex_lock(&sensor->mutex);
+	rval = __smiapp_get_selection(subdev, fh, sel);
+	mutex_unlock(&sensor->mutex);
+
+	return rval;
+}
+static int smiapp_set_selection(struct v4l2_subdev *subdev,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	int ret;
+
+	ret = __smiapp_sel_supported(subdev, sel);
+	if (ret)
+		return ret;
+
+	mutex_lock(&sensor->mutex);
+
+	sel->r.left = max(0, sel->r.left & ~1);
+	sel->r.top = max(0, sel->r.top & ~1);
+	sel->r.width = max(0, SMIAPP_ALIGN_DIM(sel->r.width, sel->flags));
+	sel->r.height = max(0, SMIAPP_ALIGN_DIM(sel->r.height, sel->flags));
+
+	sel->r.width = max_t(unsigned int,
+			     sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
+			     sel->r.width);
+	sel->r.height = max_t(unsigned int,
+			      sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
+			      sel->r.height);
+
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL:
+		ret = smiapp_set_crop(subdev, fh, sel);
+		break;
+	case V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL:
+		ret = smiapp_set_compose(subdev, fh, sel);
+		break;
+	default:
+		BUG();
+	}
+
+	mutex_unlock(&sensor->mutex);
+	return ret;
+}
+
+static int smiapp_get_skip_frames(struct v4l2_subdev *subdev, u32 *frames)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+
+	*frames = sensor->frame_skip;
+	return 0;
+}
+
+/* -----------------------------------------------------------------------------
+ * sysfs attributes
+ */
+
+static ssize_t
+smiapp_sysfs_nvm_read(struct device *dev, struct device_attribute *attr,
+		      char *buf)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(to_i2c_client(dev));
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	unsigned int nbytes;
+
+	if (!sensor->dev_init_done)
+		return -EBUSY;
+
+	if (!sensor->nvm_size) {
+		/* NVM not read yet - read it now */
+		sensor->nvm_size = sensor->platform_data->nvm_size;
+		if (smiapp_set_power(subdev, 1) < 0)
+			return -ENODEV;
+		if (smiapp_read_nvm(sensor, sensor->nvm)) {
+			dev_err(&client->dev, "nvm read failed\n");
+			return -ENODEV;
+		}
+		smiapp_set_power(subdev, 0);
+	}
+	/*
+	 * NVM is still way below a PAGE_SIZE, so we can safely
+	 * assume this for now.
+	 */
+	nbytes = min_t(unsigned int, sensor->nvm_size, PAGE_SIZE);
+	memcpy(buf, sensor->nvm, nbytes);
+
+	return nbytes;
+}
+static DEVICE_ATTR(nvm, S_IRUGO, smiapp_sysfs_nvm_read, NULL);
+
+/* -----------------------------------------------------------------------------
+ * V4L2 subdev core operations
+ */
+
+static int smiapp_identify_module(struct v4l2_subdev *subdev)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct smiapp_module_info *minfo = &sensor->minfo;
+	unsigned int i;
+	int rval = 0;
+
+	minfo->name = SMIAPP_NAME;
+
+	/* Module info */
+	rval = smiapp_read(client, SMIAPP_REG_U8_MANUFACTURER_ID,
+			   &minfo->manufacturer_id);
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U16_MODEL_ID,
+				   &minfo->model_id);
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U8_REVISION_NUMBER_MAJOR,
+				   &minfo->revision_number_major);
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U8_REVISION_NUMBER_MINOR,
+				   &minfo->revision_number_minor);
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U8_MODULE_DATE_YEAR,
+				   &minfo->module_year);
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U8_MODULE_DATE_MONTH,
+				   &minfo->module_month);
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U8_MODULE_DATE_DAY,
+				   &minfo->module_day);
+
+	/* Sensor info */
+	if (!rval)
+		rval = smiapp_read(client,
+				   SMIAPP_REG_U8_SENSOR_MANUFACTURER_ID,
+				   &minfo->sensor_manufacturer_id);
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U16_SENSOR_MODEL_ID,
+				   &minfo->sensor_model_id);
+	if (!rval)
+		rval = smiapp_read(client,
+				   SMIAPP_REG_U8_SENSOR_REVISION_NUMBER,
+				   &minfo->sensor_revision_number);
+	if (!rval)
+		rval = smiapp_read(client,
+				   SMIAPP_REG_U8_SENSOR_FIRMWARE_VERSION,
+				   &minfo->sensor_firmware_version);
+
+	/* SMIA */
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U8_SMIA_VERSION,
+				   &minfo->smia_version);
+	if (!rval)
+		rval = smiapp_read(client, SMIAPP_REG_U8_SMIAPP_VERSION,
+				   &minfo->smiapp_version);
+
+	if (rval) {
+		dev_err(&client->dev, "sensor detection failed\n");
+		return -ENODEV;
+	}
+
+	dev_dbg(&client->dev, "module 0x%2.2x-0x%4.4x\n",
+		minfo->manufacturer_id, minfo->model_id);
+
+	dev_dbg(&client->dev,
+		"module revision 0x%2.2x-0x%2.2x date %2.2d-%2.2d-%2.2d\n",
+		minfo->revision_number_major, minfo->revision_number_minor,
+		minfo->module_year, minfo->module_month, minfo->module_day);
+
+	dev_dbg(&client->dev, "sensor 0x%2.2x-0x%4.4x\n",
+		minfo->sensor_manufacturer_id, minfo->sensor_model_id);
+
+	dev_dbg(&client->dev,
+		"sensor revision 0x%2.2x firmware version 0x%2.2x\n",
+		minfo->sensor_revision_number, minfo->sensor_firmware_version);
+
+	dev_dbg(&client->dev, "smia version %2.2d smiapp version %2.2d\n",
+		minfo->smia_version, minfo->smiapp_version);
+
+	/*
+	 * Some modules have bad data in the lvalues below. Hope the
+	 * rvalues have better stuff. The lvalues are module
+	 * parameters whereas the rvalues are sensor parameters.
+	 */
+	if (!minfo->manufacturer_id && !minfo->model_id) {
+		minfo->manufacturer_id = minfo->sensor_manufacturer_id;
+		minfo->model_id = minfo->sensor_model_id;
+		minfo->revision_number_major = minfo->sensor_revision_number;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(smiapp_module_idents); i++) {
+		if (smiapp_module_idents[i].manufacturer_id
+		    != minfo->manufacturer_id)
+			continue;
+		if (smiapp_module_idents[i].model_id != minfo->model_id)
+			continue;
+		if (smiapp_module_idents[i].flags
+		    & SMIAPP_MODULE_IDENT_FLAG_REV_LE) {
+			if (smiapp_module_idents[i].revision_number_major
+			    < minfo->revision_number_major)
+				continue;
+		} else {
+			if (smiapp_module_idents[i].revision_number_major
+			    != minfo->revision_number_major)
+				continue;
+		}
+
+		minfo->name = smiapp_module_idents[i].name;
+		minfo->quirk = smiapp_module_idents[i].quirk;
+		break;
+	}
+
+	if (i >= ARRAY_SIZE(smiapp_module_idents))
+		dev_warn(&client->dev,
+			 "no quirks for this module; let's hope it's fully compliant\n");
+
+	dev_dbg(&client->dev, "the sensor is called %s, ident %2.2x%4.4x%2.2x\n",
+		minfo->name, minfo->manufacturer_id, minfo->model_id,
+		minfo->revision_number_major);
+
+	strlcpy(subdev->name, sensor->minfo.name, sizeof(subdev->name));
+
+	return 0;
+}
+
+static const struct v4l2_subdev_ops smiapp_ops;
+static const struct v4l2_subdev_internal_ops smiapp_internal_ops;
+static const struct media_entity_operations smiapp_entity_ops;
+
+static int smiapp_registered(struct v4l2_subdev *subdev)
+{
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+	struct smiapp_subdev *last = NULL;
+	u32 tmp;
+	unsigned int i;
+	int rval;
+
+	sensor->vana = regulator_get(&client->dev, "VANA");
+	if (IS_ERR(sensor->vana)) {
+		dev_err(&client->dev, "could not get regulator for vana\n");
+		return -ENODEV;
+	}
+
+	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN) {
+		if (gpio_request_one(sensor->platform_data->xshutdown, 0,
+				     "SMIA++ xshutdown") != 0) {
+			dev_err(&client->dev,
+				"unable to acquire reset gpio %d\n",
+				sensor->platform_data->xshutdown);
+			rval = -ENODEV;
+			goto out_gpio_request;
+		}
+	}
+
+	rval = smiapp_power_on(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_smiapp_power_on;
+	}
+
+	rval = smiapp_identify_module(subdev);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_power_off;
+	}
+
+	rval = smiapp_get_all_limits(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_power_off;
+	}
+
+	/*
+	 * Handle Sensor Module orientation on the board.
+	 *
+	 * The application of H-FLIP and V-FLIP on the sensor is modified by
+	 * the sensor orientation on the board.
+	 *
+	 * For SMIAPP_BOARD_SENSOR_ORIENT_180 the default behaviour is to set
+	 * both H-FLIP and V-FLIP for normal operation which also implies
+	 * that a set/unset operation for user space HFLIP and VFLIP v4l2
+	 * controls will need to be internally inverted.
+	 *
+	 * Rotation also changes the bayer pattern.
+	 */
+	if (sensor->platform_data->module_board_orient ==
+	    SMIAPP_MODULE_BOARD_ORIENT_180)
+		sensor->hvflip_inv_mask = SMIAPP_IMAGE_ORIENTATION_HFLIP |
+					  SMIAPP_IMAGE_ORIENTATION_VFLIP;
+
+	rval = smiapp_get_mbus_formats(sensor);
+	if (rval) {
+		rval = -ENODEV;
+		goto out_power_off;
+	}
+
+	if (sensor->limits[SMIAPP_LIMIT_BINNING_CAPABILITY]) {
+		u32 val;
+
+		rval = smiapp_read(client,
+				   SMIAPP_REG_U8_BINNING_SUBTYPES, &val);
+		if (rval < 0) {
+			rval = -ENODEV;
+			goto out_power_off;
+		}
+		sensor->nbinning_subtypes = min_t(u8, val,
+						  SMIAPP_BINNING_SUBTYPES);
+
+		for (i = 0; i < sensor->nbinning_subtypes; i++) {
+			rval = smiapp_read(
+				client, SMIAPP_REG_U8_BINNING_TYPE_n(i), &val);
+			if (rval < 0) {
+				rval = -ENODEV;
+				goto out_power_off;
+			}
+			sensor->binning_subtypes[i] =
+				*(struct smiapp_binning_subtype *)&val;
+
+			dev_dbg(&client->dev, "binning %xx%x\n",
+				sensor->binning_subtypes[i].horizontal,
+				sensor->binning_subtypes[i].vertical);
+		}
+	}
+	sensor->binning_horizontal = 1;
+	sensor->binning_vertical = 1;
+
+	/* SMIA++ NVM initialization - it will be read from the sensor
+	 * when it is first requested by userspace.
+	 */
+	if (sensor->minfo.smiapp_version && sensor->platform_data->nvm_size) {
+		sensor->nvm = kzalloc(sensor->platform_data->nvm_size,
+				      GFP_KERNEL);
+		if (sensor->nvm == NULL) {
+			dev_err(&client->dev, "nvm buf allocation failed\n");
+			rval = -ENOMEM;
+			goto out_power_off;
+		}
+
+		if (device_create_file(&client->dev, &dev_attr_nvm) != 0) {
+			dev_err(&client->dev, "sysfs nvm entry failed\n");
+			rval = -EBUSY;
+			goto out_power_off;
+		}
+	}
+
+	rval = smiapp_call_quirk(sensor, limits);
+	if (rval) {
+		dev_err(&client->dev, "limits quirks failed\n");
+		goto out_nvm_release;
+	}
+
+	/* We consider this as profile 0 sensor if any of these are zero. */
+	if (!sensor->limits[SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV] ||
+	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV] ||
+	    !sensor->limits[SMIAPP_LIMIT_MIN_OP_PIX_CLK_DIV] ||
+	    !sensor->limits[SMIAPP_LIMIT_MAX_OP_PIX_CLK_DIV]) {
+		sensor->minfo.smiapp_profile = SMIAPP_PROFILE_0;
+	} else if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
+		   != SMIAPP_SCALING_CAPABILITY_NONE) {
+		if (sensor->limits[SMIAPP_LIMIT_SCALING_CAPABILITY]
+		    == SMIAPP_SCALING_CAPABILITY_HORIZONTAL)
+			sensor->minfo.smiapp_profile = SMIAPP_PROFILE_1;
+		else
+			sensor->minfo.smiapp_profile = SMIAPP_PROFILE_2;
+		sensor->scaler = &sensor->ssds[sensor->ssds_used];
+		sensor->ssds_used++;
+	} else if (sensor->limits[SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY]
+		   == SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP) {
+		sensor->scaler = &sensor->ssds[sensor->ssds_used];
+		sensor->ssds_used++;
+	}
+	sensor->binner = &sensor->ssds[sensor->ssds_used];
+	sensor->ssds_used++;
+	sensor->pixel_array = &sensor->ssds[sensor->ssds_used];
+	sensor->ssds_used++;
+
+	sensor->scale_m = sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN];
+
+	for (i = 0; i < SMIAPP_SUBDEVS; i++) {
+		struct {
+			struct smiapp_subdev *ssd;
+			char *name;
+		} const __this[] = {
+			{ sensor->scaler, "scaler", },
+			{ sensor->binner, "binner", },
+			{ sensor->pixel_array, "pixel array", },
+		}, *_this = &__this[i];
+		struct smiapp_subdev *this = _this->ssd;
+
+		if (!this)
+			continue;
+
+		if (this != sensor->src)
+			v4l2_subdev_init(&this->sd, &smiapp_ops);
+
+		this->sensor = sensor;
+
+		if (this == sensor->pixel_array) {
+			this->npads = 1;
+		} else {
+			this->npads = 2;
+			this->source_pad = 1;
+		}
+
+		snprintf(this->sd.name,
+			 sizeof(this->sd.name), "%s %s",
+			 sensor->minfo.name, _this->name);
+
+		this->sink_fmt.width =
+			sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
+		this->sink_fmt.height =
+			sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+		this->compose.width = this->sink_fmt.width;
+		this->compose.height = this->sink_fmt.height;
+		this->crop[this->source_pad] = this->compose;
+		this->pads[this->source_pad].flags = MEDIA_PAD_FL_SOURCE;
+		if (this != sensor->pixel_array) {
+			this->crop[this->sink_pad] = this->compose;
+			this->pads[this->sink_pad].flags = MEDIA_PAD_FL_SINK;
+		}
+
+		this->sd.entity.ops = &smiapp_entity_ops;
+
+		if (last == NULL) {
+			last = this;
+			continue;
+		}
+
+		this->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+		this->sd.internal_ops = &smiapp_internal_ops;
+		this->sd.owner = NULL;
+		v4l2_set_subdevdata(&this->sd, client);
+
+		rval = media_entity_init(&this->sd.entity,
+					 this->npads, this->pads, 0);
+		if (rval) {
+			dev_err(&client->dev,
+				"media_entity_init failed\n");
+			goto out_nvm_release;
+		}
+
+		rval = media_entity_create_link(&this->sd.entity,
+						this->source_pad,
+						&last->sd.entity,
+						last->sink_pad,
+						MEDIA_LNK_FL_ENABLED |
+						MEDIA_LNK_FL_IMMUTABLE);
+		if (rval) {
+			dev_err(&client->dev,
+				"media_entity_create_link failed\n");
+			goto out_nvm_release;
+		}
+
+		rval = v4l2_device_register_subdev(sensor->src->sd.v4l2_dev,
+						   &this->sd);
+		if (rval) {
+			dev_err(&client->dev,
+				"v4l2_device_register_subdev failed\n");
+			goto out_nvm_release;
+		}
+
+		last = this;
+	}
+
+	dev_dbg(&client->dev, "profile %d\n", sensor->minfo.smiapp_profile);
+
+	sensor->pixel_array->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
+
+	/* final steps */
+	smiapp_read_frame_fmt(sensor);
+	rval = smiapp_init_controls(sensor);
+	if (rval < 0)
+		goto out_nvm_release;
+
+	rval = smiapp_update_mode(sensor);
+	if (rval) {
+		dev_err(&client->dev, "update mode failed\n");
+		goto out_nvm_release;
+	}
+
+	sensor->streaming = false;
+	sensor->dev_init_done = true;
+
+	/* check flash capability */
+	rval = smiapp_read(client, SMIAPP_REG_U8_FLASH_MODE_CAPABILITY, &tmp);
+	sensor->flash_capability = tmp;
+	if (rval)
+		goto out_nvm_release;
+
+	smiapp_power_off(sensor);
+
+	return 0;
+
+out_nvm_release:
+	device_remove_file(&client->dev, &dev_attr_nvm);
+
+out_power_off:
+	kfree(sensor->nvm);
+	sensor->nvm = NULL;
+	smiapp_power_off(sensor);
+
+out_smiapp_power_on:
+	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+		gpio_free(sensor->platform_data->xshutdown);
+
+out_gpio_request:
+	regulator_put(sensor->vana);
+	sensor->vana = NULL;
+	return rval;
+}
+
+static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct smiapp_subdev *ssd = to_smiapp_subdev(sd);
+	struct smiapp_sensor *sensor = ssd->sensor;
+	u32 mbus_code =
+		smiapp_csi_data_formats[smiapp_pixel_order(sensor)].code;
+	unsigned int i;
+
+	mutex_lock(&sensor->mutex);
+
+	for (i = 0; i < ssd->npads; i++) {
+		struct v4l2_mbus_framefmt *try_fmt =
+			v4l2_subdev_get_try_format(fh, i);
+		struct v4l2_rect *try_crop = v4l2_subdev_get_try_crop(fh, i);
+		struct v4l2_rect *try_comp;
+
+		try_fmt->width = sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
+		try_fmt->height = sensor->limits[SMIAPP_LIMIT_Y_ADDR_MAX] + 1;
+		try_fmt->code = mbus_code;
+
+		try_crop->top = 0;
+		try_crop->left = 0;
+		try_crop->width = try_fmt->width;
+		try_crop->height = try_fmt->height;
+
+		if (ssd != sensor->pixel_array)
+			continue;
+
+		try_comp = v4l2_subdev_get_try_compose(fh, i);
+		*try_comp = *try_crop;
+	}
+
+	mutex_unlock(&sensor->mutex);
+
+	return smiapp_set_power(sd, 1);
+}
+
+static int smiapp_close(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	return smiapp_set_power(sd, 0);
+}
+
+static const struct v4l2_subdev_video_ops smiapp_video_ops = {
+	.s_stream = smiapp_set_stream,
+};
+
+static const struct v4l2_subdev_core_ops smiapp_core_ops = {
+	.s_power = smiapp_set_power,
+};
+
+static const struct v4l2_subdev_pad_ops smiapp_pad_ops = {
+	.enum_mbus_code = smiapp_enum_mbus_code,
+	.get_fmt = smiapp_get_format,
+	.set_fmt = smiapp_set_format,
+	.get_selection = smiapp_get_selection,
+	.set_selection = smiapp_set_selection,
+};
+
+static const struct v4l2_subdev_sensor_ops smiapp_sensor_ops = {
+	.g_skip_frames = smiapp_get_skip_frames,
+};
+
+static const struct v4l2_subdev_ops smiapp_ops = {
+	.core = &smiapp_core_ops,
+	.video = &smiapp_video_ops,
+	.pad = &smiapp_pad_ops,
+	.sensor = &smiapp_sensor_ops,
+};
+
+static const struct media_entity_operations smiapp_entity_ops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
+static const struct v4l2_subdev_internal_ops smiapp_internal_src_ops = {
+	.registered = smiapp_registered,
+	.open = smiapp_open,
+	.close = smiapp_close,
+};
+
+static const struct v4l2_subdev_internal_ops smiapp_internal_ops = {
+	.open = smiapp_open,
+	.close = smiapp_close,
+};
+
+/* -----------------------------------------------------------------------------
+ * I2C Driver
+ */
+
+#ifdef CONFIG_PM
+
+static int smiapp_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	bool streaming;
+
+	BUG_ON(mutex_is_locked(&sensor->mutex));
+
+	if (sensor->power_count == 0)
+		return 0;
+
+	if (sensor->streaming)
+		smiapp_stop_streaming(sensor);
+
+	streaming = sensor->streaming;
+
+	smiapp_power_off(sensor);
+
+	/* save state for resume */
+	sensor->streaming = streaming;
+
+	return 0;
+}
+
+static int smiapp_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	int rval;
+
+	if (sensor->power_count == 0)
+		return 0;
+
+	rval = smiapp_power_on(sensor);
+	if (rval)
+		return rval;
+
+	if (sensor->streaming)
+		rval = smiapp_start_streaming(sensor);
+
+	return rval;
+}
+
+#else
+
+#define smiapp_suspend	NULL
+#define smiapp_resume	NULL
+
+#endif /* CONFIG_PM */
+
+static int smiapp_probe(struct i2c_client *client,
+			const struct i2c_device_id *devid)
+{
+	struct smiapp_sensor *sensor;
+	int rval;
+
+	if (client->dev.platform_data == NULL)
+		return -ENODEV;
+
+	sensor = kzalloc(sizeof(*sensor), GFP_KERNEL);
+	if (sensor == NULL)
+		return -ENOMEM;
+
+	sensor->platform_data = client->dev.platform_data;
+	mutex_init(&sensor->mutex);
+	mutex_init(&sensor->power_mutex);
+	sensor->src = &sensor->ssds[sensor->ssds_used];
+
+	v4l2_i2c_subdev_init(&sensor->src->sd, client, &smiapp_ops);
+	sensor->src->sd.internal_ops = &smiapp_internal_src_ops;
+	sensor->src->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+	sensor->src->sensor = sensor;
+
+	sensor->src->pads[0].flags = MEDIA_PAD_FL_SOURCE;
+	rval = media_entity_init(&sensor->src->sd.entity, 2,
+				 sensor->src->pads, 0);
+	if (rval < 0)
+		kfree(sensor);
+
+	return rval;
+}
+
+static int __exit smiapp_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
+	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
+	unsigned int i;
+
+	if (sensor->power_count) {
+		if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+			gpio_set_value(sensor->platform_data->xshutdown, 0);
+		sensor->platform_data->set_xclk(&sensor->src->sd, 0);
+		sensor->power_count = 0;
+	}
+
+	if (sensor->nvm) {
+		device_remove_file(&client->dev, &dev_attr_nvm);
+		kfree(sensor->nvm);
+	}
+
+	for (i = 0; i < sensor->ssds_used; i++) {
+		media_entity_cleanup(&sensor->ssds[i].sd.entity);
+		v4l2_device_unregister_subdev(&sensor->ssds[i].sd);
+	}
+	smiapp_free_controls(sensor);
+	if (sensor->platform_data->xshutdown != SMIAPP_NO_XSHUTDOWN)
+		gpio_free(sensor->platform_data->xshutdown);
+	if (sensor->vana)
+		regulator_put(sensor->vana);
+
+	kfree(sensor);
+
+	return 0;
+}
+
+static const struct i2c_device_id smiapp_id_table[] = {
+	{ SMIAPP_NAME, 0 },
+	{ },
+};
+MODULE_DEVICE_TABLE(i2c, smiapp_id_table);
+
+static const struct dev_pm_ops smiapp_pm_ops = {
+	.suspend	= smiapp_suspend,
+	.resume		= smiapp_resume,
+};
+
+static struct i2c_driver smiapp_i2c_driver = {
+	.driver	= {
+		.name = SMIAPP_NAME,
+		.pm = &smiapp_pm_ops,
+	},
+	.probe	= smiapp_probe,
+	.remove	= __exit_p(smiapp_remove),
+	.id_table = smiapp_id_table,
+};
+
+module_i2c_driver(smiapp_i2c_driver);
+
+MODULE_AUTHOR("Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>");
+MODULE_DESCRIPTION("Generic SMIA/SMIA++ camera module driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/media/video/smiapp/smiapp-debug.h b/drivers/media/video/smiapp/smiapp-debug.h
new file mode 100644
index 0000000..627809e
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-debug.h
@@ -0,0 +1,32 @@
+/*
+ * drivers/media/video/smiapp/smiapp-debug.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef SMIAPP_DEBUG_H
+#define SMIAPP_DEBUG_H
+
+#ifdef CONFIG_VIDEO_SMIAPP_DEBUG
+#define DEBUG
+#endif
+
+#endif
diff --git a/drivers/media/video/smiapp/smiapp-limits.c b/drivers/media/video/smiapp/smiapp-limits.c
new file mode 100644
index 0000000..0800e09
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-limits.c
@@ -0,0 +1,132 @@
+/*
+ * drivers/media/video/smiapp/smiapp-limits.c
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "smiapp.h"
+
+struct smiapp_reg_limits smiapp_reg_limits[] = {
+	{ SMIAPP_REG_U16_ANALOGUE_GAIN_CAPABILITY, "analogue_gain_capability" }, /* 0 */
+	{ SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_MIN, "analogue_gain_code_min" },
+	{ SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_MAX, "analogue_gain_code_max" },
+	{ SMIAPP_REG_U8_THS_ZERO_MIN, "ths_zero_min" },
+	{ SMIAPP_REG_U8_TCLK_TRAIL_MIN, "tclk_trail_min" },
+	{ SMIAPP_REG_U16_INTEGRATION_TIME_CAPABILITY, "integration_time_capability" }, /* 5 */
+	{ SMIAPP_REG_U16_COARSE_INTEGRATION_TIME_MIN, "coarse_integration_time_min" },
+	{ SMIAPP_REG_U16_COARSE_INTEGRATION_TIME_MAX_MARGIN, "coarse_integration_time_max_margin" },
+	{ SMIAPP_REG_U16_FINE_INTEGRATION_TIME_MIN, "fine_integration_time_min" },
+	{ SMIAPP_REG_U16_FINE_INTEGRATION_TIME_MAX_MARGIN, "fine_integration_time_max_margin" },
+	{ SMIAPP_REG_U16_DIGITAL_GAIN_CAPABILITY, "digital_gain_capability" }, /* 10 */
+	{ SMIAPP_REG_U16_DIGITAL_GAIN_MIN, "digital_gain_min" },
+	{ SMIAPP_REG_U16_DIGITAL_GAIN_MAX, "digital_gain_max" },
+	{ SMIAPP_REG_F32_MIN_EXT_CLK_FREQ_HZ, "min_ext_clk_freq_hz" },
+	{ SMIAPP_REG_F32_MAX_EXT_CLK_FREQ_HZ, "max_ext_clk_freq_hz" },
+	{ SMIAPP_REG_U16_MIN_PRE_PLL_CLK_DIV, "min_pre_pll_clk_div" }, /* 15 */
+	{ SMIAPP_REG_U16_MAX_PRE_PLL_CLK_DIV, "max_pre_pll_clk_div" },
+	{ SMIAPP_REG_F32_MIN_PLL_IP_FREQ_HZ, "min_pll_ip_freq_hz" },
+	{ SMIAPP_REG_F32_MAX_PLL_IP_FREQ_HZ, "max_pll_ip_freq_hz" },
+	{ SMIAPP_REG_U16_MIN_PLL_MULTIPLIER, "min_pll_multiplier" },
+	{ SMIAPP_REG_U16_MAX_PLL_MULTIPLIER, "max_pll_multiplier" }, /* 20 */
+	{ SMIAPP_REG_F32_MIN_PLL_OP_FREQ_HZ, "min_pll_op_freq_hz" },
+	{ SMIAPP_REG_F32_MAX_PLL_OP_FREQ_HZ, "max_pll_op_freq_hz" },
+	{ SMIAPP_REG_U16_MIN_VT_SYS_CLK_DIV, "min_vt_sys_clk_div" },
+	{ SMIAPP_REG_U16_MAX_VT_SYS_CLK_DIV, "max_vt_sys_clk_div" },
+	{ SMIAPP_REG_F32_MIN_VT_SYS_CLK_FREQ_HZ, "min_vt_sys_clk_freq_hz" }, /* 25 */
+	{ SMIAPP_REG_F32_MAX_VT_SYS_CLK_FREQ_HZ, "max_vt_sys_clk_freq_hz" },
+	{ SMIAPP_REG_F32_MIN_VT_PIX_CLK_FREQ_HZ, "min_vt_pix_clk_freq_hz" },
+	{ SMIAPP_REG_F32_MAX_VT_PIX_CLK_FREQ_HZ, "max_vt_pix_clk_freq_hz" },
+	{ SMIAPP_REG_U16_MIN_VT_PIX_CLK_DIV, "min_vt_pix_clk_div" },
+	{ SMIAPP_REG_U16_MAX_VT_PIX_CLK_DIV, "max_vt_pix_clk_div" }, /* 30 */
+	{ SMIAPP_REG_U16_MIN_FRAME_LENGTH_LINES, "min_frame_length_lines" },
+	{ SMIAPP_REG_U16_MAX_FRAME_LENGTH_LINES, "max_frame_length_lines" },
+	{ SMIAPP_REG_U16_MIN_LINE_LENGTH_PCK, "min_line_length_pck" },
+	{ SMIAPP_REG_U16_MAX_LINE_LENGTH_PCK, "max_line_length_pck" },
+	{ SMIAPP_REG_U16_MIN_LINE_BLANKING_PCK, "min_line_blanking_pck" }, /* 35 */
+	{ SMIAPP_REG_U16_MIN_FRAME_BLANKING_LINES, "min_frame_blanking_lines" },
+	{ SMIAPP_REG_U8_MIN_LINE_LENGTH_PCK_STEP_SIZE, "min_line_length_pck_step_size" },
+	{ SMIAPP_REG_U16_MIN_OP_SYS_CLK_DIV, "min_op_sys_clk_div" },
+	{ SMIAPP_REG_U16_MAX_OP_SYS_CLK_DIV, "max_op_sys_clk_div" },
+	{ SMIAPP_REG_F32_MIN_OP_SYS_CLK_FREQ_HZ, "min_op_sys_clk_freq_hz" }, /* 40 */
+	{ SMIAPP_REG_F32_MAX_OP_SYS_CLK_FREQ_HZ, "max_op_sys_clk_freq_hz" },
+	{ SMIAPP_REG_U16_MIN_OP_PIX_CLK_DIV, "min_op_pix_clk_div" },
+	{ SMIAPP_REG_U16_MAX_OP_PIX_CLK_DIV, "max_op_pix_clk_div" },
+	{ SMIAPP_REG_F32_MIN_OP_PIX_CLK_FREQ_HZ, "min_op_pix_clk_freq_hz" },
+	{ SMIAPP_REG_F32_MAX_OP_PIX_CLK_FREQ_HZ, "max_op_pix_clk_freq_hz" }, /* 45 */
+	{ SMIAPP_REG_U16_X_ADDR_MIN, "x_addr_min" },
+	{ SMIAPP_REG_U16_Y_ADDR_MIN, "y_addr_min" },
+	{ SMIAPP_REG_U16_X_ADDR_MAX, "x_addr_max" },
+	{ SMIAPP_REG_U16_Y_ADDR_MAX, "y_addr_max" },
+	{ SMIAPP_REG_U16_MIN_X_OUTPUT_SIZE, "min_x_output_size" }, /* 50 */
+	{ SMIAPP_REG_U16_MIN_Y_OUTPUT_SIZE, "min_y_output_size" },
+	{ SMIAPP_REG_U16_MAX_X_OUTPUT_SIZE, "max_x_output_size" },
+	{ SMIAPP_REG_U16_MAX_Y_OUTPUT_SIZE, "max_y_output_size" },
+	{ SMIAPP_REG_U16_MIN_EVEN_INC, "min_even_inc" },
+	{ SMIAPP_REG_U16_MAX_EVEN_INC, "max_even_inc" }, /* 55 */
+	{ SMIAPP_REG_U16_MIN_ODD_INC, "min_odd_inc" },
+	{ SMIAPP_REG_U16_MAX_ODD_INC, "max_odd_inc" },
+	{ SMIAPP_REG_U16_SCALING_CAPABILITY, "scaling_capability" },
+	{ SMIAPP_REG_U16_SCALER_M_MIN, "scaler_m_min" },
+	{ SMIAPP_REG_U16_SCALER_M_MAX, "scaler_m_max" }, /* 60 */
+	{ SMIAPP_REG_U16_SCALER_N_MIN, "scaler_n_min" },
+	{ SMIAPP_REG_U16_SCALER_N_MAX, "scaler_n_max" },
+	{ SMIAPP_REG_U16_SPATIAL_SAMPLING_CAPABILITY, "spatial_sampling_capability" },
+	{ SMIAPP_REG_U8_DIGITAL_CROP_CAPABILITY, "digital_crop_capability" },
+	{ SMIAPP_REG_U16_COMPRESSION_CAPABILITY, "compression_capability" }, /* 65 */
+	{ SMIAPP_REG_U8_FIFO_SUPPORT_CAPABILITY, "fifo_support_capability" },
+	{ SMIAPP_REG_U8_DPHY_CTRL_CAPABILITY, "dphy_ctrl_capability" },
+	{ SMIAPP_REG_U8_CSI_LANE_MODE_CAPABILITY, "csi_lane_mode_capability" },
+	{ SMIAPP_REG_U8_CSI_SIGNALLING_MODE_CAPABILITY, "csi_signalling_mode_capability" },
+	{ SMIAPP_REG_U8_FAST_STANDBY_CAPABILITY, "fast_standby_capability" }, /* 70 */
+	{ SMIAPP_REG_U8_CCI_ADDRESS_CONTROL_CAPABILITY, "cci_address_control_capability" },
+	{ SMIAPP_REG_U32_MAX_PER_LANE_BITRATE_1_LANE_MODE_MBPS, "max_per_lane_bitrate_1_lane_mode_mbps" },
+	{ SMIAPP_REG_U32_MAX_PER_LANE_BITRATE_2_LANE_MODE_MBPS, "max_per_lane_bitrate_2_lane_mode_mbps" },
+	{ SMIAPP_REG_U32_MAX_PER_LANE_BITRATE_3_LANE_MODE_MBPS, "max_per_lane_bitrate_3_lane_mode_mbps" },
+	{ SMIAPP_REG_U32_MAX_PER_LANE_BITRATE_4_LANE_MODE_MBPS, "max_per_lane_bitrate_4_lane_mode_mbps" }, /* 75 */
+	{ SMIAPP_REG_U8_TEMP_SENSOR_CAPABILITY, "temp_sensor_capability" },
+	{ SMIAPP_REG_U16_MIN_FRAME_LENGTH_LINES_BIN, "min_frame_length_lines_bin" },
+	{ SMIAPP_REG_U16_MAX_FRAME_LENGTH_LINES_BIN, "max_frame_length_lines_bin" },
+	{ SMIAPP_REG_U16_MIN_LINE_LENGTH_PCK_BIN, "min_line_length_pck_bin" },
+	{ SMIAPP_REG_U16_MAX_LINE_LENGTH_PCK_BIN, "max_line_length_pck_bin" }, /* 80 */
+	{ SMIAPP_REG_U16_MIN_LINE_BLANKING_PCK_BIN, "min_line_blanking_pck_bin" },
+	{ SMIAPP_REG_U16_FINE_INTEGRATION_TIME_MIN_BIN, "fine_integration_time_min_bin" },
+	{ SMIAPP_REG_U16_FINE_INTEGRATION_TIME_MAX_MARGIN_BIN, "fine_integration_time_max_margin_bin" },
+	{ SMIAPP_REG_U8_BINNING_CAPABILITY, "binning_capability" },
+	{ SMIAPP_REG_U8_BINNING_WEIGHTING_CAPABILITY, "binning_weighting_capability" }, /* 85 */
+	{ SMIAPP_REG_U8_DATA_TRANSFER_IF_CAPABILITY, "data_transfer_if_capability" },
+	{ SMIAPP_REG_U8_SHADING_CORRECTION_CAPABILITY, "shading_correction_capability" },
+	{ SMIAPP_REG_U8_GREEN_IMBALANCE_CAPABILITY, "green_imbalance_capability" },
+	{ SMIAPP_REG_U8_BLACK_LEVEL_CAPABILITY, "black_level_capability" },
+	{ SMIAPP_REG_U8_MODULE_SPECIFIC_CORRECTION_CAPABILITY, "module_specific_correction_capability" }, /* 90 */
+	{ SMIAPP_REG_U16_DEFECT_CORRECTION_CAPABILITY, "defect_correction_capability" },
+	{ SMIAPP_REG_U16_DEFECT_CORRECTION_CAPABILITY_2, "defect_correction_capability_2" },
+	{ SMIAPP_REG_U8_EDOF_CAPABILITY, "edof_capability" },
+	{ SMIAPP_REG_U8_COLOUR_FEEDBACK_CAPABILITY, "colour_feedback_capability" },
+	{ SMIAPP_REG_U8_ESTIMATION_MODE_CAPABILITY, "estimation_mode_capability" }, /* 95 */
+	{ SMIAPP_REG_U8_ESTIMATION_ZONE_CAPABILITY, "estimation_zone_capability" },
+	{ SMIAPP_REG_U16_CAPABILITY_TRDY_MIN, "capability_trdy_min" },
+	{ SMIAPP_REG_U8_FLASH_MODE_CAPABILITY, "flash_mode_capability" },
+	{ SMIAPP_REG_U8_ACTUATOR_CAPABILITY, "actuator_capability" },
+	{ SMIAPP_REG_U8_BRACKETING_LUT_CAPABILITY_1, "bracketing_lut_capability_1" }, /* 100 */
+	{ SMIAPP_REG_U8_BRACKETING_LUT_CAPABILITY_2, "bracketing_lut_capability_2" },
+	{ SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_STEP, "analogue_gain_code_step" },
+	{ 0, NULL },
+};
diff --git a/drivers/media/video/smiapp/smiapp-limits.h b/drivers/media/video/smiapp/smiapp-limits.h
new file mode 100644
index 0000000..7f4836bb
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-limits.h
@@ -0,0 +1,128 @@
+/*
+ * drivers/media/video/smiapp/smiapp-limits.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#define SMIAPP_LIMIT_ANALOGUE_GAIN_CAPABILITY			0
+#define SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MIN			1
+#define SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MAX			2
+#define SMIAPP_LIMIT_THS_ZERO_MIN				3
+#define SMIAPP_LIMIT_TCLK_TRAIL_MIN				4
+#define SMIAPP_LIMIT_INTEGRATION_TIME_CAPABILITY		5
+#define SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MIN		6
+#define SMIAPP_LIMIT_COARSE_INTEGRATION_TIME_MAX_MARGIN		7
+#define SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MIN			8
+#define SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MAX_MARGIN		9
+#define SMIAPP_LIMIT_DIGITAL_GAIN_CAPABILITY			10
+#define SMIAPP_LIMIT_DIGITAL_GAIN_MIN				11
+#define SMIAPP_LIMIT_DIGITAL_GAIN_MAX				12
+#define SMIAPP_LIMIT_MIN_EXT_CLK_FREQ_HZ			13
+#define SMIAPP_LIMIT_MAX_EXT_CLK_FREQ_HZ			14
+#define SMIAPP_LIMIT_MIN_PRE_PLL_CLK_DIV			15
+#define SMIAPP_LIMIT_MAX_PRE_PLL_CLK_DIV			16
+#define SMIAPP_LIMIT_MIN_PLL_IP_FREQ_HZ				17
+#define SMIAPP_LIMIT_MAX_PLL_IP_FREQ_HZ				18
+#define SMIAPP_LIMIT_MIN_PLL_MULTIPLIER				19
+#define SMIAPP_LIMIT_MAX_PLL_MULTIPLIER				20
+#define SMIAPP_LIMIT_MIN_PLL_OP_FREQ_HZ				21
+#define SMIAPP_LIMIT_MAX_PLL_OP_FREQ_HZ				22
+#define SMIAPP_LIMIT_MIN_VT_SYS_CLK_DIV				23
+#define SMIAPP_LIMIT_MAX_VT_SYS_CLK_DIV				24
+#define SMIAPP_LIMIT_MIN_VT_SYS_CLK_FREQ_HZ			25
+#define SMIAPP_LIMIT_MAX_VT_SYS_CLK_FREQ_HZ			26
+#define SMIAPP_LIMIT_MIN_VT_PIX_CLK_FREQ_HZ			27
+#define SMIAPP_LIMIT_MAX_VT_PIX_CLK_FREQ_HZ			28
+#define SMIAPP_LIMIT_MIN_VT_PIX_CLK_DIV				29
+#define SMIAPP_LIMIT_MAX_VT_PIX_CLK_DIV				30
+#define SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES			31
+#define SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES			32
+#define SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK			33
+#define SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK			34
+#define SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK			35
+#define SMIAPP_LIMIT_MIN_FRAME_BLANKING_LINES			36
+#define SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_STEP_SIZE		37
+#define SMIAPP_LIMIT_MIN_OP_SYS_CLK_DIV				38
+#define SMIAPP_LIMIT_MAX_OP_SYS_CLK_DIV				39
+#define SMIAPP_LIMIT_MIN_OP_SYS_CLK_FREQ_HZ			40
+#define SMIAPP_LIMIT_MAX_OP_SYS_CLK_FREQ_HZ			41
+#define SMIAPP_LIMIT_MIN_OP_PIX_CLK_DIV				42
+#define SMIAPP_LIMIT_MAX_OP_PIX_CLK_DIV				43
+#define SMIAPP_LIMIT_MIN_OP_PIX_CLK_FREQ_HZ			44
+#define SMIAPP_LIMIT_MAX_OP_PIX_CLK_FREQ_HZ			45
+#define SMIAPP_LIMIT_X_ADDR_MIN					46
+#define SMIAPP_LIMIT_Y_ADDR_MIN					47
+#define SMIAPP_LIMIT_X_ADDR_MAX					48
+#define SMIAPP_LIMIT_Y_ADDR_MAX					49
+#define SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE				50
+#define SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE				51
+#define SMIAPP_LIMIT_MAX_X_OUTPUT_SIZE				52
+#define SMIAPP_LIMIT_MAX_Y_OUTPUT_SIZE				53
+#define SMIAPP_LIMIT_MIN_EVEN_INC				54
+#define SMIAPP_LIMIT_MAX_EVEN_INC				55
+#define SMIAPP_LIMIT_MIN_ODD_INC				56
+#define SMIAPP_LIMIT_MAX_ODD_INC				57
+#define SMIAPP_LIMIT_SCALING_CAPABILITY				58
+#define SMIAPP_LIMIT_SCALER_M_MIN				59
+#define SMIAPP_LIMIT_SCALER_M_MAX				60
+#define SMIAPP_LIMIT_SCALER_N_MIN				61
+#define SMIAPP_LIMIT_SCALER_N_MAX				62
+#define SMIAPP_LIMIT_SPATIAL_SAMPLING_CAPABILITY		63
+#define SMIAPP_LIMIT_DIGITAL_CROP_CAPABILITY			64
+#define SMIAPP_LIMIT_COMPRESSION_CAPABILITY			65
+#define SMIAPP_LIMIT_FIFO_SUPPORT_CAPABILITY			66
+#define SMIAPP_LIMIT_DPHY_CTRL_CAPABILITY			67
+#define SMIAPP_LIMIT_CSI_LANE_MODE_CAPABILITY			68
+#define SMIAPP_LIMIT_CSI_SIGNALLING_MODE_CAPABILITY		69
+#define SMIAPP_LIMIT_FAST_STANDBY_CAPABILITY			70
+#define SMIAPP_LIMIT_CCI_ADDRESS_CONTROL_CAPABILITY		71
+#define SMIAPP_LIMIT_MAX_PER_LANE_BITRATE_1_LANE_MODE_MBPS	72
+#define SMIAPP_LIMIT_MAX_PER_LANE_BITRATE_2_LANE_MODE_MBPS	73
+#define SMIAPP_LIMIT_MAX_PER_LANE_BITRATE_3_LANE_MODE_MBPS	74
+#define SMIAPP_LIMIT_MAX_PER_LANE_BITRATE_4_LANE_MODE_MBPS	75
+#define SMIAPP_LIMIT_TEMP_SENSOR_CAPABILITY			76
+#define SMIAPP_LIMIT_MIN_FRAME_LENGTH_LINES_BIN			77
+#define SMIAPP_LIMIT_MAX_FRAME_LENGTH_LINES_BIN			78
+#define SMIAPP_LIMIT_MIN_LINE_LENGTH_PCK_BIN			79
+#define SMIAPP_LIMIT_MAX_LINE_LENGTH_PCK_BIN			80
+#define SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN			81
+#define SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MIN_BIN		82
+#define SMIAPP_LIMIT_FINE_INTEGRATION_TIME_MAX_MARGIN_BIN	83
+#define SMIAPP_LIMIT_BINNING_CAPABILITY				84
+#define SMIAPP_LIMIT_BINNING_WEIGHTING_CAPABILITY		85
+#define SMIAPP_LIMIT_DATA_TRANSFER_IF_CAPABILITY		86
+#define SMIAPP_LIMIT_SHADING_CORRECTION_CAPABILITY		87
+#define SMIAPP_LIMIT_GREEN_IMBALANCE_CAPABILITY			88
+#define SMIAPP_LIMIT_BLACK_LEVEL_CAPABILITY			89
+#define SMIAPP_LIMIT_MODULE_SPECIFIC_CORRECTION_CAPABILITY	90
+#define SMIAPP_LIMIT_DEFECT_CORRECTION_CAPABILITY		91
+#define SMIAPP_LIMIT_DEFECT_CORRECTION_CAPABILITY_2		92
+#define SMIAPP_LIMIT_EDOF_CAPABILITY				93
+#define SMIAPP_LIMIT_COLOUR_FEEDBACK_CAPABILITY			94
+#define SMIAPP_LIMIT_ESTIMATION_MODE_CAPABILITY			95
+#define SMIAPP_LIMIT_ESTIMATION_ZONE_CAPABILITY			96
+#define SMIAPP_LIMIT_CAPABILITY_TRDY_MIN			97
+#define SMIAPP_LIMIT_FLASH_MODE_CAPABILITY			98
+#define SMIAPP_LIMIT_ACTUATOR_CAPABILITY			99
+#define SMIAPP_LIMIT_BRACKETING_LUT_CAPABILITY_1		100
+#define SMIAPP_LIMIT_BRACKETING_LUT_CAPABILITY_2		101
+#define SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_STEP			102
+#define SMIAPP_LIMIT_LAST					103
diff --git a/drivers/media/video/smiapp/smiapp-quirk.c b/drivers/media/video/smiapp/smiapp-quirk.c
new file mode 100644
index 0000000..dae85a1
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-quirk.c
@@ -0,0 +1,264 @@
+/*
+ * drivers/media/video/smiapp/smiapp-quirk.c
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "smiapp-debug.h"
+
+#include <linux/delay.h>
+
+#include "smiapp.h"
+
+static int smiapp_write_8(struct smiapp_sensor *sensor, u16 reg, u8 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+
+	return smiapp_write(client, (SMIA_REG_8BIT << 16) | reg, val);
+}
+
+static int smiapp_write_8s(struct smiapp_sensor *sensor,
+			   struct smiapp_reg_8 *regs, int len)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	int rval;
+
+	for (; len > 0; len--, regs++) {
+		rval = smiapp_write_8(sensor, regs->reg, regs->val);
+		if (rval < 0) {
+			dev_err(&client->dev,
+				"error %d writing reg 0x%4.4x, val 0x%2.2x",
+				rval, regs->reg, regs->val);
+			return rval;
+		}
+	}
+
+	return 0;
+}
+
+void smiapp_replace_limit(struct smiapp_sensor *sensor,
+			  u32 limit, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+
+	dev_dbg(&client->dev, "quirk: 0x%8.8x \"%s\" = %d, 0x%x\n",
+		smiapp_reg_limits[limit].addr,
+		smiapp_reg_limits[limit].what, val, val);
+	sensor->limits[limit] = val;
+}
+
+int smiapp_replace_limit_at(struct smiapp_sensor *sensor,
+			    u32 reg, u32 val)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	int i;
+
+	for (i = 0; smiapp_reg_limits[i].addr; i++) {
+		if ((smiapp_reg_limits[i].addr & 0xffff) != reg)
+			continue;
+
+		smiapp_replace_limit(sensor, i, val);
+
+		return 0;
+	}
+
+	dev_dbg(&client->dev, "quirk: bad register 0x%4.4x\n", reg);
+
+	return -EINVAL;
+}
+
+static int jt8ew9_limits(struct smiapp_sensor *sensor)
+{
+	if (sensor->minfo.revision_number_major < 0x03)
+		sensor->frame_skip = 1;
+
+	/* Below 24 gain doesn't have effect at all, */
+	/* but ~59 is needed for full dynamic range */
+	smiapp_replace_limit(sensor, SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MIN, 59);
+	smiapp_replace_limit(
+		sensor, SMIAPP_LIMIT_ANALOGUE_GAIN_CODE_MAX, 6000);
+
+	return 0;
+}
+
+static int jt8ew9_post_poweron(struct smiapp_sensor *sensor)
+{
+	struct smiapp_reg_8 regs[] = {
+		{ 0x30a3, 0xd8 }, /* Output port control : LVDS ports only */
+		{ 0x30ae, 0x00 }, /* 0x0307 pll_multiplier maximum value on PLL input 9.6MHz ( 19.2MHz is divided on pre_pll_div) */
+		{ 0x30af, 0xd0 }, /* 0x0307 pll_multiplier maximum value on PLL input 9.6MHz ( 19.2MHz is divided on pre_pll_div) */
+		{ 0x322d, 0x04 }, /* Adjusting Processing Image Size to Scaler Toshiba Recommendation Setting */
+		{ 0x3255, 0x0f }, /* Horizontal Noise Reduction Control Toshiba Recommendation Setting */
+		{ 0x3256, 0x15 }, /* Horizontal Noise Reduction Control Toshiba Recommendation Setting */
+		{ 0x3258, 0x70 }, /* Analog Gain Control Toshiba Recommendation Setting */
+		{ 0x3259, 0x70 }, /* Analog Gain Control Toshiba Recommendation Setting */
+		{ 0x325f, 0x7c }, /* Analog Gain Control Toshiba Recommendation Setting */
+		{ 0x3302, 0x06 }, /* Pixel Reference Voltage Control Toshiba Recommendation Setting */
+		{ 0x3304, 0x00 }, /* Pixel Reference Voltage Control Toshiba Recommendation Setting */
+		{ 0x3307, 0x22 }, /* Pixel Reference Voltage Control Toshiba Recommendation Setting */
+		{ 0x3308, 0x8d }, /* Pixel Reference Voltage Control Toshiba Recommendation Setting */
+		{ 0x331e, 0x0f }, /* Black Hole Sun Correction Control Toshiba Recommendation Setting */
+		{ 0x3320, 0x30 }, /* Black Hole Sun Correction Control Toshiba Recommendation Setting */
+		{ 0x3321, 0x11 }, /* Black Hole Sun Correction Control Toshiba Recommendation Setting */
+		{ 0x3322, 0x98 }, /* Black Hole Sun Correction Control Toshiba Recommendation Setting */
+		{ 0x3323, 0x64 }, /* Black Hole Sun Correction Control Toshiba Recommendation Setting */
+		{ 0x3325, 0x83 }, /* Read Out Timing Control Toshiba Recommendation Setting */
+		{ 0x3330, 0x18 }, /* Read Out Timing Control Toshiba Recommendation Setting */
+		{ 0x333c, 0x01 }, /* Read Out Timing Control Toshiba Recommendation Setting */
+		{ 0x3345, 0x2f }, /* Black Hole Sun Correction Control Toshiba Recommendation Setting */
+		{ 0x33de, 0x38 }, /* Horizontal Noise Reduction Control Toshiba Recommendation Setting */
+		/* Taken from v03. No idea what the rest are. */
+		{ 0x32e0, 0x05 },
+		{ 0x32e1, 0x05 },
+		{ 0x32e2, 0x04 },
+		{ 0x32e5, 0x04 },
+		{ 0x32e6, 0x04 },
+
+	};
+
+	return smiapp_write_8s(sensor, regs, ARRAY_SIZE(regs));
+}
+
+const struct smiapp_quirk smiapp_jt8ew9_quirk = {
+	.limits = jt8ew9_limits,
+	.post_poweron = jt8ew9_post_poweron,
+};
+
+static int imx125es_post_poweron(struct smiapp_sensor *sensor)
+{
+	/* Taken from v02. No idea what the other two are. */
+	struct smiapp_reg_8 regs[] = {
+		/*
+		 * 0x3302: clk during frame blanking:
+		 * 0x00 - HS mode, 0x01 - LP11
+		 */
+		{ 0x3302, 0x01 },
+		{ 0x302d, 0x00 },
+		{ 0x3b08, 0x8c },
+	};
+
+	return smiapp_write_8s(sensor, regs, ARRAY_SIZE(regs));
+}
+
+const struct smiapp_quirk smiapp_imx125es_quirk = {
+	.post_poweron = imx125es_post_poweron,
+};
+
+static int jt8ev1_limits(struct smiapp_sensor *sensor)
+{
+	smiapp_replace_limit(sensor, SMIAPP_LIMIT_X_ADDR_MAX, 4271);
+	smiapp_replace_limit(sensor,
+			     SMIAPP_LIMIT_MIN_LINE_BLANKING_PCK_BIN, 184);
+
+	return 0;
+}
+
+static int jt8ev1_post_poweron(struct smiapp_sensor *sensor)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(&sensor->src->sd);
+	int rval;
+
+	struct smiapp_reg_8 regs[] = {
+		{ 0x3031, 0xcd }, /* For digital binning (EQ_MONI) */
+		{ 0x30a3, 0xd0 }, /* FLASH STROBE enable */
+		{ 0x3237, 0x00 }, /* For control of pulse timing for ADC */
+		{ 0x3238, 0x43 },
+		{ 0x3301, 0x06 }, /* For analog bias for sensor */
+		{ 0x3302, 0x06 },
+		{ 0x3304, 0x00 },
+		{ 0x3305, 0x88 },
+		{ 0x332a, 0x14 },
+		{ 0x332c, 0x6b },
+		{ 0x3336, 0x01 },
+		{ 0x333f, 0x1f },
+		{ 0x3355, 0x00 },
+		{ 0x3356, 0x20 },
+		{ 0x33bf, 0x20 }, /* Adjust the FBC speed */
+		{ 0x33c9, 0x20 },
+		{ 0x33ce, 0x30 }, /* Adjust the parameter for logic function */
+		{ 0x33cf, 0xec }, /* For Black sun */
+		{ 0x3328, 0x80 }, /* Ugh. No idea what's this. */
+	};
+
+	struct smiapp_reg_8 regs_96[] = {
+		{ 0x30ae, 0x00 }, /* For control of ADC clock */
+		{ 0x30af, 0xd0 },
+		{ 0x30b0, 0x01 },
+	};
+
+	rval = smiapp_write_8s(sensor, regs, ARRAY_SIZE(regs));
+	if (rval < 0)
+		return rval;
+
+	switch (sensor->platform_data->ext_clk) {
+	case 9600000:
+		return smiapp_write_8s(sensor, regs_96,
+				       ARRAY_SIZE(regs_96));
+	default:
+		dev_warn(&client->dev, "no MSRs for %d Hz ext_clk\n",
+			 sensor->platform_data->ext_clk);
+		return 0;
+	}
+}
+
+static int jt8ev1_pre_streamon(struct smiapp_sensor *sensor)
+{
+	return smiapp_write_8(sensor, 0x3328, 0x00);
+}
+
+static int jt8ev1_post_streamoff(struct smiapp_sensor *sensor)
+{
+	int rval;
+
+	/* Workaround: allows fast standby to work properly */
+	rval = smiapp_write_8(sensor, 0x3205, 0x04);
+	if (rval < 0)
+		return rval;
+
+	/* Wait for 1 ms + one line => 2 ms is likely enough */
+	usleep_range(2000, 2000);
+
+	/* Restore it */
+	rval = smiapp_write_8(sensor, 0x3205, 0x00);
+	if (rval < 0)
+		return rval;
+
+	return smiapp_write_8(sensor, 0x3328, 0x80);
+}
+
+const struct smiapp_quirk smiapp_jt8ev1_quirk = {
+	.limits = jt8ev1_limits,
+	.post_poweron = jt8ev1_post_poweron,
+	.pre_streamon = jt8ev1_pre_streamon,
+	.post_streamoff = jt8ev1_post_streamoff,
+	.flags = SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE,
+};
+
+static int tcm8500md_limits(struct smiapp_sensor *sensor)
+{
+	smiapp_replace_limit(sensor, SMIAPP_LIMIT_MIN_PLL_IP_FREQ_HZ, 2700000);
+
+	return 0;
+}
+
+const struct smiapp_quirk smiapp_tcm8500md_quirk = {
+	.limits = tcm8500md_limits,
+};
diff --git a/drivers/media/video/smiapp/smiapp-quirk.h b/drivers/media/video/smiapp/smiapp-quirk.h
new file mode 100644
index 0000000..7a1b3a0
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-quirk.h
@@ -0,0 +1,72 @@
+/*
+ * drivers/media/video/smiapp/smiapp-quirk.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __SMIAPP_QUIRK__
+#define __SMIAPP_QUIRK__
+
+struct smiapp_sensor;
+
+/**
+ * struct smiapp_quirk - quirks for sensors that deviate from SMIA++ standard
+ *
+ * @limits: Replace sensor->limits with values which can't be read from
+ *	    sensor registers. Called the first time the sensor is powered up.
+ * @post_poweron: Called always after the sensor has been fully powered on.
+ * @pre_streamon: Called just before streaming is enabled.
+ * @post_streamon: Called right after stopping streaming.
+ */
+struct smiapp_quirk {
+	int (*limits)(struct smiapp_sensor *sensor);
+	int (*post_poweron)(struct smiapp_sensor *sensor);
+	int (*pre_streamon)(struct smiapp_sensor *sensor);
+	int (*post_streamoff)(struct smiapp_sensor *sensor);
+	unsigned long flags;
+};
+
+/* op pix clock is for all lanes in total normally */
+#define SMIAPP_QUIRK_FLAG_OP_PIX_CLOCK_PER_LANE			(1 << 0)
+
+struct smiapp_reg_8 {
+	u16 reg;
+	u8 val;
+};
+
+void smiapp_replace_limit(struct smiapp_sensor *sensor,
+			  u32 limit, u32 val);
+
+#define smiapp_call_quirk(_sensor, _quirk, ...)				\
+	(_sensor->minfo.quirk &&					\
+	 _sensor->minfo.quirk->_quirk ?					\
+	 _sensor->minfo.quirk->_quirk(_sensor, ##__VA_ARGS__) : 0)
+
+#define smiapp_needs_quirk(_sensor, _quirk)		\
+	(_sensor->minfo.quirk ?				\
+	 _sensor->minfo.quirk->flags & _quirk : 0)
+
+extern const struct smiapp_quirk smiapp_jt8ev1_quirk;
+extern const struct smiapp_quirk smiapp_imx125es_quirk;
+extern const struct smiapp_quirk smiapp_jt8ew9_quirk;
+extern const struct smiapp_quirk smiapp_tcm8500md_quirk;
+
+#endif /* __SMIAPP_QUIRK__ */
diff --git a/drivers/media/video/smiapp/smiapp-reg-defs.h b/drivers/media/video/smiapp/smiapp-reg-defs.h
new file mode 100644
index 0000000..a089eb8
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-reg-defs.h
@@ -0,0 +1,503 @@
+/*
+ * drivers/media/video/smiapp/smiapp-reg-defs.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+#define SMIAPP_REG_MK_U8(r) ((SMIA_REG_8BIT << 16) | (r))
+#define SMIAPP_REG_MK_U16(r) ((SMIA_REG_16BIT << 16) | (r))
+#define SMIAPP_REG_MK_U32(r) ((SMIA_REG_32BIT << 16) | (r))
+
+#define SMIAPP_REG_MK_F32(r) (SMIA_REG_FLAG_FLOAT | (SMIA_REG_32BIT << 16) | (r))
+
+#define SMIAPP_REG_U16_MODEL_ID					SMIAPP_REG_MK_U16(0x0000)
+#define SMIAPP_REG_U8_REVISION_NUMBER_MAJOR			SMIAPP_REG_MK_U8(0x0002)
+#define SMIAPP_REG_U8_MANUFACTURER_ID				SMIAPP_REG_MK_U8(0x0003)
+#define SMIAPP_REG_U8_SMIA_VERSION				SMIAPP_REG_MK_U8(0x0004)
+#define SMIAPP_REG_U8_FRAME_COUNT				SMIAPP_REG_MK_U8(0x0005)
+#define SMIAPP_REG_U8_PIXEL_ORDER				SMIAPP_REG_MK_U8(0x0006)
+#define SMIAPP_REG_U16_DATA_PEDESTAL				SMIAPP_REG_MK_U16(0x0008)
+#define SMIAPP_REG_U8_PIXEL_DEPTH				SMIAPP_REG_MK_U8(0x000c)
+#define SMIAPP_REG_U8_REVISION_NUMBER_MINOR			SMIAPP_REG_MK_U8(0x0010)
+#define SMIAPP_REG_U8_SMIAPP_VERSION				SMIAPP_REG_MK_U8(0x0011)
+#define SMIAPP_REG_U8_MODULE_DATE_YEAR				SMIAPP_REG_MK_U8(0x0012)
+#define SMIAPP_REG_U8_MODULE_DATE_MONTH				SMIAPP_REG_MK_U8(0x0013)
+#define SMIAPP_REG_U8_MODULE_DATE_DAY				SMIAPP_REG_MK_U8(0x0014)
+#define SMIAPP_REG_U8_MODULE_DATE_PHASE				SMIAPP_REG_MK_U8(0x0015)
+#define SMIAPP_REG_U16_SENSOR_MODEL_ID				SMIAPP_REG_MK_U16(0x0016)
+#define SMIAPP_REG_U8_SENSOR_REVISION_NUMBER			SMIAPP_REG_MK_U8(0x0018)
+#define SMIAPP_REG_U8_SENSOR_MANUFACTURER_ID			SMIAPP_REG_MK_U8(0x0019)
+#define SMIAPP_REG_U8_SENSOR_FIRMWARE_VERSION			SMIAPP_REG_MK_U8(0x001a)
+#define SMIAPP_REG_U32_SERIAL_NUMBER				SMIAPP_REG_MK_U32(0x001c)
+#define SMIAPP_REG_U8_FRAME_FORMAT_MODEL_TYPE			SMIAPP_REG_MK_U8(0x0040)
+#define SMIAPP_REG_U8_FRAME_FORMAT_MODEL_SUBTYPE		SMIAPP_REG_MK_U8(0x0041)
+#define SMIAPP_REG_U16_FRAME_FORMAT_DESCRIPTOR_2(n)		SMIAPP_REG_MK_U16(0x0042 + ((n) << 1)) /* 0 <= n <= 14 */
+#define SMIAPP_REG_U32_FRAME_FORMAT_DESCRIPTOR_4(n)		SMIAPP_REG_MK_U32(0x0060 + ((n) << 2)) /* 0 <= n <= 7 */
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CAPABILITY			SMIAPP_REG_MK_U16(0x0080)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_MIN			SMIAPP_REG_MK_U16(0x0084)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_MAX			SMIAPP_REG_MK_U16(0x0086)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_STEP			SMIAPP_REG_MK_U16(0x0088)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_TYPE			SMIAPP_REG_MK_U16(0x008a)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_M0				SMIAPP_REG_MK_U16(0x008c)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_C0				SMIAPP_REG_MK_U16(0x008e)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_M1				SMIAPP_REG_MK_U16(0x0090)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_C1				SMIAPP_REG_MK_U16(0x0092)
+#define SMIAPP_REG_U8_DATA_FORMAT_MODEL_TYPE			SMIAPP_REG_MK_U8(0x00c0)
+#define SMIAPP_REG_U8_DATA_FORMAT_MODEL_SUBTYPE			SMIAPP_REG_MK_U8(0x00c1)
+#define SMIAPP_REG_U16_DATA_FORMAT_DESCRIPTOR(n)		SMIAPP_REG_MK_U16(0x00c2 + ((n) << 1))
+#define SMIAPP_REG_U8_MODE_SELECT				SMIAPP_REG_MK_U8(0x0100)
+#define SMIAPP_REG_U8_IMAGE_ORIENTATION				SMIAPP_REG_MK_U8(0x0101)
+#define SMIAPP_REG_U8_SOFTWARE_RESET				SMIAPP_REG_MK_U8(0x0103)
+#define SMIAPP_REG_U8_GROUPED_PARAMETER_HOLD			SMIAPP_REG_MK_U8(0x0104)
+#define SMIAPP_REG_U8_MASK_CORRUPTED_FRAMES			SMIAPP_REG_MK_U8(0x0105)
+#define SMIAPP_REG_U8_FAST_STANDBY_CTRL				SMIAPP_REG_MK_U8(0x0106)
+#define SMIAPP_REG_U8_CCI_ADDRESS_CONTROL			SMIAPP_REG_MK_U8(0x0107)
+#define SMIAPP_REG_U8_2ND_CCI_IF_CONTROL			SMIAPP_REG_MK_U8(0x0108)
+#define SMIAPP_REG_U8_2ND_CCI_ADDRESS_CONTROL			SMIAPP_REG_MK_U8(0x0109)
+#define SMIAPP_REG_U8_CSI_CHANNEL_IDENTIFIER			SMIAPP_REG_MK_U8(0x0110)
+#define SMIAPP_REG_U8_CSI_SIGNALLING_MODE			SMIAPP_REG_MK_U8(0x0111)
+#define SMIAPP_REG_U16_CSI_DATA_FORMAT				SMIAPP_REG_MK_U16(0x0112)
+#define SMIAPP_REG_U8_CSI_LANE_MODE				SMIAPP_REG_MK_U8(0x0114)
+#define SMIAPP_REG_U8_CSI2_10_TO_8_DT				SMIAPP_REG_MK_U8(0x0115)
+#define SMIAPP_REG_U8_CSI2_10_TO_7_DT				SMIAPP_REG_MK_U8(0x0116)
+#define SMIAPP_REG_U8_CSI2_10_TO_6_DT				SMIAPP_REG_MK_U8(0x0117)
+#define SMIAPP_REG_U8_CSI2_12_TO_8_DT				SMIAPP_REG_MK_U8(0x0118)
+#define SMIAPP_REG_U8_CSI2_12_TO_7_DT				SMIAPP_REG_MK_U8(0x0119)
+#define SMIAPP_REG_U8_CSI2_12_TO_6_DT				SMIAPP_REG_MK_U8(0x011a)
+#define SMIAPP_REG_U8_CSI2_14_TO_10_DT				SMIAPP_REG_MK_U8(0x011b)
+#define SMIAPP_REG_U8_CSI2_14_TO_8_DT				SMIAPP_REG_MK_U8(0x011c)
+#define SMIAPP_REG_U8_CSI2_16_TO_10_DT				SMIAPP_REG_MK_U8(0x011d)
+#define SMIAPP_REG_U8_CSI2_16_TO_8_DT				SMIAPP_REG_MK_U8(0x011e)
+#define SMIAPP_REG_U8_GAIN_MODE					SMIAPP_REG_MK_U8(0x0120)
+#define SMIAPP_REG_U16_VANA_VOLTAGE				SMIAPP_REG_MK_U16(0x0130)
+#define SMIAPP_REG_U16_VDIG_VOLTAGE				SMIAPP_REG_MK_U16(0x0132)
+#define SMIAPP_REG_U16_VIO_VOLTAGE				SMIAPP_REG_MK_U16(0x0134)
+#define SMIAPP_REG_U16_EXTCLK_FREQUENCY_MHZ			SMIAPP_REG_MK_U16(0x0136)
+#define SMIAPP_REG_U8_TEMP_SENSOR_CONTROL			SMIAPP_REG_MK_U8(0x0138)
+#define SMIAPP_REG_U8_TEMP_SENSOR_MODE				SMIAPP_REG_MK_U8(0x0139)
+#define SMIAPP_REG_U8_TEMP_SENSOR_OUTPUT			SMIAPP_REG_MK_U8(0x013a)
+#define SMIAPP_REG_U16_FINE_INTEGRATION_TIME			SMIAPP_REG_MK_U16(0x0200)
+#define SMIAPP_REG_U16_COARSE_INTEGRATION_TIME			SMIAPP_REG_MK_U16(0x0202)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_GLOBAL		SMIAPP_REG_MK_U16(0x0204)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_GREENR		SMIAPP_REG_MK_U16(0x0206)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_RED			SMIAPP_REG_MK_U16(0x0208)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_BLUE			SMIAPP_REG_MK_U16(0x020a)
+#define SMIAPP_REG_U16_ANALOGUE_GAIN_CODE_GREENB		SMIAPP_REG_MK_U16(0x020c)
+#define SMIAPP_REG_U16_DIGITAL_GAIN_GREENR			SMIAPP_REG_MK_U16(0x020e)
+#define SMIAPP_REG_U16_DIGITAL_GAIN_RED				SMIAPP_REG_MK_U16(0x0210)
+#define SMIAPP_REG_U16_DIGITAL_GAIN_BLUE			SMIAPP_REG_MK_U16(0x0212)
+#define SMIAPP_REG_U16_DIGITAL_GAIN_GREENB			SMIAPP_REG_MK_U16(0x0214)
+#define SMIAPP_REG_U16_VT_PIX_CLK_DIV				SMIAPP_REG_MK_U16(0x0300)
+#define SMIAPP_REG_U16_VT_SYS_CLK_DIV				SMIAPP_REG_MK_U16(0x0302)
+#define SMIAPP_REG_U16_PRE_PLL_CLK_DIV				SMIAPP_REG_MK_U16(0x0304)
+#define SMIAPP_REG_U16_PLL_MULTIPLIER				SMIAPP_REG_MK_U16(0x0306)
+#define SMIAPP_REG_U16_OP_PIX_CLK_DIV				SMIAPP_REG_MK_U16(0x0308)
+#define SMIAPP_REG_U16_OP_SYS_CLK_DIV				SMIAPP_REG_MK_U16(0x030a)
+#define SMIAPP_REG_U16_FRAME_LENGTH_LINES			SMIAPP_REG_MK_U16(0x0340)
+#define SMIAPP_REG_U16_LINE_LENGTH_PCK				SMIAPP_REG_MK_U16(0x0342)
+#define SMIAPP_REG_U16_X_ADDR_START				SMIAPP_REG_MK_U16(0x0344)
+#define SMIAPP_REG_U16_Y_ADDR_START				SMIAPP_REG_MK_U16(0x0346)
+#define SMIAPP_REG_U16_X_ADDR_END				SMIAPP_REG_MK_U16(0x0348)
+#define SMIAPP_REG_U16_Y_ADDR_END				SMIAPP_REG_MK_U16(0x034a)
+#define SMIAPP_REG_U16_X_OUTPUT_SIZE				SMIAPP_REG_MK_U16(0x034c)
+#define SMIAPP_REG_U16_Y_OUTPUT_SIZE				SMIAPP_REG_MK_U16(0x034e)
+#define SMIAPP_REG_U16_X_EVEN_INC				SMIAPP_REG_MK_U16(0x0380)
+#define SMIAPP_REG_U16_X_ODD_INC				SMIAPP_REG_MK_U16(0x0382)
+#define SMIAPP_REG_U16_Y_EVEN_INC				SMIAPP_REG_MK_U16(0x0384)
+#define SMIAPP_REG_U16_Y_ODD_INC				SMIAPP_REG_MK_U16(0x0386)
+#define SMIAPP_REG_U16_SCALING_MODE				SMIAPP_REG_MK_U16(0x0400)
+#define SMIAPP_REG_U16_SPATIAL_SAMPLING				SMIAPP_REG_MK_U16(0x0402)
+#define SMIAPP_REG_U16_SCALE_M					SMIAPP_REG_MK_U16(0x0404)
+#define SMIAPP_REG_U16_SCALE_N					SMIAPP_REG_MK_U16(0x0406)
+#define SMIAPP_REG_U16_DIGITAL_CROP_X_OFFSET			SMIAPP_REG_MK_U16(0x0408)
+#define SMIAPP_REG_U16_DIGITAL_CROP_Y_OFFSET			SMIAPP_REG_MK_U16(0x040a)
+#define SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_WIDTH			SMIAPP_REG_MK_U16(0x040c)
+#define SMIAPP_REG_U16_DIGITAL_CROP_IMAGE_HEIGHT		SMIAPP_REG_MK_U16(0x040e)
+#define SMIAPP_REG_U16_COMPRESSION_MODE				SMIAPP_REG_MK_U16(0x0500)
+#define SMIAPP_REG_U16_TEST_PATTERN_MODE			SMIAPP_REG_MK_U16(0x0600)
+#define SMIAPP_REG_U16_TEST_DATA_RED				SMIAPP_REG_MK_U16(0x0602)
+#define SMIAPP_REG_U16_TEST_DATA_GREENR				SMIAPP_REG_MK_U16(0x0604)
+#define SMIAPP_REG_U16_TEST_DATA_BLUE				SMIAPP_REG_MK_U16(0x0606)
+#define SMIAPP_REG_U16_TEST_DATA_GREENB				SMIAPP_REG_MK_U16(0x0608)
+#define SMIAPP_REG_U16_HORIZONTAL_CURSOR_WIDTH			SMIAPP_REG_MK_U16(0x060a)
+#define SMIAPP_REG_U16_HORIZONTAL_CURSOR_POSITION		SMIAPP_REG_MK_U16(0x060c)
+#define SMIAPP_REG_U16_VERTICAL_CURSOR_WIDTH			SMIAPP_REG_MK_U16(0x060e)
+#define SMIAPP_REG_U16_VERTICAL_CURSOR_POSITION			SMIAPP_REG_MK_U16(0x0610)
+#define SMIAPP_REG_U16_FIFO_WATER_MARK_PIXELS			SMIAPP_REG_MK_U16(0x0700)
+#define SMIAPP_REG_U8_TCLK_POST					SMIAPP_REG_MK_U8(0x0800)
+#define SMIAPP_REG_U8_THS_PREPARE				SMIAPP_REG_MK_U8(0x0801)
+#define SMIAPP_REG_U8_THS_ZERO_MIN				SMIAPP_REG_MK_U8(0x0802)
+#define SMIAPP_REG_U8_THS_TRAIL					SMIAPP_REG_MK_U8(0x0803)
+#define SMIAPP_REG_U8_TCLK_TRAIL_MIN				SMIAPP_REG_MK_U8(0x0804)
+#define SMIAPP_REG_U8_TCLK_PREPARE				SMIAPP_REG_MK_U8(0x0805)
+#define SMIAPP_REG_U8_TCLK_ZERO					SMIAPP_REG_MK_U8(0x0806)
+#define SMIAPP_REG_U8_TLPX					SMIAPP_REG_MK_U8(0x0807)
+#define SMIAPP_REG_U8_DPHY_CTRL					SMIAPP_REG_MK_U8(0x0808)
+#define SMIAPP_REG_U32_REQUESTED_LINK_BIT_RATE_MBPS		SMIAPP_REG_MK_U32(0x0820)
+#define SMIAPP_REG_U8_BINNING_MODE				SMIAPP_REG_MK_U8(0x0900)
+#define SMIAPP_REG_U8_BINNING_TYPE				SMIAPP_REG_MK_U8(0x0901)
+#define SMIAPP_REG_U8_BINNING_WEIGHTING				SMIAPP_REG_MK_U8(0x0902)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_CTRL			SMIAPP_REG_MK_U8(0x0a00)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_STATUS			SMIAPP_REG_MK_U8(0x0a01)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_PAGE_SELECT		SMIAPP_REG_MK_U8(0x0a02)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_0			SMIAPP_REG_MK_U8(0x0a04)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_1			SMIAPP_REG_MK_U8(0x0a05)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_2			SMIAPP_REG_MK_U8(0x0a06)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_3			SMIAPP_REG_MK_U8(0x0a07)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_4			SMIAPP_REG_MK_U8(0x0a08)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_5			SMIAPP_REG_MK_U8(0x0a09)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_12		SMIAPP_REG_MK_U8(0x0a10)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_13		SMIAPP_REG_MK_U8(0x0a11)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_14		SMIAPP_REG_MK_U8(0x0a12)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_15		SMIAPP_REG_MK_U8(0x0a13)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_16		SMIAPP_REG_MK_U8(0x0a14)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_17		SMIAPP_REG_MK_U8(0x0a15)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_18		SMIAPP_REG_MK_U8(0x0a16)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_19		SMIAPP_REG_MK_U8(0x0a17)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_20		SMIAPP_REG_MK_U8(0x0a18)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_21		SMIAPP_REG_MK_U8(0x0a19)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_22		SMIAPP_REG_MK_U8(0x0a1a)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_23		SMIAPP_REG_MK_U8(0x0a1b)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_24		SMIAPP_REG_MK_U8(0x0a1c)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_25		SMIAPP_REG_MK_U8(0x0a1d)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_26		SMIAPP_REG_MK_U8(0x0a1e)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_27		SMIAPP_REG_MK_U8(0x0a1f)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_28		SMIAPP_REG_MK_U8(0x0a20)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_29		SMIAPP_REG_MK_U8(0x0a21)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_30		SMIAPP_REG_MK_U8(0x0a22)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_31		SMIAPP_REG_MK_U8(0x0a23)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_32		SMIAPP_REG_MK_U8(0x0a24)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_33		SMIAPP_REG_MK_U8(0x0a25)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_34		SMIAPP_REG_MK_U8(0x0a26)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_35		SMIAPP_REG_MK_U8(0x0a27)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_36		SMIAPP_REG_MK_U8(0x0a28)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_37		SMIAPP_REG_MK_U8(0x0a29)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_38		SMIAPP_REG_MK_U8(0x0a2a)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_39		SMIAPP_REG_MK_U8(0x0a2b)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_40		SMIAPP_REG_MK_U8(0x0a2c)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_41		SMIAPP_REG_MK_U8(0x0a2d)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_42		SMIAPP_REG_MK_U8(0x0a2e)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_43		SMIAPP_REG_MK_U8(0x0a2f)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_44		SMIAPP_REG_MK_U8(0x0a30)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_45		SMIAPP_REG_MK_U8(0x0a31)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_46		SMIAPP_REG_MK_U8(0x0a32)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_47		SMIAPP_REG_MK_U8(0x0a33)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_48		SMIAPP_REG_MK_U8(0x0a34)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_49		SMIAPP_REG_MK_U8(0x0a35)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_50		SMIAPP_REG_MK_U8(0x0a36)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_51		SMIAPP_REG_MK_U8(0x0a37)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_52		SMIAPP_REG_MK_U8(0x0a38)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_53		SMIAPP_REG_MK_U8(0x0a39)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_54		SMIAPP_REG_MK_U8(0x0a3a)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_55		SMIAPP_REG_MK_U8(0x0a3b)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_56		SMIAPP_REG_MK_U8(0x0a3c)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_57		SMIAPP_REG_MK_U8(0x0a3d)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_58		SMIAPP_REG_MK_U8(0x0a3e)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_59		SMIAPP_REG_MK_U8(0x0a3f)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_60		SMIAPP_REG_MK_U8(0x0a40)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_61		SMIAPP_REG_MK_U8(0x0a41)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_62		SMIAPP_REG_MK_U8(0x0a42)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_1_DATA_63		SMIAPP_REG_MK_U8(0x0a43)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_CTRL			SMIAPP_REG_MK_U8(0x0a44)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_STATUS			SMIAPP_REG_MK_U8(0x0a45)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_PAGE_SELECT		SMIAPP_REG_MK_U8(0x0a46)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_0			SMIAPP_REG_MK_U8(0x0a48)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_1			SMIAPP_REG_MK_U8(0x0a49)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_2			SMIAPP_REG_MK_U8(0x0a4a)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_3			SMIAPP_REG_MK_U8(0x0a4b)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_4			SMIAPP_REG_MK_U8(0x0a4c)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_5			SMIAPP_REG_MK_U8(0x0a4d)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_6			SMIAPP_REG_MK_U8(0x0a4e)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_7			SMIAPP_REG_MK_U8(0x0a4f)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_8			SMIAPP_REG_MK_U8(0x0a50)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_9			SMIAPP_REG_MK_U8(0x0a51)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_10		SMIAPP_REG_MK_U8(0x0a52)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_11		SMIAPP_REG_MK_U8(0x0a53)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_12		SMIAPP_REG_MK_U8(0x0a54)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_13		SMIAPP_REG_MK_U8(0x0a55)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_14		SMIAPP_REG_MK_U8(0x0a56)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_15		SMIAPP_REG_MK_U8(0x0a57)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_16		SMIAPP_REG_MK_U8(0x0a58)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_17		SMIAPP_REG_MK_U8(0x0a59)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_18		SMIAPP_REG_MK_U8(0x0a5a)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_19		SMIAPP_REG_MK_U8(0x0a5b)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_20		SMIAPP_REG_MK_U8(0x0a5c)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_21		SMIAPP_REG_MK_U8(0x0a5d)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_22		SMIAPP_REG_MK_U8(0x0a5e)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_23		SMIAPP_REG_MK_U8(0x0a5f)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_24		SMIAPP_REG_MK_U8(0x0a60)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_25		SMIAPP_REG_MK_U8(0x0a61)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_26		SMIAPP_REG_MK_U8(0x0a62)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_27		SMIAPP_REG_MK_U8(0x0a63)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_28		SMIAPP_REG_MK_U8(0x0a64)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_29		SMIAPP_REG_MK_U8(0x0a65)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_30		SMIAPP_REG_MK_U8(0x0a66)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_31		SMIAPP_REG_MK_U8(0x0a67)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_32		SMIAPP_REG_MK_U8(0x0a68)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_33		SMIAPP_REG_MK_U8(0x0a69)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_34		SMIAPP_REG_MK_U8(0x0a6a)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_35		SMIAPP_REG_MK_U8(0x0a6b)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_36		SMIAPP_REG_MK_U8(0x0a6c)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_37		SMIAPP_REG_MK_U8(0x0a6d)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_38		SMIAPP_REG_MK_U8(0x0a6e)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_39		SMIAPP_REG_MK_U8(0x0a6f)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_40		SMIAPP_REG_MK_U8(0x0a70)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_41		SMIAPP_REG_MK_U8(0x0a71)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_42		SMIAPP_REG_MK_U8(0x0a72)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_43		SMIAPP_REG_MK_U8(0x0a73)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_44		SMIAPP_REG_MK_U8(0x0a74)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_45		SMIAPP_REG_MK_U8(0x0a75)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_46		SMIAPP_REG_MK_U8(0x0a76)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_47		SMIAPP_REG_MK_U8(0x0a77)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_48		SMIAPP_REG_MK_U8(0x0a78)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_49		SMIAPP_REG_MK_U8(0x0a79)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_50		SMIAPP_REG_MK_U8(0x0a7a)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_51		SMIAPP_REG_MK_U8(0x0a7b)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_52		SMIAPP_REG_MK_U8(0x0a7c)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_53		SMIAPP_REG_MK_U8(0x0a7d)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_54		SMIAPP_REG_MK_U8(0x0a7e)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_55		SMIAPP_REG_MK_U8(0x0a7f)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_56		SMIAPP_REG_MK_U8(0x0a80)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_57		SMIAPP_REG_MK_U8(0x0a81)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_58		SMIAPP_REG_MK_U8(0x0a82)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_59		SMIAPP_REG_MK_U8(0x0a83)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_60		SMIAPP_REG_MK_U8(0x0a84)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_61		SMIAPP_REG_MK_U8(0x0a85)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_62		SMIAPP_REG_MK_U8(0x0a86)
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_2_DATA_63		SMIAPP_REG_MK_U8(0x0a87)
+#define SMIAPP_REG_U8_SHADING_CORRECTION_ENABLE			SMIAPP_REG_MK_U8(0x0b00)
+#define SMIAPP_REG_U8_LUMINANCE_CORRECTION_LEVEL		SMIAPP_REG_MK_U8(0x0b01)
+#define SMIAPP_REG_U8_GREEN_IMBALANCE_FILTER_ENABLE		SMIAPP_REG_MK_U8(0x0b02)
+#define SMIAPP_REG_U8_GREEN_IMBALANCE_FILTER_WEIGHT		SMIAPP_REG_MK_U8(0x0b03)
+#define SMIAPP_REG_U8_BLACK_LEVEL_CORRECTION_ENABLE		SMIAPP_REG_MK_U8(0x0b04)
+#define SMIAPP_REG_U8_MAPPED_COUPLET_CORRECT_ENABLE		SMIAPP_REG_MK_U8(0x0b05)
+#define SMIAPP_REG_U8_SINGLE_DEFECT_CORRECT_ENABLE		SMIAPP_REG_MK_U8(0x0b06)
+#define SMIAPP_REG_U8_SINGLE_DEFECT_CORRECT_WEIGHT		SMIAPP_REG_MK_U8(0x0b07)
+#define SMIAPP_REG_U8_DYNAMIC_COUPLET_CORRECT_ENABLE		SMIAPP_REG_MK_U8(0x0b08)
+#define SMIAPP_REG_U8_DYNAMIC_COUPLET_CORRECT_WEIGHT		SMIAPP_REG_MK_U8(0x0b09)
+#define SMIAPP_REG_U8_COMBINED_DEFECT_CORRECT_ENABLE		SMIAPP_REG_MK_U8(0x0b0a)
+#define SMIAPP_REG_U8_COMBINED_DEFECT_CORRECT_WEIGHT		SMIAPP_REG_MK_U8(0x0b0b)
+#define SMIAPP_REG_U8_MODULE_SPECIFIC_CORRECTION_ENABLE		SMIAPP_REG_MK_U8(0x0b0c)
+#define SMIAPP_REG_U8_MODULE_SPECIFIC_CORRECTION_WEIGHT		SMIAPP_REG_MK_U8(0x0b0d)
+#define SMIAPP_REG_U8_MAPPED_LINE_DEFECT_CORRECT_ENABLE		SMIAPP_REG_MK_U8(0x0b0e)
+#define SMIAPP_REG_U8_MAPPED_LINE_DEFECT_CORRECT_ADJUST		SMIAPP_REG_MK_U8(0x0b0f)
+#define SMIAPP_REG_U8_MAPPED_COUPLET_CORRECT_ADJUST		SMIAPP_REG_MK_U8(0x0b10)
+#define SMIAPP_REG_U8_MAPPED_TRIPLET_DEFECT_CORRECT_ENABLE	SMIAPP_REG_MK_U8(0x0b11)
+#define SMIAPP_REG_U8_MAPPED_TRIPLET_DEFECT_CORRECT_ADJUST	SMIAPP_REG_MK_U8(0x0b12)
+#define SMIAPP_REG_U8_DYNAMIC_TRIPLET_DEFECT_CORRECT_ENABLE	SMIAPP_REG_MK_U8(0x0b13)
+#define SMIAPP_REG_U8_DYNAMIC_TRIPLET_DEFECT_CORRECT_ADJUST	SMIAPP_REG_MK_U8(0x0b14)
+#define SMIAPP_REG_U8_DYNAMIC_LINE_DEFECT_CORRECT_ENABLE	SMIAPP_REG_MK_U8(0x0b15)
+#define SMIAPP_REG_U8_DYNAMIC_LINE_DEFECT_CORRECT_ADJUST	SMIAPP_REG_MK_U8(0x0b16)
+#define SMIAPP_REG_U8_EDOF_MODE					SMIAPP_REG_MK_U8(0x0b80)
+#define SMIAPP_REG_U8_SHARPNESS					SMIAPP_REG_MK_U8(0x0b83)
+#define SMIAPP_REG_U8_DENOISING					SMIAPP_REG_MK_U8(0x0b84)
+#define SMIAPP_REG_U8_MODULE_SPECIFIC				SMIAPP_REG_MK_U8(0x0b85)
+#define SMIAPP_REG_U16_DEPTH_OF_FIELD				SMIAPP_REG_MK_U16(0x0b86)
+#define SMIAPP_REG_U16_FOCUS_DISTANCE				SMIAPP_REG_MK_U16(0x0b88)
+#define SMIAPP_REG_U8_ESTIMATION_MODE_CTRL			SMIAPP_REG_MK_U8(0x0b8a)
+#define SMIAPP_REG_U16_COLOUR_TEMPERATURE			SMIAPP_REG_MK_U16(0x0b8c)
+#define SMIAPP_REG_U16_ABSOLUTE_GAIN_GREENR			SMIAPP_REG_MK_U16(0x0b8e)
+#define SMIAPP_REG_U16_ABSOLUTE_GAIN_RED			SMIAPP_REG_MK_U16(0x0b90)
+#define SMIAPP_REG_U16_ABSOLUTE_GAIN_BLUE			SMIAPP_REG_MK_U16(0x0b92)
+#define SMIAPP_REG_U16_ABSOLUTE_GAIN_GREENB			SMIAPP_REG_MK_U16(0x0b94)
+#define SMIAPP_REG_U8_ESTIMATION_ZONE_MODE			SMIAPP_REG_MK_U8(0x0bc0)
+#define SMIAPP_REG_U16_FIXED_ZONE_WEIGHTING			SMIAPP_REG_MK_U16(0x0bc2)
+#define SMIAPP_REG_U16_CUSTOM_ZONE_X_START			SMIAPP_REG_MK_U16(0x0bc4)
+#define SMIAPP_REG_U16_CUSTOM_ZONE_Y_START			SMIAPP_REG_MK_U16(0x0bc6)
+#define SMIAPP_REG_U16_CUSTOM_ZONE_WIDTH			SMIAPP_REG_MK_U16(0x0bc8)
+#define SMIAPP_REG_U16_CUSTOM_ZONE_HEIGHT			SMIAPP_REG_MK_U16(0x0bca)
+#define SMIAPP_REG_U8_GLOBAL_RESET_CTRL1			SMIAPP_REG_MK_U8(0x0c00)
+#define SMIAPP_REG_U8_GLOBAL_RESET_CTRL2			SMIAPP_REG_MK_U8(0x0c01)
+#define SMIAPP_REG_U8_GLOBAL_RESET_MODE_CONFIG_1		SMIAPP_REG_MK_U8(0x0c02)
+#define SMIAPP_REG_U8_GLOBAL_RESET_MODE_CONFIG_2		SMIAPP_REG_MK_U8(0x0c03)
+#define SMIAPP_REG_U16_TRDY_CTRL				SMIAPP_REG_MK_U16(0x0c04)
+#define SMIAPP_REG_U16_TRDOUT_CTRL				SMIAPP_REG_MK_U16(0x0c06)
+#define SMIAPP_REG_U16_TSHUTTER_STROBE_DELAY_CTRL		SMIAPP_REG_MK_U16(0x0c08)
+#define SMIAPP_REG_U16_TSHUTTER_STROBE_WIDTH_CTRL		SMIAPP_REG_MK_U16(0x0c0a)
+#define SMIAPP_REG_U16_TFLASH_STROBE_DELAY_CTRL			SMIAPP_REG_MK_U16(0x0c0c)
+#define SMIAPP_REG_U16_TFLASH_STROBE_WIDTH_HIGH_CTRL		SMIAPP_REG_MK_U16(0x0c0e)
+#define SMIAPP_REG_U16_TGRST_INTERVAL_CTRL			SMIAPP_REG_MK_U16(0x0c10)
+#define SMIAPP_REG_U8_FLASH_STROBE_ADJUSTMENT			SMIAPP_REG_MK_U8(0x0c12)
+#define SMIAPP_REG_U16_FLASH_STROBE_START_POINT			SMIAPP_REG_MK_U16(0x0c14)
+#define SMIAPP_REG_U16_TFLASH_STROBE_DELAY_RS_CTRL		SMIAPP_REG_MK_U16(0x0c16)
+#define SMIAPP_REG_U16_TFLASH_STROBE_WIDTH_HIGH_RS_CTRL		SMIAPP_REG_MK_U16(0x0c18)
+#define SMIAPP_REG_U8_FLASH_MODE_RS				SMIAPP_REG_MK_U8(0x0c1a)
+#define SMIAPP_REG_U8_FLASH_TRIGGER_RS				SMIAPP_REG_MK_U8(0x0c1b)
+#define SMIAPP_REG_U8_FLASH_STATUS				SMIAPP_REG_MK_U8(0x0c1c)
+#define SMIAPP_REG_U8_SA_STROBE_MODE				SMIAPP_REG_MK_U8(0x0c1d)
+#define SMIAPP_REG_U16_SA_STROBE_START_POINT			SMIAPP_REG_MK_U16(0x0c1e)
+#define SMIAPP_REG_U16_TSA_STROBE_DELAY_CTRL			SMIAPP_REG_MK_U16(0x0c20)
+#define SMIAPP_REG_U16_TSA_STROBE_WIDTH_CTRL			SMIAPP_REG_MK_U16(0x0c22)
+#define SMIAPP_REG_U8_SA_STROBE_TRIGGER				SMIAPP_REG_MK_U8(0x0c24)
+#define SMIAPP_REG_U8_SPECIAL_ACTUATOR_STATUS			SMIAPP_REG_MK_U8(0x0c25)
+#define SMIAPP_REG_U16_TFLASH_STROBE_WIDTH2_HIGH_RS_CTRL	SMIAPP_REG_MK_U16(0x0c26)
+#define SMIAPP_REG_U16_TFLASH_STROBE_WIDTH_LOW_RS_CTRL		SMIAPP_REG_MK_U16(0x0c28)
+#define SMIAPP_REG_U8_TFLASH_STROBE_COUNT_RS_CTRL		SMIAPP_REG_MK_U8(0x0c2a)
+#define SMIAPP_REG_U8_TFLASH_STROBE_COUNT_CTRL			SMIAPP_REG_MK_U8(0x0c2b)
+#define SMIAPP_REG_U16_TFLASH_STROBE_WIDTH2_HIGH_CTRL		SMIAPP_REG_MK_U16(0x0c2c)
+#define SMIAPP_REG_U16_TFLASH_STROBE_WIDTH_LOW_CTRL		SMIAPP_REG_MK_U16(0x0c2e)
+#define SMIAPP_REG_U8_LOW_LEVEL_CTRL				SMIAPP_REG_MK_U8(0x0c80)
+#define SMIAPP_REG_U16_MAIN_TRIGGER_REF_POINT			SMIAPP_REG_MK_U16(0x0c82)
+#define SMIAPP_REG_U16_MAIN_TRIGGER_T3				SMIAPP_REG_MK_U16(0x0c84)
+#define SMIAPP_REG_U8_MAIN_TRIGGER_COUNT			SMIAPP_REG_MK_U8(0x0c86)
+#define SMIAPP_REG_U16_PHASE1_TRIGGER_T3			SMIAPP_REG_MK_U16(0x0c88)
+#define SMIAPP_REG_U8_PHASE1_TRIGGER_COUNT			SMIAPP_REG_MK_U8(0x0c8a)
+#define SMIAPP_REG_U16_PHASE2_TRIGGER_T3			SMIAPP_REG_MK_U16(0x0c8c)
+#define SMIAPP_REG_U8_PHASE2_TRIGGER_COUNT			SMIAPP_REG_MK_U8(0x0c8e)
+#define SMIAPP_REG_U8_MECH_SHUTTER_CTRL				SMIAPP_REG_MK_U8(0x0d00)
+#define SMIAPP_REG_U8_OPERATION_MODE				SMIAPP_REG_MK_U8(0x0d01)
+#define SMIAPP_REG_U8_ACT_STATE1				SMIAPP_REG_MK_U8(0x0d02)
+#define SMIAPP_REG_U8_ACT_STATE2				SMIAPP_REG_MK_U8(0x0d03)
+#define SMIAPP_REG_U16_FOCUS_CHANGE				SMIAPP_REG_MK_U16(0x0d80)
+#define SMIAPP_REG_U16_FOCUS_CHANGE_CONTROL			SMIAPP_REG_MK_U16(0x0d82)
+#define SMIAPP_REG_U16_FOCUS_CHANGE_NUMBER_PHASE1		SMIAPP_REG_MK_U16(0x0d84)
+#define SMIAPP_REG_U16_FOCUS_CHANGE_NUMBER_PHASE2		SMIAPP_REG_MK_U16(0x0d86)
+#define SMIAPP_REG_U8_STROBE_COUNT_PHASE1			SMIAPP_REG_MK_U8(0x0d88)
+#define SMIAPP_REG_U8_STROBE_COUNT_PHASE2			SMIAPP_REG_MK_U8(0x0d89)
+#define SMIAPP_REG_U8_POSITION					SMIAPP_REG_MK_U8(0x0d8a)
+#define SMIAPP_REG_U8_BRACKETING_LUT_CONTROL			SMIAPP_REG_MK_U8(0x0e00)
+#define SMIAPP_REG_U8_BRACKETING_LUT_MODE			SMIAPP_REG_MK_U8(0x0e01)
+#define SMIAPP_REG_U8_BRACKETING_LUT_ENTRY_CONTROL		SMIAPP_REG_MK_U8(0x0e02)
+#define SMIAPP_REG_U8_LUT_PARAMETERS_START			SMIAPP_REG_MK_U8(0x0e10)
+#define SMIAPP_REG_U8_LUT_PARAMETERS_END			SMIAPP_REG_MK_U8(0x0eff)
+#define SMIAPP_REG_U16_INTEGRATION_TIME_CAPABILITY		SMIAPP_REG_MK_U16(0x1000)
+#define SMIAPP_REG_U16_COARSE_INTEGRATION_TIME_MIN		SMIAPP_REG_MK_U16(0x1004)
+#define SMIAPP_REG_U16_COARSE_INTEGRATION_TIME_MAX_MARGIN	SMIAPP_REG_MK_U16(0x1006)
+#define SMIAPP_REG_U16_FINE_INTEGRATION_TIME_MIN		SMIAPP_REG_MK_U16(0x1008)
+#define SMIAPP_REG_U16_FINE_INTEGRATION_TIME_MAX_MARGIN		SMIAPP_REG_MK_U16(0x100a)
+#define SMIAPP_REG_U16_DIGITAL_GAIN_CAPABILITY			SMIAPP_REG_MK_U16(0x1080)
+#define SMIAPP_REG_U16_DIGITAL_GAIN_MIN				SMIAPP_REG_MK_U16(0x1084)
+#define SMIAPP_REG_U16_DIGITAL_GAIN_MAX				SMIAPP_REG_MK_U16(0x1086)
+#define SMIAPP_REG_U16_DIGITAL_GAIN_STEP_SIZE			SMIAPP_REG_MK_U16(0x1088)
+#define SMIAPP_REG_F32_MIN_EXT_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1100)
+#define SMIAPP_REG_F32_MAX_EXT_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1104)
+#define SMIAPP_REG_U16_MIN_PRE_PLL_CLK_DIV			SMIAPP_REG_MK_U16(0x1108)
+#define SMIAPP_REG_U16_MAX_PRE_PLL_CLK_DIV			SMIAPP_REG_MK_U16(0x110a)
+#define SMIAPP_REG_F32_MIN_PLL_IP_FREQ_HZ			SMIAPP_REG_MK_F32(0x110c)
+#define SMIAPP_REG_F32_MAX_PLL_IP_FREQ_HZ			SMIAPP_REG_MK_F32(0x1110)
+#define SMIAPP_REG_U16_MIN_PLL_MULTIPLIER			SMIAPP_REG_MK_U16(0x1114)
+#define SMIAPP_REG_U16_MAX_PLL_MULTIPLIER			SMIAPP_REG_MK_U16(0x1116)
+#define SMIAPP_REG_F32_MIN_PLL_OP_FREQ_HZ			SMIAPP_REG_MK_F32(0x1118)
+#define SMIAPP_REG_F32_MAX_PLL_OP_FREQ_HZ			SMIAPP_REG_MK_F32(0x111c)
+#define SMIAPP_REG_U16_MIN_VT_SYS_CLK_DIV			SMIAPP_REG_MK_U16(0x1120)
+#define SMIAPP_REG_U16_MAX_VT_SYS_CLK_DIV			SMIAPP_REG_MK_U16(0x1122)
+#define SMIAPP_REG_F32_MIN_VT_SYS_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1124)
+#define SMIAPP_REG_F32_MAX_VT_SYS_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1128)
+#define SMIAPP_REG_F32_MIN_VT_PIX_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x112c)
+#define SMIAPP_REG_F32_MAX_VT_PIX_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1130)
+#define SMIAPP_REG_U16_MIN_VT_PIX_CLK_DIV			SMIAPP_REG_MK_U16(0x1134)
+#define SMIAPP_REG_U16_MAX_VT_PIX_CLK_DIV			SMIAPP_REG_MK_U16(0x1136)
+#define SMIAPP_REG_U16_MIN_FRAME_LENGTH_LINES			SMIAPP_REG_MK_U16(0x1140)
+#define SMIAPP_REG_U16_MAX_FRAME_LENGTH_LINES			SMIAPP_REG_MK_U16(0x1142)
+#define SMIAPP_REG_U16_MIN_LINE_LENGTH_PCK			SMIAPP_REG_MK_U16(0x1144)
+#define SMIAPP_REG_U16_MAX_LINE_LENGTH_PCK			SMIAPP_REG_MK_U16(0x1146)
+#define SMIAPP_REG_U16_MIN_LINE_BLANKING_PCK			SMIAPP_REG_MK_U16(0x1148)
+#define SMIAPP_REG_U16_MIN_FRAME_BLANKING_LINES			SMIAPP_REG_MK_U16(0x114a)
+#define SMIAPP_REG_U8_MIN_LINE_LENGTH_PCK_STEP_SIZE		SMIAPP_REG_MK_U8(0x114c)
+#define SMIAPP_REG_U16_MIN_OP_SYS_CLK_DIV			SMIAPP_REG_MK_U16(0x1160)
+#define SMIAPP_REG_U16_MAX_OP_SYS_CLK_DIV			SMIAPP_REG_MK_U16(0x1162)
+#define SMIAPP_REG_F32_MIN_OP_SYS_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1164)
+#define SMIAPP_REG_F32_MAX_OP_SYS_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1168)
+#define SMIAPP_REG_U16_MIN_OP_PIX_CLK_DIV			SMIAPP_REG_MK_U16(0x116c)
+#define SMIAPP_REG_U16_MAX_OP_PIX_CLK_DIV			SMIAPP_REG_MK_U16(0x116e)
+#define SMIAPP_REG_F32_MIN_OP_PIX_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1170)
+#define SMIAPP_REG_F32_MAX_OP_PIX_CLK_FREQ_HZ			SMIAPP_REG_MK_F32(0x1174)
+#define SMIAPP_REG_U16_X_ADDR_MIN				SMIAPP_REG_MK_U16(0x1180)
+#define SMIAPP_REG_U16_Y_ADDR_MIN				SMIAPP_REG_MK_U16(0x1182)
+#define SMIAPP_REG_U16_X_ADDR_MAX				SMIAPP_REG_MK_U16(0x1184)
+#define SMIAPP_REG_U16_Y_ADDR_MAX				SMIAPP_REG_MK_U16(0x1186)
+#define SMIAPP_REG_U16_MIN_X_OUTPUT_SIZE			SMIAPP_REG_MK_U16(0x1188)
+#define SMIAPP_REG_U16_MIN_Y_OUTPUT_SIZE			SMIAPP_REG_MK_U16(0x118a)
+#define SMIAPP_REG_U16_MAX_X_OUTPUT_SIZE			SMIAPP_REG_MK_U16(0x118c)
+#define SMIAPP_REG_U16_MAX_Y_OUTPUT_SIZE			SMIAPP_REG_MK_U16(0x118e)
+#define SMIAPP_REG_U16_MIN_EVEN_INC				SMIAPP_REG_MK_U16(0x11c0)
+#define SMIAPP_REG_U16_MAX_EVEN_INC				SMIAPP_REG_MK_U16(0x11c2)
+#define SMIAPP_REG_U16_MIN_ODD_INC				SMIAPP_REG_MK_U16(0x11c4)
+#define SMIAPP_REG_U16_MAX_ODD_INC				SMIAPP_REG_MK_U16(0x11c6)
+#define SMIAPP_REG_U16_SCALING_CAPABILITY			SMIAPP_REG_MK_U16(0x1200)
+#define SMIAPP_REG_U16_SCALER_M_MIN				SMIAPP_REG_MK_U16(0x1204)
+#define SMIAPP_REG_U16_SCALER_M_MAX				SMIAPP_REG_MK_U16(0x1206)
+#define SMIAPP_REG_U16_SCALER_N_MIN				SMIAPP_REG_MK_U16(0x1208)
+#define SMIAPP_REG_U16_SCALER_N_MAX				SMIAPP_REG_MK_U16(0x120a)
+#define SMIAPP_REG_U16_SPATIAL_SAMPLING_CAPABILITY		SMIAPP_REG_MK_U16(0x120c)
+#define SMIAPP_REG_U8_DIGITAL_CROP_CAPABILITY			SMIAPP_REG_MK_U8(0x120e)
+#define SMIAPP_REG_U16_COMPRESSION_CAPABILITY			SMIAPP_REG_MK_U16(0x1300)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_REDINRED			SMIAPP_REG_MK_U16(0x1400)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_GREENINRED		SMIAPP_REG_MK_U16(0x1402)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_BLUEINRED			SMIAPP_REG_MK_U16(0x1404)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_REDINGREEN		SMIAPP_REG_MK_U16(0x1406)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_GREENINGREEN		SMIAPP_REG_MK_U16(0x1408)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_BLUEINGREEN		SMIAPP_REG_MK_U16(0x140a)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_REDINBLUE			SMIAPP_REG_MK_U16(0x140c)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_GREENINBLUE		SMIAPP_REG_MK_U16(0x140e)
+#define SMIAPP_REG_U16_MATRIX_ELEMENT_BLUEINBLUE		SMIAPP_REG_MK_U16(0x1410)
+#define SMIAPP_REG_U16_FIFO_SIZE_PIXELS				SMIAPP_REG_MK_U16(0x1500)
+#define SMIAPP_REG_U8_FIFO_SUPPORT_CAPABILITY			SMIAPP_REG_MK_U8(0x1502)
+#define SMIAPP_REG_U8_DPHY_CTRL_CAPABILITY			SMIAPP_REG_MK_U8(0x1600)
+#define SMIAPP_REG_U8_CSI_LANE_MODE_CAPABILITY			SMIAPP_REG_MK_U8(0x1601)
+#define SMIAPP_REG_U8_CSI_SIGNALLING_MODE_CAPABILITY		SMIAPP_REG_MK_U8(0x1602)
+#define SMIAPP_REG_U8_FAST_STANDBY_CAPABILITY			SMIAPP_REG_MK_U8(0x1603)
+#define SMIAPP_REG_U8_CCI_ADDRESS_CONTROL_CAPABILITY		SMIAPP_REG_MK_U8(0x1604)
+#define SMIAPP_REG_U32_MAX_PER_LANE_BITRATE_1_LANE_MODE_MBPS	SMIAPP_REG_MK_U32(0x1608)
+#define SMIAPP_REG_U32_MAX_PER_LANE_BITRATE_2_LANE_MODE_MBPS	SMIAPP_REG_MK_U32(0x160c)
+#define SMIAPP_REG_U32_MAX_PER_LANE_BITRATE_3_LANE_MODE_MBPS	SMIAPP_REG_MK_U32(0x1610)
+#define SMIAPP_REG_U32_MAX_PER_LANE_BITRATE_4_LANE_MODE_MBPS	SMIAPP_REG_MK_U32(0x1614)
+#define SMIAPP_REG_U8_TEMP_SENSOR_CAPABILITY			SMIAPP_REG_MK_U8(0x1618)
+#define SMIAPP_REG_U16_MIN_FRAME_LENGTH_LINES_BIN		SMIAPP_REG_MK_U16(0x1700)
+#define SMIAPP_REG_U16_MAX_FRAME_LENGTH_LINES_BIN		SMIAPP_REG_MK_U16(0x1702)
+#define SMIAPP_REG_U16_MIN_LINE_LENGTH_PCK_BIN			SMIAPP_REG_MK_U16(0x1704)
+#define SMIAPP_REG_U16_MAX_LINE_LENGTH_PCK_BIN			SMIAPP_REG_MK_U16(0x1706)
+#define SMIAPP_REG_U16_MIN_LINE_BLANKING_PCK_BIN		SMIAPP_REG_MK_U16(0x1708)
+#define SMIAPP_REG_U16_FINE_INTEGRATION_TIME_MIN_BIN		SMIAPP_REG_MK_U16(0x170a)
+#define SMIAPP_REG_U16_FINE_INTEGRATION_TIME_MAX_MARGIN_BIN	SMIAPP_REG_MK_U16(0x170c)
+#define SMIAPP_REG_U8_BINNING_CAPABILITY			SMIAPP_REG_MK_U8(0x1710)
+#define SMIAPP_REG_U8_BINNING_WEIGHTING_CAPABILITY		SMIAPP_REG_MK_U8(0x1711)
+#define SMIAPP_REG_U8_BINNING_SUBTYPES				SMIAPP_REG_MK_U8(0x1712)
+#define SMIAPP_REG_U8_BINNING_TYPE_n(n)				SMIAPP_REG_MK_U8(0x1713 + (n)) /* 1 <= n <= 237 */
+#define SMIAPP_REG_U8_DATA_TRANSFER_IF_CAPABILITY		SMIAPP_REG_MK_U8(0x1800)
+#define SMIAPP_REG_U8_SHADING_CORRECTION_CAPABILITY		SMIAPP_REG_MK_U8(0x1900)
+#define SMIAPP_REG_U8_GREEN_IMBALANCE_CAPABILITY		SMIAPP_REG_MK_U8(0x1901)
+#define SMIAPP_REG_U8_BLACK_LEVEL_CAPABILITY			SMIAPP_REG_MK_U8(0x1902)
+#define SMIAPP_REG_U8_MODULE_SPECIFIC_CORRECTION_CAPABILITY	SMIAPP_REG_MK_U8(0x1903)
+#define SMIAPP_REG_U16_DEFECT_CORRECTION_CAPABILITY		SMIAPP_REG_MK_U16(0x1904)
+#define SMIAPP_REG_U16_DEFECT_CORRECTION_CAPABILITY_2		SMIAPP_REG_MK_U16(0x1906)
+#define SMIAPP_REG_U8_EDOF_CAPABILITY				SMIAPP_REG_MK_U8(0x1980)
+#define SMIAPP_REG_U8_ESTIMATION_FRAMES				SMIAPP_REG_MK_U8(0x1981)
+#define SMIAPP_REG_U8_SUPPORTS_SHARPNESS_ADJ			SMIAPP_REG_MK_U8(0x1982)
+#define SMIAPP_REG_U8_SUPPORTS_DENOISING_ADJ			SMIAPP_REG_MK_U8(0x1983)
+#define SMIAPP_REG_U8_SUPPORTS_MODULE_SPECIFIC_ADJ		SMIAPP_REG_MK_U8(0x1984)
+#define SMIAPP_REG_U8_SUPPORTS_DEPTH_OF_FIELD_ADJ		SMIAPP_REG_MK_U8(0x1985)
+#define SMIAPP_REG_U8_SUPPORTS_FOCUS_DISTANCE_ADJ		SMIAPP_REG_MK_U8(0x1986)
+#define SMIAPP_REG_U8_COLOUR_FEEDBACK_CAPABILITY		SMIAPP_REG_MK_U8(0x1987)
+#define SMIAPP_REG_U8_EDOF_SUPPORT_AB_NXM			SMIAPP_REG_MK_U8(0x1988)
+#define SMIAPP_REG_U8_ESTIMATION_MODE_CAPABILITY		SMIAPP_REG_MK_U8(0x19c0)
+#define SMIAPP_REG_U8_ESTIMATION_ZONE_CAPABILITY		SMIAPP_REG_MK_U8(0x19c1)
+#define SMIAPP_REG_U16_EST_DEPTH_OF_FIELD			SMIAPP_REG_MK_U16(0x19c2)
+#define SMIAPP_REG_U16_EST_FOCUS_DISTANCE			SMIAPP_REG_MK_U16(0x19c4)
+#define SMIAPP_REG_U16_CAPABILITY_TRDY_MIN			SMIAPP_REG_MK_U16(0x1a00)
+#define SMIAPP_REG_U8_FLASH_MODE_CAPABILITY			SMIAPP_REG_MK_U8(0x1a02)
+#define SMIAPP_REG_U16_MECH_SHUT_AND_ACT_START_ADDR		SMIAPP_REG_MK_U16(0x1b02)
+#define SMIAPP_REG_U8_ACTUATOR_CAPABILITY			SMIAPP_REG_MK_U8(0x1b04)
+#define SMIAPP_REG_U16_ACTUATOR_TYPE				SMIAPP_REG_MK_U16(0x1b40)
+#define SMIAPP_REG_U8_AF_DEVICE_ADDRESS				SMIAPP_REG_MK_U8(0x1b42)
+#define SMIAPP_REG_U16_FOCUS_CHANGE_ADDRESS			SMIAPP_REG_MK_U16(0x1b44)
+#define SMIAPP_REG_U8_BRACKETING_LUT_CAPABILITY_1		SMIAPP_REG_MK_U8(0x1c00)
+#define SMIAPP_REG_U8_BRACKETING_LUT_CAPABILITY_2		SMIAPP_REG_MK_U8(0x1c01)
+#define SMIAPP_REG_U8_BRACKETING_LUT_SIZE			SMIAPP_REG_MK_U8(0x1c02)
diff --git a/drivers/media/video/smiapp/smiapp-reg.h b/drivers/media/video/smiapp/smiapp-reg.h
new file mode 100644
index 0000000..d0167aa
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-reg.h
@@ -0,0 +1,122 @@
+/*
+ * drivers/media/video/smiapp/smiapp-reg.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __SMIAPP_REG_H_
+#define __SMIAPP_REG_H_
+
+#include "smiapp-reg-defs.h"
+
+/* Bits for above register */
+#define SMIAPP_IMAGE_ORIENTATION_HFLIP		(1 << 0)
+#define SMIAPP_IMAGE_ORIENTATION_VFLIP		(1 << 1)
+
+#define SMIAPP_DATA_TRANSFER_IF_1_CTRL_EN		(1 << 0)
+#define SMIAPP_DATA_TRANSFER_IF_1_CTRL_RD_EN		(0 << 1)
+#define SMIAPP_DATA_TRANSFER_IF_1_CTRL_WR_EN		(1 << 1)
+#define SMIAPP_DATA_TRANSFER_IF_1_CTRL_ERR_CLEAR	(1 << 2)
+#define SMIAPP_DATA_TRANSFER_IF_1_STATUS_RD_READY	(1 << 0)
+#define SMIAPP_DATA_TRANSFER_IF_1_STATUS_WR_READY	(1 << 1)
+#define SMIAPP_DATA_TRANSFER_IF_1_STATUS_EDATA		(1 << 2)
+#define SMIAPP_DATA_TRANSFER_IF_1_STATUS_EUSAGE		(1 << 3)
+
+#define SMIAPP_SOFTWARE_RESET				(1 << 0)
+
+#define SMIAPP_FLASH_MODE_CAPABILITY_SINGLE_STROBE	(1 << 0)
+#define SMIAPP_FLASH_MODE_CAPABILITY_MULTIPLE_STROBE	(1 << 1)
+
+#define SMIAPP_DPHY_CTRL_AUTOMATIC			0
+/* DPHY control based on REQUESTED_LINK_BIT_RATE_MBPS */
+#define SMIAPP_DPHY_CTRL_UI				1
+#define SMIAPP_DPHY_CTRL_REGISTER			2
+
+#define SMIAPP_COMPRESSION_MODE_SIMPLE_PREDICTOR	1
+#define SMIAPP_COMPRESSION_MODE_ADVANCED_PREDICTOR	2
+
+#define SMIAPP_MODE_SELECT_SOFTWARE_STANDBY		0
+#define SMIAPP_MODE_SELECT_STREAMING			1
+
+#define SMIAPP_SCALING_MODE_NONE			0
+#define SMIAPP_SCALING_MODE_HORIZONTAL			1
+#define SMIAPP_SCALING_MODE_BOTH			2
+
+#define SMIAPP_SCALING_CAPABILITY_NONE			0
+#define SMIAPP_SCALING_CAPABILITY_HORIZONTAL		1
+#define SMIAPP_SCALING_CAPABILITY_BOTH			2 /* horizontal/both */
+
+/* digital crop right before scaler */
+#define SMIAPP_DIGITAL_CROP_CAPABILITY_NONE		0
+#define SMIAPP_DIGITAL_CROP_CAPABILITY_INPUT_CROP	1
+
+#define SMIAPP_BINNING_CAPABILITY_NO			0
+#define SMIAPP_BINNING_CAPABILITY_YES			1
+
+/* Maximum number of binning subtypes */
+#define SMIAPP_BINNING_SUBTYPES				253
+
+#define SMIAPP_PIXEL_ORDER_GRBG				0
+#define SMIAPP_PIXEL_ORDER_RGGB				1
+#define SMIAPP_PIXEL_ORDER_BGGR				2
+#define SMIAPP_PIXEL_ORDER_GBRG				3
+
+#define SMIAPP_DATA_FORMAT_MODEL_TYPE_NORMAL		1
+#define SMIAPP_DATA_FORMAT_MODEL_TYPE_EXTENDED		2
+#define SMIAPP_DATA_FORMAT_MODEL_TYPE_NORMAL_N		8
+#define SMIAPP_DATA_FORMAT_MODEL_TYPE_EXTENDED_N	16
+
+#define SMIAPP_FRAME_FORMAT_MODEL_TYPE_2BYTE		0x01
+#define SMIAPP_FRAME_FORMAT_MODEL_TYPE_4BYTE		0x02
+#define SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NROWS_MASK	0x0f
+#define SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NCOLS_MASK	0xf0
+#define SMIAPP_FRAME_FORMAT_MODEL_SUBTYPE_NCOLS_SHIFT	4
+
+#define SMIAPP_FRAME_FORMAT_DESC_2_PIXELCODE_MASK	0xf000
+#define SMIAPP_FRAME_FORMAT_DESC_2_PIXELCODE_SHIFT	12
+#define SMIAPP_FRAME_FORMAT_DESC_2_PIXELS_MASK		0x0fff
+
+#define SMIAPP_FRAME_FORMAT_DESC_4_PIXELCODE_MASK	0xf0000000
+#define SMIAPP_FRAME_FORMAT_DESC_4_PIXELCODE_SHIFT	28
+#define SMIAPP_FRAME_FORMAT_DESC_4_PIXELS_MASK		0x0000ffff
+
+#define SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_EMBEDDED	1
+#define SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_DUMMY	2
+#define SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_BLACK	3
+#define SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_DARK		4
+#define SMIAPP_FRAME_FORMAT_DESC_PIXELCODE_VISIBLE	5
+
+#define SMIAPP_FAST_STANDBY_CTRL_COMPLETE_FRAMES	0
+#define SMIAPP_FAST_STANDBY_CTRL_IMMEDIATE		1
+
+/* Scaling N factor */
+#define SMIAPP_SCALE_N					16
+
+/* Image statistics registers */
+/* Registers 0x2000 to 0x2fff are reserved for future
+ * use for statistics features.
+ */
+
+/* Manufacturer Specific Registers: 0x3000 to 0x3fff
+ * The manufacturer specifies these as a black box.
+ */
+
+#endif /* __SMIAPP_REG_H_ */
diff --git a/drivers/media/video/smiapp/smiapp-regs.c b/drivers/media/video/smiapp/smiapp-regs.c
new file mode 100644
index 0000000..4851ff7
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-regs.c
@@ -0,0 +1,213 @@
+/*
+ * drivers/media/video/smiapp/smiapp-regs.c
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#include "smiapp-debug.h"
+
+#include <linux/delay.h>
+#include <linux/i2c.h>
+
+#include "smiapp-regs.h"
+
+static uint32_t float_to_u32_mul_1000000(struct i2c_client *client,
+					 uint32_t phloat)
+{
+	int32_t exp;
+	uint64_t man;
+
+	if (phloat >= 0x80000000) {
+		dev_err(&client->dev, "this is a negative number\n");
+		return 0;
+	}
+
+	if (phloat == 0x7f800000)
+		return ~0; /* Inf. */
+
+	if ((phloat & 0x7f800000) == 0x7f800000) {
+		dev_err(&client->dev, "NaN or other special number\n");
+		return 0;
+	}
+
+	/* Valid cases begin here */
+	if (phloat == 0)
+		return 0; /* Valid zero */
+
+	if (phloat > 0x4f800000)
+		return ~0; /* larger than 4294967295 */
+
+	/*
+	 * Unbias exponent (note how phloat is now guaranteed to
+	 * have 0 in the high bit)
+	 */
+	exp = ((int32_t)phloat >> 23) - 127;
+
+	/* Extract mantissa, add missing '1' bit and it's in MHz */
+	man = ((phloat & 0x7fffff) | 0x800000) * 1000000ULL;
+
+	if (exp < 0)
+		man >>= -exp;
+	else
+		man <<= exp;
+
+	man >>= 23; /* Remove mantissa bias */
+
+	return man & 0xffffffff;
+}
+
+
+/*
+ * Read a 8/16/32-bit i2c register.  The value is returned in 'val'.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+int smiapp_read(struct i2c_client *client, u32 reg, u32 *val)
+{
+	struct i2c_msg msg;
+	unsigned char data[4];
+	unsigned int len = (u8)(reg >> 16);
+	u16 offset = reg;
+	int r;
+
+	if (len != SMIA_REG_8BIT && len != SMIA_REG_16BIT
+	    && len != SMIA_REG_32BIT)
+		return -EINVAL;
+
+	msg.addr = client->addr;
+	msg.flags = 0;
+	msg.len = 2;
+	msg.buf = data;
+
+	/* high byte goes out first */
+	data[0] = (u8) (offset >> 8);
+	data[1] = (u8) offset;
+	r = i2c_transfer(client->adapter, &msg, 1);
+	if (r != 1) {
+		if (r >= 0)
+			r = -EBUSY;
+		goto err;
+	}
+
+	msg.len = len;
+	msg.flags = I2C_M_RD;
+	r = i2c_transfer(client->adapter, &msg, 1);
+	if (r != 1) {
+		if (r >= 0)
+			r = -EBUSY;
+		goto err;
+	}
+
+	*val = 0;
+	/* high byte comes first */
+	switch (len) {
+	case SMIA_REG_32BIT:
+		*val = (data[0] << 24) + (data[1] << 16) + (data[2] << 8) +
+			data[3];
+		break;
+	case SMIA_REG_16BIT:
+		*val = (data[0] << 8) + data[1];
+		break;
+	case SMIA_REG_8BIT:
+		*val = data[0];
+		break;
+	default:
+		BUG();
+	}
+
+	if (reg & SMIA_REG_FLAG_FLOAT)
+		*val = float_to_u32_mul_1000000(client, *val);
+
+	return 0;
+
+err:
+	dev_err(&client->dev, "read from offset 0x%x error %d\n", offset, r);
+
+	return r;
+}
+
+/*
+ * Write to a 8/16-bit register.
+ * Returns zero if successful, or non-zero otherwise.
+ */
+int smiapp_write(struct i2c_client *client, u32 reg, u32 val)
+{
+	struct i2c_msg msg;
+	unsigned char data[6];
+	unsigned int retries;
+	unsigned int flags = reg >> 24;
+	unsigned int len = (u8)(reg >> 16);
+	u16 offset = reg;
+	int r;
+
+	if ((len != SMIA_REG_8BIT && len != SMIA_REG_16BIT &&
+	     len != SMIA_REG_32BIT) || flags)
+		return -EINVAL;
+
+	msg.addr = client->addr;
+	msg.flags = 0; /* Write */
+	msg.len = 2 + len;
+	msg.buf = data;
+
+	/* high byte goes out first */
+	data[0] = (u8) (reg >> 8);
+	data[1] = (u8) (reg & 0xff);
+
+	switch (len) {
+	case SMIA_REG_8BIT:
+		data[2] = val;
+		break;
+	case SMIA_REG_16BIT:
+		data[2] = val >> 8;
+		data[3] = val;
+		break;
+	case SMIA_REG_32BIT:
+		data[2] = val >> 24;
+		data[3] = val >> 16;
+		data[4] = val >> 8;
+		data[5] = val;
+		break;
+	default:
+		BUG();
+	}
+
+	for (retries = 0; retries < 5; retries++) {
+		/*
+		 * Due to unknown reason sensor stops responding. This
+		 * loop is a temporaty solution until the root cause
+		 * is found.
+		 */
+		r = i2c_transfer(client->adapter, &msg, 1);
+		if (r == 1) {
+			if (retries)
+				dev_err(&client->dev,
+					"sensor i2c stall encountered. "
+					"retries: %d\n", retries);
+			return 0;
+		}
+
+		usleep_range(2000, 2000);
+	}
+
+	dev_err(&client->dev,
+		"wrote 0x%x to offset 0x%x error %d\n", val, offset, r);
+
+	return r;
+}
diff --git a/drivers/media/video/smiapp/smiapp-regs.h b/drivers/media/video/smiapp/smiapp-regs.h
new file mode 100644
index 0000000..58e8009
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp-regs.h
@@ -0,0 +1,46 @@
+/*
+ * include/media/smiapp/smiapp-regs.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef SMIAPP_REGS_H
+#define SMIAPP_REGS_H
+
+#include <linux/i2c.h>
+#include <linux/types.h>
+
+/* Use upper 8 bits of the type field for flags */
+#define SMIA_REG_FLAG_FLOAT		(1 << 24)
+
+#define SMIA_REG_8BIT			1
+#define SMIA_REG_16BIT			2
+#define SMIA_REG_32BIT			4
+struct smia_reg {
+	u16 type;
+	u16 reg;			/* 16-bit offset */
+	u32 val;			/* 8/16/32-bit value */
+};
+
+int smiapp_read(struct i2c_client *client, u32 reg, u32 *val);
+int smiapp_write(struct i2c_client *client, u32 reg, u32 val);
+
+#endif
diff --git a/drivers/media/video/smiapp/smiapp.h b/drivers/media/video/smiapp/smiapp.h
new file mode 100644
index 0000000..805d8c8
--- /dev/null
+++ b/drivers/media/video/smiapp/smiapp.h
@@ -0,0 +1,251 @@
+/*
+ * drivers/media/video/smiapp/smiapp.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2010--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __SMIAPP_PRIV_H_
+#define __SMIAPP_PRIV_H_
+
+#include <linux/mutex.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-subdev.h>
+#include <media/smiapp.h>
+
+#include "../smiapp-pll.h"
+#include "smiapp-reg.h"
+#include "smiapp-regs.h"
+#include "smiapp-quirk.h"
+
+/*
+ * Standard SMIA++ constants
+ */
+#define SMIA_VERSION_1			10
+#define SMIAPP_VERSION_0_8		8 /* Draft 0.8 */
+#define SMIAPP_VERSION_0_9		9 /* Draft 0.9 */
+#define SMIAPP_VERSION_1		10
+
+#define SMIAPP_PROFILE_0		0
+#define SMIAPP_PROFILE_1		1
+#define SMIAPP_PROFILE_2		2
+
+#define SMIAPP_NVM_PAGE_SIZE		64	/* bytes */
+
+#define SMIAPP_RESET_DELAY_CLOCKS	2400
+#define SMIAPP_RESET_DELAY(clk)				\
+	(1000 +	(SMIAPP_RESET_DELAY_CLOCKS * 1000	\
+		 + (clk) / 1000 - 1) / ((clk) / 1000))
+
+#include "smiapp-limits.h"
+
+struct smiapp_quirk;
+
+#define SMIAPP_MODULE_IDENT_FLAG_REV_LE		(1 << 0)
+
+struct smiapp_module_ident {
+	u8 manufacturer_id;
+	u16 model_id;
+	u8 revision_number_major;
+
+	u8 flags;
+
+	char *name;
+	const struct smiapp_quirk *quirk;
+};
+
+struct smiapp_module_info {
+	u32 manufacturer_id;
+	u32 model_id;
+	u32 revision_number_major;
+	u32 revision_number_minor;
+
+	u32 module_year;
+	u32 module_month;
+	u32 module_day;
+
+	u32 sensor_manufacturer_id;
+	u32 sensor_model_id;
+	u32 sensor_revision_number;
+	u32 sensor_firmware_version;
+
+	u32 smia_version;
+	u32 smiapp_version;
+
+	u32 smiapp_profile;
+
+	char *name;
+	const struct smiapp_quirk *quirk;
+};
+
+#define SMIAPP_IDENT_FQ(manufacturer, model, rev, fl, _name, _quirk)	\
+	{ .manufacturer_id = manufacturer,				\
+	  .model_id = model,						\
+	  .revision_number_major = rev,					\
+	  .flags = fl,							\
+	  .name = _name,						\
+	  .quirk = _quirk, }
+
+#define SMIAPP_IDENT_LQ(manufacturer, model, rev, _name, _quirk)	\
+	{ .manufacturer_id = manufacturer,				\
+	  .model_id = model,						\
+	  .revision_number_major = rev,					\
+	  .flags = SMIAPP_MODULE_IDENT_FLAG_REV_LE,			\
+	  .name = _name,						\
+	  .quirk = _quirk, }
+
+#define SMIAPP_IDENT_L(manufacturer, model, rev, _name)			\
+	{ .manufacturer_id = manufacturer,				\
+	  .model_id = model,						\
+	  .revision_number_major = rev,					\
+	  .flags = SMIAPP_MODULE_IDENT_FLAG_REV_LE,			\
+	  .name = _name, }
+
+#define SMIAPP_IDENT_Q(manufacturer, model, rev, _name, _quirk)		\
+	{ .manufacturer_id = manufacturer,				\
+	  .model_id = model,						\
+	  .revision_number_major = rev,					\
+	  .flags = 0,							\
+	  .name = _name,						\
+	  .quirk = _quirk, }
+
+#define SMIAPP_IDENT(manufacturer, model, rev, _name)			\
+	{ .manufacturer_id = manufacturer,				\
+	  .model_id = model,						\
+	  .revision_number_major = rev,					\
+	  .flags = 0,							\
+	  .name = _name, }
+
+struct smiapp_reg_limits {
+	u32 addr;
+	char *what;
+};
+
+extern struct smiapp_reg_limits smiapp_reg_limits[];
+
+struct smiapp_csi_data_format {
+	u32 code;
+	u8 width;
+	u8 compressed;
+	u8 pixel_order;
+};
+
+#define SMIAPP_SUBDEVS			3
+
+#define SMIAPP_PA_PAD_SRC		0
+#define SMIAPP_PAD_SINK			0
+#define SMIAPP_PAD_SRC			1
+#define SMIAPP_PADS			2
+
+struct smiapp_binning_subtype {
+	u8 horizontal:4;
+	u8 vertical:4;
+} __packed;
+
+struct smiapp_subdev {
+	struct v4l2_subdev sd;
+	struct media_pad pads[2];
+	struct v4l2_rect sink_fmt;
+	struct v4l2_rect crop[2];
+	struct v4l2_rect compose; /* compose on sink */
+	unsigned short sink_pad;
+	unsigned short source_pad;
+	int npads;
+	struct smiapp_sensor *sensor;
+	struct v4l2_ctrl_handler ctrl_handler;
+};
+
+/*
+ * struct smiapp_sensor - Main device structure
+ */
+struct smiapp_sensor {
+	/*
+	 * "mutex" is used to serialise access to all fields here
+	 * except v4l2_ctrls at the end of the struct. "mutex" is also
+	 * used to serialise access to file handle specific
+	 * information. The exception to this rule is the power_mutex
+	 * below.
+	 */
+	struct mutex mutex;
+	/*
+	 * power_mutex is used to serialise power management related
+	 * activities. Acquiring "mutex" at that time isn't necessary
+	 * since there are no other users anyway.
+	 */
+	struct mutex power_mutex;
+	struct smiapp_subdev ssds[SMIAPP_SUBDEVS];
+	u32 ssds_used;
+	struct smiapp_subdev *src;
+	struct smiapp_subdev *binner;
+	struct smiapp_subdev *scaler;
+	struct smiapp_subdev *pixel_array;
+	struct smiapp_platform_data *platform_data;
+	struct regulator *vana;
+	u32 limits[SMIAPP_LIMIT_LAST];
+	u8 nbinning_subtypes;
+	struct smiapp_binning_subtype binning_subtypes[SMIAPP_BINNING_SUBTYPES];
+	u32 mbus_frame_fmts;
+	const struct smiapp_csi_data_format *csi_format;
+	const struct smiapp_csi_data_format *internal_csi_format;
+	u32 default_mbus_frame_fmts;
+	int default_pixel_order;
+
+	u8 binning_horizontal;
+	u8 binning_vertical;
+
+	u8 scale_m;
+	u8 scaling_mode;
+
+	u8 hvflip_inv_mask; /* H/VFLIP inversion due to sensor orientation */
+	u8 flash_capability;
+	u8 frame_skip;
+
+	int power_count;
+
+	bool streaming;
+	bool dev_init_done;
+
+	u8 *nvm;		/* nvm memory buffer */
+	unsigned int nvm_size;	/* bytes */
+
+	struct smiapp_module_info minfo;
+
+	struct smiapp_pll pll;
+
+	/* Pixel array controls */
+	struct v4l2_ctrl *analog_gain;
+	struct v4l2_ctrl *exposure;
+	struct v4l2_ctrl *hflip;
+	struct v4l2_ctrl *vflip;
+	struct v4l2_ctrl *vblank;
+	struct v4l2_ctrl *hblank;
+	struct v4l2_ctrl *pixel_rate_parray;
+	/* src controls */
+	struct v4l2_ctrl *link_freq;
+	struct v4l2_ctrl *pixel_rate_csi;
+};
+
+#define to_smiapp_subdev(_sd)				\
+	container_of(_sd, struct smiapp_subdev, sd)
+
+#define to_smiapp_sensor(_sd)	\
+	(to_smiapp_subdev(_sd)->sensor)
+
+#endif /* __SMIAPP_PRIV_H_ */
diff --git a/include/media/smiapp.h b/include/media/smiapp.h
new file mode 100644
index 0000000..a7877cd
--- /dev/null
+++ b/include/media/smiapp.h
@@ -0,0 +1,83 @@
+/*
+ * include/media/smiapp.h
+ *
+ * Generic driver for SMIA/SMIA++ compliant camera modules
+ *
+ * Copyright (C) 2011--2012 Nokia Corporation
+ * Contact: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef __SMIAPP_H_
+#define __SMIAPP_H_
+
+#include <media/v4l2-subdev.h>
+
+#define SMIAPP_NAME		"smiapp"
+
+#define SMIAPP_DFL_I2C_ADDR	(0x20 >> 1) /* Default I2C Address */
+#define SMIAPP_ALT_I2C_ADDR	(0x6e >> 1) /* Alternate I2C Address */
+
+#define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_CLOCK	0
+#define SMIAPP_CSI_SIGNALLING_MODE_CCP2_DATA_STROBE	1
+#define SMIAPP_CSI_SIGNALLING_MODE_CSI2			2
+
+#define SMIAPP_NO_XSHUTDOWN	-1
+
+/*
+ * Sometimes due to board layout considerations the camera module can be
+ * mounted rotated. The typical rotation used is 180 degrees which can be
+ * corrected by giving a default H-FLIP and V-FLIP in the sensor readout.
+ * FIXME: rotation also changes the bayer pattern.
+ */
+enum smiapp_module_board_orient {
+	SMIAPP_MODULE_BOARD_ORIENT_0 = 0,
+	SMIAPP_MODULE_BOARD_ORIENT_180,
+};
+
+struct smiapp_flash_strobe_parms {
+	u8 mode;
+	u32 strobe_width_high_us;
+	u16 strobe_delay;
+	u16 stobe_start_point;
+	u8 trigger;
+};
+
+struct smiapp_platform_data {
+	/*
+	 * Change the cci address if i2c_addr_alt is set.
+	 * Both default and alternate cci addr need to be present
+	 */
+	unsigned short i2c_addr_dfl;	/* Default i2c addr */
+	unsigned short i2c_addr_alt;	/* Alternate i2c addr */
+
+	unsigned int nvm_size;			/* bytes */
+	unsigned int ext_clk;			/* sensor external clk */
+
+	unsigned int lanes;		/* Number of CSI-2 lanes */
+	u8 csi_signalling_mode;		/* SMIAPP_CSI_SIGNALLING_MODE_* */
+	const s64 *op_sys_clock;
+
+	enum smiapp_module_board_orient module_board_orient;
+
+	struct smiapp_flash_strobe_parms *strobe_setup;
+
+	int (*set_xclk)(struct v4l2_subdev *sd, int hz);
+	int xshutdown;			/* gpio or SMIAPP_NO_XSHUTDOWN */
+};
+
+#endif /* __SMIAPP_H_  */
-- 
1.7.2.5


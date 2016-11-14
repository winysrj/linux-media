Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:57415 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932449AbcKNMA0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 07:00:26 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [RFCv2 PATCH] tc358840: add Toshiba HDMI-to-CSI bridge driver
Message-ID: <44d2d84d-f18d-9c80-977f-8a2b8675e70a@xs4all.nl>
Date: Mon, 14 Nov 2016 13:00:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Second RFC version.

This driver was created by Armin Weiss and cleaned up, rebased and 4k
and CEC support finalized by Hans Verkuil.

It's almost ready for mainlining. The main TODO is to clean up and document
the device tree bindings.

Signed-off-by: Armin Weiss <weii@zhaw.ch>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../devicetree/bindings/media/i2c/tc358840.txt     |   50 +
 MAINTAINERS                                        |    7 +
 drivers/media/i2c/Kconfig                          |   18 +
 drivers/media/i2c/Makefile                         |    1 +
 drivers/media/i2c/tc358840.c                       | 2851 ++++++++++++++++++++
 drivers/media/i2c/tc358840_regs.h                  |  805 ++++++
 include/media/i2c/tc358840.h                       |   91 +
 7 files changed, 3823 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tc358840.txt
 create mode 100644 drivers/media/i2c/tc358840.c
 create mode 100644 drivers/media/i2c/tc358840_regs.h
 create mode 100644 include/media/i2c/tc358840.h

diff --git a/Documentation/devicetree/bindings/media/i2c/tc358840.txt b/Documentation/devicetree/bindings/media/i2c/tc358840.txt
new file mode 100644
index 0000000..b2a2544
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/tc358840.txt
@@ -0,0 +1,50 @@
+* Toshiba TC358840 HDMI-RX to MIPI CSI2-TX Bridge
+
+The Toshiba TC358840 HDMI-RX to MIPI CSI2-TX (H2C) is a bridge that converts
+a HDMI stream to MIPI CSI-2 TX. It is programmable through I2C.
+
+Required Properties:
+
+- compatible: value should be "toshiba,tc358840"
+- clocks, clock-names: should contain a phandle link to the reference clock
+		       source, the clock input is named "refclk".
+
+Optional Properties:
+
+- reset-gpios: gpio phandle GPIO connected to the reset pin
+- interrupts, interrupt-parent: GPIO connected to the interrupt pin
+- data-lanes: should be <1 2 3 4> for four-lane operation,
+	      or <1 2> for two-lane operation
+- clock-lanes: should be <0>
+- clock-noncontinuous: Presence of this boolean property decides whether the
+		       MIPI CSI-2 clock is continuous or non-continuous.
+- link-frequencies: List of allowed link frequencies in Hz. Each frequency is
+		    expressed as a 64-bit big-endian integer. The frequency
+		    is half of the bps per lane due to DDR transmission.
+- csi_port: which CSI ports can be used: 1 = TX0, 2 = TX1, 3 = TX0 + TX1.
+
+For further information on the MIPI CSI-2 endpoint node properties, see
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+	tc358840@0f {
+		compatible = "toshiba,tc358840";
+		reg = <0x0f>;
+		clocks = <&hdmi_osc>;
+		clock-names = "refclk";
+		reset-gpios = <&gpio6 9 GPIO_ACTIVE_LOW>;
+		interrupt-parent = <&gpio2>;
+		interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
+		csi_port = <3>;
+
+		port {
+			tc358840_out: endpoint {
+				remote-endpoint = <&mipi_csi2_in>;
+				data-lanes = <1 2 3 4>;
+				clock-lanes = <0>;
+				clock-noncontinuous;
+				link-frequencies = /bits/ 64 <297000000>;
+			};
+		};
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index 93e9f42..40c54ef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12145,6 +12145,13 @@ S:	Maintained
 F:	drivers/media/i2c/tc358743*
 F:	include/media/i2c/tc358743.h

+TOSHIBA TC358840 DRIVER
+M:	Hans Verkuil <hans.verkuil@cisco.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/tc358840*
+F:	include/media/i2c/tc358840.h
+
 TMIO/SDHI MMC DRIVER
 M:	Wolfram Sang <wsa+renesas@sang-engineering.com>
 L:	linux-mmc@vger.kernel.org
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 2669b4b..404240d 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -330,6 +330,24 @@ config VIDEO_TC358743
 	  To compile this driver as a module, choose M here: the
 	  module will be called tc358743.

+config VIDEO_TC358840
+	tristate "Toshiba TC358840 decoder"
+	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
+	select HDMI
+	select MEDIA_CEC_EDID
+	---help---
+	  Support for the Toshiba TC358840 HDMI to MIPI CSI-2 bridge.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tc358840.
+
+config VIDEO_TC358840_CEC
+	bool "Enable Toshiba TC358840 CEC support"
+	depends on VIDEO_TC358840 && MEDIA_CEC
+	---help---
+	  When selected the tc358840 will support the optional
+	  HDMI CEC feature.
+
 config VIDEO_TVP514X
 	tristate "Texas Instruments TVP514x video decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 92773b2..086567e 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -82,3 +82,4 @@ obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
 obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
 obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
+obj-$(CONFIG_VIDEO_TC358840)	+= tc358840.o
diff --git a/drivers/media/i2c/tc358840.c b/drivers/media/i2c/tc358840.c
new file mode 100644
index 0000000..dd4f75d
--- /dev/null
+++ b/drivers/media/i2c/tc358840.c
@@ -0,0 +1,2851 @@
+/*
+ * tc358840.c - Toshiba UH2C/D HDMI-CSI bridge driver
+ *
+ * Copyright (c) 2015, Armin Weiss <weii@zhaw.ch>
+ * Copyright (c) 2016, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is based on the tc358840 - Toshiba HDMI to CSI-2 bridge driver
+ * from Cisco Systems, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+
+#include <linux/module.h>
+
+#include <linux/i2c.h>
+#include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
+#include <linux/interrupt.h>
+#include <linux/videodev2.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/hdmi.h>
+#include <linux/v4l2-dv-timings.h>
+
+#include <media/v4l2-dv-timings.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/cec.h>
+
+#include <media/i2c/tc358840.h>
+
+#include "tc358840_regs.h"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-3)");
+
+#define TEST_PATTERN_DISABLED		0
+#define TEST_PATTERN_COLOR_BAR		1
+#define TEST_PATTERN_COLOR_CHECKER	2
+
+#define EDID_NUM_BLOCKS_MAX 8
+#define EDID_BLOCK_SIZE 128
+
+#define I2C_MAX_XFER_SIZE  (EDID_BLOCK_SIZE + 2)
+
+static const struct v4l2_dv_timings_cap tc358840_timings_cap_1080p60 = {
+	.type = V4L2_DV_BT_656_1120,
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	/* Pixel clock from REF_01 p. 20. */
+	V4L2_INIT_BT_TIMINGS(
+		160, 1920, 120, 1200, 25000000, 165000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+		V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
+		V4L2_DV_BT_CAP_PROGRESSIVE |
+		V4L2_DV_BT_CAP_REDUCED_BLANKING |
+		V4L2_DV_BT_CAP_CUSTOM)
+};
+
+static const struct v4l2_dv_timings_cap tc358840_timings_cap_4kp30 = {
+	.type = V4L2_DV_BT_656_1120,
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	/* Pixel clock from REF_01 p. 20. Min/max height/width are unknown */
+	V4L2_INIT_BT_TIMINGS(
+		160, 3840, 120, 2160, 25000000, 300000000,
+		V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+		V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
+		V4L2_DV_BT_CAP_PROGRESSIVE |
+		V4L2_DV_BT_CAP_REDUCED_BLANKING |
+		V4L2_DV_BT_CAP_CUSTOM)
+};
+
+struct tc358840_state {
+	struct tc358840_platform_data pdata;
+	struct v4l2_subdev sd;
+	struct media_pad pad[2];
+	struct v4l2_ctrl_handler hdl;
+	struct i2c_client *i2c_client;
+	/* CONFCTL is modified in ops and tc358840_hdmi_sys_int_handler */
+	struct mutex confctl_mutex;
+
+	struct cec_adapter *cec_adap;
+	bool enabled;
+	bool found_signal;
+	bool found_stable_signal;
+	unsigned int new_fmt_cnt;
+	u32 format_changed;
+	int test_pattern;
+
+	/* controls */
+	struct v4l2_ctrl *detect_tx_5v_ctrl;
+	struct v4l2_ctrl *audio_sampling_rate_ctrl;
+	struct v4l2_ctrl *audio_present_ctrl;
+	struct v4l2_ctrl *rgb_quantization_range_ctrl;
+	struct v4l2_ctrl *splitter_width_ctrl;
+	struct v4l2_ctrl *test_pattern_ctrl;
+
+	struct delayed_work delayed_work_enable_hotplug;
+	struct delayed_work delayed_work_enable_format;
+
+	/* edid  */
+	u8 edid_blocks_written;
+
+	/* timing / mbus */
+	struct v4l2_dv_timings timings;
+	struct v4l2_dv_timings detected_timings;
+	u32 mbus_fmt_code;
+	u32 rgb_quantization_range;
+};
+
+static inline struct tc358840_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tc358840_state, sd);
+}
+
+
+static void tc358840_enable_interrupts(
+	struct v4l2_subdev *sd, bool cable_connected);
+static int tc358840_s_ctrl_detect_tx_5v(struct v4l2_subdev *sd);
+static void tc358840_init_interrupts(struct v4l2_subdev *sd);
+static int tc358840_s_dv_timings(
+	struct v4l2_subdev *sd, struct v4l2_dv_timings *timings);
+static void tc358840_set_csi(struct v4l2_subdev *sd);
+static void tc358840_set_splitter(struct v4l2_subdev *sd);
+static int tc358840_set_test_pattern_timing(struct v4l2_subdev *sd,
+	struct v4l2_dv_timings *timings);
+static int get_test_pattern_timing(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings *timings);
+
+/* --------------- I2C --------------- */
+
+static void i2c_rd(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct i2c_client *client = state->i2c_client;
+	int err;
+	u8 buf[2] = { reg >> 8, reg & 0xff };
+	struct i2c_msg msgs[] = {
+		{
+			.addr = client->addr,
+			.flags = 0,
+			.len = 2,
+			.buf = buf,
+		},
+		{
+			.addr = client->addr,
+			.flags = I2C_M_RD,
+			.len = n,
+			.buf = values,
+		},
+	};
+
+	err = i2c_transfer(client->adapter, msgs, ARRAY_SIZE(msgs));
+	if (err != ARRAY_SIZE(msgs)) {
+		v4l2_err(sd, "%s: reading register 0x%x from 0x%x failed\n",
+			__func__, reg, client->addr);
+	}
+
+	if (debug < 3)
+		return;
+
+	switch (n) {
+	case 1:
+		v4l2_info(sd, "I2C read 0x%04X = 0x%02X\n", reg, values[0]);
+		break;
+	case 2:
+		v4l2_info(sd, "I2C read 0x%04X = 0x%02X%02X\n",
+			reg, values[1], values[0]);
+		break;
+	case 4:
+		v4l2_info(sd, "I2C read 0x%04X = 0x%02X%02X%02X%02X\n",
+			reg, values[3], values[2], values[1], values[0]);
+		break;
+	default:
+		v4l2_info(sd, "I2C read %d bytes from address 0x%04X\n",
+			n, reg);
+		break;
+	}
+
+}
+
+static void i2c_wr(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct i2c_client *client = state->i2c_client;
+	int err, i;
+	struct i2c_msg msg;
+	u8 data[I2C_MAX_XFER_SIZE];
+
+	if ((2 + n) > I2C_MAX_XFER_SIZE) {
+		v4l2_warn(sd, "i2c wr reg=%04x: len=%d is too big!\n",
+			  reg, 2 + n);
+		n = I2C_MAX_XFER_SIZE - 2;
+	}
+
+	msg.addr = client->addr;
+	msg.buf = data;
+	msg.len = 2 + n;
+	msg.flags = 0;
+
+	data[0] = reg >> 8;
+	data[1] = reg & 0xff;
+
+	for (i = 0; i < n; i++)
+		data[2 + i] = values[i];
+
+	err = i2c_transfer(client->adapter, &msg, 1);
+	if (err != 1) {
+		v4l2_err(sd, "%s: writing register 0x%x from 0x%x failed\n",
+			__func__, reg, client->addr);
+		return;
+	}
+
+	if (debug < 3)
+		return;
+
+	switch (n) {
+	case 1:
+		v4l2_info(sd, "I2C write 0x%04X = 0x%02X\n", reg, data[2]);
+		break;
+	case 2:
+		v4l2_info(sd, "I2C write 0x%04X = 0x%02X%02X\n",
+			reg, data[3], data[2]);
+		break;
+	case 4:
+		v4l2_info(sd, "I2C write 0x%04X = 0x%02X%02X%02X%02X\n",
+			reg, data[5], data[4], data[3], data[2]);
+		break;
+	default:
+		v4l2_info(sd, "I2C write %d bytes from address 0x%04X\n",
+			n, reg);
+	}
+}
+
+static u8 i2c_rd8(struct v4l2_subdev *sd, u16 reg)
+{
+	u8 val;
+
+	i2c_rd(sd, reg, &val, 1);
+
+	return val;
+}
+
+static void i2c_wr8(struct v4l2_subdev *sd, u16 reg, u8 val)
+{
+	i2c_wr(sd, reg, &val, 1);
+}
+
+static void i2c_wr8_and_or(struct v4l2_subdev *sd, u16 reg,
+		u8 mask, u8 val)
+{
+	i2c_wr8(sd, reg, (i2c_rd8(sd, reg) & mask) | val);
+}
+
+static u16 i2c_rd16(struct v4l2_subdev *sd, u16 reg)
+{
+	u16 val;
+
+	i2c_rd(sd, reg, (u8 *)&val, 2);
+
+	return val;
+}
+
+static void i2c_wr16(struct v4l2_subdev *sd, u16 reg, u16 val)
+{
+	i2c_wr(sd, reg, (u8 *)&val, 2);
+}
+
+static void i2c_wr16_and_or(struct v4l2_subdev *sd, u16 reg, u16 mask, u16 val)
+{
+	i2c_wr16(sd, reg, (i2c_rd16(sd, reg) & mask) | val);
+}
+
+static u32 i2c_rd32(struct v4l2_subdev *sd, u16 reg)
+{
+	u32 val;
+
+	i2c_rd(sd, reg, (u8 *)&val, 4);
+
+	return val;
+}
+
+static void i2c_wr32(struct v4l2_subdev *sd, u16 reg, u32 val)
+{
+	i2c_wr(sd, reg, (u8 *)&val, 4);
+}
+
+static void i2c_wr32_and_or(struct v4l2_subdev *sd, u32 reg, u32 mask, u32 val)
+{
+	i2c_wr32(sd, reg, (i2c_rd32(sd, reg) & mask) | val);
+}
+
+/* --------------- STATUS --------------- */
+
+static inline bool is_hdmi(struct v4l2_subdev *sd)
+{
+	return i2c_rd8(sd, SYS_STATUS) & MASK_S_HDMI;
+}
+
+static inline bool tx_5v_power_present(struct v4l2_subdev *sd)
+{
+	return i2c_rd8(sd, SYS_STATUS) & MASK_S_DDC5V;
+}
+
+static inline bool no_signal(struct v4l2_subdev *sd)
+{
+	return !(i2c_rd8(sd, SYS_STATUS) & MASK_S_TMDS);
+}
+
+static inline bool no_sync(struct v4l2_subdev *sd)
+{
+	return !(i2c_rd8(sd, SYS_STATUS) & MASK_S_SYNC);
+}
+
+static inline bool audio_present(struct v4l2_subdev *sd)
+{
+	return i2c_rd8(sd, AU_STATUS0) & MASK_S_A_SAMPLE;
+}
+
+static int get_audio_sampling_rate(struct v4l2_subdev *sd)
+{
+	static const int code_to_rate[] = {
+		44100, 0, 48000, 32000, 22050, 384000, 24000, 352800,
+		88200, 768000, 96000, 705600, 176400, 0, 192000, 0
+	};
+
+	/* Register FS_SET is not cleared when the cable is disconnected */
+	if (no_signal(sd))
+		return 0;
+
+	return code_to_rate[i2c_rd8(sd, FS_SET) & MASK_FS];
+}
+
+static unsigned int tc358840_num_csi_lanes_in_use(struct v4l2_subdev *sd)
+{
+	/* FIXME: Read # of lanes from both, TX0 and TX1 */
+	return i2c_rd32(sd, CSITX0_BASE_ADDR+LANEEN) & MASK_LANES;
+}
+
+/* --------------- TIMINGS --------------- */
+
+static inline unsigned int fps(const struct v4l2_bt_timings *t)
+{
+	if (!V4L2_DV_BT_FRAME_HEIGHT(t) || !V4L2_DV_BT_FRAME_WIDTH(t))
+		return 0;
+
+	return DIV_ROUND_CLOSEST((unsigned int)t->pixelclock,
+			V4L2_DV_BT_FRAME_HEIGHT(t) * V4L2_DV_BT_FRAME_WIDTH(t));
+}
+
+static int tc358840_get_detected_timings(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings *timings)
+{
+	struct v4l2_bt_timings *bt = &timings->bt;
+	struct tc358840_state *state = to_state(sd);
+	unsigned int width, height, frame_width, frame_height, frame_interval;
+	unsigned int fps, pol;
+
+	memset(timings, 0, sizeof(struct v4l2_dv_timings));
+
+	if (state->test_pattern)
+		return get_test_pattern_timing(sd, timings);
+
+	if (no_signal(sd)) {
+		v4l2_dbg(1, debug, sd, "%s: no valid signal\n", __func__);
+		return -ENOLINK;
+	}
+	if (no_sync(sd)) {
+		v4l2_dbg(1, debug, sd, "%s: no sync on signal\n", __func__);
+		return -ENOLCK;
+	}
+
+	timings->type = V4L2_DV_BT_656_1120;
+
+	bt->interlaced = i2c_rd8(sd, VI_STATUS1) &
+		MASK_S_V_INTERLACE ? V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
+
+	width = ((i2c_rd8(sd, DE_HSIZE_HI) & 0x1f) << 8) +
+		i2c_rd8(sd, DE_HSIZE_LO);
+	height = ((i2c_rd8(sd, DE_VSIZE_HI) & 0x1f) << 8) +
+		i2c_rd8(sd, DE_VSIZE_LO);
+	frame_width = ((i2c_rd8(sd, IN_HSIZE_HI) & 0x1f) << 8) +
+		i2c_rd8(sd, IN_HSIZE_LO);
+	frame_height = (((i2c_rd8(sd, IN_VSIZE_HI) & 0x3f) << 8) +
+		i2c_rd8(sd, IN_VSIZE_LO)) / 2;
+	pol = i2c_rd8(sd, CLK_STATUS);
+
+	/*
+	 * Frame interval in milliseconds * 10
+	 * Require SYS_FREQ0 and SYS_FREQ1 are precisely set
+	 */
+	frame_interval = ((i2c_rd8(sd, FV_CNT_HI) & 0x3) << 8) +
+		i2c_rd8(sd, FV_CNT_LO);
+	fps = (frame_interval > 0) ?
+		DIV_ROUND_CLOSEST(10000, frame_interval) : 0;
+
+	bt->width = width;
+	bt->height = height;
+	bt->vsync = frame_height - height;
+	bt->hsync = frame_width - width;
+	bt->pixelclock = frame_width * frame_height * fps;
+	if (pol & MASK_S_V_HPOL)
+		bt->polarities |= V4L2_DV_HSYNC_POS_POL;
+	if (pol & MASK_S_V_VPOL)
+		bt->polarities |= V4L2_DV_VSYNC_POS_POL;
+	if (bt->interlaced == V4L2_DV_INTERLACED) {
+		bt->height *= 2;
+		bt->il_vsync = bt->vsync + 1;
+		bt->pixelclock /= 2;
+	}
+	/* Sanity check */
+	if (bt->width < 640 || bt->height < 480 ||
+	    (bt->width & 1) || (bt->height & 1) ||
+	    (frame_width & 1) || (frame_width <= width) ||
+	    (frame_height <= height))
+		return -ENOLCK;
+
+	return 0;
+}
+
+/* --------------- HOTPLUG / HDCP / EDID --------------- */
+
+static void tc358840_delayed_work_enable_hotplug(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct tc358840_state *state = container_of(dwork,
+		struct tc358840_state, delayed_work_enable_hotplug);
+	struct v4l2_subdev *sd = &state->sd;
+
+	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
+
+	i2c_wr8_and_or(sd, HPD_CTL, ~MASK_HPD_OUT0, MASK_HPD_OUT0);
+}
+
+static void tc358840_set_hdmi_hdcp(struct v4l2_subdev *sd, bool enable)
+{
+	v4l2_dbg(2, debug, sd, "%s: %s\n", __func__, enable ?
+				"enable" : "disable");
+
+	i2c_wr8_and_or(sd, HDCP_REG1,
+			~(MASK_AUTH_UNAUTH_SEL | MASK_AUTH_UNAUTH),
+			MASK_AUTH_UNAUTH_SEL_16_FRAMES | MASK_AUTH_UNAUTH_AUTO);
+
+	i2c_wr8_and_or(sd, HDCP_REG2, ~MASK_AUTO_P3_RESET,
+			SET_AUTO_P3_RESET_FRAMES(0x0f));
+
+	/*
+	 * HDCP is disabled by configuring the receiver as HDCP repeater. The
+	 * repeater mode require software support to work, so HDCP
+	 * authentication will fail.
+	 */
+	i2c_wr8_and_or(sd, HDCP_REG3, ~KEY_RD_CMD, enable ? KEY_RD_CMD : 0);
+	i2c_wr8_and_or(sd, HDCP_MODE, ~(MASK_AUTO_CLR | MASK_MODE_RST_TN),
+			enable ?  (MASK_AUTO_CLR | MASK_MODE_RST_TN) : 0);
+
+	/* Apple MacBook Pro gen.8 has a bug that makes it freeze every fifth
+	 * second when HDCP is disabled, but the MAX_EXCED bit is handled
+	 * correctly and HDCP is disabled on the HDMI output.
+	 */
+	i2c_wr8_and_or(sd, BSTATUS1, ~MASK_MAX_EXCED,
+			enable ? 0 : MASK_MAX_EXCED);
+	i2c_wr8_and_or(sd, BCAPS, ~(MASK_REPEATER | MASK_READY),
+			enable ? 0 : MASK_REPEATER | MASK_READY);
+}
+
+static void tc358840_disable_edid(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
+
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
+
+	/*
+	 * DDC access to EDID is also disabled when hotplug is disabled. See
+	 * register DDC_CTL
+	 */
+	i2c_wr8_and_or(sd, HPD_CTL, ~MASK_HPD_OUT0, 0x0);
+}
+
+static void tc358840_enable_edid(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	if (state->edid_blocks_written == 0) {
+		v4l2_dbg(2, debug, sd, "%s: no EDID -> no hotplug\n", __func__);
+		tc358840_s_ctrl_detect_tx_5v(sd);
+		return;
+	}
+
+	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
+
+	/*
+	 * Enable hotplug after 100 ms. DDC access to EDID is also enabled when
+	 * hotplug is enabled. See register DDC_CTL
+	 */
+	schedule_delayed_work(&state->delayed_work_enable_hotplug, HZ / 10);
+
+	tc358840_enable_interrupts(sd, true);
+	tc358840_s_ctrl_detect_tx_5v(sd);
+}
+
+static void tc358840_erase_bksv(struct v4l2_subdev *sd)
+{
+	int i;
+
+	for (i = 0; i < 5; i++)
+		i2c_wr8(sd, BKSV + i, 0);
+}
+
+/* --------------- infoframe --------------- */
+
+static void print_infoframe(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+	union hdmi_infoframe frame;
+	u8 buffer[HDMI_INFOFRAME_SIZE(SPD)];
+
+	if (!is_hdmi(sd)) {
+		v4l2_info(sd, "DVI-D signal - InfoFrames not supported\n");
+		return;
+	}
+
+	i2c_rd(sd, PK_AVI_0HEAD, buffer, HDMI_INFOFRAME_SIZE(AVI));
+
+	if (hdmi_infoframe_unpack(&frame, buffer) >= 0)
+		hdmi_infoframe_log(KERN_INFO, dev, &frame);
+
+	/*
+	 * Both the SPD and the Vendor Specific packet sizes are the
+	 * same for the tc358840. Since there is no HDMI_INFOFRAME_SIZE(VENDOR)
+	 * we use HDMI_INFOFRAME_SIZE(SPD) instead.
+	 */
+	i2c_rd(sd, PK_VS_0HEAD, buffer, HDMI_INFOFRAME_SIZE(SPD));
+
+	if (hdmi_infoframe_unpack(&frame, buffer) >= 0)
+		hdmi_infoframe_log(KERN_INFO, dev, &frame);
+
+	i2c_rd(sd, PK_SPD_0HEAD, buffer, HDMI_INFOFRAME_SIZE(SPD));
+
+	if (hdmi_infoframe_unpack(&frame, buffer) >= 0)
+		hdmi_infoframe_log(KERN_INFO, dev, &frame);
+}
+
+/* --------------- CTRLS --------------- */
+
+static int tc358840_s_ctrl_detect_tx_5v(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	if (state->test_pattern)
+		return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, true);
+
+	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
+		tx_5v_power_present(sd));
+}
+
+static int tc358840_s_ctrl_audio_sampling_rate(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	return v4l2_ctrl_s_ctrl(state->audio_sampling_rate_ctrl,
+			get_audio_sampling_rate(sd));
+}
+
+static int tc358840_s_ctrl_audio_present(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	return v4l2_ctrl_s_ctrl(state->audio_present_ctrl,
+			audio_present(sd));
+}
+
+static int tc358840_update_controls(struct v4l2_subdev *sd)
+{
+	int ret = 0;
+
+	ret |= tc358840_s_ctrl_detect_tx_5v(sd);
+	ret |= tc358840_s_ctrl_audio_sampling_rate(sd);
+	ret |= tc358840_s_ctrl_audio_present(sd);
+
+	return ret;
+}
+
+static void set_rgb_quantization_range(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	switch (state->rgb_quantization_range) {
+	case V4L2_DV_RGB_RANGE_AUTO:
+		i2c_wr8(sd, VOUT_CSC,
+			MASK_CSC_MODE_BUILTIN | MASK_COLOR_RGB_FULL);
+		break;
+	case V4L2_DV_RGB_RANGE_LIMITED:
+		i2c_wr8(sd, VOUT_CSC,
+			MASK_CSC_MODE_BUILTIN | MASK_COLOR_FULL_TO_LIMITED);
+		break;
+	case V4L2_DV_RGB_RANGE_FULL:
+		i2c_wr8(sd, VOUT_CSC,
+			MASK_CSC_MODE_BUILTIN | MASK_COLOR_LIMITED_TO_FULL);
+		break;
+	}
+}
+
+/* --------------- INIT --------------- */
+
+static void tc358840_reset_phy(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
+
+	i2c_wr8_and_or(sd, PHY_RST, ~MASK_RESET_CTRL, 0);
+	i2c_wr8_and_or(sd, PHY_RST, ~MASK_RESET_CTRL, MASK_RESET_CTRL);
+	state->new_fmt_cnt = 0;
+}
+
+static void tc358840_reset(struct v4l2_subdev *sd, u16 mask)
+{
+	u16 sysctl = i2c_rd16(sd, SYSCTL);
+
+	i2c_wr16(sd, SYSCTL, sysctl | mask);
+	i2c_wr16(sd, SYSCTL, sysctl & ~mask);
+}
+
+static inline void tc358840_sleep_mode(struct v4l2_subdev *sd, bool enable)
+{
+	v4l2_dbg(1, debug, sd, "%s(): %s\n", __func__,
+		enable ? "enable" : "disable");
+
+	i2c_wr16_and_or(sd, SYSCTL, ~MASK_SLEEP, enable ? MASK_SLEEP : 0);
+}
+
+static int enable_stream(struct v4l2_subdev *sd, bool enable)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct tc358840_platform_data *pdata = &state->pdata;
+
+	u32 sync_timeout_ctr;
+
+	v4l2_dbg(2, debug, sd, "%s: %sable\n", __func__, enable ? "en" : "dis");
+
+	if (enable == state->enabled)
+		goto out;
+
+	if (enable) {
+		if (pdata->endpoint.bus.mipi_csi2.flags &
+		    V4L2_MBUS_CSI2_NONCONTINUOUS_CLOCK) {
+			i2c_wr32_and_or(sd, FUNCMODE, ~(MASK_CONTCLKMODE),
+					MASK_FORCESTOP);
+		} else {
+			/*
+			 * It is critical for CSI receiver to see lane
+			 * transition LP11->HS. Set to non-continuous mode to
+			 * enable clock lane LP11 state.
+			 */
+			i2c_wr32_and_or(sd, FUNCMODE, ~(MASK_CONTCLKMODE), 0);
+			/*
+			 * Set to continuous mode to trigger LP11->HS
+			 * transition
+			 */
+			i2c_wr32_and_or(sd, FUNCMODE, 0, MASK_CONTCLKMODE);
+		}
+		/* Unmute video */
+		i2c_wr8(sd, VI_MUTE, MASK_AUTO_MUTE);
+		/* Signal end of initialization */
+		i2c_wr8(sd, INIT_END, MASK_INIT_END);
+
+		/* Enable testpattern, must use TX1 */
+		if (state->test_pattern)
+			i2c_wr16_and_or(sd, CB_CTL,
+					~(MASK_CB_EN | MASK_CB_CSEL),
+					MASK_CB_CSEL_CSI_TX1 | MASK_CB_EN);
+	} else {
+		/* Enable Registers to be initialized */
+		i2c_wr8_and_or(sd, INIT_END, ~(MASK_INIT_END), 0x00);
+
+		/*
+		 * Mute video so that all data lanes go to LSP11 state.
+		 * No data is output to CSI Tx block.
+		 */
+		i2c_wr8(sd, VI_MUTE, MASK_AUTO_MUTE | MASK_VI_MUTE);
+		tc358840_set_csi(sd);
+		tc358840_set_splitter(sd);
+		/* Always disable testpattern */
+		i2c_wr16_and_or(sd, CB_CTL, ~MASK_CB_EN, 0);
+	}
+
+	/* Wait for HDMI input to become stable */
+	if (enable && !state->test_pattern) {
+		sync_timeout_ctr = 100;
+		while (no_sync(sd) && sync_timeout_ctr)
+			sync_timeout_ctr--;
+
+		if (sync_timeout_ctr == 0) {
+			/* Disable stream again. Probably no cable inserted.. */
+			v4l2_err(sd, "%s: Timeout: HDMI input sync failed.\n",
+					__func__);
+			enable_stream(sd, false);
+			return -EIO;
+		}
+
+		v4l2_dbg(2, debug, sd,
+			"%s: Stream enabled! Remaining timeout attempts: %d\n",
+			__func__, sync_timeout_ctr);
+	}
+
+	mutex_lock(&state->confctl_mutex);
+	i2c_wr16_and_or(sd, CONFCTL0,
+		~(MASK_VTX0EN | MASK_VTX1EN | MASK_ABUFEN),
+		enable ? ((pdata->csi_port & (MASK_VTX0EN | MASK_VTX1EN)) |
+		MASK_ABUFEN | MASK_TX_MSEL | MASK_AUTOINDEX) :
+		(MASK_TX_MSEL | MASK_AUTOINDEX));
+	mutex_unlock(&state->confctl_mutex);
+	state->enabled = enable;
+out:
+	return 0;
+}
+
+static void tc358840_set_splitter(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	if (state->timings.bt.width <= 1920) {
+		i2c_wr16_and_or(sd, SPLITTX0_CTRL,
+				~(MASK_IFEN | MASK_LCD_CSEL), MASK_SPBP);
+		i2c_wr16_and_or(sd, SPLITTX1_CTRL,
+				~(MASK_IFEN | MASK_LCD_CSEL), MASK_SPBP);
+
+		i2c_wr16_and_or(sd, SPLITTX0_SPLIT,
+				(u16)~(MASK_TX1SEL | MASK_EHW), 0);
+	} else {
+		i2c_wr16_and_or(sd, SPLITTX0_CTRL,
+				~(MASK_IFEN | MASK_LCD_CSEL | MASK_SPBP), 0);
+		i2c_wr16_and_or(sd, SPLITTX1_CTRL,
+				~(MASK_IFEN | MASK_LCD_CSEL | MASK_SPBP), 0);
+
+		i2c_wr16_and_or(sd, SPLITTX0_SPLIT, ~(MASK_TX1SEL), MASK_EHW);
+	}
+}
+
+static int get_hsck_freq(struct tc358840_platform_data *pdata)
+{
+	int hsck = (pdata->refclk_hz / (pdata->pll_prd + 1) *
+		(pdata->pll_fbd + 1)) / (1 << pdata->pll_frs);
+	return hsck;
+}
+
+static void tc358840_set_pll(struct v4l2_subdev *sd,
+				enum tc358840_csi_port port)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct tc358840_platform_data *pdata = &state->pdata;
+	u16 base_addr;
+	u32 pllconf;
+
+	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
+
+	if (WARN_ON((pdata->csi_port <= CSI_TX_NONE) ||
+		    (pdata->csi_port > CSI_TX_BOTH)))
+		pdata->csi_port = CSI_TX_NONE;
+
+	if (pdata->csi_port == CSI_TX_NONE) {
+		v4l2_err(sd, "%s: No CSI port defined!\n", __func__);
+		return;
+	}
+
+	base_addr = (port == CSI_TX_0) ? CSITX0_BASE_ADDR :
+					CSITX1_BASE_ADDR;
+	pllconf = SET_PLL_PRD(pdata->pll_prd) | SET_PLL_FBD(pdata->pll_fbd) |
+		SET_PLL_FRS(pdata->pll_frs);
+
+	v4l2_dbg(1, debug, sd, "%s: Updating PLL clock of CSI TX%d, hsck=%d\n",
+			__func__, port-1, get_hsck_freq(pdata));
+
+	/* TODO: Set MP_LBW  ? */
+	i2c_wr32_and_or(sd, base_addr+PLLCONF,
+		~(MASK_PLL_PRD | MASK_PLL_FBD | MASK_PLL_FRS), pllconf);
+}
+
+static void tc358840_set_ref_clk(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct tc358840_platform_data *pdata = &state->pdata;
+
+	u32 sys_freq;
+	u32 lock_ref_freq;
+	u16 fh_min;
+	u16 fh_max;
+	u32 cec_freq;
+	u32 nco;
+	u16 csc;
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	if (WARN_ON((pdata->refclk_hz < 40000000) ||
+		    (pdata->refclk_hz > 50000000)))
+		pdata->refclk_hz = 42000000;
+
+	/* System Frequency */
+	sys_freq = pdata->refclk_hz / 10000;
+	i2c_wr8(sd, SYS_FREQ0, sys_freq & 0x00FF);
+	i2c_wr8(sd, SYS_FREQ1, (sys_freq & 0xFF00) >> 8);
+
+	/* Audio System Frequency */
+	lock_ref_freq = pdata->refclk_hz / 100;
+	i2c_wr8(sd, LOCK_REF_FREQA, lock_ref_freq & 0xFF);
+	i2c_wr8(sd, LOCK_REF_FREQB, (lock_ref_freq >> 8) & 0xFF);
+	i2c_wr8(sd, LOCK_REF_FREQC, (lock_ref_freq >> 16) & 0x0F);
+
+	/* Audio PLL */
+	i2c_wr8(sd, NCO_F0_MOD, MASK_NCO_F0_MOD_REG);
+	/* 6.144 * 2^28 = 1649267442 */
+	nco = (1649267442 / (pdata->refclk_hz / 1000000));
+	i2c_wr8(sd, NCO_48F0A, nco & 0xFF);
+	i2c_wr8(sd, NCO_48F0B, (nco >> 8) & 0xFF);
+	i2c_wr8(sd, NCO_48F0C, (nco >> 16) & 0xFF);
+	i2c_wr8(sd, NCO_48F0D, (nco >> 24) & 0xFF);
+	/* 5.6448 * 2^28 = 1515264462 */
+	nco = (1515264462 / (pdata->refclk_hz / 1000000));
+	i2c_wr8(sd, NCO_44F0A, nco & 0xFF);
+	i2c_wr8(sd, NCO_44F0B, (nco >> 8) & 0xFF);
+	i2c_wr8(sd, NCO_44F0C, (nco >> 16) & 0xFF);
+	i2c_wr8(sd, NCO_44F0D, (nco >> 24) & 0xFF);
+
+	fh_min = pdata->refclk_hz / 100000;
+	i2c_wr8(sd, FH_MIN0, fh_min & 0x00ff);
+	i2c_wr8(sd, FH_MIN1, (fh_min & 0xff00) >> 8);
+
+	fh_max = (fh_min * 66) / 10;
+	i2c_wr8(sd, FH_MAX0, fh_max & 0x00ff);
+	i2c_wr8(sd, FH_MAX1, (fh_max & 0xff00) >> 8);
+
+	/* Color Space Conversion */
+	csc = pdata->refclk_hz / 10000;
+	i2c_wr8(sd, SCLK_CSC0, csc & 0xFF);
+	i2c_wr8(sd, SCLK_CSC1, (csc >> 8) & 0xFF);
+
+	/*
+	 * Trial and error suggests that the default register value
+	 * of 656 is for a 42 MHz reference clock. Use that to derive
+	 * a new value based on the actual reference clock.
+	 */
+	cec_freq = (656 * sys_freq) / 4200;
+	i2c_wr16(sd, CECHCLK, cec_freq);
+	i2c_wr16(sd, CECLCLK, cec_freq);
+}
+
+static void tc358840_set_csi_mbus_config(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	switch (state->mbus_fmt_code) {
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+		v4l2_dbg(2, debug, sd, "%s: YCbCr 422 16-bit\n", __func__);
+
+		i2c_wr8(sd, VOUT_FMT, MASK_OUTFMT_422 | MASK_422FMT_NORMAL);
+		i2c_wr8(sd, VOUT_FIL, MASK_422FIL_3_TAP_444 |
+			MASK_444FIL_2_TAP);
+		i2c_wr8(sd, VOUT_SYNC0, MASK_MODE_2);
+		i2c_wr8(sd, VOUT_CSC, MASK_CSC_MODE_BUILTIN |
+			MASK_COLOR_601_YCBCR_LIMITED);
+		mutex_lock(&state->confctl_mutex);
+		i2c_wr16_and_or(sd, CONFCTL0, ~(MASK_YCBCRFMT),
+			MASK_YCBCRFMT_YCBCR422_8);
+		i2c_wr16(sd, CONFCTL1, 0x0);
+		mutex_unlock(&state->confctl_mutex);
+		break;
+
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		v4l2_dbg(2, debug, sd, "%s: RGB 888 24-bit\n", __func__);
+
+		i2c_wr8(sd, VOUT_FMT, MASK_OUTFMT_444_RGB);
+		i2c_wr8(sd, VOUT_FIL, MASK_422FIL_3_TAP_444 |
+			MASK_444FIL_2_TAP);
+		i2c_wr8(sd, VOUT_SYNC0, MASK_MODE_2);
+		i2c_wr8(sd, VOUT_CSC, MASK_CSC_MODE_BUILTIN |
+			MASK_COLOR_RGB_FULL);
+		set_rgb_quantization_range(sd);
+		mutex_lock(&state->confctl_mutex);
+		i2c_wr16_and_or(sd, CONFCTL0, ~(MASK_YCBCRFMT), 0x0);
+		i2c_wr16_and_or(sd, CONFCTL1, 0x0, MASK_TX_OUT_FMT_RGB888);
+		mutex_unlock(&state->confctl_mutex);
+		break;
+
+	default:
+		v4l2_dbg(2, debug, sd, "%s: Unsupported format code 0x%x\n",
+				__func__, state->mbus_fmt_code);
+		break;
+	}
+}
+
+static unsigned int tc358840_num_csi_lanes_needed(struct v4l2_subdev *sd)
+{
+	/* Always use 4 lanes for one CSI */
+	return 4;
+}
+
+static void tc358840_set_csi(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct tc358840_platform_data *pdata = &state->pdata;
+	unsigned int lanes = tc358840_num_csi_lanes_needed(sd);
+	enum tc358840_csi_port port;
+	u16 base_addr;
+
+	v4l2_dbg(3, debug, sd, "%s:\n", __func__);
+
+	tc358840_reset(sd, MASK_CTXRST);
+
+	for (port = CSI_TX_0; port <= CSI_TX_1; port++) {
+		base_addr = (port == CSI_TX_0) ? CSITX0_BASE_ADDR :
+						 CSITX1_BASE_ADDR;
+
+		/* Test pattern must use TX1: enable it if pattern is active */
+		if (pdata->csi_port != CSI_TX_BOTH &&
+		    pdata->csi_port != port &&
+		    !state->test_pattern) {
+			v4l2_dbg(1, debug, sd,
+				"%s: Disabling CSI TX%d\n", __func__, port-1);
+
+			/* Disable CSI lanes (High Z) */
+			i2c_wr32_and_or(sd, base_addr+LANEEN,
+				~(MASK_CLANEEN), 0);
+			continue;
+		}
+
+		v4l2_dbg(1, debug, sd,
+			"%s: Enabling CSI TX%d\n", __func__, port-1);
+
+		/* (0x0108) */
+		i2c_wr32(sd, base_addr+CSITX_CLKEN, MASK_CSITX_EN);
+		/*
+		 * PLL has to be enabled between CSITX_CLKEN and
+		 * LANEEN (0x02AC)
+		 */
+		tc358840_set_pll(sd, port);
+		/* (0x02A0) */
+		i2c_wr32_and_or(sd, base_addr+MIPICLKEN,
+			~(MASK_MP_CKEN), MASK_MP_ENABLE);
+		usleep_range(10000, 11000);
+		/* (0x02A0) */
+		i2c_wr32(sd, base_addr+MIPICLKEN,
+			MASK_MP_CKEN | MASK_MP_ENABLE);
+		/* (0x010C) */
+		i2c_wr32(sd, base_addr+PPICLKEN, MASK_HSTXCLKEN);
+		/* (0x0118) */
+		i2c_wr32(sd, base_addr+LANEEN,
+			(lanes & MASK_LANES) | MASK_CLANEEN);
+
+		/* (0x0120) */
+		i2c_wr32(sd, base_addr+LINEINITCNT, pdata->lineinitcnt);
+
+		/* (0x0254) */
+		i2c_wr32(sd, base_addr+LPTXTIMECNT, pdata->lptxtimecnt);
+		/* (0x0258) */
+		i2c_wr32(sd, base_addr+TCLK_HEADERCNT, pdata->tclk_headercnt);
+		/* (0x025C) */
+		i2c_wr32(sd, base_addr+TCLK_TRAILCNT, pdata->tclk_trailcnt);
+		/* (0x0260) */
+		i2c_wr32(sd, base_addr+THS_HEADERCNT, pdata->ths_headercnt);
+		/* (0x0264) */
+		i2c_wr32(sd, base_addr+TWAKEUP, pdata->twakeup);
+		/* (0x0268) */
+		i2c_wr32(sd, base_addr+TCLK_POSTCNT, pdata->tclk_postcnt);
+		/* (0x026C) */
+		i2c_wr32(sd, base_addr+THS_TRAILCNT, pdata->ths_trailcnt);
+		/* (0x0270) */
+		i2c_wr32(sd, base_addr+HSTXVREGCNT, pdata->hstxvregcnt);
+
+		/* (0x0274) */
+		i2c_wr32(sd, base_addr+HSTXVREGEN,
+			((lanes > 0) ? MASK_CLM_HSTXVREGEN : 0x0) |
+			((lanes > 0) ? MASK_D0M_HSTXVREGEN : 0x0) |
+			((lanes > 1) ? MASK_D1M_HSTXVREGEN : 0x0) |
+			((lanes > 2) ? MASK_D2M_HSTXVREGEN : 0x0) |
+			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
+
+		/*
+		 * Finishing configuration by setting CSITX to start
+		 * (0X011C)
+		 */
+		i2c_wr32(sd, base_addr+CSITX_START, 0x00000001);
+
+		i2c_rd32(sd, base_addr+CSITX_INTERNAL_STAT);
+	}
+}
+
+static void tc358840_set_hdmi_phy(struct v4l2_subdev *sd)
+{
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	/* Reset PHY */
+	tc358840_reset_phy(sd);
+
+	/* Enable PHY */
+	i2c_wr8_and_or(sd, PHY_ENB, ~MASK_ENABLE_PHY, 0x0);
+	i2c_wr8_and_or(sd, PHY_ENB, ~MASK_ENABLE_PHY, MASK_ENABLE_PHY);
+
+	/* Enable Audio PLL */
+	i2c_wr8(sd, APPL_CTL, MASK_APLL_CPCTL_NORMAL | MASK_APLL_ON);
+
+	/* Enable DDC IO */
+	i2c_wr8(sd, DDCIO_CTL, MASK_DDC_PWR_ON);
+}
+
+static void tc358840_set_hdmi_audio(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	i2c_wr8(sd, FORCE_MUTE, 0x00);
+	i2c_wr8(sd, AUTO_CMD0, MASK_AUTO_MUTE7 | MASK_AUTO_MUTE6 |
+			MASK_AUTO_MUTE5 | MASK_AUTO_MUTE4 |
+			MASK_AUTO_MUTE1 | MASK_AUTO_MUTE0);
+	i2c_wr8(sd, AUTO_CMD1, MASK_AUTO_MUTE9);
+	i2c_wr8(sd, AUTO_CMD2, MASK_AUTO_PLAY3 | MASK_AUTO_PLAY2);
+	i2c_wr8(sd, BUFINIT_START, SET_BUFINIT_START_MS(500));
+	i2c_wr8(sd, FS_MUTE, 0x00);
+	i2c_wr8(sd, FS_IMODE, MASK_NLPCM_SMODE | MASK_FS_SMODE);
+	i2c_wr8(sd, ACR_MODE, MASK_CTS_MODE);
+	i2c_wr8(sd, ACR_MDF0, MASK_ACR_L2MDF_1976_PPM | MASK_ACR_L1MDF_976_PPM);
+	i2c_wr8(sd, ACR_MDF1, MASK_ACR_L3MDF_3906_PPM);
+	/*
+	 * TODO: Set output data bit length (currently 24 bit, no rounding)
+	 */
+	i2c_wr8(sd, SDO_MODE1, MASK_SDO_FMT_I2S | (6 << 4));
+	i2c_wr8(sd, DIV_MODE, SET_DIV_DLY_MS(100));
+	mutex_lock(&state->confctl_mutex);
+	i2c_wr16_and_or(sd, CONFCTL0, 0xFFFF, MASK_AUDCHNUM_2 |
+			MASK_AUDOUTSEL_I2S | MASK_AUTOINDEX);
+	mutex_unlock(&state->confctl_mutex);
+}
+
+static void tc358840_set_test_pattern_type(struct v4l2_subdev *sd,
+					   int testpattern)
+{
+	u16 mask_type;
+
+	switch (testpattern) {
+	case TEST_PATTERN_COLOR_BAR:
+		mask_type = MASK_CB_TYPE_COLOR_BAR;
+		break;
+	case TEST_PATTERN_COLOR_CHECKER:
+		mask_type = MASK_CB_TYPE_COLOR_CHECKERS;
+		break;
+	default:
+		return;
+	}
+	i2c_wr16_and_or(sd, CB_CTL, ~MASK_CB_TYPE, mask_type);
+}
+
+static int tc358840_set_test_pattern_timing(struct v4l2_subdev *sd,
+	struct v4l2_dv_timings *timings)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct v4l2_bt_timings *bt;
+	int target_fps;
+	int clk = get_hsck_freq(&state->pdata);
+	int htot;
+	int frame_height;
+	int frame_width;
+	/* Concatenated value for bytes/pixel, bits/clk.. */
+	int clks_pr_pixel = 4;
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+	if (!timings)
+		return -ERANGE;
+	bt = &timings->bt;
+	target_fps = fps(bt);
+	if (!target_fps)
+		return -ERANGE;
+	frame_height = V4L2_DV_BT_FRAME_HEIGHT(bt);
+	if (!frame_height)
+		return -ERANGE;
+	htot = ((clk/frame_height) / target_fps) / clks_pr_pixel;
+
+	frame_width = V4L2_DV_BT_FRAME_WIDTH(bt);
+	v4l2_dbg(3, debug, sd, "%s():htot=%d\n", __func__, htot);
+	/*
+	 * If bandwidth is too small: Keep timings, lower the fps
+	 */
+	if (htot < frame_width) {
+		htot = frame_width;
+		target_fps = (clk / frame_height) / (htot * clks_pr_pixel);
+		v4l2_err(sd, "%s(): Bandwidth too small, fps will be %d\n",
+			__func__, target_fps);
+	}
+
+	i2c_wr16(sd, CB_HSW, bt->hsync);
+	i2c_wr16(sd, CB_VSW, bt->vsync);
+	i2c_wr16(sd, CB_HTOTAL, htot);
+	i2c_wr16(sd, CB_VTOTAL, frame_height);
+	i2c_wr16(sd, CB_HACT, bt->width);
+	i2c_wr16(sd, CB_VACT, bt->height);
+	i2c_wr16(sd, CB_HSTART, bt->hbackporch);
+	i2c_wr16(sd, CB_VSTART, bt->vbackporch);
+
+	return 0;
+}
+
+static int get_test_pattern_timing(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings *timings)
+{
+	/* Return timings last set */
+	struct tc358840_state *state = to_state(sd);
+	*timings = state->timings;
+	return 0;
+}
+
+static void tc358840_initial_setup(struct v4l2_subdev *sd)
+{
+	static struct v4l2_dv_timings default_timing =
+		V4L2_DV_BT_CEA_1920X1080P60;
+	struct tc358840_state *state = to_state(sd);
+	struct tc358840_platform_data *pdata = &state->pdata;
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	/* *** Reset *** */
+	enable_stream(sd, false);
+
+	tc358840_sleep_mode(sd, false);
+	tc358840_reset(sd, MASK_RESET_ALL);
+
+	tc358840_init_interrupts(sd);
+
+	/* *** Init CSI *** */
+	tc358840_s_dv_timings(sd, &default_timing);
+
+	tc358840_set_ref_clk(sd);
+
+	i2c_wr8_and_or(sd, DDC_CTL, ~MASK_DDC5V_MODE,
+		       pdata->ddc5v_delay & MASK_DDC5V_MODE);
+
+	i2c_wr8_and_or(sd, EDID_MODE, ~MASK_EDID_MODE_ALL, MASK_RAM_EDDC);
+
+	i2c_wr8_and_or(sd, HPD_CTL, ~MASK_HPD_CTL0, 0);
+
+	tc358840_set_hdmi_phy(sd);
+
+	tc358840_set_hdmi_hdcp(sd, pdata->enable_hdcp);
+	tc358840_set_hdmi_audio(sd);
+
+	/* All CE and IT formats are detected as RGB full range in DVI mode */
+	i2c_wr8_and_or(sd, VI_MODE, ~MASK_RGB_DVI, 0);
+}
+
+/* --------------- CEC --------------- */
+
+#if IS_ENABLED(CONFIG_VIDEO_TC358840_CEC)
+
+static int tc358840_cec_adap_enable(struct cec_adapter *adap, bool enable)
+{
+	struct tc358840_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+
+	i2c_wr32(sd, CECIMSK, enable ? MASK_CECTIM | MASK_CECRIM : 0);
+	i2c_wr32(sd, CECICLR, MASK_CECTICLR | MASK_CECRICLR);
+	i2c_wr32(sd, CECEN, enable);
+	if (enable)
+		i2c_wr32(sd, CECREN, MASK_CECREN);
+	return 0;
+}
+
+static int tc358840_cec_adap_monitor_all_enable(struct cec_adapter *adap,
+						bool enable)
+{
+	struct tc358840_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	u32 reg;
+
+	reg = i2c_rd32(sd, CECRCTL1);
+	if (enable)
+		reg |= MASK_CECOTH;
+	else
+		reg &= ~MASK_CECOTH;
+	i2c_wr32(sd, CECRCTL1, reg);
+	return 0;
+}
+
+static int tc358840_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
+{
+	struct tc358840_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned int la = 0;
+
+	if (log_addr != CEC_LOG_ADDR_INVALID) {
+		la = i2c_rd32(sd, CECADD);
+		la |= 1 << log_addr;
+	}
+	i2c_wr32(sd, CECADD, la);
+	return 0;
+}
+
+static int tc358840_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
+				   u32 signal_free_time, struct cec_msg *msg)
+{
+	struct tc358840_state *state = adap->priv;
+	struct v4l2_subdev *sd = &state->sd;
+	unsigned int i;
+
+	i2c_wr32(sd, CECTCTL,
+		 (cec_msg_is_broadcast(msg) ? MASK_CECBRD : 0) |
+		 (signal_free_time - 1));
+	for (i = 0; i < msg->len; i++)
+		i2c_wr32(sd, CECTBUF1 + i * 4,
+			msg->msg[i] | ((i == msg->len - 1) ? MASK_CECTEOM : 0));
+	i2c_wr32(sd, CECTEN, MASK_CECTEN);
+	return 0;
+}
+
+static const struct cec_adap_ops tc358840_cec_adap_ops = {
+	.adap_enable = tc358840_cec_adap_enable,
+	.adap_log_addr = tc358840_cec_adap_log_addr,
+	.adap_transmit = tc358840_cec_adap_transmit,
+	.adap_monitor_all_enable = tc358840_cec_adap_monitor_all_enable,
+};
+
+#endif
+
+static bool tc358840_match_dv_timings(const struct v4l2_dv_timings *t1,
+				      const struct v4l2_dv_timings *t2,
+				      unsigned int pclock_delta)
+{
+	if (t1->type != t2->type || t1->type != V4L2_DV_BT_656_1120)
+		return false;
+	if (t1->bt.width == t2->bt.width &&
+	    t1->bt.height == t2->bt.height &&
+	    t1->bt.interlaced == t2->bt.interlaced &&
+	    t1->bt.polarities == t2->bt.polarities &&
+	    t1->bt.pixelclock >= t2->bt.pixelclock - pclock_delta &&
+	    t1->bt.pixelclock <= t2->bt.pixelclock + pclock_delta &&
+	    V4L2_DV_BT_BLANKING_WIDTH(&t1->bt) ==
+	    V4L2_DV_BT_BLANKING_WIDTH(&t2->bt) &&
+	    V4L2_DV_BT_BLANKING_HEIGHT(&t1->bt) ==
+	    V4L2_DV_BT_BLANKING_HEIGHT(&t2->bt))
+		return true;
+	return false;
+}
+/* --------------- IRQ --------------- */
+
+static const struct v4l2_event tc358840_ev_fmt = {
+	.type = V4L2_EVENT_SOURCE_CHANGE,
+	.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+};
+
+static void tc358840_delayed_work_enable_format(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct tc358840_state *state = container_of(dwork,
+		struct tc358840_state, delayed_work_enable_format);
+	struct v4l2_subdev *sd = &state->sd;
+
+	if (!state->found_signal)
+		return;
+
+	v4l2_dbg(1, debug, sd, "event: resolution change %ux%u\n",
+		 state->detected_timings.bt.width,
+		 state->detected_timings.bt.height);
+
+	state->found_stable_signal = true;
+	v4l2_subdev_notify_event(sd, &tc358840_ev_fmt);
+}
+
+static void tc358840_format_change(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct v4l2_dv_timings timings;
+	bool unchanged;
+
+	if (tc358840_get_detected_timings(sd, &timings)) {
+		enable_stream(sd, false);
+
+		if (!state->found_signal)
+			return;
+		state->found_signal = false;
+		state->found_stable_signal = false;
+		cancel_delayed_work(&state->delayed_work_enable_format);
+		state->new_fmt_cnt = 0;
+		v4l2_subdev_notify_event(sd, &tc358840_ev_fmt);
+		v4l2_dbg(1, debug, sd, "%s: No Signal\n", __func__);
+		return;
+	}
+
+	unchanged = tc358840_match_dv_timings(&state->timings,
+					      &timings, 250000);
+
+	if (!unchanged)
+		enable_stream(sd, false);
+
+	if (state->found_signal) {
+		if (state->new_fmt_cnt++ >= 4) {
+			tc358840_reset_phy(sd);
+			tc358840_erase_bksv(sd);
+			cancel_delayed_work(&state->delayed_work_enable_format);
+			return;
+		}
+		unchanged = tc358840_match_dv_timings(&state->detected_timings,
+						      &timings, 0);
+	}
+
+	if (state->found_signal && unchanged)
+		return;
+	state->found_signal = true;
+	state->found_stable_signal = false;
+	state->detected_timings = timings;
+	v4l2_print_dv_timings(sd->name,
+			      "new timings detected: ", &timings, debug);
+
+	cancel_delayed_work(&state->delayed_work_enable_format);
+	schedule_delayed_work(&state->delayed_work_enable_format, HZ);
+}
+
+static void tc358840_init_interrupts(struct v4l2_subdev *sd)
+{
+	u16 i;
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	i2c_wr16(sd, INTMASK, MASK_INT_STATUS_MASK_ALL);
+
+	/* clear interrupt status registers */
+	for (i = SYS_INT; i <= MISC_INT; i++) {
+		/* No interrupt register at Address 0x850A */
+		if (i != 0x850A) {
+			/* Mask interrupts */
+			i2c_wr8(sd, i + 0x10, 0xFF);
+			/* Clear any pending interrupts */
+			i2c_wr8(sd, i, 0xFF);
+		}
+	}
+
+	/* Clear any pending interrupts */
+	i2c_wr16(sd, INTSTATUS, MASK_INT_STATUS_MASK_ALL);
+}
+
+static void tc358840_enable_interrupts(struct v4l2_subdev *sd,
+		bool cable_connected)
+{
+	v4l2_dbg(2, debug, sd, "%s: cable connected = %d\n", __func__,
+			cable_connected);
+
+	if (cable_connected) {
+		i2c_wr8(sd, SYS_INTM, ~(MASK_DDC | MASK_DVI |
+					MASK_HDMI) & 0xFF);
+		if (no_signal(sd) || no_sync(sd)) {
+			i2c_wr8(sd, CLK_INTM, 0xFF);
+			i2c_wr8(sd, CBIT_INTM,
+				~(MASK_AF_LOCK | MASK_AF_UNLOCK) & 0xFF);
+			i2c_wr8(sd, AUDIO_INTM, 0xFF);
+		} else {
+			i2c_wr8(sd, CLK_INTM, ~MASK_IN_DE_CHG);
+			i2c_wr8(sd, CBIT_INTM, ~(MASK_CBIT_FS | MASK_AF_LOCK |
+						 MASK_AF_UNLOCK) & 0xFF);
+			i2c_wr8(sd, AUDIO_INTM, ~MASK_BUFINIT_END);
+		}
+		i2c_wr8(sd, MISC_INTM, ~MASK_SYNC_CHG);
+	} else {
+		i2c_wr8(sd, SYS_INTM, ~MASK_DDC & 0xFF);
+		i2c_wr8(sd, CLK_INTM, 0xFF);
+		i2c_wr8(sd, CBIT_INTM, 0xFF);
+		i2c_wr8(sd, AUDIO_INTM, 0xFF);
+		i2c_wr8(sd, MISC_INTM, 0xFF);
+	}
+}
+
+static void tc358840_hdmi_audio_int_handler(struct v4l2_subdev *sd,
+		bool *handled)
+{
+	u8 audio_int_mask = i2c_rd8(sd, AUDIO_INTM);
+	u8 audio_int = i2c_rd8(sd, AUDIO_INT);
+
+	i2c_wr8(sd, AUDIO_INT, audio_int);
+	audio_int &= ~audio_int_mask;
+
+	v4l2_dbg(3, debug, sd, "%s: AUDIO_INT = 0x%02x\n", __func__, audio_int);
+
+	if (audio_int & MASK_BUFINIT_END) {
+		v4l2_dbg(1, debug, sd, "%s: Audio BUFINIT_END\n", __func__);
+		tc358840_s_ctrl_audio_sampling_rate(sd);
+		tc358840_s_ctrl_audio_present(sd);
+		audio_int &= ~MASK_BUFINIT_END;
+		if (handled)
+			*handled = true;
+	}
+
+	if (audio_int) {
+		v4l2_err(sd, "%s: Unhandled AUDIO_INT interrupts: 0x%02x\n",
+				__func__, audio_int);
+	}
+}
+
+static void tc358840_hdmi_misc_int_handler(struct v4l2_subdev *sd,
+		bool *handled)
+{
+	struct tc358840_state *state = to_state(sd);
+	u8 misc_int_mask = i2c_rd8(sd, MISC_INTM);
+	u8 misc_int = i2c_rd8(sd, MISC_INT);
+
+	i2c_wr8(sd, MISC_INT, misc_int);
+	misc_int &= ~misc_int_mask;
+
+	v4l2_dbg(3, debug, sd, "%s: MISC_INT = 0x%02x\n", __func__, misc_int);
+
+	if (misc_int & MASK_SYNC_CHG) {
+		state->format_changed |= 1 << 0;
+
+		v4l2_dbg(1, debug, sd, "%s: sync change\n", __func__);
+		misc_int &= ~MASK_SYNC_CHG;
+		if (handled)
+			*handled = true;
+	}
+
+	if (misc_int) {
+		v4l2_err(sd, "%s: Unhandled MISC_INT interrupts: 0x%02x\n",
+				__func__, misc_int);
+	}
+}
+
+static void tc358840_hdmi_cbit_int_handler(struct v4l2_subdev *sd,
+		bool *handled)
+{
+	u8 cbit_int_mask = i2c_rd8(sd, CBIT_INTM);
+	u8 cbit_int = i2c_rd8(sd, CBIT_INT);
+
+	i2c_wr8(sd, CBIT_INT, cbit_int);
+	cbit_int &= ~cbit_int_mask;
+
+	v4l2_dbg(3, debug, sd, "%s: CBIT_INT = 0x%02x\n", __func__, cbit_int);
+
+	if (cbit_int & MASK_CBIT_FS) {
+		v4l2_dbg(1, debug, sd, "%s: Audio sample rate changed\n",
+				__func__);
+		tc358840_s_ctrl_audio_sampling_rate(sd);
+
+		cbit_int &= ~MASK_CBIT_FS;
+		if (handled)
+			*handled = true;
+	}
+
+	if (cbit_int & (MASK_AF_LOCK | MASK_AF_UNLOCK)) {
+
+		v4l2_dbg(1, debug, sd, "%s: Audio present changed\n",
+				__func__);
+		tc358840_s_ctrl_audio_present(sd);
+
+		cbit_int &= ~(MASK_AF_LOCK | MASK_AF_UNLOCK);
+		if (handled)
+			*handled = true;
+	}
+
+	if (cbit_int) {
+		v4l2_err(sd, "%s: Unhandled CBIT_INT interrupts: 0x%02x\n",
+				__func__, cbit_int);
+	}
+}
+
+static void tc358840_hdmi_clk_int_handler(struct v4l2_subdev *sd, bool *handled)
+{
+	struct tc358840_state *state = to_state(sd);
+	u8 clk_int_mask = i2c_rd8(sd, CLK_INTM);
+	u8 clk_int = i2c_rd8(sd, CLK_INT);
+
+	/* Bit 7 and bit 6 are set even when they are masked */
+	i2c_wr8(sd, CLK_INT, clk_int | 0x80 | MASK_OUT_H_CHG);
+	clk_int &= ~clk_int_mask;
+
+	v4l2_dbg(3, debug, sd, "%s: CLK_INT = 0x%02x\n", __func__, clk_int);
+
+	if (clk_int & (MASK_IN_DE_CHG)) {
+
+		v4l2_dbg(1, debug, sd, "%s: DE size or position has changed\n",
+				__func__);
+
+		/* TODO: Check if also true for tc358840 */
+
+		/*
+		 * If the source switch to a new resolution with the same pixel
+		 * frequency as the existing (e.g. 1080p25 -> 720p50), the
+		 * I_SYNC_CHG interrupt is not always triggered, while the
+		 * I_IN_DE_CHG interrupt seems to work fine. FMT_CHANGE
+		 * notifications are only sent when the signal is stable to
+		 * reduce the number of notifications.
+		 */
+		if (!no_signal(sd) && !no_sync(sd))
+			state->format_changed |= 1 << 1;
+
+		clk_int &= ~MASK_IN_DE_CHG;
+		if (handled)
+			*handled = true;
+	}
+
+	if (clk_int) {
+		v4l2_err(sd, "%s: Unhandled CLK_INT interrupts: 0x%02x\n",
+				__func__, clk_int);
+	}
+}
+
+static void tc358840_hdmi_sys_int_handler(struct v4l2_subdev *sd, bool *handled)
+{
+	struct tc358840_state *state = to_state(sd);
+	u8 sys_int_mask = i2c_rd8(sd, SYS_INTM);
+	u8 sys_int = i2c_rd8(sd, SYS_INT);
+
+	i2c_wr8(sd, SYS_INT, sys_int);
+	sys_int &= ~sys_int_mask;
+
+	v4l2_dbg(3, debug, sd, "%s: SYS_INT = 0x%02x\n", __func__, sys_int);
+
+	if (sys_int & MASK_DDC) {
+		bool tx_5v = tx_5v_power_present(sd);
+
+		v4l2_dbg(1, debug, sd, "%s: Tx 5V power present: %s\n",
+				__func__, tx_5v ?  "yes" : "no");
+
+		if (tx_5v) {
+			tc358840_enable_edid(sd);
+		} else {
+			tc358840_enable_interrupts(sd, false);
+			tc358840_disable_edid(sd);
+			memset(&state->timings, 0, sizeof(state->timings));
+			tc358840_erase_bksv(sd);
+			tc358840_update_controls(sd);
+		}
+
+		sys_int &= ~MASK_DDC;
+		if (handled)
+			*handled = true;
+	}
+
+	if (sys_int & MASK_DVI) {
+		v4l2_dbg(1, debug, sd, "%s: HDMI->DVI change detected\n",
+				__func__);
+
+		if (no_sync(sd) || no_signal(sd))
+			state->format_changed |= 1 << 2;
+
+		sys_int &= ~MASK_DVI;
+		if (handled)
+			*handled = true;
+	}
+
+	if (sys_int & MASK_HDMI) {
+		v4l2_dbg(1, debug, sd, "%s: DVI->HDMI change detected\n",
+				__func__);
+
+		i2c_wr8(sd, APPL_CTL, MASK_APLL_CPCTL_NORMAL | MASK_APLL_ON);
+		sys_int &= ~MASK_HDMI;
+		if (handled)
+			*handled = true;
+	}
+
+	if (sys_int) {
+		v4l2_err(sd, "%s: Unhandled SYS_INT interrupts: 0x%02x\n",
+				__func__, sys_int);
+	}
+}
+
+/* --------------- CORE OPS --------------- */
+
+static int tc358840_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
+{
+	struct tc358840_state *state = to_state(sd);
+	u16 intstatus, clrstatus = 0;
+	int retry = 10;
+	int i;
+
+	intstatus = i2c_rd16(sd, INTSTATUS);
+
+	while (intstatus && retry--) {
+		v4l2_dbg(1, debug, sd,
+			 "%s: intstatus = 0x%04x\n", __func__, intstatus);
+
+		state->format_changed = false;
+		if (intstatus & MASK_HDMI_INT) {
+			u8 hdmi_int0;
+			u8 hdmi_int1;
+
+			hdmi_int0 = i2c_rd8(sd, HDMI_INT0);
+			hdmi_int1 = i2c_rd8(sd, HDMI_INT1);
+
+			if (hdmi_int0 & MASK_MISC)
+				tc358840_hdmi_misc_int_handler(sd, handled);
+			if (hdmi_int1 & MASK_ACBIT)
+				tc358840_hdmi_cbit_int_handler(sd, handled);
+			if (hdmi_int1 & MASK_CLK)
+				tc358840_hdmi_clk_int_handler(sd, handled);
+			if (hdmi_int1 & MASK_SYS)
+				tc358840_hdmi_sys_int_handler(sd, handled);
+			if (hdmi_int1 & MASK_AUD)
+				tc358840_hdmi_audio_int_handler(sd, handled);
+
+			clrstatus |= MASK_HDMI_INT;
+		}
+
+		if (state->format_changed) {
+			if (no_sync(sd) || no_signal(sd)) {
+				/*
+				 * Reset the HDMI PHY to try to trigger proper
+				 * lock on the incoming video format. Erase BKSV
+				 * to prevent that old keys are used when a new
+				 * source is connected.
+				 */
+				tc358840_reset_phy(sd);
+				tc358840_erase_bksv(sd);
+			}
+			tc358840_enable_interrupts(sd, tx_5v_power_present(sd));
+			tc358840_format_change(sd);
+		}
+
+#if IS_ENABLED(CONFIG_VIDEO_TC358840_CEC)
+		if (intstatus & (MASK_CEC_RINT | MASK_CEC_TINT)) {
+			unsigned int cec_rxint, cec_txint;
+			unsigned int clr;
+
+			cec_rxint = i2c_rd32(sd, CECRSTAT);
+			cec_txint = i2c_rd32(sd, CECTSTAT);
+
+			clr = 0;
+			if (intstatus & MASK_CEC_RINT)
+				clr |= MASK_CECRICLR;
+			if (intstatus & MASK_CEC_TINT)
+				clr |= MASK_CECTICLR;
+			i2c_wr32(sd, CECICLR, clr);
+
+			if ((intstatus & MASK_CEC_TINT) && cec_txint) {
+				if (cec_txint & MASK_CECTIEND)
+					cec_transmit_done(state->cec_adap,
+							  CEC_TX_STATUS_OK,
+							  0, 0, 0, 0);
+				else if (cec_txint & MASK_CECTIAL)
+					cec_transmit_done(state->cec_adap,
+							 CEC_TX_STATUS_ARB_LOST,
+							 1, 0, 0, 0);
+				else if (cec_txint & MASK_CECTIACK)
+					cec_transmit_done(state->cec_adap,
+							  CEC_TX_STATUS_NACK,
+							  0, 1, 0, 0);
+				else if (cec_txint & MASK_CECTIUR) {
+					/*
+					 * Not sure when this bit is set. Treat
+					 * it as an error for now.
+					 */
+					cec_transmit_done(state->cec_adap,
+							  CEC_TX_STATUS_ERROR,
+							  0, 0, 0, 1);
+				}
+				*handled = true;
+			}
+			if ((intstatus & MASK_CEC_RINT) &&
+			    (cec_rxint & MASK_CECRIEND)) {
+				struct cec_msg msg = {};
+				unsigned int i;
+				unsigned int v;
+
+				v = i2c_rd32(sd, CECRCTR);
+				msg.len = v & 0x1f;
+				for (i = 0; i < msg.len; i++) {
+					v = i2c_rd32(sd, CECRBUF1 + i * 4);
+					msg.msg[i] = v & 0xff;
+				}
+				cec_received_msg(state->cec_adap, &msg);
+				*handled = true;
+			}
+			clrstatus |=
+				intstatus & (MASK_CEC_RINT | MASK_CEC_TINT);
+		}
+#endif
+
+		if (intstatus & MASK_CSITX0_INT) {
+			v4l2_dbg(3, debug, sd,
+				 "%s: MASK_CSITX0_INT\n", __func__);
+
+			clrstatus |= MASK_CSITX0_INT;
+		}
+
+		if (intstatus & MASK_CSITX1_INT) {
+			v4l2_dbg(3, debug, sd,
+				 "%s: MASK_CSITX1_INT\n", __func__);
+
+			clrstatus |= MASK_CSITX1_INT;
+		}
+
+		if (clrstatus)
+			i2c_wr16(sd, INTSTATUS, clrstatus);
+
+		if (intstatus & ~clrstatus) {
+			v4l2_dbg(1, debug, sd,
+				 "%s: Unhandled intstatus interrupts: 0x%04x\n",
+				 __func__, intstatus & ~clrstatus);
+		}
+		intstatus = i2c_rd16(sd, INTSTATUS);
+
+		if (intstatus)
+			v4l2_dbg(1, debug, sd,
+				 "%s: retry %d intstatus = 0x%04x\n",
+				 __func__, 10 - retry, intstatus);
+	}
+	if (intstatus == 0)
+		return 0;
+
+	v4l2_err(sd, "unprocessed interrupts: 0x%04x\n", intstatus);
+
+	if (!(intstatus & MASK_HDMI_INT))
+		return 0;
+
+	/*
+	 * If intstatus != 0, then one or more HDMI interrupts are still
+	 * pending.
+	 */
+	for (i = 0x8502; i <= 0x850b; i++) {
+		u8 irqs;
+
+		if (i == 0x850a)
+			continue;
+		irqs = i2c_rd8(sd, i) & ~i2c_rd8(sd, i + 0x10);
+		if (irqs) {
+			v4l2_err(sd, "runaway irqs 0x%02x in reg 0x%x\n",
+				 irqs, i);
+			/* Mask this runaway interrupt */
+			i2c_wr8(sd, i + 0x10, i2c_rd8(sd, i + 0x10) | irqs);
+		}
+	}
+	/* Hopefully this interrupt can now be cleared */
+	i2c_wr16(sd, INTSTATUS, MASK_HDMI_INT);
+	/* Reset the phys as well */
+	tc358840_reset_phy(sd);
+	tc358840_erase_bksv(sd);
+	tc358840_enable_interrupts(sd, tx_5v_power_present(sd));
+	return 0;
+}
+
+static irqreturn_t tc358840_irq_handler(int irq, void *dev_id)
+{
+	struct v4l2_subdev *sd = dev_id;
+	bool handled = false;
+
+	tc358840_isr(sd, 0, &handled);
+
+	return handled ? IRQ_HANDLED : IRQ_NONE;
+}
+
+/* --------------- PAD OPS --------------- */
+
+static int tc358840_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct tc358840_state *state = to_state(sd);
+	u8 vout_csc = i2c_rd8(sd, VOUT_CSC);
+	struct v4l2_mbus_framefmt *fmt;
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	if (format->pad != 0)
+		return -EINVAL;
+
+	format->format.code = state->mbus_fmt_code;
+	format->format.width = state->timings.bt.width;
+	format->format.height = state->timings.bt.height;
+	format->format.field = V4L2_FIELD_NONE;
+
+	switch (vout_csc & MASK_COLOR) {
+	case MASK_COLOR_RGB_FULL:
+	case MASK_COLOR_RGB_LIMITED:
+		format->format.colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+	case MASK_COLOR_601_YCBCR_FULL:
+	case MASK_COLOR_601_YCBCR_LIMITED:
+		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
+		break;
+	case MASK_COLOR_709_YCBCR_FULL:
+	case MASK_COLOR_709_YCBCR_LIMITED:
+		format->format.colorspace = V4L2_COLORSPACE_REC709;
+		break;
+	default:
+		format->format.colorspace = 0;
+		break;
+	}
+
+	fmt = &format->format;
+	v4l2_dbg(3, debug, sd,
+		"%s(): width=%d, height=%d, code=0x%08X, field=%d\n",
+		__func__, fmt->width, fmt->height, fmt->code, fmt->field);
+
+	return 0;
+}
+
+static int tc358840_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct tc358840_state *state = to_state(sd);
+	u32 code = format->format.code; /* is overwritten by get_fmt */
+	int ret = tc358840_get_fmt(sd, cfg, format);
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	format->format.code = code;
+
+	if (ret)
+		return ret;
+
+	switch (code) {
+	case MEDIA_BUS_FMT_RGB888_1X24:
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
+	v4l2_dbg(3, debug, sd, "%s(): format->which=%d\n",
+		__func__, format->which);
+
+	if (state->mbus_fmt_code == format->format.code)
+		return 0;
+
+	state->mbus_fmt_code = format->format.code;
+	enable_stream(sd, false);
+	tc358840_set_csi(sd);
+	tc358840_set_csi_mbus_config(sd);
+
+	return 0;
+}
+
+static int tc358840_g_edid(struct v4l2_subdev *sd,
+		struct v4l2_subdev_edid *edid)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+
+	if (edid->pad != 0)
+		return -EINVAL;
+
+	if (edid->start_block == 0 && edid->blocks == 0) {
+		edid->blocks = state->edid_blocks_written;
+		return 0;
+	}
+
+	if (state->edid_blocks_written == 0)
+		return -ENODATA;
+
+	if (edid->start_block >= state->edid_blocks_written ||
+			edid->blocks == 0)
+		return -EINVAL;
+
+	if (edid->start_block + edid->blocks > state->edid_blocks_written)
+		edid->blocks = state->edid_blocks_written - edid->start_block;
+
+	i2c_rd(sd, EDID_RAM + (edid->start_block * EDID_BLOCK_SIZE), edid->edid,
+		   edid->blocks * EDID_BLOCK_SIZE);
+
+	return 0;
+}
+
+static int tc358840_s_edid(struct v4l2_subdev *sd,
+				struct v4l2_subdev_edid *edid)
+{
+	struct tc358840_state *state = to_state(sd);
+	u16 edid_len = edid->blocks * EDID_BLOCK_SIZE;
+	unsigned int i;
+
+	v4l2_dbg(2, debug, sd, "%s, pad %d, start block %d, blocks %d\n",
+		 __func__, edid->pad, edid->start_block, edid->blocks);
+
+	memset(edid->reserved, 0, sizeof(edid->reserved));
+
+	if (edid->pad != 0)
+		return -EINVAL;
+
+	if (edid->start_block != 0)
+		return -EINVAL;
+
+	if (edid->blocks > EDID_NUM_BLOCKS_MAX) {
+		edid->blocks = EDID_NUM_BLOCKS_MAX;
+		return -E2BIG;
+	}
+
+	tc358840_disable_edid(sd);
+
+	i2c_wr8(sd, EDID_LEN1, edid_len & 0xFF);
+	i2c_wr8(sd, EDID_LEN2, edid_len >> 8);
+
+	if (edid->blocks == 0) {
+		state->edid_blocks_written = 0;
+		return 0;
+	}
+
+	for (i = 0; i < edid_len; i += EDID_BLOCK_SIZE)
+		i2c_wr(sd, EDID_RAM + i, edid->edid + i, EDID_BLOCK_SIZE);
+
+	state->edid_blocks_written = edid->blocks;
+
+	if (tx_5v_power_present(sd))
+		tc358840_enable_edid(sd);
+
+	return 0;
+}
+
+static int tc358840_subscribe_event(struct v4l2_subdev *sd, struct v4l2_fh *fh,
+				    struct v4l2_event_subscription *sub)
+{
+	switch (sub->type) {
+	case V4L2_EVENT_SOURCE_CHANGE:
+		return v4l2_src_change_event_subdev_subscribe(sd, fh, sub);
+	case V4L2_EVENT_CTRL:
+		return v4l2_ctrl_subdev_subscribe_event(sd, fh, sub);
+	default:
+		return -EINVAL;
+	}
+}
+
+/* --------------- VIDEO OPS --------------- */
+
+static const struct v4l2_dv_timings_cap *
+tc358840_g_timings_cap(struct tc358840_state *state)
+{
+	struct tc358840_platform_data *pdata = &state->pdata;
+
+	if (pdata->csi_port == CSI_TX_BOTH)
+		return &tc358840_timings_cap_4kp30;
+	return &tc358840_timings_cap_1080p60;
+}
+
+static int tc358840_g_input_status(struct v4l2_subdev *sd, u32 *status)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	*status = 0;
+	if (!state->test_pattern) {
+		*status |= no_signal(sd) ? V4L2_IN_ST_NO_SIGNAL : 0;
+		*status |= (no_sync(sd) || !state->found_stable_signal) ?
+				V4L2_IN_ST_NO_SYNC : 0;
+	}
+
+	v4l2_dbg(1, debug, sd, "%s: status = 0x%x\n", __func__, *status);
+
+	return 0;
+}
+
+static int tc358840_s_dv_timings(struct v4l2_subdev *sd,
+				 struct v4l2_dv_timings *timings)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	if (!timings)
+		return -EINVAL;
+
+	if (debug)
+		v4l2_print_dv_timings(sd->name, "tc358840_s_dv_timings: ",
+				timings, false);
+
+	if (state->test_pattern &&
+	    tc358840_set_test_pattern_timing(sd, timings)) {
+		v4l2_dbg(1, debug, sd,
+			 "%s: failed to set test pattern timings\n", __func__);
+		return -ERANGE;
+	}
+
+	if (tc358840_match_dv_timings(&state->timings, timings, 0)) {
+		v4l2_dbg(1, debug, sd, "%s: no change\n", __func__);
+		return 0;
+	}
+
+	if (!v4l2_valid_dv_timings(timings, tc358840_g_timings_cap(state),
+				   NULL, NULL)) {
+		v4l2_dbg(1, debug, sd, "%s: timings out of range\n", __func__);
+		return -ERANGE;
+	}
+
+	state->timings = *timings;
+
+	enable_stream(sd, false);
+	tc358840_set_csi(sd);
+	tc358840_set_splitter(sd);
+
+	return 0;
+}
+
+static int tc358840_g_dv_timings(struct v4l2_subdev *sd,
+				 struct v4l2_dv_timings *timings)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	*timings = state->timings;
+
+	return 0;
+}
+
+static int tc358840_enum_dv_timings(struct v4l2_subdev *sd,
+				    struct v4l2_enum_dv_timings *timings)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s(): DUMMY\n", __func__);
+
+	if (timings->pad != 0)
+		return -EINVAL;
+
+	return v4l2_enum_dv_timings_cap(timings,
+			tc358840_g_timings_cap(state), NULL, NULL);
+}
+
+static int tc358840_query_dv_timings(struct v4l2_subdev *sd,
+				     struct v4l2_dv_timings *timings)
+{
+	struct tc358840_state *state = to_state(sd);
+	int ret;
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	ret = tc358840_get_detected_timings(sd, timings);
+	if (ret)
+		return ret;
+	if (!state->found_stable_signal)
+		return -ENOLCK;
+
+	if (debug)
+		v4l2_print_dv_timings(sd->name, "tc358840_query_dv_timings: ",
+			timings, false);
+	if (!v4l2_valid_dv_timings(timings, tc358840_g_timings_cap(state),
+				   NULL, NULL)) {
+		v4l2_dbg(1, debug, sd, "%s: timings out of range\n", __func__);
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+static int tc358840_dv_timings_cap(struct v4l2_subdev *sd,
+				   struct v4l2_dv_timings_cap *cap)
+{
+	struct tc358840_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	if (cap->pad != 0)
+		return -EINVAL;
+
+	*cap = *tc358840_g_timings_cap(state);
+
+	return 0;
+}
+
+static int tc358840_g_mbus_config(struct v4l2_subdev *sd,
+				  struct v4l2_mbus_config *cfg)
+{
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	cfg->type = V4L2_MBUS_CSI2;
+
+	/* Support for non-continuous CSI-2 clock is missing in the driver */
+	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK | V4L2_MBUS_CSI2_CHANNEL_0;
+
+	switch (tc358840_num_csi_lanes_in_use(sd)) {
+	case 1:
+		cfg->flags |= V4L2_MBUS_CSI2_1_LANE;
+		break;
+	case 2:
+		cfg->flags |= V4L2_MBUS_CSI2_2_LANE;
+		break;
+	case 3:
+		cfg->flags |= V4L2_MBUS_CSI2_3_LANE;
+		break;
+	case 4:
+		cfg->flags |= V4L2_MBUS_CSI2_4_LANE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	v4l2_dbg(2, debug, sd, "%s: Lanes: 0x%02X\n",
+		__func__, cfg->flags & 0x0F);
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static u8 tc358840_reg_size(u32 addr)
+{
+	if ((addr >= 0x100 && addr < 0x500) ||
+	    (addr >= 0x600 && addr < 0x700))
+		return 4;
+	if (addr >= 0x8000 && addr < 0xa000)
+		return 1;
+	return 2;
+}
+
+static int tc358840_g_register(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_register *reg)
+{
+	reg->size = tc358840_reg_size(reg->reg);
+	switch (reg->size) {
+	case 1:
+		reg->val = i2c_rd8(sd, reg->reg);
+		break;
+	case 2:
+		reg->val = i2c_rd16(sd, reg->reg);
+		break;
+	case 4:
+	default:
+		reg->val = i2c_rd32(sd, reg->reg);
+		break;
+	}
+	return 0;
+}
+
+static int tc358840_s_register(struct v4l2_subdev *sd,
+			       const struct v4l2_dbg_register *reg)
+{
+	u8 size = tc358840_reg_size(reg->reg);
+
+	/*
+	 * It should not be possible for the user to enable HDCP with a simple
+	 * v4l2-dbg command.
+	 *
+	 * DO NOT REMOVE THIS unless all other issues with HDCP have been
+	 * resolved.
+	 */
+	if (reg->reg == HDCP_MODE ||
+	    reg->reg == HDCP_REG1 ||
+	    reg->reg == HDCP_REG2 ||
+	    reg->reg == HDCP_REG3 ||
+	    reg->reg == BCAPS)
+		return 0;
+
+	switch (size) {
+	case 1:
+		i2c_wr8(sd, reg->reg, reg->val);
+		break;
+	case 2:
+		i2c_wr16(sd, reg->reg, reg->val);
+		break;
+	case 4:
+	default:
+		i2c_wr32(sd, reg->reg, reg->val);
+		break;
+	}
+	return 0;
+}
+#endif
+
+static int tc358840_log_status(struct v4l2_subdev *sd)
+{
+	struct tc358840_state *state = to_state(sd);
+	struct v4l2_dv_timings timings;
+	u8 hdmi_sys_status =  i2c_rd8(sd, SYS_STATUS);
+	u16 sysctl = i2c_rd16(sd, SYSCTL);
+	u8 vi_status3 = i2c_rd8(sd, VI_STATUS3);
+	u8 vout_csc = i2c_rd8(sd, VOUT_CSC);
+	const int deep_color_mode[4] = { 8, 10, 12, 16 };
+	static const char * const input_color_space[] = {
+		"RGB", "YCbCr 601", "Adobe RGB", "YCbCr 709", "NA (4)",
+		"xvYCC 601", "NA(6)", "xvYCC 709", "NA(8)", "sYCC601",
+		"NA(10)", "NA(11)", "NA(12)", "Adobe YCC 601"};
+	static const char * const vout_csc_mode_str[] = {
+		"Off", "On (built-in coefficients)",
+		"On/Off Auto", "On (host coefficients)"
+	};
+	static const char * const vout_csc_color_str[] = {
+		"RGB Full", "RGB Limited",
+		"YCbCr 601 Full", "YCbCr 601 Limited",
+		"YCbCr 709 Full", "YCbCr 709 Limited",
+		"RGB Full to Limited", "RGB Limited to Full"
+	};
+
+	v4l2_ctrl_subdev_log_status(sd);
+	v4l2_info(sd, "-----Chip status-----\n");
+	v4l2_info(sd, "Chip ID: 0x%02x\n",
+			(i2c_rd16(sd, CHIPID_ADDR) & MASK_CHIPID) >> 8);
+	v4l2_info(sd, "Chip revision: 0x%02x\n",
+			i2c_rd16(sd, CHIPID_ADDR) & MASK_REVID);
+	v4l2_info(sd, "Reset: IR: %d, CEC: %d, CSI TX: %d, HDMI: %d\n",
+			!!(sysctl & MASK_IRRST),
+			!!(sysctl & MASK_CECRST),
+			!!(sysctl & MASK_CTXRST),
+			!!(sysctl & MASK_HDMIRST));
+	v4l2_info(sd, "Sleep mode: %s\n", sysctl & MASK_SLEEP ? "on" : "off");
+	v4l2_info(sd, "Cable detected (+5V power): %s\n",
+			hdmi_sys_status & MASK_S_DDC5V ? "yes" : "no");
+	v4l2_info(sd, "Number of EDID blocks: %d\n",
+		  state->edid_blocks_written);
+	v4l2_info(sd, "DDC lines enabled: %s\n",
+			(i2c_rd8(sd, EDID_MODE) & MASK_EDID_MODE_ALL) ?
+			"yes" : "no");
+	v4l2_info(sd, "Hotplug enabled: %s\n",
+			(i2c_rd8(sd, HPD_CTL) & MASK_HPD_OUT0) ?
+			"yes" : "no");
+	v4l2_info(sd, "CEC enabled: %s\n",
+			(i2c_rd16(sd, CECEN) & MASK_CECEN) ?  "yes" : "no");
+	v4l2_info(sd, "-----Signal status-----\n");
+	v4l2_info(sd, "TMDS signal detected: %s\n",
+			hdmi_sys_status & MASK_S_TMDS ? "yes" : "no");
+	v4l2_info(sd, "Stable sync signal: %s\n",
+			hdmi_sys_status & MASK_S_SYNC ? "yes" : "no");
+	v4l2_info(sd, "PHY PLL locked: %s\n",
+			hdmi_sys_status & MASK_S_PHY_PLL ? "yes" : "no");
+	v4l2_info(sd, "PHY DE detected: %s\n",
+			hdmi_sys_status & MASK_S_PHY_SCDT ? "yes" : "no");
+
+	if (tc358840_get_detected_timings(sd, &timings)) {
+		v4l2_info(sd, "No video detected\n");
+	} else {
+		v4l2_print_dv_timings(sd->name, "Detected format: ",
+				      &timings, true);
+	}
+	v4l2_print_dv_timings(sd->name, "Configured format: ",
+			      &state->timings, true);
+	v4l2_info(sd, "streaming: %s\n", state->enabled ? "yes" : "no");
+
+	v4l2_info(sd, "-----CSI-TX status-----\n");
+	v4l2_info(sd, "Lanes needed: %d\n",
+			tc358840_num_csi_lanes_needed(sd));
+	v4l2_info(sd, "Lanes in use: %d\n",
+			tc358840_num_csi_lanes_in_use(sd));
+	v4l2_info(sd, "Splitter %sabled\n",
+		  (i2c_rd16(sd, SPLITTX0_CTRL) & MASK_SPBP) ? "dis" : "en");
+	v4l2_info(sd, "Color encoding: %s\n",
+			state->mbus_fmt_code == MEDIA_BUS_FMT_UYVY8_1X16 ?
+			"YCbCr 422 16-bit" :
+			state->mbus_fmt_code == MEDIA_BUS_FMT_RGB888_1X24 ?
+			"RGB 888 24-bit" : "Unsupported");
+	v4l2_info(sd, "CSC: %s %s\n",
+			vout_csc_mode_str[vout_csc & MASK_CSC_MODE],
+			vout_csc_color_str[(vout_csc & MASK_COLOR) >> 4]);
+
+	v4l2_info(sd, "-----%s status-----\n", is_hdmi(sd) ? "HDMI" : "DVI-D");
+	v4l2_info(sd, "HDCP encrypted content: %s\n",
+			hdmi_sys_status & MASK_S_HDCP ? "yes" : "no");
+	v4l2_info(sd, "Input color space: %s %s range\n",
+			input_color_space[(vi_status3 & MASK_S_V_COLOR) >> 1],
+			(vi_status3 & MASK_LIMITED) ? "limited" : "full");
+	if (!is_hdmi(sd))
+		return 0;
+	v4l2_info(sd, "AV Mute: %s\n", hdmi_sys_status & MASK_S_AVMUTE ? "on" :
+			"off");
+	v4l2_info(sd, "Deep color mode: %d-bits per channel\n",
+			deep_color_mode[(i2c_rd8(sd, VI_STATUS1) &
+				MASK_S_DEEPCOLOR) >> 2]);
+	print_infoframe(sd);
+
+	return 0;
+}
+
+static int tc358840_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	v4l2_dbg(3, debug, sd, "%s():\n", __func__);
+
+	return enable_stream(sd, enable);
+}
+
+static int tc358840_enum_mbus_code(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_pad_config *cfg,
+				   struct v4l2_subdev_mbus_code_enum *code)
+{
+	v4l2_dbg(2, debug, sd, "%s()\n", __func__);
+
+	if (code->index >= 2)
+		return -EINVAL;
+
+	switch (code->index) {
+	case 0:
+		code->code = MEDIA_BUS_FMT_RGB888_1X24;
+		break;
+	case 1:
+		code->code = MEDIA_BUS_FMT_UYVY8_1X16;
+		break;
+	}
+	return 0;
+}
+
+static int tc358840_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct tc358840_state, hdl)->sd;
+
+	if (ctrl->id == V4L2_CID_DV_RX_IT_CONTENT_TYPE) {
+		ctrl->val = V4L2_DV_IT_CONTENT_TYPE_NO_ITC;
+		if (i2c_rd8(sd, PK_AVI_2BYTE) & 0x80)
+			ctrl->val = (i2c_rd8(sd, PK_AVI_4BYTE) >> 4) & 3;
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static int tc358840_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct v4l2_subdev *sd =
+		&container_of(ctrl->handler, struct tc358840_state, hdl)->sd;
+	struct tc358840_state *state = to_state(sd);
+
+	switch (ctrl->id) {
+	case V4L2_CID_TEST_PATTERN:
+		v4l2_dbg(2, debug, sd, "%s() id=0x%x old_val=%d new_val=%d:\n",
+			__func__, ctrl->id, state->test_pattern, ctrl->val);
+		/* Not allowed to enable/disable testpat if streaming enabled */
+		if (state->enabled) {
+			if (!state->test_pattern ||
+				ctrl->val == TEST_PATTERN_DISABLED)
+				return -EBUSY;
+		}
+		tc358840_set_test_pattern_type(sd, ctrl->val);
+
+		/* test pattern enabled ? set/override tx_5V to true */
+		if (!state->test_pattern && ctrl->val)
+			__v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl, true);
+		/* test pattern disabled ? set tx_5V according to HW */
+		if (state->test_pattern && !ctrl->val)
+			__v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
+				tx_5v_power_present(sd));
+
+		state->test_pattern = ctrl->val;
+		break;
+	case  V4L2_CID_DV_RX_RGB_RANGE:
+		state->rgb_quantization_range = ctrl->val;
+		if (state->mbus_fmt_code == MEDIA_BUS_FMT_RGB888_1X24)
+			set_rgb_quantization_range(sd);
+		break;
+	}
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops tc358840_ctrl_ops = {
+	.g_volatile_ctrl = tc358840_g_volatile_ctrl,
+	.s_ctrl = tc358840_s_ctrl,
+};
+
+static struct v4l2_subdev_video_ops tc358840_subdev_video_ops = {
+	.g_input_status = tc358840_g_input_status,
+	.s_dv_timings = tc358840_s_dv_timings,
+	.g_dv_timings = tc358840_g_dv_timings,
+	.query_dv_timings = tc358840_query_dv_timings,
+	.g_mbus_config = tc358840_g_mbus_config,
+	.s_stream = tc358840_s_stream,
+};
+
+static struct v4l2_subdev_core_ops tc358840_subdev_core_ops = {
+	.log_status = tc358840_log_status,
+	.interrupt_service_routine = tc358840_isr,
+	.subscribe_event = tc358840_subscribe_event,
+	.unsubscribe_event = v4l2_event_subdev_unsubscribe,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = tc358840_g_register,
+	.s_register = tc358840_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_pad_ops tc358840_pad_ops = {
+	.set_fmt = tc358840_set_fmt,
+	.get_fmt = tc358840_get_fmt,
+	.enum_mbus_code = tc358840_enum_mbus_code,
+	.get_edid = tc358840_g_edid,
+	.set_edid = tc358840_s_edid,
+	.dv_timings_cap = tc358840_dv_timings_cap,
+	.enum_dv_timings = tc358840_enum_dv_timings,
+};
+
+static struct v4l2_subdev_ops tc358840_ops = {
+	.core = &tc358840_subdev_core_ops,
+	.video = &tc358840_subdev_video_ops,
+	.pad = &tc358840_pad_ops,
+};
+
+
+/* --------------- CUSTOM CTRLS --------------- */
+
+static const struct v4l2_ctrl_config tc358840_ctrl_audio_sampling_rate = {
+	.id = TC358840_CID_AUDIO_SAMPLING_RATE,
+	.name = "Audio sampling rate",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 768000,
+	.step = 1,
+	.def = 0,
+	.flags = V4L2_CTRL_FLAG_READ_ONLY,
+};
+
+static const struct v4l2_ctrl_config tc358840_ctrl_audio_present = {
+	.id = TC358840_CID_AUDIO_PRESENT,
+	.name = "Audio present",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 0,
+	.flags = V4L2_CTRL_FLAG_READ_ONLY,
+};
+
+static const struct v4l2_ctrl_config tc358840_ctrl_splitter_width = {
+	.id = TC358840_CID_SPLITTER_WIDTH,
+	.name = "Splitter Width",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 320,
+	.max = 1920,
+	.step = 16,
+	.def = 1920,
+	.flags = V4L2_CTRL_FLAG_READ_ONLY,
+};
+
+static const char * const test_pattern_menu[] = {
+	"Disabled",
+	"Color Bar",
+	"Color Checker",
+};
+
+/* --------------- PROBE / REMOVE --------------- */
+
+#ifdef CONFIG_OF
+
+static bool tc358840_parse_dt(struct tc358840_platform_data *pdata,
+		struct i2c_client *client)
+{
+	struct device_node *node = client->dev.of_node;
+	const u32 *property;
+
+	v4l_dbg(1, debug, client, "Device Tree Parameters:\n");
+
+	pdata->reset_gpio = of_get_named_gpio(node, "reset-gpios", 0);
+	if (pdata->reset_gpio == 0)
+		return false;
+	v4l_dbg(1, debug, client, "reset_gpio = %d\n", pdata->reset_gpio);
+
+	if (v4l2_of_parse_endpoint(node, &pdata->endpoint))
+		return false;
+
+	property = of_get_property(node, "refclk_hz", NULL);
+	if (property == NULL)
+		return false;
+	pdata->refclk_hz = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "refclk_hz = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "ddc5v_delay", NULL);
+	if (property == NULL)
+		return false;
+	pdata->ddc5v_delay = be32_to_cpup(property);
+	if (pdata->ddc5v_delay > DDC5V_DELAY_MAX)
+		pdata->ddc5v_delay = DDC5V_DELAY_MAX;
+	v4l_dbg(1, debug, client, "ddc5v_delay = %d ms\n",
+		50 * pdata->ddc5v_delay);
+
+	property = of_get_property(node, "enable_hdcp", NULL);
+	if (property == NULL)
+		return false;
+	pdata->enable_hdcp = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "enable_hdcp = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "csi_port", NULL);
+	if (property == NULL)
+		return false;
+	pdata->csi_port = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "csi_port = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "lineinitcnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->lineinitcnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "lineinitcnt = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "lptxtimecnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->lptxtimecnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "lptxtimecnt = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "tclk_headercnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->tclk_headercnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "tclk_headercnt = %d\n",
+		be32_to_cpup(property));
+
+	property = of_get_property(node, "tclk_trailcnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->tclk_trailcnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "tclk_trailcnt = %d\n",
+		be32_to_cpup(property));
+
+	property = of_get_property(node, "ths_headercnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->ths_headercnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "ths_headercnt = %d\n",
+		be32_to_cpup(property));
+
+	property = of_get_property(node, "twakeup", NULL);
+	if (property == NULL)
+		return false;
+	pdata->twakeup = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "twakeup = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "tclk_postcnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->tclk_postcnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "tclk_postcnt = %d\n",
+		be32_to_cpup(property));
+
+	property = of_get_property(node, "ths_trailcnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->ths_trailcnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "ths_trailcnt = %d\n",
+		be32_to_cpup(property));
+
+	property = of_get_property(node, "hstxvregcnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->hstxvregcnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "hstxvregcnt = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "btacnt", NULL);
+	if (property == NULL)
+		return false;
+	pdata->btacnt = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "btacnt = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "pll_prd", NULL);
+	if (property == NULL)
+		return false;
+	pdata->pll_prd = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "pll_prd = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "pll_frs", NULL);
+	if (property == NULL)
+		return false;
+	pdata->pll_frs = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "pll_frs = %d\n", be32_to_cpup(property));
+
+	property = of_get_property(node, "pll_fbd", NULL);
+	if (property == NULL)
+		return false;
+	pdata->pll_fbd = be32_to_cpup(property);
+	v4l_dbg(1, debug, client, "pll_fbd = %d\n", be32_to_cpup(property));
+
+	return true;
+}
+#else
+static bool tc358840_parse_dt(struct tc358840_platform_data *pdata,
+		struct i2c_client *client)
+{
+	return false;
+}
+#endif
+
+static int tc358840_verify_chipid(struct v4l2_subdev *sd)
+{
+	u16 cid = 0;
+
+	cid = i2c_rd16(sd, CHIPID_ADDR);
+	if (cid != TC358840_CHIPID) {
+		v4l2_err(sd, "Invalid chip ID 0x%04X\n", cid);
+		return -ENODEV;
+	}
+
+	v4l2_dbg(1, debug, sd, "TC358840 ChipID 0x%02x, Revision 0x%02x\n",
+		(cid & MASK_CHIPID) >> 8, cid & MASK_REVID);
+
+	return 0;
+}
+
+static int tc358840_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	dev_dbg(&client->dev, "%s:\n", __func__);
+	return 0;
+}
+
+static const struct v4l2_subdev_internal_ops tc358840_subdev_internal_ops = {
+	.open = tc358840_open,
+};
+
+static const struct media_entity_operations tc358840_media_ops = {
+#ifdef CONFIG_MEDIA_CONTROLLER
+	.link_validate = v4l2_subdev_link_validate,
+#endif
+};
+
+static int tc358840_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
+{
+	u16 irq_mask = MASK_HDMI_INT;
+	struct v4l2_dv_timings timings;
+	struct tc358840_state *state;
+	struct v4l2_ctrl *ctrl;
+	struct v4l2_subdev *sd;
+	int err;
+
+	state = devm_kzalloc(&client->dev,
+			     sizeof(struct tc358840_state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	if (client->dev.of_node) {
+		if (!tc358840_parse_dt(&state->pdata, client)) {
+			v4l_err(client, "Couldn't parse device tree\n");
+			return -ENODEV;
+		}
+	} else {
+		if (!client->dev.platform_data) {
+			v4l_err(client, "No platform data!\n");
+			return -ENODEV;
+		}
+		state->pdata = *(struct tc358840_platform_data *)
+				client->dev.platform_data;
+	}
+
+	state->i2c_client = client;
+	sd = &state->sd;
+
+	i2c_set_clientdata(client, state);
+
+	v4l2_i2c_subdev_init(sd, client, &tc358840_ops);
+	mutex_init(&state->confctl_mutex);
+
+	/* Release System Reset (pin K8) */
+	v4l2_dbg(1, debug, sd, "Releasing System Reset (gpio 0x%04X)\n",
+		 state->pdata.reset_gpio);
+	if (!gpio_is_valid(state->pdata.reset_gpio)) {
+		v4l_err(client, "Reset GPIO is invalid!\n");
+		return state->pdata.reset_gpio;
+	}
+	err = devm_gpio_request_one(&client->dev, state->pdata.reset_gpio,
+					GPIOF_OUT_INIT_HIGH, "tc358840-reset");
+	if (err) {
+		dev_err(&client->dev,
+			"Failed to request Reset GPIO 0x%04X: %d\n",
+			state->pdata.reset_gpio, err);
+		return err;
+	}
+
+	/*  */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+	v4l_info(client, "Chip found @ 7h%02X (%s)\n",
+		client->addr, client->adapter->name);
+
+
+	/* Verify chip ID */
+	err = tc358840_verify_chipid(sd);
+	if (err)
+		return err;
+
+#if IS_ENABLED(CONFIG_VIDEO_TC358840_CEC)
+	state->cec_adap = cec_allocate_adapter(&tc358840_cec_adap_ops,
+		state, dev_name(&client->dev),
+		CEC_CAP_TRANSMIT | CEC_CAP_LOG_ADDRS | CEC_CAP_PASSTHROUGH |
+		CEC_CAP_MONITOR_ALL | CEC_CAP_RC, 1, &client->dev);
+	if (IS_ERR_OR_NULL(state->cec_adap)) {
+		err = state->cec_adap ? PTR_ERR(state->cec_adap) : -ENOMEM;
+		return err;
+	}
+	state->cec_adap->available_log_addrs = CEC_MAX_LOG_ADDRS;
+	irq_mask |= MASK_CEC_RINT | MASK_CEC_TINT;
+#endif
+
+	/* Control Handlers */
+	v4l2_ctrl_handler_init(&state->hdl, 7);
+
+	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(&state->hdl, NULL,
+			V4L2_CID_DV_RX_POWER_PRESENT, 0, 1, 0, 0);
+
+	ctrl = v4l2_ctrl_new_std_menu(&state->hdl, &tc358840_ctrl_ops,
+			V4L2_CID_DV_RX_IT_CONTENT_TYPE,
+			V4L2_DV_IT_CONTENT_TYPE_NO_ITC,
+			0, V4L2_DV_IT_CONTENT_TYPE_NO_ITC);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
+	state->test_pattern_ctrl = v4l2_ctrl_new_std_menu_items(&state->hdl,
+		&tc358840_ctrl_ops, V4L2_CID_TEST_PATTERN,
+		ARRAY_SIZE(test_pattern_menu) - 1, 0, 0,
+		test_pattern_menu);
+	state->rgb_quantization_range_ctrl = v4l2_ctrl_new_std_menu(&state->hdl,
+			&tc358840_ctrl_ops, V4L2_CID_DV_RX_RGB_RANGE,
+			V4L2_DV_RGB_RANGE_FULL, 0, V4L2_DV_RGB_RANGE_AUTO);
+
+	/* Custom controls */
+	state->audio_sampling_rate_ctrl = v4l2_ctrl_new_custom(&state->hdl,
+			&tc358840_ctrl_audio_sampling_rate, NULL);
+
+	state->audio_present_ctrl = v4l2_ctrl_new_custom(&state->hdl,
+			&tc358840_ctrl_audio_present, NULL);
+
+	state->splitter_width_ctrl = v4l2_ctrl_new_custom(&state->hdl,
+			&tc358840_ctrl_splitter_width, NULL);
+
+	if (state->hdl.error) {
+		err = state->hdl.error;
+		goto err_hdl;
+	}
+
+	sd->ctrl_handler = &state->hdl;
+
+	if (tc358840_update_controls(sd)) {
+		err = -ENODEV;
+		goto err_hdl;
+	}
+
+	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
+			tc358840_delayed_work_enable_hotplug);
+	INIT_DELAYED_WORK(&state->delayed_work_enable_format,
+			tc358840_delayed_work_enable_format);
+
+	/* Initial Setup */
+	state->mbus_fmt_code = MEDIA_BUS_FMT_UYVY8_1X16;
+	tc358840_initial_setup(sd);
+
+	tc358840_set_csi_mbus_config(sd);
+
+	/* Get interrupt */
+	if (client->irq) {
+		err = devm_request_threaded_irq(&state->i2c_client->dev,
+				client->irq, NULL, tc358840_irq_handler,
+				IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				sd->name, (void *)sd);
+		if (err) {
+			v4l2_err(sd, "Could not request interrupt %d!\n",
+				 client->irq);
+			goto err_hdl;
+		}
+	}
+
+	v4l2_ctrl_handler_setup(sd->ctrl_handler);
+
+	v4l2_info(sd, "%s found @ 7h%02X (%s)\n", client->name,
+		  client->addr, client->adapter->name);
+
+	sd->dev	= &client->dev;
+	sd->internal_ops = &tc358840_subdev_internal_ops;
+	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	state->pad[0].flags = MEDIA_PAD_FL_SOURCE;
+	state->pad[1].flags = MEDIA_PAD_FL_SOURCE;
+	sd->entity.ops = &tc358840_media_ops;
+	err = media_entity_pads_init(&sd->entity, 2, state->pad);
+	if (err < 0) {
+		dev_err(&client->dev, "unable to init media entity\n");
+		return err;
+	}
+#endif
+
+	err = cec_register_adapter(state->cec_adap);
+	if (err < 0) {
+		pr_err("%s: failed to register the cec device\n", __func__);
+		cec_delete_adapter(state->cec_adap);
+		state->cec_adap = NULL;
+		goto err_hdl;
+	}
+
+	state->found_signal = !tc358840_get_detected_timings(sd, &timings);
+	if (state->found_signal) {
+		state->timings = timings;
+		state->found_stable_signal = true;
+	}
+	tc358840_enable_interrupts(sd, tx_5v_power_present(sd));
+	cec_s_phys_addr(state->cec_adap, 0, false);
+
+	i2c_wr16(sd, INTMASK, ~irq_mask & 0x0F3F);
+
+	err = v4l2_async_register_subdev(sd);
+	if (err == 0)
+		return 0;
+
+	cec_unregister_adapter(state->cec_adap);
+err_hdl:
+	v4l2_ctrl_handler_free(&state->hdl);
+	return err;
+}
+
+static int tc358840_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tc358840_state *state = to_state(sd);
+
+	v4l_dbg(1, debug, client, "%s()\n", __func__);
+
+	cancel_delayed_work_sync(&state->delayed_work_enable_format);
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
+#if defined(CONFIG_MEDIA_CONTROLLER)
+	media_entity_cleanup(&sd->entity);
+#endif
+	cec_unregister_adapter(state->cec_adap);
+	return 0;
+}
+
+static const struct i2c_device_id tc358840_id[] = {
+	{ "tc358840", 0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(i2c, tc358840_id);
+
+#ifdef CONFIG_OF
+static const struct of_device_id tc358840_of_table[] = {
+	{ .compatible = "toshiba,tc358840" },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, tc358840_of_table);
+#endif
+
+static struct i2c_driver tc358840_driver = {
+	.driver = {
+		.of_match_table = of_match_ptr(tc358840_of_table),
+		.name = "tc358840",
+	},
+	.probe = tc358840_probe,
+	.remove = tc358840_remove,
+	.id_table = tc358840_id,
+};
+module_i2c_driver(tc358840_driver);
+
+MODULE_DESCRIPTION("Driver for Toshiba TC358840 HDMI to CSI-2 Bridge");
+MODULE_AUTHOR("Armin Weiss (weii@zhaw.ch)");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/media/i2c/tc358840_regs.h b/drivers/media/i2c/tc358840_regs.h
new file mode 100644
index 0000000..d189f48
--- /dev/null
+++ b/drivers/media/i2c/tc358840_regs.h
@@ -0,0 +1,805 @@
+/*
+ * tc358840_regs.h - Toshiba UH2C/D HDMI-CSI bridge registers
+ *
+ * Copyright (c) 2015, Armin Weiss <weii@zhaw.ch>
+ * Copyright (c) 2016, NVIDIA CORPORATION.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __TC358840_REGS__
+#define __TC358840_REGS__
+
+/**************************************************
+ * Register Addresses
+ *************************************************/
+
+/* *** General (16 bit) *** */
+#define CHIPID_ADDR				0x0000
+#define MASK_CHIPID				0xff00
+#define MASK_REVID				0x00ff
+#define TC358840_CHIPID				0x4700
+
+#define SYSCTL					0x0002
+#define MASK_SLEEP				(1 << 0)
+#define MASK_I2SDIS				(1 << 7)
+#define MASK_HDMIRST				(1 << 8)
+#define MASK_CTXRST				(1 << 9)
+#define MASK_CECRST				(1 << 10)
+#define MASK_IRRST				(1 << 11)
+#define MASK_SPLRST				(1 << 12)
+#define MASK_ABRST				(1 << 14)
+#define MASK_RESET_ALL				0x5f80
+
+#define CONFCTL0				0x0004
+#define MASK_VTX0EN				(1 << 0)
+#define MASK_VTX1EN				(1 << 1)
+#define MASK_AUTOINDEX				(1 << 2)
+#define MASK_AUDOUTSEL_CSITX0			(0 << 3)
+#define MASK_AUDOUTSEL_CSITX1			(1 << 3)
+#define MASK_AUDOUTSEL_I2S			(2 << 3)
+#define MASK_AUDOUTSEL_TDM			(3 << 3)
+#define MASK_ABUFEN				(1 << 5)
+#define MASK_YCBCRFMT				(3 << 6)
+#define MASK_YCBCRFMT_YCBCR444			(0 << 6)
+#define MASK_YCBCRFMT_YCBCR422_12		(1 << 6)
+#define MASK_YCBCRFMT_VPID2			(2 << 6)
+#define MASK_YCBCRFMT_YCBCR422_8		(3 << 6)
+#define MASK_I2SDLYOPT				(1 << 8)
+#define MASK_AUDCHSEL				(1 << 9)
+#define MASK_AUDCHNUM_8				(0 << 10)
+#define MASK_AUDCHNUM_6				(1 << 10)
+#define MASK_AUDCHNUM_4				(2 << 10)
+#define MASK_AUDCHNUM_2				(3 << 10)
+#define MASK_ACLKOPT				(1 << 12)
+#define MASK_IECEN				(1 << 13)
+#define MASK_SLMBEN				(1 << 14)
+#define MASK_TX_MSEL				(1 << 15)
+
+#define CONFCTL1				0x0006
+#define MASK_TX_OUT_FMT				0x0003
+#define MASK_TX_OUT_FMT_RGB888			(0 << 0)
+#define MASK_TX_OUT_FMT_RGB666			(2 << 0)
+#define MASK_TX_MS_EN				(1 << 2)
+
+/* *** Interrupt (16 bit) *** */
+#define INTSTATUS				0x0014
+#define INTMASK					0x0016
+#define MASK_IR_DINT				(1 << 0)
+#define MASK_IR_EINT				(1 << 1)
+#define MASK_CEC_RINT				(1 << 2)
+#define MASK_CEC_TINT				(1 << 3)
+#define MASK_CEC_EINT				(1 << 4)
+#define MASK_SYS_INT				(1 << 5)
+#define MASK_CSITX0_INT				(1 << 8)
+#define MASK_HDMI_INT				(1 << 9)
+#define MASK_AMUTE_INT				(1 << 10)
+#define MASK_CSITX1_INT				(1 << 11)
+#define MASK_INT_STATUS_MASK_ALL		0x0f3f
+
+/* *** Interrupt and MASKs (8 bit) *** */
+#define HDMI_INT0				0x8500
+#define MASK_KEY				0x01
+#define MASK_MISC				0x0002
+
+#define HDMI_INT1				0x8501
+#define MASK_SYS				0x01
+#define MASK_CLK				0x02
+#define MASK_PACKET				0x04
+#define MASK_ACBIT				0x08
+#define MASK_AUD				0x10
+#define MASK_ERR				0x20
+#define MASK_HDCP				0x40
+#define MASK_GBD				0x80
+
+#define SYS_INT					0x8502
+#define SYS_INTM				0x8512
+#define MASK_DDC				0x01
+#define MASK_TMDS				0x02
+#define MASK_DPMBDET				0x04
+#define MASK_NOPMBDET				0x08
+#define MASK_HDMI				0x10
+#define MASK_DVI				0x20
+#define MASK_ACRN				0x40
+#define MASK_ACR_CTS				0x80
+
+#define CLK_INT					0x8503
+#define CLK_INTM				0x8513
+#define MASK_TMDSCLK_CHG			0x01
+#define MASK_PHYCLK_CHG				0x02
+#define MASK_PXCLK_CHG				0x04
+#define MASK_DC_CHG				0x08
+#define MASK_IN_HV_CHG				0x10
+#define MASK_IN_DE_CHG				0x20
+#define MASK_OUT_H_CHG				0x40
+#define MASK_OUT_DE_CHG				0x80
+
+#define PACKET_INT				0x8504
+#define PACKET_INTM				0x8514
+#define MASK_PK_AVI				0x01
+#define MASK_PK_AUD				0x02
+#define MASK_PK_MS				0x04
+#define MASK_PK_SPD				0x08
+#define MASK_PK_VS				0x10
+#define MASK_PK_ACP				0x20
+#define MASK_PK_ISRC				0x40
+#define MASK_PK_ISRC2				0x80
+
+#define CBIT_INT				0x8505
+#define CBIT_INTM				0x8515
+#define MASK_CBIT				0x01
+#define MASK_CBIT_FS				0x02
+#define MASK_CBIT_NLPCM				0x04
+#define MASK_AU_HBR				0x08
+#define MASK_AU_DSD				0x10
+#define MASK_AF_UNLOCK				0x40
+#define MASK_AF_LOCK				0x80
+
+#define AUDIO_INT				0x8506
+#define AUDIO_INTM				0x8516
+#define MASK_BUFINIT_END			0x01
+#define MASK_BUF_UNDER				0x02
+#define MASK_BUF_NU2				0x04
+#define MASK_BUF_NU1				0x08
+#define MASK_BUF_CENTER				0x10
+#define MASK_BUF_NO1				0x20
+#define MASK_BUF_NO2				0x40
+#define MASK_BUF_OVER				0x80
+
+#define ERR_INT					0x8507
+#define ERR_INTM				0x8517
+#define MASK_DC_PPERR				0x01
+#define MASK_DC_BUFERR				0x02
+#define MASK_DC_DEERR				0x04
+#define MASK_DC_NOCD				0x08
+#define MASK_NO_AVI				0x10
+#define MASK_NO_ACP				0x20
+#define MASK_AU_FRAME				0x40
+#define MASK_EESS_ERR				0x80
+
+#define HDCP_INT				0x8508
+#define HDCP_INTM				0x8518
+#define MASK_AN_END				0x01
+#define MASK_AKSV_END				0x02
+#define MASK_KM_END				0x04
+#define MASK_R0_END				0x08
+#define MASK_SHA_END				0x10
+#define MASK_LINKERR				0x20
+#define MASK_AVM_CLR				0x40
+#define MASK_AVM_SET				0x80
+
+#define GBD_INT					0x8509
+#define GBD_INTM				0x8519
+#define MASK_GBD_ON				0x01
+#define MASK_GBD_OFF				0x02
+#define MASK_P1GBD_DET				0x04
+#define MASK_P0GBD_CHG				0x10
+#define MASK_P1GBD_CHG				0x20
+#define MASK_GBD_ACLR				0x40
+#define MASK_GBD_PKERR				0x80
+
+#define MISC_INT				0x850b
+#define MISC_INTM				0x851b
+#define MASK_AUDIO_MUTE				0x01
+#define MASK_SYNC_CHG				0x02
+#define MASK_NO_VS				0x04
+#define MASK_NO_SPD				0x08
+#define MASK_AS_LAYOUT				0x10
+#define MASK_VIDEO_COLOR			0x20
+#define MASK_AU_HBR_OFF				0x40
+#define MASK_AU_DSD_OFF				0x80
+
+/* *** STATUS *** */
+#define SYS_STATUS				0x8520
+#define MASK_S_SYNC				0x80
+#define MASK_S_AVMUTE				0x40
+#define MASK_S_HDCP				0x20
+#define MASK_S_HDMI				0x10
+#define MASK_S_PHY_SCDT				0x08
+#define MASK_S_PHY_PLL				0x04
+#define MASK_S_TMDS				0x02
+#define MASK_S_DDC5V				0x01
+
+#define VI_STATUS1				0x8522
+#define MASK_S_V_GBD				0x08
+#define MASK_S_DEEPCOLOR			0x0c
+#define MASK_S_V_422				0x02
+#define MASK_S_V_INTERLACE			0x01
+
+#define VI_STATUS3				0x8528
+#define MASK_S_V_COLOR				0x1f
+#define MASK_RGB_FULL				0x00
+#define MASK_RGB_LIMITED			0x01
+#define MASK_YCBCR601_FULL			0x02
+#define MASK_YCBCR601_LIMITED			0x03
+#define MASK_ADOBE_RGB_FULL			0x04
+#define MASK_ADOBE_RGB_LIMITED			0x05
+#define MASK_YCBCR709_FULL			0x06
+#define MASK_YCBCR709_LIMITED			0x07
+#define MASK_XVYCC601_FULL			0x0a
+#define MASK_XVYCC601_LIMITED			0x0b
+#define MASK_XVYCC709_FULL			0x0e
+#define MASK_XVYCC709_LIMITED			0x0f
+#define MASK_SYCC601_FULL			0x12
+#define MASK_SYCC601_LIMITED			0x13
+#define MASK_ADOBE_YCC601_FULL			0x1a
+#define MASK_ADOBE_YCC601_LIMITED		0x1b
+#define MASK_LIMITED                            0x01
+
+
+/* *** CSI TX (32 bit) *** */
+#define CSITX0_BASE_ADDR			0x0000
+#define CSITX1_BASE_ADDR			0x0200
+
+#define CSITX_CLKEN				0x0108
+#define MASK_CSITX_EN				(1 << 0)
+
+#define PPICLKEN				0x010c
+#define MASK_HSTXCLKEN				0x00000001
+
+#define MODECONF				0x0110	/* Not in Ref. v1.5 */
+#define MASK_CSI2MODE				(1 << 0)
+#define MASK_VSYNC_POL_SW			(1 << 1)
+#define MASK_HSYNC_POL_SW			(1 << 2)
+#define MASK_DTVALID_POL_SW			(1 << 3)
+#define MASK_INDMODE				(1 << 4)
+
+#define LANEEN					0x0118
+#define MASK_LANES				0x00000007
+#define MASK_LANE_0_EN				(1 << 0)
+#define MASK_LANE_0_1_EN			(2 << 0)
+#define MASK_LANE_0_1_2_EN			(3 << 0)
+#define MASK_LANE_0_1_2_3_EN			(4 << 0)
+#define MASK_LANES				0x00000007
+#define MASK_CLANEEN				(1 << 4)
+
+#define CSITX_START				0x011c
+#define LINEINITCNT				0x0120
+#define HSTOCNT					0x0124
+
+#define FUNCMODE				0x0150
+#define MASK_CONTCLKMODE			(1 << 5)
+#define MASK_FORCESTOP				(1 << 10)
+
+#define CSITX_INTERNAL_STAT			0x01B0
+
+#define LPTXTIMECNT				0x0254
+#define TCLK_HEADERCNT				0x0258
+#define TCLK_TRAILCNT				0x025c
+#define THS_HEADERCNT				0x0260
+#define TWAKEUP					0x0264
+#define TCLK_POSTCNT				0x0268
+#define THS_TRAILCNT				0x026c
+#define HSTXVREGCNT				0x0270
+
+#define HSTXVREGEN				0x0274
+#define MASK_D3M_HSTXVREGEN			0x0010
+#define MASK_D2M_HSTXVREGEN			0x0008
+#define MASK_D1M_HSTXVREGEN			0x0004
+#define MASK_D0M_HSTXVREGEN			0x0002
+#define MASK_CLM_HSTXVREGEN			0x0001
+
+#define MIPICLKEN				0x02a0
+#define MASK_MP_ENABLE				0x00000001
+#define MASK_MP_CKEN				0x00000002
+
+#define PLLCONF					0x02ac
+#define MASK_LFBREN				(1 << 9)
+#define MASK_MPLBW				0x00030000
+#define MASK_MPLBW_25				(0 << 16)
+#define MASK_MPLBW_33				(1 << 16)
+#define MASK_MPLBW_50				(2 << 16)
+#define MASK_MPLBW_MAX				(3 << 16)
+#define MASK_PLL_FBD				0x000000ff
+#define SET_PLL_FBD(fbd)			((fbd) & MASK_PLL_FBD)
+#define MASK_PLL_FRS				0x00000c00
+#define SET_PLL_FRS(frs)			(((frs) << 10) & MASK_PLL_FRS)
+#define MASK_PLL_PRD				0x0000f000
+#define SET_PLL_PRD(prd)			(((prd) << 12) & \
+						  MASK_PLL_PRD)
+#define MASK_PLL_LBW				0x00030000
+#define SET_PLL_LBW(lbw)			((((lbw) - 1) << 16) & \
+						  MASK_PLL_LBW)
+
+/* *** CEC (32 bit) *** */
+#define CECHCLK					0x0028	/* 16 bits */
+#define MASK_CECHCLK				(0x7ff << 0)
+
+#define CECLCLK					0x002a	/* 16 bits */
+#define MASK_CECLCLK				(0x7ff << 0)
+
+#define CECEN					0x0600
+#define MASK_CECEN				0x0001
+
+#define CECADD					0x0604
+#define CECRST					0x0608
+#define MASK_CECRESET				0x0001
+
+#define CECREN					0x060c
+#define MASK_CECREN				0x0001
+
+#define CECRCTL1				0x0614
+#define MASK_CECACKDIS				(1 << 24)
+#define MASK_CECHNC				(3 << 20)
+#define MASK_CECLNC				(7 << 16)
+#define MASK_CECMIN				(7 << 12)
+#define MASK_CECMAX				(7 << 8)
+#define MASK_CECDAT				(7 << 4)
+#define MASK_CECTOUT				(3 << 2)
+#define MASK_CECRIHLD				(1 << 1)
+#define MASK_CECOTH				(1 << 0)
+
+#define CECRCTL2				0x0618
+#define MASK_CECSWAV3				(7 << 12)
+#define MASK_CECSWAV2				(7 << 8)
+#define MASK_CECSWAV1				(7 << 4)
+#define MASK_CECSWAV0				(7 << 0)
+
+#define CECRCTL3				0x061c
+#define MASK_CECWAV3				(7 << 20)
+#define MASK_CECWAV2				(7 << 16)
+#define MASK_CECWAV1				(7 << 12)
+#define MASK_CECWAV0				(7 << 8)
+#define MASK_CECACKEI				(1 << 4)
+#define MASK_CECMINEI				(1 << 3)
+#define MASK_CECMAXEI				(1 << 2)
+#define MASK_CECRSTEI				(1 << 1)
+#define MASK_CECWAVEI				(1 << 0)
+
+#define CECTEN					0x0620
+#define MASK_CECTBUSY				(1 << 1)
+#define MASK_CECTEN				(1 << 0)
+
+#define CECTCTL					0x0628
+#define MASK_CECSTRS				(7 << 20)
+#define MASK_CECSPRD				(7 << 16)
+#define MASK_CECDTRS				(7 << 12)
+#define MASK_CECDPRD				(15 << 8)
+#define MASK_CECBRD				(1 << 4)
+#define MASK_CECFREE				(15 << 0)
+
+#define CECRSTAT				0x062c
+#define MASK_CECRIWA				(1 << 6)
+#define MASK_CECRIOR				(1 << 5)
+#define MASK_CECRIACK				(1 << 4)
+#define MASK_CECRIMIN				(1 << 3)
+#define MASK_CECRIMAX				(1 << 2)
+#define MASK_CECRISTA				(1 << 1)
+#define MASK_CECRIEND				(1 << 0)
+
+#define CECTSTAT				0x0630
+#define MASK_CECTIUR				(1 << 4)
+#define MASK_CECTIACK				(1 << 3)
+#define MASK_CECTIAL				(1 << 2)
+#define MASK_CECTIEND				(1 << 1)
+
+#define CECRBUF1				0x0634
+#define MASK_CECRACK				(1 << 9)
+#define MASK_CECEOM				(1 << 8)
+#define MASK_CECRBYTE				(0xff << 0)
+
+#define CECTBUF1				0x0674
+#define MASK_CECTEOM				(1 << 8)
+#define MASK_CECTBYTE				(0xff << 0)
+
+#define CECRCTR					0x06b4
+#define MASK_CECRCTR				(0x1f << 0)
+
+#define CECIMSK					0x06c0
+#define MASK_CECTIM				(1 << 1)
+#define MASK_CECRIM				(1 << 0)
+
+#define CECICLR					0x06cc
+#define MASK_CECTICLR				(1 << 1)
+#define MASK_CECRICLR				(1 << 0)
+
+/* *** Split Control (16 bit) *** */
+#define SPLITTX0_CTRL				0x5000
+#define SPLITTX1_CTRL				0x5080
+#define MASK_LCD_CSEL				0x0001
+#define MASK_IFEN				0x0002
+#define MASK_SPBP				0x0100
+
+#define SPLITTX0_WC				0x5008	/*Removed in rev. 1.1*/
+#define SPLITTX1_WC				0x5088	/*Removed in rev. 1.1*/
+
+#define SPLITTX0_SPLIT				0x500c
+#define SPLITTX1_SPLIT				0x508c
+#define MASK_FPXV				0x0fff
+/* NOTE: Only available for TX0 */
+#define MASK_TX1SEL				0x4000
+/* NOTE: Only available for TX0 */
+#define MASK_EHW				0x8000
+
+/* *** HDMI PHY (8 bit) *** */
+#define PHY_CTL					0x8410
+#define MASK_POWERCTL				(1 << 0)
+
+#define PHY_CTL2				0x8412
+#define MASK_PHY_FREE_RUN			(1 << 5)
+
+#define PHY_ENB					0x8413
+#define MASK_ENABLE_PHY				0x01
+
+#define PHY_RST					0x8414
+#define MASK_RESET_CTRL				0x01	/* Reset active low */
+
+#define APPL_CTL				0x84f0
+#define MASK_APLL_ON				0x01
+#define MASK_APLL_CPCTL				0x30
+#define MASK_APLL_CPCTL_HIZ			0x00
+#define MASK_APLL_CPCTL_LFIX			0x10
+#define MASK_APLL_CPCTL_HFIX			0x20
+#define MASK_APLL_CPCTL_NORMAL			0x30
+
+#define DDCIO_CTL				0x84f4
+#define MASK_DDC_PWR_ON				(1 << 0)
+
+/** *** HDMI Clock (8 bit) *** */
+#define AU_STATUS0				0x8523
+#define MASK_S_A_SAMPLE				0x01
+
+#define SYS_FREQ0				0x8540
+#define SYS_FREQ1				0x8541
+#define LOCK_REF_FREQA				0x8630
+#define LOCK_REF_FREQB				0x8631
+#define LOCK_REF_FREQC				0x8632
+
+#define FS_SET					0x8621
+#define MASK_FS					0x0f
+
+#define CLK_STATUS				0x8526
+#define MASK_S_V_HPOL				(1 << 3)
+#define MASK_S_V_VPOL				(1 << 2)
+
+#define NCO_F0_MOD				0x8670
+#define MASK_NCO_F0_MOD_42MHZ			0x00
+#define MASK_NCO_F0_MOD_REG			0x02
+
+#define NCO_48F0A				0x8671
+#define NCO_48F0B				0x8672
+#define NCO_48F0C				0x8673
+#define NCO_48F0D				0x8674
+
+#define NCO_44F0A				0x8675
+#define NCO_44F0B				0x8676
+#define NCO_44F0C				0x8677
+#define NCO_44F0D				0x8678
+
+#define SCLK_CSC0				0x8a0c
+#define SCLK_CSC1				0x8a0d
+
+#define HDCP_MODE				0x8560
+#define MASK_MODE_RST_TN			0x20
+#define MASK_LINE_REKEY				0x10
+#define MASK_AUTO_CLR				0x04
+
+#define HDCP_REG1				0x8563 /* Not in REF_01 */
+#define MASK_AUTH_UNAUTH_SEL			0x70
+#define MASK_AUTH_UNAUTH_SEL_12_FRAMES		0x70
+#define MASK_AUTH_UNAUTH_SEL_8_FRAMES		0x60
+#define MASK_AUTH_UNAUTH_SEL_4_FRAMES		0x50
+#define MASK_AUTH_UNAUTH_SEL_2_FRAMES		0x40
+#define MASK_AUTH_UNAUTH_SEL_64_FRAMES		0x30
+#define MASK_AUTH_UNAUTH_SEL_32_FRAMES		0x20
+#define MASK_AUTH_UNAUTH_SEL_16_FRAMES		0x10
+#define MASK_AUTH_UNAUTH_SEL_ONCE		0x00
+#define MASK_AUTH_UNAUTH			0x01
+#define MASK_AUTH_UNAUTH_AUTO			0x01
+
+#define HDCP_REG2				0x8564 /* Not in REF_01 */
+#define MASK_AUTO_P3_RESET			0x0f
+#define SET_AUTO_P3_RESET_FRAMES(n)		(n & MASK_AUTO_P3_RESET)
+#define MASK_AUTO_P3_RESET_OFF			0x00
+
+
+/* *** VI *** */
+#define VI_MODE					0x8570
+/* TODO: Probably wrong bit (see p. 292 rev. 0.93) */
+#define MASK_RGB_DVI				0x08
+
+#define DE_HSIZE_LO				0x8582
+#define DE_HSIZE_HI				0x8583
+#define DE_VSIZE_LO				0x858c
+#define DE_VSIZE_HI				0x858d
+
+#define IN_HSIZE_LO				0x858e
+#define IN_HSIZE_HI				0x858f
+
+#define IN_VSIZE_LO				0x8590
+#define IN_VSIZE_HI				0x8591
+
+#define HV_CLR					0x8593
+#define MASK_HV_HOLD				0x80
+#define MASK_HV_DEV_CLR				0x20
+#define MASK_HV_DEH_CLR				0x10
+#define MASK_HV_V_CLR				0x02
+#define MASK_HV_H_CLR				0x01
+
+#define FV_CNT_LO				0x85c1	/* Undocumented */
+#define FV_CNT_HI				0x85c2	/* Undocumented */
+
+#define FH_MIN0					0x85ca /* Not in REF_01 */
+#define FH_MIN1					0x85cb /* Not in REF_01 */
+#define FH_MAX0					0x85cc /* Not in REF_01 */
+#define FH_MAX1					0x85cd /* Not in REF_01 */
+
+#define HV_RST					0x85cf /* Not in REF_01 */
+#define MASK_H_PI_RST				0x20
+#define MASK_V_PI_RST				0x10
+
+#define HDCP_REG3				0x85d1 /* Not in REF_01 */
+#define KEY_RD_CMD				0x01
+
+/* *** EDID (8 bit) *** */
+#define EDID_MODE				0x85e0
+#define MASK_DIRECT				0x00
+#define MASK_RAM_DDC2B				(1 << 0)
+#define MASK_RAM_EDDC				(1 << 1)
+#define MASK_EDID_MODE_ALL			0x03
+
+#define EDID_LEN1				0x85e3
+#define EDID_LEN2				0x85e4
+
+#define EDID_RAM				0x8c00
+
+/* *** HDCP *** */
+#define BKSV					0x8800
+
+#define BCAPS					0x8840
+#define MASK_HDMI_RSVD				0x80
+#define MASK_REPEATER				0x40
+#define MASK_READY				0x20
+#define MASK_FASTI2C				0x10
+#define MASK_1_1_FEA				0x02
+#define MASK_FAST_REAU				0x01
+
+#define BSTATUS0				0x8841
+#define BSTATUS1				0x8842
+#define MASK_HDMI_MODE				0x10
+#define MASK_MAX_EXCED				0x08
+
+/* *** Video Output Format (8 bit) *** */
+#define VOUT_FMT				0x8a00
+#define MASK_OUTFMT_444_RGB			(0 << 0)
+#define MASK_OUTFMT_422				(1 << 0)
+#define MASK_OUTFMT_THROUGH			(2 << 0)
+#define MASK_422FMT_NORMAL			(0 << 4)
+#define MASK_422FMT_HDMITHROUGH			(1 << 4)
+
+#define VOUT_FIL				0x8a01
+#define MASK_422FIL				0x07
+#define MASK_422FIL_2_TAP			(0 << 0)
+#define MASK_422FIL_3_TAP			(1 << 0)
+#define MASK_422FIL_NO_FILTER			(2 << 0)
+#define MASK_422FIL_2_TAP_444			(3 << 0)
+#define MASK_422FIL_3_TAP_444			(4 << 0)
+#define MASK_422FIL_2_TAP_444_CSC		(5 << 0)
+#define MASK_422FIL_3_TAP_444_CSC		(6 << 0)
+#define MASK_444FIL				0x10
+#define MASK_444FIL_REPEAT			(0 << 4)
+#define MASK_444FIL_2_TAP			(1 << 4)
+
+#define VOUT_SYNC0				0x8a02
+#define MASK_MODE_2				(2 << 0)
+#define MASK_MODE_3				(3 << 0)
+#define MASK_M3_HSIZE				0x30
+#define MASK_M3_VSIZE				0xc0
+
+#define VOUT_CSC				0x8a08
+#define MASK_CSC_MODE				0x03
+#define MASK_CSC_MODE_OFF			(0 << 0)
+#define MASK_CSC_MODE_BUILTIN			(1 << 0)
+#define MASK_CSC_MODE_AUTO			(2 << 0)
+#define MASK_CSC_MODE_HOST			(3 << 0)
+#define MASK_COLOR				0x70
+#define MASK_COLOR_RGB_FULL			(0 << 4)
+#define MASK_COLOR_RGB_LIMITED			(1 << 4)
+#define MASK_COLOR_601_YCBCR_FULL		(2 << 4)
+#define MASK_COLOR_601_YCBCR_LIMITED		(3 << 4)
+#define MASK_COLOR_709_YCBCR_FULL		(4 << 4)
+#define MASK_COLOR_709_YCBCR_LIMITED		(5 << 4)
+#define MASK_COLOR_FULL_TO_LIMITED		(6 << 4)
+#define MASK_COLOR_LIMITED_TO_FULL		(7 << 4)
+
+
+/* *** HDMI Audio RefClk (8 bit) *** */
+#define FORCE_MUTE				0x8600
+#define MASK_FORCE_DMUTE			(1 << 0)
+#define MASK_FORCE_AMUTE			(1 << 4)
+
+#define AUTO_CMD0				0x8602
+#define MASK_AUTO_MUTE7				0x80
+#define MASK_AUTO_MUTE6				0x40
+#define MASK_AUTO_MUTE5				0x20
+#define MASK_AUTO_MUTE4				0x10
+#define MASK_AUTO_MUTE3				0x08
+#define MASK_AUTO_MUTE2				0x04
+#define MASK_AUTO_MUTE1				0x02
+#define MASK_AUTO_MUTE0				0x01
+
+#define AUTO_CMD1				0x8603
+#define MASK_AUTO_MUTE10			0x04
+#define MASK_AUTO_MUTE9				0x02
+#define MASK_AUTO_MUTE8				0x01
+
+#define AUTO_CMD2				0x8604
+#define MASK_AUTO_PLAY3				0x08
+#define MASK_AUTO_PLAY2				0x04
+
+#define BUFINIT_START				0x8606
+#define SET_BUFINIT_START_MS(milliseconds)	((milliseconds) / 100)
+
+#define FS_MUTE					0x8607
+#define MASK_FS_ELSE_MUTE			0x80
+#define MASK_FS22_MUTE				0x40
+#define MASK_FS24_MUTE				0x20
+#define MASK_FS88_MUTE				0x10
+#define MASK_FS96_MUTE				0x08
+#define MASK_FS176_MUTE				0x04
+#define MASK_FS192_MUTE				0x02
+#define MASK_FS_NO_MUTE				0x01
+
+#define FS_IMODE				0x8620
+#define MASK_NLPCM_HMODE			0x40
+#define MASK_NLPCM_SMODE			0x20
+#define MASK_NLPCM_IMODE			0x10
+#define MASK_FS_HMODE				0x08
+#define MASK_FS_AMODE				0x04
+#define MASK_FS_SMODE				0x02
+#define MASK_FS_IMODE				0x01
+
+#define ACR_MODE				0x8640
+#define MASK_ACR_LOAD				0x10
+#define MASK_N_MODE				0x04
+#define MASK_CTS_MODE				0x01
+
+#define ACR_MDF0				0x8641
+#define MASK_ACR_L2MDF				0x70
+#define MASK_ACR_L2MDF_0_PPM			0x00
+#define MASK_ACR_L2MDF_61_PPM			0x10
+#define MASK_ACR_L2MDF_122_PPM			0x20
+#define MASK_ACR_L2MDF_244_PPM			0x30
+#define MASK_ACR_L2MDF_488_PPM			0x40
+#define MASK_ACR_L2MDF_976_PPM			0x50
+#define MASK_ACR_L2MDF_1976_PPM			0x60
+#define MASK_ACR_L2MDF_3906_PPM			0x70
+#define MASK_ACR_L1MDF				0x07
+#define MASK_ACR_L1MDF_0_PPM			0x00
+#define MASK_ACR_L1MDF_61_PPM			0x01
+#define MASK_ACR_L1MDF_122_PPM			0x02
+#define MASK_ACR_L1MDF_244_PPM			0x03
+#define MASK_ACR_L1MDF_488_PPM			0x04
+#define MASK_ACR_L1MDF_976_PPM			0x05
+#define MASK_ACR_L1MDF_1976_PPM			0x06
+#define MASK_ACR_L1MDF_3906_PPM			0x07
+
+#define ACR_MDF1				0x8642
+#define MASK_ACR_L3MDF				0x07
+#define MASK_ACR_L3MDF_0_PPM			0x00
+#define MASK_ACR_L3MDF_61_PPM			0x01
+#define MASK_ACR_L3MDF_122_PPM			0x02
+#define MASK_ACR_L3MDF_244_PPM			0x03
+#define MASK_ACR_L3MDF_488_PPM			0x04
+#define MASK_ACR_L3MDF_976_PPM			0x05
+#define MASK_ACR_L3MDF_1976_PPM			0x06
+#define MASK_ACR_L3MDF_3906_PPM			0x07
+
+#define SDO_MODE1				0x8652
+#define MASK_SDO_BIT_LENG			0x70
+#define MASK_SDO_FMT				0x03
+#define MASK_SDO_FMT_RIGHT			0x00
+#define MASK_SDO_FMT_LEFT			0x01
+#define MASK_SDO_FMT_I2S			0x02
+
+#define DIV_MODE				0x8665 /* Not in REF_01 */
+#define MASK_DIV_DLY				0xf0
+#define SET_DIV_DLY_MS(milliseconds)		((((milliseconds)/100) << 4) & \
+						MASK_DIV_DLY)
+#define MASK_DIV_MODE				0x01
+
+#define HDMIAUDIO_MODE				0x8680
+
+/* *** HDMI General (16 bit) *** */
+#define DDC_CTL					0x8543
+#define MASK_DDC_ACTION				0x04
+#define MASK_DDC5V_MODE				0x03
+#define MASK_DDC5V_MODE_0MS			0x00
+#define MASK_DDC5V_MODE_50MS			0x01
+#define MASK_DDC5V_MODE_100MS			0x02
+#define MASK_DDC5V_MODE_200MS			0x03
+
+#define HPD_CTL					0x8544
+#define MASK_HPD_OUT0				(1 << 0)
+#define MASK_HPD_CTL0				(1 << 4)
+
+#define INIT_END				0x854a
+#define MASK_INIT_END				0x01
+
+/* *** Video Mute *** */
+#define VI_MUTE					0x857f
+#define MASK_AUTO_MUTE				0xc0
+#define MASK_VI_MUTE				0x10
+#define MASK_VI_BLACK				0x01
+
+/* *** Info Frame *** */
+#define PK_INT_MODE				0x8709
+#define MASK_ISRC2_INT_MODE			0x80
+#define MASK_ISRC_INT_MODE			0x40
+#define MASK_ACP_INT_MODE			0x20
+#define MASK_VS_INT_MODE			0x10
+#define MASK_SPD_INT_MODE			0x08
+#define MASK_MS_INT_MODE			0x04
+#define MASK_AUD_INT_MODE			0x02
+#define MASK_AVI_INT_MODE			0x01
+
+#define NO_PKT_LIMIT				0x870b
+#define MASK_NO_ACP_LIMIT			0xf0
+#define SET_NO_ACP_LIMIT_MS(milliseconds)	((((milliseconds)/80) << 4) & \
+						  MASK_NO_ACP_LIMIT)
+
+#define NO_PKT_CLR				0x870c
+#define MASK_NO_VS_CLR				0x40
+#define MASK_NO_SPD_CLR				0x20
+#define MASK_NO_ACP_CLR				0x10
+#define MASK_NO_AVI_CLR1			0x02
+#define MASK_NO_AVI_CLR0			0x01
+
+#define ERR_PK_LIMIT				0x870d
+#define NO_PKT_LIMIT2				0x870e
+#define PK_AVI_0HEAD				0x8710
+#define PK_AVI_1HEAD				0x8711
+#define PK_AVI_2HEAD				0x8712
+#define PK_AVI_0BYTE				0x8713
+#define PK_AVI_1BYTE				0x8714
+#define PK_AVI_2BYTE				0x8715
+#define PK_AVI_3BYTE				0x8716
+#define PK_AVI_4BYTE				0x8717
+#define PK_AVI_5BYTE				0x8718
+#define PK_AVI_6BYTE				0x8719
+#define PK_AVI_7BYTE				0x871a
+#define PK_AVI_8BYTE				0x871b
+#define PK_AVI_9BYTE				0x871c
+#define PK_AVI_10BYTE				0x871d
+#define PK_AVI_11BYTE				0x871e
+#define PK_AVI_12BYTE				0x871f
+#define PK_AVI_13BYTE				0x8720
+#define PK_AVI_14BYTE				0x8721
+#define PK_AVI_15BYTE				0x8722
+#define PK_AVI_16BYTE				0x8723
+
+#define PK_SPD_0HEAD				0x8750
+
+#define PK_VS_0HEAD				0x8770
+
+#define NO_GDB_LIMIT				0x9007
+
+/* *** Color Bar (16 bit) *** */
+#define CB_CTL					0x7000
+#define MASK_CB_EN				0x01
+#define MASK_CB_TYPE				(0x03 << 1)
+#define MASK_CB_TYPE_COLOR_BAR			(0x02 << 1)
+#define MASK_CB_TYPE_COLOR_CHECKERS		(0x03 << 1)
+#define MASK_CB_CSEL				(0x01 << 3)
+#define MASK_CB_CSEL_CSI_TX0			0x00
+#define MASK_CB_CSEL_CSI_TX1			(0x01 << 3)
+#define CB_HSW					0x7008
+#define CB_VSW					0x700a
+#define CB_HTOTAL				0x700c
+#define CB_VTOTAL				0x700e
+#define CB_HACT					0x7010
+#define CB_VACT					0x7012
+#define CB_HSTART				0x7014
+#define CB_VSTART				0x7016
+
+#endif  /* __TC358840_REGS__ */
diff --git a/include/media/i2c/tc358840.h b/include/media/i2c/tc358840.h
new file mode 100644
index 0000000..44a7055
--- /dev/null
+++ b/include/media/i2c/tc358840.h
@@ -0,0 +1,91 @@
+/*
+ * tc358840.h - Toshiba UH2C/D HDMI-CSI bridge driver
+ *
+ * Copyright (c) 2015, Armin Weiss <weii@zhaw.ch>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _TC358840_
+#define _TC358840_
+
+enum tc358840_csi_port {
+	CSI_TX_NONE = 0,
+	CSI_TX_0,
+	CSI_TX_1,
+	CSI_TX_BOTH
+};
+
+enum tc358840_clock_mode {
+	CSI_NON_CONT_CLK = 0,
+	CSI_CONT_CLK
+};
+
+enum tc358840_ddc5v_delays {
+	DDC5V_DELAY_0MS,
+	DDC5V_DELAY_50MS,
+	DDC5V_DELAY_100MS,
+	DDC5V_DELAY_200MS,
+	DDC5V_DELAY_MAX = DDC5V_DELAY_200MS,
+};
+
+struct tc358840_platform_data {
+	/* GPIOs */
+	int reset_gpio;		/* Pin K8 */
+
+	struct v4l2_of_endpoint endpoint;
+
+	/* System clock connected to REFCLK (pin K9) */
+	u32 refclk_hz;		/* 40 - 50 MHz */
+
+	/* DDC +5V debounce delay */
+	enum tc358840_ddc5v_delays ddc5v_delay;
+
+	/* HDCP */
+	/* TODO: Not yet implemented */
+	bool enable_hdcp;
+
+	/* CSI Output */
+	enum tc358840_csi_port csi_port;
+
+	/* CSI */
+	/* The values in brackets can serve as a starting point. */
+	u32 lineinitcnt;	/* (0x00000FA0) */
+	u32 lptxtimecnt;	/* (0x00000004) */
+	u32 tclk_headercnt;	/* (0x00180203) */
+	u32 tclk_trailcnt;	/* (0x00040005) */
+	u32 ths_headercnt;	/* (0x000D0004) */
+	u32 twakeup;		/* (0x00003E80) */
+	u32 tclk_postcnt;	/* (0x0000000A) */
+	u32 ths_trailcnt;	/* (0x00080006) */
+	u32 hstxvregcnt;	/* (0x00000020) */
+	u32 btacnt;		/* (0x00040003) */
+
+	/* PLL */
+	/* Bps per lane is (refclk_hz / (prd + 1) * (fbd + 1)) / 2^frs */
+	u16 pll_prd;
+	u16 pll_fbd;
+	u16 pll_frs;
+};
+
+/* custom controls */
+#define V4L2_CID_USER_TC358840_BASE (V4L2_CID_BASE + 0x1000)
+
+/* Audio sample rate in Hz */
+#define TC358840_CID_AUDIO_SAMPLING_RATE (V4L2_CID_USER_TC358840_BASE + 1)
+/* Audio present status */
+#define TC358840_CID_AUDIO_PRESENT       (V4L2_CID_USER_TC358840_BASE + 2)
+/* Splitter width */
+#define TC358840_CID_SPLITTER_WIDTH      (V4L2_CID_USER_TC358840_BASE + 3)
+
+#endif /* _TC358840_ */
-- 
2.8.1


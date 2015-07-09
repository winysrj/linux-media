Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:57745 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbbGIIzm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2015 04:55:42 -0400
From: matrandg@cisco.com
To: linux-media@vger.kernel.org
Cc: hansverk@cisco.com, p.zabel@pengutronix.de, kernel@pengutronix.de,
	Mats Randgaard <matrandg@cisco.com>
Subject: [RFC v04] Driver for Toshiba TC358743 HDMI to CSI-2 bridge
Date: Thu,  9 Jul 2015 10:45:47 +0200
Message-Id: <1436431547-27319-2-git-send-email-matrandg@cisco.com>
In-Reply-To: <1436431547-27319-1-git-send-email-matrandg@cisco.com>
References: <1436431547-27319-1-git-send-email-matrandg@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mats Randgaard <matrandg@cisco.com>

The driver is tested on our hardware and all the implemented features
works as expected.

Missing features:
- CEC support
- HDCP repeater support
- IR support

Signed-off-by: Mats Randgaard <matrandg@cisco.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8133cef..fb98b8d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10303,6 +10303,13 @@ F:	drivers/char/toshiba.c
 F:	include/linux/toshiba.h
 F:	include/uapi/linux/toshiba.h
 
+TOSHIBA TC358743 DRIVER
+M:	Mats Randgaard <matrandg@cisco.com>
+L:	linux-media@vger.kernel.org
+S:	Maintained
+F:	drivers/media/i2c/tc358743*
+F:	include/media/tc358743.h
+
 TMIO MMC DRIVER
 M:	Ian Molton <ian@mnementh.co.uk>
 L:	linux-mmc@vger.kernel.org
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 71ee8f5..3308706 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -286,6 +286,15 @@ config VIDEO_SAA711X
 	  To compile this driver as a module, choose M here: the
 	  module will be called saa7115.
 
+config VIDEO_TC358743
+	tristate "Toshiba TC358743 decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Toshiba TC358743 HDMI to MIPI CSI-2 bridge
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tc358743.
+
 config VIDEO_TVP514X
 	tristate "Texas Instruments TVP514x video decoder"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index f165fae..07db257 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -78,3 +78,4 @@ obj-$(CONFIG_VIDEO_AK881X)		+= ak881x.o
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-$(CONFIG_VIDEO_ML86V7667)	+= ml86v7667.o
 obj-$(CONFIG_VIDEO_OV2659)	+= ov2659.o
+obj-$(CONFIG_VIDEO_TC358743)	+= tc358743.o
diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
new file mode 100644
index 0000000..34d4f32
--- /dev/null
+++ b/drivers/media/i2c/tc358743.c
@@ -0,0 +1,1778 @@
+/*
+ * tc358743 - Toshiba HDMI to CSI-2 bridge
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights
+ * reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+/*
+ * References (c = chapter, p = page):
+ * REF_01 - Toshiba, TC358743XBG (H2C), Functional Specification, Rev 0.60
+ * REF_02 - Toshiba, TC358743XBG_HDMI-CSI_Tv11p_nm.xls
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/videodev2.h>
+#include <linux/workqueue.h>
+#include <linux/v4l2-dv-timings.h>
+#include <linux/hdmi.h>
+#include <media/v4l2-dv-timings.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/tc358743.h>
+
+#include "tc358743_regs.h"
+
+static int debug;
+module_param(debug, int, 0644);
+MODULE_PARM_DESC(debug, "debug level (0-3)");
+
+MODULE_DESCRIPTION("Toshiba TC358743 HDMI to CSI-2 bridge driver");
+MODULE_AUTHOR("Ramakrishnan Muthukrishnan <ram@rkrishnan.org>");
+MODULE_AUTHOR("Mikhail Khelik <mkhelik@cisco.com>");
+MODULE_AUTHOR("Mats Randgaard <matrandg@cisco.com>");
+MODULE_LICENSE("GPL");
+
+#define EDID_NUM_BLOCKS_MAX 8
+#define EDID_BLOCK_SIZE 128
+
+static const struct v4l2_dv_timings_cap tc358743_timings_cap = {
+	.type = V4L2_DV_BT_656_1120,
+	/* keep this initialization for compatibility with GCC < 4.4.6 */
+	.reserved = { 0 },
+	/* Pixel clock from REF_01 p. 20. Min/max height/width are unknown */
+	V4L2_INIT_BT_TIMINGS(1, 10000, 1, 10000, 0, 165000000,
+			V4L2_DV_BT_STD_CEA861 | V4L2_DV_BT_STD_DMT |
+			V4L2_DV_BT_STD_GTF | V4L2_DV_BT_STD_CVT,
+			V4L2_DV_BT_CAP_PROGRESSIVE |
+			V4L2_DV_BT_CAP_REDUCED_BLANKING |
+			V4L2_DV_BT_CAP_CUSTOM)
+};
+
+struct tc358743_state {
+	struct tc358743_platform_data pdata;
+	struct v4l2_subdev sd;
+	struct media_pad pad;
+	struct v4l2_ctrl_handler hdl;
+	struct i2c_client *i2c_client;
+	/* CONFCTL is modified in both process context and interrupt context */
+	struct mutex confctl_mutex;
+
+	/* controls */
+	struct v4l2_ctrl *detect_tx_5v_ctrl;
+	struct v4l2_ctrl *audio_sampling_rate_ctrl;
+	struct v4l2_ctrl *audio_present_ctrl;
+
+	/* work queues */
+	struct workqueue_struct *work_queues;
+	struct delayed_work delayed_work_enable_hotplug;
+
+	/* edid  */
+	u8 edid_blocks_written;
+
+	struct v4l2_dv_timings timings;
+	u32 mbus_fmt_code;
+};
+
+static void tc358743_enable_interrupts(struct v4l2_subdev *sd,
+		bool cable_connected);
+static int tc358743_s_ctrl_detect_tx_5v(struct v4l2_subdev *sd);
+
+static inline struct tc358743_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tc358743_state, sd);
+}
+
+/* --------------- I2C --------------- */
+
+static void i2c_rd(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
+{
+	struct tc358743_state *state = to_state(sd);
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
+				__func__, reg, client->addr);
+	}
+}
+
+static void i2c_wr(struct v4l2_subdev *sd, u16 reg, u8 *values, u32 n)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct i2c_client *client = state->i2c_client;
+	int err, i;
+	struct i2c_msg msg;
+	u8 data[2 + n];
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
+				__func__, reg, client->addr);
+		return;
+	}
+
+	if (debug < 3)
+		return;
+
+	switch (n) {
+	case 1:
+		v4l2_info(sd, "I2C write 0x%04x = 0x%02x",
+				reg, data[2]);
+		break;
+	case 2:
+		v4l2_info(sd, "I2C write 0x%04x = 0x%02x%02x",
+				reg, data[3], data[2]);
+		break;
+	case 4:
+		v4l2_info(sd, "I2C write 0x%04x = 0x%02x%02x%02x%02x",
+				reg, data[5], data[4], data[3], data[2]);
+		break;
+	default:
+		v4l2_info(sd, "I2C write %d bytes from address 0x%04x\n",
+				n, reg);
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
+static unsigned tc358743_num_csi_lanes_in_use(struct v4l2_subdev *sd)
+{
+	return ((i2c_rd32(sd, CSI_CONTROL) & MASK_NOL) >> 1) + 1;
+}
+
+/* --------------- TIMINGS --------------- */
+
+static inline unsigned fps(const struct v4l2_bt_timings *t)
+{
+	if (!V4L2_DV_BT_FRAME_HEIGHT(t) || !V4L2_DV_BT_FRAME_WIDTH(t))
+		return 0;
+
+	return DIV_ROUND_CLOSEST((unsigned)t->pixelclock,
+			V4L2_DV_BT_FRAME_HEIGHT(t) * V4L2_DV_BT_FRAME_WIDTH(t));
+}
+
+static int tc358743_get_detected_timings(struct v4l2_subdev *sd,
+				     struct v4l2_dv_timings *timings)
+{
+	struct v4l2_bt_timings *bt = &timings->bt;
+	unsigned width, height, frame_width, frame_height, frame_interval, fps;
+
+	memset(timings, 0, sizeof(struct v4l2_dv_timings));
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
+	bt->interlaced = i2c_rd8(sd, VI_STATUS1) & MASK_S_V_INTERLACE ?
+		V4L2_DV_INTERLACED : V4L2_DV_PROGRESSIVE;
+
+	width = ((i2c_rd8(sd, DE_WIDTH_H_HI) & 0x1f) << 8) +
+		i2c_rd8(sd, DE_WIDTH_H_LO);
+	height = ((i2c_rd8(sd, DE_WIDTH_V_HI) & 0x1f) << 8) +
+		i2c_rd8(sd, DE_WIDTH_V_LO);
+	frame_width = ((i2c_rd8(sd, H_SIZE_HI) & 0x1f) << 8) +
+		i2c_rd8(sd, H_SIZE_LO);
+	frame_height = (((i2c_rd8(sd, V_SIZE_HI) & 0x3f) << 8) +
+		i2c_rd8(sd, V_SIZE_LO)) / 2;
+	/* frame interval in milliseconds * 10
+	 * Require SYS_FREQ0 and SYS_FREQ1 are precisely set */
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
+	if (bt->interlaced == V4L2_DV_INTERLACED) {
+		bt->height *= 2;
+		bt->il_vsync = bt->vsync + 1;
+		bt->pixelclock /= 2;
+	}
+
+	return 0;
+}
+
+/* --------------- HOTPLUG / HDCP / EDID --------------- */
+
+static void tc358743_delayed_work_enable_hotplug(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct tc358743_state *state = container_of(dwork,
+			struct tc358743_state, delayed_work_enable_hotplug);
+	struct v4l2_subdev *sd = &state->sd;
+
+	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
+
+	i2c_wr8_and_or(sd, HPD_CTL, ~MASK_HPD_OUT0, MASK_HPD_OUT0);
+}
+
+static void tc358743_set_hdmi_hdcp(struct v4l2_subdev *sd, bool enable)
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
+	/* HDCP is disabled by configuring the receiver as HDCP repeater. The
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
+static void tc358743_disable_edid(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
+
+	cancel_delayed_work_sync(&state->delayed_work_enable_hotplug);
+
+	/* DDC access to EDID is also disabled when hotplug is disabled. See
+	 * register DDC_CTL */
+	i2c_wr8_and_or(sd, HPD_CTL, ~MASK_HPD_OUT0, 0x0);
+}
+
+static void tc358743_enable_edid(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	if (state->edid_blocks_written == 0) {
+		v4l2_dbg(2, debug, sd, "%s: no EDID -> no hotplug\n", __func__);
+		return;
+	}
+
+	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
+
+	/* Enable hotplug after 100 ms. DDC access to EDID is also enabled when
+	 * hotplug is enabled. See register DDC_CTL */
+	queue_delayed_work(state->work_queues,
+			   &state->delayed_work_enable_hotplug, HZ / 10);
+
+	tc358743_enable_interrupts(sd, true);
+	tc358743_s_ctrl_detect_tx_5v(sd);
+}
+
+static void tc358743_erase_bksv(struct v4l2_subdev *sd)
+{
+	int i;
+
+	for (i = 0; i < 5; i++)
+		i2c_wr8(sd, BKSV + i, 0);
+}
+
+/* --------------- AVI infoframe --------------- */
+
+static void print_avi_infoframe(struct v4l2_subdev *sd)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	struct device *dev = &client->dev;
+	union hdmi_infoframe frame;
+	u8 buffer[HDMI_INFOFRAME_SIZE(AVI)];
+
+	if (!is_hdmi(sd)) {
+		v4l2_info(sd, "DVI-D signal - AVI infoframe not supported\n");
+		return;
+	}
+
+	i2c_rd(sd, PK_AVI_0HEAD, buffer, HDMI_INFOFRAME_SIZE(AVI));
+
+	if (hdmi_infoframe_unpack(&frame, buffer) < 0) {
+		v4l2_err(sd, "%s: unpack of AVI infoframe failed\n", __func__);
+		return;
+	}
+
+	hdmi_infoframe_log(KERN_INFO, dev, &frame);
+}
+
+/* --------------- CTRLS --------------- */
+
+static int tc358743_s_ctrl_detect_tx_5v(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	return v4l2_ctrl_s_ctrl(state->detect_tx_5v_ctrl,
+			tx_5v_power_present(sd));
+}
+
+static int tc358743_s_ctrl_audio_sampling_rate(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	return v4l2_ctrl_s_ctrl(state->audio_sampling_rate_ctrl,
+			get_audio_sampling_rate(sd));
+}
+
+static int tc358743_s_ctrl_audio_present(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	return v4l2_ctrl_s_ctrl(state->audio_present_ctrl,
+			audio_present(sd));
+}
+
+static int tc358743_update_controls(struct v4l2_subdev *sd)
+{
+	int ret = 0;
+
+	ret |= tc358743_s_ctrl_detect_tx_5v(sd);
+	ret |= tc358743_s_ctrl_audio_sampling_rate(sd);
+	ret |= tc358743_s_ctrl_audio_present(sd);
+
+	return ret;
+}
+
+/* --------------- INIT --------------- */
+
+static void tc358743_reset_phy(struct v4l2_subdev *sd)
+{
+	v4l2_dbg(1, debug, sd, "%s:\n", __func__);
+
+	i2c_wr8_and_or(sd, PHY_RST, ~MASK_RESET_CTRL, 0);
+	i2c_wr8_and_or(sd, PHY_RST, ~MASK_RESET_CTRL, MASK_RESET_CTRL);
+}
+
+static void tc358743_reset(struct v4l2_subdev *sd, uint16_t mask)
+{
+	u16 sysctl = i2c_rd16(sd, SYSCTL);
+
+	i2c_wr16(sd, SYSCTL, sysctl | mask);
+	i2c_wr16(sd, SYSCTL, sysctl & ~mask);
+}
+
+static inline void tc358743_sleep_mode(struct v4l2_subdev *sd, bool enable)
+{
+	i2c_wr16_and_or(sd, SYSCTL, ~MASK_SLEEP,
+			enable ? MASK_SLEEP : 0);
+}
+
+static inline void enable_stream(struct v4l2_subdev *sd, bool enable)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	v4l2_dbg(3, debug, sd, "%s: %sable\n",
+			__func__, enable ? "en" : "dis");
+
+	if (enable) {
+		/* It is critical for CSI receiver to see lane transition
+		 * LP11->HS. Set to non-continuous mode to enable clock lane
+		 * LP11 state. */
+		i2c_wr32(sd, TXOPTIONCNTRL, 0);
+		/* Set to continuous mode to trigger LP11->HS transition */
+		i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);
+		/* Unmute video */
+		i2c_wr8(sd, VI_MUTE, MASK_AUTO_MUTE);
+	} else {
+		/* Mute video so that all data lanes go to LSP11 state.
+		 * No data is output to CSI Tx block. */
+		i2c_wr8(sd, VI_MUTE, MASK_AUTO_MUTE | MASK_VI_MUTE);
+	}
+
+	mutex_lock(&state->confctl_mutex);
+	i2c_wr16_and_or(sd, CONFCTL, ~(MASK_VBUFEN | MASK_ABUFEN),
+			enable ? (MASK_VBUFEN | MASK_ABUFEN) : 0x0);
+	mutex_unlock(&state->confctl_mutex);
+}
+
+static void tc358743_set_pll(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct tc358743_platform_data *pdata = &state->pdata;
+	u16 pllctl0 = i2c_rd16(sd, PLLCTL0);
+	u16 pllctl1 = i2c_rd16(sd, PLLCTL1);
+	u16 pllctl0_new = SET_PLL_PRD(pdata->pll_prd) |
+		SET_PLL_FBD(pdata->pll_fbd);
+	u32 hsck = (pdata->refclk_hz / pdata->pll_prd) * pdata->pll_fbd;
+
+	v4l2_dbg(2, debug, sd, "%s:\n", __func__);
+
+	/* Only rewrite when needed (new value or disabled), since rewriting
+	 * triggers another format change event. */
+	if ((pllctl0 != pllctl0_new) || ((pllctl1 & MASK_PLL_EN) == 0)) {
+		u16 pll_frs;
+
+		if (hsck > 500000000)
+			pll_frs = 0x0;
+		else if (hsck > 250000000)
+			pll_frs = 0x1;
+		else if (hsck > 125000000)
+			pll_frs = 0x2;
+		else
+			pll_frs = 0x3;
+
+		v4l2_dbg(1, debug, sd, "%s: updating PLL clock\n", __func__);
+		tc358743_sleep_mode(sd, true);
+		i2c_wr16(sd, PLLCTL0, pllctl0_new);
+		i2c_wr16_and_or(sd, PLLCTL1,
+				~(MASK_PLL_FRS | MASK_RESETB | MASK_PLL_EN),
+				(SET_PLL_FRS(pll_frs) | MASK_RESETB |
+				 MASK_PLL_EN));
+		udelay(10); /* REF_02, Sheet "Source HDMI" */
+		i2c_wr16_and_or(sd, PLLCTL1, ~MASK_CKEN, MASK_CKEN);
+		tc358743_sleep_mode(sd, false);
+	}
+}
+
+static void tc358743_set_ref_clk(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct tc358743_platform_data *pdata = &state->pdata;
+	u32 sys_freq;
+	u32 lockdet_ref;
+	u16 fh_min;
+	u16 fh_max;
+
+	BUG_ON(!(pdata->refclk_hz == 26000000 ||
+		 pdata->refclk_hz == 27000000 ||
+		 pdata->refclk_hz == 42000000));
+
+	sys_freq = pdata->refclk_hz / 10000;
+	i2c_wr8(sd, SYS_FREQ0, sys_freq & 0x00ff);
+	i2c_wr8(sd, SYS_FREQ1, (sys_freq & 0xff00) >> 8);
+
+	i2c_wr8_and_or(sd, PHY_CTL0, ~MASK_PHY_SYSCLK_IND,
+			(pdata->refclk_hz == 42000000) ?
+			MASK_PHY_SYSCLK_IND : 0x0);
+
+	fh_min = pdata->refclk_hz / 100000;
+	i2c_wr8(sd, FH_MIN0, fh_min & 0x00ff);
+	i2c_wr8(sd, FH_MIN1, (fh_min & 0xff00) >> 8);
+
+	fh_max = (fh_min * 66) / 10;
+	i2c_wr8(sd, FH_MAX0, fh_max & 0x00ff);
+	i2c_wr8(sd, FH_MAX1, (fh_max & 0xff00) >> 8);
+
+	lockdet_ref = pdata->refclk_hz / 100;
+	i2c_wr8(sd, LOCKDET_REF0, lockdet_ref & 0x0000ff);
+	i2c_wr8(sd, LOCKDET_REF1, (lockdet_ref & 0x00ff00) >> 8);
+	i2c_wr8(sd, LOCKDET_REF2, (lockdet_ref & 0x0f0000) >> 16);
+
+	i2c_wr8_and_or(sd, NCO_F0_MOD, ~MASK_NCO_F0_MOD,
+			(pdata->refclk_hz == 27000000) ?
+			MASK_NCO_F0_MOD_27MHZ : 0x0);
+}
+
+static void tc358743_set_csi_color_space(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	switch (state->mbus_fmt_code) {
+	case MEDIA_BUS_FMT_UYVY8_1X16:
+		v4l2_dbg(2, debug, sd, "%s: YCbCr 422 16-bit\n", __func__);
+		i2c_wr8_and_or(sd, VOUT_SET2,
+				~(MASK_SEL422 | MASK_VOUT_422FIL_100) & 0xff,
+				MASK_SEL422 | MASK_VOUT_422FIL_100);
+		i2c_wr8_and_or(sd, VI_REP, ~MASK_VOUT_COLOR_SEL & 0xff,
+				MASK_VOUT_COLOR_601_YCBCR_LIMITED);
+		mutex_lock(&state->confctl_mutex);
+		i2c_wr16_and_or(sd, CONFCTL, ~MASK_YCBCRFMT,
+				MASK_YCBCRFMT_422_8_BIT);
+		mutex_unlock(&state->confctl_mutex);
+		break;
+	case MEDIA_BUS_FMT_RGB888_1X24:
+		v4l2_dbg(2, debug, sd, "%s: RGB 888 24-bit\n", __func__);
+		i2c_wr8_and_or(sd, VOUT_SET2,
+				~(MASK_SEL422 | MASK_VOUT_422FIL_100) & 0xff,
+				0x00);
+		i2c_wr8_and_or(sd, VI_REP, ~MASK_VOUT_COLOR_SEL & 0xff,
+				MASK_VOUT_COLOR_RGB_FULL);
+		mutex_lock(&state->confctl_mutex);
+		i2c_wr16_and_or(sd, CONFCTL, ~MASK_YCBCRFMT, 0);
+		mutex_unlock(&state->confctl_mutex);
+		break;
+	default:
+		v4l2_dbg(2, debug, sd, "%s: Unsupported format code 0x%x\n",
+				__func__, state->mbus_fmt_code);
+	}
+}
+
+static unsigned tc358743_num_csi_lanes_needed(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct v4l2_bt_timings *bt = &state->timings.bt;
+	struct tc358743_platform_data *pdata = &state->pdata;
+	u32 bits_pr_pixel =
+		(state->mbus_fmt_code == MEDIA_BUS_FMT_UYVY8_1X16) ?  16 : 24;
+	u32 bps = bt->width * bt->height * fps(bt) * bits_pr_pixel;
+	u32 bps_pr_lane = (pdata->refclk_hz / pdata->pll_prd) * pdata->pll_fbd;
+
+	return DIV_ROUND_UP(bps, bps_pr_lane);
+}
+
+static void tc358743_set_csi(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct tc358743_platform_data *pdata = &state->pdata;
+	unsigned lanes = tc358743_num_csi_lanes_needed(sd);
+
+	v4l2_dbg(3, debug, sd, "%s:\n", __func__);
+
+	tc358743_reset(sd, MASK_CTXRST);
+
+	if (lanes < 1)
+		i2c_wr32(sd, CLW_CNTRL, MASK_CLW_LANEDISABLE);
+	if (lanes < 1)
+		i2c_wr32(sd, D0W_CNTRL, MASK_D0W_LANEDISABLE);
+	if (lanes < 2)
+		i2c_wr32(sd, D1W_CNTRL, MASK_D1W_LANEDISABLE);
+	if (lanes < 3)
+		i2c_wr32(sd, D2W_CNTRL, MASK_D2W_LANEDISABLE);
+	if (lanes < 4)
+		i2c_wr32(sd, D3W_CNTRL, MASK_D3W_LANEDISABLE);
+
+	i2c_wr32(sd, LINEINITCNT, pdata->lineinitcnt);
+	i2c_wr32(sd, LPTXTIMECNT, pdata->lptxtimecnt);
+	i2c_wr32(sd, TCLK_HEADERCNT, pdata->tclk_headercnt);
+	i2c_wr32(sd, TCLK_TRAILCNT, pdata->tclk_trailcnt);
+	i2c_wr32(sd, THS_HEADERCNT, pdata->ths_headercnt);
+	i2c_wr32(sd, TWAKEUP, pdata->twakeup);
+	i2c_wr32(sd, TCLK_POSTCNT, pdata->tclk_postcnt);
+	i2c_wr32(sd, THS_TRAILCNT, pdata->ths_trailcnt);
+	i2c_wr32(sd, HSTXVREGCNT, pdata->hstxvregcnt);
+
+	i2c_wr32(sd, HSTXVREGEN,
+			((lanes > 0) ? MASK_CLM_HSTXVREGEN : 0x0) |
+			((lanes > 0) ? MASK_D0M_HSTXVREGEN : 0x0) |
+			((lanes > 1) ? MASK_D1M_HSTXVREGEN : 0x0) |
+			((lanes > 2) ? MASK_D2M_HSTXVREGEN : 0x0) |
+			((lanes > 3) ? MASK_D3M_HSTXVREGEN : 0x0));
+
+	i2c_wr32(sd, TXOPTIONCNTRL, MASK_CONTCLKMODE);
+	i2c_wr32(sd, STARTCNTRL, MASK_START);
+	i2c_wr32(sd, CSI_START, MASK_STRT);
+
+	i2c_wr32(sd, CSI_CONFW, MASK_MODE_SET |
+			MASK_ADDRESS_CSI_CONTROL |
+			MASK_CSI_MODE |
+			MASK_TXHSMD |
+			((lanes == 4) ? MASK_NOL_4 :
+			 (lanes == 3) ? MASK_NOL_3 :
+			 (lanes == 2) ? MASK_NOL_2 : MASK_NOL_1));
+
+	i2c_wr32(sd, CSI_CONFW, MASK_MODE_SET |
+			MASK_ADDRESS_CSI_ERR_INTENA | MASK_TXBRK | MASK_QUNK |
+			MASK_WCER | MASK_INER);
+
+	i2c_wr32(sd, CSI_CONFW, MASK_MODE_CLEAR |
+			MASK_ADDRESS_CSI_ERR_HALT | MASK_TXBRK | MASK_QUNK);
+
+	i2c_wr32(sd, CSI_CONFW, MASK_MODE_SET |
+			MASK_ADDRESS_CSI_INT_ENA | MASK_INTER);
+}
+
+static void tc358743_set_hdmi_phy(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct tc358743_platform_data *pdata = &state->pdata;
+
+	/* Default settings from REF_02, sheet "Source HDMI"
+	 * and custom settings as platform data */
+	i2c_wr8_and_or(sd, PHY_EN, ~MASK_ENABLE_PHY, 0x0);
+	i2c_wr8(sd, PHY_CTL1, SET_PHY_AUTO_RST1_US(1600) |
+			SET_FREQ_RANGE_MODE_CYCLES(1));
+	i2c_wr8_and_or(sd, PHY_CTL2, ~MASK_PHY_AUTO_RSTn,
+			(pdata->hdmi_phy_auto_reset_tmds_detected ?
+			 MASK_PHY_AUTO_RST2 : 0) |
+			(pdata->hdmi_phy_auto_reset_tmds_in_range ?
+			 MASK_PHY_AUTO_RST3 : 0) |
+			(pdata->hdmi_phy_auto_reset_tmds_valid ?
+			 MASK_PHY_AUTO_RST4 : 0));
+	i2c_wr8(sd, PHY_BIAS, 0x40);
+	i2c_wr8(sd, PHY_CSQ, SET_CSQ_CNT_LEVEL(0x0a));
+	i2c_wr8(sd, AVM_CTL, 45);
+	i2c_wr8_and_or(sd, HDMI_DET, ~MASK_HDMI_DET_V,
+			pdata->hdmi_detection_delay << 4);
+	i2c_wr8_and_or(sd, HV_RST, ~(MASK_H_PI_RST | MASK_V_PI_RST),
+			(pdata->hdmi_phy_auto_reset_hsync_out_of_range ?
+			 MASK_H_PI_RST : 0) |
+			(pdata->hdmi_phy_auto_reset_vsync_out_of_range ?
+			 MASK_V_PI_RST : 0));
+	i2c_wr8_and_or(sd, PHY_EN, ~MASK_ENABLE_PHY, MASK_ENABLE_PHY);
+}
+
+static void tc358743_set_hdmi_audio(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	/* Default settings from REF_02, sheet "Source HDMI" */
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
+	i2c_wr8(sd, SDO_MODE1, MASK_SDO_FMT_I2S);
+	i2c_wr8(sd, DIV_MODE, SET_DIV_DLY_MS(100));
+
+	mutex_lock(&state->confctl_mutex);
+	i2c_wr16_and_or(sd, CONFCTL, 0xffff, MASK_AUDCHNUM_2 |
+			MASK_AUDOUTSEL_I2S | MASK_AUTOINDEX);
+	mutex_unlock(&state->confctl_mutex);
+}
+
+static void tc358743_set_hdmi_info_frame_mode(struct v4l2_subdev *sd)
+{
+	/* Default settings from REF_02, sheet "Source HDMI" */
+	i2c_wr8(sd, PK_INT_MODE, MASK_ISRC2_INT_MODE | MASK_ISRC_INT_MODE |
+			MASK_ACP_INT_MODE | MASK_VS_INT_MODE |
+			MASK_SPD_INT_MODE | MASK_MS_INT_MODE |
+			MASK_AUD_INT_MODE | MASK_AVI_INT_MODE);
+	i2c_wr8(sd, NO_PKT_LIMIT, 0x2c);
+	i2c_wr8(sd, NO_PKT_CLR, 0x53);
+	i2c_wr8(sd, ERR_PK_LIMIT, 0x01);
+	i2c_wr8(sd, NO_PKT_LIMIT2, 0x30);
+	i2c_wr8(sd, NO_GDB_LIMIT, 0x10);
+}
+
+static void tc358743_initial_setup(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct tc358743_platform_data *pdata = &state->pdata;
+
+	/* CEC and IR are not supported by this driver */
+	i2c_wr16_and_or(sd, SYSCTL, ~(MASK_CECRST | MASK_IRRST),
+			(MASK_CECRST | MASK_IRRST));
+
+	tc358743_reset(sd, MASK_CTXRST | MASK_HDMIRST);
+	tc358743_sleep_mode(sd, false);
+
+	i2c_wr16(sd, FIFOCTL, pdata->fifo_level);
+
+	tc358743_set_ref_clk(sd);
+
+	i2c_wr8_and_or(sd, DDC_CTL, ~MASK_DDC5V_MODE,
+			pdata->ddc5v_delay & MASK_DDC5V_MODE);
+	i2c_wr8_and_or(sd, EDID_MODE, ~MASK_EDID_MODE, MASK_EDID_MODE_E_DDC);
+
+	tc358743_set_hdmi_phy(sd);
+	tc358743_set_hdmi_hdcp(sd, pdata->enable_hdcp);
+	tc358743_set_hdmi_audio(sd);
+	tc358743_set_hdmi_info_frame_mode(sd);
+
+	/* All CE and IT formats are detected as RGB full range in DVI mode */
+	i2c_wr8_and_or(sd, VI_MODE, ~MASK_RGB_DVI, 0);
+
+	i2c_wr8_and_or(sd, VOUT_SET2, ~MASK_VOUTCOLORMODE,
+			MASK_VOUTCOLORMODE_AUTO);
+	i2c_wr8(sd, VOUT_SET3, MASK_VOUT_EXTCNT);
+}
+
+/* --------------- IRQ --------------- */
+
+static void tc358743_format_change(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct v4l2_dv_timings timings;
+	const struct v4l2_event tc358743_ev_fmt = {
+		.type = V4L2_EVENT_SOURCE_CHANGE,
+		.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+	};
+
+	if (tc358743_get_detected_timings(sd, &timings)) {
+		enable_stream(sd, false);
+
+		v4l2_dbg(1, debug, sd, "%s: Format changed. No signal\n",
+				__func__);
+	} else {
+		if (!v4l2_match_dv_timings(&state->timings, &timings, 0))
+			enable_stream(sd, false);
+
+		v4l2_print_dv_timings(sd->name,
+				"tc358743_format_change: Format changed. New format: ",
+				&timings, false);
+	}
+
+	v4l2_subdev_notify(sd, V4L2_DEVICE_NOTIFY_EVENT,
+			(void *)&tc358743_ev_fmt);
+}
+
+static void tc358743_init_interrupts(struct v4l2_subdev *sd)
+{
+	u16 i;
+
+	/* clear interrupt status registers */
+	for (i = SYS_INT; i <= KEY_INT; i++)
+		i2c_wr8(sd, i, 0xff);
+
+	i2c_wr16(sd, INTSTATUS, 0xffff);
+}
+
+static void tc358743_enable_interrupts(struct v4l2_subdev *sd,
+		bool cable_connected)
+{
+	v4l2_dbg(2, debug, sd, "%s: cable connected = %d\n", __func__,
+			cable_connected);
+
+	if (cable_connected) {
+		i2c_wr8(sd, SYS_INTM, ~(MASK_M_DDC | MASK_M_DVI_DET |
+					MASK_M_HDMI_DET) & 0xff);
+		i2c_wr8(sd, CLK_INTM, ~MASK_M_IN_DE_CHG);
+		i2c_wr8(sd, CBIT_INTM, ~(MASK_M_CBIT_FS | MASK_M_AF_LOCK |
+					MASK_M_AF_UNLOCK) & 0xff);
+		i2c_wr8(sd, AUDIO_INTM, ~MASK_M_BUFINIT_END);
+		i2c_wr8(sd, MISC_INTM, ~MASK_M_SYNC_CHG);
+	} else {
+		i2c_wr8(sd, SYS_INTM, ~MASK_M_DDC & 0xff);
+		i2c_wr8(sd, CLK_INTM, 0xff);
+		i2c_wr8(sd, CBIT_INTM, 0xff);
+		i2c_wr8(sd, AUDIO_INTM, 0xff);
+		i2c_wr8(sd, MISC_INTM, 0xff);
+	}
+}
+
+static void tc358743_hdmi_audio_int_handler(struct v4l2_subdev *sd,
+		bool *handled)
+{
+	u8 audio_int_mask = i2c_rd8(sd, AUDIO_INTM);
+	u8 audio_int = i2c_rd8(sd, AUDIO_INT) & ~audio_int_mask;
+
+	i2c_wr8(sd, AUDIO_INT, audio_int);
+
+	v4l2_dbg(3, debug, sd, "%s: AUDIO_INT = 0x%02x\n", __func__, audio_int);
+
+	tc358743_s_ctrl_audio_sampling_rate(sd);
+	tc358743_s_ctrl_audio_present(sd);
+}
+
+static void tc358743_csi_err_int_handler(struct v4l2_subdev *sd, bool *handled)
+{
+	v4l2_err(sd, "%s: CSI_ERR = 0x%x\n", __func__, i2c_rd32(sd, CSI_ERR));
+
+	i2c_wr32(sd, CSI_INT_CLR, MASK_ICRER);
+}
+
+static void tc358743_hdmi_misc_int_handler(struct v4l2_subdev *sd,
+		bool *handled)
+{
+	u8 misc_int_mask = i2c_rd8(sd, MISC_INTM);
+	u8 misc_int = i2c_rd8(sd, MISC_INT) & ~misc_int_mask;
+
+	i2c_wr8(sd, MISC_INT, misc_int);
+
+	v4l2_dbg(3, debug, sd, "%s: MISC_INT = 0x%02x\n", __func__, misc_int);
+
+	if (misc_int & MASK_I_SYNC_CHG) {
+		/* Reset the HDMI PHY to try to trigger proper lock on the
+		 * incoming video format. Erase BKSV to prevent that old keys
+		 * are used when a new source is connected. */
+		if (no_sync(sd) || no_signal(sd)) {
+			tc358743_reset_phy(sd);
+			tc358743_erase_bksv(sd);
+		}
+
+		tc358743_format_change(sd);
+
+		misc_int &= ~MASK_I_SYNC_CHG;
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
+static void tc358743_hdmi_cbit_int_handler(struct v4l2_subdev *sd,
+		bool *handled)
+{
+	u8 cbit_int_mask = i2c_rd8(sd, CBIT_INTM);
+	u8 cbit_int = i2c_rd8(sd, CBIT_INT) & ~cbit_int_mask;
+
+	i2c_wr8(sd, CBIT_INT, cbit_int);
+
+	v4l2_dbg(3, debug, sd, "%s: CBIT_INT = 0x%02x\n", __func__, cbit_int);
+
+	if (cbit_int & MASK_I_CBIT_FS) {
+
+		v4l2_dbg(1, debug, sd, "%s: Audio sample rate changed\n",
+				__func__);
+		tc358743_s_ctrl_audio_sampling_rate(sd);
+
+		cbit_int &= ~MASK_I_CBIT_FS;
+		if (handled)
+			*handled = true;
+	}
+
+	if (cbit_int & (MASK_I_AF_LOCK | MASK_I_AF_UNLOCK)) {
+
+		v4l2_dbg(1, debug, sd, "%s: Audio present changed\n",
+				__func__);
+		tc358743_s_ctrl_audio_present(sd);
+
+		cbit_int &= ~(MASK_I_AF_LOCK | MASK_I_AF_UNLOCK);
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
+static void tc358743_hdmi_clk_int_handler(struct v4l2_subdev *sd, bool *handled)
+{
+	u8 clk_int_mask = i2c_rd8(sd, CLK_INTM);
+	u8 clk_int = i2c_rd8(sd, CLK_INT) & ~clk_int_mask;
+
+	/* Bit 7 and bit 6 are set even when they are masked */
+	i2c_wr8(sd, CLK_INT, clk_int | 0x80 | MASK_I_OUT_H_CHG);
+
+	v4l2_dbg(3, debug, sd, "%s: CLK_INT = 0x%02x\n", __func__, clk_int);
+
+	if (clk_int & (MASK_I_IN_DE_CHG)) {
+
+		v4l2_dbg(1, debug, sd, "%s: DE size or position has changed\n",
+				__func__);
+
+		/* If the source switch to a new resolution with the same pixel
+		 * frequency as the existing (e.g. 1080p25 -> 720p50), the
+		 * I_SYNC_CHG interrupt is not always triggered, while the
+		 * I_IN_DE_CHG interrupt seems to work fine. Format change
+		 * notifications are only sent when the signal is stable to
+		 * reduce the number of notifications. */
+		if (!no_signal(sd) && !no_sync(sd))
+			tc358743_format_change(sd);
+
+		clk_int &= ~(MASK_I_IN_DE_CHG);
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
+static void tc358743_hdmi_sys_int_handler(struct v4l2_subdev *sd, bool *handled)
+{
+	struct tc358743_state *state = to_state(sd);
+	u8 sys_int_mask = i2c_rd8(sd, SYS_INTM);
+	u8 sys_int = i2c_rd8(sd, SYS_INT) & ~sys_int_mask;
+
+	i2c_wr8(sd, SYS_INT, sys_int);
+
+	v4l2_dbg(3, debug, sd, "%s: SYS_INT = 0x%02x\n", __func__, sys_int);
+
+	if (sys_int & MASK_I_DDC) {
+		bool tx_5v = tx_5v_power_present(sd);
+
+		v4l2_dbg(1, debug, sd, "%s: Tx 5V power present: %s\n",
+				__func__, tx_5v ?  "yes" : "no");
+
+		if (tx_5v) {
+			tc358743_enable_edid(sd);
+		} else {
+			tc358743_enable_interrupts(sd, false);
+			tc358743_disable_edid(sd);
+			memset(&state->timings, 0, sizeof(state->timings));
+			tc358743_erase_bksv(sd);
+			tc358743_update_controls(sd);
+		}
+
+		sys_int &= ~MASK_I_DDC;
+		if (handled)
+			*handled = true;
+	}
+
+	if (sys_int & MASK_I_DVI) {
+		v4l2_dbg(1, debug, sd, "%s: HDMI->DVI change detected\n",
+				__func__);
+
+		/* Reset the HDMI PHY to try to trigger proper lock on the
+		 * incoming video format. Erase BKSV to prevent that old keys
+		 * are used when a new source is connected. */
+		if (no_sync(sd) || no_signal(sd)) {
+			tc358743_reset_phy(sd);
+			tc358743_erase_bksv(sd);
+		}
+
+		sys_int &= ~MASK_I_DVI;
+		if (handled)
+			*handled = true;
+	}
+
+	if (sys_int & MASK_I_HDMI) {
+		v4l2_dbg(1, debug, sd, "%s: DVI->HDMI change detected\n",
+				__func__);
+
+		/* Register is reset in DVI mode (REF_01, c. 6.6.41) */
+		i2c_wr8(sd, ANA_CTL, MASK_APPL_PCSX_NORMAL | MASK_ANALOG_ON);
+
+		sys_int &= ~MASK_I_HDMI;
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
+static int tc358743_log_status(struct v4l2_subdev *sd)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct v4l2_dv_timings timings;
+	uint8_t hdmi_sys_status =  i2c_rd8(sd, SYS_STATUS);
+	uint16_t sysctl = i2c_rd16(sd, SYSCTL);
+	u8 vi_status3 =  i2c_rd8(sd, VI_STATUS3);
+	const int deep_color_mode[4] = { 8, 10, 12, 16 };
+	static const char * const input_color_space[] = {
+		"RGB", "YCbCr 601", "Adobe RGB", "YCbCr 709", "NA (4)",
+		"xvYCC 601", "NA(6)", "xvYCC 709", "NA(8)", "sYCC601",
+		"NA(10)", "NA(11)", "NA(12)", "Adobe YCC 601"};
+
+	v4l2_info(sd, "-----Chip status-----\n");
+	v4l2_info(sd, "Chip ID: 0x%02x\n",
+			(i2c_rd16(sd, CHIPID) & MASK_CHIPID) >> 8);
+	v4l2_info(sd, "Chip revision: 0x%02x\n",
+			i2c_rd16(sd, CHIPID) & MASK_REVID);
+	v4l2_info(sd, "Reset: IR: %d, CEC: %d, CSI TX: %d, HDMI: %d\n",
+			!!(sysctl & MASK_IRRST),
+			!!(sysctl & MASK_CECRST),
+			!!(sysctl & MASK_CTXRST),
+			!!(sysctl & MASK_HDMIRST));
+	v4l2_info(sd, "Sleep mode: %s\n", sysctl & MASK_SLEEP ? "on" : "off");
+	v4l2_info(sd, "Cable detected (+5V power): %s\n",
+			hdmi_sys_status & MASK_S_DDC5V ? "yes" : "no");
+	v4l2_info(sd, "DDC lines enabled: %s\n",
+			(i2c_rd8(sd, EDID_MODE) & MASK_EDID_MODE_E_DDC) ?
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
+	if (tc358743_get_detected_timings(sd, &timings)) {
+		v4l2_info(sd, "No video detected\n");
+	} else {
+		v4l2_print_dv_timings(sd->name, "Detected format: ", &timings,
+				true);
+	}
+	v4l2_print_dv_timings(sd->name, "Configured format: ", &state->timings,
+			true);
+
+	v4l2_info(sd, "-----CSI-TX status-----\n");
+	v4l2_info(sd, "Lanes needed: %d\n",
+			tc358743_num_csi_lanes_needed(sd));
+	v4l2_info(sd, "Lanes in use: %d\n",
+			tc358743_num_csi_lanes_in_use(sd));
+	v4l2_info(sd, "Waiting for particular sync signal: %s\n",
+			(i2c_rd16(sd, CSI_STATUS) & MASK_S_WSYNC) ?
+			"yes" : "no");
+	v4l2_info(sd, "Transmit mode: %s\n",
+			(i2c_rd16(sd, CSI_STATUS) & MASK_S_TXACT) ?
+			"yes" : "no");
+	v4l2_info(sd, "Receive mode: %s\n",
+			(i2c_rd16(sd, CSI_STATUS) & MASK_S_RXACT) ?
+			"yes" : "no");
+	v4l2_info(sd, "Stopped: %s\n",
+			(i2c_rd16(sd, CSI_STATUS) & MASK_S_HLT) ?
+			"yes" : "no");
+	v4l2_info(sd, "Color space: %s\n",
+			state->mbus_fmt_code == MEDIA_BUS_FMT_UYVY8_1X16 ?
+			"YCbCr 422 16-bit" :
+			state->mbus_fmt_code == MEDIA_BUS_FMT_RGB888_1X24 ?
+			"RGB 888 24-bit" : "Unsupported");
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
+	print_avi_infoframe(sd);
+
+	return 0;
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static void tc358743_print_register_map(struct v4l2_subdev *sd)
+{
+	v4l2_info(sd, "0x0000–0x00FF: Global Control Register\n");
+	v4l2_info(sd, "0x0100–0x01FF: CSI2-TX PHY Register\n");
+	v4l2_info(sd, "0x0200–0x03FF: CSI2-TX PPI Register\n");
+	v4l2_info(sd, "0x0400–0x05FF: Reserved\n");
+	v4l2_info(sd, "0x0600–0x06FF: CEC Register\n");
+	v4l2_info(sd, "0x0700–0x84FF: Reserved\n");
+	v4l2_info(sd, "0x8500–0x85FF: HDMIRX System Control Register\n");
+	v4l2_info(sd, "0x8600–0x86FF: HDMIRX Audio Control Register\n");
+	v4l2_info(sd, "0x8700–0x87FF: HDMIRX InfoFrame packet data Register\n");
+	v4l2_info(sd, "0x8800–0x88FF: HDMIRX HDCP Port Register\n");
+	v4l2_info(sd, "0x8900–0x89FF: HDMIRX Video Output Port & 3D Register\n");
+	v4l2_info(sd, "0x8A00–0x8BFF: Reserved\n");
+	v4l2_info(sd, "0x8C00–0x8FFF: HDMIRX EDID-RAM (1024bytes)\n");
+	v4l2_info(sd, "0x9000–0x90FF: HDMIRX GBD Extraction Control\n");
+	v4l2_info(sd, "0x9100–0x92FF: HDMIRX GBD RAM read\n");
+	v4l2_info(sd, "0x9300-      : Reserved\n");
+}
+
+static int tc358743_get_reg_size(u16 address)
+{
+	/* REF_01 p. 66-72 */
+	if (address <= 0x00ff)
+		return 2;
+	else if ((address >= 0x0100) && (address <= 0x06FF))
+		return 4;
+	else if ((address >= 0x0700) && (address <= 0x84ff))
+		return 2;
+	else
+		return 1;
+}
+
+static int tc358743_g_register(struct v4l2_subdev *sd,
+			       struct v4l2_dbg_register *reg)
+{
+	if (reg->reg > 0xffff) {
+		tc358743_print_register_map(sd);
+		return -EINVAL;
+	}
+
+	reg->size = tc358743_get_reg_size(reg->reg);
+
+	i2c_rd(sd, reg->reg, (u8 *)&reg->val, reg->size);
+
+	return 0;
+}
+
+static int tc358743_s_register(struct v4l2_subdev *sd,
+			       const struct v4l2_dbg_register *reg)
+{
+	if (reg->reg > 0xffff) {
+		tc358743_print_register_map(sd);
+		return -EINVAL;
+	}
+
+	/* It should not be possible for the user to enable HDCP with a simple
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
+	i2c_wr(sd, (u16)reg->reg, (u8 *)&reg->val,
+			tc358743_get_reg_size(reg->reg));
+
+	return 0;
+}
+#endif
+
+static int tc358743_isr(struct v4l2_subdev *sd, u32 status, bool *handled)
+{
+	u16 intstatus = i2c_rd16(sd, INTSTATUS);
+
+	v4l2_dbg(1, debug, sd, "%s: IntStatus = 0x%04x\n", __func__, intstatus);
+
+	if (intstatus & MASK_HDMI_INT) {
+		u8 hdmi_int0 = i2c_rd8(sd, HDMI_INT0);
+		u8 hdmi_int1 = i2c_rd8(sd, HDMI_INT1);
+
+		if (hdmi_int0 & MASK_I_MISC)
+			tc358743_hdmi_misc_int_handler(sd, handled);
+		if (hdmi_int1 & MASK_I_CBIT)
+			tc358743_hdmi_cbit_int_handler(sd, handled);
+		if (hdmi_int1 & MASK_I_CLK)
+			tc358743_hdmi_clk_int_handler(sd, handled);
+		if (hdmi_int1 & MASK_I_SYS)
+			tc358743_hdmi_sys_int_handler(sd, handled);
+		if (hdmi_int1 & MASK_I_AUD)
+			tc358743_hdmi_audio_int_handler(sd, handled);
+
+		i2c_wr16(sd, INTSTATUS, MASK_HDMI_INT);
+		intstatus &= ~MASK_HDMI_INT;
+	}
+
+	if (intstatus & MASK_CSI_INT) {
+		u32 csi_int = i2c_rd32(sd, CSI_INT);
+
+		if (csi_int & MASK_INTER)
+			tc358743_csi_err_int_handler(sd, handled);
+
+		i2c_wr16(sd, INTSTATUS, MASK_CSI_INT);
+		intstatus &= ~MASK_CSI_INT;
+	}
+
+	intstatus = i2c_rd16(sd, INTSTATUS);
+	if (intstatus) {
+		v4l2_dbg(1, debug, sd,
+				"%s: Unhandled IntStatus interrupts: 0x%02x\n",
+				__func__, intstatus);
+	}
+
+	return 0;
+}
+
+/* --------------- VIDEO OPS --------------- */
+
+static int tc358743_g_input_status(struct v4l2_subdev *sd, u32 *status)
+{
+	*status = 0;
+	*status |= no_signal(sd) ? V4L2_IN_ST_NO_SIGNAL : 0;
+	*status |= no_sync(sd) ? V4L2_IN_ST_NO_SYNC : 0;
+
+	v4l2_dbg(1, debug, sd, "%s: status = 0x%x\n", __func__, *status);
+
+	return 0;
+}
+
+static int tc358743_s_dv_timings(struct v4l2_subdev *sd,
+				 struct v4l2_dv_timings *timings)
+{
+	struct tc358743_state *state = to_state(sd);
+	struct v4l2_bt_timings *bt;
+
+	if (!timings)
+		return -EINVAL;
+
+	if (debug)
+		v4l2_print_dv_timings(sd->name, "tc358743_s_dv_timings: ",
+				timings, false);
+
+	if (v4l2_match_dv_timings(&state->timings, timings, 0)) {
+		v4l2_dbg(1, debug, sd, "%s: no change\n", __func__);
+		return 0;
+	}
+
+	bt = &timings->bt;
+
+	if (!v4l2_valid_dv_timings(timings,
+				&tc358743_timings_cap, NULL, NULL)) {
+		v4l2_dbg(1, debug, sd, "%s: timings out of range\n", __func__);
+		return -ERANGE;
+	}
+
+	state->timings = *timings;
+
+	enable_stream(sd, false);
+	tc358743_set_pll(sd);
+	tc358743_set_csi(sd);
+
+	return 0;
+}
+
+static int tc358743_g_dv_timings(struct v4l2_subdev *sd,
+				 struct v4l2_dv_timings *timings)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	*timings = state->timings;
+
+	return 0;
+}
+
+static int tc358743_enum_dv_timings(struct v4l2_subdev *sd,
+				    struct v4l2_enum_dv_timings *timings)
+{
+	if (timings->pad != 0)
+		return -EINVAL;
+
+	return v4l2_enum_dv_timings_cap(timings,
+			&tc358743_timings_cap, NULL, NULL);
+}
+
+static int tc358743_query_dv_timings(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings *timings)
+{
+	int ret;
+
+	ret = tc358743_get_detected_timings(sd, timings);
+	if (ret)
+		return ret;
+
+	if (debug)
+		v4l2_print_dv_timings(sd->name, "tc358743_query_dv_timings: ",
+				timings, false);
+
+	if (!v4l2_valid_dv_timings(timings,
+				&tc358743_timings_cap, NULL, NULL)) {
+		v4l2_dbg(1, debug, sd, "%s: timings out of range\n", __func__);
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
+static int tc358743_dv_timings_cap(struct v4l2_subdev *sd,
+		struct v4l2_dv_timings_cap *cap)
+{
+	if (cap->pad != 0)
+		return -EINVAL;
+
+	*cap = tc358743_timings_cap;
+
+	return 0;
+}
+
+static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
+			     struct v4l2_mbus_config *cfg)
+{
+	cfg->type = V4L2_MBUS_CSI2;
+
+	/* Support for non-continuous CSI-2 clock is missing in the driver */
+	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
+
+	switch (tc358743_num_csi_lanes_in_use(sd)) {
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
+	return 0;
+}
+
+static int tc358743_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	enable_stream(sd, enable);
+
+	return 0;
+}
+
+/* --------------- PAD OPS --------------- */
+
+static int tc358743_get_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct tc358743_state *state = to_state(sd);
+	u8 vi_rep = i2c_rd8(sd, VI_REP);
+
+	if (format->pad != 0)
+		return -EINVAL;
+
+	format->format.code = state->mbus_fmt_code;
+	format->format.width = state->timings.bt.width;
+	format->format.height = state->timings.bt.height;
+	format->format.field = V4L2_FIELD_NONE;
+
+	switch (vi_rep & MASK_VOUT_COLOR_SEL) {
+	case MASK_VOUT_COLOR_RGB_FULL:
+	case MASK_VOUT_COLOR_RGB_LIMITED:
+		format->format.colorspace = V4L2_COLORSPACE_SRGB;
+		break;
+	case MASK_VOUT_COLOR_601_YCBCR_LIMITED:
+	case MASK_VOUT_COLOR_601_YCBCR_FULL:
+		format->format.colorspace = V4L2_COLORSPACE_SMPTE170M;
+		break;
+	case MASK_VOUT_COLOR_709_YCBCR_FULL:
+	case MASK_VOUT_COLOR_709_YCBCR_LIMITED:
+		format->format.colorspace = V4L2_COLORSPACE_REC709;
+		break;
+	default:
+		format->format.colorspace = 0;
+		break;
+	}
+
+	return 0;
+}
+
+static int tc358743_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
+{
+	struct tc358743_state *state = to_state(sd);
+
+	u32 code = format->format.code; /* is overwritten by get_fmt */
+	int ret = tc358743_get_fmt(sd, cfg, format);
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
+	state->mbus_fmt_code = format->format.code;
+
+	enable_stream(sd, false);
+	tc358743_set_pll(sd);
+	tc358743_set_csi(sd);
+	tc358743_set_csi_color_space(sd);
+
+	return 0;
+}
+
+static int tc358743_g_edid(struct v4l2_subdev *sd,
+		struct v4l2_subdev_edid *edid)
+{
+	struct tc358743_state *state = to_state(sd);
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
+			edid->blocks * EDID_BLOCK_SIZE);
+
+	return 0;
+}
+
+static int tc358743_s_edid(struct v4l2_subdev *sd,
+				struct v4l2_subdev_edid *edid)
+{
+	struct tc358743_state *state = to_state(sd);
+	u16 edid_len = edid->blocks * EDID_BLOCK_SIZE;
+
+	v4l2_dbg(2, debug, sd, "%s, pad %d, start block %d, blocks %d\n",
+		 __func__, edid->pad, edid->start_block, edid->blocks);
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
+	tc358743_disable_edid(sd);
+
+	i2c_wr8(sd, EDID_LEN1, edid_len & 0xff);
+	i2c_wr8(sd, EDID_LEN2, edid_len >> 8);
+
+	if (edid->blocks == 0) {
+		state->edid_blocks_written = 0;
+		return 0;
+	}
+
+	i2c_wr(sd, EDID_RAM, edid->edid, edid_len);
+
+	state->edid_blocks_written = edid->blocks;
+
+	if (tx_5v_power_present(sd))
+		tc358743_enable_edid(sd);
+
+	return 0;
+}
+
+/* -------------------------------------------------------------------------- */
+
+static const struct v4l2_subdev_core_ops tc358743_core_ops = {
+	.log_status = tc358743_log_status,
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = tc358743_g_register,
+	.s_register = tc358743_s_register,
+#endif
+	.interrupt_service_routine = tc358743_isr,
+};
+
+static const struct v4l2_subdev_video_ops tc358743_video_ops = {
+	.g_input_status = tc358743_g_input_status,
+	.s_dv_timings = tc358743_s_dv_timings,
+	.g_dv_timings = tc358743_g_dv_timings,
+	.query_dv_timings = tc358743_query_dv_timings,
+	.g_mbus_config = tc358743_g_mbus_config,
+	.s_stream = tc358743_s_stream,
+};
+
+static const struct v4l2_subdev_pad_ops tc358743_pad_ops = {
+	.set_fmt = tc358743_set_fmt,
+	.get_fmt = tc358743_get_fmt,
+	.get_edid = tc358743_g_edid,
+	.set_edid = tc358743_s_edid,
+	.enum_dv_timings = tc358743_enum_dv_timings,
+	.dv_timings_cap = tc358743_dv_timings_cap,
+};
+
+static const struct v4l2_subdev_ops tc358743_ops = {
+	.core = &tc358743_core_ops,
+	.video = &tc358743_video_ops,
+	.pad = &tc358743_pad_ops,
+};
+
+/* --------------- CUSTOM CTRLS --------------- */
+
+static const struct v4l2_ctrl_config tc358743_ctrl_audio_sampling_rate = {
+	.id = TC358743_CID_AUDIO_SAMPLING_RATE,
+	.name = "Audio sampling rate",
+	.type = V4L2_CTRL_TYPE_INTEGER,
+	.min = 0,
+	.max = 768000,
+	.step = 1,
+	.def = 0,
+	.flags = V4L2_CTRL_FLAG_READ_ONLY,
+};
+
+static const struct v4l2_ctrl_config tc358743_ctrl_audio_present = {
+	.id = TC358743_CID_AUDIO_PRESENT,
+	.name = "Audio present",
+	.type = V4L2_CTRL_TYPE_BOOLEAN,
+	.min = 0,
+	.max = 1,
+	.step = 1,
+	.def = 0,
+	.flags = V4L2_CTRL_FLAG_READ_ONLY,
+};
+
+/* --------------- PROBE / REMOVE --------------- */
+
+static int tc358743_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
+{
+	static struct v4l2_dv_timings default_timing =
+		V4L2_DV_BT_CEA_640X480P59_94;
+	struct tc358743_state *state;
+	struct tc358743_platform_data *pdata = client->dev.platform_data;
+	struct v4l2_subdev *sd;
+	int err;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+	v4l_dbg(1, debug, client, "chip found @ 0x%x (%s)\n",
+		client->addr << 1, client->adapter->name);
+
+	state = devm_kzalloc(&client->dev, sizeof(struct tc358743_state),
+			GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	/* platform data */
+	if (!pdata) {
+		v4l_err(client, "No platform data!\n");
+		return -ENODEV;
+	}
+	state->pdata = *pdata;
+
+	state->i2c_client = client;
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &tc358743_ops);
+	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS;
+
+	/* i2c access */
+	if ((i2c_rd16(sd, CHIPID) & MASK_CHIPID) != 0) {
+		v4l2_info(sd, "not a TC358743 on address 0x%x\n",
+			  client->addr << 1);
+		return -ENODEV;
+	}
+
+	/* control handlers */
+	v4l2_ctrl_handler_init(&state->hdl, 3);
+
+	/* private controls */
+	state->detect_tx_5v_ctrl = v4l2_ctrl_new_std(&state->hdl, NULL,
+			V4L2_CID_DV_RX_POWER_PRESENT, 0, 1, 0, 0);
+
+	/* custom controls */
+	state->audio_sampling_rate_ctrl = v4l2_ctrl_new_custom(&state->hdl,
+			&tc358743_ctrl_audio_sampling_rate, NULL);
+
+	state->audio_present_ctrl = v4l2_ctrl_new_custom(&state->hdl,
+			&tc358743_ctrl_audio_present, NULL);
+
+	sd->ctrl_handler = &state->hdl;
+	if (state->hdl.error) {
+		err = state->hdl.error;
+		goto err_hdl;
+	}
+
+	if (tc358743_update_controls(sd)) {
+		err = -ENODEV;
+		goto err_hdl;
+	}
+
+	/* work queues */
+	state->work_queues = create_singlethread_workqueue(client->name);
+	if (!state->work_queues) {
+		v4l2_err(sd, "Could not create work queue\n");
+		err = -ENOMEM;
+		goto err_hdl;
+	}
+
+	mutex_init(&state->confctl_mutex);
+
+	INIT_DELAYED_WORK(&state->delayed_work_enable_hotplug,
+			tc358743_delayed_work_enable_hotplug);
+
+	tc358743_initial_setup(sd);
+
+	tc358743_s_dv_timings(sd, &default_timing);
+
+	state->mbus_fmt_code = MEDIA_BUS_FMT_RGB888_1X24;
+	tc358743_set_csi_color_space(sd);
+
+	tc358743_init_interrupts(sd);
+	tc358743_enable_interrupts(sd, tx_5v_power_present(sd));
+	i2c_wr16(sd, INTMASK, ~(MASK_HDMI_MSK | MASK_CSI_MSK) & 0xffff);
+
+	err = v4l2_ctrl_handler_setup(sd->ctrl_handler);
+	if (err)
+		goto err_work_queues;
+
+	v4l2_info(sd, "%s found @ 0x%x (%s)\n", client->name,
+		  client->addr << 1, client->adapter->name);
+
+	return 0;
+
+err_work_queues:
+	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	destroy_workqueue(state->work_queues);
+	mutex_destroy(&state->confctl_mutex);
+err_hdl:
+	v4l2_ctrl_handler_free(&state->hdl);
+	return err;
+}
+
+static int tc358743_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tc358743_state *state = to_state(sd);
+
+	cancel_delayed_work(&state->delayed_work_enable_hotplug);
+	destroy_workqueue(state->work_queues);
+	v4l2_device_unregister_subdev(sd);
+	mutex_destroy(&state->confctl_mutex);
+	v4l2_ctrl_handler_free(&state->hdl);
+
+	return 0;
+}
+
+static struct i2c_device_id tc358743_id[] = {
+	{"tc358743", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, tc358743_id);
+
+static struct i2c_driver tc358743_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "tc358743",
+	},
+	.probe = tc358743_probe,
+	.remove = tc358743_remove,
+	.id_table = tc358743_id,
+};
+
+module_i2c_driver(tc358743_driver);
diff --git a/drivers/media/i2c/tc358743_regs.h b/drivers/media/i2c/tc358743_regs.h
new file mode 100644
index 0000000..112d70e
--- /dev/null
+++ b/drivers/media/i2c/tc358743_regs.h
@@ -0,0 +1,681 @@
+/*
+ * tc358743 - Toshiba HDMI to CSI-2 bridge - register names and bit masks
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights
+ * reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+/*
+ * References (c = chapter, p = page):
+ * REF_01 - Toshiba, TC358743XBG (H2C), Functional Specification, Rev 0.60
+ */
+
+/* Bit masks has prefix 'MASK_' and options after '_'. */
+
+#ifndef __TC358743_REGS_H
+#define __TC358743_REGS_H
+
+#define CHIPID                                0x0000
+#define MASK_CHIPID                           0xff00
+#define MASK_REVID                            0x00ff
+
+#define SYSCTL                                0x0002
+#define MASK_IRRST                            0x0800
+#define MASK_CECRST                           0x0400
+#define MASK_CTXRST                           0x0200
+#define MASK_HDMIRST                          0x0100
+#define MASK_SLEEP                            0x0001
+
+#define CONFCTL                               0x0004
+#define MASK_PWRISO                           0x8000
+#define MASK_ACLKOPT                          0x1000
+#define MASK_AUDCHNUM                         0x0c00
+#define MASK_AUDCHNUM_8                       0x0000
+#define MASK_AUDCHNUM_6                       0x0400
+#define MASK_AUDCHNUM_4                       0x0800
+#define MASK_AUDCHNUM_2                       0x0c00
+#define MASK_AUDCHSEL                         0x0200
+#define MASK_I2SDLYOPT                        0x0100
+#define MASK_YCBCRFMT                         0x00c0
+#define MASK_YCBCRFMT_444                     0x0000
+#define MASK_YCBCRFMT_422_12_BIT              0x0040
+#define MASK_YCBCRFMT_COLORBAR                0x0080
+#define MASK_YCBCRFMT_422_8_BIT               0x00c0
+#define MASK_INFRMEN                          0x0020
+#define MASK_AUDOUTSEL                        0x0018
+#define MASK_AUDOUTSEL_CSI                    0x0000
+#define MASK_AUDOUTSEL_I2S                    0x0010
+#define MASK_AUDOUTSEL_TDM                    0x0018
+#define MASK_AUTOINDEX                        0x0004
+#define MASK_ABUFEN                           0x0002
+#define MASK_VBUFEN                           0x0001
+
+#define FIFOCTL                               0x0006
+
+#define INTSTATUS                             0x0014
+#define MASK_AMUTE_INT                        0x0400
+#define MASK_HDMI_INT                         0x0200
+#define MASK_CSI_INT                          0x0100
+#define MASK_SYS_INT                          0x0020
+#define MASK_CEC_EINT                         0x0010
+#define MASK_CEC_TINT                         0x0008
+#define MASK_CEC_RINT                         0x0004
+#define MASK_IR_EINT                          0x0002
+#define MASK_IR_DINT                          0x0001
+
+#define INTMASK                               0x0016
+#define MASK_AMUTE_MSK                        0x0400
+#define MASK_HDMI_MSK                         0x0200
+#define MASK_CSI_MSK                          0x0100
+#define MASK_SYS_MSK                          0x0020
+#define MASK_CEC_EMSK                         0x0010
+#define MASK_CEC_TMSK                         0x0008
+#define MASK_CEC_RMSK                         0x0004
+#define MASK_IR_EMSK                          0x0002
+#define MASK_IR_DMSK                          0x0001
+
+#define INTFLAG                               0x0018
+#define INTSYSSTATUS                          0x001A
+
+#define PLLCTL0                               0x0020
+#define MASK_PLL_PRD                          0xf000
+#define SET_PLL_PRD(prd)                      ((((prd) - 1) << 12) &\
+						MASK_PLL_PRD)
+#define MASK_PLL_FBD                          0x01ff
+#define SET_PLL_FBD(fbd)                      (((fbd) - 1) & MASK_PLL_FBD)
+
+#define PLLCTL1                               0x0022
+#define MASK_PLL_FRS                          0x0c00
+#define SET_PLL_FRS(frs)                      (((frs) << 10) & MASK_PLL_FRS)
+#define MASK_PLL_LBWS                         0x0300
+#define MASK_LFBREN                           0x0040
+#define MASK_BYPCKEN                          0x0020
+#define MASK_CKEN                             0x0010
+#define MASK_RESETB                           0x0002
+#define MASK_PLL_EN                           0x0001
+
+#define CLW_CNTRL                             0x0140
+#define MASK_CLW_LANEDISABLE                  0x0001
+
+#define D0W_CNTRL                             0x0144
+#define MASK_D0W_LANEDISABLE                  0x0001
+
+#define D1W_CNTRL                             0x0148
+#define MASK_D1W_LANEDISABLE                  0x0001
+
+#define D2W_CNTRL                             0x014C
+#define MASK_D2W_LANEDISABLE                  0x0001
+
+#define D3W_CNTRL                             0x0150
+#define MASK_D3W_LANEDISABLE                  0x0001
+
+#define STARTCNTRL                            0x0204
+#define MASK_START                            0x00000001
+
+#define LINEINITCNT                           0x0210
+#define LPTXTIMECNT                           0x0214
+#define TCLK_HEADERCNT                        0x0218
+#define TCLK_TRAILCNT                         0x021C
+#define THS_HEADERCNT                         0x0220
+#define TWAKEUP                               0x0224
+#define TCLK_POSTCNT                          0x0228
+#define THS_TRAILCNT                          0x022C
+#define HSTXVREGCNT                           0x0230
+
+#define HSTXVREGEN                            0x0234
+#define MASK_D3M_HSTXVREGEN                   0x0010
+#define MASK_D2M_HSTXVREGEN                   0x0008
+#define MASK_D1M_HSTXVREGEN                   0x0004
+#define MASK_D0M_HSTXVREGEN                   0x0002
+#define MASK_CLM_HSTXVREGEN                   0x0001
+
+
+#define TXOPTIONCNTRL                         0x0238
+#define MASK_CONTCLKMODE                      0x00000001
+
+#define CSI_CONTROL                           0x040C
+#define MASK_CSI_MODE                         0x8000
+#define MASK_HTXTOEN                          0x0400
+#define MASK_TXHSMD                           0x0080
+#define MASK_HSCKMD                           0x0020
+#define MASK_NOL                              0x0006
+#define MASK_NOL_1                            0x0000
+#define MASK_NOL_2                            0x0002
+#define MASK_NOL_3                            0x0004
+#define MASK_NOL_4                            0x0006
+#define MASK_EOTDIS                           0x0001
+
+#define CSI_INT                               0x0414
+#define MASK_INTHLT                           0x00000008
+#define MASK_INTER                            0x00000004
+
+#define CSI_INT_ENA                           0x0418
+#define MASK_IENHLT                           0x00000008
+#define MASK_IENER                            0x00000004
+
+#define CSI_ERR                               0x044C
+#define MASK_INER                             0x00000200
+#define MASK_WCER                             0x00000100
+#define MASK_QUNK                             0x00000010
+#define MASK_TXBRK                            0x00000002
+
+#define CSI_ERR_INTENA                        0x0450
+#define CSI_ERR_HALT                          0x0454
+
+#define CSI_CONFW                             0x0500
+#define MASK_MODE                             0xe0000000
+#define MASK_MODE_SET                         0xa0000000
+#define MASK_MODE_CLEAR                       0xc0000000
+#define MASK_ADDRESS                          0x1f000000
+#define MASK_ADDRESS_CSI_CONTROL              0x03000000
+#define MASK_ADDRESS_CSI_INT_ENA              0x06000000
+#define MASK_ADDRESS_CSI_ERR_INTENA           0x14000000
+#define MASK_ADDRESS_CSI_ERR_HALT             0x15000000
+#define MASK_DATA                             0x0000ffff
+
+#define CSI_INT_CLR                           0x050C
+#define MASK_ICRER                            0x00000004
+
+#define CSI_START                             0x0518
+#define MASK_STRT                             0x00000001
+
+#define CECEN                                 0x0600
+#define MASK_CECEN                            0x0001
+
+#define HDMI_INT0                             0x8500
+#define MASK_I_KEY                            0x80
+#define MASK_I_MISC                           0x02
+#define MASK_I_PHYERR                         0x01
+
+#define HDMI_INT1                             0x8501
+#define MASK_I_GBD                            0x80
+#define MASK_I_HDCP                           0x40
+#define MASK_I_ERR                            0x20
+#define MASK_I_AUD                            0x10
+#define MASK_I_CBIT                           0x08
+#define MASK_I_PACKET                         0x04
+#define MASK_I_CLK                            0x02
+#define MASK_I_SYS                            0x01
+
+#define SYS_INT                               0x8502
+#define MASK_I_ACR_CTS                        0x80
+#define MASK_I_ACRN                           0x40
+#define MASK_I_DVI                            0x20
+#define MASK_I_HDMI                           0x10
+#define MASK_I_NOPMBDET                       0x08
+#define MASK_I_DPMBDET                        0x04
+#define MASK_I_TMDS                           0x02
+#define MASK_I_DDC                            0x01
+
+#define CLK_INT                               0x8503
+#define MASK_I_OUT_H_CHG                      0x40
+#define MASK_I_IN_DE_CHG                      0x20
+#define MASK_I_IN_HV_CHG                      0x10
+#define MASK_I_DC_CHG                         0x08
+#define MASK_I_PXCLK_CHG                      0x04
+#define MASK_I_PHYCLK_CHG                     0x02
+#define MASK_I_TMDSCLK_CHG                    0x01
+
+#define CBIT_INT                              0x8505
+#define MASK_I_AF_LOCK                        0x80
+#define MASK_I_AF_UNLOCK                      0x40
+#define MASK_I_CBIT_FS                        0x02
+
+#define AUDIO_INT                             0x8506
+
+#define ERR_INT                               0x8507
+#define MASK_I_EESS_ERR                       0x80
+
+#define HDCP_INT                              0x8508
+#define MASK_I_AVM_SET                        0x80
+#define MASK_I_AVM_CLR                        0x40
+#define MASK_I_LINKERR                        0x20
+#define MASK_I_SHA_END                        0x10
+#define MASK_I_R0_END                         0x08
+#define MASK_I_KM_END                         0x04
+#define MASK_I_AKSV_END                       0x02
+#define MASK_I_AN_END                         0x01
+
+#define MISC_INT                              0x850B
+#define MASK_I_AS_LAYOUT                      0x10
+#define MASK_I_NO_SPD                         0x08
+#define MASK_I_NO_VS                          0x03
+#define MASK_I_SYNC_CHG                       0x02
+#define MASK_I_AUDIO_MUTE                     0x01
+
+#define KEY_INT                               0x850F
+
+#define SYS_INTM                              0x8512
+#define MASK_M_ACR_CTS                        0x80
+#define MASK_M_ACR_N                          0x40
+#define MASK_M_DVI_DET                        0x20
+#define MASK_M_HDMI_DET                       0x10
+#define MASK_M_NOPMBDET                       0x08
+#define MASK_M_BPMBDET                        0x04
+#define MASK_M_TMDS                           0x02
+#define MASK_M_DDC                            0x01
+
+#define CLK_INTM                              0x8513
+#define MASK_M_OUT_H_CHG                      0x40
+#define MASK_M_IN_DE_CHG                      0x20
+#define MASK_M_IN_HV_CHG                      0x10
+#define MASK_M_DC_CHG                         0x08
+#define MASK_M_PXCLK_CHG                      0x04
+#define MASK_M_PHYCLK_CHG                     0x02
+#define MASK_M_TMDS_CHG                       0x01
+
+#define PACKET_INTM                           0x8514
+
+#define CBIT_INTM                             0x8515
+#define MASK_M_AF_LOCK                        0x80
+#define MASK_M_AF_UNLOCK                      0x40
+#define MASK_M_CBIT_FS                        0x02
+
+#define AUDIO_INTM                            0x8516
+#define MASK_M_BUFINIT_END                    0x01
+
+#define ERR_INTM                              0x8517
+#define MASK_M_EESS_ERR                       0x80
+
+#define HDCP_INTM                             0x8518
+#define MASK_M_AVM_SET                        0x80
+#define MASK_M_AVM_CLR                        0x40
+#define MASK_M_LINKERR                        0x20
+#define MASK_M_SHA_END                        0x10
+#define MASK_M_R0_END                         0x08
+#define MASK_M_KM_END                         0x04
+#define MASK_M_AKSV_END                       0x02
+#define MASK_M_AN_END                         0x01
+
+#define MISC_INTM                             0x851B
+#define MASK_M_AS_LAYOUT                      0x10
+#define MASK_M_NO_SPD                         0x08
+#define MASK_M_NO_VS                          0x03
+#define MASK_M_SYNC_CHG                       0x02
+#define MASK_M_AUDIO_MUTE                     0x01
+
+#define KEY_INTM                              0x851F
+
+#define SYS_STATUS                            0x8520
+#define MASK_S_SYNC                           0x80
+#define MASK_S_AVMUTE                         0x40
+#define MASK_S_HDCP                           0x20
+#define MASK_S_HDMI                           0x10
+#define MASK_S_PHY_SCDT                       0x08
+#define MASK_S_PHY_PLL                        0x04
+#define MASK_S_TMDS                           0x02
+#define MASK_S_DDC5V                          0x01
+
+#define CSI_STATUS                            0x0410
+#define MASK_S_WSYNC                          0x0400
+#define MASK_S_TXACT                          0x0200
+#define MASK_S_RXACT                          0x0100
+#define MASK_S_HLT                            0x0001
+
+#define VI_STATUS1                            0x8522
+#define MASK_S_V_GBD                          0x08
+#define MASK_S_DEEPCOLOR                      0x0c
+#define MASK_S_V_422                          0x02
+#define MASK_S_V_INTERLACE                    0x01
+
+#define AU_STATUS0                            0x8523
+#define MASK_S_A_SAMPLE                       0x01
+
+#define VI_STATUS3                            0x8528
+#define MASK_S_V_COLOR                        0x1e
+#define MASK_LIMITED                          0x01
+
+#define PHY_CTL0                              0x8531
+#define MASK_PHY_SYSCLK_IND                   0x02
+#define MASK_PHY_CTL                          0x01
+
+
+#define PHY_CTL1                              0x8532 /* Not in REF_01 */
+#define MASK_PHY_AUTO_RST1                    0xf0
+#define MASK_PHY_AUTO_RST1_OFF                0x00
+#define SET_PHY_AUTO_RST1_US(us)             ((((us) / 200) << 4) & \
+						MASK_PHY_AUTO_RST1)
+#define MASK_FREQ_RANGE_MODE                  0x0f
+#define SET_FREQ_RANGE_MODE_CYCLES(cycles)   (((cycles) - 1) & \
+						MASK_FREQ_RANGE_MODE)
+
+#define PHY_CTL2                              0x8533 /* Not in REF_01 */
+#define MASK_PHY_AUTO_RST4                    0x04
+#define MASK_PHY_AUTO_RST3                    0x02
+#define MASK_PHY_AUTO_RST2                    0x01
+#define MASK_PHY_AUTO_RSTn                    (MASK_PHY_AUTO_RST4 | \
+						MASK_PHY_AUTO_RST3 | \
+						MASK_PHY_AUTO_RST2)
+
+#define PHY_EN                                0x8534
+#define MASK_ENABLE_PHY                       0x01
+
+#define PHY_RST                               0x8535
+#define MASK_RESET_CTRL                       0x01   /* Reset active low */
+
+#define PHY_BIAS                              0x8536 /* Not in REF_01 */
+
+#define PHY_CSQ                               0x853F /* Not in REF_01 */
+#define MASK_CSQ_CNT                          0x0f
+#define SET_CSQ_CNT_LEVEL(n)                 (n & MASK_CSQ_CNT)
+
+#define SYS_FREQ0                             0x8540
+#define SYS_FREQ1                             0x8541
+
+#define SYS_CLK                               0x8542 /* Not in REF_01 */
+#define MASK_CLK_DIFF                         0x0C
+#define MASK_CLK_DIV                          0x03
+
+#define DDC_CTL                               0x8543
+#define MASK_DDC_ACK_POL                      0x08
+#define MASK_DDC_ACTION                       0x04
+#define MASK_DDC5V_MODE                       0x03
+#define MASK_DDC5V_MODE_0MS                   0x00
+#define MASK_DDC5V_MODE_50MS                  0x01
+#define MASK_DDC5V_MODE_100MS                 0x02
+#define MASK_DDC5V_MODE_200MS                 0x03
+
+#define HPD_CTL                               0x8544
+#define MASK_HPD_CTL0                         0x10
+#define MASK_HPD_OUT0                         0x01
+
+#define ANA_CTL                               0x8545
+#define MASK_APPL_PCSX                        0x30
+#define MASK_APPL_PCSX_HIZ                    0x00
+#define MASK_APPL_PCSX_L_FIX                  0x10
+#define MASK_APPL_PCSX_H_FIX                  0x20
+#define MASK_APPL_PCSX_NORMAL                 0x30
+#define MASK_ANALOG_ON                        0x01
+
+#define AVM_CTL                               0x8546
+
+#define INIT_END                              0x854A
+#define MASK_INIT_END                         0x01
+
+#define HDMI_DET                              0x8552 /* Not in REF_01 */
+#define MASK_HDMI_DET_MOD1                    0x80
+#define MASK_HDMI_DET_MOD0                    0x40
+#define MASK_HDMI_DET_V                       0x30
+#define MASK_HDMI_DET_V_SYNC                  0x00
+#define MASK_HDMI_DET_V_ASYNC_25MS            0x10
+#define MASK_HDMI_DET_V_ASYNC_50MS            0x20
+#define MASK_HDMI_DET_V_ASYNC_100MS           0x30
+#define MASK_HDMI_DET_NUM                     0x0f
+
+#define HDCP_MODE                             0x8560
+#define MASK_MODE_RST_TN                      0x20
+#define MASK_LINE_REKEY                       0x10
+#define MASK_AUTO_CLR                         0x04
+
+#define HDCP_REG1                             0x8563 /* Not in REF_01 */
+#define MASK_AUTH_UNAUTH_SEL                  0x70
+#define MASK_AUTH_UNAUTH_SEL_12_FRAMES        0x70
+#define MASK_AUTH_UNAUTH_SEL_8_FRAMES         0x60
+#define MASK_AUTH_UNAUTH_SEL_4_FRAMES         0x50
+#define MASK_AUTH_UNAUTH_SEL_2_FRAMES         0x40
+#define MASK_AUTH_UNAUTH_SEL_64_FRAMES        0x30
+#define MASK_AUTH_UNAUTH_SEL_32_FRAMES        0x20
+#define MASK_AUTH_UNAUTH_SEL_16_FRAMES        0x10
+#define MASK_AUTH_UNAUTH_SEL_ONCE             0x00
+#define MASK_AUTH_UNAUTH                      0x01
+#define MASK_AUTH_UNAUTH_AUTO                 0x01
+
+#define HDCP_REG2                             0x8564 /* Not in REF_01 */
+#define MASK_AUTO_P3_RESET                    0x0F
+#define SET_AUTO_P3_RESET_FRAMES(n)          (n & MASK_AUTO_P3_RESET)
+#define MASK_AUTO_P3_RESET_OFF                0x00
+
+#define VI_MODE                               0x8570
+#define MASK_RGB_DVI                          0x08 /* Not in REF_01 */
+
+#define VOUT_SET2                             0x8573
+#define MASK_SEL422                           0x80
+#define MASK_VOUT_422FIL_100                  0x40
+#define MASK_VOUTCOLORMODE                    0x03
+#define MASK_VOUTCOLORMODE_THROUGH            0x00
+#define MASK_VOUTCOLORMODE_AUTO               0x01
+#define MASK_VOUTCOLORMODE_MANUAL             0x03
+
+#define VOUT_SET3                             0x8574
+#define MASK_VOUT_EXTCNT                      0x08
+
+#define VI_REP                                0x8576
+#define MASK_VOUT_COLOR_SEL                   0xe0
+#define MASK_VOUT_COLOR_RGB_FULL              0x00
+#define MASK_VOUT_COLOR_RGB_LIMITED           0x20
+#define MASK_VOUT_COLOR_601_YCBCR_FULL        0x40
+#define MASK_VOUT_COLOR_601_YCBCR_LIMITED     0x60
+#define MASK_VOUT_COLOR_709_YCBCR_FULL        0x80
+#define MASK_VOUT_COLOR_709_YCBCR_LIMITED     0xa0
+#define MASK_VOUT_COLOR_FULL_TO_LIMITED       0xc0
+#define MASK_VOUT_COLOR_LIMITED_TO_FULL       0xe0
+#define MASK_IN_REP_HEN                       0x10
+#define MASK_IN_REP                           0x0f
+
+#define VI_MUTE                               0x857F
+#define MASK_AUTO_MUTE                        0xc0
+#define MASK_VI_MUTE                          0x10
+
+#define DE_WIDTH_H_LO                         0x8582 /* Not in REF_01 */
+#define DE_WIDTH_H_HI                         0x8583 /* Not in REF_01 */
+#define DE_WIDTH_V_LO                         0x8588 /* Not in REF_01 */
+#define DE_WIDTH_V_HI                         0x8589 /* Not in REF_01 */
+#define H_SIZE_LO                             0x858A /* Not in REF_01 */
+#define H_SIZE_HI                             0x858B /* Not in REF_01 */
+#define V_SIZE_LO                             0x858C /* Not in REF_01 */
+#define V_SIZE_HI                             0x858D /* Not in REF_01 */
+#define FV_CNT_LO                             0x85A1 /* Not in REF_01 */
+#define FV_CNT_HI                             0x85A2 /* Not in REF_01 */
+
+#define FH_MIN0                               0x85AA /* Not in REF_01 */
+#define FH_MIN1                               0x85AB /* Not in REF_01 */
+#define FH_MAX0                               0x85AC /* Not in REF_01 */
+#define FH_MAX1                               0x85AD /* Not in REF_01 */
+
+#define HV_RST                                0x85AF /* Not in REF_01 */
+#define MASK_H_PI_RST                         0x20
+#define MASK_V_PI_RST                         0x10
+
+#define EDID_MODE                             0x85C7
+#define MASK_EDID_SPEED                       0x40
+#define MASK_EDID_MODE                        0x03
+#define MASK_EDID_MODE_DISABLE                0x00
+#define MASK_EDID_MODE_DDC2B                  0x01
+#define MASK_EDID_MODE_E_DDC                  0x02
+
+#define EDID_LEN1                             0x85CA
+#define EDID_LEN2                             0x85CB
+
+#define HDCP_REG3                             0x85D1 /* Not in REF_01 */
+#define KEY_RD_CMD                            0x01
+
+#define FORCE_MUTE                            0x8600
+#define MASK_FORCE_AMUTE                      0x10
+#define MASK_FORCE_DMUTE                      0x01
+
+#define CMD_AUD                               0x8601
+#define MASK_CMD_BUFINIT                      0x04
+#define MASK_CMD_LOCKDET                      0x02
+#define MASK_CMD_MUTE                         0x01
+
+#define AUTO_CMD0                             0x8602
+#define MASK_AUTO_MUTE7                       0x80
+#define MASK_AUTO_MUTE6                       0x40
+#define MASK_AUTO_MUTE5                       0x20
+#define MASK_AUTO_MUTE4                       0x10
+#define MASK_AUTO_MUTE3                       0x08
+#define MASK_AUTO_MUTE2                       0x04
+#define MASK_AUTO_MUTE1                       0x02
+#define MASK_AUTO_MUTE0                       0x01
+
+#define AUTO_CMD1                             0x8603
+#define MASK_AUTO_MUTE10                      0x04
+#define MASK_AUTO_MUTE9                       0x02
+#define MASK_AUTO_MUTE8                       0x01
+
+#define AUTO_CMD2                             0x8604
+#define MASK_AUTO_PLAY3                       0x08
+#define MASK_AUTO_PLAY2                       0x04
+
+#define BUFINIT_START                         0x8606
+#define SET_BUFINIT_START_MS(milliseconds)   ((milliseconds) / 100)
+
+#define FS_MUTE                               0x8607
+#define MASK_FS_ELSE_MUTE                     0x80
+#define MASK_FS22_MUTE                        0x40
+#define MASK_FS24_MUTE                        0x20
+#define MASK_FS88_MUTE                        0x10
+#define MASK_FS96_MUTE                        0x08
+#define MASK_FS176_MUTE                       0x04
+#define MASK_FS192_MUTE                       0x02
+#define MASK_FS_NO_MUTE                       0x01
+
+#define FS_IMODE                              0x8620
+#define MASK_NLPCM_HMODE                      0x40
+#define MASK_NLPCM_SMODE                      0x20
+#define MASK_NLPCM_IMODE                      0x10
+#define MASK_FS_HMODE                         0x08
+#define MASK_FS_AMODE                         0x04
+#define MASK_FS_SMODE                         0x02
+#define MASK_FS_IMODE                         0x01
+
+#define FS_SET                                0x8621
+#define MASK_FS                               0x0f
+
+#define LOCKDET_REF0                          0x8630
+#define LOCKDET_REF1                          0x8631
+#define LOCKDET_REF2                          0x8632
+
+#define ACR_MODE                              0x8640
+#define MASK_ACR_LOAD                         0x10
+#define MASK_N_MODE                           0x04
+#define MASK_CTS_MODE                         0x01
+
+#define ACR_MDF0                              0x8641
+#define MASK_ACR_L2MDF                        0x70
+#define MASK_ACR_L2MDF_0_PPM                  0x00
+#define MASK_ACR_L2MDF_61_PPM                 0x10
+#define MASK_ACR_L2MDF_122_PPM                0x20
+#define MASK_ACR_L2MDF_244_PPM                0x30
+#define MASK_ACR_L2MDF_488_PPM                0x40
+#define MASK_ACR_L2MDF_976_PPM                0x50
+#define MASK_ACR_L2MDF_1976_PPM               0x60
+#define MASK_ACR_L2MDF_3906_PPM               0x70
+#define MASK_ACR_L1MDF                        0x07
+#define MASK_ACR_L1MDF_0_PPM                  0x00
+#define MASK_ACR_L1MDF_61_PPM                 0x01
+#define MASK_ACR_L1MDF_122_PPM                0x02
+#define MASK_ACR_L1MDF_244_PPM                0x03
+#define MASK_ACR_L1MDF_488_PPM                0x04
+#define MASK_ACR_L1MDF_976_PPM                0x05
+#define MASK_ACR_L1MDF_1976_PPM               0x06
+#define MASK_ACR_L1MDF_3906_PPM               0x07
+
+#define ACR_MDF1                              0x8642
+#define MASK_ACR_L3MDF                        0x07
+#define MASK_ACR_L3MDF_0_PPM                  0x00
+#define MASK_ACR_L3MDF_61_PPM                 0x01
+#define MASK_ACR_L3MDF_122_PPM                0x02
+#define MASK_ACR_L3MDF_244_PPM                0x03
+#define MASK_ACR_L3MDF_488_PPM                0x04
+#define MASK_ACR_L3MDF_976_PPM                0x05
+#define MASK_ACR_L3MDF_1976_PPM               0x06
+#define MASK_ACR_L3MDF_3906_PPM               0x07
+
+#define SDO_MODE1                             0x8652
+#define MASK_SDO_BIT_LENG                     0x70
+#define MASK_SDO_FMT                          0x03
+#define MASK_SDO_FMT_RIGHT                    0x00
+#define MASK_SDO_FMT_LEFT                     0x01
+#define MASK_SDO_FMT_I2S                      0x02
+
+#define DIV_MODE                              0x8665 /* Not in REF_01 */
+#define MASK_DIV_DLY                          0xf0
+#define SET_DIV_DLY_MS(milliseconds)         ((((milliseconds) / 100) << 4) & \
+						MASK_DIV_DLY)
+#define MASK_DIV_MODE                         0x01
+
+#define NCO_F0_MOD                            0x8670
+#define MASK_NCO_F0_MOD                       0x03
+#define MASK_NCO_F0_MOD_42MHZ                 0x00
+#define MASK_NCO_F0_MOD_27MHZ                 0x01
+
+#define PK_INT_MODE                           0x8709
+#define MASK_ISRC2_INT_MODE                   0x80
+#define MASK_ISRC_INT_MODE                    0x40
+#define MASK_ACP_INT_MODE                     0x20
+#define MASK_VS_INT_MODE                      0x10
+#define MASK_SPD_INT_MODE                     0x08
+#define MASK_MS_INT_MODE                      0x04
+#define MASK_AUD_INT_MODE                     0x02
+#define MASK_AVI_INT_MODE                     0x01
+
+#define NO_PKT_LIMIT                          0x870B
+#define MASK_NO_ACP_LIMIT                     0xf0
+#define SET_NO_ACP_LIMIT_MS(milliseconds)    ((((milliseconds) / 80) << 4) & \
+						MASK_NO_ACP_LIMIT)
+#define MASK_NO_AVI_LIMIT                     0x0f
+#define SET_NO_AVI_LIMIT_MS(milliseconds)    (((milliseconds) / 80) & \
+						MASK_NO_AVI_LIMIT)
+
+#define NO_PKT_CLR                            0x870C
+#define MASK_NO_VS_CLR                        0x40
+#define MASK_NO_SPD_CLR                       0x20
+#define MASK_NO_ACP_CLR                       0x10
+#define MASK_NO_AVI_CLR1                      0x02
+#define MASK_NO_AVI_CLR0                      0x01
+
+#define ERR_PK_LIMIT                          0x870D
+#define NO_PKT_LIMIT2                         0x870E
+#define PK_AVI_0HEAD                          0x8710
+#define PK_AVI_1HEAD                          0x8711
+#define PK_AVI_2HEAD                          0x8712
+#define PK_AVI_0BYTE                          0x8713
+#define PK_AVI_1BYTE                          0x8714
+#define PK_AVI_2BYTE                          0x8715
+#define PK_AVI_3BYTE                          0x8716
+#define PK_AVI_4BYTE                          0x8717
+#define PK_AVI_5BYTE                          0x8718
+#define PK_AVI_6BYTE                          0x8719
+#define PK_AVI_7BYTE                          0x871A
+#define PK_AVI_8BYTE                          0x871B
+#define PK_AVI_9BYTE                          0x871C
+#define PK_AVI_10BYTE                         0x871D
+#define PK_AVI_11BYTE                         0x871E
+#define PK_AVI_12BYTE                         0x871F
+#define PK_AVI_13BYTE                         0x8720
+#define PK_AVI_14BYTE                         0x8721
+#define PK_AVI_15BYTE                         0x8722
+#define PK_AVI_16BYTE                         0x8723
+
+#define BKSV                                  0x8800
+
+#define BCAPS                                 0x8840
+#define MASK_HDMI_RSVD                        0x80
+#define MASK_REPEATER                         0x40
+#define MASK_READY                            0x20
+#define MASK_FASTI2C                          0x10
+#define MASK_1_1_FEA                          0x02
+#define MASK_FAST_REAU                        0x01
+
+#define BSTATUS1                              0x8842
+#define MASK_MAX_EXCED                        0x08
+
+#define EDID_RAM                              0x8C00
+#define NO_GDB_LIMIT                          0x9007
+
+#endif
diff --git a/include/media/tc358743.h b/include/media/tc358743.h
new file mode 100644
index 0000000..cfe2fcd
--- /dev/null
+++ b/include/media/tc358743.h
@@ -0,0 +1,131 @@
+/*
+ * tc358743 - Toshiba HDMI to CSI-2 bridge
+ *
+ * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights
+ * reserved.
+ *
+ * This program is free software; you may redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+/*
+ * References (c = chapter, p = page):
+ * REF_01 - Toshiba, TC358743XBG (H2C), Functional Specification, Rev 0.60
+ * REF_02 - Toshiba, TC358743XBG_HDMI-CSI_Tv11p_nm.xls
+ */
+
+#ifndef _TC358743_
+#define _TC358743_
+
+enum tc358743_ddc5v_delays {
+	DDC5V_DELAY_0_MS,
+	DDC5V_DELAY_50_MS,
+	DDC5V_DELAY_100_MS,
+	DDC5V_DELAY_200_MS,
+};
+
+enum tc358743_hdmi_detection_delay {
+	HDMI_MODE_DELAY_0_MS,
+	HDMI_MODE_DELAY_25_MS,
+	HDMI_MODE_DELAY_50_MS,
+	HDMI_MODE_DELAY_100_MS,
+};
+
+struct tc358743_platform_data {
+	/* System clock connected to REFCLK (pin H5) */
+	u32 refclk_hz; /* 26 MHz, 27 MHz or 42 MHz */
+
+	/* DDC +5V debounce delay to avoid spurious interrupts when the cable
+	 * is connected.
+	 * Sets DDC5V_MODE in register DDC_CTL.
+	 * Default: DDC5V_DELAY_0_MS
+	 */
+	enum tc358743_ddc5v_delays ddc5v_delay;
+
+	bool enable_hdcp;
+
+	/*
+	 * The FIFO size is 512x32, so Toshiba recommend to set the default FIFO
+	 * level to somewhere in the middle (e.g. 300), so it can cover speed
+	 * mismatches in input and output ports.
+	 */
+	u16 fifo_level;
+
+	/* Bps pr lane is (refclk_hz / pll_prd) * pll_fbd */
+	u16 pll_prd;
+	u16 pll_fbd;
+
+	/* CSI
+	 * Calculate CSI parameters with REF_02 for the highest resolution your
+	 * CSI interface can handle. The driver will adjust the number of CSI
+	 * lanes in use according to the pixel clock.
+	 *
+	 * The values in brackets are calculated with REF_02 when the number of
+	 * bps pr lane is 823.5 MHz, and can serve as a starting point.
+	 */
+	u32 lineinitcnt;	/* (0x00001770) */
+	u32 lptxtimecnt;	/* (0x00000005) */
+	u32 tclk_headercnt;	/* (0x00001d04) */
+	u32 tclk_trailcnt;	/* (0x00000000) */
+	u32 ths_headercnt;	/* (0x00000505) */
+	u32 twakeup;		/* (0x00004650) */
+	u32 tclk_postcnt;	/* (0x00000000) */
+	u32 ths_trailcnt;	/* (0x00000004) */
+	u32 hstxvregcnt;	/* (0x00000005) */
+
+	/* DVI->HDMI detection delay to avoid unnecessary switching between DVI
+	 * and HDMI mode.
+	 * Sets HDMI_DET_V in register HDMI_DET.
+	 * Default: HDMI_MODE_DELAY_0_MS
+	 */
+	enum tc358743_hdmi_detection_delay hdmi_detection_delay;
+
+	/* Reset PHY automatically when TMDS clock goes from DC to AC.
+	 * Sets PHY_AUTO_RST2 in register PHY_CTL2.
+	 * Default: false
+	 */
+	bool hdmi_phy_auto_reset_tmds_detected;
+
+	/* Reset PHY automatically when TMDS clock passes 21 MHz.
+	 * Sets PHY_AUTO_RST3 in register PHY_CTL2.
+	 * Default: false
+	 */
+	bool hdmi_phy_auto_reset_tmds_in_range;
+
+	/* Reset PHY automatically when TMDS clock is detected.
+	 * Sets PHY_AUTO_RST4 in register PHY_CTL2.
+	 * Default: false
+	 */
+	bool hdmi_phy_auto_reset_tmds_valid;
+
+	/* Reset HDMI PHY automatically when hsync period is out of range.
+	 * Sets H_PI_RST in register HV_RST.
+	 * Default: false
+	 */
+	bool hdmi_phy_auto_reset_hsync_out_of_range;
+
+	/* Reset HDMI PHY automatically when vsync period is out of range.
+	 * Sets V_PI_RST in register HV_RST.
+	 * Default: false
+	 */
+	bool hdmi_phy_auto_reset_vsync_out_of_range;
+};
+
+/* custom controls */
+/* Audio sample rate in Hz */
+#define TC358743_CID_AUDIO_SAMPLING_RATE (V4L2_CID_USER_TC358743_BASE + 0)
+/* Audio present status */
+#define TC358743_CID_AUDIO_PRESENT       (V4L2_CID_USER_TC358743_BASE + 1)
+
+#endif
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 9f6e108..d448c53 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -174,6 +174,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_ADV7180_BASE		(V4L2_CID_USER_BASE + 0x1070)
 
+/* The base for the tc358743 driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
-- 
2.4.3


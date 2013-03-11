Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1607 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 13/42] tw2804: add support for the Techwell tw2804.
Date: Mon, 11 Mar 2013 12:45:51 +0100
Message-Id: <36ee090a9bdef8e9ea705b1d8a559f061790ac54.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is based on the wis-tw2804.c driver that's part of the go7007 driver.
It has been converted to a v4l subdev driver by Volokh Konstantin, and I
made additional cleanups.

Based on work by: Volokh Konstantin <volokh84@gmail.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/media/i2c/Kconfig  |   11 +-
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/tw2804.c |  467 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 478 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/i2c/tw2804.c

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index eb9ef55..4c03684 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -301,11 +301,20 @@ config VIDEO_TVP7002
 	  To compile this driver as a module, choose M here: the
 	  module will be called tvp7002.
 
+config VIDEO_TW2804
+	tristate "Techwell TW2804 multiple video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Techwell tw2804 multiple video decoder.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tw2804.
+
 config VIDEO_TW9903
 	tristate "Techwell TW9903 video decoder"
 	depends on VIDEO_V4L2 && I2C
 	---help---
-	  Support for the Techwell 9903 multi-standard video decoder
+	  Support for the Techwell tw9903 multi-standard video decoder
 	  with high quality down scaler.
 
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index af8fb29..399050a 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
 obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
 obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
 obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
+obj-$(CONFIG_VIDEO_TW2804) += tw2804.o
 obj-$(CONFIG_VIDEO_TW9903) += tw9903.o
 obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
 obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
diff --git a/drivers/media/i2c/tw2804.c b/drivers/media/i2c/tw2804.c
new file mode 100644
index 0000000..4bb5ba6
--- /dev/null
+++ b/drivers/media/i2c/tw2804.c
@@ -0,0 +1,467 @@
+/*
+ * Copyright (C) 2005-2006 Micronas USA Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (Version 2) as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/i2c.h>
+#include <linux/videodev2.h>
+#include <linux/ioctl.h>
+#include <linux/slab.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-ctrls.h>
+
+#define TW2804_REG_AUTOGAIN		0x02
+#define TW2804_REG_HUE			0x0f
+#define TW2804_REG_SATURATION		0x10
+#define TW2804_REG_CONTRAST		0x11
+#define TW2804_REG_BRIGHTNESS		0x12
+#define TW2804_REG_COLOR_KILLER		0x14
+#define TW2804_REG_GAIN			0x3c
+#define TW2804_REG_CHROMA_GAIN		0x3d
+#define TW2804_REG_BLUE_BALANCE		0x3e
+#define TW2804_REG_RED_BALANCE		0x3f
+
+struct tw2804 {
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	u8 channel:2;
+	u8 input:1;
+	int norm;
+};
+
+static const u8 global_registers[] = {
+	0x39, 0x00,
+	0x3a, 0xff,
+	0x3b, 0x84,
+	0x3c, 0x80,
+	0x3d, 0x80,
+	0x3e, 0x82,
+	0x3f, 0x82,
+	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
+};
+
+static const u8 channel_registers[] = {
+	0x01, 0xc4,
+	0x02, 0xa5,
+	0x03, 0x20,
+	0x04, 0xd0,
+	0x05, 0x20,
+	0x06, 0xd0,
+	0x07, 0x88,
+	0x08, 0x20,
+	0x09, 0x07,
+	0x0a, 0xf0,
+	0x0b, 0x07,
+	0x0c, 0xf0,
+	0x0d, 0x40,
+	0x0e, 0xd2,
+	0x0f, 0x80,
+	0x10, 0x80,
+	0x11, 0x80,
+	0x12, 0x80,
+	0x13, 0x1f,
+	0x14, 0x00,
+	0x15, 0x00,
+	0x16, 0x00,
+	0x17, 0x00,
+	0x18, 0xff,
+	0x19, 0xff,
+	0x1a, 0xff,
+	0x1b, 0xff,
+	0x1c, 0xff,
+	0x1d, 0xff,
+	0x1e, 0xff,
+	0x1f, 0xff,
+	0x20, 0x07,
+	0x21, 0x07,
+	0x22, 0x00,
+	0x23, 0x91,
+	0x24, 0x51,
+	0x25, 0x03,
+	0x26, 0x00,
+	0x27, 0x00,
+	0x28, 0x00,
+	0x29, 0x00,
+	0x2a, 0x00,
+	0x2b, 0x00,
+	0x2c, 0x00,
+	0x2d, 0x00,
+	0x2e, 0x00,
+	0x2f, 0x00,
+	0x30, 0x00,
+	0x31, 0x00,
+	0x32, 0x00,
+	0x33, 0x00,
+	0x34, 0x00,
+	0x35, 0x00,
+	0x36, 0x00,
+	0x37, 0x00,
+	0xff, 0xff, /* Terminator (reg 0xff does not exist) */
+};
+
+static int write_reg(struct i2c_client *client, u8 reg, u8 value, u8 channel)
+{
+	return i2c_smbus_write_byte_data(client, reg | (channel << 6), value);
+}
+
+static int write_regs(struct i2c_client *client, const u8 *regs, u8 channel)
+{
+	int ret;
+	int i;
+
+	for (i = 0; regs[i] != 0xff; i += 2) {
+		ret = i2c_smbus_write_byte_data(client,
+				regs[i] | (channel << 6), regs[i + 1]);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+static int read_reg(struct i2c_client *client, u8 reg, u8 channel)
+{
+	return i2c_smbus_read_byte_data(client, (reg) | (channel << 6));
+}
+
+static inline struct tw2804 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tw2804, sd);
+}
+
+static inline struct tw2804 *to_state_from_ctrl(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct tw2804, hdl);
+}
+
+static int tw2804_log_status(struct v4l2_subdev *sd)
+{
+	struct tw2804 *state = to_state(sd);
+
+	v4l2_info(sd, "Standard: %s\n",
+			state->norm & V4L2_STD_525_60 ? "60 Hz" : "50 Hz");
+	v4l2_info(sd, "Channel: %d\n", state->channel);
+	v4l2_info(sd, "Input: %d\n", state->input);
+	return v4l2_ctrl_subdev_log_status(sd);
+}
+
+/*
+ * These volatile controls are needed because all four channels share
+ * these controls. So a change made to them through one channel would
+ * require another channel to be updated.
+ *
+ * Normally this would have been done in a different way, but since the one
+ * board that uses this driver sees this single chip as if it was on four
+ * different i2c adapters (each adapter belonging to a separate instance of
+ * the same USB driver) there is no reliable method that I have found to let
+ * the instances know about each other.
+ *
+ * So implementing these global registers as volatile is the best we can do.
+ */
+static int tw2804_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct tw2804 *state = to_state_from_ctrl(ctrl);
+	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
+
+	switch (ctrl->id) {
+	case V4L2_CID_GAIN:
+		ctrl->val = read_reg(client, TW2804_REG_GAIN, 0);
+		return 0;
+
+	case V4L2_CID_CHROMA_GAIN:
+		ctrl->val = read_reg(client, TW2804_REG_CHROMA_GAIN, 0);
+		return 0;
+
+	case V4L2_CID_BLUE_BALANCE:
+		ctrl->val = read_reg(client, TW2804_REG_BLUE_BALANCE, 0);
+		return 0;
+
+	case V4L2_CID_RED_BALANCE:
+		ctrl->val = read_reg(client, TW2804_REG_RED_BALANCE, 0);
+		return 0;
+	}
+	return 0;
+}
+
+static int tw2804_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct tw2804 *state = to_state_from_ctrl(ctrl);
+	struct i2c_client *client = v4l2_get_subdevdata(&state->sd);
+	int addr;
+	int reg;
+
+	switch (ctrl->id) {
+	case V4L2_CID_AUTOGAIN:
+		addr = TW2804_REG_AUTOGAIN;
+		reg = read_reg(client, addr, state->channel);
+		if (reg < 0)
+			return reg;
+		if (ctrl->val == 0)
+			reg &= ~(1 << 7);
+		else
+			reg |= 1 << 7;
+		return write_reg(client, addr, reg, state->channel);
+
+	case V4L2_CID_COLOR_KILLER:
+		addr = TW2804_REG_COLOR_KILLER;
+		reg = read_reg(client, addr, state->channel);
+		if (reg < 0)
+			return reg;
+		reg = (reg & ~(0x03)) | (ctrl->val == 0 ? 0x02 : 0x03);
+		return write_reg(client, addr, reg, state->channel);
+
+	case V4L2_CID_GAIN:
+		return write_reg(client, TW2804_REG_GAIN, ctrl->val, 0);
+
+	case V4L2_CID_CHROMA_GAIN:
+		return write_reg(client, TW2804_REG_CHROMA_GAIN, ctrl->val, 0);
+
+	case V4L2_CID_BLUE_BALANCE:
+		return write_reg(client, TW2804_REG_BLUE_BALANCE, ctrl->val, 0);
+
+	case V4L2_CID_RED_BALANCE:
+		return write_reg(client, TW2804_REG_RED_BALANCE, ctrl->val, 0);
+
+	case V4L2_CID_BRIGHTNESS:
+		return write_reg(client, TW2804_REG_BRIGHTNESS,
+				ctrl->val, state->channel);
+
+	case V4L2_CID_CONTRAST:
+		return write_reg(client, TW2804_REG_CONTRAST,
+				ctrl->val, state->channel);
+
+	case V4L2_CID_SATURATION:
+		return write_reg(client, TW2804_REG_SATURATION,
+				ctrl->val, state->channel);
+
+	case V4L2_CID_HUE:
+		return write_reg(client, TW2804_REG_HUE,
+				ctrl->val, state->channel);
+
+	default:
+		break;
+	}
+	return -EINVAL;
+}
+
+static int tw2804_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	struct tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	bool is_60hz = norm & V4L2_STD_525_60;
+	u8 regs[] = {
+		0x01, is_60hz ? 0xc4 : 0x84,
+		0x09, is_60hz ? 0x07 : 0x04,
+		0x0a, is_60hz ? 0xf0 : 0x20,
+		0x0b, is_60hz ? 0x07 : 0x04,
+		0x0c, is_60hz ? 0xf0 : 0x20,
+		0x0d, is_60hz ? 0x40 : 0x4a,
+		0x16, is_60hz ? 0x00 : 0x40,
+		0x17, is_60hz ? 0x00 : 0x40,
+		0x20, is_60hz ? 0x07 : 0x0f,
+		0x21, is_60hz ? 0x07 : 0x0f,
+		0xff, 0xff,
+	};
+
+	write_regs(client, regs, dec->channel);
+	dec->norm = norm;
+	return 0;
+}
+
+static int tw2804_s_video_routing(struct v4l2_subdev *sd, u32 input, u32 output,
+	u32 config)
+{
+	struct tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	int reg;
+
+	if (config && config - 1 != dec->channel) {
+		if (config > 4) {
+			dev_err(&client->dev,
+				"channel %d is not between 1 and 4!\n", config);
+			return -EINVAL;
+		}
+		dec->channel = config - 1;
+		dev_dbg(&client->dev, "initializing TW2804 channel %d\n",
+			dec->channel);
+		if (dec->channel == 0 &&
+				write_regs(client, global_registers, 0) < 0) {
+			dev_err(&client->dev,
+				"error initializing TW2804 global registers\n");
+			return -EIO;
+		}
+		if (write_regs(client, channel_registers, dec->channel) < 0) {
+			dev_err(&client->dev,
+				"error initializing TW2804 channel %d\n",
+				dec->channel);
+			return -EIO;
+		}
+	}
+
+	if (input > 1)
+		return -EINVAL;
+
+	if (input == dec->input)
+		return 0;
+
+	reg = read_reg(client, 0x22, dec->channel);
+
+	if (reg >= 0) {
+		if (input == 0)
+			reg &= ~(1 << 2);
+		else
+			reg |= 1 << 2;
+		reg = write_reg(client, 0x22, reg, dec->channel);
+	}
+
+	if (reg >= 0)
+		dec->input = input;
+	else
+		return reg;
+	return 0;
+}
+
+static int tw2804_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct tw2804 *dec = to_state(sd);
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+	u32 reg = read_reg(client, 0x78, 0);
+
+	if (enable == 1)
+		write_reg(client, 0x78, reg & ~(1 << dec->channel), 0);
+	else
+		write_reg(client, 0x78, reg | (1 << dec->channel), 0);
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops tw2804_ctrl_ops = {
+	.g_volatile_ctrl = tw2804_g_volatile_ctrl,
+	.s_ctrl = tw2804_s_ctrl,
+};
+
+static const struct v4l2_subdev_video_ops tw2804_video_ops = {
+	.s_routing = tw2804_s_video_routing,
+	.s_stream = tw2804_s_stream,
+};
+
+static const struct v4l2_subdev_core_ops tw2804_core_ops = {
+	.log_status = tw2804_log_status,
+	.s_std = tw2804_s_std,
+};
+
+static const struct v4l2_subdev_ops tw2804_ops = {
+	.core = &tw2804_core_ops,
+	.video = &tw2804_video_ops,
+};
+
+static int tw2804_probe(struct i2c_client *client,
+			    const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	struct tw2804 *state;
+	struct v4l2_subdev *sd;
+	struct v4l2_ctrl *ctrl;
+	int err;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	state = kzalloc(sizeof(struct tw2804), GFP_KERNEL);
+
+	if (state == NULL)
+		return -ENOMEM;
+	sd = &state->sd;
+	v4l2_i2c_subdev_init(sd, client, &tw2804_ops);
+	state->channel = -1;
+	state->norm = V4L2_STD_NTSC;
+
+	v4l2_ctrl_handler_init(&state->hdl, 10);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_BRIGHTNESS, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_CONTRAST, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_SATURATION, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_HUE, 0, 255, 1, 128);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_COLOR_KILLER, 0, 1, 1, 0);
+	v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_AUTOGAIN, 0, 1, 1, 0);
+	ctrl = v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_GAIN, 0, 255, 1, 128);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ctrl = v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_CHROMA_GAIN, 0, 255, 1, 128);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ctrl = v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_BLUE_BALANCE, 0, 255, 1, 122);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	ctrl = v4l2_ctrl_new_std(&state->hdl, &tw2804_ctrl_ops,
+				V4L2_CID_RED_BALANCE, 0, 255, 1, 122);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	sd->ctrl_handler = &state->hdl;
+	err = state->hdl.error;
+	if (err) {
+		v4l2_ctrl_handler_free(&state->hdl);
+		kfree(state);
+		return err;
+	}
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	return 0;
+}
+
+static int tw2804_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct tw2804 *state = to_state(sd);
+
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&state->hdl);
+	kfree(state);
+	return 0;
+}
+
+static const struct i2c_device_id tw2804_id[] = {
+	{ "tw2804", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tw2804_id);
+
+static struct i2c_driver tw2804_driver = {
+	.driver = {
+		.name	= "tw2804",
+	},
+	.probe		= tw2804_probe,
+	.remove		= tw2804_remove,
+	.id_table	= tw2804_id,
+};
+
+module_i2c_driver(tw2804_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("TW2804/TW2802 V4L2 i2c driver");
+MODULE_AUTHOR("Micronas USA Inc");
-- 
1.7.10.4


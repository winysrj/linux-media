Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2420 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab3CKLq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:57 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 12/42] tw9903: add new tw9903 video decoder.
Date: Mon, 11 Mar 2013 12:45:50 +0100
Message-Id: <70b46354264bfe964430d87cbe6619749c71e96d.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This based on the wis-tw9903.c driver that's part of the go7007 driver.
It has been converted to a v4l subdev driver by Pete Eberlein, and I made
additional cleanups.

Based on work by: Pete Eberlein <pete@sensoray.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Pete Eberlein <pete@sensoray.com>
---
 drivers/media/i2c/Kconfig  |   10 ++
 drivers/media/i2c/Makefile |    1 +
 drivers/media/i2c/tw9903.c |  274 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 285 insertions(+)
 create mode 100644 drivers/media/i2c/tw9903.c

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 8000642..eb9ef55 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -301,6 +301,16 @@ config VIDEO_TVP7002
 	  To compile this driver as a module, choose M here: the
 	  module will be called tvp7002.
 
+config VIDEO_TW9903
+	tristate "Techwell TW9903 video decoder"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Techwell 9903 multi-standard video decoder
+	  with high quality down scaler.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called tw9903.
+
 config VIDEO_VPX3220
 	tristate "vpx3220a, vpx3216b & vpx3214c video decoders"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index b1775b3..af8fb29 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -37,6 +37,7 @@ obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
 obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
 obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
 obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
+obj-$(CONFIG_VIDEO_TW9903) += tw9903.o
 obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
 obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
 obj-$(CONFIG_VIDEO_M52790) += m52790.o
diff --git a/drivers/media/i2c/tw9903.c b/drivers/media/i2c/tw9903.c
new file mode 100644
index 0000000..82626ea
--- /dev/null
+++ b/drivers/media/i2c/tw9903.c
@@ -0,0 +1,274 @@
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
+#include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <linux/slab.h>
+
+MODULE_DESCRIPTION("TW9903 I2C subdev driver");
+MODULE_LICENSE("GPL v2");
+
+/*
+ * This driver is based on the wis-tw9903.c source that was in
+ * drivers/staging/media/go7007. That source had commented out code for
+ * saturation and scaling (neither seemed to work). If anyone ever gets
+ * hardware to test this driver, then that code might be useful to look at.
+ * You need to get the kernel sources of, say, kernel 3.8 where that
+ * wis-tw9903 driver is still present.
+ */
+
+struct tw9903 {
+	struct v4l2_subdev sd;
+	struct v4l2_ctrl_handler hdl;
+	v4l2_std_id norm;
+};
+
+static inline struct tw9903 *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct tw9903, sd);
+}
+
+static const u8 initial_registers[] = {
+	0x02, 0x44, /* input 1, composite */
+	0x03, 0x92, /* correct digital format */
+	0x04, 0x00,
+	0x05, 0x80, /* or 0x00 for PAL */
+	0x06, 0x40, /* second internal current reference */
+	0x07, 0x02, /* window */
+	0x08, 0x14, /* window */
+	0x09, 0xf0, /* window */
+	0x0a, 0x81, /* window */
+	0x0b, 0xd0, /* window */
+	0x0c, 0x8c,
+	0x0d, 0x00, /* scaling */
+	0x0e, 0x11, /* scaling */
+	0x0f, 0x00, /* scaling */
+	0x10, 0x00, /* brightness */
+	0x11, 0x60, /* contrast */
+	0x12, 0x01, /* sharpness */
+	0x13, 0x7f, /* U gain */
+	0x14, 0x5a, /* V gain */
+	0x15, 0x00, /* hue */
+	0x16, 0xc3, /* sharpness */
+	0x18, 0x00,
+	0x19, 0x58, /* vbi */
+	0x1a, 0x80,
+	0x1c, 0x0f, /* video norm */
+	0x1d, 0x7f, /* video norm */
+	0x20, 0xa0, /* clamping gain (working 0x50) */
+	0x21, 0x22,
+	0x22, 0xf0,
+	0x23, 0xfe,
+	0x24, 0x3c,
+	0x25, 0x38,
+	0x26, 0x44,
+	0x27, 0x20,
+	0x28, 0x00,
+	0x29, 0x15,
+	0x2a, 0xa0,
+	0x2b, 0x44,
+	0x2c, 0x37,
+	0x2d, 0x00,
+	0x2e, 0xa5, /* burst PLL control (working: a9) */
+	0x2f, 0xe0, /* 0xea is blue test frame -- 0xe0 for normal */
+	0x31, 0x00,
+	0x33, 0x22,
+	0x34, 0x11,
+	0x35, 0x35,
+	0x3b, 0x05,
+	0x06, 0xc0, /* reset device */
+	0x00, 0x00, /* Terminator (reg 0x00 is read-only) */
+};
+
+static int write_reg(struct v4l2_subdev *sd, u8 reg, u8 value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static int write_regs(struct v4l2_subdev *sd, const u8 *regs)
+{
+	int i;
+
+	for (i = 0; regs[i] != 0x00; i += 2)
+		if (write_reg(sd, regs[i], regs[i + 1]) < 0)
+			return -1;
+	return 0;
+}
+
+static int tw9903_s_video_routing(struct v4l2_subdev *sd, u32 input,
+				      u32 output, u32 config)
+{
+	write_reg(sd, 0x02, 0x40 | (input << 1));
+	return 0;
+}
+
+static int tw9903_s_std(struct v4l2_subdev *sd, v4l2_std_id norm)
+{
+	struct tw9903 *dec = to_state(sd);
+	bool is_60hz = norm & V4L2_STD_525_60;
+	u8 regs[] = {
+		0x05, is_60hz ? 0x80 : 0x00,
+		0x07, is_60hz ? 0x02 : 0x12,
+		0x08, is_60hz ? 0x14 : 0x18,
+		0x09, is_60hz ? 0xf0 : 0x20,
+		0,    0,
+	};
+
+	write_regs(sd, regs);
+	dec->norm = norm;
+	return 0;
+}
+
+
+static int tw9903_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct tw9903 *dec = container_of(ctrl->handler, struct tw9903, hdl);
+	struct v4l2_subdev *sd = &dec->sd;
+
+	switch (ctrl->id) {
+	case V4L2_CID_BRIGHTNESS:
+		write_reg(sd, 0x10, ctrl->val);
+		break;
+	case V4L2_CID_CONTRAST:
+		write_reg(sd, 0x11, ctrl->val);
+		break;
+	case V4L2_CID_HUE:
+		write_reg(sd, 0x15, ctrl->val);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int tw9903_log_status(struct v4l2_subdev *sd)
+{
+	struct tw9903 *dec = to_state(sd);
+
+	v4l2_info(sd, "Standard: %s\n", dec->norm == V4L2_STD_NTSC ? "NTSC" :
+					dec->norm == V4L2_STD_PAL ? "PAL" :
+					dec->norm == V4L2_STD_SECAM ? "SECAM" :
+					"unknown");
+	v4l2_ctrl_subdev_log_status(sd);
+	return 0;
+}
+
+/* --------------------------------------------------------------------------*/
+
+static const struct v4l2_ctrl_ops tw9903_ctrl_ops = {
+	.s_ctrl = tw9903_s_ctrl,
+};
+
+static const struct v4l2_subdev_core_ops tw9903_core_ops = {
+	.log_status = tw9903_log_status,
+	.s_std = tw9903_s_std,
+};
+
+static const struct v4l2_subdev_video_ops tw9903_video_ops = {
+	.s_routing = tw9903_s_video_routing,
+};
+
+static const struct v4l2_subdev_ops tw9903_ops = {
+	.core = &tw9903_core_ops,
+	.video = &tw9903_video_ops,
+};
+
+/* --------------------------------------------------------------------------*/
+
+static int tw9903_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
+{
+	struct tw9903 *dec;
+	struct v4l2_subdev *sd;
+	struct v4l2_ctrl_handler *hdl;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	dec = kzalloc(sizeof(struct tw9903), GFP_KERNEL);
+	if (dec == NULL)
+		return -ENOMEM;
+	sd = &dec->sd;
+	v4l2_i2c_subdev_init(sd, client, &tw9903_ops);
+	hdl = &dec->hdl;
+	v4l2_ctrl_handler_init(hdl, 4);
+	v4l2_ctrl_new_std(hdl, &tw9903_ctrl_ops,
+		V4L2_CID_BRIGHTNESS, -128, 127, 1, 0);
+	v4l2_ctrl_new_std(hdl, &tw9903_ctrl_ops,
+		V4L2_CID_CONTRAST, 0, 255, 1, 0x60);
+	v4l2_ctrl_new_std(hdl, &tw9903_ctrl_ops,
+		V4L2_CID_HUE, -128, 127, 1, 0);
+	sd->ctrl_handler = hdl;
+	if (hdl->error) {
+		int err = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		kfree(dec);
+		return err;
+	}
+
+	/* Initialize tw9903 */
+	dec->norm = V4L2_STD_NTSC;
+
+	if (write_regs(sd, initial_registers) < 0) {
+		v4l2_err(client, "error initializing TW9903\n");
+		kfree(dec);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int tw9903_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	v4l2_ctrl_handler_free(&to_state(sd)->hdl);
+	kfree(to_state(sd));
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
+static const struct i2c_device_id tw9903_id[] = {
+	{ "tw9903", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, tw9903_id);
+
+static struct i2c_driver tw9903_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "tw9903",
+	},
+	.probe = tw9903_probe,
+	.remove = tw9903_remove,
+	.id_table = tw9903_id,
+};
+module_i2c_driver(tw9903_driver);
-- 
1.7.10.4


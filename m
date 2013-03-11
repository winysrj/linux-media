Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3540 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106Ab3CKLqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 11/42] uda1342: add new uda1342 audio codec driver
Date: Mon, 11 Mar 2013 12:45:49 +0100
Message-Id: <44786c98f1e77f63e93ec5bf71ea392b73968cd2.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This based on the wis-uda1342.c driver that's part of the go7007 driver.
It has been converted to a v4l subdev driver by Pete Eberlein, and I made
additional cleanups.

Based on work by: Pete Eberlein <pete@sensoray.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Pete Eberlein <pete@sensoray.com>
---
 drivers/media/i2c/Kconfig   |    9 ++++
 drivers/media/i2c/Makefile  |    1 +
 drivers/media/i2c/uda1342.c |  113 +++++++++++++++++++++++++++++++++++++++++++
 include/media/uda1342.h     |   29 +++++++++++
 4 files changed, 152 insertions(+)
 create mode 100644 drivers/media/i2c/uda1342.c
 create mode 100644 include/media/uda1342.h

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index fe5f9d0..8000642 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -112,6 +112,15 @@ config VIDEO_TLV320AIC23B
 	  To compile this driver as a module, choose M here: the
 	  module will be called tlv320aic23b.
 
+config VIDEO_UDA1342
+	tristate "Philips UDA1342 audio codec"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Philips UDA1342 audio codec.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called uda1342.
+
 config VIDEO_WM8775
 	tristate "Wolfson Microelectronics WM8775 audio ADC with input mixer"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index adf9504..b1775b3 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
 obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
 obj-$(CONFIG_VIDEO_M52790) += m52790.o
 obj-$(CONFIG_VIDEO_TLV320AIC23B) += tlv320aic23b.o
+obj-$(CONFIG_VIDEO_UDA1342) += uda1342.o
 obj-$(CONFIG_VIDEO_WM8775) += wm8775.o
 obj-$(CONFIG_VIDEO_WM8739) += wm8739.o
 obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
diff --git a/drivers/media/i2c/uda1342.c b/drivers/media/i2c/uda1342.c
new file mode 100644
index 0000000..3af4085
--- /dev/null
+++ b/drivers/media/i2c/uda1342.c
@@ -0,0 +1,113 @@
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
+#include <media/v4l2-device.h>
+#include <media/uda1342.h>
+#include <linux/slab.h>
+
+static int write_reg(struct i2c_client *client, int reg, int value)
+{
+	/* UDA1342 wants MSB first, but SMBus sends LSB first */
+	i2c_smbus_write_word_data(client, reg, swab16(value));
+	return 0;
+}
+
+static int uda1342_s_routing(struct v4l2_subdev *sd,
+		u32 input, u32 output, u32 config)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	switch (input) {
+	case UDA1342_IN1:
+		write_reg(client, 0x00, 0x1241); /* select input 1 */
+		break;
+	case UDA1342_IN2:
+		write_reg(client, 0x00, 0x1441); /* select input 2 */
+		break;
+	default:
+		v4l2_err(sd, "input %d not supported\n", input);
+		break;
+	}
+	return 0;
+}
+
+static const struct v4l2_subdev_audio_ops uda1342_audio_ops = {
+	.s_routing = uda1342_s_routing,
+};
+
+static const struct v4l2_subdev_ops uda1342_ops = {
+	.audio = &uda1342_audio_ops,
+};
+
+static int uda1342_probe(struct i2c_client *client,
+			     const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	struct v4l2_subdev *sd;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
+		return -ENODEV;
+
+	dev_dbg(&client->dev, "initializing UDA1342 at address %d on %s\n",
+		client->addr, adapter->name);
+
+	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	if (sd == NULL)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(sd, client, &uda1342_ops);
+
+	write_reg(client, 0x00, 0x8000); /* reset registers */
+	write_reg(client, 0x00, 0x1241); /* select input 1 */
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	return 0;
+}
+
+static int uda1342_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(sd);
+	return 0;
+}
+
+static const struct i2c_device_id uda1342_id[] = {
+	{ "uda1342", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, uda1342_id);
+
+static struct i2c_driver uda1342_driver = {
+	.driver = {
+		.name	= "uda1342",
+	},
+	.probe		= uda1342_probe,
+	.remove		= uda1342_remove,
+	.id_table	= uda1342_id,
+};
+
+module_i2c_driver(uda1342_driver);
+
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/uda1342.h b/include/media/uda1342.h
new file mode 100644
index 0000000..cd15640
--- /dev/null
+++ b/include/media/uda1342.h
@@ -0,0 +1,29 @@
+/*
+ * uda1342.h - definition for uda1342 inputs
+ *
+ * Copyright 2013 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
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
+#ifndef _UDA1342_H_
+#define _UDA1342_H_
+
+/* The UDA1342 has 2 inputs */
+
+#define UDA1342_IN1 1
+#define UDA1342_IN2 2
+
+#endif
-- 
1.7.10.4


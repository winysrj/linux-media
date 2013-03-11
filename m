Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3939 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3CKLqx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:46:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 10/42] ov7640: add new ov7640 driver
Date: Mon, 11 Mar 2013 12:45:48 +0100
Message-Id: <5ec2b16d9ce2278aa00c794e65140e83796b4405.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This based on the wis-ov7640.c driver that's part of the go7007 driver.
It has been converted to a v4l subdev driver by Pete Eberlein, and I made
additional cleanups.

Based on work by: Pete Eberlein <pete@sensoray.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Pete Eberlein <pete@sensoray.com>
---
 drivers/media/i2c/Kconfig  |   11 +++++
 drivers/media/i2c/Makefile |    3 +-
 drivers/media/i2c/ov7640.c |  106 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 119 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/i2c/ov7640.c

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 70dbae2..fe5f9d0 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -395,6 +395,17 @@ config VIDEO_APTINA_PLL
 config VIDEO_SMIAPP_PLL
 	tristate
 
+config VIDEO_OV7640
+	tristate "OmniVision OV7640 sensor support"
+	depends on I2C && VIDEO_V4L2
+	depends on MEDIA_CAMERA_SUPPORT
+	---help---
+	  This is a Video4Linux2 sensor-level driver for the OmniVision
+	  OV7640 camera.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ov7640.
+
 config VIDEO_OV7670
 	tristate "OmniVision OV7670 sensor support"
 	depends on I2C && VIDEO_V4L2
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 4c57075..adf9504 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -47,7 +47,8 @@ obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
 obj-$(CONFIG_VIDEO_SONY_BTF_MPX) += sony-btf-mpx.o
 obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
 obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
-obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
+obj-$(CONFIG_VIDEO_OV7640) += ov7640.o
+obj-$(CONFIG_VIDEO_OV7670) += ov7670.o
 obj-$(CONFIG_VIDEO_OV9650) += ov9650.o
 obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 obj-$(CONFIG_VIDEO_MT9M032) += mt9m032.o
diff --git a/drivers/media/i2c/ov7640.c b/drivers/media/i2c/ov7640.c
new file mode 100644
index 0000000..b0cc927
--- /dev/null
+++ b/drivers/media/i2c/ov7640.c
@@ -0,0 +1,106 @@
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
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <linux/slab.h>
+
+MODULE_DESCRIPTION("OmniVision ov7640 sensor driver");
+MODULE_LICENSE("GPL v2");
+
+static const u8 initial_registers[] = {
+	0x12, 0x80,
+	0x12, 0x54,
+	0x14, 0x24,
+	0x15, 0x01,
+	0x28, 0x20,
+	0x75, 0x82,
+	0xFF, 0xFF, /* Terminator (reg 0xFF is unused) */
+};
+
+static int write_regs(struct i2c_client *client, const u8 *regs)
+{
+	int i;
+
+	for (i = 0; regs[i] != 0xFF; i += 2)
+		if (i2c_smbus_write_byte_data(client, regs[i], regs[i + 1]) < 0)
+			return -1;
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
+static const struct v4l2_subdev_ops ov7640_ops;
+
+static int ov7640_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	struct v4l2_subdev *sd;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	if (sd == NULL)
+		return -ENOMEM;
+	v4l2_i2c_subdev_init(sd, client, &ov7640_ops);
+
+	client->flags = I2C_CLIENT_SCCB;
+
+	v4l_info(client, "chip found @ 0x%02x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	if (write_regs(client, initial_registers) < 0) {
+		v4l_err(client, "error initializing OV7640\n");
+		kfree(sd);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+
+static int ov7640_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(sd);
+	return 0;
+}
+
+static const struct i2c_device_id ov7640_id[] = {
+	{ "ov7640", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, ov7640_id);
+
+static struct i2c_driver ov7640_driver = {
+	.driver = {
+		.owner	= THIS_MODULE,
+		.name	= "ov7640",
+	},
+	.probe = ov7640_probe,
+	.remove = ov7640_remove,
+	.id_table = ov7640_id,
+};
+module_i2c_driver(ov7640_driver);
-- 
1.7.10.4


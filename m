Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53577 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868AbbK3U1o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:44 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 09/11] cs3308: add new 8-channel volume control driver
Date: Mon, 30 Nov 2015 21:27:19 +0100
Message-Id: <1448915241-415-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Add simple support for this 8 channel volume control driver.
Currently all it does is to unmute all 8 channels.

Based upon Devin's initial patch made for an older kernel which I
cleaned up and rebased. Thanks to Kernel Labs for that work.

Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 MAINTAINERS                |   9 +++
 drivers/media/i2c/Kconfig  |  10 ++++
 drivers/media/i2c/Makefile |   1 +
 drivers/media/i2c/cs3308.c | 138 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 158 insertions(+)
 create mode 100644 drivers/media/i2c/cs3308.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d6bba28..9571ad9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3094,6 +3094,15 @@ S:	Maintained
 F:	crypto/ansi_cprng.c
 F:	crypto/rng.c
 
+CS3308 MEDIA DRIVER
+M:	Hans Verkuil <hverkuil@xs4all.nl>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+W:	http://linuxtv.org
+S:	Odd Fixes
+F:	drivers/media/i2c/cs3308.c
+F:	drivers/media/i2c/cs3308.h
+
 CS5535 Audio ALSA driver
 M:	Jaya Kumar <jayakumar.alsa@gmail.com>
 S:	Maintained
diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 521bbf1..993dc50 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -83,6 +83,16 @@ config VIDEO_MSP3400
 	  To compile this driver as a module, choose M here: the
 	  module will be called msp3400.
 
+config VIDEO_CS3308
+	tristate "Cirrus Logic CS3308 audio ADC"
+	depends on VIDEO_V4L2 && I2C
+	---help---
+	  Support for the Cirrus Logic CS3308 High Performance 8-Channel
+	  Analog Volume Control
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called cs3308.
+
 config VIDEO_CS5345
 	tristate "Cirrus Logic CS5345 audio ADC"
 	depends on VIDEO_V4L2 && I2C
diff --git a/drivers/media/i2c/Makefile b/drivers/media/i2c/Makefile
index 07db257..94f2c99 100644
--- a/drivers/media/i2c/Makefile
+++ b/drivers/media/i2c/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_VIDEO_TVP7002) += tvp7002.o
 obj-$(CONFIG_VIDEO_TW2804) += tw2804.o
 obj-$(CONFIG_VIDEO_TW9903) += tw9903.o
 obj-$(CONFIG_VIDEO_TW9906) += tw9906.o
+obj-$(CONFIG_VIDEO_CS3308) += cs3308.o
 obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
 obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
 obj-$(CONFIG_VIDEO_M52790) += m52790.o
diff --git a/drivers/media/i2c/cs3308.c b/drivers/media/i2c/cs3308.c
new file mode 100644
index 0000000..d28b4f3
--- /dev/null
+++ b/drivers/media/i2c/cs3308.c
@@ -0,0 +1,138 @@
+/*
+ * Cirrus Logic cs3308 8-Channel Analog Volume Control
+ *
+ * Copyright (C) 2010 Devin Heitmueller <dheitmueller@kernellabs.com>
+ * Copyright (C) 2012 Steven Toth <stoth@kernellabs.com>
+ *
+ * Derived from cs5345.c Copyright (C) 2007 Hans Verkuil
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/i2c.h>
+#include <linux/slab.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+
+MODULE_DESCRIPTION("i2c device driver for cs3308 8-channel volume control");
+MODULE_AUTHOR("Devin Heitmueller");
+MODULE_LICENSE("GPL");
+
+static inline int cs3308_write(struct v4l2_subdev *sd, u8 reg, u8 value)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+
+static inline int cs3308_read(struct v4l2_subdev *sd, u8 reg)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	return i2c_smbus_read_byte_data(client, reg);
+}
+
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+static int cs3308_g_register(struct v4l2_subdev *sd, struct v4l2_dbg_register *reg)
+{
+	reg->val = cs3308_read(sd, reg->reg & 0xffff);
+	reg->size = 1;
+	return 0;
+}
+
+static int cs3308_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_register *reg)
+{
+	cs3308_write(sd, reg->reg & 0xffff, reg->val & 0xff);
+	return 0;
+}
+#endif
+
+/* ----------------------------------------------------------------------- */
+
+static const struct v4l2_subdev_core_ops cs3308_core_ops = {
+#ifdef CONFIG_VIDEO_ADV_DEBUG
+	.g_register = cs3308_g_register,
+	.s_register = cs3308_s_register,
+#endif
+};
+
+static const struct v4l2_subdev_ops cs3308_ops = {
+	.core = &cs3308_core_ops,
+};
+
+/* ----------------------------------------------------------------------- */
+
+static int cs3308_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct v4l2_subdev *sd;
+	unsigned i;
+
+	/* Check if the adapter supports the needed features */
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -EIO;
+
+	if ((i2c_smbus_read_byte_data(client, 0x1c) & 0xf0) != 0xe0)
+		return -ENODEV;
+
+	v4l_info(client, "chip found @ 0x%x (%s)\n",
+		 client->addr << 1, client->adapter->name);
+
+	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	if (sd == NULL)
+		return -ENOMEM;
+
+	v4l2_i2c_subdev_init(sd, client, &cs3308_ops);
+
+	/* Set some reasonable defaults */
+	cs3308_write(sd, 0x0d, 0x00); /* Power up all channels */
+	cs3308_write(sd, 0x0e, 0x00); /* Master Power */
+	cs3308_write(sd, 0x0b, 0x00); /* Device Configuration */
+	/* Set volume for each channel */
+	for (i = 1; i <= 8; i++)
+		cs3308_write(sd, i, 0xd2);
+	cs3308_write(sd, 0x0a, 0x00); /* Unmute all channels */
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
+static int cs3308_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(sd);
+	return 0;
+}
+
+/* ----------------------------------------------------------------------- */
+
+static const struct i2c_device_id cs3308_id[] = {
+	{ "cs3308", 0 },
+	{ }
+};
+MODULE_DEVICE_TABLE(i2c, cs3308_id);
+
+static struct i2c_driver cs3308_driver = {
+	.driver = {
+		.owner  = THIS_MODULE,
+		.name   = "cs3308",
+	},
+	.probe          = cs3308_probe,
+	.remove         = cs3308_remove,
+	.id_table       = cs3308_id,
+};
+
+module_i2c_driver(cs3308_driver);
-- 
2.6.2


Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35354 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbZCMKW3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Mar 2009 06:22:29 -0400
Received: from dbdp31.itg.ti.com ([172.24.170.98])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n2DAMLNa012519
	for <linux-media@vger.kernel.org>; Fri, 13 Mar 2009 05:22:27 -0500
From: chaithrika@ti.com
To: linux-media@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com,
	Chaithrika U S <chaithrika@ti.com>
Subject: [RFC 3/7] ARM: DaVinci: DM646x Video: THS7303 video amplifier driver
Date: Fri, 13 Mar 2009 14:31:06 +0530
Message-Id: <1236934866-32135-1-git-send-email-chaithrika@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Chaithrika U S <chaithrika@ti.com>

THS7303 video amplifier driver code

This patch implements driver for TI THS7303 video amplifier . This driver is
implemented as a v4l2-subdev.
---
Applies to v4l-dvb repository located at
http://linuxtv.org/hg/v4l-dvb/rev/1fd54a62abde

 drivers/media/video/Kconfig   |    9 ++
 drivers/media/video/Makefile  |    1 +
 drivers/media/video/ths7303.c |  179 +++++++++++++++++++++++++++++++++++++++++
 include/media/ths7303.h       |   26 ++++++
 4 files changed, 215 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/ths7303.c
 create mode 100644 include/media/ths7303.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 16019e9..b3b591d 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -435,6 +435,15 @@ config VIDEO_ADV7343
           To compile this driver as a module, choose M here: the
           module will be called adv7473.
 
+config VIDEO_THS7303
+	tristate "THS7303 Video Amplifier"
+	depends on I2C
+	help
+	  Support for TI  THS7303 video amplifier
+
+	  To compile this driver as a module, choose M here: the
+          module will be called ths7303.
+
 comment "Video improvement chips"
 
 config VIDEO_UPD64031A
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 7f9fc62..1ed9c2c 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -55,6 +55,7 @@ obj-$(CONFIG_VIDEO_BT819) += bt819.o
 obj-$(CONFIG_VIDEO_BT856) += bt856.o
 obj-$(CONFIG_VIDEO_BT866) += bt866.o
 obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
+obj-$(CONFIG_VIDEO_THS7303) += ths7303.o
 
 obj-$(CONFIG_VIDEO_ZORAN) += zoran/
 
diff --git a/drivers/media/video/ths7303.c b/drivers/media/video/ths7303.c
new file mode 100644
index 0000000..a78b450
--- /dev/null
+++ b/drivers/media/video/ths7303.c
@@ -0,0 +1,179 @@
+/*
+ * ths7303- THS7303 Video Amplifier driver
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/ctype.h>
+#include <linux/i2c.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-device.h>
+#include <media/v4l2-i2c-drv.h>
+#include <media/v4l2-subdev.h>
+#include <media/ths7303.h>
+
+static int debug;
+
+struct ths7303_state {
+	struct i2c_client	*client;
+	struct v4l2_subdev sd;
+};
+
+static inline struct ths7303_state *to_state(struct v4l2_subdev *sd)
+{
+	return container_of(sd, struct ths7303_state, sd);
+}
+
+/* following function is used to set ths7303 */
+static int ths7303_setvalue(struct v4l2_subdev *sd, v4l2_std_id std)
+{
+	int err = 0;
+	u8 val;
+	struct ths7303_state *state;
+	struct i2c_client *client;
+
+	state = to_state(sd);
+	client = state->client;
+
+	if (client == NULL) {
+		printk(KERN_ERR "THS7303 Client not found\n");
+		return -ENODEV;
+	}
+
+	if ((std == V4L2_STD_NTSC) || (std == V4L2_STD_PAL))
+		val = 0x02;
+	else if ((std == V4L2_STD_480P_60) || (std == V4L2_STD_576P_50))
+		val = 0x4A;
+	else
+		val = 0x92;
+
+	err |= i2c_smbus_write_byte_data(client, 0x01, val);
+	err |= i2c_smbus_write_byte_data(client, 0x02, val);
+	err |= i2c_smbus_write_byte_data(client, 0x03, val);
+
+	if (err)
+		printk(KERN_ERR "ths7303 write\n");
+
+	mdelay(100);
+
+	return err;
+}
+
+static long ths7303_ioctl(struct v4l2_subdev *sd, unsigned cmd, void *arg)
+{
+	int err = 0;
+	v4l2_dbg(1, debug, sd, "ioctl\n");
+	switch (cmd) {
+
+	case THS7303_SETVALUE:
+		err = ths7303_setvalue(sd, *(v4l2_std_id *) arg);
+		break;
+
+	default:
+		break;
+	}
+
+	return err;
+}
+
+static int ths7303_initialize(struct v4l2_subdev *sd, u32 val)
+{
+	v4l2_std_id id = V4L2_STD_NTSC;
+	return (int) ths7303_ioctl(sd, THS7303_SETVALUE, &id);
+}
+
+static const struct v4l2_subdev_core_ops ths7303_core_ops = {
+	.ioctl	= ths7303_ioctl,
+	.init	= ths7303_initialize,
+};
+
+static const struct v4l2_subdev_ops ths7303_ops = {
+	.core	= &ths7303_core_ops,
+};
+
+static int ths7303_command(struct i2c_client *client, unsigned cmd, void *arg)
+{
+	return v4l2_subdev_command(i2c_get_clientdata(client), cmd, arg);
+}
+
+static int ths7303_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	struct ths7303_state *state;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	v4l2_info(client, "chip found @ 0x%x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	state = kzalloc(sizeof(struct ths7303_state), GFP_KERNEL);
+	if (state == NULL)
+		return -ENOMEM;
+
+	state->client = client;
+	v4l2_i2c_subdev_init(&state->sd, client, &ths7303_ops);
+	v4l2_dbg(1, debug, client, "Registered video amplifier\n");
+
+	return 0;
+}
+
+static int ths7303_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+	kfree(to_state(sd));
+
+	return 0;
+}
+
+static const struct i2c_device_id ths7303_id[] = {
+	{THS7303_NAME, 0},
+	{},
+};
+
+MODULE_DEVICE_TABLE(i2c, ths7303_id);
+
+static struct v4l2_i2c_driver_data v4l2_i2c_data = {
+	.name		= THS7303_NAME,
+	.command	= ths7303_command,
+	.probe		= ths7303_probe,
+	.remove		= ths7303_remove,
+	.legacy_class	= I2C_CLASS_TV_ANALOG | I2C_CLASS_TV_DIGITAL,
+	.id_table	= ths7303_id,
+};
+
+static int __init ths7303_init(void)
+{
+	return 0;
+}
+
+static void __exit ths7303_exit(void)
+{
+
+}
+
+module_init(ths7303_init);
+module_exit(ths7303_exit);
+
+MODULE_DESCRIPTION("THS7303 video amplifier driver");
+MODULE_AUTHOR("Chaithrika U S");
+MODULE_LICENSE("GPL");
+
diff --git a/include/media/ths7303.h b/include/media/ths7303.h
new file mode 100644
index 0000000..5426941
--- /dev/null
+++ b/include/media/ths7303.h
@@ -0,0 +1,26 @@
+/*
+ * THS7303 header file
+ *
+ * Copyright (C) 2009 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed .as is. WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef THS7303_H
+#define THS7303_H
+
+#include <linux/videodev2.h>
+
+#define THS7303_NAME	"ths7303"
+
+#define THS7303_SETVALUE	_IOW('e', BASE_VIDIOC_PRIVATE + 1,\
+							v4l2_std_id *)
+
+#endif
-- 
1.5.6


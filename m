Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18152 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab0C1Hra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 03:47:30 -0400
From: "Zhang, Xiaolin" <xiaolin.zhang@intel.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "Zhu, Daniel" <daniel.zhu@intel.com>,
	"Yu, Jinlu" <jinlu.yu@intel.com>,
	"Wang, Wen W" <wen.w.wang@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"Hu, Gang A" <gang.a.hu@intel.com>,
	"Ba, Zheng" <zheng.ba@intel.com>,
	"Zhang, Xiaolin" <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 15:47:21 +0800
Subject: [PATCH v2 3/10] V4L2 patches for Intel Moorestown Camera Imaging
 Drivers
Message-ID: <33AB447FBD802F4E932063B962385B351D6D534D@shsmsx501.ccr.corp.intel.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 1fd72af8366c3cfb04520bbee7252a1991c878ba Mon Sep 17 00:00:00 2001
From: Xiaolin Zhang <xiaolin.zhang@intel.com>
Date: Sun, 28 Mar 2010 13:57:52 +0800
Subject: [PATCH 03/10] This patch is the flash subdev driver for intel moorestown camera imaging.

Signed-off-by: Xiaolin Zhang <xiaolin.zhang@intel.com>
---
 drivers/media/video/mrstci/mrstflash/Kconfig     |    9 ++
 drivers/media/video/mrstci/mrstflash/Makefile    |    3 +
 drivers/media/video/mrstci/mrstflash/mrstflash.c |  150 ++++++++++++++++++++++
 3 files changed, 162 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/mrstci/mrstflash/Kconfig
 create mode 100644 drivers/media/video/mrstci/mrstflash/Makefile
 create mode 100644 drivers/media/video/mrstci/mrstflash/mrstflash.c

diff --git a/drivers/media/video/mrstci/mrstflash/Kconfig b/drivers/media/video/mrstci/mrstflash/Kconfig
new file mode 100644
index 0000000..72099c5
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstflash/Kconfig
@@ -0,0 +1,9 @@
+config VIDEO_MRST_FLASH
+	tristate "Moorestown flash"
+	depends on I2C && VIDEO_MRST_ISP
+
+	---help---
+	  Say Y here if your platform support moorestown flash.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mrstov2650.ko.
diff --git a/drivers/media/video/mrstci/mrstflash/Makefile b/drivers/media/video/mrstci/mrstflash/Makefile
new file mode 100644
index 0000000..068f638
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstflash/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_VIDEO_MRST_FLASH)	 += mrstflash.o
+
+EXTRA_CFLAGS	+=	-I$(src)/../include
diff --git a/drivers/media/video/mrstci/mrstflash/mrstflash.c b/drivers/media/video/mrstci/mrstflash/mrstflash.c
new file mode 100644
index 0000000..89ceddc
--- /dev/null
+++ b/drivers/media/video/mrstci/mrstflash/mrstflash.c
@@ -0,0 +1,150 @@
+/*
+ * Support for Moorestown Langwell Camera Imaging camera flash.
+ *
+ * Copyright (c) 2009 Intel Corporation. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ *
+ *
+ * Xiaolin Zhang <xiaolin.zhang@intel.com>
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kmod.h>
+#include <linux/device.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/gpio.h>
+#include <linux/videodev2.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-chip-ident.h>
+#include <media/v4l2-i2c-drv.h>
+
+static int debug;
+module_param(debug, bool, 0644);
+MODULE_PARM_DESC(debug, "Debug level (0-1)");
+
+MODULE_AUTHOR("Xiaolin Zhang <xiaolin.zhang@intel.com>");
+MODULE_DESCRIPTION("A low-level driver for mrst flash");
+MODULE_LICENSE("GPL");
+
+static int flash_g_chip_ident(struct v4l2_subdev *sd,
+		struct v4l2_dbg_chip_ident *chip)
+{
+	struct i2c_client *client = v4l2_get_subdevdata(sd);
+
+	#define V4L2_IDENT_MRST_FLASH 8248
+	return v4l2_chip_ident_i2c_client(client, chip,
+					  V4L2_IDENT_MRST_FLASH, 0);
+}
+
+static const struct v4l2_subdev_core_ops flash_core_ops = {
+	.g_chip_ident = flash_g_chip_ident,
+};
+static const struct v4l2_subdev_ops flash_ops = {
+	.core = &flash_core_ops,
+};
+
+static int flash_detect(struct i2c_client *client)
+{
+	struct i2c_adapter *adapter = client->adapter;
+	u8 pid;
+
+	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_BYTE_DATA))
+		return -ENODEV;
+
+	if (adapter->nr != 0)
+		return -ENODEV;
+
+	pid = i2c_smbus_read_byte_data(client, 0x10);
+	if (pid == 0x18) {
+		printk(KERN_ERR "camera flash device found\n");
+		v4l_dbg(1, debug, client, "found camera flash device");
+	} else {
+		printk(KERN_ERR "no camera flash device found\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int flash_probe(struct i2c_client *client,
+			const struct i2c_device_id *id)
+{
+	u8 pid, ver;
+	int ret = -1;
+	struct v4l2_subdev *sd;
+
+	v4l_info(client, "chip found @ 0x%x (%s)\n",
+			client->addr << 1, client->adapter->name);
+
+	sd = kzalloc(sizeof(struct v4l2_subdev), GFP_KERNEL);
+	ret = flash_detect(client);
+	if (ret)
+		return -ENODEV;
+
+	v4l2_i2c_subdev_init(sd, client, &flash_ops);
+
+	ver = i2c_smbus_read_byte_data(client, 0x50);
+	v4l_dbg(1, debug, client, "detect:CST from device is 0x%x", ver);
+	pid = i2c_smbus_read_byte_data(client, 0x20);
+	v4l_dbg(1, debug, client, "detect:MFPC from device is 0x%x", pid);
+	pid = i2c_smbus_read_byte_data(client, 0xA0);
+	v4l_dbg(1, debug, client, "detect:TCC from device is 0x%x", pid);
+	pid = i2c_smbus_read_byte_data(client, 0xB0);
+	v4l_dbg(1, debug, client, "detect:FCC from device is 0x%x", pid);
+	pid = i2c_smbus_read_byte_data(client, 0xC0);
+	v4l_dbg(1, debug, client, "detect:FDC from device is 0x%x", pid);
+	i2c_smbus_write_byte_data(client, 0xc0, 0xff); /*set FST to 1000us*/
+	pid = i2c_smbus_read_byte_data(client, 0xc0);
+	v4l_dbg(1, debug, client, "FDC from device is 0x%x", pid);
+
+	v4l_dbg(1, debug, client,
+		"successfully load camera flash device driver");
+	return 0;
+}
+
+static int flash_remove(struct i2c_client *client)
+{
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+
+	v4l2_device_unregister_subdev(sd);
+
+	return 0;
+}
+
+static const struct i2c_device_id flash_id[] = {
+	{"mrst_camera_flash", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, flash_id);
+
+static struct v4l2_i2c_driver_data v4l2_i2c_data = {
+	.name = "mrst_camera_flash",
+	.probe = flash_probe,
+	.remove = flash_remove,
+	.id_table = flash_id,
+};
-- 
1.6.3.2


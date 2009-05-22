Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:25234 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZEVKuL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 May 2009 06:50:11 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [RFC] v4l2_subdev i2c: Add i2c board info to v4l2_i2c_new_subdev
Date: Fri, 22 May 2009 13:45:15 +0300
Message-Id: <1242989115-14948-1-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <20090522085827.GA1964@esdhcp037198.research.nokia.com>
References: <20090522085827.GA1964@esdhcp037198.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Eduardo Valentin <eduardo.valentin@nokia.com>

Device drivers of v4l2_subdev devices may want to have
i2c board info data. This patch adds an helper function
to allow bridge drivers to pass board specific data to
v4l2_subdev drivers.

For those drivers which need to support kernel versions
bellow 2.6.26, a .s_config callback was added. The
idea of this callback is to pass board configuration
as well. In that case, the bridge driver should call
the .s_config of subdevs manually.

Priority: normal

Signed-off-by: "Eduardo Valentin <eduardo.valentin@nokia.com>"

diff -r 315bc4b65b4f -r 778e5e5ecc68 linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Sun May 17 12:28:55 2009 +0000
+++ b/linux/drivers/media/video/v4l2-common.c	Fri May 22 12:59:44 2009 +0300
@@ -819,15 +819,16 @@
 
 
 /* Load an i2c sub-device. */
-struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter,
-		const char *module_name, const char *client_type, u8 addr)
+static struct v4l2_subdev *__v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter, const char *module_name,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+		struct i2c_board_info *info)
+#else
+		u8 addr)
+#endif
 {
 	struct v4l2_subdev *sd = NULL;
 	struct i2c_client *client;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
-	struct i2c_board_info info;
-#endif
 
 	BUG_ON(!v4l2_dev);
 
@@ -835,14 +836,8 @@
 		request_module(module_name);
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
-	/* Setup the i2c board info with the device type and
-	   the device address. */
-	memset(&info, 0, sizeof(info));
-	strlcpy(info.type, client_type, sizeof(info.type));
-	info.addr = addr;
-
 	/* Create the i2c client */
-	client = i2c_new_device(adapter, &info);
+	client = i2c_new_device(adapter, info);
 #else
 	/* Legacy code: loading the module automatically
 	   probes and creates the i2c_client on the adapter.
@@ -877,8 +872,39 @@
 #endif
 	return sd;
 }
+
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type, u8 addr)
+{
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+	struct i2c_board_info info;
+
+	/* Setup the i2c board info with the device type and
+	   the device address. */
+	memset(&info, 0, sizeof(info));
+	strlcpy(info.type, client_type, sizeof(info.type));
+	info.addr = addr;
+
+	return __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name,
+					&info);
+#else
+	return __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name,
+					addr);
+#endif
+}
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+struct v4l2_subdev *v4l2_i2c_new_subdev_board_info(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter, const char *module_name,
+		struct i2c_board_info *i)
+{
+	return __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name, i);
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board_info);
+#endif
+
 /* Probe and load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_probed_subdev(struct v4l2_device *v4l2_dev,
 	struct i2c_adapter *adapter,
diff -r 315bc4b65b4f -r 778e5e5ecc68 linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Sun May 17 12:28:55 2009 +0000
+++ b/linux/include/media/v4l2-common.h	Fri May 22 12:59:44 2009 +0300
@@ -130,6 +130,7 @@
 struct i2c_driver;
 struct i2c_adapter;
 struct i2c_client;
+struct i2c_board_info;
 struct i2c_device_id;
 struct v4l2_device;
 struct v4l2_subdev;
@@ -147,6 +148,13 @@
 struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter,
 		const char *module_name, const char *client_type, u8 addr);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+/* Same as v4l2_i2c_new_subdev, but with opportunity to pass i2c_board_info
+   to client device */
+struct v4l2_subdev *v4l2_i2c_new_subdev_board_info(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter, const char *module_name,
+		struct i2c_board_info *i);
+#endif
 /* Probe and load an i2c module and return an initialized v4l2_subdev struct.
    Only call request_module if module_name != NULL.
    The client_type argument is the name of the chip that's on the adapter. */
diff -r 315bc4b65b4f -r 778e5e5ecc68 linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Sun May 17 12:28:55 2009 +0000
+++ b/linux/include/media/v4l2-subdev.h	Fri May 22 12:59:44 2009 +0300
@@ -96,6 +96,7 @@
 struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
+	int (*s_config)(struct v4l2_subdev *sd, void *config_data);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
 	int (*load_fw)(struct v4l2_subdev *sd);
 	int (*reset)(struct v4l2_subdev *sd, u32 val);

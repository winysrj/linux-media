Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:29915 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZEYKmo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 May 2009 06:42:44 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Darius Augulis <augulis.darius@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCH 1/1] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board i2c helper function
Date: Mon, 25 May 2009 13:37:08 +0300
Message-Id: <1243247828-20622-1-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <20090525101828.GA31070@esdhcp037198.research.nokia.com>
References: <20090525101828.GA31070@esdhcp037198.research.nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Device drivers of v4l2_subdev devices may want to have
board specific data. This patch adds an helper function
to allow bridge drivers to pass board specific data to
v4l2_subdev drivers.

For those drivers which need to support kernel versions
bellow 2.6.26, a .s_config callback was added. The
idea of this callback is to pass board configuration
as well. In that case, subdev driver should set .s_config
properly, because v4l2_i2c_new_subdev_board will call
the .s_config directly. Of course, if we are >= 2.6.26,
the same data will be passed through i2c board info as well.

Priority: normal

Signed-off-by: "Eduardo Valentin <eduardo.valentin@nokia.com>"

diff -r 41d2c77ae71f -r 905a6501f2a4 linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Sun May 24 00:46:01 2009 -0300
+++ b/linux/drivers/media/video/v4l2-common.c	Mon May 25 13:32:13 2009 +0300
@@ -819,9 +819,10 @@
 
 
 /* Load an i2c sub-device. */
-struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
+static struct v4l2_subdev *__v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter,
-		const char *module_name, const char *client_type, u8 addr)
+		const char *module_name, const char *client_type, u8 addr,
+		int irq, void *platform_data)
 {
 	struct v4l2_subdev *sd = NULL;
 	struct i2c_client *client;
@@ -840,6 +841,8 @@
 	memset(&info, 0, sizeof(info));
 	strlcpy(info.type, client_type, sizeof(info.type));
 	info.addr = addr;
+	info.irq = irq;
+	info.platform_data = platform_data;
 
 	/* Create the i2c client */
 	client = i2c_new_device(adapter, &info);
@@ -877,8 +880,38 @@
 #endif
 	return sd;
 }
+
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type, u8 addr)
+{
+	return __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name,
+		client_type, addr, 0, NULL);
+}
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
 
+struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type, u8 addr,
+		int irq, void *platform_data)
+{
+	struct v4l2_subdev *sd;
+	int err = 0;
+
+	sd = __v4l2_i2c_new_subdev(v4l2_dev, adapter, module_name, client_type,
+					addr, irq, platform_data);
+
+	/*
+	 * We return errors from v4l2_subdev_call only if we have the callback
+	 * as the .s_config is not mandatory
+	 */
+	if (sd && sd->ops && sd->ops->core && sd->ops->core->s_config)
+		err = sd->ops->core->s_config(sd, irq, platform_data);
+
+	return err < 0 ? NULL : sd;
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board);
+
 /* Probe and load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_probed_subdev(struct v4l2_device *v4l2_dev,
 	struct i2c_adapter *adapter,
diff -r 41d2c77ae71f -r 905a6501f2a4 linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Sun May 24 00:46:01 2009 -0300
+++ b/linux/include/media/v4l2-common.h	Mon May 25 13:32:13 2009 +0300
@@ -147,6 +147,14 @@
 struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter,
 		const char *module_name, const char *client_type, u8 addr);
+/*
+ * Same as v4l2_i2c_new_subdev, but with the opportunity to configure
+ * subdevice with board specific data (irq and platform_data).
+ */
+struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type, u8 addr,
+		int irq, void *platform_data);
 /* Probe and load an i2c module and return an initialized v4l2_subdev struct.
    Only call request_module if module_name != NULL.
    The client_type argument is the name of the chip that's on the adapter. */
diff -r 41d2c77ae71f -r 905a6501f2a4 linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Sun May 24 00:46:01 2009 -0300
+++ b/linux/include/media/v4l2-subdev.h	Mon May 25 13:32:13 2009 +0300
@@ -96,6 +96,7 @@
 struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
+	int (*s_config)(struct v4l2_subdev *sd, int irq, void *platform_data);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
 	int (*load_fw)(struct v4l2_subdev *sd);
 	int (*reset)(struct v4l2_subdev *sd, u32 val);

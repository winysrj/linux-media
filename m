Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:18608 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbZE2HiA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 03:38:00 -0400
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: "\\\"ext Hans Verkuil\\\"" <hverkuil@xs4all.nl>,
	"\\\"ext Mauro Carvalho Chehab\\\"" <mchehab@infradead.org>
Cc: "\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: [PATCHv5 1 of 8] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board i2c helper function
Date: Fri, 29 May 2009 10:33:21 +0300
Message-Id: <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
In-Reply-To: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Eduardo Valentin <eduardo.valentin@nokia.com>
# Date 1243414605 -10800
# Branch export
# Node ID 4fb354645426f8b187c2c90cd8528b2518461005
# Parent  142fd6020df3b4d543068155e49a2618140efa49
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

Signed-off-by: Eduardo Valentin <eduardo.valentin@nokia.com>
---
 drivers/media/video/v4l2-common.c |   37 +++++++++++++++++++++++++++++++++++--
 include/linux/v4l2-common.h       |    8 ++++++++
 include/linux/v4l2-subdev.h       |    1 +
 3 files changed, 44 insertions(+), 2 deletions(-)

diff -r 142fd6020df3 -r 4fb354645426 linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Mon May 18 02:31:55 2009 +0000
+++ b/linux/drivers/media/video/v4l2-common.c	Wed May 27 11:56:45 2009 +0300
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
diff -r 142fd6020df3 -r 4fb354645426 linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Mon May 18 02:31:55 2009 +0000
+++ b/linux/include/media/v4l2-common.h	Wed May 27 11:56:45 2009 +0300
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
diff -r 142fd6020df3 -r 4fb354645426 linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Mon May 18 02:31:55 2009 +0000
+++ b/linux/include/media/v4l2-subdev.h	Wed May 27 11:56:45 2009 +0300
@@ -96,6 +96,7 @@
 struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
+	int (*s_config)(struct v4l2_subdev *sd, int irq, void *platform_data);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
 	int (*load_fw)(struct v4l2_subdev *sd);
 	int (*reset)(struct v4l2_subdev *sd, u32 val);

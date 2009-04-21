Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:50696 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753852AbZDUI5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 04:57:12 -0400
Date: Tue, 21 Apr 2009 10:57:16 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l2-subdev: add a v4l2_i2c_new_dev_subdev() function
Message-ID: <Pine.LNX.4.64.0904211051280.6551@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Video (sub)devices, connecting to SoCs over generic i2c busses cannot 
provide a pointer to struct v4l2_device in i2c-adapter driver_data, and 
provide their own i2c_board_info data, including a platform_data field. 
Add a v4l2_i2c_new_dev_subdev() API function that does exactly the same as 
v4l2_i2c_new_subdev() but uses different parameters, and make 
v4l2_i2c_new_subdev() a wrapper around it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 1da8cb8..c55fc99 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -783,8 +783,6 @@ void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
 
-
-
 /* Load an i2c sub-device. It assumes that i2c_get_adapdata(adapter)
    returns the v4l2_device and that i2c_get_clientdata(client)
    returns the v4l2_subdev. */
@@ -792,23 +790,34 @@ struct v4l2_subdev *v4l2_i2c_new_subdev(struct i2c_adapter *adapter,
 		const char *module_name, const char *client_type, u8 addr)
 {
 	struct v4l2_device *dev = i2c_get_adapdata(adapter);
-	struct v4l2_subdev *sd = NULL;
-	struct i2c_client *client;
 	struct i2c_board_info info;
 
-	BUG_ON(!dev);
-
-	if (module_name)
-		request_module(module_name);
-
 	/* Setup the i2c board info with the device type and
 	   the device address. */
 	memset(&info, 0, sizeof(info));
 	strlcpy(info.type, client_type, sizeof(info.type));
 	info.addr = addr;
 
+	return v4l2_i2c_new_dev_subdev(adapter, module_name, &info, dev);
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
+
+/* Load an i2c sub-device. It assumes that i2c_get_clientdata(client)
+   returns the v4l2_subdev. */
+struct v4l2_subdev *v4l2_i2c_new_dev_subdev(struct i2c_adapter *adapter,
+		const char *module_name, const struct i2c_board_info *info,
+		struct v4l2_device *dev)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct i2c_client *client;
+
+	BUG_ON(!dev);
+
+	if (module_name)
+		request_module(module_name);
+
 	/* Create the i2c client */
-	client = i2c_new_device(adapter, &info);
+	client = i2c_new_device(adapter, info);
 	/* Note: it is possible in the future that
 	   c->driver is NULL if the driver is still being loaded.
 	   We need better support from the kernel so that we
@@ -835,7 +844,7 @@ error:
 		i2c_unregister_device(client);
 	return sd;
 }
-EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_dev_subdev);
 
 /* Probe and load an i2c sub-device. It assumes that i2c_get_adapdata(adapter)
    returns the v4l2_device and that i2c_get_clientdata(client)
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 3a69056..0722b00 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -131,6 +131,7 @@ struct i2c_driver;
 struct i2c_adapter;
 struct i2c_client;
 struct i2c_device_id;
+struct i2c_board_info;
 struct v4l2_device;
 struct v4l2_subdev;
 struct v4l2_subdev_ops;
@@ -144,6 +145,10 @@ int v4l2_i2c_attach(struct i2c_adapter *adapter, int address, struct i2c_driver
    The client_type argument is the name of the chip that's on the adapter. */
 struct v4l2_subdev *v4l2_i2c_new_subdev(struct i2c_adapter *adapter,
 		const char *module_name, const char *client_type, u8 addr);
+/* Same as above but uses user-provided v4l2_device and i2c_board_info */
+struct v4l2_subdev *v4l2_i2c_new_dev_subdev(struct i2c_adapter *adapter,
+		const char *module_name, const struct i2c_board_info *info,
+		struct v4l2_device *dev);
 /* Probe and load an i2c module and return an initialized v4l2_subdev struct.
    Only call request_module if module_name != NULL.
    The client_type argument is the name of the chip that's on the adapter. */

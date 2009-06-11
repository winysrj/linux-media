Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4160 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756740AbZFKGJX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 02:09:23 -0400
Received: from tschai.lan (cm-84.208.85.194.getinternet.no [84.208.85.194])
	(authenticated bits=0)
	by smtp-vbr11.xs4all.nl (8.13.8/8.13.8) with ESMTP id n5B69N5I042410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Thu, 11 Jun 2009 08:09:24 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: PATCH: add new s_config subdev ops and v4l2_i2c_new_subdev_cfg/board calls
Date: Thu, 11 Jun 2009 08:09:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906110809.23148.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As per Mauro's request here is the patch adding the new core functionality.

To quote from my original pull request:

"This time I've only added new functions and left the existing ones in place.
I did add a bit of code to the existing v4l2_i2c_new_(probed_)subdev 
functions to call the new s_config op if it is available. Existing subdev 
drivers never set this new op, so this code will not effect current 
behavior. But for new drivers that do set s_config it is important that it 
is called no matter what flavor of these functions is used.

At the end of the 2.6.31 cycle we can replace the current 
v4l2_i2c_new_(probed_)subdev calls with the new one I had in my earlier 
patches."

Comments are welcome.

	Hans

# HG changeset patch
# User Hans Verkuil <hverkuil@xs4all.nl>
# Date 1244578353 -7200
# Node ID d9d3f747395109de316eadeed1d1d52b8440f84b
# Parent  ed3781a79c734f35b800d0b55d276cd62d793141
v4l2: add new s_config subdev ops and v4l2_i2c_new_subdev_cfg/board calls

From: Hans Verkuil <hverkuil@xs4all.nl>

Add a new s_config core ops call: this is called with the irq and platform
data to be used to initialize the subdev.

Added new v4l2_i2c_new_subdev_cfg and v4l2_i2c_new_subdev_board calls
that allows you to pass these new arguments.

The existing v4l2_i2c_new_subdev functions were modified to also call
s_config.

In the future the existing v4l2_i2c_new_subdev functions will be replaced
by a single v4l2_i2c_new_subdev function similar to v4l2_i2c_new_subdev_cfg
but without the irq and platform_data arguments.

Priority: normal

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

diff -r ed3781a79c73 -r d9d3f7473951 linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Sat Jun 06 16:31:34 2009 +0400
+++ b/linux/drivers/media/video/v4l2-common.c	Tue Jun 09 22:12:33 2009 +0200
@@ -868,6 +868,17 @@
 	/* Decrease the module use count to match the first try_module_get. */
 	module_put(client->driver->driver.owner);
 
+	if (sd) {
+		/* We return errors from v4l2_subdev_call only if we have the
+		   callback as the .s_config is not mandatory */
+		int err = v4l2_subdev_call(sd, core, s_config, 0, NULL);
+
+		if (err && err != -ENOIOCTLCMD) {
+			v4l2_device_unregister_subdev(sd);
+			sd = NULL;
+		}
+	}
+
 error:
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 	/* If we have a client but no subdev, then something went wrong and
@@ -931,6 +942,17 @@
 	/* Decrease the module use count to match the first try_module_get. */
 	module_put(client->driver->driver.owner);
 
+	if (sd) {
+		/* We return errors from v4l2_subdev_call only if we have the
+		   callback as the .s_config is not mandatory */
+		int err = v4l2_subdev_call(sd, core, s_config, 0, NULL);
+
+		if (err && err != -ENOIOCTLCMD) {
+			v4l2_device_unregister_subdev(sd);
+			sd = NULL;
+		}
+	}
+
 error:
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
 	/* If we have a client but no subdev, then something went wrong and
@@ -952,6 +974,150 @@
 			module_name, client_type, addrs);
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_probed_subdev_addr);
+
+/* Load an i2c sub-device. */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter, const char *module_name,
+		struct i2c_board_info *info, const unsigned short *probe_addrs)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct i2c_client *client;
+
+	BUG_ON(!v4l2_dev);
+
+	if (module_name)
+		request_module(module_name);
+
+	/* Create the i2c client */
+	if (info->addr == 0 && probe_addrs)
+		client = i2c_new_probed_device(adapter, info, probe_addrs);
+	else
+		client = i2c_new_device(adapter, info);
+
+	/* Note: by loading the module first we are certain that c->driver
+	   will be set if the driver was found. If the module was not loaded
+	   first, then the i2c core tries to delay-load the module for us,
+	   and then c->driver is still NULL until the module is finally
+	   loaded. This delay-load mechanism doesn't work if other drivers
+	   want to use the i2c device, so explicitly loading the module
+	   is the best alternative. */
+	if (client == NULL || client->driver == NULL)
+		goto error;
+
+	/* Lock the module so we can safely get the v4l2_subdev pointer */
+	if (!try_module_get(client->driver->driver.owner))
+		goto error;
+	sd = i2c_get_clientdata(client);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+	if (v4l2_device_register_subdev(v4l2_dev, sd))
+		sd = NULL;
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(client->driver->driver.owner);
+
+	if (sd) {
+		/* We return errors from v4l2_subdev_call only if we have the
+		   callback as the .s_config is not mandatory */
+		int err = v4l2_subdev_call(sd, core, s_config,
+				info->irq, info->platform_data);
+
+		if (err && err != -ENOIOCTLCMD) {
+			v4l2_device_unregister_subdev(sd);
+			sd = NULL;
+		}
+	}
+
+error:
+	/* If we have a client but no subdev, then something went wrong and
+	   we must unregister the client. */
+	if (client && sd == NULL)
+		i2c_unregister_device(client);
+	return sd;
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board);
+
+struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type,
+		int irq, void *platform_data,
+		u8 addr, const unsigned short *probe_addrs)
+{
+	struct i2c_board_info info;
+
+	/* Setup the i2c board info with the device type and
+	   the device address. */
+	memset(&info, 0, sizeof(info));
+	strlcpy(info.type, client_type, sizeof(info.type));
+	info.addr = addr;
+	info.irq = irq;
+	info.platform_data = platform_data;
+
+	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, module_name,
+			&info, probe_addrs);
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_cfg);
+#else
+struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type,
+		int irq, void *platform_data,
+		u8 addr, const unsigned short *probe_addrs)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct i2c_client *client;
+
+	BUG_ON(!v4l2_dev);
+
+	if (module_name)
+		request_module(module_name);
+
+	if (addr == 0 && probe_addrs) {
+		/* Legacy code: loading the module should automatically
+		   probe and create the i2c_client on the adapter.
+		   Try to find the client by walking the adapter's client list
+		   for each of the possible addresses. */
+		while (!client && *probe_addrs != I2C_CLIENT_END)
+			client = v4l2_i2c_legacy_find_client(adapter, *probe_addrs++);
+	} else {
+		/* Legacy code: loading the module automatically probes and
+		   creates the i2c_client on the adapter. Try to find the
+		   client by walking the adapter's client list. */
+		client = v4l2_i2c_legacy_find_client(adapter, addr);
+	}
+	if (client == NULL || client->driver == NULL)
+		goto error;
+
+	/* Lock the module so we can safely get the v4l2_subdev pointer */
+	if (!try_module_get(client->driver->driver.owner))
+		goto error;
+	sd = i2c_get_clientdata(client);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+	if (v4l2_device_register_subdev(v4l2_dev, sd))
+		sd = NULL;
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(client->driver->driver.owner);
+
+	if (sd) {
+		/* We return errors from v4l2_subdev_call only if we have the
+		   callback as the .s_config is not mandatory */
+		int err = v4l2_subdev_call(sd, core, s_config,
+				irq, platform_data);
+
+		if (err && err != -ENOIOCTLCMD) {
+			v4l2_device_unregister_subdev(sd);
+			sd = NULL;
+		}
+	}
+
+error:
+	return sd;
+}
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_cfg);
+#endif
 
 /* Return i2c client address of v4l2_subdev. */
 unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd)
diff -r ed3781a79c73 -r d9d3f7473951 linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Sat Jun 06 16:31:34 2009 +0400
+++ b/linux/include/media/v4l2-common.h	Tue Jun 09 22:12:33 2009 +0200
@@ -158,6 +158,24 @@
 struct v4l2_subdev *v4l2_i2c_new_probed_subdev_addr(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter,
 		const char *module_name, const char *client_type, u8 addr);
+
+/* Load an i2c module and return an initialized v4l2_subdev struct.
+   Only call request_module if module_name != NULL.
+   The client_type argument is the name of the chip that's on the adapter. */
+struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type,
+		int irq, void *platform_data,
+		u8 addr, const unsigned short *probe_addrs);
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
+struct i2c_board_info;
+
+struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
+		struct i2c_adapter *adapter, const char *module_name,
+		struct i2c_board_info *info, const unsigned short *probe_addrs);
+#endif
+
 /* Initialize an v4l2_subdev with data from an i2c_client struct */
 void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
 		const struct v4l2_subdev_ops *ops);
diff -r ed3781a79c73 -r d9d3f7473951 linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Sat Jun 06 16:31:34 2009 +0400
+++ b/linux/include/media/v4l2-subdev.h	Tue Jun 09 22:12:33 2009 +0200
@@ -79,7 +79,11 @@
    not yet implemented) since ops provide proper type-checking.
  */
 
-/* init: initialize the sensor registors to some sort of reasonable default
+/* s_config: if set, then it is always called by the v4l2_i2c_new_subdev*
+	functions after the v4l2_subdev was registered. It is used to pass
+	platform data to the subdev which can be used during initialization.
+
+   init: initialize the sensor registors to some sort of reasonable default
 	values. Do not use for new drivers and should be removed in existing
 	drivers.
 
@@ -96,6 +100,7 @@
 struct v4l2_subdev_core_ops {
 	int (*g_chip_ident)(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip);
 	int (*log_status)(struct v4l2_subdev *sd);
+	int (*s_config)(struct v4l2_subdev *sd, int irq, void *platform_data);
 	int (*init)(struct v4l2_subdev *sd, u32 val);
 	int (*load_fw)(struct v4l2_subdev *sd);
 	int (*reset)(struct v4l2_subdev *sd, u32 val);

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

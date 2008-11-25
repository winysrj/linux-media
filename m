Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAPHn3wm002092
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 12:49:03 -0500
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAPHmpDT025533
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 12:48:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
Date: Tue, 25 Nov 2008 18:48:47 +0100
References: <200811242309.37489.hverkuil@xs4all.nl>
	<200811250810.01767.hverkuil@xs4all.nl>
	<5d5443650811242327gc204050lf232dfac48ae4f1@mail.gmail.com>
In-Reply-To: <5d5443650811242327gc204050lf232dfac48ae4f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811251848.47637.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: v4l2_device/v4l2_subdev: please review (PATCH 2/3)
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


# HG changeset patch
# User Hans Verkuil <hverkuil@xs4all.nl>
# Date 1227453585 -3600
# Node ID aaf944b194f95c0cc47603c1fc5105cca073c7db
# Parent d9ec70c0b0c55e18813f91218c6da6212ca9b7e6
v4l2-common: add i2c helper functions

From: Hans Verkuil <hverkuil@xs4all.nl>

Add helper functions to load i2c sub-devices, integrating them
into the v4l2-framework.

Priority: normal

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>

--- a/linux/drivers/media/video/v4l2-common.c	Mon Nov 24 22:09:50 2008 
+0100
+++ b/linux/drivers/media/video/v4l2-common.c	Sun Nov 23 16:19:45 2008 
+0100
@@ -58,6 +58,7 @@
 #include <asm/div64.h>
 #define __OLD_VIDIOC_ /* To allow fixing old calls*/
 #include <media/v4l2-common.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
 
 #include <linux/videodev2.h>
@@ -802,4 +803,173 @@ int v4l2_i2c_attach(struct i2c_adapter *
 	return err != -ENOMEM ? 0 : err;
 }
 EXPORT_SYMBOL(v4l2_i2c_attach);
-#endif
+
+void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client 
*client,
+		const struct v4l2_subdev_ops *ops)
+{
+	v4l2_subdev_init(sd, ops);
+	/* the owner is the same as the i2c_client's driver owner */
+	sd->owner = client->driver->driver.owner;
+	/* i2c_client and v4l2_subdev point to one another */
+	v4l2_set_subdevdata(sd, client);
+	i2c_set_clientdata(client, sd);
+	/* initialize name */
+	snprintf(sd->name, sizeof(sd->name), "%s %d-%04x",
+		client->driver->driver.name, i2c_adapter_id(client->adapter),
+		client->addr);
+}
+EXPORT_SYMBOL(v4l2_i2c_subdev_init);
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 22)
+/* Supporting function to find a client on a specific address on the
+   given adapter. Used for legacy i2c drivers. */
+static struct i2c_client *v4l2_i2c_legacy_find_client(struct 
i2c_adapter *adap, u8 addr)
+{
+	struct i2c_client *result = NULL;
+	struct i2c_client *client;
+	struct list_head  *item;
+
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 16)
+	down(&adap->clist_lock);
+#else
+	mutex_lock(&adap->clist_lock);
+#endif
+	list_for_each(item, &adap->clients) {
+		client = list_entry(item, struct i2c_client, list);
+		if (client->addr == addr) {
+			result = client;
+			break;
+		}
+	}
+#if LINUX_VERSION_CODE <= KERNEL_VERSION(2, 6, 16)
+	up(&adap->clist_lock);
+#else
+	mutex_unlock(&adap->clist_lock);
+#endif
+	return result;
+}
+#endif
+
+
+/* Load an i2c sub-device. It assumes that i2c_get_adapdata(adapter)
+   returns the v4l2_device and that i2c_get_clientdata(client)
+   returns the v4l2_subdev. */
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type, u8 addr)
+{
+	struct v4l2_device *dev = i2c_get_adapdata(adapter);
+	struct v4l2_subdev *sd = NULL;
+	struct i2c_client *client;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	struct i2c_board_info info;
+#endif
+
+	BUG_ON(!dev);
+#ifdef MODULE
+	if (module_name)
+		request_module(module_name);
+#endif
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	/* Setup the i2c board info with the device type and
+	   the device address. */
+	memset(&info, 0, sizeof(info));
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
+	strlcpy(info.driver_name, client_type, sizeof(info.driver_name));
+#else
+	strlcpy(info.type, client_type, sizeof(info.type));
+#endif
+	info.addr = addr;
+
+	/* Create the i2c client */
+	client = i2c_new_device(adapter, &info);
+#else
+	/* Legacy code: loading the module automatically
+	   probes and creates the i2c_client on the adapter.
+	   Try to find the client by walking the adapter's client list. */
+	client = v4l2_i2c_legacy_find_client(adapter, addr);
+#endif
+	/* Note: it is possible in the future that
+	   c->driver is NULL if the driver is still being loaded.
+	   We need better support from the kernel so that we
+	   can easily wait for the load to finish. */
+	if (client == NULL || client->driver == NULL)
+		return NULL;
+
+	/* Lock the module so we can safely get the v4l2_subdev pointer */
+	if (!try_module_get(client->driver->driver.owner))
+		return NULL;
+	sd = i2c_get_clientdata(client);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+	if (v4l2_device_register_subdev(dev, sd))
+		sd = NULL;
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(client->driver->driver.owner);
+	return sd;
+
+}
+EXPORT_SYMBOL(v4l2_i2c_new_subdev);
+
+/* Probe and load an i2c sub-device. It assumes that 
i2c_get_adapdata(adapter)
+   returns the v4l2_device and that i2c_get_clientdata(client)
+   returns the v4l2_subdev. */
+struct v4l2_subdev *v4l2_i2c_new_probed_subdev(struct i2c_adapter 
*adapter,
+	const char *module_name, const char *client_type,
+	const unsigned short *addrs)
+{
+	struct v4l2_device *dev = i2c_get_adapdata(adapter);
+	struct v4l2_subdev *sd = NULL;
+	struct i2c_client *client = NULL;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	struct i2c_board_info info;
+#endif
+
+	BUG_ON(!dev);
+#ifdef MODULE
+	if (module_name)
+		request_module(module_name);
+#endif
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 22)
+	/* Setup the i2c board info with the device type and
+	   the device address. */
+	memset(&info, 0, sizeof(info));
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 26)
+	strlcpy(info.driver_name, client_type, sizeof(info.driver_name));
+#else
+	strlcpy(info.type, client_type, sizeof(info.type));
+#endif
+
+	/* Probe and create the i2c client */
+	client = i2c_new_probed_device(adapter, &info, addrs);
+#else
+	/* Legacy code: loading the module should automatically
+	   probe and create the i2c_client on the adapter.
+	   Try to find the client by walking the adapter's client list
+	   for each of the possible addresses. */
+	while (!client && *addrs != I2C_CLIENT_END)
+		client = v4l2_i2c_legacy_find_client(adapter, *addrs++);
+#endif
+	/* Note: it is possible in the future that
+	   c->driver is NULL if the driver is still being loaded.
+	   We need better support from the kernel so that we
+	   can easily wait for the load to finish. */
+	if (client == NULL || client->driver == NULL)
+		return NULL;
+
+	/* Lock the module so we can safely get the v4l2_subdev pointer */
+	if (!try_module_get(client->driver->driver.owner))
+		return NULL;
+	sd = i2c_get_clientdata(client);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+	if (v4l2_device_register_subdev(dev, sd))
+		sd = NULL;
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(client->driver->driver.owner);
+	return sd;
+}
+EXPORT_SYMBOL(v4l2_i2c_new_probed_subdev);
+
+#endif
--- a/linux/include/media/v4l2-common.h	Mon Nov 24 22:09:50 2008 +0100
+++ b/linux/include/media/v4l2-common.h	Sun Nov 23 16:19:45 2008 +0100
@@ -53,6 +53,29 @@
 	do { 								     \
 		if (debug >= (level))					     \
 			v4l_client_printk(KERN_DEBUG, client, fmt , ## arg); \
+	} while (0)
+
+/* ------------------------------------------------------------------------- 
*/
+
+/* These printk constructs can be used with v4l2_device and v4l2_subdev 
*/
+#define v4l2_printk(level, dev, fmt, arg...) \
+	printk(level "%s: " fmt, (dev)->name , ## arg)
+
+#define v4l2_err(dev, fmt, arg...) \
+	v4l2_printk(KERN_ERR, dev, fmt , ## arg)
+
+#define v4l2_warn(dev, fmt, arg...) \
+	v4l2_printk(KERN_WARNING, dev, fmt , ## arg)
+
+#define v4l2_info(dev, fmt, arg...) \
+	v4l2_printk(KERN_INFO, dev, fmt , ## arg)
+
+/* These three macros assume that the debug level is set with a module
+   parameter called 'debug'. */
+#define v4l2_dbg(level, debug, dev, fmt, arg...)			\
+	do { 								\
+		if (debug >= (level))					\
+			v4l2_printk(KERN_DEBUG, dev, fmt , ## arg); 	\
 	} while (0)
 
 /* ------------------------------------------------------------------------- 
*/
@@ -104,10 +127,28 @@ struct i2c_adapter;
 struct i2c_adapter;
 struct i2c_client;
 struct i2c_device_id;
+struct v4l2_device;
+struct v4l2_subdev;
+struct v4l2_subdev_ops;
 
 int v4l2_i2c_attach(struct i2c_adapter *adapter, int address, struct 
i2c_driver *driver,
 		const char *name,
 		int (*probe)(struct i2c_client *, const struct i2c_device_id *));
+
+/* Load an i2c module and return an initialized v4l2_subdev struct.
+   Only call request_module if module_name != NULL.
+   The client_type argument is the name of the chip that's on the 
adapter. */
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct i2c_adapter *adapter,
+		const char *module_name, const char *client_type, u8 addr);
+/* Probe and load an i2c module and return an initialized v4l2_subdev 
struct.
+   Only call request_module if module_name != NULL.
+   The client_type argument is the name of the chip that's on the 
adapter. */
+struct v4l2_subdev *v4l2_i2c_new_probed_subdev(struct i2c_adapter 
*adapter,
+		const char *module_name, const char *client_type,
+		const unsigned short *addrs);
+/* Initialize an v4l2_subdev with data from an i2c_client struct */
+void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client 
*client,
+		const struct v4l2_subdev_ops *ops);
 
 /* ------------------------------------------------------------------------- 
*/
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

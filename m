Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62074 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763461Ab3DHLHo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 07:07:44 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v7 2/7] media: V4L2: support asynchronous subdevice registration
Date: Mon,  8 Apr 2013 13:07:06 +0200
Message-Id: <1365419231-14830-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365419231-14830-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365419231-14830-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently bridge device drivers register devices for all subdevices
synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
is attached to a video bridge device, the bridge driver will create an I2C
device and wait for the respective I2C driver to probe. This makes linking
of devices straight forward, but this approach cannot be used with
intrinsically asynchronous and unordered device registration systems like
the Flattened Device Tree. To support such systems this patch adds an
asynchronous subdevice registration framework to V4L2. To use it respective
(e.g. I2C) subdevice drivers must register themselves with the framework.
A bridge driver on the other hand must register notification callbacks,
that will be called upon various related events.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v7:
1. Removed bogus device reprobing from v4l2_async_unregister_subdev()
2. Renamed V4L2_ASYNC_BUS_SPECIAL to V4L2_ASYNC_BUS_CUSTOM
3. Renamed v4l2_async_subdev_(un)register() to v4l2_async_(un)register_subdev()

 drivers/media/v4l2-core/Makefile     |    3 +-
 drivers/media/v4l2-core/v4l2-async.c |  263 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h           |  105 ++++++++++++++
 3 files changed, 370 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-async.c
 create mode 100644 include/media/v4l2-async.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index 628c630..4c33b8d6 100644
--- a/drivers/media/v4l2-core/Makefile
+++ b/drivers/media/v4l2-core/Makefile
@@ -5,7 +5,8 @@
 tuner-objs	:=	tuner-core.o
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
-			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
+			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o \
+			v4l2-async.o
 ifeq ($(CONFIG_COMPAT),y)
   videodev-objs += v4l2-compat-ioctl32.o
 endif
diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
new file mode 100644
index 0000000..4cc56ad
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -0,0 +1,263 @@
+/*
+ * V4L2 asynchronous subdevice registration API
+ *
+ * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <media/v4l2-async.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+static bool match_i2c(struct device *dev, struct v4l2_async_hw_device *hw_dev)
+{
+	struct i2c_client *client = i2c_verify_client(dev);
+	return client &&
+		hw_dev->bus_type == V4L2_ASYNC_BUS_I2C &&
+		hw_dev->match.i2c.adapter_id == client->adapter->nr &&
+		hw_dev->match.i2c.address == client->addr;
+}
+
+static bool match_platform(struct device *dev, struct v4l2_async_hw_device *hw_dev)
+{
+	return hw_dev->bus_type == V4L2_ASYNC_BUS_PLATFORM &&
+		!strcmp(hw_dev->match.platform.name, dev_name(dev));
+}
+
+static LIST_HEAD(subdev_list);
+static LIST_HEAD(notifier_list);
+static DEFINE_MUTEX(list_lock);
+
+static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
+						    struct v4l2_async_subdev_list *asdl)
+{
+	struct v4l2_async_subdev *asd = NULL;
+	bool (*match)(struct device *,
+		      struct v4l2_async_hw_device *);
+
+	list_for_each_entry (asd, &notifier->waiting, list) {
+		struct v4l2_async_hw_device *hw = &asd->hw;
+		switch (hw->bus_type) {
+		case V4L2_ASYNC_BUS_SPECIAL:
+			match = hw->match.special.match;
+			if (!match)
+				/* Match always */
+				return asd;
+			break;
+		case V4L2_ASYNC_BUS_PLATFORM:
+			match = match_platform;
+			break;
+		case V4L2_ASYNC_BUS_I2C:
+			match = match_i2c;
+			break;
+		default:
+			/* Oops */
+			match = NULL;
+			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
+				"Invalid bus-type %u on %p\n", hw->bus_type, asd);
+		}
+
+		if (match && match(asdl->dev, hw))
+			break;
+	}
+
+	return asd;
+}
+
+static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
+				  struct v4l2_async_subdev_list *asdl,
+				  struct v4l2_async_subdev *asd)
+{
+	int ret;
+
+	/* Remove from the waiting list */
+	list_del(&asd->list);
+	asdl->asd = asd;
+	asdl->notifier = notifier;
+
+	if (notifier->bound) {
+		ret = notifier->bound(notifier, asdl);
+		if (ret < 0)
+			return ret;
+	}
+	/* Move from the global subdevice list to notifier's done */
+	list_move(&asdl->list, &notifier->done);
+
+	ret = v4l2_device_register_subdev(notifier->v4l2_dev,
+					  asdl->subdev);
+	if (ret < 0) {
+		if (notifier->unbind)
+			notifier->unbind(notifier, asdl);
+		return ret;
+	}
+
+	if (list_empty(&notifier->waiting) && notifier->complete)
+		return notifier->complete(notifier);
+
+	return 0;
+}
+
+static void v4l2_async_cleanup(struct v4l2_async_subdev_list *asdl)
+{
+	v4l2_device_unregister_subdev(asdl->subdev);
+	/* Subdevice driver will reprobe and put asdl back onto the list */
+	list_del_init(&asdl->list);
+	asdl->asd = NULL;
+	asdl->dev = NULL;
+}
+
+static struct device *v4l2_async_unregister(struct v4l2_async_subdev_list *asdl)
+{
+	struct device *dev = asdl->dev;
+
+	v4l2_async_cleanup(asdl);
+
+	/* If we handled USB devices, we'd have to lock the parent too */
+	device_release_driver(dev);
+	return dev;
+}
+
+int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
+				 struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_async_subdev_list *asdl, *tmp;
+	int i;
+
+	notifier->v4l2_dev = v4l2_dev;
+	INIT_LIST_HEAD(&notifier->waiting);
+	INIT_LIST_HEAD(&notifier->done);
+
+	for (i = 0; i < notifier->subdev_num; i++)
+		list_add_tail(&notifier->subdev[i]->list, &notifier->waiting);
+
+	mutex_lock(&list_lock);
+
+	/* Keep also completed notifiers on the list */
+	list_add(&notifier->list, &notifier_list);
+
+	list_for_each_entry_safe(asdl, tmp, &subdev_list, list) {
+		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, asdl);
+		int ret;
+
+		if (!asd)
+			continue;
+
+		ret = v4l2_async_test_notify(notifier, asdl, asd);
+		if (ret < 0) {
+			mutex_unlock(&list_lock);
+			return ret;
+		}
+	}
+
+	mutex_unlock(&list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_async_notifier_register);
+
+void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_async_subdev_list *asdl, *tmp;
+	int i = 0;
+	struct device **dev = kcalloc(notifier->subdev_num,
+				      sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		dev_err(notifier->v4l2_dev->dev,
+			"Failed to allocate device cache!\n");
+
+	mutex_lock(&list_lock);
+
+	list_del(&notifier->list);
+
+	list_for_each_entry_safe(asdl, tmp, &notifier->done, list) {
+		if (dev)
+			dev[i++] = get_device(asdl->dev);
+		v4l2_async_unregister(asdl);
+
+		if (notifier->unbind)
+			notifier->unbind(notifier, asdl);
+	}
+
+	mutex_unlock(&list_lock);
+
+	if (dev) {
+		while (i--) {
+			if (dev[i] && device_attach(dev[i]) < 0)
+				dev_err(dev[i], "Failed to re-probe to %s\n",
+					dev[i]->driver ? dev[i]->driver->name : "(none)");
+			put_device(dev[i]);
+		}
+		kfree(dev);
+	}
+	/*
+	 * Don't care about the waiting list, it is initialised and populated
+	 * upon notifier registration.
+	 */
+}
+EXPORT_SYMBOL(v4l2_async_notifier_unregister);
+
+int v4l2_async_register_subdev(struct v4l2_async_subdev_list *asdl)
+{
+	struct v4l2_async_notifier *notifier;
+
+	mutex_lock(&list_lock);
+
+	INIT_LIST_HEAD(&asdl->list);
+
+	list_for_each_entry(notifier, &notifier_list, list) {
+		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, asdl);
+		if (asd) {
+			int ret = v4l2_async_test_notify(notifier, asdl, asd);
+			mutex_unlock(&list_lock);
+			return ret;
+		}
+	}
+
+	/* None matched, wait for hot-plugging */
+	list_add(&asdl->list, &subdev_list);
+
+	mutex_unlock(&list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(v4l2_async_register_subdev);
+
+void v4l2_async_unregister_subdev(struct v4l2_async_subdev_list *asdl)
+{
+	struct v4l2_async_notifier *notifier = asdl->notifier;
+	struct device *dev;
+
+	if (!asdl->asd) {
+		if (!list_empty(&asdl->list))
+			v4l2_async_cleanup(asdl);
+		return;
+	}
+
+	mutex_lock(&list_lock);
+
+	dev = asdl->dev;
+
+	list_add(&asdl->asd->list, &notifier->waiting);
+
+	v4l2_async_cleanup(asdl);
+
+	if (notifier->unbind)
+		notifier->unbind(notifier, asdl);
+
+	mutex_unlock(&list_lock);
+}
+EXPORT_SYMBOL(v4l2_async_unregister_subdev);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
new file mode 100644
index 0000000..c0470c6
--- /dev/null
+++ b/include/media/v4l2-async.h
@@ -0,0 +1,105 @@
+/*
+ * V4L2 asynchronous subdevice registration API
+ *
+ * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef V4L2_ASYNC_H
+#define V4L2_ASYNC_H
+
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+
+#include <media/v4l2-subdev.h>
+
+struct device;
+struct v4l2_device;
+struct v4l2_async_notifier;
+
+enum v4l2_async_bus_type {
+	V4L2_ASYNC_BUS_SPECIAL,
+	V4L2_ASYNC_BUS_PLATFORM,
+	V4L2_ASYNC_BUS_I2C,
+};
+
+struct v4l2_async_hw_device {
+	enum v4l2_async_bus_type bus_type;
+	union {
+		struct {
+			const char *name;
+		} platform;
+		struct {
+			int adapter_id;
+			unsigned short address;
+		} i2c;
+		struct {
+			bool (*match)(struct device *,
+				      struct v4l2_async_hw_device *);
+			void *priv;
+		} special;
+	} match;
+};
+
+/**
+ * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
+ * @hw:		this device descriptor
+ * @list:	member in a list of subdevices
+ */
+struct v4l2_async_subdev {
+	struct v4l2_async_hw_device hw;
+	struct list_head list;
+};
+
+/**
+ * v4l2_async_subdev_list - provided by subdevices
+ * @list:	member in a list of subdevices
+ * @dev:	hardware device
+ * @subdev:	V4L2 subdevice
+ * @asd:	pointer to respective struct v4l2_async_subdev
+ * @notifier:	pointer to managing notifier
+ */
+struct v4l2_async_subdev_list {
+	struct list_head list;
+	struct device *dev;
+	struct v4l2_subdev *subdev;
+	struct v4l2_async_subdev *asd;
+	struct v4l2_async_notifier *notifier;
+};
+
+/**
+ * v4l2_async_notifier - provided by bridges
+ * @subdev_num:	number of subdevices
+ * @subdev:	array of pointers to subdevices
+ * @v4l2_dev:	pointer to sruct v4l2_device
+ * @waiting:	list of subdevices, waiting for their drivers
+ * @done:	list of subdevices, already probed
+ * @list:	member in a global list of notifiers
+ * @bound:	a subdevice driver has successfully probed one of subdevices
+ * @complete:	all subdevices have been probed successfully
+ * @unbind:	a subdevice is leaving
+ */
+struct v4l2_async_notifier {
+	int subdev_num;
+	struct v4l2_async_subdev **subdev;
+	struct v4l2_device *v4l2_dev;
+	struct list_head waiting;
+	struct list_head done;
+	struct list_head list;
+	int (*bound)(struct v4l2_async_notifier *notifier,
+		     struct v4l2_async_subdev_list *asdl);
+	int (*complete)(struct v4l2_async_notifier *notifier);
+	void (*unbind)(struct v4l2_async_notifier *notifier,
+		       struct v4l2_async_subdev_list *asdl);
+};
+
+int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
+				 struct v4l2_async_notifier *notifier);
+void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
+int v4l2_async_register_subdev(struct v4l2_async_subdev_list *asdl);
+void v4l2_async_unregister_subdev(struct v4l2_async_subdev_list *asdl);
+#endif
-- 
1.7.2.5


Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:55315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3AGKYI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 05:24:08 -0500
Date: Mon, 7 Jan 2013 11:23:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH 1/6 v4] media: V4L2: support asynchronous subdevice registration
In-Reply-To: <1356544151-6313-2-git-send-email-g.liakhovetski@gmx.de>
Message-ID: <Pine.LNX.4.64.1301071121280.23972@axis700.grange>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de>
 <1356544151-6313-2-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>From 0e1eae338ba898dc25ec60e3dba99e5581edc199 Mon Sep 17 00:00:00 2001
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Date: Fri, 19 Oct 2012 23:40:44 +0200
Subject: [PATCH] media: V4L2: support asynchronous subdevice registration

Currently bridge device drivers register devices for all subdevices
synchronously, tupically, during their probing. E.g. if an I2C CMOS sensor
is attached to a video bridge device, the bridge driver will create an I2C
device and wait for the respective I2C driver to probe. This makes linking
of devices straight forward, but this approach cannot be used with
intrinsically asynchronous and unordered device registration systems like
the Flattened Device Tree. To support such systems this patch adds an
asynchronous subdevice registration framework to V4L2. To use it respective
(e.g. I2C) subdevice drivers must request deferred probing as long as their
bridge driver hasn't probed. The bridge driver during its probing submits a
an arbitrary number of subdevice descriptor groups to the framework to
manage. After that it can add callbacks to each of those groups to be
called at various stages during subdevice probing, e.g. after completion.
Then the bridge driver can request single groups to be probed, finish its
own probing and continue its video subsystem configuration from its
callbacks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v4: Fixed v4l2_async_notifier_register() for the case, when subdevices 
probe successfully before the bridge, thanks to Prabhakar for reporting

 drivers/media/v4l2-core/Makefile     |    3 +-
 drivers/media/v4l2-core/v4l2-async.c |  284 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h           |  113 ++++++++++++++
 3 files changed, 399 insertions(+), 1 deletions(-)
 create mode 100644 drivers/media/v4l2-core/v4l2-async.c
 create mode 100644 include/media/v4l2-async.h

diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
index d065c01..b667ced 100644
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
index 0000000..55c2ad0
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -0,0 +1,284 @@
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
+	struct i2c_client *client = to_i2c_client(dev);
+	return hw_dev->bus_type == V4L2_ASYNC_BUS_I2C &&
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
+				   struct v4l2_async_subdev_list *asdl)
+{
+	struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier, asdl);
+	if (asd) {
+		int ret;
+		/* Remove from the waiting list */
+		list_del(&asd->list);
+		asdl->asd = asd;
+		asdl->notifier = notifier;
+
+		if (notifier->bound) {
+			ret = notifier->bound(notifier, asdl);
+			if (ret < 0)
+				return ret;
+		}
+		/* Move from the global subdevice list to notifier's done */
+		list_move(&asdl->list, &notifier->done);
+
+		ret = v4l2_device_register_subdev(notifier->v4l2_dev,
+						  asdl->subdev);
+		if (ret < 0) {
+			if (notifier->unbind)
+				notifier->unbind(notifier, asdl);
+			return ret;
+		}
+
+		if (list_empty(&notifier->waiting) && notifier->complete)
+			return notifier->complete(notifier);
+
+		return 0;
+	}
+
+	return -EPROBE_DEFER;
+}
+
+static struct device *v4l2_async_unbind(struct v4l2_async_subdev_list *asdl)
+{
+	struct device *dev = asdl->dev;
+	v4l2_device_unregister_subdev(asdl->subdev);
+	/* Subdevice driver will reprobe and put asdl back onto the list */
+	list_del(&asdl->list);
+	asdl->asd = NULL;
+	/* If we handled USB devices, we'd have to lock the parent too */
+	device_release_driver(dev);
+	return dev;
+}
+
+int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
+				 struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_async_subdev_list *asdl;
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
+	list_for_each_entry(asdl, &subdev_list, list) {
+		int ret = v4l2_async_test_notify(notifier, asdl);
+		if (ret < 0 && ret != -EPROBE_DEFER) {
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
+		v4l2_async_unbind(asdl);
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
+int v4l2_async_subdev_bind(struct v4l2_async_subdev_list *asdl)
+{
+	struct v4l2_async_notifier *notifier;
+	int ret = 0;
+
+	mutex_lock(&list_lock);
+
+	list_for_each_entry(notifier, &notifier_list, list) {
+		struct v4l2_async_subdev *asd = v4l2_async_belongs(notifier,
+								   asdl);
+		/*
+		 * Whether or not probing succeeds - this is the right hardware
+		 * subdevice descriptor and we can provide it to the notifier
+		 */
+		if (asd) {
+			asdl->asd = asd;
+			if (notifier->bind)
+				ret = notifier->bind(notifier, asdl);
+			break;
+		}
+	}
+
+	mutex_unlock(&list_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(v4l2_async_subdev_bind);
+
+int v4l2_async_subdev_bound(struct v4l2_async_subdev_list *asdl)
+{
+	struct v4l2_async_notifier *notifier;
+
+	mutex_lock(&list_lock);
+
+	INIT_LIST_HEAD(&asdl->list);
+
+	list_for_each_entry(notifier, &notifier_list, list) {
+		int ret = v4l2_async_test_notify(notifier, asdl);
+		if (ret != -EPROBE_DEFER) {
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
+EXPORT_SYMBOL(v4l2_async_subdev_bound);
+
+void v4l2_async_subdev_unbind(struct v4l2_async_subdev_list *asdl)
+{
+	struct v4l2_async_notifier *notifier = asdl->notifier;
+	struct device *dev;
+
+	if (!asdl->asd)
+		return;
+
+	mutex_lock(&list_lock);
+
+	dev = asdl->dev;
+
+	list_add(&asdl->asd->list, &notifier->waiting);
+
+	dev = get_device(asdl->dev);
+
+	v4l2_async_unbind(asdl);
+
+	if (notifier->unbind)
+		notifier->unbind(notifier, asdl);
+
+	mutex_unlock(&list_lock);
+
+	/* Re-probe with lock released - avoid a deadlock */
+	if (dev && device_attach(dev) < 0)
+		dev_err(dev, "Failed to re-probe to %s\n",
+			dev->driver ? dev->driver->name : "(none)");
+
+	put_device(dev);
+}
+EXPORT_SYMBOL(v4l2_async_subdev_unbind);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
new file mode 100644
index 0000000..91d436d
--- /dev/null
+++ b/include/media/v4l2-async.h
@@ -0,0 +1,113 @@
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
+ * @bind:	a subdevice driver is about to probe one of your subdevices
+ * @bound:	a subdevice driver has successfully probed one of your subdevices
+ * @complete:	all your subdevices have been probed successfully
+ * @unbind:	a subdevice is leaving
+ */
+struct v4l2_async_notifier {
+	int subdev_num;
+	struct v4l2_async_subdev **subdev;
+	struct v4l2_device *v4l2_dev;
+	struct list_head waiting;
+	struct list_head done;
+	struct list_head list;
+	int (*bind)(struct v4l2_async_notifier *notifier,
+		    struct v4l2_async_subdev_list *asdl);
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
+/*
+ * If subdevice probing fails any time after v4l2_async_subdev_bind(), no clean
+ * up must be called. This function is only a message of intention.
+ */
+int v4l2_async_subdev_bind(struct v4l2_async_subdev_list *asdl);
+int v4l2_async_subdev_bound(struct v4l2_async_subdev_list *asdl);
+void v4l2_async_subdev_unbind(struct v4l2_async_subdev_list *asdl);
+#endif
-- 
1.7.2.5


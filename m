Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:61570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884Ab3FNTlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jun 2013 15:41:06 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v11 16/21] V4L2: support asynchronous subdevice registration
Date: Fri, 14 Jun 2013 21:08:26 +0200
Message-Id: <1371236911-15131-17-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de>
References: <1371236911-15131-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently bridge device drivers register devices for all subdevices
synchronously, typically, during their probing. E.g. if an I2C CMOS sensor
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

v11: extended comments, renamed one field

 drivers/media/v4l2-core/Makefile     |    3 +-
 drivers/media/v4l2-core/v4l2-async.c |  280 ++++++++++++++++++++++++++++++++++
 include/media/v4l2-async.h           |  105 +++++++++++++
 include/media/v4l2-subdev.h          |    8 +
 4 files changed, 395 insertions(+), 1 deletions(-)
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
index 0000000..c80ffb4
--- /dev/null
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -0,0 +1,280 @@
+/*
+ * V4L2 asynchronous subdevice registration API
+ *
+ * Copyright (C) 2012-2013, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+
+#include <media/v4l2-async.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+
+static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
+{
+	struct i2c_client *client = i2c_verify_client(dev);
+	return client &&
+		asd->bus_type == V4L2_ASYNC_BUS_I2C &&
+		asd->match.i2c.adapter_id == client->adapter->nr &&
+		asd->match.i2c.address == client->addr;
+}
+
+static bool match_platform(struct device *dev, struct v4l2_async_subdev *asd)
+{
+	return asd->bus_type == V4L2_ASYNC_BUS_PLATFORM &&
+		!strcmp(asd->match.platform.name, dev_name(dev));
+}
+
+static LIST_HEAD(subdev_list);
+static LIST_HEAD(notifier_list);
+static DEFINE_MUTEX(list_lock);
+
+static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *notifier,
+						    struct v4l2_async_subdev_list *asdl)
+{
+	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
+	struct v4l2_async_subdev *asd;
+	bool (*match)(struct device *,
+		      struct v4l2_async_subdev *);
+
+	list_for_each_entry(asd, &notifier->waiting, list) {
+		/* bus_type has been verified valid before */
+		switch (asd->bus_type) {
+		case V4L2_ASYNC_BUS_CUSTOM:
+			match = asd->match.custom.match;
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
+			/* Cannot happen, unless someone breaks us */
+			WARN_ON(true);
+			return NULL;
+		}
+
+		/* match cannot be NULL here */
+		if (match(sd->dev, asd))
+			return asd;
+	}
+
+	return NULL;
+}
+
+static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
+				  struct v4l2_async_subdev_list *asdl,
+				  struct v4l2_async_subdev *asd)
+{
+	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
+	int ret;
+
+	/* Remove from the waiting list */
+	list_del(&asd->list);
+	asdl->asd = asd;
+	asdl->notifier = notifier;
+
+	if (notifier->bound) {
+		ret = notifier->bound(notifier, sd, asd);
+		if (ret < 0)
+			return ret;
+	}
+	/* Move from the global subdevice list to notifier's done */
+	list_move(&asdl->list, &notifier->done);
+
+	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
+	if (ret < 0) {
+		if (notifier->unbind)
+			notifier->unbind(notifier, sd, asd);
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
+	struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
+
+	v4l2_device_unregister_subdev(sd);
+	/* Subdevice driver will reprobe and put asdl back onto the list */
+	list_del_init(&asdl->list);
+	asdl->asd = NULL;
+	sd->dev = NULL;
+}
+
+int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
+				 struct v4l2_async_notifier *notifier)
+{
+	struct v4l2_async_subdev_list *asdl, *tmp;
+	struct v4l2_async_subdev *asd;
+	int i;
+
+	if (!notifier->num_subdevs || notifier->num_subdevs > V4L2_MAX_SUBDEVS)
+		return -EINVAL;
+
+	notifier->v4l2_dev = v4l2_dev;
+	INIT_LIST_HEAD(&notifier->waiting);
+	INIT_LIST_HEAD(&notifier->done);
+
+	for (i = 0; i < notifier->num_subdevs; i++) {
+		asd = notifier->subdev[i];
+
+		switch (asd->bus_type) {
+		case V4L2_ASYNC_BUS_CUSTOM:
+		case V4L2_ASYNC_BUS_PLATFORM:
+		case V4L2_ASYNC_BUS_I2C:
+			break;
+		default:
+			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
+				"Invalid bus-type %u on %p\n",
+				asd->bus_type, asd);
+			return -EINVAL;
+		}
+		list_add_tail(&asd->list, &notifier->waiting);
+	}
+
+	mutex_lock(&list_lock);
+
+	/* Keep also completed notifiers on the list */
+	list_add(&notifier->list, &notifier_list);
+
+	list_for_each_entry_safe(asdl, tmp, &subdev_list, list) {
+		int ret;
+
+		asd = v4l2_async_belongs(notifier, asdl);
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
+	unsigned int notif_n_subdev = notifier->num_subdevs;
+	unsigned int n_subdev = min(notif_n_subdev, V4L2_MAX_SUBDEVS);
+	struct device *dev[n_subdev];
+	int i = 0;
+
+	mutex_lock(&list_lock);
+
+	list_del(&notifier->list);
+
+	list_for_each_entry_safe(asdl, tmp, &notifier->done, list) {
+		struct v4l2_subdev *sd = v4l2_async_to_subdev(asdl);
+
+		dev[i] = get_device(sd->dev);
+
+		v4l2_async_cleanup(asdl);
+
+		/* If we handled USB devices, we'd have to lock the parent too */
+		device_release_driver(dev[i++]);
+
+		if (notifier->unbind)
+			notifier->unbind(notifier, sd, sd->asdl.asd);
+	}
+
+	mutex_unlock(&list_lock);
+
+	while (i--) {
+		struct device *d = dev[i];
+
+		if (d && device_attach(d) < 0) {
+			const char *name = "(none)";
+			int lock = device_trylock(d);
+
+			if (lock && d->driver)
+				name = d->driver->name;
+			dev_err(d, "Failed to re-probe to %s\n", name);
+			if (lock)
+				device_unlock(d);
+		}
+		put_device(d);
+	}
+	/*
+	 * Don't care about the waiting list, it is initialised and populated
+	 * upon notifier registration.
+	 */
+}
+EXPORT_SYMBOL(v4l2_async_notifier_unregister);
+
+int v4l2_async_register_subdev(struct v4l2_subdev *sd)
+{
+	struct v4l2_async_subdev_list *asdl = &sd->asdl;
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
+void v4l2_async_unregister_subdev(struct v4l2_subdev *sd)
+{
+	struct v4l2_async_subdev_list *asdl = &sd->asdl;
+	struct v4l2_async_notifier *notifier = asdl->notifier;
+
+	if (!asdl->asd) {
+		if (!list_empty(&asdl->list))
+			v4l2_async_cleanup(asdl);
+		return;
+	}
+
+	mutex_lock(&list_lock);
+
+	list_add(&asdl->asd->list, &notifier->waiting);
+
+	v4l2_async_cleanup(asdl);
+
+	if (notifier->unbind)
+		notifier->unbind(notifier, sd, sd->asdl.asd);
+
+	mutex_unlock(&list_lock);
+}
+EXPORT_SYMBOL(v4l2_async_unregister_subdev);
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
new file mode 100644
index 0000000..c3ec6ac
--- /dev/null
+++ b/include/media/v4l2-async.h
@@ -0,0 +1,105 @@
+/*
+ * V4L2 asynchronous subdevice registration API
+ *
+ * Copyright (C) 2012-2013, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
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
+
+struct device;
+struct v4l2_device;
+struct v4l2_subdev;
+struct v4l2_async_notifier;
+
+/* A random max subdevice number, used to allocate an array on stack */
+#define V4L2_MAX_SUBDEVS 128U
+
+enum v4l2_async_bus_type {
+	V4L2_ASYNC_BUS_CUSTOM,
+	V4L2_ASYNC_BUS_PLATFORM,
+	V4L2_ASYNC_BUS_I2C,
+};
+
+/**
+ * struct v4l2_async_subdev - sub-device descriptor, as known to a bridge
+ * @bus_type:	subdevice bus type to select the appropriate matching method
+ * @match:	union of per-bus type matching data sets
+ * @list:	used to link struct v4l2_async_subdev objects, waiting to be
+ *		probed, to a notifier->waiting list
+ */
+struct v4l2_async_subdev {
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
+				      struct v4l2_async_subdev *);
+			void *priv;
+		} custom;
+	} match;
+
+	/* v4l2-async core private: not to be used by drivers */
+	struct list_head list;
+};
+
+/**
+ * v4l2_async_subdev_list - provided by subdevices
+ * @list:	links struct v4l2_async_subdev_list objects to a global list
+ *		before probing, and onto notifier->done after probing
+ * @asd:	pointer to respective struct v4l2_async_subdev
+ * @notifier:	pointer to managing notifier
+ */
+struct v4l2_async_subdev_list {
+	struct list_head list;
+	struct v4l2_async_subdev *asd;
+	struct v4l2_async_notifier *notifier;
+};
+
+/**
+ * v4l2_async_notifier - v4l2_device notifier data
+ * @num_subdevs:number of subdevices
+ * @subdev:	array of pointers to subdevice descriptors
+ * @v4l2_dev:	pointer to struct v4l2_device
+ * @waiting:	list of struct v4l2_async_subdev, waiting for their drivers
+ * @done:	list of struct v4l2_async_subdev_list, already probed
+ * @list:	member in a global list of notifiers
+ * @bound:	a subdevice driver has successfully probed one of subdevices
+ * @complete:	all subdevices have been probed successfully
+ * @unbind:	a subdevice is leaving
+ */
+struct v4l2_async_notifier {
+	unsigned int num_subdevs;
+	struct v4l2_async_subdev **subdev;
+	struct v4l2_device *v4l2_dev;
+	struct list_head waiting;
+	struct list_head done;
+	struct list_head list;
+	int (*bound)(struct v4l2_async_notifier *notifier,
+		     struct v4l2_subdev *subdev,
+		     struct v4l2_async_subdev *asd);
+	int (*complete)(struct v4l2_async_notifier *notifier);
+	void (*unbind)(struct v4l2_async_notifier *notifier,
+		       struct v4l2_subdev *subdev,
+		       struct v4l2_async_subdev *asd);
+};
+
+int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
+				 struct v4l2_async_notifier *notifier);
+void v4l2_async_notifier_unregister(struct v4l2_async_notifier *notifier);
+int v4l2_async_register_subdev(struct v4l2_subdev *sd);
+void v4l2_async_unregister_subdev(struct v4l2_subdev *sd);
+#endif
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 39a37f5..b27436e 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -24,6 +24,7 @@
 #include <linux/types.h>
 #include <linux/v4l2-subdev.h>
 #include <media/media-entity.h>
+#include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-dev.h>
 #include <media/v4l2-fh.h>
@@ -587,8 +588,15 @@ struct v4l2_subdev {
 	struct video_device *devnode;
 	/* pointer to the physical device, if any */
 	struct device *dev;
+	struct v4l2_async_subdev_list asdl;
 };
 
+static inline struct v4l2_subdev *v4l2_async_to_subdev(
+			struct v4l2_async_subdev_list *asdl)
+{
+	return container_of(asdl, struct v4l2_subdev, asdl);
+}
+
 #define media_entity_to_v4l2_subdev(ent) \
 	container_of(ent, struct v4l2_subdev, entity)
 #define vdev_to_v4l2_subdev(vdev) \
-- 
1.7.2.5


Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:50224 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbcDEDgL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2016 23:36:11 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com, ricard.wanderlof@axis.com,
	julian@jusst.de, pierre-louis.bossart@linux.intel.com,
	clemens@ladisch.de, dominic.sacre@gmx.de, takamichiho@gmail.com,
	johan@oljud.se, geliangtang@163.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH v2 1/5] media: Add Media Device Allocator API
Date: Mon,  4 Apr 2016 21:35:56 -0600
Message-Id: <11649550bd418b55f48000b5354ab70b1b52a1e8.1459825702.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1459825702.git.shuahkh@osg.samsung.com>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1459825702.git.shuahkh@osg.samsung.com>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add Media Device Allocator API to manage Media Device life time problems.
There are known problems with media device life time management. When media
device is released while an media ioctl is in progress, ioctls fail with
use-after-free errors and kernel hangs in some cases.

Media Allocator API provides interfaces to allocate a refcounted media
device instance from system wide global list and maintains the state until
the last user of the media device releases it.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/Makefile              |   3 +-
 drivers/media/media-dev-allocator.c | 154 ++++++++++++++++++++++++++++++++++++
 include/media/media-dev-allocator.h | 116 +++++++++++++++++++++++++++
 3 files changed, 272 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index e608bbc..b08f091 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,7 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
-media-objs	:= media-device.o media-devnode.o media-entity.o
+media-objs	:= media-device.o media-devnode.o media-entity.o \
+		   media-dev-allocator.o
 
 #
 # I2C drivers should come before other drivers, otherwise they'll fail
diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
new file mode 100644
index 0000000..8c3a5f0
--- /dev/null
+++ b/drivers/media/media-dev-allocator.c
@@ -0,0 +1,154 @@
+/*
+ * media-devkref.c - Media Controller Device Allocator API
+ *
+ * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2016 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ */
+
+/*
+ * This file adds Media Controller Device Instance with
+ * Kref support. A system wide global media device list
+ * is managed and each  media device is refcounted. The
+ * last put on the media device releases the media device
+ * instance.
+*/
+
+#include <linux/slab.h>
+#include <linux/kref.h>
+#include <media/media-device.h>
+
+static LIST_HEAD(media_device_list);
+static LIST_HEAD(media_device_to_delete_list);
+static DEFINE_MUTEX(media_device_lock);
+
+struct media_device_instance {
+	struct media_device mdev;
+	struct list_head list;
+	struct device *dev;
+	struct kref refcount;
+	bool to_delete; /* should be set when devnode is deleted */
+};
+
+static struct media_device *__media_device_get(struct device *dev,
+					       bool allocate, bool get_kref)
+{
+	struct media_device_instance *mdi;
+
+	mutex_lock(&media_device_lock);
+
+	list_for_each_entry(mdi, &media_device_list, list) {
+		if (mdi->dev == dev) {
+			if (get_kref) {
+				kref_get(&mdi->refcount);
+				pr_debug("%s: mdev=%p\n", __func__, &mdi->mdev);
+			}
+			goto done;
+		}
+	}
+
+	if (!allocate) {
+		mdi = NULL;
+		goto done;
+	}
+
+	mdi = kzalloc(sizeof(*mdi), GFP_KERNEL);
+	if (!mdi)
+		goto done;
+
+	mdi->dev = dev;
+	kref_init(&mdi->refcount);
+	list_add_tail(&mdi->list, &media_device_list);
+	pr_debug("%s: mdev=%p\n", __func__, &mdi->mdev);
+
+done:
+	mutex_unlock(&media_device_lock);
+
+	return mdi ? &mdi->mdev : NULL;
+}
+
+struct media_device *media_device_get(struct device *dev)
+{
+	pr_debug("%s\n", __func__);
+	return __media_device_get(dev, true, true);
+}
+EXPORT_SYMBOL_GPL(media_device_get);
+
+/* Don't increment kref - this is a search and find */
+struct media_device *media_device_find(struct device *dev)
+{
+	pr_debug("%s\n", __func__);
+	return __media_device_get(dev, false, false);
+}
+EXPORT_SYMBOL_GPL(media_device_find);
+
+/* don't allocate - increment kref if one is found */
+struct media_device *media_device_get_ref(struct device *dev)
+{
+	pr_debug("%s\n", __func__);
+	return __media_device_get(dev, false, true);
+}
+EXPORT_SYMBOL_GPL(media_device_get_ref);
+
+static void media_device_instance_release(struct kref *kref)
+{
+	struct media_device_instance *mdi =
+		container_of(kref, struct media_device_instance, refcount);
+
+	pr_debug("%s: mdev=%p\n", __func__, &mdi->mdev);
+
+	list_del(&mdi->list);
+	kfree(mdi);
+}
+
+void media_device_put(struct device *dev)
+{
+	struct media_device_instance *mdi;
+
+	mutex_lock(&media_device_lock);
+	/* search first in the media_device_list */
+	list_for_each_entry(mdi, &media_device_list, list) {
+		if (mdi->dev == dev) {
+			pr_debug("%s: mdev=%p\n", __func__, &mdi->mdev);
+			kref_put(&mdi->refcount, media_device_instance_release);
+			goto done;
+		}
+		pr_debug("%s: media_device_list mdev=%p\n", __func__,
+			&mdi->mdev);
+	}
+	/* search in the media_device_to_delete_list */
+	list_for_each_entry(mdi, &media_device_to_delete_list, list) {
+		if (mdi->dev == dev) {
+			pr_debug("%s: mdev=%p\n", __func__, &mdi->mdev);
+			kref_put(&mdi->refcount,
+				 media_device_instance_release);
+			goto done;
+		}
+		pr_debug("%s: media_device_to_delete_list mdev=%p\n", __func__,
+			&mdi->mdev);
+	}
+done:
+	mutex_unlock(&media_device_lock);
+}
+EXPORT_SYMBOL_GPL(media_device_put);
+
+void media_device_set_to_delete_state(struct device *dev)
+{
+	struct media_device_instance *mdi;
+
+	mutex_lock(&media_device_lock);
+	list_for_each_entry(mdi, &media_device_list, list) {
+		if (mdi->dev == dev) {
+			pr_debug("%s: mdev=%p\n", __func__, &mdi->mdev);
+			mdi->to_delete = true;
+			list_move_tail(&mdi->list,
+				       &media_device_to_delete_list);
+			goto done;
+		}
+	}
+done:
+	mutex_unlock(&media_device_lock);
+}
+EXPORT_SYMBOL_GPL(media_device_set_to_delete_state);
diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
new file mode 100644
index 0000000..6003bad
--- /dev/null
+++ b/include/media/media-dev-allocator.h
@@ -0,0 +1,116 @@
+/*
+ * media-devkref.c - Media Controller Device Allocator API
+ *
+ * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2016 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ */
+
+/*
+ * This file adds Media Controller Device Instance with Kref support.
+ * A system wide global media device list is managed and each media
+ * device is refcounted. The last put on the media device releases
+ * the media device instance.
+*/
+
+#ifndef _MEDIA_DEV_ALLOCTOR_H
+#define _MEDIA_DEV_ALLOCTOR_H
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+/**
+ * DOC: Media Controller Device Allocator API
+ * There are known problems with media device life time management. When media
+ * device is released while an media ioctl is in progress, ioctls fail with
+ * use-after-free errors and kernel hangs in some cases.
+ *
+ * Media Device can be in any the following states:
+ *
+ * - Allocated
+ * - Registered (could be tied to more than one driver)
+ * - Unregistered, not in use (media device file is not open)
+ * - Unregistered, in use (media device file is not open)
+ * - Released
+ *
+ * When media device belongs to  more than one driver, registrations should be
+ * refcounted to avoid unregistering when one of the drivers does unregister.
+ * A refcount field in the struct media_device covers this case. Unregister on
+ * a Media Allocator media device is a kref_put() call. The media device should
+ * be unregistered only when the last unregister occurs.
+ *
+ * When a media device is in use when it is unregistered, it should not be
+ * released until the application exits when it detects the unregistered
+ * status. Media device that is in use when it is unregistered is moved to
+ * to_delete_list. When the last unregister occurs, media device is unregistered
+ * and becomes an unregistered, still allocated device. Unregister marks the
+ * device to be deleted.
+ *
+ * When media device belongs to more than one driver, as both drivers could be
+ * unbound/bound, driver should not end up getting stale media device that is
+ * on its way out. Moving the unregistered media device to to_delete_list helps
+ * this case as well.
+ */
+/**
+ * media_device_get() - Allocate and return global media device
+ *
+ * @mdev
+ *
+ * This interface should be called to allocate media device. A new media
+ * device instance is created and added to the system wide media device
+ * instance list. If media device instance exists, media_device_get()
+ * increments the reference count and returns the media device. When
+ * more than one driver control the media device, the first driver to
+ * probe will allocate and the second driver when it calls media_device_get()
+ * it will get a reference.
+ *
+ */
+struct media_device *media_device_get(struct device *dev);
+/**
+ * media_device_get_ref() - Get reference to an allocated and registered
+ *			    media device.
+ *
+ * @mdev
+ *
+ * This interface should be called to get a reference to an allocated media
+ * device. media_open() ioctl should call this to hold a reference to ensure
+ * the media device will not be released until the media_release() does a put
+ * on it.
+ */
+struct media_device *media_device_get_ref(struct device *dev);
+/**
+ * media_device_find() - Find an allocated and registered media device.
+ *
+ * @mdev
+ *
+ * This interface should be called to find a media device. This will not
+ * incremnet the reference count.
+ */
+struct media_device *media_device_find(struct device *dev);
+/**
+ * media_device_put() - Release refcounted media device. Calls kref_put()
+ *
+ * @mdev
+ *
+ * This interface should be called to decrement refcount.
+ */
+void media_device_put(struct device *dev);
+/**
+ * media_device_set_to_delete_state() - Set the state to be deleted.
+ *
+ * @mdev
+ *
+ * This interface is used to not release the media device under from
+ * an active ioctl if unregister happens.
+ */
+void media_device_set_to_delete_state(struct device *dev);
+#else
+static inline struct media_device *media_device_get(struct device *dev)
+			{ return NULL; }
+static inline struct media_device *media_device_get_ref(struct device *dev);
+static inline struct media_device *media_device_find(struct device *dev)
+			{ return NULL; }
+static inline void media_device_put(struct device *dev) { }
+static inline void media_device_set_to_delete_state(struct device *dev) { }
+#endif /* CONFIG_MEDIA_CONTROLLER */
+#endif
-- 
2.5.0


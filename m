Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-02v.sys.comcast.net ([96.114.154.161]:45089 "EHLO
	resqmta-po-02v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187AbcE0UZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 16:25:40 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	inki.dae@samsung.com, g.liakhovetski@gmx.de,
	jh1009.sung@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] media: Media Device Allocator API
Date: Fri, 27 May 2016 14:25:35 -0600
Message-Id: <1464380735-4527-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media Device Allocator API to allows multiple drivers share a media device.
Using this API, drivers can allocate a media device with the shared struct
device as the key. Once the media device is allocated by a driver, other
drivers can get a reference to it. The media device is released when all
the references are released.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---

Changes since v2:
-- Addressed Hans's comments on v2

 drivers/media/Makefile              |   3 +-
 drivers/media/media-dev-allocator.c | 114 ++++++++++++++++++++++++++++++++++++
 include/media/media-dev-allocator.h |  85 +++++++++++++++++++++++++++
 3 files changed, 201 insertions(+), 1 deletion(-)
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
index 0000000..21d5337
--- /dev/null
+++ b/drivers/media/media-dev-allocator.c
@@ -0,0 +1,114 @@
+/*
+ * media-dev-allocator.c - Media Controller Device Allocator API
+ *
+ * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2016 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ */
+
+/*
+ * This file adds a global refcounted Media Controller Device Instance API.
+ * A system wide global media device list is managed and each media device
+ * includes a kref count. The last put on the media device releases the media
+ * device instance.
+ *
+*/
+
+#include <linux/slab.h>
+#include <linux/kref.h>
+#include <linux/usb.h>
+#include <media/media-device.h>
+
+static LIST_HEAD(media_device_list);
+static DEFINE_MUTEX(media_device_lock);
+
+struct media_device_instance {
+	struct media_device mdev;
+	struct list_head list;
+	struct device *dev;
+	struct kref refcount;
+};
+
+static inline struct media_device_instance *
+to_media_device_instance(struct media_device *mdev)
+{
+	return container_of(mdev, struct media_device_instance, mdev);
+}
+
+static void media_device_instance_release(struct kref *kref)
+{
+	struct media_device_instance *mdi =
+		container_of(kref, struct media_device_instance, refcount);
+
+	dev_dbg(mdi->mdev.dev, "%s: mdev=%p\n", __func__, &mdi->mdev);
+
+	mutex_lock(&media_device_lock);
+
+	media_device_unregister(&mdi->mdev);
+	media_device_cleanup(&mdi->mdev);
+
+	list_del(&mdi->list);
+	mutex_unlock(&media_device_lock);
+
+	kfree(mdi);
+}
+
+/* Callers should hold media_device_lock when calling this function */
+static struct media_device *__media_device_get(struct device *dev)
+{
+	struct media_device_instance *mdi;
+
+	list_for_each_entry(mdi, &media_device_list, list) {
+		if (mdi->dev == dev) {
+			kref_get(&mdi->refcount);
+			dev_dbg(dev, "%s: get mdev=%p\n",
+				 __func__, &mdi->mdev);
+			return &mdi->mdev;
+		}
+	}
+
+	mdi = kzalloc(sizeof(*mdi), GFP_KERNEL);
+	if (!mdi)
+		return NULL;
+
+	mdi->dev = dev;
+	kref_init(&mdi->refcount);
+	list_add_tail(&mdi->list, &media_device_list);
+
+	dev_dbg(dev, "%s: alloc mdev=%p\n", __func__, &mdi->mdev);
+	return &mdi->mdev;
+}
+
+struct media_device *media_device_usb_allocate(struct usb_device *udev,
+					       char *driver_name)
+{
+	struct media_device *mdev;
+
+	mutex_lock(&media_device_lock);
+	mdev = __media_device_get(&udev->dev);
+	if (!mdev) {
+		mutex_unlock(&media_device_lock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* check if media device is already initialized */
+	if (!mdev->dev)
+		__media_device_usb_init(mdev, udev, udev->product,
+					driver_name);
+	mutex_unlock(&media_device_lock);
+
+	dev_dbg(&udev->dev, "%s\n", __func__);
+	return mdev;
+}
+EXPORT_SYMBOL_GPL(media_device_usb_allocate);
+
+void media_device_delete(struct media_device *mdev)
+{
+	struct media_device_instance *mdi = to_media_device_instance(mdev);
+
+	dev_dbg(mdi->mdev.dev, "%s: mdev=%p\n", __func__, &mdi->mdev);
+	kref_put(&mdi->refcount, media_device_instance_release);
+}
+EXPORT_SYMBOL_GPL(media_device_delete);
diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
new file mode 100644
index 0000000..fda032b
--- /dev/null
+++ b/include/media/media-dev-allocator.h
@@ -0,0 +1,85 @@
+/*
+ * media-dev-allocator.h - Media Controller Device Allocator API
+ *
+ * Copyright (c) 2016 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2016 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ * Credits: Suggested by Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ */
+
+/*
+ * This file adds a global ref-counted Media Controller Device Instance API.
+ * A system wide global media device list is managed and each media device
+ * includes a kref count. The last put on the media device releases the media
+ * device instance.
+*/
+
+#ifndef _MEDIA_DEV_ALLOCTOR_H
+#define _MEDIA_DEV_ALLOCTOR_H
+
+struct usb_device;
+
+#ifdef CONFIG_MEDIA_CONTROLLER
+/**
+ * DOC: Media Controller Device Allocator API
+ *
+ * When media device belongs to more than one driver, the shared media device
+ * is allocated with the shared struct device as the key for look ups.
+ *
+ * Shared media device should stay in registered state until the last driver
+ * unregisters it. In addition, media device should be released when all the
+ * references are released. Each driver gets a reference to the media device
+ * during probe, when it allocates the media device. If media device is already
+ * allocated, allocate API bumps up the refcount and return the existing media
+ * device. Driver puts the reference back from its disconnect routine when it
+ * calls media_device_delete().
+ *
+ * Media device is unregistered and cleaned up from the kref put handler to
+ * ensure that the media device stays in registered state until the last driver
+ * unregisters the media device.
+ *
+ * Driver Usage:
+ *
+ * Drivers should use the media-core routines to get register reference and
+ * call media_device_delete() routine to make sure the shared media device
+ * delete is handled correctly.
+ *
+ * driver probe:
+ *	Call media_device_usb_allocate() to allocate or get a reference
+ *	Call media_device_register(), if media devnode isn't registered
+ *
+ * driver disconnect:
+ *	Call media_device_delete() to free the media_device. Free'ing is
+ *	handled by the put handler.
+ *
+ */
+
+/**
+ * media_device_usb_allocate() - Allocate and return media device
+ *
+ * @udev - struct usb_device pointer
+ * @driver_name
+ *
+ * This interface should be called to allocate a media device when multiple
+ * drivers share usb_device and the media device. This interface allocates
+ * media device and calls media_device_usb_init() to initialize it.
+ *
+ */
+struct media_device *media_device_usb_allocate(struct usb_device *udev,
+					       char *driver_name);
+/**
+ * media_device_delete() - Release media device. Calls kref_put().
+ *
+ * @mdev - struct media_device pointer
+ *
+ * This interface should be called to put Media Device Instance kref.
+ */
+void media_device_delete(struct media_device *mdev);
+#else
+static inline struct media_device *media_device_usb_allocate(
+			struct usb_device *udev, char *driver_name)
+			{ return NULL; }
+static inline void media_device_delete(struct media_device *mdev) { }
+#endif /* CONFIG_MEDIA_CONTROLLER */
+#endif
-- 
2.7.4


Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:59450 "EHLO
        resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753176AbcKPO3S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 09:29:18 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@kernel.org, perex@perex.cz, tiwai@suse.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, g.liakhovetski@gmx.de, ONeukum@suse.com,
        k@oikw.org, daniel@zonque.org, mahasler@gmail.com,
        clemens@ladisch.de, geliangtang@163.com, vdronov@redhat.com,
        laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH v4 1/3] media: Media Device Allocator API
Date: Wed, 16 Nov 2016 07:29:09 -0700
Message-Id: <448169cd2db0ba7c8a455bd672e6709e6bada2aa.1479271294.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1479271294.git.shuahkh@osg.samsung.com>
References: <cover.1479271294.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1479271294.git.shuahkh@osg.samsung.com>
References: <cover.1479271294.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Media Device Allocator API to allows multiple drivers share a media device.
Using this API, drivers can allocate a media device with the shared struct
device as the key. Once the media device is allocated by a driver, other
drivers can get a reference to it. The media device is released when all
the references are released.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v3:
- Fixed undefined reference to `__media_device_usb_init compile error when
  CONFIG_USB is disabled.
- Fixed kernel paging error when accessing /dev/mediaX after rmmod of the
  module that owns the media_device. The fix bumps the reference count for
  the owner when second driver comes along to share the media_device. If
  au0828 owns the media_device, then snd_usb_audio will bump the refcount
  for au0828, so it won't get deleted and vice versa.

 drivers/media/Makefile              |   3 +-
 drivers/media/media-dev-allocator.c | 146 ++++++++++++++++++++++++++++++++++++
 include/media/media-dev-allocator.h |  87 +++++++++++++++++++++
 3 files changed, 235 insertions(+), 1 deletion(-)
 create mode 100644 drivers/media/media-dev-allocator.c
 create mode 100644 include/media/media-dev-allocator.h

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 0deaa93..7c0701d 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -6,7 +6,8 @@ ifeq ($(CONFIG_MEDIA_CEC_EDID),y)
   obj-$(CONFIG_MEDIA_SUPPORT) += cec-edid.o
 endif
 
-media-objs	:= media-device.o media-devnode.o media-entity.o
+media-objs	:= media-device.o media-devnode.o media-entity.o \
+		   media-dev-allocator.o
 
 #
 # I2C drivers should come before other drivers, otherwise they'll fail
diff --git a/drivers/media/media-dev-allocator.c b/drivers/media/media-dev-allocator.c
new file mode 100644
index 0000000..014a317
--- /dev/null
+++ b/drivers/media/media-dev-allocator.c
@@ -0,0 +1,146 @@
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
+ */
+
+#include <linux/slab.h>
+#include <linux/kref.h>
+#include <linux/usb.h>
+#include <linux/module.h>
+#include <media/media-device.h>
+
+static LIST_HEAD(media_device_list);
+static DEFINE_MUTEX(media_device_lock);
+
+struct media_device_instance {
+	struct media_device mdev;
+	struct module *owner;
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
+static struct media_device *__media_device_get(struct device *dev,
+					       char *module_name)
+{
+	struct media_device_instance *mdi;
+
+	list_for_each_entry(mdi, &media_device_list, list) {
+		if (mdi->dev == dev) {
+			kref_get(&mdi->refcount);
+			/* get module reference for the media_device owner */
+			if (find_module(module_name) != mdi->owner &&
+			    !try_module_get(mdi->owner))
+				dev_err(dev, "%s: try_module_get() error\n",
+					__func__);
+			dev_dbg(dev, "%s: get mdev=%p module_name %s\n",
+				__func__, &mdi->mdev, module_name);
+			return &mdi->mdev;
+		}
+	}
+
+	mdi = kzalloc(sizeof(*mdi), GFP_KERNEL);
+	if (!mdi)
+		return NULL;
+
+	mdi->dev = dev;
+	mdi->owner = find_module(module_name);
+	kref_init(&mdi->refcount);
+	list_add_tail(&mdi->list, &media_device_list);
+
+	dev_dbg(dev, "%s: alloc mdev=%p module_name %s\n", __func__,
+		&mdi->mdev, module_name);
+	return &mdi->mdev;
+}
+
+#if IS_ENABLED(CONFIG_USB)
+struct media_device *media_device_usb_allocate(struct usb_device *udev,
+					       char *module_name)
+{
+	struct media_device *mdev;
+
+	if (!module_name) {
+		dev_err(&udev->dev, "%s Module Name is null\n", __func__);
+		return ERR_PTR(-EINVAL);
+	}
+
+	mutex_lock(&media_device_lock);
+	mdev = __media_device_get(&udev->dev, module_name);
+	if (!mdev) {
+		mutex_unlock(&media_device_lock);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	/* check if media device is already initialized */
+	if (!mdev->dev)
+		__media_device_usb_init(mdev, udev, udev->product,
+					module_name);
+	mutex_unlock(&media_device_lock);
+
+	dev_dbg(&udev->dev, "%s\n", __func__);
+	return mdev;
+}
+EXPORT_SYMBOL_GPL(media_device_usb_allocate);
+#endif
+
+void media_device_delete(struct media_device *mdev, char *module_name)
+{
+	struct media_device_instance *mdi = to_media_device_instance(mdev);
+
+	if (!module_name) {
+		dev_err(mdi->mdev.dev, "%s Module Name is null\n", __func__);
+		return;
+	}
+
+	dev_dbg(mdi->mdev.dev, "%s: mdev=%p module_name %s\n",
+		__func__, &mdi->mdev, module_name);
+
+	mutex_lock(&media_device_lock);
+	/* put module reference if media_device owner is not THIS_MODULE */
+	if (mdi->owner != find_module(module_name)) {
+		module_put(mdi->owner);
+		dev_dbg(mdi->mdev.dev,
+			"%s decremented owner module reference\n", __func__);
+	}
+	mutex_unlock(&media_device_lock);
+	kref_put(&mdi->refcount, media_device_instance_release);
+}
+EXPORT_SYMBOL_GPL(media_device_delete);
diff --git a/include/media/media-dev-allocator.h b/include/media/media-dev-allocator.h
new file mode 100644
index 0000000..45c437d
--- /dev/null
+++ b/include/media/media-dev-allocator.h
@@ -0,0 +1,87 @@
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
+ */
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
+ * @module_name
+ *
+ * This interface should be called to allocate a media device when multiple
+ * drivers share usb_device and the media device. This interface allocates
+ * media device and calls media_device_usb_init() to initialize it.
+ *
+ */
+struct media_device *media_device_usb_allocate(struct usb_device *udev,
+					       char *module_name);
+/**
+ * media_device_delete() - Release media device. Calls kref_put().
+ *
+ * @mdev - struct media_device pointer
+ * @module_name
+ *
+ * This interface should be called to put Media Device Instance kref.
+ */
+void media_device_delete(struct media_device *mdev, char *driver_name);
+#else
+static inline struct media_device *media_device_usb_allocate(
+			struct usb_device *udev, char *driver_name)
+			{ return NULL; }
+static inline void media_device_delete(
+			struct media_device *mdev, char *module_name) { }
+#endif /* CONFIG_MEDIA_CONTROLLER */
+#endif
-- 
2.7.4


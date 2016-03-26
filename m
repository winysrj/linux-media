Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:49995 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbcCZEiu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Mar 2016 00:38:50 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: laurent.pinchart@ideasonboard.com, mchehab@osg.samsung.com,
	perex@perex.cz, tiwai@suse.com, hans.verkuil@cisco.com,
	chehabrafael@gmail.com, javier@osg.samsung.com,
	jh1009.sung@samsung.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [RFC PATCH 3/4] media: Add refcount to keep track of media device registrations
Date: Fri, 25 Mar 2016 22:38:44 -0600
Message-Id: <dd4a411224763aa8a8e83ba43e2fbf668c2ba15f.1458966594.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1458966594.git.shuahkh@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1458966594.git.shuahkh@osg.samsung.com>
References: <cover.1458966594.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add refcount to keep track of media device registrations to avoid release
of media device when one of the drivers does unregister when media device
belongs to more than one driver. Also add a new interfaces to unregister
a media device allocated using Media Device Allocator and a hold register
refcount. Change media_open() to get media device reference and put the
reference in media_release().

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c  | 53 +++++++++++++++++++++++++++++++++++++++++++
 drivers/media/media-devnode.c |  3 +++
 include/media/media-device.h  | 32 ++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 93aff4e..3359235 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -36,6 +36,7 @@
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
+#include <media/media-dev-allocator.h>
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
@@ -702,6 +703,7 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->entity_notify);
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
+	kref_init(&mdev->refcount);
 
 	dev_dbg(mdev->dev, "Media device initialized\n");
 }
@@ -730,6 +732,13 @@ printk("%s: mdev %p\n", __func__, mdev);
 	/* Check if mdev was ever registered at all */
 	mutex_lock(&mdev->graph_mutex);
 
+	/* if media device is already registered, bump the register refcount */
+	if (media_devnode_is_registered(&mdev->devnode)) {
+		kref_get(&mdev->refcount);
+		mutex_unlock(&mdev->graph_mutex);
+		return 0;
+	}
+
 	/* Register the device node. */
 	mdev->devnode.fops = &media_device_fops;
 	mdev->devnode.parent = mdev->dev;
@@ -756,6 +765,22 @@ err:
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
+void media_device_register_ref(struct media_device *mdev)
+{
+	if (!mdev)
+		return;
+
+	pr_info("%s: mdev %p\n", __func__, mdev);
+	mutex_lock(&mdev->graph_mutex);
+
+	/* Check if mdev is registered - bump registered refcount */
+	if (media_devnode_is_registered(&mdev->devnode))
+		kref_get(&mdev->refcount);
+
+	mutex_unlock(&mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_device_register_ref);
+
 int __must_check media_device_register_entity_notify(struct media_device *mdev,
 					struct media_entity_notify *nptr)
 {
@@ -829,6 +854,34 @@ printk("%s: mdev=%p\n", __func__, mdev);
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
+static void __media_device_unregister_kref(struct kref *kref)
+{
+	struct media_device *mdev;
+
+	mdev = container_of(kref, struct media_device, refcount);
+	__media_device_unregister(mdev);
+}
+
+void media_device_unregister_put(struct media_device *mdev)
+{
+	int ret;
+
+	if (mdev == NULL)
+		return;
+
+	pr_info("%s: mdev=%p\n", __func__, mdev);
+	ret = kref_put_mutex(&mdev->refcount, __media_device_unregister_kref,
+			     &mdev->graph_mutex);
+	if (ret) {
+		/* __media_device_unregister() ran */
+		__media_device_cleanup(mdev);
+		mutex_unlock(&mdev->graph_mutex);
+		mutex_destroy(&mdev->graph_mutex);
+		media_device_set_to_delete_state(mdev->dev);
+	}
+}
+EXPORT_SYMBOL_GPL(media_device_unregister_put);
+
 static void media_device_release_devres(struct device *dev, void *res)
 {
 }
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 29409f4..d1d1263 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -44,6 +44,7 @@
 #include <linux/uaccess.h>
 
 #include <media/media-devnode.h>
+#include <media/media-dev-allocator.h>
 
 #define MEDIA_NUM_DEVICES	256
 #define MEDIA_NAME		"media"
@@ -186,6 +187,7 @@ static int media_open(struct inode *inode, struct file *filp)
 		}
 	}
 
+	media_device_get_ref(mdev->parent);
 	return 0;
 }
 
@@ -201,6 +203,7 @@ static int media_release(struct inode *inode, struct file *filp)
 	   return value is ignored. */
 	put_device(&mdev->dev);
 	filp->private_data = NULL;
+	media_device_put(mdev->parent);
 	return 0;
 }
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index e59772e..64114ae 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -284,6 +284,8 @@ struct media_entity_notify {
  * struct media_device - Media device
  * @dev:	Parent device
  * @devnode:	Media device node
+ * @refcount:	Media device register reference count. Used when more
+ *		than one driver owns the device.
  * @driver_name: Optional device driver name. If not set, calls to
  *		%MEDIA_IOC_DEVICE_INFO will return dev->driver->name.
  *		This is needed for USB drivers for example, as otherwise
@@ -348,6 +350,7 @@ struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
 	struct media_devnode devnode;
+	struct kref refcount;
 
 	char model[32];
 	char driver_name[32];
@@ -501,6 +504,17 @@ int __must_check __media_device_register(struct media_device *mdev,
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
 
 /**
+ * media_device_register_ref() - Increments media device register refcount
+ *
+ * @mdev:	pointer to struct &media_device
+ *
+ * When more than one driver is associated with the media device, it is
+ * necessary to refcount the number of registrations to avoid unregister
+ * when it is still in use.
+ */
+void media_device_register_ref(struct media_device *mdev);
+
+/**
  * media_device_unregister() - Unregisters a media device element
  *
  * @mdev:	pointer to struct &media_device
@@ -512,6 +526,18 @@ int __must_check __media_device_register(struct media_device *mdev,
 void media_device_unregister(struct media_device *mdev);
 
 /**
+ * media_device_unregister_put() - Unregisters a media device element
+ *
+ * @mdev:	pointer to struct &media_device
+ *
+ * Should be called to unregister media device allocated with Media Device
+ * Allocator API media_device_get() interface.
+ * It is safe to call this function on an unregistered (but initialised)
+ * media device.
+ */
+void media_device_unregister_put(struct media_device *mdev);
+
+/**
  * media_device_register_entity() - registers a media entity inside a
  *	previously registered media device.
  *
@@ -681,9 +707,15 @@ static inline int media_device_register(struct media_device *mdev)
 {
 	return 0;
 }
+static inline void media_device_register_ref(struct media_device *mdev)
+{
+}
 static inline void media_device_unregister(struct media_device *mdev)
 {
 }
+static inline void media_device_unregister_put(struct media_device *mdev)
+{
+}
 static inline int media_device_register_entity(struct media_device *mdev,
 						struct media_entity *entity)
 {
-- 
2.5.0


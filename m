Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:50264 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbcDEDgL (ORCPT
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
Subject: [RFC PATCH v2 2/5] media: Add driver count to keep track of media device registrations
Date: Mon,  4 Apr 2016 21:35:57 -0600
Message-Id: <07bb92168242dc8a30338cf2978b22ec31395dc3.1459825702.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1459825702.git.shuahkh@osg.samsung.com>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1459825702.git.shuahkh@osg.samsung.com>
References: <cover.1459825702.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add driver count to keep track of media device registrations to avoid
releasing the media device, when one of the drivers does unregister when
media device belongs to more than one driver. Also add a new interfaces
to unregister a media device allocated using Media Device Allocator and
a increment register count.

Change media_open() to get media device reference and put the reference
in media_release().

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 drivers/media/media-device.c  | 49 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/media/media-devnode.c | 10 ++++++---
 include/media/media-device.h  | 31 +++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6e43c95..f22cf0f 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -36,6 +36,7 @@
 #include <media/media-device.h>
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
+#include <media/media-dev-allocator.h>
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 
@@ -743,12 +744,31 @@ int __must_check __media_device_register(struct media_device *mdev,
 		return ret;
 	}
 
-	dev_dbg(mdev->dev, "Media device registered\n");
+	mdev->num_drivers++;
+	dev_dbg(mdev->dev, "Media device registered num_drivers %d\n",
+		mdev->num_drivers);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
+void media_device_register_ref(struct media_device *mdev)
+{
+	if (!mdev)
+		return;
+
+	mutex_lock(&mdev->graph_mutex);
+
+	/* Check if mdev is registered - bump registered driver count */
+	if (media_devnode_is_registered(&mdev->devnode))
+		mdev->num_drivers++;
+
+	dev_dbg(mdev->dev, "%s: mdev %p num_drivers %d\n", __func__, mdev,
+		mdev->num_drivers);
+	mutex_unlock(&mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_device_register_ref);
+
 int __must_check media_device_register_entity_notify(struct media_device *mdev,
 					struct media_entity_notify *nptr)
 {
@@ -820,6 +840,33 @@ void media_device_unregister(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_unregister);
 
+void media_device_unregister_put(struct media_device *mdev)
+{
+	if (mdev == NULL)
+		return;
+
+	dev_dbg(mdev->dev, "%s: mdev %p num_drivers %d\n", __func__, mdev,
+		mdev->num_drivers);
+
+	mutex_lock(&mdev->graph_mutex);
+	mdev->num_drivers--;
+	if (mdev->num_drivers == 0) {
+		mutex_unlock(&mdev->graph_mutex);
+
+		/* unregister media device and cleanup */
+		media_device_unregister(mdev);
+		media_device_cleanup(mdev);
+
+		/* mark the media device for deletion */
+		media_device_set_to_delete_state(mdev->dev);
+	} else
+		mutex_unlock(&mdev->graph_mutex);
+
+	dev_dbg(mdev->dev, "%s: end mdev %p num_drivers %d\n", __func__, mdev,
+		mdev->num_drivers);
+}
+EXPORT_SYMBOL_GPL(media_device_unregister_put);
+
 static void media_device_release_devres(struct device *dev, void *res)
 {
 }
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 29409f4..ec18815 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -44,6 +44,7 @@
 #include <linux/uaccess.h>
 
 #include <media/media-devnode.h>
+#include <media/media-dev-allocator.h>
 
 #define MEDIA_NUM_DEVICES	256
 #define MEDIA_NAME		"media"
@@ -173,7 +174,6 @@ static int media_open(struct inode *inode, struct file *filp)
 	}
 	/* and increase the device refcount */
 	get_device(&mdev->dev);
-	mutex_unlock(&media_devnode_lock);
 
 	filp->private_data = mdev;
 
@@ -182,11 +182,14 @@ static int media_open(struct inode *inode, struct file *filp)
 		if (ret) {
 			put_device(&mdev->dev);
 			filp->private_data = NULL;
-			return ret;
+			goto done;
 		}
 	}
 
-	return 0;
+	media_device_get_ref(mdev->parent);
+done:
+	mutex_unlock(&media_devnode_lock);
+	return ret;
 }
 
 /* Override for the release function */
@@ -201,6 +204,7 @@ static int media_release(struct inode *inode, struct file *filp)
 	   return value is ignored. */
 	put_device(&mdev->dev);
 	filp->private_data = NULL;
+	media_device_put(mdev->parent);
 	return 0;
 }
 
diff --git a/include/media/media-device.h b/include/media/media-device.h
index df74cfa..aaeac7a 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -284,6 +284,7 @@ struct media_entity_notify {
  * struct media_device - Media device
  * @dev:	Parent device
  * @devnode:	Media device node
+ * @num_drivers: Number of drivers that own the media device and register.
  * @driver_name: Optional device driver name. If not set, calls to
  *		%MEDIA_IOC_DEVICE_INFO will return dev->driver->name.
  *		This is needed for USB drivers for example, as otherwise
@@ -349,6 +350,7 @@ struct media_device {
 	/* dev->driver_data points to this struct. */
 	struct device *dev;
 	struct media_devnode devnode;
+	int num_drivers;
 
 	char model[32];
 	char driver_name[32];
@@ -494,6 +496,17 @@ int __must_check __media_device_register(struct media_device *mdev,
 #define media_device_register(mdev) __media_device_register(mdev, THIS_MODULE)
 
 /**
+ * media_device_register_ref() - Increments media device register driver count
+ *
+ * @mdev:	pointer to struct &media_device
+ *
+ * When more than one driver is associated with the media device, it is
+ * necessary to maintain the number of registrations to avoid unregister
+ * when it is still in use.
+ */
+void media_device_register_ref(struct media_device *mdev);
+
+/**
  * __media_device_unregister() - Unegisters a media device element
  *
  * @mdev:	pointer to struct &media_device
@@ -505,6 +518,18 @@ int __must_check __media_device_register(struct media_device *mdev,
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
@@ -661,9 +686,15 @@ static inline int media_device_register(struct media_device *mdev)
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


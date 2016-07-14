Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40472 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752092AbcGNWfZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:25 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: [RFC 06/16] media: Dynamically allocate the media device
Date: Fri, 15 Jul 2016 01:35:01 +0300
Message-Id: <1468535711-13836-7-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Allow allocating the media device dynamically. As the struct media_device
embeds struct media_devnode, the lifetime of that object is that same than
that of the media_device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 28 ++++++++++++++++++++++++++--
 include/media/media-device.h | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index a11b3be..1bab2c6 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -543,9 +543,18 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
  * Registration/unregistration
  */
 
-static void media_device_release(struct media_devnode *mdev)
+static void media_device_release(struct media_devnode *devnode)
 {
-	dev_dbg(mdev->parent, "Media device released\n");
+	struct media_device *mdev = to_media_device(devnode);
+
+	ida_destroy(&mdev->entity_internal_idx);
+	mdev->entity_internal_idx_max = 0;
+	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
+	mutex_destroy(&mdev->graph_mutex);
+	dev_dbg(devnode->parent, "Media device released\n");
+
+	if (devnode->use_kref)
+		kfree(mdev);
 }
 
 /**
@@ -692,6 +701,21 @@ void media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
+struct media_device *media_device_alloc(void)
+{
+	struct media_device *mdev;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return NULL;
+
+	media_devnode_init(&mdev->devnode);
+	media_device_init(mdev);
+
+	return mdev;
+}
+EXPORT_SYMBOL_GPL(media_device_alloc);
+
 void media_device_cleanup(struct media_device *mdev)
 {
 	ida_destroy(&mdev->entity_internal_idx);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index a9b33c4..cb5722b 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -428,6 +428,42 @@ static inline __must_check int media_entity_enum_init(
 void media_device_init(struct media_device *mdev);
 
 /**
+ * media_device_alloc() - Allocate and initialise a media device
+ *
+ * Allocate and initialise a media device. Returns a media device.
+ * The media device is refcounted, and this function returns a media
+ * device the refcount of which is one (1).
+ *
+ * References are taken and given using media_device_get() and
+ * media_device_put().
+ */
+struct media_device *media_device_alloc(void);
+
+/**
+ * media_device_get() - Get a reference to a media device
+ *
+ * mdev: media device
+ */
+#define media_device_get(mdev)						\
+	do {								\
+		dev_dbg((mdev)->dev, "%s: get media device %s\n",	\
+			__func__, (mdev)->bus_info);			\
+		media_devnode_get(&(mdev)->devnode);			\
+	} while (0)
+
+/**
+ * media_device_put() - Put a reference to a media device
+ *
+ * mdev: media device
+ */
+#define media_device_put(mdev)						\
+	do {								\
+		dev_dbg((mdev)->dev, "%s: put media device %s\n",	\
+			__func__, (mdev)->bus_info);			\
+		media_devnode_put(&(mdev)->devnode);			\
+	} while (0)
+
+/**
  * media_device_cleanup() - Cleanups a media device element
  *
  * @mdev:	pointer to struct &media_device
@@ -654,6 +690,8 @@ void __media_device_usb_init(struct media_device *mdev,
 			     const char *driver_name);
 
 #else
+#define media_device_get(mdev) do { } while (0)
+#define media_device_put(mdev) do { } while (0)
 static inline int media_device_register(struct media_device *mdev)
 {
 	return 0;
-- 
2.1.4


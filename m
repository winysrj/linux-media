Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35300 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752087AbcKHNzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:36 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 11/21] media device: Refcount the media device
Date: Tue,  8 Nov 2016 15:55:20 +0200
Message-Id: <1478613330-24691-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the struct media_device embeds struct media_devnode, the lifetime of
that object must be that same than that of the media_device.

References are obtained by media_entity_get() and released by
media_entity_put(). In case a driver uses media_device_alloc() to allocate
its media device, it must release the media device by calling
media_device_put() rather than media_device_cleanup().

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 13 +++++++++++++
 include/media/media-device.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 0920c02..e9f6e76 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -712,6 +712,17 @@ void media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
+static void media_device_release(struct media_devnode *devnode)
+{
+	struct media_device *mdev = to_media_device(devnode);
+
+	dev_dbg(devnode->parent, "Media device released\n");
+
+	media_device_cleanup(mdev);
+
+	kfree(mdev);
+}
+
 struct media_device *media_device_alloc(struct device *dev)
 {
 	struct media_device *mdev;
@@ -723,6 +734,8 @@ struct media_device *media_device_alloc(struct device *dev)
 	mdev->dev = dev;
 	media_device_init(mdev);
 
+	mdev->devnode.release = media_device_release;
+
 	return mdev;
 }
 EXPORT_SYMBOL_GPL(media_device_alloc);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index c9b5798..fc0d82a 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -212,10 +212,39 @@ void media_device_init(struct media_device *mdev);
  * @dev:	The associated struct device pointer
  *
  * Allocate and initialise a media device. Returns a media device.
+ * The media device is refcounted, and this function returns a media
+ * device the refcount of which is one (1).
+ *
+ * References are taken and given using media_device_get() and
+ * media_device_put().
  */
 struct media_device *media_device_alloc(struct device *dev);
 
 /**
+ * media_device_get() - Get a reference to a media device
+ *
+ * mdev: media device
+ */
+#define media_device_get(mdev)						\
+	do {								\
+		dev_dbg((mdev)->dev, "%s: get media device %s\n",	\
+			__func__, (mdev)->bus_info);			\
+		get_device(&(mdev)->devnode.dev);			\
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
+		put_device(&(mdev)->devnode.dev);			\
+	} while (0)
+
+/**
  * media_device_cleanup() - Cleanups a media device element
  *
  * @mdev:	pointer to struct &media_device
@@ -464,6 +493,8 @@ static inline struct media_device *media_device_alloc(struct device *dev)
 {
 	return NULL;
 }
+#define media_device_get(mdev) do { } while (0)
+#define media_device_put(mdev) do { } while (0)
 static inline int media_device_register(struct media_device *mdev)
 {
 	return 0;
-- 
2.1.4


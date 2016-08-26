Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54116 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754702AbcHZXop (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:45 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [RFC v3 08/21] media: Enable allocating the media device dynamically
Date: Sat, 27 Aug 2016 02:43:16 +0300
Message-Id: <1472255009-28719-9-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Allow allocating the media device dynamically. As the struct media_device
embeds struct media_devnode, the lifetime of that object is that same than
that of the media_device.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 15 +++++++++++++++
 include/media/media-device.h | 13 +++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index d90d8c6..6eca50c 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -686,6 +686,21 @@ void media_device_init(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_init);
 
+struct media_device *media_device_alloc(struct device *dev)
+{
+	struct media_device *mdev;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return NULL;
+
+	mdev->dev = dev;
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
index 4eee613..1fdfbd7 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -197,6 +197,15 @@ static inline __must_check int media_entity_enum_init(
 void media_device_init(struct media_device *mdev);
 
 /**
+ * media_device_alloc() - Allocate and initialise a media device
+ *
+ * @dev:	The associated struct device pointer
+ *
+ * Allocate and initialise a media device. Returns a media device.
+ */
+struct media_device *media_device_alloc(struct device *dev);
+
+/**
  * media_device_cleanup() - Cleanups a media device element
  *
  * @mdev:	pointer to struct &media_device
@@ -425,6 +434,10 @@ void __media_device_usb_init(struct media_device *mdev,
 			     const char *driver_name);
 
 #else
+static inline struct media_device *media_device_alloc(struct device *dev)
+{
+	return NULL;
+}
 static inline int media_device_register(struct media_device *mdev)
 {
 	return 0;
-- 
2.1.4


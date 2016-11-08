Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35270 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751934AbcKHNzf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:35 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [RFC v4 08/21] media: Enable allocating the media device dynamically
Date: Tue,  8 Nov 2016 15:55:17 +0200
Message-Id: <1478613330-24691-8-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
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
index a31329d..496195e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -684,6 +684,21 @@ void media_device_init(struct media_device *mdev)
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
index 96de915..c9b5798 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -207,6 +207,15 @@ static inline __must_check int media_entity_enum_init(
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
@@ -451,6 +460,10 @@ void __media_device_usb_init(struct media_device *mdev,
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


Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35298 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752077AbcKHNzg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Nov 2016 08:55:36 -0500
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v4 10/21] media: Shuffle functions around
Date: Tue,  8 Nov 2016 15:55:19 +0200
Message-Id: <1478613330-24691-10-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk>
 <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the call paths of the functions in question will change, move them
around in anticipation of that. No other changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 56 ++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c79a9f5..0920c02 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -660,6 +660,34 @@ void media_device_unregister_entity(struct media_entity *entity)
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
+int __must_check media_device_register_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	mutex_lock(&mdev->graph_mutex);
+	list_add_tail(&nptr->list, &mdev->entity_notify);
+	mutex_unlock(&mdev->graph_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(media_device_register_entity_notify);
+
+/*
+ * Note: Should be called with mdev->lock held.
+ */
+static void __media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	list_del(&nptr->list);
+}
+
+void media_device_unregister_entity_notify(struct media_device *mdev,
+					struct media_entity_notify *nptr)
+{
+	mutex_lock(&mdev->graph_mutex);
+	__media_device_unregister_entity_notify(mdev, nptr);
+	mutex_unlock(&mdev->graph_mutex);
+}
+EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
+
 /**
  * media_device_init() - initialize a media device
  * @mdev:	The media device
@@ -743,34 +771,6 @@ int __must_check __media_device_register(struct media_device *mdev,
 }
 EXPORT_SYMBOL_GPL(__media_device_register);
 
-int __must_check media_device_register_entity_notify(struct media_device *mdev,
-					struct media_entity_notify *nptr)
-{
-	mutex_lock(&mdev->graph_mutex);
-	list_add_tail(&nptr->list, &mdev->entity_notify);
-	mutex_unlock(&mdev->graph_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(media_device_register_entity_notify);
-
-/*
- * Note: Should be called with mdev->lock held.
- */
-static void __media_device_unregister_entity_notify(struct media_device *mdev,
-					struct media_entity_notify *nptr)
-{
-	list_del(&nptr->list);
-}
-
-void media_device_unregister_entity_notify(struct media_device *mdev,
-					struct media_entity_notify *nptr)
-{
-	mutex_lock(&mdev->graph_mutex);
-	__media_device_unregister_entity_notify(mdev, nptr);
-	mutex_unlock(&mdev->graph_mutex);
-}
-EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
-
 void media_device_unregister(struct media_device *mdev)
 {
 	struct media_entity *entity;
-- 
2.1.4


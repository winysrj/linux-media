Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54122 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754705AbcHZXop (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:45 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 10/21] media: Shuffle functions around
Date: Sat, 27 Aug 2016 02:43:18 +0300
Message-Id: <1472255009-28719-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
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
index 9765031..3b96de5 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -662,6 +662,34 @@ void media_device_unregister_entity(struct media_entity *entity)
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
@@ -745,34 +773,6 @@ out_put:
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


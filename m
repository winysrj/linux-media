Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40490 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752194AbcGNWf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 18:35:26 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: [RFC 12/16] media: Shuffle functions around
Date: Fri, 15 Jul 2016 01:35:07 +0300
Message-Id: <1468535711-13836-13-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1468535711-13836-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the call paths of the functions in question will change, move them
around in anticipation of that. No other changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 90 ++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7538572..26fe37f 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -543,23 +543,6 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
  * Registration/unregistration
  */
 
-static void media_device_release(struct media_devnode *devnode)
-{
-	struct media_device *mdev = to_media_device(devnode);
-
-	ida_destroy(&mdev->entity_internal_idx);
-	mdev->entity_internal_idx_max = 0;
-	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
-	mutex_destroy(&mdev->graph_mutex);
-	dev_dbg(devnode->parent, "Media device released\n");
-
-	if (mdev->release)
-		mdev->release(mdev);
-
-	if (devnode->use_kref)
-		kfree(mdev);
-}
-
 /**
  * media_device_register_entity - Register an entity with a media device
  * @mdev:	The media device
@@ -680,6 +663,34 @@ void media_device_unregister_entity(struct media_entity *entity)
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
@@ -744,6 +755,23 @@ void media_device_cleanup(struct media_device *mdev)
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
 
+static void media_device_release(struct media_devnode *devnode)
+{
+	struct media_device *mdev = to_media_device(devnode);
+
+	ida_destroy(&mdev->entity_internal_idx);
+	mdev->entity_internal_idx_max = 0;
+	media_entity_graph_walk_cleanup(&mdev->pm_count_walk);
+	mutex_destroy(&mdev->graph_mutex);
+	dev_dbg(devnode->parent, "Media device released\n");
+
+	if (mdev->release)
+		mdev->release(mdev);
+
+	if (devnode->use_kref)
+		kfree(mdev);
+}
+
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
 {
@@ -773,34 +801,6 @@ int __must_check __media_device_register(struct media_device *mdev,
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


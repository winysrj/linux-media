Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46850 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754299AbcHSKYG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 06:24:06 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v2 13/17] media: Shuffle functions around
Date: Fri, 19 Aug 2016 13:23:44 +0300
Message-Id: <1471602228-30722-14-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the call paths of the functions in question will change, move them
around in anticipation of that. No other changes.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 88 ++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 7f90cb82..0656daf 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -542,22 +542,6 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
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
-	kfree(mdev);
-}
-
 /**
  * media_device_register_entity - Register an entity with a media device
  * @mdev:	The media device
@@ -678,6 +662,34 @@ void media_device_unregister_entity(struct media_entity *entity)
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
@@ -741,6 +753,22 @@ void media_device_cleanup(struct media_device *mdev)
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
+	kfree(mdev);
+}
+
 int __must_check __media_device_register(struct media_device *mdev,
 					 struct module *owner)
 {
@@ -770,34 +798,6 @@ int __must_check __media_device_register(struct media_device *mdev,
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


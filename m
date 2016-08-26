Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54114 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754725AbcHZXor (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 Aug 2016 19:44:47 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org, hverkuil@xs4all.nl
Cc: mchehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
Subject: [RFC v3 18/21] media-device: Postpone graph object removal until free
Date: Sat, 27 Aug 2016 02:43:26 +0300
Message-Id: <1472255009-28719-19-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The media device itself will be unregistered based on it being unbound and
driver's remove callback being called. The graph objects themselves may
still be in use; rely on the media device release callback to release
them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/media-device.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 82ae07a..beb9372 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -719,6 +719,26 @@ EXPORT_SYMBOL_GPL(media_device_init);
 static void media_device_release(struct media_devnode *devnode)
 {
 	struct media_device *mdev = to_media_device(devnode);
+	struct media_entity *entity;
+	struct media_entity *next;
+	struct media_interface *intf, *tmp_intf;
+	struct media_entity_notify *notify, *nextp;
+
+	/* Remove all entities from the media device */
+	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
+		__media_device_unregister_entity(entity);
+
+	/* Remove all entity_notify callbacks from the media device */
+	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
+		__media_device_unregister_entity_notify(mdev, notify);
+
+	/* Remove all interfaces from the media device */
+	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
+				 graph_obj.list) {
+		__media_remove_intf_links(intf);
+		media_gobj_destroy(&intf->graph_obj);
+		kfree(intf);
+	}
 
 	dev_dbg(devnode->parent, "Media device released\n");
 
@@ -799,38 +819,14 @@ EXPORT_SYMBOL_GPL(__media_device_register);
 
 void media_device_unregister(struct media_device *mdev)
 {
-	struct media_entity *entity;
-	struct media_entity *next;
-	struct media_interface *intf, *tmp_intf;
-	struct media_entity_notify *notify, *nextp;
-
 	if (mdev == NULL)
 		return;
 
 	mutex_lock(&mdev->graph_mutex);
-
-	/* Check if mdev was ever registered at all */
 	if (!media_devnode_is_registered(&mdev->devnode)) {
 		mutex_unlock(&mdev->graph_mutex);
 		return;
 	}
-
-	/* Remove all entities from the media device */
-	list_for_each_entry_safe(entity, next, &mdev->entities, graph_obj.list)
-		__media_device_unregister_entity(entity);
-
-	/* Remove all entity_notify callbacks from the media device */
-	list_for_each_entry_safe(notify, nextp, &mdev->entity_notify, list)
-		__media_device_unregister_entity_notify(mdev, notify);
-
-	/* Remove all interfaces from the media device */
-	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
-				 graph_obj.list) {
-		__media_remove_intf_links(intf);
-		media_gobj_destroy(&intf->graph_obj);
-		kfree(intf);
-	}
-
 	mutex_unlock(&mdev->graph_mutex);
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
-- 
2.1.4


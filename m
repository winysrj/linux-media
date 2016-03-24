Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40247 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbcCXWWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 18:22:48 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 2/2] Revert "[media] media-device: get rid of the spinlock"
Date: Fri, 25 Mar 2016 00:22:44 +0200
Message-Id: <1458858164-1066-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458858164-1066-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458858164-1066-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit c38077d39c7eb84f031b072eab8009acfff57134 that
introduced a deadlock.

[ 2760.127749] INFO: task media-ctl:954 blocked for more than 120 seconds.
[ 2760.131867]       Not tainted 4.5.0+ #357
[ 2760.134622] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2760.139310] media-ctl       D ffffffc000086bcc     0   954    671 0x00000001
[ 2760.143618] Call trace:
[ 2760.145601] [<ffffffc000086bcc>] __switch_to+0x90/0xa4
[ 2760.148941] [<ffffffc0004e6ef0>] __schedule+0x188/0x5b0
[ 2760.152309] [<ffffffc0004e7354>] schedule+0x3c/0xa0
[ 2760.155495] [<ffffffc0004e7768>] schedule_preempt_disabled+0x20/0x38
[ 2760.159423] [<ffffffc0004e8d28>] __mutex_lock_slowpath+0xc4/0x148
[ 2760.163217] [<ffffffc0004e8df0>] mutex_lock+0x44/0x5c
[ 2760.166483] [<ffffffc0003e87d4>] find_entity+0x2c/0xac
[ 2760.169773] [<ffffffc0003e8d34>] __media_device_enum_links+0x20/0x1dc
[ 2760.173711] [<ffffffc0003e9718>] media_device_ioctl+0x214/0x33c
[ 2760.177384] [<ffffffc0003e9eec>] media_ioctl+0x24/0x3c
[ 2760.180671] [<ffffffc0001bee64>] do_vfs_ioctl+0xac/0x758
[ 2760.184026] [<ffffffc0001bf594>] SyS_ioctl+0x84/0x98
[ 2760.187196] [<ffffffc000085d30>] el0_svc_naked+0x24/0x28

Fixes: c38077d39c7e ("[media] media-device: get rid of the spinlock")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/media-device.c | 32 ++++++++++++++++++--------------
 drivers/media/media-entity.c | 16 ++++++++--------
 include/media/media-device.h |  6 +++++-
 3 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c32fa15cc76e..6e43c95629ea 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -90,17 +90,17 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 
 	id &= ~MEDIA_ENT_ID_FLAG_NEXT;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 
 	media_device_for_each_entity(entity, mdev) {
 		if (((media_entity_id(entity) == id) && !next) ||
 		    ((media_entity_id(entity) > id) && next)) {
-			mutex_unlock(&mdev->graph_mutex);
+			spin_unlock(&mdev->lock);
 			return entity;
 		}
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->lock);
 
 	return NULL;
 }
@@ -590,12 +590,12 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	if (!ida_pre_get(&mdev->entity_internal_idx, GFP_KERNEL))
 		return -ENOMEM;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 
 	ret = ida_get_new_above(&mdev->entity_internal_idx, 1,
 				&entity->internal_idx);
 	if (ret < 0) {
-		mutex_unlock(&mdev->graph_mutex);
+		spin_unlock(&mdev->lock);
 		return ret;
 	}
 
@@ -615,6 +615,9 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 		(notify)->notify(entity, notify->notify_data);
 	}
 
+	spin_unlock(&mdev->lock);
+
+	mutex_lock(&mdev->graph_mutex);
 	if (mdev->entity_internal_idx_max
 	    >= mdev->pm_count_walk.ent_enum.idx_max) {
 		struct media_entity_graph new = { .top = 0 };
@@ -677,9 +680,9 @@ void media_device_unregister_entity(struct media_entity *entity)
 	if (mdev == NULL)
 		return;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 	__media_device_unregister_entity(entity);
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
@@ -700,6 +703,7 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->pads);
 	INIT_LIST_HEAD(&mdev->links);
 	INIT_LIST_HEAD(&mdev->entity_notify);
+	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
 
@@ -748,9 +752,9 @@ EXPORT_SYMBOL_GPL(__media_device_register);
 int __must_check media_device_register_entity_notify(struct media_device *mdev,
 					struct media_entity_notify *nptr)
 {
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 	list_add_tail(&nptr->list, &mdev->entity_notify);
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->lock);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity_notify);
@@ -767,9 +771,9 @@ static void __media_device_unregister_entity_notify(struct media_device *mdev,
 void media_device_unregister_entity_notify(struct media_device *mdev,
 					struct media_entity_notify *nptr)
 {
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 	__media_device_unregister_entity_notify(mdev, nptr);
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
 
@@ -783,11 +787,11 @@ void media_device_unregister(struct media_device *mdev)
 	if (mdev == NULL)
 		return;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 
 	/* Check if mdev was ever registered at all */
 	if (!media_devnode_is_registered(&mdev->devnode)) {
-		mutex_unlock(&mdev->graph_mutex);
+		spin_unlock(&mdev->lock);
 		return;
 	}
 
@@ -807,7 +811,7 @@ void media_device_unregister(struct media_device *mdev)
 		kfree(intf);
 	}
 
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->lock);
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index c53c1d5589a0..e95070b3a3d4 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -219,7 +219,7 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 	entity->pads = pads;
 
 	if (mdev)
-		mutex_lock(&mdev->graph_mutex);
+		spin_lock(&mdev->lock);
 
 	for (i = 0; i < num_pads; i++) {
 		pads[i].entity = entity;
@@ -230,7 +230,7 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 	}
 
 	if (mdev)
-		mutex_unlock(&mdev->graph_mutex);
+		spin_unlock(&mdev->lock);
 
 	return 0;
 }
@@ -747,9 +747,9 @@ void media_entity_remove_links(struct media_entity *entity)
 	if (mdev == NULL)
 		return;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 	__media_entity_remove_links(entity);
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_entity_remove_links);
 
@@ -951,9 +951,9 @@ void media_remove_intf_link(struct media_link *link)
 	if (mdev == NULL)
 		return;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 	__media_remove_intf_link(link);
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_link);
 
@@ -975,8 +975,8 @@ void media_remove_intf_links(struct media_interface *intf)
 	if (mdev == NULL)
 		return;
 
-	mutex_lock(&mdev->graph_mutex);
+	spin_lock(&mdev->lock);
 	__media_remove_intf_links(intf);
-	mutex_unlock(&mdev->graph_mutex);
+	spin_unlock(&mdev->lock);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_links);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index b21ef244ad3e..07809f698464 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -25,6 +25,7 @@
 
 #include <linux/list.h>
 #include <linux/mutex.h>
+#include <linux/spinlock.h>
 
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
@@ -303,7 +304,8 @@ struct media_entity_notify {
  * @pads:	List of registered pads
  * @links:	List of registered links
  * @entity_notify: List of registered entity_notify callbacks
- * @graph_mutex: Protects access to struct media_device data
+ * @lock:	Entities list lock
+ * @graph_mutex: Entities graph operation lock
  * @pm_count_walk: Graph walk for power state walk. Access serialised using
  *		   graph_mutex.
  *
@@ -369,6 +371,8 @@ struct media_device {
 	/* notify callback list invoked when a new entity is registered */
 	struct list_head entity_notify;
 
+	/* Protects the graph objects creation/removal */
+	spinlock_t lock;
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
 	struct media_entity_graph pm_count_walk;
-- 
2.7.3


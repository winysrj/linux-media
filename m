Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:57375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbcDFNz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Apr 2016 09:55:28 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] [media] media-device: get rid of the spinlock
Date: Wed,  6 Apr 2016 06:55:24 -0700
Message-Id: <cf3f7fec1241c22f49cbe8205c2b1129eb4bb3d7.1459950922.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Right now, the lock schema for media_device struct is messy,
since sometimes, it is protected via a spin lock, while, for
media graph traversal, it is protected by a mutex.

Solve this conflict by always using a mutex.

As a side effect, this prevents a bug when the media notifiers
is called at atomic context, while running the notifier callback:

 BUG: sleeping function called from invalid context at mm/slub.c:1289
 in_atomic(): 1, irqs_disabled(): 0, pid: 3479, name: modprobe
 4 locks held by modprobe/3479:
 #0:  (&dev->mutex){......}, at: [<ffffffff81ce8933>] __driver_attach+0xa3/0x160
 #1:  (&dev->mutex){......}, at: [<ffffffff81ce8941>] __driver_attach+0xb1/0x160
 #2:  (register_mutex#5){+.+.+.}, at: [<ffffffffa10596c7>] usb_audio_probe+0x257/0x1c90 [snd_usb_audio]
 #3:  (&(&mdev->lock)->rlock){+.+.+.}, at: [<ffffffffa0e6051b>] media_device_register_entity+0x1cb/0x700 [media]
 CPU: 2 PID: 3479 Comm: modprobe Not tainted 4.5.0-rc3+ #49
 Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
 0000000000000000 ffff8803b3f6f288 ffffffff81933901 ffff8803c4bae000
 ffff8803c4bae5c8 ffff8803b3f6f2b0 ffffffff811c6af5 ffff8803c4bae000
 ffffffff8285d7f6 0000000000000509 ffff8803b3f6f2f0 ffffffff811c6ce5
 Call Trace:
 [<ffffffff81933901>] dump_stack+0x85/0xc4
 [<ffffffff811c6af5>] ___might_sleep+0x245/0x3a0
 [<ffffffff811c6ce5>] __might_sleep+0x95/0x1a0
 [<ffffffff8155aade>] kmem_cache_alloc_trace+0x20e/0x300
 [<ffffffffa0e66e3d>] ? media_add_link+0x4d/0x140 [media]
 [<ffffffffa0e66e3d>] media_add_link+0x4d/0x140 [media]
 [<ffffffffa0e69931>] media_create_pad_link+0xa1/0x600 [media]
 [<ffffffffa0fe11b3>] au0828_media_graph_notify+0x173/0x360 [au0828]
 [<ffffffffa0e68a6a>] ? media_gobj_create+0x1ba/0x480 [media]
 [<ffffffffa0e606fb>] media_device_register_entity+0x3ab/0x700 [media]

Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/media-device.c | 39 +++++++++++++--------------------------
 drivers/media/media-entity.c | 16 ++++++++--------
 include/media/media-device.h |  6 +-----
 3 files changed, 22 insertions(+), 39 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 6e43c95629ea..898a3cf814ba 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -90,18 +90,13 @@ static struct media_entity *find_entity(struct media_device *mdev, u32 id)
 
 	id &= ~MEDIA_ENT_ID_FLAG_NEXT;
 
-	spin_lock(&mdev->lock);
-
 	media_device_for_each_entity(entity, mdev) {
 		if (((media_entity_id(entity) == id) && !next) ||
 		    ((media_entity_id(entity) > id) && next)) {
-			spin_unlock(&mdev->lock);
 			return entity;
 		}
 	}
 
-	spin_unlock(&mdev->lock);
-
 	return NULL;
 }
 
@@ -431,6 +426,7 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 	struct media_device *dev = to_media_device(devnode);
 	long ret;
 
+	mutex_lock(&dev->graph_mutex);
 	switch (cmd) {
 	case MEDIA_IOC_DEVICE_INFO:
 		ret = media_device_get_info(dev,
@@ -443,29 +439,24 @@ static long media_device_ioctl(struct file *filp, unsigned int cmd,
 		break;
 
 	case MEDIA_IOC_ENUM_LINKS:
-		mutex_lock(&dev->graph_mutex);
 		ret = media_device_enum_links(dev,
 				(struct media_links_enum __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
 		break;
 
 	case MEDIA_IOC_SETUP_LINK:
-		mutex_lock(&dev->graph_mutex);
 		ret = media_device_setup_link(dev,
 				(struct media_link_desc __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
 		break;
 
 	case MEDIA_IOC_G_TOPOLOGY:
-		mutex_lock(&dev->graph_mutex);
 		ret = media_device_get_topology(dev,
 				(struct media_v2_topology __user *)arg);
-		mutex_unlock(&dev->graph_mutex);
 		break;
 
 	default:
 		ret = -ENOIOCTLCMD;
 	}
+	mutex_unlock(&dev->graph_mutex);
 
 	return ret;
 }
@@ -590,12 +581,12 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	if (!ida_pre_get(&mdev->entity_internal_idx, GFP_KERNEL))
 		return -ENOMEM;
 
-	spin_lock(&mdev->lock);
+	mutex_lock(&mdev->graph_mutex);
 
 	ret = ida_get_new_above(&mdev->entity_internal_idx, 1,
 				&entity->internal_idx);
 	if (ret < 0) {
-		spin_unlock(&mdev->lock);
+		mutex_unlock(&mdev->graph_mutex);
 		return ret;
 	}
 
@@ -615,9 +606,6 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 		(notify)->notify(entity, notify->notify_data);
 	}
 
-	spin_unlock(&mdev->lock);
-
-	mutex_lock(&mdev->graph_mutex);
 	if (mdev->entity_internal_idx_max
 	    >= mdev->pm_count_walk.ent_enum.idx_max) {
 		struct media_entity_graph new = { .top = 0 };
@@ -680,9 +668,9 @@ void media_device_unregister_entity(struct media_entity *entity)
 	if (mdev == NULL)
 		return;
 
-	spin_lock(&mdev->lock);
+	mutex_lock(&mdev->graph_mutex);
 	__media_device_unregister_entity(entity);
-	spin_unlock(&mdev->lock);
+	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity);
 
@@ -703,7 +691,6 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->pads);
 	INIT_LIST_HEAD(&mdev->links);
 	INIT_LIST_HEAD(&mdev->entity_notify);
-	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
 	ida_init(&mdev->entity_internal_idx);
 
@@ -752,9 +739,9 @@ EXPORT_SYMBOL_GPL(__media_device_register);
 int __must_check media_device_register_entity_notify(struct media_device *mdev,
 					struct media_entity_notify *nptr)
 {
-	spin_lock(&mdev->lock);
+	mutex_lock(&mdev->graph_mutex);
 	list_add_tail(&nptr->list, &mdev->entity_notify);
-	spin_unlock(&mdev->lock);
+	mutex_unlock(&mdev->graph_mutex);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_device_register_entity_notify);
@@ -771,9 +758,9 @@ static void __media_device_unregister_entity_notify(struct media_device *mdev,
 void media_device_unregister_entity_notify(struct media_device *mdev,
 					struct media_entity_notify *nptr)
 {
-	spin_lock(&mdev->lock);
+	mutex_lock(&mdev->graph_mutex);
 	__media_device_unregister_entity_notify(mdev, nptr);
-	spin_unlock(&mdev->lock);
+	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_device_unregister_entity_notify);
 
@@ -787,11 +774,11 @@ void media_device_unregister(struct media_device *mdev)
 	if (mdev == NULL)
 		return;
 
-	spin_lock(&mdev->lock);
+	mutex_lock(&mdev->graph_mutex);
 
 	/* Check if mdev was ever registered at all */
 	if (!media_devnode_is_registered(&mdev->devnode)) {
-		spin_unlock(&mdev->lock);
+		mutex_unlock(&mdev->graph_mutex);
 		return;
 	}
 
@@ -811,7 +798,7 @@ void media_device_unregister(struct media_device *mdev)
 		kfree(intf);
 	}
 
-	spin_unlock(&mdev->lock);
+	mutex_unlock(&mdev->graph_mutex);
 
 	device_remove_file(&mdev->devnode.dev, &dev_attr_model);
 	media_devnode_unregister(&mdev->devnode);
diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
index e95070b3a3d4..c53c1d5589a0 100644
--- a/drivers/media/media-entity.c
+++ b/drivers/media/media-entity.c
@@ -219,7 +219,7 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 	entity->pads = pads;
 
 	if (mdev)
-		spin_lock(&mdev->lock);
+		mutex_lock(&mdev->graph_mutex);
 
 	for (i = 0; i < num_pads; i++) {
 		pads[i].entity = entity;
@@ -230,7 +230,7 @@ int media_entity_pads_init(struct media_entity *entity, u16 num_pads,
 	}
 
 	if (mdev)
-		spin_unlock(&mdev->lock);
+		mutex_unlock(&mdev->graph_mutex);
 
 	return 0;
 }
@@ -747,9 +747,9 @@ void media_entity_remove_links(struct media_entity *entity)
 	if (mdev == NULL)
 		return;
 
-	spin_lock(&mdev->lock);
+	mutex_lock(&mdev->graph_mutex);
 	__media_entity_remove_links(entity);
-	spin_unlock(&mdev->lock);
+	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_entity_remove_links);
 
@@ -951,9 +951,9 @@ void media_remove_intf_link(struct media_link *link)
 	if (mdev == NULL)
 		return;
 
-	spin_lock(&mdev->lock);
+	mutex_lock(&mdev->graph_mutex);
 	__media_remove_intf_link(link);
-	spin_unlock(&mdev->lock);
+	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_link);
 
@@ -975,8 +975,8 @@ void media_remove_intf_links(struct media_interface *intf)
 	if (mdev == NULL)
 		return;
 
-	spin_lock(&mdev->lock);
+	mutex_lock(&mdev->graph_mutex);
 	__media_remove_intf_links(intf);
-	spin_unlock(&mdev->lock);
+	mutex_unlock(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_remove_intf_links);
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 07809f698464..b21ef244ad3e 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -25,7 +25,6 @@
 
 #include <linux/list.h>
 #include <linux/mutex.h>
-#include <linux/spinlock.h>
 
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
@@ -304,8 +303,7 @@ struct media_entity_notify {
  * @pads:	List of registered pads
  * @links:	List of registered links
  * @entity_notify: List of registered entity_notify callbacks
- * @lock:	Entities list lock
- * @graph_mutex: Entities graph operation lock
+ * @graph_mutex: Protects access to struct media_device data
  * @pm_count_walk: Graph walk for power state walk. Access serialised using
  *		   graph_mutex.
  *
@@ -371,8 +369,6 @@ struct media_device {
 	/* notify callback list invoked when a new entity is registered */
 	struct list_head entity_notify;
 
-	/* Protects the graph objects creation/removal */
-	spinlock_t lock;
 	/* Serializes graph operations. */
 	struct mutex graph_mutex;
 	struct media_entity_graph pm_count_walk;
-- 
2.5.5


Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44991 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751726AbbJZXDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2015 19:03:49 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 02/19] media: Introduce internal index for media entities
Date: Tue, 27 Oct 2015 01:01:33 +0200
Message-Id: <1445900510-1398-3-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
References: <1445900510-1398-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The internal index can be used internally by the framework in order to keep
track of entities for a purpose or another. The internal index is constant
while it's registered to a media device, but the same index may be re-used
once the entity having that index is unregistered.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 17 +++++++++++++++++
 include/media/media-device.h |  4 ++++
 include/media/media-entity.h |  3 +++
 3 files changed, 24 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index c181758..ebb84cb 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -22,6 +22,7 @@
 
 #include <linux/compat.h>
 #include <linux/export.h>
+#include <linux/idr.h>
 #include <linux/ioctl.h>
 #include <linux/media.h>
 #include <linux/types.h>
@@ -546,6 +547,7 @@ void media_device_init(struct media_device *mdev)
 	INIT_LIST_HEAD(&mdev->links);
 	spin_lock_init(&mdev->lock);
 	mutex_init(&mdev->graph_mutex);
+	ida_init(&mdev->entity_internal_idx);
 
 	dev_dbg(mdev->dev, "Media device initialized\n");
 }
@@ -558,6 +560,8 @@ EXPORT_SYMBOL_GPL(media_device_init);
  */
 void media_device_cleanup(struct media_device *mdev)
 {
+	ida_destroy(&mdev->entity_internal_idx);
+	mdev->entity_internal_idx_max = 0;
 	mutex_destroy(&mdev->graph_mutex);
 }
 EXPORT_SYMBOL_GPL(media_device_cleanup);
@@ -658,6 +662,17 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	INIT_LIST_HEAD(&entity->links);
 
 	spin_lock(&mdev->lock);
+
+	entity->internal_idx = ida_simple_get(&mdev->entity_internal_idx, 1, 0,
+					      GFP_KERNEL);
+	if (entity->internal_idx < 0) {
+		spin_unlock(&mdev->lock);
+		return entity->internal_idx;
+	}
+
+	mdev->entity_internal_idx_max =
+		max(mdev->entity_internal_idx_max, entity->internal_idx);
+
 	/* Initialize media_gobj embedded at the entity */
 	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 
@@ -690,6 +705,8 @@ void media_device_unregister_entity(struct media_entity *entity)
 
 	spin_lock(&mdev->lock);
 
+	ida_simple_remove(&mdev->entity_internal_idx, entity->internal_idx);
+
 	/* Remove interface links with this entity on it */
 	list_for_each_entry_safe(link, tmp, &mdev->links, graph_obj.list) {
 		if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY
diff --git a/include/media/media-device.h b/include/media/media-device.h
index a2c7570..c0e1764 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -30,6 +30,7 @@
 #include <media/media-devnode.h>
 #include <media/media-entity.h>
 
+struct ida;
 struct device;
 
 /**
@@ -47,6 +48,7 @@ struct device;
  * @pad_id:	Unique ID used on the last pad registered
  * @link_id:	Unique ID used on the last link registered
  * @intf_devnode_id: Unique ID used on the last interface devnode registered
+ * @entity_internal_idx: Allocated internal entity indices
  * @entities:	List of registered entities
  * @interfaces:	List of registered interfaces
  * @pads:	List of registered pads
@@ -82,6 +84,8 @@ struct media_device {
 	u32 pad_id;
 	u32 link_id;
 	u32 intf_devnode_id;
+	struct ida entity_internal_idx;
+	int entity_internal_idx_max;
 
 	struct list_head entities;
 	struct list_head interfaces;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index eebdd24..d3d3a39 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -159,6 +159,8 @@ struct media_entity_operations {
  * @num_pads:	Number of sink and source pads.
  * @num_links:	Number of existing links, both enabled and disabled.
  * @num_backlinks: Number of backlinks
+ * @internal_idx: An unique internal entity specific number. The numbers are
+ *		re-used if entities are unregistered or registered again.
  * @pads:	Pads array with the size defined by @num_pads.
  * @links:	Linked list for the data links.
  * @ops:	Entity operations.
@@ -187,6 +189,7 @@ struct media_entity {
 	u16 num_pads;
 	u16 num_links;
 	u16 num_backlinks;
+	int internal_idx;
 
 	struct media_pad *pads;
 	struct list_head links;
-- 
2.1.4


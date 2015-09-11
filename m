Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28146 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbbIKKLR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 2/9] media: Introduce low_id for media entities
Date: Fri, 11 Sep 2015 13:09:05 +0300
Message-Id: <1441966152-28444-3-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A low ID is a unique number specific to a media entity. The number is
guaranteed to be under MEDIA_ENTITY_MAX_LOW_ID.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 14 ++++++++++++++
 include/media/media-device.h |  2 ++
 include/media/media-entity.h |  3 +++
 3 files changed, 19 insertions(+)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 1312e93..dfc5e4a 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -20,6 +20,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/bitmap.h>
 #include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/ioctl.h>
@@ -543,6 +544,8 @@ int __must_check __media_device_register(struct media_device *mdev,
 	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
 		return -EINVAL;
 
+	bitmap_zero(mdev->entity_low_id, MEDIA_ENTITY_MAX_LOW_ID);
+
 	INIT_LIST_HEAD(&mdev->entities);
 	INIT_LIST_HEAD(&mdev->interfaces);
 	INIT_LIST_HEAD(&mdev->pads);
@@ -628,6 +631,15 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	INIT_LIST_HEAD(&entity->links);
 
 	spin_lock(&mdev->lock);
+	entity->low_id = find_first_zero_bit(mdev->entity_low_id,
+					     MEDIA_ENTITY_MAX_LOW_ID);
+	if (entity->low_id == MEDIA_ENTITY_MAX_LOW_ID) {
+		spin_unlock(&mdev->lock);
+		return -ENOSPC;
+	}
+
+	__set_bit(entity->low_id, mdev->entity_low_id);
+
 	/* Initialize media_gobj embedded at the entity */
 	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
 
@@ -660,6 +672,8 @@ void media_device_unregister_entity(struct media_entity *entity)
 
 	spin_lock(&mdev->lock);
 
+	__clear_bit(entity->low_id, mdev->entity_low_id);
+
 	/* Remove interface links with this entity on it */
 	list_for_each_entry_safe(link, tmp, &mdev->links, graph_obj.list) {
 		if (media_type(link->gobj1) == MEDIA_GRAPH_ENTITY
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 1b12774..732163f 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -47,6 +47,7 @@ struct device;
  * @pad_id:	Unique ID used on the last pad registered
  * @link_id:	Unique ID used on the last link registered
  * @intf_devnode_id: Unique ID used on the last interface devnode registered
+ * @entity_low_id: Allocated low entity IDs
  * @entities:	List of registered entities
  * @interfaces:	List of registered interfaces
  * @pads:	List of registered pads
@@ -82,6 +83,7 @@ struct media_device {
 	u32 pad_id;
 	u32 link_id;
 	u32 intf_devnode_id;
+	DECLARE_BITMAP(entity_low_id, MEDIA_ENTITY_MAX_LOW_ID);
 
 	struct list_head entities;
 	struct list_head interfaces;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index bb6383b..2c56027 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -159,6 +159,8 @@ struct media_entity_operations {
  * @num_pads:	Number of sink and source pads.
  * @num_links:	Number of existing links, both enabled and disabled.
  * @num_backlinks: Number of backlinks
+ * @low_id:	An unique low entity specific number. The numbers are
+ *		re-used if entities are unregistered or registered again.
  * @pads:	Pads array with the size defined by @num_pads.
  * @links:	Linked list for the data links.
  * @ops:	Entity operations.
@@ -187,6 +189,7 @@ struct media_entity {
 	u16 num_pads;
 	u16 num_links;
 	u16 num_backlinks;
+	u8 low_id;
 
 	struct media_pad *pads;
 	struct list_head links;
-- 
2.1.0.231.g7484e3b


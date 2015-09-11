Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:28146 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbbIKKLR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Sep 2015 06:11:17 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, javier@osg.samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl
Subject: [RFC 4/9] media: Use media entity enum API for managing low IDs
Date: Fri, 11 Sep 2015 13:09:07 +0300
Message-Id: <1441966152-28444-5-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1441966152-28444-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/media-device.c | 15 +++++++--------
 include/media/media-device.h |  2 +-
 include/media/media-entity.h | 12 ++++++++++++
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index dfc5e4a..43d0760 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -20,7 +20,6 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
-#include <linux/bitmap.h>
 #include <linux/compat.h>
 #include <linux/export.h>
 #include <linux/ioctl.h>
@@ -544,7 +543,7 @@ int __must_check __media_device_register(struct media_device *mdev,
 	if (WARN_ON(mdev->dev == NULL || mdev->model[0] == 0))
 		return -EINVAL;
 
-	bitmap_zero(mdev->entity_low_id, MEDIA_ENTITY_MAX_LOW_ID);
+	media_entity_enum_init(mdev->entity_low_id);
 
 	INIT_LIST_HEAD(&mdev->entities);
 	INIT_LIST_HEAD(&mdev->interfaces);
@@ -618,6 +617,7 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 					      struct media_entity *entity)
 {
 	unsigned int i;
+	int id;
 
 	if (entity->function == MEDIA_ENT_F_V4L2_SUBDEV_UNKNOWN ||
 	    entity->function == MEDIA_ENT_F_UNKNOWN)
@@ -631,14 +631,13 @@ int __must_check media_device_register_entity(struct media_device *mdev,
 	INIT_LIST_HEAD(&entity->links);
 
 	spin_lock(&mdev->lock);
-	entity->low_id = find_first_zero_bit(mdev->entity_low_id,
-					     MEDIA_ENTITY_MAX_LOW_ID);
-	if (entity->low_id == MEDIA_ENTITY_MAX_LOW_ID) {
+	id = media_entity_enum_get_next(mdev->entity_low_id);
+	if (id < 0) {
 		spin_unlock(&mdev->lock);
-		return -ENOSPC;
+		return id;
 	}
 
-	__set_bit(entity->low_id, mdev->entity_low_id);
+	entity->id = id;
 
 	/* Initialize media_gobj embedded at the entity */
 	media_gobj_init(mdev, MEDIA_GRAPH_ENTITY, &entity->graph_obj);
@@ -672,7 +671,7 @@ void media_device_unregister_entity(struct media_entity *entity)
 
 	spin_lock(&mdev->lock);
 
-	__clear_bit(entity->low_id, mdev->entity_low_id);
+	media_entity_enum_clear(mdev->entity_low_id, entity);
 
 	/* Remove interface links with this entity on it */
 	list_for_each_entry_safe(link, tmp, &mdev->links, graph_obj.list) {
diff --git a/include/media/media-device.h b/include/media/media-device.h
index 732163f..b074ff8 100644
--- a/include/media/media-device.h
+++ b/include/media/media-device.h
@@ -83,7 +83,7 @@ struct media_device {
 	u32 pad_id;
 	u32 link_id;
 	u32 intf_devnode_id;
-	DECLARE_BITMAP(entity_low_id, MEDIA_ENTITY_MAX_LOW_ID);
+	DECLARE_MEDIA_ENTITY_ENUM(entity_low_id);
 
 	struct list_head entities;
 	struct list_head interfaces;
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 17ec205..95b1061 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -352,6 +352,18 @@ static inline bool media_entity_enum_intersects(unsigned long *e,
 	return bitmap_intersects(e, f, MEDIA_ENTITY_MAX_LOW_ID);
 }
 
+static inline int media_entity_enum_get_next(unsigned long *e)
+{
+	unsigned int id = find_first_zero_bit(e, MEDIA_ENTITY_MAX_LOW_ID);
+
+	if (id == MEDIA_ENTITY_MAX_LOW_ID)
+		return -ENOSPC;
+
+	__set_bit(id, e);
+
+	return id;
+}
+
 struct media_entity_graph {
 	struct {
 		struct media_entity *entity;
-- 
2.1.0.231.g7484e3b


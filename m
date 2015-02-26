Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:53148 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbbBZQAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 11:00:20 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NKD004Y4Z4IEGB0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Feb 2015 01:00:18 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [v4l-utils PATCH/RFC v5 05/14] mediactl: Add media device graph helpers
Date: Thu, 26 Feb 2015 16:59:15 +0100
Message-id: <1424966364-3647-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
References: <1424966364-3647-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new graph helpers useful for video pipeline discovering.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c |   48 +++++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediactl.h    |   36 +++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index bbaf387..a294ada 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -35,6 +35,7 @@
 #include <unistd.h>
 
 #include <linux/media.h>
+#include <linux/kdev_t.h>
 #include <linux/videodev2.h>
 
 #include "mediactl.h"
@@ -87,6 +88,29 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
 	return NULL;
 }
 
+struct media_entity *media_get_entity_by_devname(struct media_device *media,
+						 const char *devname,
+						 size_t length)
+{
+	unsigned int i;
+
+	/* A match is impossible if the entity devname is longer than the
+	 * maximum size we can get from the kernel.
+	 */
+	if (length >= FIELD_SIZEOF(struct media_entity, devname))
+		return NULL;
+
+	for (i = 0; i < media->entities_count; ++i) {
+		struct media_entity *entity = &media->entities[i];
+
+		if (strncmp(entity->devname, devname, length) == 0 &&
+		    entity->devname[length] == '\0')
+			return entity;
+	}
+
+	return NULL;
+}
+
 struct media_entity *media_get_entity_by_id(struct media_device *media,
 					    __u32 id)
 {
@@ -145,6 +169,11 @@ const char *media_entity_get_devname(struct media_entity *entity)
 	return entity->devname[0] ? entity->devname : NULL;
 }
 
+const char *media_entity_get_name(struct media_entity *entity)
+{
+	return entity->info.name;
+}
+
 struct media_entity *media_get_default_entity(struct media_device *media,
 					      unsigned int type)
 {
@@ -177,6 +206,25 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
 	return &entity->info;
 }
 
+int media_get_backlinks_by_entity(struct media_entity *entity,
+				struct media_link **backlinks,
+				int *num_backlinks)
+{
+	int num_bklinks = 0, i;
+
+	if (entity == NULL || backlinks == NULL || num_backlinks == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < entity->num_links; ++i)
+		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
+		    (entity->links[i].sink->entity == entity))
+			backlinks[num_bklinks++] = &entity->links[i];
+
+	*num_backlinks = num_bklinks;
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * Open/close
  */
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 3faee71..9db40a8 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -231,6 +231,15 @@ const struct media_link *media_entity_get_link(struct media_entity *entity,
 const char *media_entity_get_devname(struct media_entity *entity);
 
 /**
+ * @brief Get the name for an entity
+ * @param entity - media entity.
+ *
+ * This function returns the name of the entity.
+ *
+ * @return A pointer to the string with entity name
+ */
+const char *media_entity_get_name(struct media_entity *entity);
+
  * @brief Get the type of an entity.
  * @param entity - the entity.
  *
@@ -255,6 +264,19 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
 	const char *name, size_t length);
 
 /**
+ * @brief Find an entity by the corresponding device node name.
+ * @param media - media device.
+ * @param devname - device node name.
+ * @param length - size of @a devname.
+ *
+ * Search for an entity with a device node name equal to @a devname.
+ *
+ * @return A pointer to the entity if found, or NULL otherwise.
+ */
+struct media_entity *media_get_entity_by_devname(struct media_device *media,
+	const char *devname, size_t length);
+
+/**
  * @brief Find an entity by its ID.
  * @param media - media device.
  * @param id - entity ID.
@@ -434,4 +456,18 @@ int media_parse_setup_link(struct media_device *media,
  */
 int media_parse_setup_links(struct media_device *media, const char *p);
 
+/**
+ * @brief Get entity's enabled backlinks
+ * @param entity - media entity.
+ * @param backlinks - array of pointers to matching backlinks.
+ * @param num_backlinks - number of matching backlinks.
+ *
+ * Get links that are connected to the entity sink pads.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_get_backlinks_by_entity(struct media_entity *entity,
+				struct media_link **backlinks,
+				int *num_backlinks);
+
 #endif
-- 
1.7.9.5


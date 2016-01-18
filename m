Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:51738 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbcARQSY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2016 11:18:24 -0500
Received: from epcpsbgm2new.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O1501N1RPAIDD20@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 19 Jan 2016 01:18:22 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 05/15] mediactl: Add media device graph helpers
Date: Mon, 18 Jan 2016 17:17:30 +0100
Message-id: <1453133860-21571-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
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
index 61b5f50..0be1845 100644
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


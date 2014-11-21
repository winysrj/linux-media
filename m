Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:25965 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaKUQPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 11:15:10 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NFE00GK4D58BS80@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Sat, 22 Nov 2014 01:15:08 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, gjasny@googlemail.com, hdegoede@redhat.com,
	hans.verkuil@cisco.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@linux.intel.com,
	laurent.pinchart@ideasonboard.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v4 05/11] mediactl: Add media device graph helpers
Date: Fri, 21 Nov 2014 17:14:34 +0100
Message-id: <1416586480-19982-6-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
References: <1416586480-19982-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new graph helpers useful for video pipeline discovering.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 utils/media-ctl/libmediactl.c |  174 +++++++++++++++++++++++++++++++++++++++++
 utils/media-ctl/mediactl.h    |  121 ++++++++++++++++++++++++++++
 2 files changed, 295 insertions(+)

diff --git a/utils/media-ctl/libmediactl.c b/utils/media-ctl/libmediactl.c
index af7dd43..a476601 100644
--- a/utils/media-ctl/libmediactl.c
+++ b/utils/media-ctl/libmediactl.c
@@ -35,6 +35,7 @@
 #include <unistd.h>
 
 #include <linux/media.h>
+#include <linux/kdev_t.h>
 #include <linux/videodev2.h>
 
 #include "mediactl.h"
@@ -87,6 +88,28 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
 	return NULL;
 }
 
+struct media_entity *media_get_entity_by_devname(struct media_device *media,
+					      const char *devname, size_t length)
+{
+	unsigned int i;
+
+	/* A match is impossible if the entity devname is longer than the maximum
+	 * size we can get from the kernel.
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
@@ -145,6 +168,11 @@ const char *media_entity_get_devname(struct media_entity *entity)
 	return entity->devname[0] ? entity->devname : NULL;
 }
 
+const char *media_entity_get_name(struct media_entity *entity)
+{
+	return entity->info.name ? entity->info.name : NULL;
+}
+
 struct media_entity *media_get_default_entity(struct media_device *media,
 					      unsigned int type)
 {
@@ -177,6 +205,152 @@ const struct media_entity_desc *media_entity_get_info(struct media_entity *entit
 	return &entity->info;
 }
 
+int media_get_link_by_sink_pad(struct media_device *media,
+				struct media_pad *pad,
+				struct media_link **link)
+{
+	struct media_link *cur_link = NULL;
+	int i, j;
+
+	if (pad == NULL || link == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < media->entities_count; ++i) {
+		for (j = 0; j < media->entities[i].num_links; ++j) {
+			cur_link = &media->entities[i].links[j];
+			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
+			    /* check if cur_link's sink entity matches the pad parent entity */
+			    (cur_link->sink->entity->info.id == pad->entity->info.id) &&
+			    /* check if cur_link's sink pad id matches */
+			    (cur_link->sink->index == pad->index)) {
+				*link = cur_link;
+				return 0;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+
+int media_get_link_by_source_pad(struct media_entity *entity,
+				struct media_pad *pad,
+				struct media_link **link)
+{
+	int i;
+
+	if (entity == NULL || pad == NULL || link == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < entity->num_links; ++i) {
+		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
+		    (entity->links[i].source->index == pad->index)) {
+			*link = &entity->links[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+int media_get_pads_by_entity(struct media_entity *entity, unsigned int type,
+				struct media_pad **pads, int *num_pads)
+{
+	struct media_pad *entity_pads;
+	int cnt_pads, i;
+
+	if (entity == NULL || pads == NULL || num_pads == NULL)
+		return -EINVAL;
+
+	entity_pads = malloc(sizeof(*entity_pads));
+	cnt_pads = 0;
+
+	for (i = 0; i < entity->info.pads; ++i) {
+		if (entity->pads[i].flags & type) {
+			entity_pads = realloc(entity_pads, (i + 1) *
+					      sizeof(*entity_pads));
+			entity_pads[cnt_pads++] = entity->pads[i];
+		}
+	}
+
+	if (cnt_pads == 0)
+		free(entity_pads);
+
+	*pads = entity_pads;
+	*num_pads = cnt_pads;
+
+	return 0;
+}
+
+int media_get_busy_pads_by_entity(struct media_device *media,
+				struct media_entity *entity,
+				unsigned int type,
+				struct media_pad **busy_pads,
+				int *num_busy_pads)
+{
+	struct media_pad *bpads, *pads;
+	struct media_link *link;
+	int cnt_bpads = 0, num_pads, i, ret;
+
+	if (entity == NULL || busy_pads == NULL || num_busy_pads == NULL ||
+	    (type == MEDIA_PAD_FL_SINK && media == NULL))
+		return -EINVAL;
+
+	ret = media_get_pads_by_entity(entity, type, &pads, &num_pads);
+	if (ret < 0)
+		return -EINVAL;
+
+	if (num_pads == 0)
+		goto done;
+
+	bpads = malloc(sizeof(*pads));
+	if (bpads == NULL)
+		goto error_ret;
+
+	for (i = 0; i < num_pads; ++i) {
+		if (type == MEDIA_PAD_FL_SINK)
+			ret = media_get_link_by_sink_pad(media, &pads[i], &link);
+		else
+			ret = media_get_link_by_source_pad(entity, &pads[i], &link);
+		if (ret == 0) {
+			bpads = realloc(bpads, (i + 1) *
+						sizeof(*bpads));
+			bpads[cnt_bpads++] = pads[i];
+		}
+	}
+	if (num_pads > 0)
+		free(pads);
+
+	if (cnt_bpads == 0)
+		free(bpads);
+
+done:
+	*busy_pads = bpads;
+	*num_busy_pads = cnt_bpads;
+
+	return 0;
+
+error_ret:
+	return -EINVAL;
+}
+
+int media_get_pad_by_index(struct media_pad *pads, int num_pads,
+				int index, struct media_pad *out_pad)
+{
+	int i;
+
+	if (pads == NULL || out_pad == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < num_pads; ++i) {
+		if (pads[i].index == index) {
+			*out_pad = pads[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
 /* -----------------------------------------------------------------------------
  * Open/close
  */
diff --git a/utils/media-ctl/mediactl.h b/utils/media-ctl/mediactl.h
index 7309b16..18a1e0e 100644
--- a/utils/media-ctl/mediactl.h
+++ b/utils/media-ctl/mediactl.h
@@ -23,6 +23,7 @@
 #define __MEDIA_H__
 
 #include <linux/media.h>
+#include <sys/types.h>
 
 struct media_link {
 	struct media_pad *source;
@@ -231,6 +232,16 @@ const struct media_link *media_entity_get_link(struct media_entity *entity,
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
+/**
  * @brief Get the type of an entity.
  * @param entity - the entity.
  *
@@ -255,6 +266,19 @@ struct media_entity *media_get_entity_by_name(struct media_device *media,
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
@@ -435,6 +459,103 @@ int media_parse_setup_link(struct media_device *media,
 int media_parse_setup_links(struct media_device *media, const char *p);
 
 /**
+ * @brief Get entity's pads of a given type
+ * @param entity - media entity
+ * @param type - pad type (MEDIA_PAD_FL_SINK or MEDIA_PAD_FL_SOURCE)
+ * @param pads - array of matching pads
+ * @param num_pads - number of matching pads
+ *
+ * Get only sink or source pads for an entity. The returned pads
+ * array has to be freed by the caller.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_get_pads_by_entity(struct media_entity *entity,
+				unsigned int type,
+				struct media_pad **pads,
+				int *num_pads);
+/**
+ * @brief Get occupied entity's pads of a given type
+ * @param media - media device
+ * @param entity - media entity
+ * @param type - pad type (MEDIA_PAD_FL_SINK or MEDIA_PAD_FL_SOURCE)
+ * @param busy_pads - array of matching pads
+ * @param num_busy_pads - number of matching pads
+ *
+ * Get only sink or source pads for an entity, with active links.
+ * The returned pads array has to be freed by the caller.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_get_busy_pads_by_entity(struct media_device *media,
+				struct media_entity *entity,
+				unsigned int type,
+				struct media_pad **busy_pads,
+				int *num_busy_pads);
+
+/**
+ * @brief Get link for  sink pad
+ * @param media - media device
+ * @param pad - pad to search the link for
+ * @param link - matching link
+ *
+ * Get the link connected to the entity's sink pad.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_get_link_by_sink_pad(struct media_device *media,
+				struct media_pad *pad,
+				struct media_link **link);
+
+/**
+ * @brief Get link for source pad
+ * @param entity - media entity
+ * @param pad - pad to search the link for
+ * @param link - matching link
+ *
+ * Get the link connected to the entity's source pad.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_get_link_by_source_pad(struct media_entity *entity,
+				struct media_pad *pad,
+				struct media_link **link);
+
+/**
+ * @brief Get pad with given index
+ * @param pads - array of pads
+ * @param num_pads - number of pads in the array
+ * @param index - index of a pad to search for
+ * @param out_pad - matching pad
+ *
+ * Get pad with given index from the given pads array.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_get_pad_by_index(struct media_pad *pads, int num_pads,
+				int index, struct media_pad *out_pad);
+
+/**
+ * @brief Get source pad of the pipeline entity
+ * @param entity - media entity
+ *
+ * This function returns the source pad of the entity.
+ *
+ * @return entity source pad, or NULL if the entity is not linked.
+ */
+int media_entity_get_src_pad_index(struct media_entity *entity);
+
+/**
+ * @brief Get sink pad of the pipeline entity
+ * @param entity - media entity
+ *
+ * This function returns the sink pad of the entity.
+ *
+ * @return entity sink pad, or NULL if the entity is not linked
+ */
+int media_entity_get_sink_pad_index(struct media_entity *entity);
+
+/**
  * @brief Get file descriptor of the entity sub-device
  * @param entity - media entity
  *
-- 
1.7.9.5


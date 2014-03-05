Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39366 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaCERbA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 12:31:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Subject: [PATCH/RFC v2 3/5] Make the media_entity structure private
Date: Wed,  5 Mar 2014 18:32:19 +0100
Message-Id: <1394040741-22503-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1394040741-22503-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1394040741-22503-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 src/main.c          | 94 ++++++++++++++++++++++++++++++-----------------------
 src/mediactl-priv.h | 12 +++++++
 src/mediactl.c      | 38 ++++++++++++++++++++--
 src/mediactl.h      | 78 +++++++++++++++++++++++++++++++++++---------
 4 files changed, 164 insertions(+), 58 deletions(-)

diff --git a/src/main.c b/src/main.c
index b0e2277..6f980b4 100644
--- a/src/main.c
+++ b/src/main.c
@@ -171,7 +171,6 @@ static const char *media_pad_type_to_string(unsigned flag)
 
 static void media_print_topology_dot(struct media_device *media)
 {
-	struct media_entity *entities = media_get_entities(media);
 	unsigned int nents = media_get_entities_count(media);
 	unsigned int i, j;
 
@@ -179,34 +178,41 @@ static void media_print_topology_dot(struct media_device *media)
 	printf("\trankdir=TB\n");
 
 	for (i = 0; i < nents; ++i) {
-		struct media_entity *entity = &entities[i];
+		struct media_entity *entity = media_get_entity(media, i);
+		const struct media_entity_desc *info = media_entity_get_info(entity);
+		const char *devname = media_entity_get_devname(entity);
+		unsigned int num_links = media_entity_get_links_count(entity);
 		unsigned int npads;
 
 		switch (media_entity_type(entity)) {
 		case MEDIA_ENT_T_DEVNODE:
 			printf("\tn%08x [label=\"%s\\n%s\", shape=box, style=filled, "
 			       "fillcolor=yellow]\n",
-			       entity->info.id, entity->info.name, entity->devname);
+			       info->id, info->name, devname);
 			break;
 
 		case MEDIA_ENT_T_V4L2_SUBDEV:
-			printf("\tn%08x [label=\"{{", entity->info.id);
+			printf("\tn%08x [label=\"{{", info->id);
 
-			for (j = 0, npads = 0; j < entity->info.pads; ++j) {
-				if (!(entity->pads[j].flags & MEDIA_PAD_FL_SINK))
+			for (j = 0, npads = 0; j < info->pads; ++j) {
+				const struct media_pad *pad = media_entity_get_pad(entity, j);
+
+				if (!(pad->flags & MEDIA_PAD_FL_SINK))
 					continue;
 
 				printf("%s<port%u> %u", npads ? " | " : "", j, j);
 				npads++;
 			}
 
-			printf("} | %s", entity->info.name);
-			if (entity->devname)
-				printf("\\n%s", entity->devname);
+			printf("} | %s", info->name);
+			if (devname)
+				printf("\\n%s", devname);
 			printf(" | {");
 
-			for (j = 0, npads = 0; j < entity->info.pads; ++j) {
-				if (!(entity->pads[j].flags & MEDIA_PAD_FL_SOURCE))
+			for (j = 0, npads = 0; j < info->pads; ++j) {
+				const struct media_pad *pad = media_entity_get_pad(entity, j);
+
+				if (!(pad->flags & MEDIA_PAD_FL_SOURCE))
 					continue;
 
 				printf("%s<port%u> %u", npads ? " | " : "", j, j);
@@ -220,19 +226,21 @@ static void media_print_topology_dot(struct media_device *media)
 			continue;
 		}
 
-		for (j = 0; j < entity->num_links; j++) {
-			struct media_link *link = &entity->links[j];
+		for (j = 0; j < num_links; j++) {
+			const struct media_link *link = media_entity_get_link(entity, j);
+			const struct media_pad *source = link->source;
+			const struct media_pad *sink = link->sink;
 
-			if (link->source->entity != entity)
+			if (source->entity != entity)
 				continue;
 
-			printf("\tn%08x", link->source->entity->info.id);
-			if (media_entity_type(link->source->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
-				printf(":port%u", link->source->index);
+			printf("\tn%08x", media_entity_get_info(source->entity)->id);
+			if (media_entity_type(source->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
+				printf(":port%u", source->index);
 			printf(" -> ");
-			printf("n%08x", link->sink->entity->info.id);
-			if (media_entity_type(link->sink->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
-				printf(":port%u", link->sink->index);
+			printf("n%08x", media_entity_get_info(sink->entity)->id);
+			if (media_entity_type(sink->entity) == MEDIA_ENT_T_V4L2_SUBDEV)
+				printf(":port%u", sink->index);
 
 			if (link->flags & MEDIA_LNK_FL_IMMUTABLE)
 				printf(" [style=bold]");
@@ -256,7 +264,6 @@ static void media_print_topology_text(struct media_device *media)
 		{ MEDIA_LNK_FL_DYNAMIC, "DYNAMIC" },
 	};
 
-	struct media_entity *entities = media_get_entities(media);
 	unsigned int nents = media_get_entities_count(media);
 	unsigned int i, j, k;
 	unsigned int padding;
@@ -264,40 +271,45 @@ static void media_print_topology_text(struct media_device *media)
 	printf("Device topology\n");
 
 	for (i = 0; i < nents; ++i) {
-		struct media_entity *entity = &entities[i];
-
-		padding = printf("- entity %u: ", entity->info.id);
-		printf("%s (%u pad%s, %u link%s)\n", entity->info.name,
-			entity->info.pads, entity->info.pads > 1 ? "s" : "",
-			entity->num_links, entity->num_links > 1 ? "s" : "");
+		struct media_entity *entity = media_get_entity(media, i);
+		const struct media_entity_desc *info = media_entity_get_info(entity);
+		const char *devname = media_entity_get_devname(entity);
+		unsigned int num_links = media_entity_get_links_count(entity);
+
+		padding = printf("- entity %u: ", info->id);
+		printf("%s (%u pad%s, %u link%s)\n", info->name,
+			info->pads, info->pads > 1 ? "s" : "",
+			num_links, num_links > 1 ? "s" : "");
 		printf("%*ctype %s subtype %s flags %x\n", padding, ' ',
-			media_entity_type_to_string(entity->info.type),
-			media_entity_subtype_to_string(entity->info.type),
-			entity->info.flags);
-		if (entity->devname[0])
-			printf("%*cdevice node name %s\n", padding, ' ', entity->devname);
+			media_entity_type_to_string(info->type),
+			media_entity_subtype_to_string(info->type),
+			info->flags);
+		if (devname)
+			printf("%*cdevice node name %s\n", padding, ' ', devname);
 
-		for (j = 0; j < entity->info.pads; j++) {
-			struct media_pad *pad = &entity->pads[j];
+		for (j = 0; j < info->pads; j++) {
+			const struct media_pad *pad = media_entity_get_pad(entity, j);
 
 			printf("\tpad%u: %s\n", j, media_pad_type_to_string(pad->flags));
 
 			if (media_entity_type(entity) == MEDIA_ENT_T_V4L2_SUBDEV)
 				v4l2_subdev_print_format(entity, j, V4L2_SUBDEV_FORMAT_ACTIVE);
 
-			for (k = 0; k < entity->num_links; k++) {
-				struct media_link *link = &entity->links[k];
-				struct media_pad *source = link->source;
-				struct media_pad *sink = link->sink;
+			for (k = 0; k < num_links; k++) {
+				const struct media_link *link = media_entity_get_link(entity, k);
+				const struct media_pad *source = link->source;
+				const struct media_pad *sink = link->sink;
 				bool first = true;
 				unsigned int i;
 
 				if (source->entity == entity && source->index == j)
 					printf("\t\t-> \"%s\":%u [",
-						sink->entity->info.name, sink->index);
+						media_entity_get_info(sink->entity)->name,
+						sink->index);
 				else if (sink->entity == entity && sink->index == j)
 					printf("\t\t<- \"%s\":%u [",
-						source->entity->info.name, source->index);
+						media_entity_get_info(source->entity)->name,
+						source->index);
 				else
 					continue;
 
@@ -383,7 +395,7 @@ int main(int argc, char **argv)
 			goto out;
 		}
 
-		printf("%s\n", entity->devname);
+		printf("%s\n", media_entity_get_devname(entity));
 	}
 
 	if (media_opts.pad) {
diff --git a/src/mediactl-priv.h b/src/mediactl-priv.h
index 844acc7..37e60aa 100644
--- a/src/mediactl-priv.h
+++ b/src/mediactl-priv.h
@@ -26,6 +26,18 @@
 
 #include "mediactl.h"
 
+struct media_entity {
+	struct media_device *media;
+	struct media_entity_desc info;
+	struct media_pad *pads;
+	struct media_link *links;
+	unsigned int max_links;
+	unsigned int num_links;
+
+	char devname[32];
+	int fd;
+};
+
 struct media_device {
 	int fd;
 	int refcount;
diff --git a/src/mediactl.c b/src/mediactl.c
index 2ba0ab8..a48953a 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -111,9 +111,38 @@ unsigned int media_get_entities_count(struct media_device *media)
 	return media->entities_count;
 }
 
-struct media_entity *media_get_entities(struct media_device *media)
+struct media_entity *media_get_entity(struct media_device *media, unsigned int index)
 {
-	return media->entities;
+	if (index >= media->entities_count)
+		return NULL;
+
+	return &media->entities[index];
+}
+
+const struct media_pad *media_entity_get_pad(struct media_entity *entity, unsigned int index)
+{
+	if (index >= entity->info.pads)
+		return NULL;
+
+	return &entity->pads[index];
+}
+
+unsigned int media_entity_get_links_count(struct media_entity *entity)
+{
+	return entity->num_links;
+}
+
+const struct media_link *media_entity_get_link(struct media_entity *entity, unsigned int index)
+{
+	if (index >= entity->num_links)
+		return NULL;
+
+	return &entity->links[index];
+}
+
+const char *media_entity_get_devname(struct media_entity *entity)
+{
+	return entity->devname[0] ? entity->devname : NULL;
 }
 
 const struct media_device_info *media_get_info(struct media_device *media)
@@ -126,6 +155,11 @@ const char *media_get_devnode(struct media_device *media)
 	return media->devnode;
 }
 
+const struct media_entity_desc *media_entity_get_info(struct media_entity *entity)
+{
+	return &entity->info;
+}
+
 /* -----------------------------------------------------------------------------
  * Open/close
  */
diff --git a/src/mediactl.h b/src/mediactl.h
index efa59d6..e2c93b8 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -39,20 +39,8 @@ struct media_pad {
 	__u32 padding[3];
 };
 
-struct media_entity {
-	struct media_device *media;
-	struct media_entity_desc info;
-	struct media_pad *pads;
-	struct media_link *links;
-	unsigned int max_links;
-	unsigned int num_links;
-
-	char devname[32];
-	int fd;
-	__u32 padding[6];
-};
-
 struct media_device;
+struct media_entity;
 
 /**
  * @brief Create a new media device.
@@ -131,6 +119,66 @@ int media_device_enumerate(struct media_device *media);
 struct media_pad *media_entity_remote_source(struct media_pad *pad);
 
 /**
+ * @brief Get information about a media entity
+ * @param entity - media entity.
+ *
+ * The information structure is owned by the media entity object and will be
+ * freed when the object is destroyed.
+ *
+ * @return A pointer to the media entity information
+ */
+const struct media_entity_desc *media_entity_get_info(struct media_entity *entity);
+
+/**
+ * @brief Get an entity pad
+ * @param entity - media entity.
+ * @param index - pad index.
+ *
+ * This function returns a pointer to the pad object identified by its index
+ * for the given entity. If the pad index is out of bounds it will return NULL.
+ *
+ * @return A pointer to the pad
+ */
+const struct media_pad *media_entity_get_pad(struct media_entity *entity,
+					     unsigned int index);
+
+/**
+ * @brief Get the number of links
+ * @param entity - media entity.
+ *
+ * This function returns the total number of links that originate from or arrive
+ * at the the media entity.
+ *
+ * @return The number of links for the entity
+ */
+unsigned int media_entity_get_links_count(struct media_entity *entity);
+
+/**
+ * @brief Get an entity link
+ * @param entity - media entity.
+ * @param index - link index.
+ *
+ * This function returns a pointer to the link object identified by its index
+ * for the given entity. If the link index is out of bounds it will return NULL.
+ *
+ * @return A pointer to the link
+ */
+const struct media_link *media_entity_get_link(struct media_entity *entity,
+					       unsigned int index);
+
+/**
+ * @brief Get the device node name for an entity
+ * @param entity - media entity.
+ *
+ * This function returns the full path and name to the device node corresponding
+ * to the given entity.
+ *
+ * @return A pointer to the device node name or NULL if the entity has no
+ * associated device node
+ */
+const char *media_entity_get_devname(struct media_entity *entity);
+
+/**
  * @brief Get the type of an entity.
  * @param entity - the entity.
  *
@@ -138,7 +186,7 @@ struct media_pad *media_entity_remote_source(struct media_pad *pad);
  */
 static inline unsigned int media_entity_type(struct media_entity *entity)
 {
-	return entity->info.type & MEDIA_ENT_TYPE_MASK;
+	return media_entity_get_info(entity)->type & MEDIA_ENT_TYPE_MASK;
 }
 
 /**
@@ -193,7 +241,7 @@ unsigned int media_get_entities_count(struct media_device *media);
  *
  * @return A pointer to an array of entities
  */
-struct media_entity *media_get_entities(struct media_device *media);
+struct media_entity *media_get_entity(struct media_device *media, unsigned int index);
 
 /**
  * @brief Get the media device information
-- 
1.8.3.2


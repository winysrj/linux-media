Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56145 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaAXNH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 08:07:26 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Subject: [PATCH/RFC 2/4] Make the media_device structure private
Date: Fri, 24 Jan 2014 14:08:07 +0100
Message-Id: <1390568889-1508-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 src/main.c          | 32 ++++++++++++++++-----------
 src/mediactl-priv.h | 45 ++++++++++++++++++++++++++++++++++++++
 src/mediactl.c      | 29 +++++++++++++++++++++++++
 src/mediactl.h      | 62 ++++++++++++++++++++++++++++++++++++++++-------------
 src/v4l2subdev.c    |  1 +
 5 files changed, 141 insertions(+), 28 deletions(-)
 create mode 100644 src/mediactl-priv.h

diff --git a/src/main.c b/src/main.c
index 8b48fde..b0e2277 100644
--- a/src/main.c
+++ b/src/main.c
@@ -171,13 +171,15 @@ static const char *media_pad_type_to_string(unsigned flag)
 
 static void media_print_topology_dot(struct media_device *media)
 {
+	struct media_entity *entities = media_get_entities(media);
+	unsigned int nents = media_get_entities_count(media);
 	unsigned int i, j;
 
 	printf("digraph board {\n");
 	printf("\trankdir=TB\n");
 
-	for (i = 0; i < media->entities_count; ++i) {
-		struct media_entity *entity = &media->entities[i];
+	for (i = 0; i < nents; ++i) {
+		struct media_entity *entity = &entities[i];
 		unsigned int npads;
 
 		switch (media_entity_type(entity)) {
@@ -254,13 +256,15 @@ static void media_print_topology_text(struct media_device *media)
 		{ MEDIA_LNK_FL_DYNAMIC, "DYNAMIC" },
 	};
 
+	struct media_entity *entities = media_get_entities(media);
+	unsigned int nents = media_get_entities_count(media);
 	unsigned int i, j, k;
 	unsigned int padding;
 
 	printf("Device topology\n");
 
-	for (i = 0; i < media->entities_count; ++i) {
-		struct media_entity *entity = &media->entities[i];
+	for (i = 0; i < nents; ++i) {
+		struct media_entity *entity = &entities[i];
 
 		padding = printf("- entity %u: ", entity->info.id);
 		printf("%s (%u pad%s, %u link%s)\n", entity->info.name,
@@ -347,10 +351,12 @@ int main(int argc, char **argv)
 	}
 
 	if (media_opts.print) {
+		const struct media_device_info *info = media_get_info(media);
+
 		printf("Media controller API version %u.%u.%u\n\n",
-		       (media->info.media_version << 16) & 0xff,
-		       (media->info.media_version << 8) & 0xff,
-		       (media->info.media_version << 0) & 0xff);
+		       (info->media_version << 16) & 0xff,
+		       (info->media_version << 8) & 0xff,
+		       (info->media_version << 0) & 0xff);
 		printf("Media device information\n"
 		       "------------------------\n"
 		       "driver          %s\n"
@@ -359,12 +365,12 @@ int main(int argc, char **argv)
 		       "bus info        %s\n"
 		       "hw revision     0x%x\n"
 		       "driver version  %u.%u.%u\n\n",
-		       media->info.driver, media->info.model,
-		       media->info.serial, media->info.bus_info,
-		       media->info.hw_revision,
-		       (media->info.driver_version << 16) & 0xff,
-		       (media->info.driver_version << 8) & 0xff,
-		       (media->info.driver_version << 0) & 0xff);
+		       info->driver, info->model,
+		       info->serial, info->bus_info,
+		       info->hw_revision,
+		       (info->driver_version << 16) & 0xff,
+		       (info->driver_version << 8) & 0xff,
+		       (info->driver_version << 0) & 0xff);
 	}
 
 	if (media_opts.entity) {
diff --git a/src/mediactl-priv.h b/src/mediactl-priv.h
new file mode 100644
index 0000000..844acc7
--- /dev/null
+++ b/src/mediactl-priv.h
@@ -0,0 +1,45 @@
+/*
+ * Media controller interface library
+ *
+ * Copyright (C) 2010-2011 Ideas on board SPRL
+ *
+ * Contact: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published
+ * by the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program. If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __MEDIA_PRIV_H__
+#define __MEDIA_PRIV_H__
+
+#include <linux/media.h>
+
+#include "mediactl.h"
+
+struct media_device {
+	int fd;
+	int refcount;
+	char *devnode;
+
+	struct media_device_info info;
+	struct media_entity *entities;
+	unsigned int entities_count;
+
+	void (*debug_handler)(void *, ...);
+	void *debug_priv;
+};
+
+#define media_dbg(media, ...) \
+	(media)->debug_handler((media)->debug_priv, __VA_ARGS__)
+
+#endif /* __MEDIA_PRIV_H__ */
diff --git a/src/mediactl.c b/src/mediactl.c
index c71d4e1..2ba0ab8 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -38,8 +38,13 @@
 #include <linux/videodev2.h>
 
 #include "mediactl.h"
+#include "mediactl-priv.h"
 #include "tools.h"
 
+/* -----------------------------------------------------------------------------
+ * Graph access
+ */
+
 struct media_pad *media_entity_remote_source(struct media_pad *pad)
 {
 	unsigned int i;
@@ -101,6 +106,26 @@ struct media_entity *media_get_entity_by_id(struct media_device *media,
 	return NULL;
 }
 
+unsigned int media_get_entities_count(struct media_device *media)
+{
+	return media->entities_count;
+}
+
+struct media_entity *media_get_entities(struct media_device *media)
+{
+	return media->entities;
+}
+
+const struct media_device_info *media_get_info(struct media_device *media)
+{
+	return &media->info;
+}
+
+const char *media_get_devnode(struct media_device *media)
+{
+	return media->devnode;
+}
+
 /* -----------------------------------------------------------------------------
  * Open/close
  */
@@ -222,6 +247,10 @@ int media_reset_links(struct media_device *media)
 	return 0;
 }
 
+/* -----------------------------------------------------------------------------
+ * Entities, pads and links enumeration
+ */
+
 static struct media_link *media_entity_add_link(struct media_entity *entity)
 {
 	if (entity->num_links >= entity->max_links) {
diff --git a/src/mediactl.h b/src/mediactl.h
index 34e7487..ce5c05a 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -52,21 +52,6 @@ struct media_entity {
 	__u32 padding[6];
 };
 
-struct media_device {
-	int fd;
-	int refcount;
-	char *devnode;
-	struct media_device_info info;
-	struct media_entity *entities;
-	unsigned int entities_count;
-	void (*debug_handler)(void *, ...);
-	void *debug_priv;
-	__u32 padding[6];
-};
-
-#define media_dbg(media, ...) \
-	(media)->debug_handler((media)->debug_priv, __VA_ARGS__)
-
 /**
  * @brief Create a new media device.
  * @param devnode - device node path.
@@ -184,6 +169,53 @@ struct media_entity *media_get_entity_by_id(struct media_device *media,
 	__u32 id);
 
 /**
+ * @brief Get the number of entities
+ * @param media - media device.
+ *
+ * This function returns the total number of entities in the media device. If
+ * entities haven't been enumerated yet it will return 0.
+ *
+ * @return The number of entities in the media device
+ */
+unsigned int media_get_entities_count(struct media_device *media);
+
+/**
+ * @brief Get the entities
+ * @param media - media device.
+ *
+ * This function returns a pointer to the array of entities for the media
+ * device. If entities haven't been enumerated yet it will return NULL.
+ *
+ * The array of entities is owned by the media device object and will be freed
+ * when the media object is destroyed.
+ *
+ * @return A pointer to an array of entities
+ */
+struct media_entity *media_get_entities(struct media_device *media);
+
+/**
+ * @brief Get the media device information
+ * @param media - media device.
+ *
+ * The information structure is owned by the media device object and will be freed
+ * when the media object is destroyed.
+ *
+ * @return A pointer to the media device information
+ */
+const struct media_device_info *media_get_info(struct media_device *media);
+
+/**
+ * @brief Get the media device node name
+ * @param media - media device.
+ *
+ * The device node name string is owned by the media device object and will be
+ * freed when the media object is destroyed.
+ *
+ * @return A pointer to the media device node name
+ */
+const char *media_get_devnode(struct media_device *media);
+
+/**
  * @brief Configure a link.
  * @param media - media device.
  * @param source - source pad at the link origin.
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
index 2d45d7f..77fe420 100644
--- a/src/v4l2subdev.c
+++ b/src/v4l2subdev.c
@@ -35,6 +35,7 @@
 #include <linux/v4l2-subdev.h>
 
 #include "mediactl.h"
+#include "mediactl-priv.h"
 #include "tools.h"
 #include "v4l2subdev.h"
 
-- 
1.8.3.2


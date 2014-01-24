Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56145 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbaAXNH1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 08:07:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, sakari.ailus@iki.fi
Subject: [PATCH/RFC 4/4] Add support for emulated devices
Date: Fri, 24 Jan 2014 14:08:09 +0100
Message-Id: <1390568889-1508-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1390568889-1508-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Emulated media devices are backed by real hardware devices for the
functions they provide, but have no kernel media device counterpart.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 src/mediactl.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 src/mediactl.h | 52 +++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+), 4 deletions(-)

diff --git a/src/mediactl.c b/src/mediactl.c
index 5e83ad1..5c8236f 100644
--- a/src/mediactl.c
+++ b/src/mediactl.c
@@ -602,7 +602,7 @@ void media_debug_set_handler(struct media_device *media,
 	}
 }
 
-struct media_device *media_device_new(const char *devnode)
+static struct media_device *__media_device_new(void)
 {
 	struct media_device *media;
 	int ret;
@@ -616,6 +616,18 @@ struct media_device *media_device_new(const char *devnode)
 
 	media_debug_set_handler(media, NULL, NULL);
 
+	return media;
+}
+
+struct media_device *media_device_new(const char *devnode)
+{
+	struct media_device *media;
+	int ret;
+
+	media = __media_device_new();
+	if (media == NULL)
+		return NULL;
+
 	media->devnode = strdup(devnode);
 	if (media->devnode == NULL) {
 		media_device_unref(media);
@@ -625,6 +637,19 @@ struct media_device *media_device_new(const char *devnode)
 	return media;
 }
 
+struct media_device *media_device_new_emulated(struct media_device_info *info)
+{
+	struct media_device *media;
+
+	media = __media_device_new();
+	if (media == NULL)
+		return NULL;
+
+	media->info = *info;
+
+	return media;
+}
+
 struct media_device *media_device_ref(struct media_device *media)
 {
 	media->refcount++;
@@ -653,9 +678,61 @@ void media_device_unref(struct media_device *media)
 	free(media);
 }
 
-/* -----------------------------------------------------------------------------
- * Parsing
- */
+int media_device_add_entity(struct media_device *media,
+			    const struct media_entity_desc *desc,
+			    const char *devnode)
+{
+	struct media_entity **defent;
+	struct media_entity *entity;
+	unsigned int size;
+
+	size = (media->entities_count + 1) * sizeof(*media->entities);
+	entity = realloc(media->entities, size);
+	if (entity == NULL)
+		return -ENOMEM;
+
+	media->entities = entity;
+	media->entities_count++;
+
+	entity = &media->entities[media->entities_count - 1];
+	memset(entity, 0, sizeof *entity);
+
+	entity->fd = -1;
+	entity->media = media;
+	strncpy(entity->devname, devnode, sizeof entity->devname);
+	entity->devname[sizeof entity->devname - 1] = '\0';
+
+	entity->info.id = 0;
+	entity->info.type = desc->type;
+	entity->info.flags = 0;
+	memcpy(entity->info.name, desc->name, sizeof entity->info.name);
+
+	switch (entity->info.type) {
+	case MEDIA_ENT_T_DEVNODE_V4L:
+		defent = &media->def.v4l;
+		entity->info.v4l = desc->v4l;
+		break;
+	case MEDIA_ENT_T_DEVNODE_FB:
+		defent = &media->def.fb;
+		entity->info.fb = desc->fb;
+		break;
+	case MEDIA_ENT_T_DEVNODE_ALSA:
+		defent = &media->def.alsa;
+		entity->info.alsa = desc->alsa;
+		break;
+	case MEDIA_ENT_T_DEVNODE_DVB:
+		defent = &media->def.dvb;
+		entity->info.dvb = desc->dvb;
+		break;
+	}
+
+	if (desc->flags & MEDIA_ENT_FL_DEFAULT) {
+		entity->info.flags |= MEDIA_ENT_FL_DEFAULT;
+		*defent = entity;
+	}
+
+	return 0;
+}
 
 struct media_pad *media_parse_pad(struct media_device *media,
 				  const char *p, char **endp)
diff --git a/src/mediactl.h b/src/mediactl.h
index 52612db..25a72a8 100644
--- a/src/mediactl.h
+++ b/src/mediactl.h
@@ -70,6 +70,22 @@ struct media_entity {
 struct media_device *media_device_new(const char *devnode);
 
 /**
+ * @brief Create a new emulated media device.
+ * @param info - device information.
+ *
+ * Emulated media devices are userspace-only objects not backed by a kernel
+ * media device. They are created for ALSA and V4L2 devices that are not
+ * associated with a media controller device.
+ *
+ * Only device query functions are available for media devices. Enumerating or
+ * setting up links is invalid.
+ *
+ * @return A pointer to the new media device or NULL if memory cannot be
+ * allocated.
+ */
+struct media_device *media_device_new_emulated(struct media_device_info *info);
+
+/**
  * @brief Take a reference to the device.
  * @param media - device instance.
  *
@@ -91,6 +107,42 @@ struct media_device *media_device_ref(struct media_device *media);
 void media_device_unref(struct media_device *media);
 
 /**
+ * @brief Add an entity to an existing media device
+ * @param media - device instance.
+ * @param desc - description of the entity to be added
+ * @param devnode - device node corresponding to the entity
+ *
+ * Entities are usually created and added to media devices automatically when
+ * the media device is enumerated through the media controller API. However,
+ * when an emulated media device (thus not backed with a kernel-side media
+ * controller device) is created, entities need to be manually added.
+ *
+ * Entities can also be manually added to a successfully enumerated media device
+ * to group several functions provided by separate kernel devices. The most
+ * common use case is to group the audio and video functions of a USB webcam in
+ * a single media device. Those functions are exposed through separate USB
+ * interfaces and handled through unrelated kernel drivers, they must thus be
+ * manually added to the same media device.
+ *
+ * This function adds a new entity to the given media device and initializes it
+ * from the given entity description and device node name. Only the following
+ * fields of the description are copied over to the new entity:
+ *
+ * - type
+ * - flags (MEDIA_ENT_FL_DEFAULT only)
+ * - name
+ * - v4l, fb, alsa or dvb (depending on the device type)
+ *
+ * All other fields of the newly created entity id are initialized to 0,
+ * including the entity ID.
+ *
+ * @return Zero on success or -ENOMEM if memory cannot be allocated.
+ */
+int media_device_add_entity(struct media_device *media,
+			    const struct media_entity_desc *desc,
+			    const char *devnode);
+
+/**
  * @brief Set a handler for debug messages.
  * @param media - device instance.
  * @param debug_handler - debug message handler
-- 
1.8.3.2


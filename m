Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:34388 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1JGPfM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 Oct 2011 11:35:12 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: [media-ctl PATCH 1/7] Rename files to match the names of the libraries
Date: Fri,  7 Oct 2011 18:38:02 +0300
Message-Id: <1318001888-18689-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <20111007153443.GC8908@valkosipuli.localdomain>
References: <20111007153443.GC8908@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rename media.* to mediactl.* and subdev.* v4l2subdev.*.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 src/Makefile.am  |    6 +-
 src/main.c       |    4 +-
 src/media.c      |  475 ------------------------------------------------------
 src/media.h      |  161 ------------------
 src/mediactl.c   |  475 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/mediactl.h   |  161 ++++++++++++++++++
 src/subdev.c     |  188 ---------------------
 src/subdev.h     |  162 -------------------
 src/v4l2subdev.c |  188 +++++++++++++++++++++
 src/v4l2subdev.h |  162 +++++++++++++++++++
 10 files changed, 991 insertions(+), 991 deletions(-)
 delete mode 100644 src/media.c
 delete mode 100644 src/media.h
 create mode 100644 src/mediactl.c
 create mode 100644 src/mediactl.h
 delete mode 100644 src/subdev.c
 delete mode 100644 src/subdev.h
 create mode 100644 src/v4l2subdev.c
 create mode 100644 src/v4l2subdev.h

diff --git a/src/Makefile.am b/src/Makefile.am
index 52628d2..2583464 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,8 +1,8 @@
 lib_LTLIBRARIES = libmediactl.la libv4l2subdev.la
-libmediactl_la_SOURCES = media.c
-libv4l2subdev_la_SOURCES = subdev.c
+libmediactl_la_SOURCES = mediactl.c
+libv4l2subdev_la_SOURCES = v4l2subdev.c
 mediactl_includedir=$(includedir)/mediactl
-mediactl_include_HEADERS = media.h subdev.h
+mediactl_include_HEADERS = mediactl.h v4l2subdev.h
 
 bin_PROGRAMS = media-ctl
 media_ctl_CFLAGS = $(LIBUDEV_CFLAGS)
diff --git a/src/main.c b/src/main.c
index b9b9150..55a6e2d 100644
--- a/src/main.c
+++ b/src/main.c
@@ -36,9 +36,9 @@
 #include <linux/v4l2-subdev.h>
 #include <linux/videodev2.h>
 
-#include "media.h"
+#include "mediactl.h"
 #include "options.h"
-#include "subdev.h"
+#include "v4l2subdev.h"
 #include "tools.h"
 
 /* -----------------------------------------------------------------------------
diff --git a/src/media.c b/src/media.c
deleted file mode 100644
index f443d0c..0000000
--- a/src/media.c
+++ /dev/null
@@ -1,475 +0,0 @@
-/*
- * Media controller test application
- *
- * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- */
-
-#include "config.h"
-
-#include <sys/ioctl.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-
-#include <unistd.h>
-#include <stdio.h>
-#include <stdlib.h>
-#include <string.h>
-#include <fcntl.h>
-#include <errno.h>
-
-#include <linux/videodev2.h>
-#include <linux/media.h>
-
-#include "media.h"
-#include "tools.h"
-
-struct media_pad *media_entity_remote_source(struct media_pad *pad)
-{
-	unsigned int i;
-
-	if (!(pad->flags & MEDIA_PAD_FL_SINK))
-		return NULL;
-
-	for (i = 0; i < pad->entity->num_links; ++i) {
-		struct media_link *link = &pad->entity->links[i];
-
-		if (!(link->flags & MEDIA_LNK_FL_ENABLED))
-			continue;
-
-		if (link->sink == pad)
-			return link->source;
-	}
-
-	return NULL;
-}
-
-struct media_entity *media_get_entity_by_name(struct media_device *media,
-					      const char *name, size_t length)
-{
-	unsigned int i;
-
-	for (i = 0; i < media->entities_count; ++i) {
-		struct media_entity *entity = &media->entities[i];
-
-		if (strncmp(entity->info.name, name, length) == 0)
-			return entity;
-	}
-
-	return NULL;
-}
-
-struct media_entity *media_get_entity_by_id(struct media_device *media,
-					    __u32 id)
-{
-	unsigned int i;
-
-	for (i = 0; i < media->entities_count; ++i) {
-		struct media_entity *entity = &media->entities[i];
-
-		if (entity->info.id == id)
-			return entity;
-	}
-
-	return NULL;
-}
-
-int media_setup_link(struct media_device *media,
-		     struct media_pad *source,
-		     struct media_pad *sink,
-		     __u32 flags)
-{
-	struct media_link *link;
-	struct media_link_desc ulink;
-	unsigned int i;
-	int ret;
-
-	for (i = 0; i < source->entity->num_links; i++) {
-		link = &source->entity->links[i];
-
-		if (link->source->entity == source->entity &&
-		    link->source->index == source->index &&
-		    link->sink->entity == sink->entity &&
-		    link->sink->index == sink->index)
-			break;
-	}
-
-	if (i == source->entity->num_links) {
-		printf("%s: Link not found\n", __func__);
-		return -EINVAL;
-	}
-
-	/* source pad */
-	ulink.source.entity = source->entity->info.id;
-	ulink.source.index = source->index;
-	ulink.source.flags = MEDIA_PAD_FL_SOURCE;
-
-	/* sink pad */
-	ulink.sink.entity = sink->entity->info.id;
-	ulink.sink.index = sink->index;
-	ulink.sink.flags = MEDIA_PAD_FL_SINK;
-
-	ulink.flags = flags | (link->flags & MEDIA_LNK_FL_IMMUTABLE);
-
-	ret = ioctl(media->fd, MEDIA_IOC_SETUP_LINK, &ulink);
-	if (ret < 0) {
-		printf("%s: Unable to setup link (%s)\n", __func__,
-			strerror(errno));
-		return ret;
-	}
-
-	link->flags = ulink.flags;
-	link->twin->flags = ulink.flags;
-	return 0;
-}
-
-int media_reset_links(struct media_device *media)
-{
-	unsigned int i, j;
-	int ret;
-
-	for (i = 0; i < media->entities_count; ++i) {
-		struct media_entity *entity = &media->entities[i];
-
-		for (j = 0; j < entity->num_links; j++) {
-			struct media_link *link = &entity->links[j];
-
-			if (link->flags & MEDIA_LNK_FL_IMMUTABLE ||
-			    link->source->entity != entity)
-				continue;
-
-			ret = media_setup_link(media, link->source, link->sink,
-					       link->flags & ~MEDIA_LNK_FL_ENABLED);
-			if (ret < 0)
-				return ret;
-		}
-	}
-
-	return 0;
-}
-
-static struct media_link *media_entity_add_link(struct media_entity *entity)
-{
-	if (entity->num_links >= entity->max_links) {
-		struct media_link *links = entity->links;
-		unsigned int max_links = entity->max_links * 2;
-		unsigned int i;
-
-		links = realloc(links, max_links * sizeof *links);
-		if (links == NULL)
-			return NULL;
-
-		for (i = 0; i < entity->num_links; ++i)
-			links[i].twin->twin = &links[i];
-
-		entity->max_links = max_links;
-		entity->links = links;
-	}
-
-	return &entity->links[entity->num_links++];
-}
-
-static int media_enum_links(struct media_device *media)
-{
-	__u32 id;
-	int ret = 0;
-
-	for (id = 1; id <= media->entities_count; id++) {
-		struct media_entity *entity = &media->entities[id - 1];
-		struct media_links_enum links;
-		unsigned int i;
-
-		links.entity = entity->info.id;
-		links.pads = malloc(entity->info.pads * sizeof(struct media_pad_desc));
-		links.links = malloc(entity->info.links * sizeof(struct media_link_desc));
-
-		if (ioctl(media->fd, MEDIA_IOC_ENUM_LINKS, &links) < 0) {
-			printf("%s: Unable to enumerate pads and links (%s).\n",
-				__func__, strerror(errno));
-			free(links.pads);
-			free(links.links);
-			return -errno;
-		}
-
-		for (i = 0; i < entity->info.pads; ++i) {
-			entity->pads[i].entity = entity;
-			entity->pads[i].index = links.pads[i].index;
-			entity->pads[i].flags = links.pads[i].flags;
-		}
-
-		for (i = 0; i < entity->info.links; ++i) {
-			struct media_link_desc *link = &links.links[i];
-			struct media_link *fwdlink;
-			struct media_link *backlink;
-			struct media_entity *source;
-			struct media_entity *sink;
-
-			source = media_get_entity_by_id(media, link->source.entity);
-			sink = media_get_entity_by_id(media, link->sink.entity);
-
-			if (source == NULL || sink == NULL) {
-				printf("WARNING entity %u link %u from %u/%u to %u/%u is invalid!\n",
-					id, i, link->source.entity, link->source.index,
-					link->sink.entity, link->sink.index);
-				ret = -EINVAL;
-			} else {
-				fwdlink = media_entity_add_link(source);
-				fwdlink->source = &source->pads[link->source.index];
-				fwdlink->sink = &sink->pads[link->sink.index];
-				fwdlink->flags = link->flags;
-
-				backlink = media_entity_add_link(sink);
-				backlink->source = &source->pads[link->source.index];
-				backlink->sink = &sink->pads[link->sink.index];
-				backlink->flags = link->flags;
-
-				fwdlink->twin = backlink;
-				backlink->twin = fwdlink;
-			}
-		}
-
-		free(links.pads);
-		free(links.links);
-	}
-
-	return ret;
-}
-
-#ifdef HAVE_LIBUDEV
-
-#include <libudev.h>
-
-static inline int media_udev_open(struct udev **udev)
-{
-	*udev = udev_new();
-	if (*udev == NULL)
-		return -ENOMEM;
-	return 0;
-}
-
-static inline void media_udev_close(struct udev *udev)
-{
-	if (udev != NULL)
-		udev_unref(udev);
-}
-
-static int media_get_devname_udev(struct udev *udev,
-		struct media_entity *entity, int verbose)
-{
-	struct udev_device *device;
-	dev_t devnum;
-	const char *p;
-	int ret = -ENODEV;
-
-	if (udev == NULL)
-		return -EINVAL;
-
-	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
-	if (verbose)
-		printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
-	device = udev_device_new_from_devnum(udev, 'c', devnum);
-	if (device) {
-		p = udev_device_get_devnode(device);
-		if (p) {
-			strncpy(entity->devname, p, sizeof(entity->devname));
-			entity->devname[sizeof(entity->devname) - 1] = '\0';
-		}
-		ret = 0;
-	}
-
-	udev_device_unref(device);
-
-	return ret;
-}
-
-#else	/* HAVE_LIBUDEV */
-
-struct udev;
-
-static inline int media_udev_open(struct udev **udev) { return 0; }
-
-static inline void media_udev_close(struct udev *udev) { }
-
-static inline int media_get_devname_udev(struct udev *udev,
-		struct media_entity *entity, int verbose)
-{
-	return -ENOTSUP;
-}
-
-#endif	/* HAVE_LIBUDEV */
-
-static int media_get_devname_sysfs(struct media_entity *entity)
-{
-	struct stat devstat;
-	char devname[32];
-	char sysname[32];
-	char target[1024];
-	char *p;
-	int ret;
-
-	sprintf(sysname, "/sys/dev/char/%u:%u", entity->info.v4l.major,
-		entity->info.v4l.minor);
-	ret = readlink(sysname, target, sizeof(target));
-	if (ret < 0)
-		return -errno;
-
-	target[ret] = '\0';
-	p = strrchr(target, '/');
-	if (p == NULL)
-		return -EINVAL;
-
-	sprintf(devname, "/dev/%s", p + 1);
-	ret = stat(devname, &devstat);
-	if (ret < 0)
-		return -errno;
-
-	/* Sanity check: udev might have reordered the device nodes.
-	 * Make sure the major/minor match. We should really use
-	 * libudev.
-	 */
-	if (major(devstat.st_rdev) == entity->info.v4l.major &&
-	    minor(devstat.st_rdev) == entity->info.v4l.minor)
-		strcpy(entity->devname, devname);
-
-	return 0;
-}
-
-static int media_enum_entities(struct media_device *media, int verbose)
-{
-	struct media_entity *entity;
-	struct udev *udev;
-	unsigned int size;
-	__u32 id;
-	int ret;
-
-	ret = media_udev_open(&udev);
-	if (ret < 0)
-		printf("%s: Can't get udev context\n", __func__);
-
-	for (id = 0, ret = 0; ; id = entity->info.id) {
-		size = (media->entities_count + 1) * sizeof(*media->entities);
-		media->entities = realloc(media->entities, size);
-
-		entity = &media->entities[media->entities_count];
-		memset(entity, 0, sizeof(*entity));
-		entity->fd = -1;
-		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
-
-		ret = ioctl(media->fd, MEDIA_IOC_ENUM_ENTITIES, &entity->info);
-		if (ret < 0) {
-			ret = errno != EINVAL ? -errno : 0;
-			break;
-		}
-
-		/* Number of links (for outbound links) plus number of pads (for
-		 * inbound links) is a good safe initial estimate of the total
-		 * number of links.
-		 */
-		entity->max_links = entity->info.pads + entity->info.links;
-
-		entity->pads = malloc(entity->info.pads * sizeof(*entity->pads));
-		entity->links = malloc(entity->max_links * sizeof(*entity->links));
-		if (entity->pads == NULL || entity->links == NULL) {
-			ret = -ENOMEM;
-			break;
-		}
-
-		media->entities_count++;
-
-		/* Find the corresponding device name. */
-		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE &&
-		    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
-			continue;
-
-		/* Try to get the device name via udev */
-		if (!media_get_devname_udev(udev, entity, verbose))
-			continue;
-
-		/* Fall back to get the device name via sysfs */
-		media_get_devname_sysfs(entity);
-	}
-
-	media_udev_close(udev);
-	return ret;
-}
-
-struct media_device *media_open(const char *name, int verbose)
-{
-	struct media_device *media;
-	int ret;
-
-	media = calloc(1, sizeof(*media));
-	if (media == NULL) {
-		printf("%s: unable to allocate memory\n", __func__);
-		return NULL;
-	}
-
-	if (verbose)
-		printf("Opening media device %s\n", name);
-	media->fd = open(name, O_RDWR);
-	if (media->fd < 0) {
-		media_close(media);
-		printf("%s: Can't open media device %s\n", __func__, name);
-		return NULL;
-	}
-
-	if (verbose)
-		printf("Enumerating entities\n");
-
-	ret = media_enum_entities(media, verbose);
-
-	if (ret < 0) {
-		printf("%s: Unable to enumerate entities for device %s (%s)\n",
-			__func__, name, strerror(-ret));
-		media_close(media);
-		return NULL;
-	}
-
-	if (verbose) {
-		printf("Found %u entities\n", media->entities_count);
-		printf("Enumerating pads and links\n");
-	}
-
-	ret = media_enum_links(media);
-	if (ret < 0) {
-		printf("%s: Unable to enumerate pads and linksfor device %s\n",
-			__func__, name);
-		media_close(media);
-		return NULL;
-	}
-
-	return media;
-}
-
-void media_close(struct media_device *media)
-{
-	unsigned int i;
-
-	if (media->fd != -1)
-		close(media->fd);
-
-	for (i = 0; i < media->entities_count; ++i) {
-		struct media_entity *entity = &media->entities[i];
-
-		free(entity->pads);
-		free(entity->links);
-		if (entity->fd != -1)
-			close(entity->fd);
-	}
-
-	free(media->entities);
-	free(media);
-}
-
diff --git a/src/media.h b/src/media.h
deleted file mode 100644
index b91a2ac..0000000
--- a/src/media.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/*
- * Media controller test application
- *
- * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- */
-
-#ifndef __MEDIA_H__
-#define __MEDIA_H__
-
-#include <linux/media.h>
-
-struct media_link {
-	struct media_pad *source;
-	struct media_pad *sink;
-	struct media_link *twin;
-	__u32 flags;
-	__u32 padding[3];
-};
-
-struct media_pad {
-	struct media_entity *entity;
-	__u32 index;
-	__u32 flags;
-	__u32 padding[3];
-};
-
-struct media_entity {
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
-struct media_device {
-	int fd;
-	struct media_entity *entities;
-	unsigned int entities_count;
-	__u32 padding[6];
-};
-
-/**
- * @brief Open a media device.
- * @param name - name (including path) of the device node.
- * @param verbose - whether to print verbose information on the standard output.
- *
- * Open the media device referenced by @a name and enumerate entities, pads and
- * links.
- *
- * @return A pointer to a newly allocated media_device structure instance on
- * success and NULL on failure. The returned pointer must be freed with
- * media_close when the device isn't needed anymore.
- */
-struct media_device *media_open(const char *name, int verbose);
-
-/**
- * @brief Close a media device.
- * @param media - device instance.
- *
- * Close the @a media device instance and free allocated resources. Access to the
- * device instance is forbidden after this function returns.
- */
-void media_close(struct media_device *media);
-
-/**
- * @brief Locate the pad at the other end of a link.
- * @param pad - sink pad at one end of the link.
- *
- * Locate the source pad connected to @a pad through an enabled link. As only one
- * link connected to a sink pad can be enabled at a time, the connected source
- * pad is guaranteed to be unique.
- *
- * @return A pointer to the connected source pad, or NULL if all links connected
- * to @a pad are disabled. Return NULL also if @a pad is not a sink pad.
- */
-struct media_pad *media_entity_remote_source(struct media_pad *pad);
-
-/**
- * @brief Get the type of an entity.
- * @param entity - the entity.
- *
- * @return The type of @a entity.
- */
-static inline unsigned int media_entity_type(struct media_entity *entity)
-{
-	return entity->info.type & MEDIA_ENT_TYPE_MASK;
-}
-
-/**
- * @brief Find an entity by its name.
- * @param media - media device.
- * @param name - entity name.
- * @param length - size of @a name.
- *
- * Search for an entity with a name equal to @a name.
- *
- * @return A pointer to the entity if found, or NULL otherwise.
- */
-struct media_entity *media_get_entity_by_name(struct media_device *media,
-	const char *name, size_t length);
-
-/**
- * @brief Find an entity by its ID.
- * @param media - media device.
- * @param id - entity ID.
- *
- * Search for an entity with an ID equal to @a id.
- *
- * @return A pointer to the entity if found, or NULL otherwise.
- */
-struct media_entity *media_get_entity_by_id(struct media_device *media,
-	__u32 id);
-
-/**
- * @brief Configure a link.
- * @param media - media device.
- * @param source - source pad at the link origin.
- * @param sink - sink pad at the link target.
- * @param flags - configuration flags.
- *
- * Locate the link between @a source and @a sink, and configure it by applying
- * the new @a flags.
- *
- * Only the MEDIA_LINK_FLAG_ENABLED flag is writable.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-int media_setup_link(struct media_device *media,
-	struct media_pad *source, struct media_pad *sink,
-	__u32 flags);
-
-/**
- * @brief Reset all links to the disabled state.
- * @param media - media device.
- *
- * Disable all links in the media device. This function is usually used after
- * opening a media device to reset all links to a known state.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-int media_reset_links(struct media_device *media);
-
-#endif
-
diff --git a/src/mediactl.c b/src/mediactl.c
new file mode 100644
index 0000000..5c710c9
--- /dev/null
+++ b/src/mediactl.c
@@ -0,0 +1,475 @@
+/*
+ * Media controller test application
+ *
+ * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#include "config.h"
+
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <errno.h>
+
+#include <linux/videodev2.h>
+#include <linux/media.h>
+
+#include "mediactl.h"
+#include "tools.h"
+
+struct media_pad *media_entity_remote_source(struct media_pad *pad)
+{
+	unsigned int i;
+
+	if (!(pad->flags & MEDIA_PAD_FL_SINK))
+		return NULL;
+
+	for (i = 0; i < pad->entity->num_links; ++i) {
+		struct media_link *link = &pad->entity->links[i];
+
+		if (!(link->flags & MEDIA_LNK_FL_ENABLED))
+			continue;
+
+		if (link->sink == pad)
+			return link->source;
+	}
+
+	return NULL;
+}
+
+struct media_entity *media_get_entity_by_name(struct media_device *media,
+					      const char *name, size_t length)
+{
+	unsigned int i;
+
+	for (i = 0; i < media->entities_count; ++i) {
+		struct media_entity *entity = &media->entities[i];
+
+		if (strncmp(entity->info.name, name, length) == 0)
+			return entity;
+	}
+
+	return NULL;
+}
+
+struct media_entity *media_get_entity_by_id(struct media_device *media,
+					    __u32 id)
+{
+	unsigned int i;
+
+	for (i = 0; i < media->entities_count; ++i) {
+		struct media_entity *entity = &media->entities[i];
+
+		if (entity->info.id == id)
+			return entity;
+	}
+
+	return NULL;
+}
+
+int media_setup_link(struct media_device *media,
+		     struct media_pad *source,
+		     struct media_pad *sink,
+		     __u32 flags)
+{
+	struct media_link *link;
+	struct media_link_desc ulink;
+	unsigned int i;
+	int ret;
+
+	for (i = 0; i < source->entity->num_links; i++) {
+		link = &source->entity->links[i];
+
+		if (link->source->entity == source->entity &&
+		    link->source->index == source->index &&
+		    link->sink->entity == sink->entity &&
+		    link->sink->index == sink->index)
+			break;
+	}
+
+	if (i == source->entity->num_links) {
+		printf("%s: Link not found\n", __func__);
+		return -EINVAL;
+	}
+
+	/* source pad */
+	ulink.source.entity = source->entity->info.id;
+	ulink.source.index = source->index;
+	ulink.source.flags = MEDIA_PAD_FL_SOURCE;
+
+	/* sink pad */
+	ulink.sink.entity = sink->entity->info.id;
+	ulink.sink.index = sink->index;
+	ulink.sink.flags = MEDIA_PAD_FL_SINK;
+
+	ulink.flags = flags | (link->flags & MEDIA_LNK_FL_IMMUTABLE);
+
+	ret = ioctl(media->fd, MEDIA_IOC_SETUP_LINK, &ulink);
+	if (ret < 0) {
+		printf("%s: Unable to setup link (%s)\n", __func__,
+			strerror(errno));
+		return ret;
+	}
+
+	link->flags = ulink.flags;
+	link->twin->flags = ulink.flags;
+	return 0;
+}
+
+int media_reset_links(struct media_device *media)
+{
+	unsigned int i, j;
+	int ret;
+
+	for (i = 0; i < media->entities_count; ++i) {
+		struct media_entity *entity = &media->entities[i];
+
+		for (j = 0; j < entity->num_links; j++) {
+			struct media_link *link = &entity->links[j];
+
+			if (link->flags & MEDIA_LNK_FL_IMMUTABLE ||
+			    link->source->entity != entity)
+				continue;
+
+			ret = media_setup_link(media, link->source, link->sink,
+					       link->flags & ~MEDIA_LNK_FL_ENABLED);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+
+static struct media_link *media_entity_add_link(struct media_entity *entity)
+{
+	if (entity->num_links >= entity->max_links) {
+		struct media_link *links = entity->links;
+		unsigned int max_links = entity->max_links * 2;
+		unsigned int i;
+
+		links = realloc(links, max_links * sizeof *links);
+		if (links == NULL)
+			return NULL;
+
+		for (i = 0; i < entity->num_links; ++i)
+			links[i].twin->twin = &links[i];
+
+		entity->max_links = max_links;
+		entity->links = links;
+	}
+
+	return &entity->links[entity->num_links++];
+}
+
+static int media_enum_links(struct media_device *media)
+{
+	__u32 id;
+	int ret = 0;
+
+	for (id = 1; id <= media->entities_count; id++) {
+		struct media_entity *entity = &media->entities[id - 1];
+		struct media_links_enum links;
+		unsigned int i;
+
+		links.entity = entity->info.id;
+		links.pads = malloc(entity->info.pads * sizeof(struct media_pad_desc));
+		links.links = malloc(entity->info.links * sizeof(struct media_link_desc));
+
+		if (ioctl(media->fd, MEDIA_IOC_ENUM_LINKS, &links) < 0) {
+			printf("%s: Unable to enumerate pads and links (%s).\n",
+				__func__, strerror(errno));
+			free(links.pads);
+			free(links.links);
+			return -errno;
+		}
+
+		for (i = 0; i < entity->info.pads; ++i) {
+			entity->pads[i].entity = entity;
+			entity->pads[i].index = links.pads[i].index;
+			entity->pads[i].flags = links.pads[i].flags;
+		}
+
+		for (i = 0; i < entity->info.links; ++i) {
+			struct media_link_desc *link = &links.links[i];
+			struct media_link *fwdlink;
+			struct media_link *backlink;
+			struct media_entity *source;
+			struct media_entity *sink;
+
+			source = media_get_entity_by_id(media, link->source.entity);
+			sink = media_get_entity_by_id(media, link->sink.entity);
+
+			if (source == NULL || sink == NULL) {
+				printf("WARNING entity %u link %u from %u/%u to %u/%u is invalid!\n",
+					id, i, link->source.entity, link->source.index,
+					link->sink.entity, link->sink.index);
+				ret = -EINVAL;
+			} else {
+				fwdlink = media_entity_add_link(source);
+				fwdlink->source = &source->pads[link->source.index];
+				fwdlink->sink = &sink->pads[link->sink.index];
+				fwdlink->flags = link->flags;
+
+				backlink = media_entity_add_link(sink);
+				backlink->source = &source->pads[link->source.index];
+				backlink->sink = &sink->pads[link->sink.index];
+				backlink->flags = link->flags;
+
+				fwdlink->twin = backlink;
+				backlink->twin = fwdlink;
+			}
+		}
+
+		free(links.pads);
+		free(links.links);
+	}
+
+	return ret;
+}
+
+#ifdef HAVE_LIBUDEV
+
+#include <libudev.h>
+
+static inline int media_udev_open(struct udev **udev)
+{
+	*udev = udev_new();
+	if (*udev == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static inline void media_udev_close(struct udev *udev)
+{
+	if (udev != NULL)
+		udev_unref(udev);
+}
+
+static int media_get_devname_udev(struct udev *udev,
+		struct media_entity *entity, int verbose)
+{
+	struct udev_device *device;
+	dev_t devnum;
+	const char *p;
+	int ret = -ENODEV;
+
+	if (udev == NULL)
+		return -EINVAL;
+
+	devnum = makedev(entity->info.v4l.major, entity->info.v4l.minor);
+	if (verbose)
+		printf("looking up device: %u:%u\n", major(devnum), minor(devnum));
+	device = udev_device_new_from_devnum(udev, 'c', devnum);
+	if (device) {
+		p = udev_device_get_devnode(device);
+		if (p) {
+			strncpy(entity->devname, p, sizeof(entity->devname));
+			entity->devname[sizeof(entity->devname) - 1] = '\0';
+		}
+		ret = 0;
+	}
+
+	udev_device_unref(device);
+
+	return ret;
+}
+
+#else	/* HAVE_LIBUDEV */
+
+struct udev;
+
+static inline int media_udev_open(struct udev **udev) { return 0; }
+
+static inline void media_udev_close(struct udev *udev) { }
+
+static inline int media_get_devname_udev(struct udev *udev,
+		struct media_entity *entity, int verbose)
+{
+	return -ENOTSUP;
+}
+
+#endif	/* HAVE_LIBUDEV */
+
+static int media_get_devname_sysfs(struct media_entity *entity)
+{
+	struct stat devstat;
+	char devname[32];
+	char sysname[32];
+	char target[1024];
+	char *p;
+	int ret;
+
+	sprintf(sysname, "/sys/dev/char/%u:%u", entity->info.v4l.major,
+		entity->info.v4l.minor);
+	ret = readlink(sysname, target, sizeof(target));
+	if (ret < 0)
+		return -errno;
+
+	target[ret] = '\0';
+	p = strrchr(target, '/');
+	if (p == NULL)
+		return -EINVAL;
+
+	sprintf(devname, "/dev/%s", p + 1);
+	ret = stat(devname, &devstat);
+	if (ret < 0)
+		return -errno;
+
+	/* Sanity check: udev might have reordered the device nodes.
+	 * Make sure the major/minor match. We should really use
+	 * libudev.
+	 */
+	if (major(devstat.st_rdev) == entity->info.v4l.major &&
+	    minor(devstat.st_rdev) == entity->info.v4l.minor)
+		strcpy(entity->devname, devname);
+
+	return 0;
+}
+
+static int media_enum_entities(struct media_device *media, int verbose)
+{
+	struct media_entity *entity;
+	struct udev *udev;
+	unsigned int size;
+	__u32 id;
+	int ret;
+
+	ret = media_udev_open(&udev);
+	if (ret < 0)
+		printf("%s: Can't get udev context\n", __func__);
+
+	for (id = 0, ret = 0; ; id = entity->info.id) {
+		size = (media->entities_count + 1) * sizeof(*media->entities);
+		media->entities = realloc(media->entities, size);
+
+		entity = &media->entities[media->entities_count];
+		memset(entity, 0, sizeof(*entity));
+		entity->fd = -1;
+		entity->info.id = id | MEDIA_ENT_ID_FLAG_NEXT;
+
+		ret = ioctl(media->fd, MEDIA_IOC_ENUM_ENTITIES, &entity->info);
+		if (ret < 0) {
+			ret = errno != EINVAL ? -errno : 0;
+			break;
+		}
+
+		/* Number of links (for outbound links) plus number of pads (for
+		 * inbound links) is a good safe initial estimate of the total
+		 * number of links.
+		 */
+		entity->max_links = entity->info.pads + entity->info.links;
+
+		entity->pads = malloc(entity->info.pads * sizeof(*entity->pads));
+		entity->links = malloc(entity->max_links * sizeof(*entity->links));
+		if (entity->pads == NULL || entity->links == NULL) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		media->entities_count++;
+
+		/* Find the corresponding device name. */
+		if (media_entity_type(entity) != MEDIA_ENT_T_DEVNODE &&
+		    media_entity_type(entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			continue;
+
+		/* Try to get the device name via udev */
+		if (!media_get_devname_udev(udev, entity, verbose))
+			continue;
+
+		/* Fall back to get the device name via sysfs */
+		media_get_devname_sysfs(entity);
+	}
+
+	media_udev_close(udev);
+	return ret;
+}
+
+struct media_device *media_open(const char *name, int verbose)
+{
+	struct media_device *media;
+	int ret;
+
+	media = calloc(1, sizeof(*media));
+	if (media == NULL) {
+		printf("%s: unable to allocate memory\n", __func__);
+		return NULL;
+	}
+
+	if (verbose)
+		printf("Opening media device %s\n", name);
+	media->fd = open(name, O_RDWR);
+	if (media->fd < 0) {
+		media_close(media);
+		printf("%s: Can't open media device %s\n", __func__, name);
+		return NULL;
+	}
+
+	if (verbose)
+		printf("Enumerating entities\n");
+
+	ret = media_enum_entities(media, verbose);
+
+	if (ret < 0) {
+		printf("%s: Unable to enumerate entities for device %s (%s)\n",
+			__func__, name, strerror(-ret));
+		media_close(media);
+		return NULL;
+	}
+
+	if (verbose) {
+		printf("Found %u entities\n", media->entities_count);
+		printf("Enumerating pads and links\n");
+	}
+
+	ret = media_enum_links(media);
+	if (ret < 0) {
+		printf("%s: Unable to enumerate pads and linksfor device %s\n",
+			__func__, name);
+		media_close(media);
+		return NULL;
+	}
+
+	return media;
+}
+
+void media_close(struct media_device *media)
+{
+	unsigned int i;
+
+	if (media->fd != -1)
+		close(media->fd);
+
+	for (i = 0; i < media->entities_count; ++i) {
+		struct media_entity *entity = &media->entities[i];
+
+		free(entity->pads);
+		free(entity->links);
+		if (entity->fd != -1)
+			close(entity->fd);
+	}
+
+	free(media->entities);
+	free(media);
+}
+
diff --git a/src/mediactl.h b/src/mediactl.h
new file mode 100644
index 0000000..b91a2ac
--- /dev/null
+++ b/src/mediactl.h
@@ -0,0 +1,161 @@
+/*
+ * Media controller test application
+ *
+ * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#ifndef __MEDIA_H__
+#define __MEDIA_H__
+
+#include <linux/media.h>
+
+struct media_link {
+	struct media_pad *source;
+	struct media_pad *sink;
+	struct media_link *twin;
+	__u32 flags;
+	__u32 padding[3];
+};
+
+struct media_pad {
+	struct media_entity *entity;
+	__u32 index;
+	__u32 flags;
+	__u32 padding[3];
+};
+
+struct media_entity {
+	struct media_entity_desc info;
+	struct media_pad *pads;
+	struct media_link *links;
+	unsigned int max_links;
+	unsigned int num_links;
+
+	char devname[32];
+	int fd;
+	__u32 padding[6];
+};
+
+struct media_device {
+	int fd;
+	struct media_entity *entities;
+	unsigned int entities_count;
+	__u32 padding[6];
+};
+
+/**
+ * @brief Open a media device.
+ * @param name - name (including path) of the device node.
+ * @param verbose - whether to print verbose information on the standard output.
+ *
+ * Open the media device referenced by @a name and enumerate entities, pads and
+ * links.
+ *
+ * @return A pointer to a newly allocated media_device structure instance on
+ * success and NULL on failure. The returned pointer must be freed with
+ * media_close when the device isn't needed anymore.
+ */
+struct media_device *media_open(const char *name, int verbose);
+
+/**
+ * @brief Close a media device.
+ * @param media - device instance.
+ *
+ * Close the @a media device instance and free allocated resources. Access to the
+ * device instance is forbidden after this function returns.
+ */
+void media_close(struct media_device *media);
+
+/**
+ * @brief Locate the pad at the other end of a link.
+ * @param pad - sink pad at one end of the link.
+ *
+ * Locate the source pad connected to @a pad through an enabled link. As only one
+ * link connected to a sink pad can be enabled at a time, the connected source
+ * pad is guaranteed to be unique.
+ *
+ * @return A pointer to the connected source pad, or NULL if all links connected
+ * to @a pad are disabled. Return NULL also if @a pad is not a sink pad.
+ */
+struct media_pad *media_entity_remote_source(struct media_pad *pad);
+
+/**
+ * @brief Get the type of an entity.
+ * @param entity - the entity.
+ *
+ * @return The type of @a entity.
+ */
+static inline unsigned int media_entity_type(struct media_entity *entity)
+{
+	return entity->info.type & MEDIA_ENT_TYPE_MASK;
+}
+
+/**
+ * @brief Find an entity by its name.
+ * @param media - media device.
+ * @param name - entity name.
+ * @param length - size of @a name.
+ *
+ * Search for an entity with a name equal to @a name.
+ *
+ * @return A pointer to the entity if found, or NULL otherwise.
+ */
+struct media_entity *media_get_entity_by_name(struct media_device *media,
+	const char *name, size_t length);
+
+/**
+ * @brief Find an entity by its ID.
+ * @param media - media device.
+ * @param id - entity ID.
+ *
+ * Search for an entity with an ID equal to @a id.
+ *
+ * @return A pointer to the entity if found, or NULL otherwise.
+ */
+struct media_entity *media_get_entity_by_id(struct media_device *media,
+	__u32 id);
+
+/**
+ * @brief Configure a link.
+ * @param media - media device.
+ * @param source - source pad at the link origin.
+ * @param sink - sink pad at the link target.
+ * @param flags - configuration flags.
+ *
+ * Locate the link between @a source and @a sink, and configure it by applying
+ * the new @a flags.
+ *
+ * Only the MEDIA_LINK_FLAG_ENABLED flag is writable.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_setup_link(struct media_device *media,
+	struct media_pad *source, struct media_pad *sink,
+	__u32 flags);
+
+/**
+ * @brief Reset all links to the disabled state.
+ * @param media - media device.
+ *
+ * Disable all links in the media device. This function is usually used after
+ * opening a media device to reset all links to a known state.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int media_reset_links(struct media_device *media);
+
+#endif
+
diff --git a/src/subdev.c b/src/subdev.c
deleted file mode 100644
index f8ccfe3..0000000
--- a/src/subdev.c
+++ /dev/null
@@ -1,188 +0,0 @@
-/*
- * Media controller test application
- *
- * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- */
-
-#include <sys/ioctl.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-
-#include <errno.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <string.h>
-#include <unistd.h>
-
-#include <linux/v4l2-subdev.h>
-
-#include "media.h"
-#include "subdev.h"
-#include "tools.h"
-
-int v4l2_subdev_open(struct media_entity *entity)
-{
-	if (entity->fd != -1)
-		return 0;
-
-	entity->fd = open(entity->devname, O_RDWR);
-	if (entity->fd == -1) {
-		printf("%s: Failed to open subdev device node %s\n", __func__,
-			entity->devname);
-		return -errno;
-	}
-
-	return 0;
-}
-
-void v4l2_subdev_close(struct media_entity *entity)
-{
-	close(entity->fd);
-	entity->fd = -1;
-}
-
-int v4l2_subdev_get_format(struct media_entity *entity,
-	struct v4l2_mbus_framefmt *format, unsigned int pad,
-	enum v4l2_subdev_format_whence which)
-{
-	struct v4l2_subdev_format fmt;
-	int ret;
-
-	ret = v4l2_subdev_open(entity);
-	if (ret < 0)
-		return ret;
-
-	memset(&fmt, 0, sizeof(fmt));
-	fmt.pad = pad;
-	fmt.which = which;
-
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
-	if (ret < 0)
-		return -errno;
-
-	*format = fmt.format;
-	return 0;
-}
-
-int v4l2_subdev_set_format(struct media_entity *entity,
-	struct v4l2_mbus_framefmt *format, unsigned int pad,
-	enum v4l2_subdev_format_whence which)
-{
-	struct v4l2_subdev_format fmt;
-	int ret;
-
-	ret = v4l2_subdev_open(entity);
-	if (ret < 0)
-		return ret;
-
-	memset(&fmt, 0, sizeof(fmt));
-	fmt.pad = pad;
-	fmt.which = which;
-	fmt.format = *format;
-
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
-	if (ret < 0)
-		return -errno;
-
-	*format = fmt.format;
-	return 0;
-}
-
-int v4l2_subdev_get_crop(struct media_entity *entity, struct v4l2_rect *rect,
-			 unsigned int pad, enum v4l2_subdev_format_whence which)
-{
-	struct v4l2_subdev_crop crop;
-	int ret;
-
-	ret = v4l2_subdev_open(entity);
-	if (ret < 0)
-		return ret;
-
-	memset(&crop, 0, sizeof(crop));
-	crop.pad = pad;
-	crop.which = which;
-
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &crop);
-	if (ret < 0)
-		return -errno;
-
-	*rect = crop.rect;
-	return 0;
-}
-
-int v4l2_subdev_set_crop(struct media_entity *entity, struct v4l2_rect *rect,
-			 unsigned int pad, enum v4l2_subdev_format_whence which)
-{
-	struct v4l2_subdev_crop crop;
-	int ret;
-
-	ret = v4l2_subdev_open(entity);
-	if (ret < 0)
-		return ret;
-
-	memset(&crop, 0, sizeof(crop));
-	crop.pad = pad;
-	crop.which = which;
-	crop.rect = *rect;
-
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_CROP, &crop);
-	if (ret < 0)
-		return -errno;
-
-	*rect = crop.rect;
-	return 0;
-}
-
-int v4l2_subdev_get_frame_interval(struct media_entity *entity,
-				   struct v4l2_fract *interval)
-{
-	struct v4l2_subdev_frame_interval ival;
-	int ret;
-
-	ret = v4l2_subdev_open(entity);
-	if (ret < 0)
-		return ret;
-
-	memset(&ival, 0, sizeof(ival));
-
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
-	if (ret < 0)
-		return -errno;
-
-	*interval = ival.interval;
-	return 0;
-}
-
-int v4l2_subdev_set_frame_interval(struct media_entity *entity,
-				   struct v4l2_fract *interval)
-{
-	struct v4l2_subdev_frame_interval ival;
-	int ret;
-
-	ret = v4l2_subdev_open(entity);
-	if (ret < 0)
-		return ret;
-
-	memset(&ival, 0, sizeof(ival));
-	ival.interval = *interval;
-
-	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
-	if (ret < 0)
-		return -errno;
-
-	*interval = ival.interval;
-	return 0;
-}
diff --git a/src/subdev.h b/src/subdev.h
deleted file mode 100644
index b5772e0..0000000
--- a/src/subdev.h
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- * Media controller test application
- *
- * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- */
-
-#ifndef __SUBDEV_H__
-#define __SUBDEV_H__
-
-#include <linux/v4l2-subdev.h>
-
-struct media_entity;
-
-/**
- * @brief Open a sub-device.
- * @param entity - sub-device media entity.
- *
- * Open the V4L2 subdev device node associated with @a entity. The file
- * descriptor is stored in the media_entity structure.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-int v4l2_subdev_open(struct media_entity *entity);
-
-/**
- * @brief Close a sub-device.
- * @param entity - sub-device media entity.
- *
- * Close the V4L2 subdev device node associated with the @a entity and opened by
- * a previous call to v4l2_subdev_open() (either explicit or implicit).
- */
-void v4l2_subdev_close(struct media_entity *entity);
-
-/**
- * @brief Retrieve the format on a pad.
- * @param entity - subdev-device media entity.
- * @param format - format to be filled.
- * @param pad - pad number.
- * @param which - identifier of the format to get.
- *
- * Retrieve the current format on the @a entity @a pad and store it in the
- * @a format structure.
- *
- * @a which is set to V4L2_SUBDEV_FORMAT_TRY to retrieve the try format stored
- * in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to retrieve the current
- * active format.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-int v4l2_subdev_get_format(struct media_entity *entity,
-	struct v4l2_mbus_framefmt *format, unsigned int pad,
-	enum v4l2_subdev_format_whence which);
-
-/**
- * @brief Set the format on a pad.
- * @param entity - subdev-device media entity.
- * @param format - format.
- * @param pad - pad number.
- * @param which - identifier of the format to set.
- *
- * Set the format on the @a entity @a pad to @a format. The driver is allowed to
- * modify the requested format, in which case @a format is updated with the
- * modifications.
- *
- * @a which is set to V4L2_SUBDEV_FORMAT_TRY to set the try format stored in the
- * file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to configure the device with an
- * active format.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-int v4l2_subdev_set_format(struct media_entity *entity,
-	struct v4l2_mbus_framefmt *format, unsigned int pad,
-	enum v4l2_subdev_format_whence which);
-
-/**
- * @brief Retrieve the crop rectangle on a pad.
- * @param entity - subdev-device media entity.
- * @param rect - crop rectangle to be filled.
- * @param pad - pad number.
- * @param which - identifier of the format to get.
- *
- * Retrieve the current crop rectangleon the @a entity @a pad and store it in
- * the @a rect structure.
- *
- * @a which is set to V4L2_SUBDEV_FORMAT_TRY to retrieve the try crop rectangle
- * stored in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to retrieve the
- * current active crop rectangle.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-int v4l2_subdev_get_crop(struct media_entity *entity, struct v4l2_rect *rect,
-	unsigned int pad, enum v4l2_subdev_format_whence which);
-
-/**
- * @brief Set the crop rectangle on a pad.
- * @param entity - subdev-device media entity.
- * @param rect - crop rectangle.
- * @param pad - pad number.
- * @param which - identifier of the format to set.
- *
- * Set the crop rectangle on the @a entity @a pad to @a rect. The driver is
- * allowed to modify the requested rectangle, in which case @a rect is updated
- * with the modifications.
- *
- * @a which is set to V4L2_SUBDEV_FORMAT_TRY to set the try crop rectangle
- * stored in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to configure the
- * device with an active crop rectangle.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-int v4l2_subdev_set_crop(struct media_entity *entity, struct v4l2_rect *rect,
-	unsigned int pad, enum v4l2_subdev_format_whence which);
-
-/**
- * @brief Retrieve the frame interval on a sub-device.
- * @param entity - subdev-device media entity.
- * @param interval - frame interval to be filled.
- *
- * Retrieve the current frame interval on subdev @a entity and store it in the
- * @a interval structure.
- *
- * Frame interval retrieving is usually supported only on devices at the
- * beginning of video pipelines, such as sensors.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-
-int v4l2_subdev_get_frame_interval(struct media_entity *entity,
-	struct v4l2_fract *interval);
-
-/**
- * @brief Set the frame interval on a sub-device.
- * @param entity - subdev-device media entity.
- * @param interval - frame interval.
- *
- * Set the frame interval on subdev @a entity to @a interval. The driver is
- * allowed to modify the requested frame interval, in which case @a interval is
- * updated with the modifications.
- *
- * Frame interval setting is usually supported only on devices at the beginning
- * of video pipelines, such as sensors.
- *
- * @return 0 on success, or a negative error code on failure.
- */
-int v4l2_subdev_set_frame_interval(struct media_entity *entity,
-	struct v4l2_fract *interval);
-
-#endif
-
diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
new file mode 100644
index 0000000..785209b
--- /dev/null
+++ b/src/v4l2subdev.c
@@ -0,0 +1,188 @@
+/*
+ * Media controller test application
+ *
+ * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+
+#include <linux/v4l2-subdev.h>
+
+#include "mediactl.h"
+#include "v4l2subdev.h"
+#include "tools.h"
+
+int v4l2_subdev_open(struct media_entity *entity)
+{
+	if (entity->fd != -1)
+		return 0;
+
+	entity->fd = open(entity->devname, O_RDWR);
+	if (entity->fd == -1) {
+		printf("%s: Failed to open subdev device node %s\n", __func__,
+			entity->devname);
+		return -errno;
+	}
+
+	return 0;
+}
+
+void v4l2_subdev_close(struct media_entity *entity)
+{
+	close(entity->fd);
+	entity->fd = -1;
+}
+
+int v4l2_subdev_get_format(struct media_entity *entity,
+	struct v4l2_mbus_framefmt *format, unsigned int pad,
+	enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_subdev_format fmt;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(&fmt, 0, sizeof(fmt));
+	fmt.pad = pad;
+	fmt.which = which;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FMT, &fmt);
+	if (ret < 0)
+		return -errno;
+
+	*format = fmt.format;
+	return 0;
+}
+
+int v4l2_subdev_set_format(struct media_entity *entity,
+	struct v4l2_mbus_framefmt *format, unsigned int pad,
+	enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_subdev_format fmt;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(&fmt, 0, sizeof(fmt));
+	fmt.pad = pad;
+	fmt.which = which;
+	fmt.format = *format;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FMT, &fmt);
+	if (ret < 0)
+		return -errno;
+
+	*format = fmt.format;
+	return 0;
+}
+
+int v4l2_subdev_get_crop(struct media_entity *entity, struct v4l2_rect *rect,
+			 unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_subdev_crop crop;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(&crop, 0, sizeof(crop));
+	crop.pad = pad;
+	crop.which = which;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_CROP, &crop);
+	if (ret < 0)
+		return -errno;
+
+	*rect = crop.rect;
+	return 0;
+}
+
+int v4l2_subdev_set_crop(struct media_entity *entity, struct v4l2_rect *rect,
+			 unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_subdev_crop crop;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(&crop, 0, sizeof(crop));
+	crop.pad = pad;
+	crop.which = which;
+	crop.rect = *rect;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_CROP, &crop);
+	if (ret < 0)
+		return -errno;
+
+	*rect = crop.rect;
+	return 0;
+}
+
+int v4l2_subdev_get_frame_interval(struct media_entity *entity,
+				   struct v4l2_fract *interval)
+{
+	struct v4l2_subdev_frame_interval ival;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(&ival, 0, sizeof(ival));
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_G_FRAME_INTERVAL, &ival);
+	if (ret < 0)
+		return -errno;
+
+	*interval = ival.interval;
+	return 0;
+}
+
+int v4l2_subdev_set_frame_interval(struct media_entity *entity,
+				   struct v4l2_fract *interval)
+{
+	struct v4l2_subdev_frame_interval ival;
+	int ret;
+
+	ret = v4l2_subdev_open(entity);
+	if (ret < 0)
+		return ret;
+
+	memset(&ival, 0, sizeof(ival));
+	ival.interval = *interval;
+
+	ret = ioctl(entity->fd, VIDIOC_SUBDEV_S_FRAME_INTERVAL, &ival);
+	if (ret < 0)
+		return -errno;
+
+	*interval = ival.interval;
+	return 0;
+}
diff --git a/src/v4l2subdev.h b/src/v4l2subdev.h
new file mode 100644
index 0000000..b5772e0
--- /dev/null
+++ b/src/v4l2subdev.h
@@ -0,0 +1,162 @@
+/*
+ * Media controller test application
+ *
+ * Copyright (C) 2010 Ideas on board SPRL <laurent.pinchart@ideasonboard.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ */
+
+#ifndef __SUBDEV_H__
+#define __SUBDEV_H__
+
+#include <linux/v4l2-subdev.h>
+
+struct media_entity;
+
+/**
+ * @brief Open a sub-device.
+ * @param entity - sub-device media entity.
+ *
+ * Open the V4L2 subdev device node associated with @a entity. The file
+ * descriptor is stored in the media_entity structure.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_open(struct media_entity *entity);
+
+/**
+ * @brief Close a sub-device.
+ * @param entity - sub-device media entity.
+ *
+ * Close the V4L2 subdev device node associated with the @a entity and opened by
+ * a previous call to v4l2_subdev_open() (either explicit or implicit).
+ */
+void v4l2_subdev_close(struct media_entity *entity);
+
+/**
+ * @brief Retrieve the format on a pad.
+ * @param entity - subdev-device media entity.
+ * @param format - format to be filled.
+ * @param pad - pad number.
+ * @param which - identifier of the format to get.
+ *
+ * Retrieve the current format on the @a entity @a pad and store it in the
+ * @a format structure.
+ *
+ * @a which is set to V4L2_SUBDEV_FORMAT_TRY to retrieve the try format stored
+ * in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to retrieve the current
+ * active format.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_get_format(struct media_entity *entity,
+	struct v4l2_mbus_framefmt *format, unsigned int pad,
+	enum v4l2_subdev_format_whence which);
+
+/**
+ * @brief Set the format on a pad.
+ * @param entity - subdev-device media entity.
+ * @param format - format.
+ * @param pad - pad number.
+ * @param which - identifier of the format to set.
+ *
+ * Set the format on the @a entity @a pad to @a format. The driver is allowed to
+ * modify the requested format, in which case @a format is updated with the
+ * modifications.
+ *
+ * @a which is set to V4L2_SUBDEV_FORMAT_TRY to set the try format stored in the
+ * file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to configure the device with an
+ * active format.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_set_format(struct media_entity *entity,
+	struct v4l2_mbus_framefmt *format, unsigned int pad,
+	enum v4l2_subdev_format_whence which);
+
+/**
+ * @brief Retrieve the crop rectangle on a pad.
+ * @param entity - subdev-device media entity.
+ * @param rect - crop rectangle to be filled.
+ * @param pad - pad number.
+ * @param which - identifier of the format to get.
+ *
+ * Retrieve the current crop rectangleon the @a entity @a pad and store it in
+ * the @a rect structure.
+ *
+ * @a which is set to V4L2_SUBDEV_FORMAT_TRY to retrieve the try crop rectangle
+ * stored in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to retrieve the
+ * current active crop rectangle.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_get_crop(struct media_entity *entity, struct v4l2_rect *rect,
+	unsigned int pad, enum v4l2_subdev_format_whence which);
+
+/**
+ * @brief Set the crop rectangle on a pad.
+ * @param entity - subdev-device media entity.
+ * @param rect - crop rectangle.
+ * @param pad - pad number.
+ * @param which - identifier of the format to set.
+ *
+ * Set the crop rectangle on the @a entity @a pad to @a rect. The driver is
+ * allowed to modify the requested rectangle, in which case @a rect is updated
+ * with the modifications.
+ *
+ * @a which is set to V4L2_SUBDEV_FORMAT_TRY to set the try crop rectangle
+ * stored in the file handle, of V4L2_SUBDEV_FORMAT_ACTIVE to configure the
+ * device with an active crop rectangle.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_set_crop(struct media_entity *entity, struct v4l2_rect *rect,
+	unsigned int pad, enum v4l2_subdev_format_whence which);
+
+/**
+ * @brief Retrieve the frame interval on a sub-device.
+ * @param entity - subdev-device media entity.
+ * @param interval - frame interval to be filled.
+ *
+ * Retrieve the current frame interval on subdev @a entity and store it in the
+ * @a interval structure.
+ *
+ * Frame interval retrieving is usually supported only on devices at the
+ * beginning of video pipelines, such as sensors.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+
+int v4l2_subdev_get_frame_interval(struct media_entity *entity,
+	struct v4l2_fract *interval);
+
+/**
+ * @brief Set the frame interval on a sub-device.
+ * @param entity - subdev-device media entity.
+ * @param interval - frame interval.
+ *
+ * Set the frame interval on subdev @a entity to @a interval. The driver is
+ * allowed to modify the requested frame interval, in which case @a interval is
+ * updated with the modifications.
+ *
+ * Frame interval setting is usually supported only on devices at the beginning
+ * of video pipelines, such as sensors.
+ *
+ * @return 0 on success, or a negative error code on failure.
+ */
+int v4l2_subdev_set_frame_interval(struct media_entity *entity,
+	struct v4l2_fract *interval);
+
+#endif
+
-- 
1.7.2.5


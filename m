Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:46171 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbaJQOzQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Oct 2014 10:55:16 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NDL00KS2G43MS30@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 17 Oct 2014 23:55:15 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: s.nawrocki@samsung.com, b.zolnierkie@samsung.com,
	kyungmin.park@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v2 2/4] Add media device related data structures and API.
Date: Fri, 17 Oct 2014 16:54:40 +0200
Message-id: <1413557682-20535-3-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
References: <1413557682-20535-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add helpers for retrieving media device topology and manipulating
its configuration.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 lib/include/libv4l2-mdev.h |  195 +++++++++
 lib/libv4l2/libv4l2-mdev.c |  975 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 1170 insertions(+)
 create mode 100644 lib/include/libv4l2-mdev.h
 create mode 100644 lib/libv4l2/libv4l2-mdev.c

diff --git a/lib/include/libv4l2-mdev.h b/lib/include/libv4l2-mdev.h
new file mode 100644
index 0000000..cb28835
--- /dev/null
+++ b/lib/include/libv4l2-mdev.h
@@ -0,0 +1,195 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ */
+
+#ifndef __LIBV4L2_MDEV_H
+#define __LIBV4L2_MDEV_H
+
+#include <libv4l2-media-conf-parser.h>
+#include <linux/v4l2-subdev.h>
+#include <linux/videodev2.h>
+#include <sys/syscall.h>
+
+#define SYS_IOCTL(fd, cmd, arg) \
+	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
+
+#ifdef DEBUG
+#define V4L2_MDEV_DBG(format, ARG...)\
+        printf("[%s:%d] [%s] " format " \n", __FILE__, __LINE__, __func__, ##ARG)
+#else
+#define V4L2_MDEV_DBG(format, ARG...)
+#endif
+
+#define V4L2_MDEV_ERR(format, ARG...)\
+        fprintf(stderr, "Libv4l media device: "format "\n", ##ARG)
+
+#define V4L2_MDEV_LOG(format, ARG...)\
+        fprintf(stdout, "Libv4l media device: "format "\n", ##ARG)
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+/*
+ * struct media_entity - media device entity data
+ * @id:			media entity id within media controller
+ * @name:		media entity name
+ * @node_name:		media entity related device node name
+ * @pads:		array of media_entity pads
+ * @num_pads:		number of elements in the pads array
+ * @links:		array of media_entity links
+ * @num_links:		number of elements in the links array
+ * @subdev_fmt:		related sub-device format
+ * @fd:			related sub-device node file descriptor
+ * @src_pad_id:		source pad id when entity is linked
+ * @sink_pad_id:	sink pad id when entity is linked
+ * @next:		pointer to the next data structure in the list
+ */
+struct media_entity {
+	int id;
+	char name[32];
+	char node_name[32];
+	struct media_pad_desc *pads;
+	int num_pads;
+	struct media_link_desc *links;
+	int num_links;
+	struct v4l2_subdev_format subdev_fmt;
+	int fd;
+	int src_pad_id;
+	int sink_pad_id;
+	struct media_entity *next;
+};
+
+/*
+ * struct media_device - media device comprising the opened video device
+ * @entities:		media entities comprised by a video device
+ * @num_entities:	number of media entities within a video device
+ * @pipeline:		pipeline of media entities from sensor to the video node
+ * @media_fd:		file descriptor of the media device this
+ *			video device belongs to
+ * @config:		media device configuration
+ * @vid_fd:		file descriptor of the opened video device node
+ */
+struct media_device {
+	struct media_entity *entities;
+	int num_entities;
+	struct media_entity *pipeline;
+	int media_fd;
+	struct libv4l2_media_device_conf config;
+	int vid_fd;
+};
+
+int mdev_get_node_by_devnum(unsigned int major, unsigned int minor,
+			char *node_name);
+
+int mdev_get_node_by_fd(int fd, char *node_name);
+
+int mdev_enumerate_links(struct media_device *mdev);
+
+int mdev_release_entities(struct media_device *mdev);
+
+int mdev_get_device_topology(struct media_device *mdev);
+
+int mdev_has_device_node(struct media_device *mdev, char *entity_node,
+			char **entity_name);
+
+int mdev_get_media_node(struct media_device *mdev, int capture_fd,
+			char **entity_name);
+
+int mdev_get_pad_parent_name(struct media_device *mdev,
+			struct media_pad_desc *pad, char **parent_name);
+
+int mdev_entity_get_id_by_name(struct media_device *mdev, char *name, int *id);
+
+int mdev_has_link_pad(struct media_link_desc *link,
+			struct media_pad_desc *pad);
+
+int mdev_pad_busy(struct media_device *mdev, struct media_pad_desc *pad,
+			struct media_link_desc **link);
+
+int mdev_print_link_log(char *message, struct media_device *mdev,
+			struct media_link_desc *link);
+
+int mdev_disable_link(struct media_device *mdev,
+			struct media_link_desc *link);
+
+int mdev_get_v4l2_pad(struct media_device *mdev, char *entity_name,
+			int pad_id, struct media_pad_desc *pad);
+
+int mdev_same_link(struct media_link_desc *link1,
+			struct media_link_desc *link2);
+
+int mdev_link_enabled(struct media_device *mdev,
+			struct media_link_desc *link);
+
+int mdev_get_entity_by_pad(struct media_device *mdev,
+			struct media_pad_desc *pad,
+			struct media_entity **entity);
+
+int mdev_setup_config_links(struct media_device *mdev,
+			struct libv4l2_media_link_conf *links);
+
+struct media_entity *mdev_get_entity_by_name(struct media_device *mdev,
+			char *name);
+
+struct media_entity *mdev_conf_get_entity_by_cid(
+			struct libv4l2_media_ctrl_conf *ctrl_cfg,
+			int cid);
+
+int mdev_is_control_supported(struct media_device *mdev,
+			struct libv4l2_media_ctrl_conf *ctrl_cfg);
+
+int mdev_validate_control_config(struct media_device *mdev,
+			struct libv4l2_media_ctrl_conf *ctrl_cfg);
+
+int mdev_get_entity_by_fd(struct media_device *mdev, int fd,
+			struct media_entity **entity);
+
+int mdev_get_pads_by_entity(struct media_entity *entity,
+			struct media_pad_desc **pads,
+			int *num_pads, unsigned int type);
+
+int mdev_get_src_entity_by_link(struct media_device *mdev,
+			struct media_link_desc *link,
+			struct media_entity **entity);
+
+int mdev_get_link_by_sink_pad(struct media_device *mdev,
+			struct media_pad_desc *pad,
+			struct media_link_desc **link);
+
+int mdev_get_link_by_source_pad(struct media_entity *entity,
+			struct media_pad_desc *pad,
+			struct media_link_desc **link);
+
+int mdev_get_busy_pads_by_entity(struct media_device *mdev,
+			struct media_entity *entity,
+			struct media_pad_desc **busy_pads,
+			int *num_busy_pads,
+			unsigned int type);
+
+int mdev_get_pad_by_index(struct media_pad_desc *pads, int num_pads,
+			int index, struct media_pad_desc *out_pad);
+
+int mdev_discover_pipeline_by_fd(struct media_device *mdev, int fd);
+
+void mdev_close_pipeline_subdevs(struct media_entity *pipeline);
+
+int mdev_open_pipeline_subdevs(struct media_entity *pipeline);
+
+int mdev_verify_format(struct v4l2_mbus_framefmt *fmt1,
+			struct v4l2_mbus_framefmt *fmt2);
+
+int mdev_has_pipeline_entity(struct media_entity *pipeline, char *entity);
+
+#endif /* __LIBV4L2_MDEV_H */
diff --git a/lib/libv4l2/libv4l2-mdev.c b/lib/libv4l2/libv4l2-mdev.c
new file mode 100644
index 0000000..ed05fd8
--- /dev/null
+++ b/lib/libv4l2/libv4l2-mdev.c
@@ -0,0 +1,975 @@
+/*
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *              http://www.samsung.com
+ *
+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ */
+
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/kdev_t.h>
+#include <linux/media.h>
+#include <linux/types.h>
+#include <linux/videodev2.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <libv4l2-mdev.h>
+
+/*
+ * If there was an entry for the cid defined in the controls
+ * config then this function returns related entity. Otherwise
+ * NULL is returned.
+ */
+struct media_entity *mdev_conf_get_entity_by_cid(
+				struct libv4l2_media_ctrl_conf *ctrl_cfg,
+				int cid)
+{
+	if (ctrl_cfg == NULL)
+		return NULL;
+
+	while (ctrl_cfg) {
+		if (ctrl_cfg->cid == cid)
+			return ctrl_cfg->entity;
+		ctrl_cfg = ctrl_cfg->next;
+	}
+
+	return NULL;
+}
+
+int mdev_get_node_by_devnum(unsigned int major, unsigned int minor,
+				char *node_name)
+{
+	struct stat devstat;
+	char devname[32];
+	char sysname[32];
+	char target[1024];
+	char *p;
+	int ret;
+
+	if (node_name == NULL)
+		return -EINVAL;
+
+	sprintf(sysname, "/sys/dev/char/%u:%u", major, minor);
+	ret = readlink(sysname, target, sizeof(target));
+	if (ret < 0)
+		return -EINVAL;
+
+	target[ret] = '\0';
+	p = strrchr(target, '/');
+	if (p == NULL)
+		return -EINVAL;
+
+	sprintf(devname, "/dev/%s", p + 1);
+	ret = stat(devname, &devstat);
+	if (ret < 0)
+		return -EINVAL;
+
+	if (major(devstat.st_rdev) == major &&
+	    minor(devstat.st_rdev) == minor)
+		strcpy(node_name, devname);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+int mdev_get_node_by_fd(int fd, char *node_name)
+{
+	struct stat stat;
+	int major_num, minor_num;
+	int ret;
+
+	if (node_name == NULL)
+		return -EINVAL;
+
+	ret = fstat(fd, &stat);
+	if (ret < 0)
+		return -EINVAL;
+
+	major_num = MAJOR(stat.st_rdev);
+	minor_num = MINOR(stat.st_rdev);
+
+	ret = mdev_get_node_by_devnum(major_num, minor_num, node_name);
+	if (ret < 0)
+		return -EINVAL;
+
+	return 0;
+}
+
+int mdev_enumerate_entites(struct media_device *mdev)
+{
+	struct media_entity *entity, *entity_buf;
+	struct media_entity_desc entity_desc;
+	unsigned int entities_cnt = 0, entity_buf_size;
+	int ret, id;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	entity_buf = calloc(1, sizeof(*entity));
+	memset(&entity_desc, 0, sizeof(entity_desc));
+
+	for (id = 0;; id = entity_desc.id, ++entities_cnt) {
+		entity_buf_size = (entities_cnt + 1) * sizeof(*entity);
+		entity_buf = realloc(entity_buf, entity_buf_size);
+
+		entity = &entity_buf[entities_cnt];
+		memset(entity, 0, sizeof(*entity));
+
+		entity_desc.id = id | MEDIA_ENT_ID_FLAG_NEXT;
+		ret = SYS_IOCTL(mdev->media_fd, MEDIA_IOC_ENUM_ENTITIES,
+			    &entity_desc);
+		if (ret < 0) {
+			ret = errno != EINVAL ? -errno : 0;
+			break;
+		}
+		entity->id = entity_desc.id;
+		entity->num_pads = entity_desc.pads;
+		entity->num_links = entity_desc.links;
+		strcpy(entity->name, entity_desc.name);
+
+		if (!(entity_desc.type & MEDIA_ENT_T_DEVNODE) &&
+		    !(entity_desc.type & MEDIA_ENT_T_V4L2_SUBDEV))
+			continue;
+
+		ret = mdev_get_node_by_devnum(entity_desc.v4l.major,
+						  entity_desc.v4l.minor,
+						  entity->node_name);
+		if (ret < 0)
+			goto err_media_dev;
+	}
+
+	mdev->num_entities = entities_cnt;
+	mdev->entities = entity_buf;
+
+	return ret;
+
+err_media_dev:
+	free(entity_buf);
+	return -EINVAL;
+}
+
+int mdev_enumerate_links(struct media_device *mdev)
+{
+	struct media_entity *entities = mdev->entities;
+	struct media_links_enum links_enum;
+	int i, j, ret;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (entities[i].num_pads == 0)
+			continue;
+		links_enum.entity = entities[i].id;
+		links_enum.pads = malloc(entities[i].num_pads *
+					 sizeof(struct media_pad_desc));
+		links_enum.links = malloc(entities[i].num_links *
+					  sizeof(struct media_link_desc));
+		ret = SYS_IOCTL(mdev->media_fd, MEDIA_IOC_ENUM_LINKS,
+			    &links_enum);
+		if (ret < 0) {
+			ret = -errno;
+			goto err_enum_links;
+		}
+
+		entities[i].pads = links_enum.pads;
+		entities[i].links = links_enum.links;
+	}
+
+	return 0;
+
+err_enum_links:
+	for (j = 0; j < i; ++j) {
+		free(entities[j].pads);
+		free(entities[j].links);
+	}
+
+	return ret;
+}
+
+int mdev_release_entities(struct media_device *mdev)
+{
+	int i;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		free(mdev->entities[i].links);
+		free(mdev->entities[i].pads);
+	}
+
+	free(mdev->entities);
+
+	return 0;
+}
+
+int mdev_get_device_topology(struct media_device *mdev)
+{
+	int ret;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	ret = mdev_enumerate_entites(mdev);
+	if (ret < 0) {
+		V4L2_MDEV_ERR("Failed to enumerate video entities.");
+		return ret;
+	}
+
+	ret = mdev_enumerate_links(mdev);
+	if (ret < 0) {
+		V4L2_MDEV_ERR("Failed to enumerate links.");
+		return ret;
+	}
+
+	return 0;
+}
+
+int mdev_has_device_node(struct media_device *mdev, char *entity_node,
+				char **entity_name)
+{
+	int i;
+
+	if (mdev == NULL || entity_node == NULL || entity_name == NULL)
+		return 0;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (!strcmp(mdev->entities[i].node_name, entity_node)) {
+			*entity_name = mdev->entities[i].name;
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+int mdev_get_media_node(struct media_device *mdev, int capture_fd,
+				char **entity_name)
+{
+	char media_dev_node[32], capture_dev_node[32];
+	int i, ret;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	ret = mdev_get_node_by_fd(capture_fd, capture_dev_node);
+	if (ret < 0)
+		return -EINVAL;
+
+	/* query all available media devices */
+	for (i = 0;; ++i) {
+		sprintf(media_dev_node, "/dev/media%d", i);
+
+		mdev->media_fd = open(media_dev_node, O_RDWR);
+		if (mdev->media_fd < 0) {
+			close(mdev->media_fd);
+			return -EINVAL;
+		}
+
+		ret = mdev_get_device_topology(mdev);
+		if (ret < 0)
+			goto err_get_topology;
+
+		if (mdev_has_device_node(mdev, capture_dev_node, entity_name))
+			return 0;
+
+		mdev_release_entities(mdev);
+		close(mdev->media_fd);
+	}
+
+	ret = -EINVAL;
+
+err_get_topology:
+	close(mdev->media_fd);
+	return ret;
+}
+
+int mdev_get_pad_parent_name(struct media_device *mdev,
+				struct media_pad_desc *pad,
+				char **parent_name)
+{
+	int i;
+
+	if (mdev == NULL || pad == NULL || parent_name == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (mdev->entities[i].id == pad->entity) {
+			*parent_name = mdev->entities[i].name;
+			break;
+		}
+	}
+
+	if (i == mdev->num_entities)
+		return -EINVAL;
+
+	return 0;
+}
+
+int mdev_entity_get_id_by_name(struct media_device *mdev, char *name,
+					int *id)
+{
+	int i;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (strcmp(mdev->entities[i].name, name) == 0) {
+			*id = mdev->entities[i].id;
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+
+}
+
+int mdev_has_link_pad(struct media_link_desc *link,
+			struct media_pad_desc *pad)
+{
+	if (link == NULL || pad == NULL)
+		return -EINVAL;
+
+	if (link->source.entity == pad->entity &&
+	    link->source.index == pad->index)
+		return 1;
+	if (link->sink.entity == pad->entity &&
+	    link->sink.index == pad->index)
+		return 1;
+
+	return 0;
+}
+
+int mdev_pad_busy(struct media_device *mdev, struct media_pad_desc *pad,
+			struct media_link_desc **link)
+{
+	struct media_link_desc *cur_link;
+	int i, j;
+
+	if (mdev == NULL || link == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		for (j = 0; j < mdev->entities[i].num_links; ++j) {
+			cur_link = &mdev->entities[i].links[j];
+			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
+			    mdev_has_link_pad(cur_link, pad)) {
+				*link = cur_link;
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int mdev_print_link_log(char *message, struct media_device *mdev,
+				struct media_link_desc *link)
+{
+	char *src_entity = NULL, *sink_entity = NULL;
+	int ret;
+
+	if (message == NULL || mdev == NULL || link == NULL)
+		return -EINVAL;
+
+	ret = mdev_get_pad_parent_name(mdev, &link->source, &src_entity);
+	if (ret < 0)
+		return ret;
+
+	ret = mdev_get_pad_parent_name(mdev, &link->sink, &sink_entity);
+	if (ret < 0)
+		return ret;
+
+	V4L2_MDEV_LOG("%s: [%s]:%d -> [%s]:%d", message, src_entity,
+			link->source.index, sink_entity, link->sink.index);
+
+	return 0;
+}
+
+int mdev_disable_link(struct media_device *mdev,
+				struct media_link_desc *link)
+{
+	int ret = -1;
+
+	if (mdev == NULL || link == NULL)
+		return -EINVAL;
+
+	if (link->flags & MEDIA_LNK_FL_IMMUTABLE) {
+		V4L2_MDEV_ERR("Can't disable immutable link.");
+		return -EINVAL;
+	}
+
+	link->flags &= ~MEDIA_LNK_FL_ENABLED;
+	ret = SYS_IOCTL(mdev->media_fd, MEDIA_IOC_SETUP_LINK, link);
+	if (ret) {
+		V4L2_MDEV_ERR("MEDIA_IOC_SETUP_LINK ioctl failed.");
+		return ret;
+	}
+
+	mdev_print_link_log("Disabled link.", mdev, link);
+
+	return 0;
+}
+
+int mdev_get_v4l2_pad(struct media_device *mdev, char *entity_name,
+			int pad_id, struct media_pad_desc *pad)
+{
+	int ret = -1, entity_id;
+
+	if (mdev == NULL || entity_name == NULL || pad == NULL)
+		return -EINVAL;
+
+	ret = mdev_entity_get_id_by_name(mdev, entity_name, &entity_id);
+	if (ret < 0)
+		return ret;
+
+	pad->entity = entity_id;
+	pad->index = pad_id;
+
+	return 0;
+}
+
+int mdev_same_link(struct media_link_desc *link1,
+			struct media_link_desc *link2)
+{
+	if (link1 == NULL || link2 == NULL)
+		return 0;
+
+	if (link1->source.entity == link2->source.entity &&
+	    link1->source.index == link2->source.index &&
+	    link1->sink.entity == link2->sink.entity &&
+	    link1->sink.index == link2->sink.index)
+		return 1;
+
+	return 0;
+}
+
+int mdev_link_enabled(struct media_device *mdev,
+			struct media_link_desc *link)
+{
+	struct media_link_desc *cur_link;
+	int i, j;
+
+	if (mdev == NULL || link == NULL)
+		return 0;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		for (j = 0; j < mdev->entities[i].num_links; ++j) {
+			cur_link = &mdev->entities[i].links[j];
+			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
+			    mdev_same_link(link, cur_link)) {
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int mdev_get_entity_by_pad(struct media_device *mdev,
+				struct media_pad_desc *pad,
+				struct media_entity **entity)
+{
+	int i;
+
+	if (mdev == NULL || pad == NULL || entity == NULL)
+		return -EINVAL;
+
+	    for (i = 0; i < mdev->num_entities; ++i) {
+		if (pad->entity == mdev->entities[i].id) {
+			*entity = &mdev->entities[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+int mdev_setup_config_links(struct media_device *mdev,
+				struct libv4l2_media_link_conf *links)
+{
+	struct media_link_desc new_link, *colliding_link;
+	struct media_entity *entity;
+	int i, ret;
+
+	if (mdev == NULL || links == NULL)
+		return -EINVAL;
+
+	while (links) {
+		ret = mdev_get_v4l2_pad(mdev, links->source_entity,
+					links->source_pad, &new_link.source);
+		if (ret < 0)
+			return ret;
+		ret = mdev_get_v4l2_pad(mdev, links->sink_entity,
+					links->sink_pad, &new_link.sink);
+		if (ret < 0)
+			return ret;
+
+		if (mdev_link_enabled(mdev, &new_link)) {
+			mdev_print_link_log("Link already enabled.", mdev,
+						&new_link);
+
+			links = links->next;
+			continue;
+		}
+
+		ret = mdev_get_entity_by_pad(mdev, &new_link.sink, &entity);
+		if (ret < 0)
+			return ret;
+
+		/* Disable all links occupying sink pads of the entity */
+		for (i = 0; i < entity->num_pads; ++i) {
+			if (entity->pads[i].flags & MEDIA_PAD_FL_SINK) {
+				if (mdev_pad_busy(mdev, &entity->pads[i],
+							&colliding_link)) {
+					ret = mdev_disable_link(mdev, colliding_link);
+					if (ret < 0)
+						return ret;
+				}
+			}
+		}
+
+		new_link.flags = MEDIA_LNK_FL_ENABLED;
+
+		mdev_print_link_log("Linking entities...", mdev, &new_link);
+
+		ret = SYS_IOCTL(mdev->media_fd, MEDIA_IOC_SETUP_LINK,
+			    &new_link);
+		if (ret < 0)
+			return ret;
+
+		V4L2_MDEV_LOG("Link has been set up successfuly.");
+
+		links = links->next;
+	}
+
+	return 0;
+}
+
+struct media_entity *mdev_get_entity_by_name(struct media_device *mdev,
+						char *name)
+{
+	int i;
+
+	for (i = 0; i < mdev->num_entities; ++i)
+		if (!strcmp(mdev->entities[i].name, name))
+			return &mdev->entities[i];
+
+	return NULL;
+}
+
+int mdev_is_control_supported(struct media_device *mdev,
+			struct libv4l2_media_ctrl_conf *ctrl_cfg)
+{
+	struct v4l2_query_ext_ctrl queryctrl;
+	struct media_entity *entity;
+
+	entity = mdev_get_entity_by_name(mdev, ctrl_cfg->entity_name);
+	if (entity == NULL)
+		return 0;
+
+	/* Iterate through control ids */
+
+	queryctrl.id = V4L2_CID_BASE | V4L2_CTRL_FLAG_NEXT_CTRL;
+
+	while (!SYS_IOCTL(entity->fd, VIDIOC_QUERY_EXT_CTRL, &queryctrl)) {
+		if (queryctrl.flags & V4L2_CTRL_FLAG_DISABLED)
+			continue;
+
+		if (!strcmp((char *) queryctrl.name, ctrl_cfg->control_name)) {
+			ctrl_cfg->cid = queryctrl.id & ~V4L2_CTRL_FLAG_NEXT_CTRL;
+			ctrl_cfg->entity = entity;
+			V4L2_MDEV_DBG("Validated config control \"%s\" (id: %x).",
+								queryctrl.name,
+								ctrl_cfg->cid);
+
+			return 1;
+		}
+
+		queryctrl.id = queryctrl.id | V4L2_CTRL_FLAG_NEXT_CTRL;
+	}
+
+	return 0;
+}
+
+int mdev_validate_control_config(struct media_device *mdev,
+				struct libv4l2_media_ctrl_conf *ctrl_cfg)
+{
+	if (mdev == NULL || ctrl_cfg == NULL)
+		return -EINVAL;
+
+	while (ctrl_cfg) {
+		if (!mdev_is_control_supported(mdev, ctrl_cfg)) {
+			V4L2_MDEV_ERR("Control \"%s\" is unsupported on %s.",
+					 ctrl_cfg->control_name,
+					 ctrl_cfg->entity_name);
+			return -EINVAL;
+		}
+
+		ctrl_cfg = ctrl_cfg->next;
+	}
+
+	return 0;
+}
+
+int mdev_get_entity_by_fd(struct media_device *mdev, int fd,
+				struct media_entity **entity)
+{
+	char node_name[32];
+	int i, ret;
+
+	if (mdev == NULL || entity == NULL)
+		return -EINVAL;
+
+	ret = mdev_get_node_by_fd(fd, node_name);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (strcmp(mdev->entities[i].node_name, node_name) == 0) {
+			*entity = &mdev->entities[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+int mdev_get_pads_by_entity(struct media_entity *entity,
+				struct media_pad_desc **pads,
+				int *num_pads, unsigned int type)
+{
+	struct media_pad_desc *entity_pads;
+	int cnt_pads, i;
+
+	if (entity == NULL || pads == NULL || num_pads == NULL)
+		return -EINVAL;
+
+	entity_pads = malloc(sizeof(*entity_pads));
+	cnt_pads = 0;
+
+	for (i = 0; i < entity->num_pads; ++i) {
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
+int mdev_get_src_entity_by_link(struct media_device *mdev,
+				struct media_link_desc *link,
+				struct media_entity **entity)
+{
+	int i;
+
+	if (mdev == NULL || link == NULL || entity == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		if (mdev->entities[i].id == link->source.entity) {
+			*entity = &mdev->entities[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+int mdev_get_link_by_sink_pad(struct media_device *mdev,
+				struct media_pad_desc *pad,
+				struct media_link_desc **link)
+{
+	struct media_link_desc *cur_link = NULL;
+	struct media_entity *entity;
+	int i, j, ret;
+
+	if (mdev == NULL || pad == NULL || link == NULL)
+		return -EINVAL;
+
+	ret = mdev_get_entity_by_pad(mdev, pad, &entity);
+	if (ret < 0)
+		return ret;
+
+	for (i = 0; i < mdev->num_entities; ++i) {
+		for (j = 0; j < mdev->entities[i].num_links; ++j) {
+			cur_link = &mdev->entities[i].links[j];
+			if ((cur_link->flags & MEDIA_LNK_FL_ENABLED) &&
+			    (cur_link->sink.entity == pad->entity) &&
+			    (cur_link->sink.index == pad->index)) {
+				*link = cur_link;
+				return 0;
+			}
+		}
+	}
+
+	return -EINVAL;
+}
+
+int mdev_get_link_by_source_pad(struct media_entity *entity,
+				struct media_pad_desc *pad,
+				struct media_link_desc **link)
+{
+	int i;
+
+	if (entity == NULL || pad == NULL || link == NULL)
+		return -EINVAL;
+
+	for (i = 0; i < entity->num_links; ++i) {
+		if ((entity->links[i].flags & MEDIA_LNK_FL_ENABLED) &&
+		    (entity->links[i].source.index == pad->index)) {
+			*link = &entity->links[i];
+			return 0;
+		}
+	}
+
+	return -EINVAL;
+}
+
+int mdev_get_busy_pads_by_entity(struct media_device *mdev,
+				struct media_entity *entity,
+				struct media_pad_desc **busy_pads,
+				int *num_busy_pads,
+				unsigned int type)
+{
+	struct media_pad_desc *bpads, *pads;
+	struct media_link_desc *link;
+	int cnt_bpads = 0, num_pads, i, ret;
+
+	if (entity == NULL || busy_pads == NULL || num_busy_pads == NULL ||
+	    (type == MEDIA_PAD_FL_SINK && mdev == NULL))
+		return -EINVAL;
+
+	ret = mdev_get_pads_by_entity(entity, &pads, &num_pads, type);
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
+			ret = mdev_get_link_by_sink_pad(mdev, &pads[i], &link);
+		else
+			ret = mdev_get_link_by_source_pad(entity, &pads[i], &link);
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
+int mdev_get_pad_by_index(struct media_pad_desc *pads, int num_pads,
+				int index, struct media_pad_desc *out_pad)
+
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
+int mdev_discover_pipeline_by_fd(struct media_device *mdev, int fd)
+{
+	struct media_entity *entity, *pipe_head = NULL;
+	struct media_pad_desc *sink_pads, sink_pad;
+	struct media_link_desc *link;
+	int num_sink_pads, prev_link_src_pad = -1, ret;
+
+	if (mdev == NULL)
+		return -EINVAL;
+
+	/* get sink pipeline entity */
+	ret = mdev_get_entity_by_fd(mdev, fd, &entity);
+	if (ret < 0)
+		return ret;
+
+	if (entity == NULL)
+		return -EINVAL;
+
+	entity->fd = fd;
+
+	for (;;) {
+		if (pipe_head == NULL) {
+			pipe_head = entity;
+		} else {
+			entity->next = pipe_head;
+			pipe_head = entity;
+		}
+
+		entity->src_pad_id = prev_link_src_pad;
+		ret = mdev_get_busy_pads_by_entity(mdev, entity,
+						     &sink_pads,
+						     &num_sink_pads,
+						     MEDIA_PAD_FL_SINK);
+		if (ret < 0)
+			return ret;
+
+		/* check if pipeline source entity has been reached */
+		if (num_sink_pads > 1) {
+			/* Case for two parallel active links */
+			ret = mdev_get_pad_by_index(sink_pads, num_sink_pads,
+							0, &sink_pad);
+			if (ret < 0)
+				return ret;
+		} else if (num_sink_pads == 1) {
+			sink_pad = sink_pads[0];
+		} else {
+			break;
+		}
+		if (num_sink_pads > 0)
+			free(sink_pads);
+
+		ret = mdev_get_link_by_sink_pad(mdev, &sink_pad,
+							&link);
+
+		prev_link_src_pad = link->source.index;
+		entity->sink_pad_id = link->sink.index;
+
+		ret = mdev_get_src_entity_by_link(mdev, link, &entity);
+		if (ret || entity == NULL)
+			return ret;
+	}
+
+	mdev->pipeline = pipe_head;
+
+	return 0;
+}
+
+void mdev_close_pipeline_subdevs(struct media_entity *pipeline)
+{
+	while (pipeline) {
+		close(pipeline->fd);
+		pipeline = pipeline->next;
+		if (pipeline->next == NULL)
+			break;
+	}
+}
+
+int mdev_open_pipeline_subdevs(struct media_entity *pipeline)
+{
+	struct media_entity *entity = pipeline;
+
+	if (pipeline == NULL)
+		return -EINVAL;
+
+	while (entity) {
+		entity->fd = open(entity->node_name, O_RDWR);
+		if (entity->fd < 0) {
+			V4L2_MDEV_DBG("Could not open device %s", entity->node_name);
+			goto err_open_subdev;
+		}
+
+		entity = entity->next;
+		if (entity->next == NULL)
+			break;
+	}
+
+	return 0;
+
+err_open_subdev:
+	if (pipeline == entity)
+		return 0;
+	mdev_close_pipeline_subdevs(pipeline);
+
+	return -EINVAL;
+}
+
+int mdev_verify_format(struct v4l2_mbus_framefmt *fmt1,
+				struct v4l2_mbus_framefmt *fmt2)
+{
+	if (fmt1 == NULL || fmt2 == NULL)
+		return 0;
+
+	if (fmt1->width != fmt2->width) {
+		V4L2_MDEV_DBG("width mismatch");
+		return 0;
+	}
+
+	if (fmt1->height != fmt2->height) {
+		V4L2_MDEV_DBG("height mismatch");
+		return 0;
+	}
+
+	if (fmt1->code != fmt2->code) {
+		V4L2_MDEV_DBG("code mismatch");
+		return 0;
+	}
+
+	if (fmt1->field != fmt2->field) {
+		V4L2_MDEV_DBG("field mismatch");
+		return 0;
+	}
+
+	if (fmt1->colorspace != fmt2->colorspace) {
+		V4L2_MDEV_DBG("colorspace mismatch");
+		return 0;
+	}
+
+	return 1;
+}
+
+int mdev_has_pipeline_entity(struct media_entity *pipeline, char *entity)
+{
+	if (pipeline == NULL || entity == NULL)
+		return -EINVAL;
+
+	while (pipeline) {
+		if (!strcmp(pipeline->name, entity))
+			return 1;
+		pipeline = pipeline->next;
+	}
+
+	return 0;
+}
-- 
1.7.9.5


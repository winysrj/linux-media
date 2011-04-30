Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59810 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab1D3Ndn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Apr 2011 09:33:43 -0400
Received: from localhost.localdomain (unknown [91.178.80.7])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 9930535A00
	for <linux-media@vger.kernel.org>; Sat, 30 Apr 2011 13:33:41 +0000 (UTC)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/4] uvcvideo: Register subdevices for each entity
Date: Sat, 30 Apr 2011 15:34:03 +0200
Message-Id: <1304170445-11978-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1304170445-11978-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Userspace applications can now discover the UVC device topology using
the media controller API.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/uvc/Makefile     |    2 +-
 drivers/media/video/uvc/uvc_driver.c |   25 ++++++++-
 drivers/media/video/uvc/uvc_entity.c |   94 ++++++++++++++++++++++++++++++++++
 drivers/media/video/uvc/uvcvideo.h   |   13 +++++
 4 files changed, 130 insertions(+), 4 deletions(-)
 create mode 100644 drivers/media/video/uvc/uvc_entity.c

diff --git a/drivers/media/video/uvc/Makefile b/drivers/media/video/uvc/Makefile
index 968c199..f23f55e 100644
--- a/drivers/media/video/uvc/Makefile
+++ b/drivers/media/video/uvc/Makefile
@@ -1,3 +1,3 @@
 uvcvideo-objs  := uvc_driver.o uvc_queue.o uvc_v4l2.o uvc_video.o uvc_ctrl.o \
-		  uvc_status.o uvc_isight.o
+		  uvc_entity.o uvc_status.o uvc_isight.o
 obj-$(CONFIG_USB_VIDEO_CLASS) += uvcvideo.o
diff --git a/drivers/media/video/uvc/uvc_driver.c b/drivers/media/video/uvc/uvc_driver.c
index 1d0696c..78e0836 100644
--- a/drivers/media/video/uvc/uvc_driver.c
+++ b/drivers/media/video/uvc/uvc_driver.c
@@ -243,7 +243,7 @@ uint32_t uvc_fraction_to_interval(uint32_t numerator, uint32_t denominator)
  * Terminal and unit management
  */
 
-static struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id)
+struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id)
 {
 	struct uvc_entity *entity;
 
@@ -790,9 +790,12 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 	struct uvc_entity *entity;
 	unsigned int num_inputs;
 	unsigned int size;
+	unsigned int i;
 
+	extra_size = ALIGN(extra_size, sizeof(*entity->pads));
 	num_inputs = (type & UVC_TERM_OUTPUT) ? num_pads : num_pads - 1;
-	size = sizeof(*entity) + extra_size + num_inputs;
+	size = sizeof(*entity) + extra_size + sizeof(*entity->pads) * num_pads
+	     + num_inputs;
 	entity = kzalloc(size, GFP_KERNEL);
 	if (entity == NULL)
 		return NULL;
@@ -800,8 +803,17 @@ static struct uvc_entity *uvc_alloc_entity(u16 type, u8 id,
 	entity->id = id;
 	entity->type = type;
 
+	entity->num_links = 0;
+	entity->num_pads = num_pads;
+	entity->pads = ((void *)(entity + 1)) + extra_size;
+
+	for (i = 0; i < num_inputs; ++i)
+		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
+	if (!UVC_ENTITY_IS_OTERM(entity))
+		entity->pads[num_pads-1].flags = MEDIA_PAD_FL_SOURCE;
+
 	entity->bNrInPins = num_inputs;
-	entity->baSourceID = ((__u8 *)entity) + sizeof(*entity) + extra_size;
+	entity->baSourceID = (__u8 *)(&entity->pads[num_pads]);
 
 	return entity;
 }
@@ -1594,6 +1606,7 @@ static void uvc_delete(struct uvc_device *dev)
 	list_for_each_safe(p, n, &dev->entities) {
 		struct uvc_entity *entity;
 		entity = list_entry(p, struct uvc_entity, list);
+		uvc_mc_cleanup_entity(entity);
 		kfree(entity);
 	}
 
@@ -1745,6 +1758,12 @@ static int uvc_register_chains(struct uvc_device *dev)
 		ret = uvc_register_terms(dev, chain);
 		if (ret < 0)
 			return ret;
+
+		ret = uvc_mc_register_entities(chain);
+		if (ret < 0) {
+			uvc_printk(KERN_INFO, "Failed to register entites "
+				"(%d).\n", ret);
+		}
 	}
 
 	return 0;
diff --git a/drivers/media/video/uvc/uvc_entity.c b/drivers/media/video/uvc/uvc_entity.c
new file mode 100644
index 0000000..8e8e7ef
--- /dev/null
+++ b/drivers/media/video/uvc/uvc_entity.c
@@ -0,0 +1,94 @@
+/*
+ *      uvc_entity.c  --  USB Video Class driver
+ *
+ *      Copyright (C) 2005-2011
+ *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/videodev2.h>
+
+#include <media/v4l2-common.h>
+
+#include "uvcvideo.h"
+
+/* ------------------------------------------------------------------------
+ * Video subdevices registration and unregistration
+ */
+
+static int uvc_mc_register_entity(struct uvc_video_chain *chain,
+	struct uvc_entity *entity)
+{
+	const u32 flags = MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE;
+	struct uvc_entity *remote;
+	unsigned int i;
+	u8 remote_pad;
+	int ret;
+
+	for (i = 0; i < entity->num_pads; ++i) {
+		if (!(entity->pads[i].flags & MEDIA_PAD_FL_SINK))
+			continue;
+
+		remote = uvc_entity_by_id(chain->dev, entity->baSourceID[i]);
+		if (remote == NULL)
+			return -EINVAL;
+
+		remote_pad = remote->num_pads - 1;
+		ret = media_entity_create_link(&remote->subdev.entity,
+				remote_pad, &entity->subdev.entity, i, flags);
+		if (ret < 0)
+			return ret;
+	}
+
+	return v4l2_device_register_subdev(&chain->dev->vdev, &entity->subdev);
+}
+
+static struct v4l2_subdev_ops uvc_subdev_ops = {
+};
+
+void uvc_mc_cleanup_entity(struct uvc_entity *entity)
+{
+	media_entity_cleanup(&entity->subdev.entity);
+}
+
+static int uvc_mc_init_entity(struct uvc_entity *entity)
+{
+	v4l2_subdev_init(&entity->subdev, &uvc_subdev_ops);
+	strlcpy(entity->subdev.name, entity->name, sizeof(entity->subdev.name));
+
+	return media_entity_init(&entity->subdev.entity, entity->num_pads,
+				 entity->pads, 0);
+}
+
+int uvc_mc_register_entities(struct uvc_video_chain *chain)
+{
+	struct uvc_entity *entity;
+	int ret;
+
+	list_for_each_entry(entity, &chain->entities, chain) {
+		ret = uvc_mc_init_entity(entity);
+		if (ret < 0) {
+			uvc_printk(KERN_INFO, "Failed to initialize entity for "
+				   "entity %u\n", entity->id);
+			return ret;
+		}
+	}
+
+	list_for_each_entry(entity, &chain->entities, chain) {
+		ret = uvc_mc_register_entity(chain, entity);
+		if (ret < 0) {
+			uvc_printk(KERN_INFO, "Failed to register entity for "
+				   "entity %u\n", entity->id);
+			return ret;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/media/video/uvc/uvcvideo.h b/drivers/media/video/uvc/uvcvideo.h
index 87ce89e..87014fb 100644
--- a/drivers/media/video/uvc/uvcvideo.h
+++ b/drivers/media/video/uvc/uvcvideo.h
@@ -98,6 +98,7 @@ struct uvc_xu_control {
 #ifdef __KERNEL__
 
 #include <linux/poll.h>
+#include <linux/usb.h>
 #include <linux/usb/video.h>
 #include <linux/uvcvideo.h>
 #include <media/media-device.h>
@@ -300,6 +301,12 @@ struct uvc_entity {
 	__u16 type;
 	char name[64];
 
+	/* Media controller-related fields. */
+	struct v4l2_subdev subdev;
+	unsigned int num_pads;
+	unsigned int num_links;
+	struct media_pad *pads;
+
 	union {
 		struct {
 			__u16 wObjectiveFocalLengthMin;
@@ -584,6 +591,8 @@ extern unsigned int uvc_timeout_param;
 /* Core driver */
 extern struct uvc_driver uvc_driver;
 
+extern struct uvc_entity *uvc_entity_by_id(struct uvc_device *dev, int id);
+
 /* Video buffers queue management. */
 extern void uvc_queue_init(struct uvc_video_queue *queue,
 		enum v4l2_buf_type type, int drop_corrupted);
@@ -613,6 +622,10 @@ static inline int uvc_queue_streaming(struct uvc_video_queue *queue)
 /* V4L2 interface */
 extern const struct v4l2_file_operations uvc_fops;
 
+/* Media controller */
+extern int uvc_mc_register_entities(struct uvc_video_chain *chain);
+extern void uvc_mc_cleanup_entity(struct uvc_entity *entity);
+
 /* Video */
 extern int uvc_video_init(struct uvc_streaming *stream);
 extern int uvc_video_suspend(struct uvc_streaming *stream);
-- 
1.7.3.4


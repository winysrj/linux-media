Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:43921 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340AbZJTIPA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 04:15:00 -0400
Message-Id: <20091020011216.038361298@ideasonboard.com>
Date: Tue, 20 Oct 2009 03:12:24 +0200
From: laurent.pinchart@ideasonboard.com
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com, hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC/PATCH 14/14] uvcvideo: Register subdevices for each entity
References: <20091020011210.623421213@ideasonboard.com>
Content-Disposition: inline; filename=uvc-mc.patch
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Userspace applications can now discover the UVC device topology using
the media controller API.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvc_driver.c
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvc_driver.c
@@ -762,9 +762,12 @@ static struct uvc_entity *uvc_alloc_enti
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
@@ -772,8 +775,17 @@ static struct uvc_entity *uvc_alloc_enti
 	entity->id = id;
 	entity->type = type;
 
+	entity->num_links = 0;
+	entity->num_pads = num_pads;
+	entity->pads = ((void *)(entity + 1)) + extra_size;
+
+	for (i = 0; i < num_inputs; ++i)
+		entity->pads[i].type = V4L2_PAD_TYPE_INPUT;
+	if (!UVC_ENTITY_IS_OTERM(entity))
+		entity->pads[num_pads-1].type = V4L2_PAD_TYPE_OUTPUT;
+
 	entity->bNrInPins = num_inputs;
-	entity->baSourceID = ((__u8 *)entity) + sizeof(*entity) + extra_size;
+	entity->baSourceID = (__u8 *)(&entity->pads[num_pads]);
 
 	return entity;
 }
@@ -1158,6 +1170,77 @@ next_descriptor:
 }
 
 /* ------------------------------------------------------------------------
+ * Video subdevices registration and unregistration
+ */
+
+static int uvc_mc_register_subdev(struct uvc_video_chain *chain,
+	struct uvc_entity *entity)
+{
+	const u32 flags = V4L2_LINK_FLAG_ACTIVE | V4L2_LINK_FLAG_PERMANENT;
+	struct uvc_entity *remote;
+	unsigned int i;
+	u8 remote_pad;
+	int ret;
+
+	for (i = 0; i < entity->num_pads; ++i) {
+		if (entity->pads[i].type != V4L2_PAD_TYPE_INPUT)
+			continue;
+
+		remote = uvc_entity_by_id(chain->dev, entity->baSourceID[i]);
+		if (remote == NULL)
+			return -EINVAL;
+
+		remote_pad = remote->num_pads - 1;
+		ret = v4l2_entity_connect(&remote->subdev.entity, remote_pad,
+					  &entity->subdev.entity, i, flags);
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
+static int uvc_mc_init_subdev(struct uvc_video_chain *chain,
+	struct uvc_entity *entity)
+{
+	v4l2_subdev_init(&entity->subdev, &uvc_subdev_ops);
+	snprintf(entity->subdev.name, sizeof(entity->subdev.name), "uvc-%u",
+		 entity->id);
+
+	return v4l2_entity_init(&entity->subdev.entity, entity->num_pads,
+				entity->pads, 0);
+}
+
+static int uvc_mc_register_subdevs(struct uvc_video_chain *chain)
+{
+	struct uvc_entity *entity;
+	int ret;
+
+	list_for_each_entry(entity, &chain->entities, chain) {
+		ret = uvc_mc_init_subdev(chain, entity);
+		if (ret < 0) {
+			uvc_printk(KERN_INFO, "Failed to initialize subdev for "
+				   "entity %u\n", entity->id);
+			return ret;
+		}
+	}
+
+	list_for_each_entry(entity, &chain->entities, chain) {
+		ret = uvc_mc_register_subdev(chain, entity);
+		if (ret < 0) {
+			uvc_printk(KERN_INFO, "Failed to register subdev for "
+				   "entity %u\n", entity->id);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/* ------------------------------------------------------------------------
  * UVC device scan
  */
 
@@ -1708,6 +1791,12 @@ static int uvc_register_chains(struct uv
 		ret = uvc_register_terms(dev, chain);
 		if (ret < 0)
 			return ret;
+
+		ret = uvc_mc_register_subdevs(chain);
+		if (ret < 0) {
+			uvc_printk(KERN_INFO, "Failed to register subdevs "
+				"(%d).\n", ret);
+		}
 	}
 
 	return 0;
Index: v4l-dvb-mc/linux/drivers/media/video/uvc/uvcvideo.h
===================================================================
--- v4l-dvb-mc.orig/linux/drivers/media/video/uvc/uvcvideo.h
+++ v4l-dvb-mc/linux/drivers/media/video/uvc/uvcvideo.h
@@ -278,6 +278,12 @@ struct uvc_entity {
 	__u16 type;
 	char name[64];
 
+	/* Media controller-related fields. */
+	struct v4l2_subdev subdev;
+	unsigned int num_pads;
+	unsigned int num_links;
+	struct v4l2_entity_pad *pads;
+
 	union {
 		struct {
 			__u16 wObjectiveFocalLengthMin;



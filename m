Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48304 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176AbcBHLoK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:44:10 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 18/35] v4l: vsp1: Extract link creation to separate function
Date: Mon,  8 Feb 2016 13:43:48 +0200
Message-Id: <1454931845-23864-19-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Link creation will be handled differently for the DU pipeline.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 95 ++++++++++++++++++++--------------
 1 file changed, 56 insertions(+), 39 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 0fb654e72633..81c49bfdc8dd 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -67,7 +67,7 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
  */
 
 /*
- * vsp1_create_links - Create links from all sources to the given sink
+ * vsp1_create_sink_links - Create links from all sources to the given sink
  *
  * This function creates media links from all valid sources to the given sink
  * pad. Links that would be invalid according to the VSP1 hardware capabilities
@@ -76,26 +76,14 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
  * - from a UDS to a UDS (UDS entities can't be chained)
  * - from an entity to itself (no loops are allowed)
  */
-static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
+static int vsp1_create_sink_links(struct vsp1_device *vsp1,
+				  struct vsp1_entity *sink)
 {
 	struct media_entity *entity = &sink->subdev.entity;
 	struct vsp1_entity *source;
 	unsigned int pad;
 	int ret;
 
-	if (sink->type == VSP1_ENTITY_RPF) {
-		struct vsp1_rwpf *rpf = to_rwpf(&sink->subdev);
-
-		/* RPFs have no source entities, just connect their source pad
-		 * to their video device.
-		 */
-		return media_create_pad_link(&rpf->video->video.entity, 0,
-					     &rpf->entity.subdev.entity,
-					     RWPF_PAD_SINK,
-					     MEDIA_LNK_FL_ENABLED |
-					     MEDIA_LNK_FL_IMMUTABLE);
-	}
-
 	list_for_each_entry(source, &vsp1->entities, list_dev) {
 		u32 flags;
 
@@ -126,21 +114,63 @@ static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
 		}
 	}
 
-	if (sink->type == VSP1_ENTITY_WPF) {
-		struct vsp1_rwpf *wpf = to_rwpf(&sink->subdev);
-		unsigned int flags = MEDIA_LNK_FL_ENABLED;
+	return 0;
+}
 
+static int vsp1_create_links(struct vsp1_device *vsp1)
+{
+	struct vsp1_entity *entity;
+	unsigned int i;
+	int ret;
+
+	list_for_each_entry(entity, &vsp1->entities, list_dev) {
+		if (entity->type == VSP1_ENTITY_LIF ||
+		    entity->type == VSP1_ENTITY_RPF)
+			continue;
+
+		ret = vsp1_create_sink_links(vsp1, entity);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (vsp1->pdata.features & VSP1_HAS_LIF) {
+		ret = media_create_pad_link(&vsp1->wpf[0]->entity.subdev.entity,
+					    RWPF_PAD_SOURCE,
+					    &vsp1->lif->entity.subdev.entity,
+					    LIF_PAD_SINK, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+		struct vsp1_rwpf *rpf = vsp1->rpf[i];
+
+		ret = media_create_pad_link(&rpf->video->video.entity, 0,
+					    &rpf->entity.subdev.entity,
+					    RWPF_PAD_SINK,
+					    MEDIA_LNK_FL_ENABLED |
+					    MEDIA_LNK_FL_IMMUTABLE);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
 		/* Connect the video device to the WPF. All connections are
 		 * immutable except for the WPF0 source link if a LIF is
 		 * present.
 		 */
-		if (!(vsp1->pdata.features & VSP1_HAS_LIF) || sink->index != 0)
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		unsigned int flags = MEDIA_LNK_FL_ENABLED;
+
+		if (!(vsp1->pdata.features & VSP1_HAS_LIF) || i != 0)
 			flags |= MEDIA_LNK_FL_IMMUTABLE;
 
-		return media_create_pad_link(&wpf->entity.subdev.entity,
-					     RWPF_PAD_SOURCE,
-					     &wpf->video->video.entity,
-					     0, flags);
+		ret = media_create_pad_link(&wpf->entity.subdev.entity,
+					    RWPF_PAD_SOURCE,
+					    &wpf->video->video.entity, 0,
+					    flags);
+		if (ret < 0)
+			return ret;
 	}
 
 	return 0;
@@ -310,22 +340,9 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	/* Create links. */
-	list_for_each_entry(entity, &vsp1->entities, list_dev) {
-		if (entity->type == VSP1_ENTITY_LIF)
-			continue;
-
-		ret = vsp1_create_links(vsp1, entity);
-		if (ret < 0)
-			goto done;
-	}
-
-	if (vsp1->pdata.features & VSP1_HAS_LIF) {
-		ret = media_create_pad_link(
-			&vsp1->wpf[0]->entity.subdev.entity, RWPF_PAD_SOURCE,
-			&vsp1->lif->entity.subdev.entity, LIF_PAD_SINK, 0);
-		if (ret < 0)
-			return ret;
-	}
+	ret = vsp1_create_links(vsp1);
+	if (ret < 0)
+		goto done;
 
 	ret = v4l2_device_register_subdev_nodes(&vsp1->v4l2_dev);
 	if (ret < 0)
-- 
2.4.10


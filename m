Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52349 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbbIMU5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:21 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 15/32] v4l: vsp1: Extract link creation to separate function
Date: Sun, 13 Sep 2015 23:56:53 +0300
Message-Id: <1442177830-24536-16-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Link creation will be handled differently for the DU pipeline.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 114 ++++++++++++++++++---------------
 1 file changed, 64 insertions(+), 50 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 91ecf75119ba..d1e42260a871 100644
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
@@ -76,7 +76,8 @@ static irqreturn_t vsp1_irq_handler(int irq, void *data)
  * - from a UDS to a UDS (UDS entities can't be chained)
  * - from an entity to itself (no loops are allowed)
  */
-static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
+static int vsp1_create_sink_links(struct vsp1_device *vsp1,
+				  struct vsp1_entity *sink)
 {
 	struct media_entity *entity = &sink->subdev.entity;
 	struct vsp1_entity *source;
@@ -116,6 +117,64 @@ static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
 	return 0;
 }
 
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
+	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
+		struct vsp1_rwpf *rpf = vsp1->rpf[i];
+
+		ret = media_entity_create_link(&rpf->video->video.entity, 0,
+					       &rpf->entity.subdev.entity,
+					       RWPF_PAD_SINK,
+					       MEDIA_LNK_FL_ENABLED |
+					       MEDIA_LNK_FL_IMMUTABLE);
+		if (ret < 0)
+			return ret;
+	}
+
+	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
+		/* Connect the video device to the WPF. All connections are
+		 * immutable except for the WPF0 source link if a LIF is
+		 * present.
+		 */
+		struct vsp1_rwpf *wpf = vsp1->wpf[i];
+		unsigned int flags = MEDIA_LNK_FL_ENABLED;
+
+		if (!(vsp1->pdata.features & VSP1_HAS_LIF) || i != 0)
+			flags |= MEDIA_LNK_FL_IMMUTABLE;
+
+		ret = media_entity_create_link(&wpf->entity.subdev.entity,
+					       RWPF_PAD_SOURCE,
+					       &wpf->video->video.entity,
+					       0, flags);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (vsp1->pdata.features & VSP1_HAS_LIF) {
+		ret = media_entity_create_link(
+			&vsp1->wpf[0]->entity.subdev.entity, RWPF_PAD_SOURCE,
+			&vsp1->lif->entity.subdev.entity, LIF_PAD_SINK, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static void vsp1_destroy_entities(struct vsp1_device *vsp1)
 {
 	struct vsp1_entity *entity, *_entity;
@@ -276,54 +335,9 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	}
 
 	/* Create links. */
-	list_for_each_entry(entity, &vsp1->entities, list_dev) {
-		if (entity->type == VSP1_ENTITY_LIF ||
-		    entity->type == VSP1_ENTITY_RPF)
-			continue;
-
-		ret = vsp1_create_links(vsp1, entity);
-		if (ret < 0)
-			goto done;
-	}
-
-	for (i = 0; i < vsp1->pdata.rpf_count; ++i) {
-		struct vsp1_rwpf *rpf = vsp1->rpf[i];
-
-		ret = media_entity_create_link(&rpf->video->video.entity, 0,
-					       &rpf->entity.subdev.entity,
-					       RWPF_PAD_SINK,
-					       MEDIA_LNK_FL_ENABLED |
-					       MEDIA_LNK_FL_IMMUTABLE);
-		if (ret < 0)
-			goto done;
-	}
-
-	for (i = 0; i < vsp1->pdata.wpf_count; ++i) {
-		/* Connect the video device to the WPF. All connections are
-		 * immutable except for the WPF0 source link if a LIF is
-		 * present.
-		 */
-		struct vsp1_rwpf *wpf = vsp1->wpf[i];
-		unsigned int flags = MEDIA_LNK_FL_ENABLED;
-
-		if (!(vsp1->pdata.features & VSP1_HAS_LIF) || i != 0)
-			flags |= MEDIA_LNK_FL_IMMUTABLE;
-
-		ret = media_entity_create_link(&wpf->entity.subdev.entity,
-					       RWPF_PAD_SOURCE,
-					       &wpf->video->video.entity,
-					       0, flags);
-		if (ret < 0)
-			goto done;
-	}
-
-	if (vsp1->pdata.features & VSP1_HAS_LIF) {
-		ret = media_entity_create_link(
-			&vsp1->wpf[0]->entity.subdev.entity, RWPF_PAD_SOURCE,
-			&vsp1->lif->entity.subdev.entity, LIF_PAD_SINK, 0);
-		if (ret < 0)
-			return ret;
-	}
+	ret = vsp1_create_links(vsp1);
+	if (ret < 0)
+		goto done;
 
 	/* Register all subdevs. */
 	list_for_each_entry(entity, &vsp1->entities, list_dev) {
-- 
2.4.6


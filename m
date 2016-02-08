Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:48305 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbcBHLn5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Feb 2016 06:43:57 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 03/35] v4l: vsp1: Group all link creation code in a single file
Date: Mon,  8 Feb 2016 13:43:33 +0200
Message-Id: <1454931845-23864-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1454931845-23864-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's no need to spread the code across multiple source files.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_drv.c  | 50 +++++++++++++++++++++++----------
 drivers/media/platform/vsp1/vsp1_rpf.c  | 20 -------------
 drivers/media/platform/vsp1/vsp1_rwpf.h |  5 ----
 drivers/media/platform/vsp1/vsp1_wpf.c  | 25 -----------------
 4 files changed, 35 insertions(+), 65 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 533bc796391e..d7f653123712 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -82,6 +82,19 @@ static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
 	unsigned int pad;
 	int ret;
 
+	if (sink->type == VSP1_ENTITY_RPF) {
+		struct vsp1_rwpf *rpf = to_rwpf(&sink->subdev);
+
+		/* RPFs have no source entities, just connect their source pad
+		 * to their video device.
+		 */
+		return media_create_pad_link(&rpf->video.video.entity, 0,
+					     &rpf->entity.subdev.entity,
+					     RWPF_PAD_SINK,
+					     MEDIA_LNK_FL_ENABLED |
+					     MEDIA_LNK_FL_IMMUTABLE);
+	}
+
 	list_for_each_entry(source, &vsp1->entities, list_dev) {
 		u32 flags;
 
@@ -112,6 +125,23 @@ static int vsp1_create_links(struct vsp1_device *vsp1, struct vsp1_entity *sink)
 		}
 	}
 
+	if (sink->type == VSP1_ENTITY_WPF) {
+		struct vsp1_rwpf *wpf = to_rwpf(&sink->subdev);
+		unsigned int flags = MEDIA_LNK_FL_ENABLED;
+
+		/* Connect the video device to the WPF. All connections are
+		 * immutable except for the WPF0 source link if a LIF is
+		 * present.
+		 */
+		if (!(vsp1->pdata.features & VSP1_HAS_LIF) || sink->index != 0)
+			flags |= MEDIA_LNK_FL_IMMUTABLE;
+
+		return media_create_pad_link(&wpf->entity.subdev.entity,
+					     RWPF_PAD_SOURCE,
+					     &wpf->video.video.entity, 0,
+					     flags);
+	}
+
 	return 0;
 }
 
@@ -256,22 +286,12 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	/* Create links. */
 	list_for_each_entry(entity, &vsp1->entities, list_dev) {
-		if (entity->type == VSP1_ENTITY_WPF) {
-			ret = vsp1_wpf_create_links(vsp1, entity);
-			if (ret < 0)
-				goto done;
-		} else if (entity->type == VSP1_ENTITY_RPF) {
-			ret = vsp1_rpf_create_links(vsp1, entity);
-			if (ret < 0)
-				goto done;
-		}
+		if (entity->type == VSP1_ENTITY_LIF)
+			continue;
 
-		if (entity->type != VSP1_ENTITY_LIF &&
-		    entity->type != VSP1_ENTITY_RPF) {
-			ret = vsp1_create_links(vsp1, entity);
-			if (ret < 0)
-				goto done;
-		}
+		ret = vsp1_create_links(vsp1, entity);
+		if (ret < 0)
+			goto done;
 	}
 
 	if (vsp1->pdata.features & VSP1_HAS_LIF) {
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 924538223d3e..b988e46818a5 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -283,23 +283,3 @@ error:
 	vsp1_entity_destroy(&rpf->entity);
 	return ERR_PTR(ret);
 }
-
-/*
- * vsp1_rpf_create_links() - RPF pads links creation
- * @vsp1: Pointer to VSP1 device
- * @entity: Pointer to VSP1 entity
- *
- * return negative error code or zero on success
- */
-int vsp1_rpf_create_links(struct vsp1_device *vsp1,
-			       struct vsp1_entity *entity)
-{
-	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
-
-	/* Connect the video device to the RPF. */
-	return media_create_pad_link(&rpf->video.video.entity, 0,
-				     &rpf->entity.subdev.entity,
-				     RWPF_PAD_SINK,
-				     MEDIA_LNK_FL_ENABLED |
-				     MEDIA_LNK_FL_IMMUTABLE);
-}
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 731d36e5258d..f452dce1a931 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -50,11 +50,6 @@ static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
 struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index);
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
 
-int vsp1_rpf_create_links(struct vsp1_device *vsp1,
-			       struct vsp1_entity *entity);
-int vsp1_wpf_create_links(struct vsp1_device *vsp1,
-			       struct vsp1_entity *entity);
-
 int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_mbus_code_enum *code);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index cbf514a6582d..1d722f7e2407 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -283,28 +283,3 @@ error:
 	vsp1_entity_destroy(&wpf->entity);
 	return ERR_PTR(ret);
 }
-
-/*
- * vsp1_wpf_create_links() - RPF pads links creation
- * @vsp1: Pointer to VSP1 device
- * @entity: Pointer to VSP1 entity
- *
- * return negative error code or zero on success
- */
-int vsp1_wpf_create_links(struct vsp1_device *vsp1,
-			       struct vsp1_entity *entity)
-{
-	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
-	unsigned int flags;
-
-	/* Connect the video device to the WPF. All connections are immutable
-	 * except for the WPF0 source link if a LIF is present.
-	 */
-	flags = MEDIA_LNK_FL_ENABLED;
-	if (!(vsp1->pdata.features & VSP1_HAS_LIF) || entity->index != 0)
-		flags |= MEDIA_LNK_FL_IMMUTABLE;
-
-	return media_create_pad_link(&wpf->entity.subdev.entity,
-				     RWPF_PAD_SOURCE,
-				     &wpf->video.video.entity, 0, flags);
-}
-- 
2.4.10


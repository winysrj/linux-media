Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37360 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965207AbcDYVg1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 17:36:27 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 08/13] v4l: vsp1: Make vsp1_entity_get_pad_compose() more generic
Date: Tue, 26 Apr 2016 00:36:33 +0300
Message-Id: <1461620198-13428-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1461620198-13428-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Turn the helper into a function that can retrieve crop and compose
selection rectangles.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_entity.c | 24 ++++++++++++++++++++----
 drivers/media/platform/vsp1/vsp1_entity.h |  6 +++---
 drivers/media/platform/vsp1/vsp1_rpf.c    |  7 ++++---
 3 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index f60d7926d53f..8c49a74381a1 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -87,12 +87,28 @@ vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 	return v4l2_subdev_get_try_format(&entity->subdev, cfg, pad);
 }
 
+/**
+ * vsp1_entity_get_pad_selection - Get a pad selection from storage for entity
+ * @entity: the entity
+ * @cfg: the configuration storage
+ * @pad: the pad number
+ * @target: the selection target
+ *
+ * Return the selection rectangle stored in the given configuration for an
+ * entity's pad. The configuration can be an ACTIVE or TRY configuration. The
+ * selection target can be COMPOSE or CROP.
+ */
 struct v4l2_rect *
-vsp1_entity_get_pad_compose(struct vsp1_entity *entity,
-			    struct v4l2_subdev_pad_config *cfg,
-			    unsigned int pad)
+vsp1_entity_get_pad_selection(struct vsp1_entity *entity,
+			      struct v4l2_subdev_pad_config *cfg,
+			      unsigned int pad, unsigned int target)
 {
-	return v4l2_subdev_get_try_compose(&entity->subdev, cfg, pad);
+	if (target == V4L2_SEL_TGT_COMPOSE)
+		return v4l2_subdev_get_try_compose(&entity->subdev, cfg, pad);
+	else if (target == V4L2_SEL_TGT_CROP)
+		return v4l2_subdev_get_try_crop(&entity->subdev, cfg, pad);
+	else
+		return NULL;
 }
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index aaab05f4952c..a240fc1c59a6 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -122,9 +122,9 @@ vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad);
 struct v4l2_rect *
-vsp1_entity_get_pad_compose(struct vsp1_entity *entity,
-			    struct v4l2_subdev_pad_config *cfg,
-			    unsigned int pad);
+vsp1_entity_get_pad_selection(struct vsp1_entity *entity,
+			      struct v4l2_subdev_pad_config *cfg,
+			      unsigned int pad, unsigned int target);
 int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 			 struct v4l2_subdev_pad_config *cfg);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 49168db3f529..64dfbddf2aba 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -130,9 +130,10 @@ static void rpf_configure(struct vsp1_entity *entity,
 	if (pipe->bru) {
 		const struct v4l2_rect *compose;
 
-		compose = vsp1_entity_get_pad_compose(pipe->bru,
-						      pipe->bru->config,
-						      rpf->bru_input);
+		compose = vsp1_entity_get_pad_selection(pipe->bru,
+							pipe->bru->config,
+							rpf->bru_input,
+							V4L2_SEL_TGT_COMPOSE);
 		left = compose->left;
 		top = compose->top;
 	}
-- 
2.7.3


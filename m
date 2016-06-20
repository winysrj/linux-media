Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52968 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbcFTTng (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:43:36 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 19/24] v4l: vsp1: clu: Support runtime modification of controls
Date: Mon, 20 Jun 2016 22:10:37 +0300
Message-Id: <1466449842-29502-20-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow reconfiguration of the look-up table and processing mode at
runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_clu.c | 41 +++++++++++++++++++++-------------
 drivers/media/platform/vsp1/vsp1_clu.h |  4 ++++
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index 913070ec09e7..2f77c2c60ad2 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -55,7 +55,9 @@ static int clu_set_table(struct vsp1_clu *clu, struct v4l2_ctrl *ctrl)
 	for (i = 0; i < 17 * 17 * 17; ++i)
 		vsp1_dl_fragment_write(dlb, VI6_CLU_DATA, ctrl->p_new.p_u32[i]);
 
+	spin_lock_irq(&clu->lock);
 	swap(clu->clu, dlb);
+	spin_unlock_irq(&clu->lock);
 
 	vsp1_dl_fragment_free(dlb);
 	return 0;
@@ -208,32 +210,39 @@ static void clu_configure(struct vsp1_entity *entity,
 			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_clu *clu = to_clu(&entity->subdev);
-	struct v4l2_mbus_framefmt *format;
+	struct vsp1_dl_body *dlb;
+	unsigned long flags;
 	u32 ctrl = VI6_CLU_CTRL_AAI | VI6_CLU_CTRL_MVS | VI6_CLU_CTRL_EN;
 
-	if (!full)
+	/* The format can't be changed during streaming, only verify it at
+	 * stream start and store the information internally for future partial
+	 * reconfiguration calls.
+	 */
+	if (full) {
+		struct v4l2_mbus_framefmt *format;
+
+		format = vsp1_entity_get_pad_format(&clu->entity,
+						    clu->entity.config,
+						    CLU_PAD_SINK);
+		clu->yuv_mode = format->code == MEDIA_BUS_FMT_AYUV8_1X32;
 		return;
-
-	format = vsp1_entity_get_pad_format(&clu->entity, clu->entity.config,
-					    CLU_PAD_SINK);
-
-	mutex_lock(clu->ctrls.lock);
+	}
 
 	/* 2D mode can only be used with the YCbCr pixel encoding. */
-	if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D &&
-	    format->code == MEDIA_BUS_FMT_AYUV8_1X32)
+	if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D && clu->yuv_mode)
 		ctrl |= VI6_CLU_CTRL_AX1I_2D | VI6_CLU_CTRL_AX2I_2D
 		     |  VI6_CLU_CTRL_OS0_2D | VI6_CLU_CTRL_OS1_2D
 		     |  VI6_CLU_CTRL_OS2_2D | VI6_CLU_CTRL_M2D;
 
-	if (clu->clu) {
-		vsp1_dl_list_add_fragment(dl, clu->clu);
-		clu->clu = NULL;
-	}
+	vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
 
-	mutex_unlock(clu->ctrls.lock);
+	spin_lock_irqsave(&clu->lock, flags);
+	dlb = clu->clu;
+	clu->clu = NULL;
+	spin_unlock_irqrestore(&clu->lock, flags);
 
-	vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
+	if (dlb)
+		vsp1_dl_list_add_fragment(dl, dlb);
 }
 
 static const struct vsp1_entity_operations clu_entity_ops = {
@@ -253,6 +262,8 @@ struct vsp1_clu *vsp1_clu_create(struct vsp1_device *vsp1)
 	if (clu == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	spin_lock_init(&clu->lock);
+
 	clu->entity.ops = &clu_entity_ops;
 	clu->entity.type = VSP1_ENTITY_CLU;
 
diff --git a/drivers/media/platform/vsp1/vsp1_clu.h b/drivers/media/platform/vsp1/vsp1_clu.h
index 33a69029c719..036e0a2f1a42 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.h
+++ b/drivers/media/platform/vsp1/vsp1_clu.h
@@ -13,6 +13,8 @@
 #ifndef __VSP1_CLU_H__
 #define __VSP1_CLU_H__
 
+#include <linux/spinlock.h>
+
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
@@ -30,6 +32,8 @@ struct vsp1_clu {
 
 	struct v4l2_ctrl_handler ctrls;
 
+	bool yuv_mode;
+	spinlock_t lock;
 	unsigned int mode;
 	struct vsp1_dl_body *clu;
 };
-- 
Regards,

Laurent Pinchart


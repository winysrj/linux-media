Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52967 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbcFTTnf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:43:35 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 18/24] v4l: vsp1: lut: Support runtime modification of controls
Date: Mon, 20 Jun 2016 22:10:36 +0300
Message-Id: <1466449842-29502-19-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow reconfiguration of the look-up table at runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_lut.c | 25 +++++++++++++++----------
 drivers/media/platform/vsp1/vsp1_lut.h |  3 +++
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 0bd26dd5f706..e34237824a5a 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -52,7 +52,9 @@ static int lut_set_table(struct vsp1_lut *lut, struct v4l2_ctrl *ctrl)
 		vsp1_dl_fragment_write(dlb, VI6_LUT_TABLE + 4 * i,
 				       ctrl->p_new.p_u32[i]);
 
+	spin_lock_irq(&lut->lock);
 	swap(lut->lut, dlb);
+	spin_unlock_irq(&lut->lock);
 
 	vsp1_dl_fragment_free(dlb);
 	return 0;
@@ -184,20 +186,21 @@ static void lut_configure(struct vsp1_entity *entity,
 			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
+	struct vsp1_dl_body *dlb;
+	unsigned long flags;
 
-	if (!full)
+	if (full) {
+		vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
 		return;
-
-	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
-
-	mutex_lock(lut->ctrls.lock);
-
-	if (lut->lut) {
-		vsp1_dl_list_add_fragment(dl, lut->lut);
-		lut->lut = NULL;
 	}
 
-	mutex_unlock(lut->ctrls.lock);
+	spin_lock_irqsave(&lut->lock, flags);
+	dlb = lut->lut;
+	lut->lut = NULL;
+	spin_unlock_irqrestore(&lut->lock, flags);
+
+	if (dlb)
+		vsp1_dl_list_add_fragment(dl, dlb);
 }
 
 static const struct vsp1_entity_operations lut_entity_ops = {
@@ -217,6 +220,8 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	if (lut == NULL)
 		return ERR_PTR(-ENOMEM);
 
+	spin_lock_init(&lut->lock);
+
 	lut->entity.ops = &lut_entity_ops;
 	lut->entity.type = VSP1_ENTITY_LUT;
 
diff --git a/drivers/media/platform/vsp1/vsp1_lut.h b/drivers/media/platform/vsp1/vsp1_lut.h
index 021898fc0ce5..f8c4e8f0a79d 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.h
+++ b/drivers/media/platform/vsp1/vsp1_lut.h
@@ -13,6 +13,8 @@
 #ifndef __VSP1_LUT_H__
 #define __VSP1_LUT_H__
 
+#include <linux/spinlock.h>
+
 #include <media/media-entity.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
@@ -29,6 +31,7 @@ struct vsp1_lut {
 
 	struct v4l2_ctrl_handler ctrls;
 
+	spinlock_t lock;
 	struct vsp1_dl_body *lut;
 };
 
-- 
Regards,

Laurent Pinchart


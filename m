Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:46920 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759218AbcIMXQj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Sep 2016 19:16:39 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran+renesas@ksquared.org.uk>
Subject: [PATCH 08/13] v4l: vsp1: Pass parameter type to entity configuration operation
Date: Wed, 14 Sep 2016 02:17:01 +0300
Message-Id: <1473808626-19488-9-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1473808626-19488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace the current boolean parameter (full / !full) with an explicit
enum.

- VSP1_ENTITY_PARAMS_INIT for parameters to be configured at pipeline
  initialization time only (V4L2 stream on or DRM atomic update)
- VSP1_ENTITY_PARAMS_RUNTIME for all parameters that can be freely
  modified at runtime (through V4L2 controls)

This will allow future extensions when implementing image partitioning
support.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    |  5 ++--
 drivers/media/platform/vsp1/vsp1_clu.c    | 43 +++++++++++++++++--------------
 drivers/media/platform/vsp1/vsp1_drm.c    |  6 +++--
 drivers/media/platform/vsp1/vsp1_entity.h | 12 ++++++++-
 drivers/media/platform/vsp1/vsp1_hsit.c   |  5 ++--
 drivers/media/platform/vsp1/vsp1_lif.c    |  5 ++--
 drivers/media/platform/vsp1/vsp1_lut.c    | 24 ++++++++++-------
 drivers/media/platform/vsp1/vsp1_rpf.c    |  5 ++--
 drivers/media/platform/vsp1/vsp1_sru.c    |  5 ++--
 drivers/media/platform/vsp1/vsp1_uds.c    |  5 ++--
 drivers/media/platform/vsp1/vsp1_video.c  |  6 +++--
 drivers/media/platform/vsp1/vsp1_wpf.c    |  5 ++--
 12 files changed, 78 insertions(+), 48 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 26b9e2282a41..80fb948860d5 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -285,14 +285,15 @@ static const struct v4l2_subdev_ops bru_ops = {
 
 static void bru_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl, bool full)
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
 {
 	struct vsp1_bru *bru = to_bru(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
 	unsigned int flags;
 	unsigned int i;
 
-	if (!full)
+	if (params != VSP1_ENTITY_PARAMS_INIT)
 		return;
 
 	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index e1fd03811dda..a0a69dfc38fc 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -214,42 +214,47 @@ static const struct v4l2_subdev_ops clu_ops = {
 
 static void clu_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl, bool full)
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
 {
 	struct vsp1_clu *clu = to_clu(&entity->subdev);
 	struct vsp1_dl_body *dlb;
 	unsigned long flags;
 	u32 ctrl = VI6_CLU_CTRL_AAI | VI6_CLU_CTRL_MVS | VI6_CLU_CTRL_EN;
 
-	/* The format can't be changed during streaming, only verify it at
-	 * stream start and store the information internally for future partial
-	 * reconfiguration calls.
-	 */
-	if (full) {
+	switch (params) {
+	case VSP1_ENTITY_PARAMS_INIT: {
+		/* The format can't be changed during streaming, only verify it
+		 * at setup time and store the information internally for future
+		 * runtime configuration calls.
+		 */
 		struct v4l2_mbus_framefmt *format;
 
 		format = vsp1_entity_get_pad_format(&clu->entity,
 						    clu->entity.config,
 						    CLU_PAD_SINK);
 		clu->yuv_mode = format->code == MEDIA_BUS_FMT_AYUV8_1X32;
-		return;
+		break;
 	}
 
-	/* 2D mode can only be used with the YCbCr pixel encoding. */
-	if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D && clu->yuv_mode)
-		ctrl |= VI6_CLU_CTRL_AX1I_2D | VI6_CLU_CTRL_AX2I_2D
-		     |  VI6_CLU_CTRL_OS0_2D | VI6_CLU_CTRL_OS1_2D
-		     |  VI6_CLU_CTRL_OS2_2D | VI6_CLU_CTRL_M2D;
+	case VSP1_ENTITY_PARAMS_RUNTIME:
+		/* 2D mode can only be used with the YCbCr pixel encoding. */
+		if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D && clu->yuv_mode)
+			ctrl |= VI6_CLU_CTRL_AX1I_2D | VI6_CLU_CTRL_AX2I_2D
+			     |  VI6_CLU_CTRL_OS0_2D | VI6_CLU_CTRL_OS1_2D
+			     |  VI6_CLU_CTRL_OS2_2D | VI6_CLU_CTRL_M2D;
 
-	vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
+		vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
 
-	spin_lock_irqsave(&clu->lock, flags);
-	dlb = clu->clu;
-	clu->clu = NULL;
-	spin_unlock_irqrestore(&clu->lock, flags);
+		spin_lock_irqsave(&clu->lock, flags);
+		dlb = clu->clu;
+		clu->clu = NULL;
+		spin_unlock_irqrestore(&clu->lock, flags);
 
-	if (dlb)
-		vsp1_dl_list_add_fragment(dl, dlb);
+		if (dlb)
+			vsp1_dl_list_add_fragment(dl, dlb);
+		break;
+	}
 }
 
 static const struct vsp1_entity_operations clu_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 06972f612263..6cbd3aeedbe3 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -492,8 +492,10 @@ void vsp1_du_atomic_flush(struct device *dev)
 		vsp1_entity_route_setup(entity, pipe->dl);
 
 		if (entity->ops->configure) {
-			entity->ops->configure(entity, pipe, pipe->dl, true);
-			entity->ops->configure(entity, pipe, pipe->dl, false);
+			entity->ops->configure(entity, pipe, pipe->dl,
+					       VSP1_ENTITY_PARAMS_INIT);
+			entity->ops->configure(entity, pipe, pipe->dl,
+					       VSP1_ENTITY_PARAMS_RUNTIME);
 		}
 
 		/* The memory buffer address must be applied after configuring
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index b5e4dbb1f7d4..51835e73308d 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -35,6 +35,16 @@ enum vsp1_entity_type {
 	VSP1_ENTITY_WPF,
 };
 
+/*
+ * enum vsp1_entity_params - Entity configuration parameters class
+ * @VSP1_ENTITY_PARAMS_INIT - Initial parameters
+ * @VSP1_ENTITY_PARAMS_RUNTIME - Runtime-configurable parameters
+ */
+enum vsp1_entity_params {
+	VSP1_ENTITY_PARAMS_INIT,
+	VSP1_ENTITY_PARAMS_RUNTIME,
+};
+
 #define VSP1_ENTITY_MAX_INPUTS		5	/* For the BRU */
 
 /*
@@ -73,7 +83,7 @@ struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
 	void (*set_memory)(struct vsp1_entity *, struct vsp1_dl_list *dl);
 	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
-			  struct vsp1_dl_list *, bool);
+			  struct vsp1_dl_list *, enum vsp1_entity_params);
 };
 
 struct vsp1_entity {
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 6ffbedb5c095..94316afc54ff 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -132,11 +132,12 @@ static const struct v4l2_subdev_ops hsit_ops = {
 
 static void hsit_configure(struct vsp1_entity *entity,
 			   struct vsp1_pipeline *pipe,
-			   struct vsp1_dl_list *dl, bool full)
+			   struct vsp1_dl_list *dl,
+			   enum vsp1_entity_params params)
 {
 	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
 
-	if (!full)
+	if (params != VSP1_ENTITY_PARAMS_INIT)
 		return;
 
 	if (hsit->inverse)
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 702df863b13a..e32acae1fc6e 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -129,7 +129,8 @@ static const struct v4l2_subdev_ops lif_ops = {
 
 static void lif_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl, bool full)
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
@@ -137,7 +138,7 @@ static void lif_configure(struct vsp1_entity *entity,
 	unsigned int obth = 400;
 	unsigned int lbth = 200;
 
-	if (!full)
+	if (params != VSP1_ENTITY_PARAMS_INIT)
 		return;
 
 	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index e1c0bb7535e4..ace8acce2076 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -190,24 +190,28 @@ static const struct v4l2_subdev_ops lut_ops = {
 
 static void lut_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl, bool full)
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 	struct vsp1_dl_body *dlb;
 	unsigned long flags;
 
-	if (full) {
+	switch (params) {
+	case VSP1_ENTITY_PARAMS_INIT:
 		vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
-		return;
-	}
+		break;
 
-	spin_lock_irqsave(&lut->lock, flags);
-	dlb = lut->lut;
-	lut->lut = NULL;
-	spin_unlock_irqrestore(&lut->lock, flags);
+	case VSP1_ENTITY_PARAMS_RUNTIME:
+		spin_lock_irqsave(&lut->lock, flags);
+		dlb = lut->lut;
+		lut->lut = NULL;
+		spin_unlock_irqrestore(&lut->lock, flags);
 
-	if (dlb)
-		vsp1_dl_list_add_fragment(dl, dlb);
+		if (dlb)
+			vsp1_dl_list_add_fragment(dl, dlb);
+		break;
+	}
 }
 
 static const struct vsp1_entity_operations lut_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 3d6669dbeacf..795bf0fd1761 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -60,7 +60,8 @@ static void rpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 
 static void rpf_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl, bool full)
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
@@ -73,7 +74,7 @@ static void rpf_configure(struct vsp1_entity *entity,
 	u32 pstride;
 	u32 infmt;
 
-	if (!full) {
+	if (params == VSP1_ENTITY_PARAMS_RUNTIME) {
 		vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
 			       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
 		vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 6e13cdfa5ed4..9d4a1afb6634 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -271,7 +271,8 @@ static const struct v4l2_subdev_ops sru_ops = {
 
 static void sru_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl, bool full)
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
@@ -279,7 +280,7 @@ static void sru_configure(struct vsp1_entity *entity,
 	struct v4l2_mbus_framefmt *output;
 	u32 ctrl0;
 
-	if (!full)
+	if (params != VSP1_ENTITY_PARAMS_INIT)
 		return;
 
 	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index a8fc893a31ee..62beae5d6944 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -260,7 +260,8 @@ static const struct v4l2_subdev_ops uds_ops = {
 
 static void uds_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl, bool full)
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
@@ -269,7 +270,7 @@ static void uds_configure(struct vsp1_entity *entity,
 	unsigned int vscale;
 	bool multitap;
 
-	if (!full)
+	if (params != VSP1_ENTITY_PARAMS_INIT)
 		return;
 
 	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index cd7d215ed455..c66f0b480989 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -254,7 +254,8 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl, false);
+			entity->ops->configure(entity, pipe, pipe->dl,
+					       VSP1_ENTITY_PARAMS_RUNTIME);
 	}
 
 	for (i = 0; i < vsp1->info->rpf_count; ++i) {
@@ -629,7 +630,8 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 		vsp1_entity_route_setup(entity, pipe->dl);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl, true);
+			entity->ops->configure(entity, pipe, pipe->dl,
+					       VSP1_ENTITY_PARAMS_INIT);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index f3a593196282..adf348d08c64 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -206,7 +206,8 @@ static void wpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 
 static void wpf_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl, bool full)
+			  struct vsp1_dl_list *dl,
+			  enum vsp1_entity_params params)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
@@ -216,7 +217,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 	u32 outfmt = 0;
 	u32 srcrpf = 0;
 
-	if (!full) {
+	if (params == VSP1_ENTITY_PARAMS_RUNTIME) {
 		const unsigned int mask = BIT(WPF_CTRL_VFLIP)
 					| BIT(WPF_CTRL_HFLIP);
 
-- 
Regards,

Laurent Pinchart


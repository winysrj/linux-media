Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50654 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752475AbeEQRYN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 May 2018 13:24:13 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH v10 7/8] media: vsp1: Adapt entities to configure into a body
Date: Thu, 17 May 2018 18:24:00 +0100
Message-Id: <c56ba0ee73806832129d8ea7da0c8c4c32fe6364.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.e217e37c63010c4a78c4022a30a389e5d7627919.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.e217e37c63010c4a78c4022a30a389e5d7627919.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.e217e37c63010c4a78c4022a30a389e5d7627919.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.e217e37c63010c4a78c4022a30a389e5d7627919.1526577622.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the entities store their configurations into a display list.
Adapt this such that the code can be configured into a body directly,
allowing greater flexibility and control of the content.

All users of vsp1_dl_list_write() are removed in this process, thus it
too is removed.

A helper, vsp1_dl_list_get_body0() is provided to access the internal body0
from the display list.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
[Don't remove blank line unnecessarily]
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_brx.c    | 22 ++++++------
 drivers/media/platform/vsp1/vsp1_clu.c    | 23 ++++++-------
 drivers/media/platform/vsp1/vsp1_dl.c     | 12 ++-----
 drivers/media/platform/vsp1/vsp1_dl.h     |  2 +-
 drivers/media/platform/vsp1/vsp1_drm.c    | 12 ++++---
 drivers/media/platform/vsp1/vsp1_entity.c | 22 ++++++------
 drivers/media/platform/vsp1/vsp1_entity.h | 18 ++++++----
 drivers/media/platform/vsp1/vsp1_hgo.c    | 16 ++++-----
 drivers/media/platform/vsp1/vsp1_hgt.c    | 18 +++++-----
 drivers/media/platform/vsp1/vsp1_hsit.c   | 10 +++---
 drivers/media/platform/vsp1/vsp1_lif.c    | 15 ++++----
 drivers/media/platform/vsp1/vsp1_lut.c    | 23 ++++++-------
 drivers/media/platform/vsp1/vsp1_pipe.c   |  4 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |  3 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 43 ++++++++++++------------
 drivers/media/platform/vsp1/vsp1_sru.c    | 14 ++++----
 drivers/media/platform/vsp1/vsp1_uds.c    | 25 +++++++-------
 drivers/media/platform/vsp1/vsp1_uds.h    |  2 +-
 drivers/media/platform/vsp1/vsp1_uif.c    | 21 ++++++------
 drivers/media/platform/vsp1/vsp1_video.c  | 16 ++++++---
 drivers/media/platform/vsp1/vsp1_wpf.c    | 42 ++++++++++++-----------
 21 files changed, 194 insertions(+), 169 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_brx.c b/drivers/media/platform/vsp1/vsp1_brx.c
index 011edac5ebc1..359917b5d842 100644
--- a/drivers/media/platform/vsp1/vsp1_brx.c
+++ b/drivers/media/platform/vsp1/vsp1_brx.c
@@ -26,10 +26,10 @@
  * Device Access
  */
 
-static inline void vsp1_brx_write(struct vsp1_brx *brx, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_brx_write(struct vsp1_brx *brx,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, brx->base + reg, data);
+	vsp1_dl_body_write(dlb, brx->base + reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -283,7 +283,7 @@ static const struct v4l2_subdev_ops brx_ops = {
 
 static void brx_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_brx *brx = to_brx(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
@@ -305,7 +305,7 @@ static void brx_configure_stream(struct vsp1_entity *entity,
 	 * format at the pipeline output is premultiplied.
 	 */
 	flags = pipe->output ? pipe->output->format.flags : 0;
-	vsp1_brx_write(brx, dl, VI6_BRU_INCTRL,
+	vsp1_brx_write(brx, dlb, VI6_BRU_INCTRL,
 		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
 		       0 : VI6_BRU_INCTRL_NRM);
 
@@ -313,12 +313,12 @@ static void brx_configure_stream(struct vsp1_entity *entity,
 	 * Set the background position to cover the whole output image and
 	 * configure its color.
 	 */
-	vsp1_brx_write(brx, dl, VI6_BRU_VIRRPF_SIZE,
+	vsp1_brx_write(brx, dlb, VI6_BRU_VIRRPF_SIZE,
 		       (format->width << VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT) |
 		       (format->height << VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT));
-	vsp1_brx_write(brx, dl, VI6_BRU_VIRRPF_LOC, 0);
+	vsp1_brx_write(brx, dlb, VI6_BRU_VIRRPF_LOC, 0);
 
-	vsp1_brx_write(brx, dl, VI6_BRU_VIRRPF_COL, brx->bgcolor |
+	vsp1_brx_write(brx, dlb, VI6_BRU_VIRRPF_COL, brx->bgcolor |
 		       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
 
 	/*
@@ -328,7 +328,7 @@ static void brx_configure_stream(struct vsp1_entity *entity,
 	 * unit.
 	 */
 	if (entity->type == VSP1_ENTITY_BRU)
-		vsp1_brx_write(brx, dl, VI6_BRU_ROP,
+		vsp1_brx_write(brx, dlb, VI6_BRU_ROP,
 			       VI6_BRU_ROP_DSTSEL_BRUIN(1) |
 			       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
 			       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
@@ -370,7 +370,7 @@ static void brx_configure_stream(struct vsp1_entity *entity,
 		if (!(entity->type == VSP1_ENTITY_BRU && i == 1))
 			ctrl |= VI6_BRU_CTRL_SRCSEL_BRUIN(i);
 
-		vsp1_brx_write(brx, dl, VI6_BRU_CTRL(i), ctrl);
+		vsp1_brx_write(brx, dlb, VI6_BRU_CTRL(i), ctrl);
 
 		/*
 		 * Harcode the blending formula to
@@ -385,7 +385,7 @@ static void brx_configure_stream(struct vsp1_entity *entity,
 		 *
 		 * otherwise.
 		 */
-		vsp1_brx_write(brx, dl, VI6_BRU_BLD(i),
+		vsp1_brx_write(brx, dlb, VI6_BRU_BLD(i),
 			       VI6_BRU_BLD_CCMDX_255_SRC_A |
 			       (premultiplied ? VI6_BRU_BLD_CCMDY_COEFY :
 						VI6_BRU_BLD_CCMDY_SRC_A) |
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index 34f17a82ac1f..942fc14c19d1 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -25,10 +25,10 @@
  * Device Access
  */
 
-static inline void vsp1_clu_write(struct vsp1_clu *clu, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_clu_write(struct vsp1_clu *clu,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg, data);
+	vsp1_dl_body_write(dlb, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -171,7 +171,7 @@ static const struct v4l2_subdev_ops clu_ops = {
 
 static void clu_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_clu *clu = to_clu(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
@@ -188,10 +188,11 @@ static void clu_configure_stream(struct vsp1_entity *entity,
 
 static void clu_configure_frame(struct vsp1_entity *entity,
 				struct vsp1_pipeline *pipe,
-				struct vsp1_dl_list *dl)
+				struct vsp1_dl_list *dl,
+				struct vsp1_dl_body *dlb)
 {
 	struct vsp1_clu *clu = to_clu(&entity->subdev);
-	struct vsp1_dl_body *dlb;
+	struct vsp1_dl_body *clu_dlb;
 	unsigned long flags;
 	u32 ctrl = VI6_CLU_CTRL_AAI | VI6_CLU_CTRL_MVS | VI6_CLU_CTRL_EN;
 
@@ -201,18 +202,18 @@ static void clu_configure_frame(struct vsp1_entity *entity,
 		     |  VI6_CLU_CTRL_OS0_2D | VI6_CLU_CTRL_OS1_2D
 		     |  VI6_CLU_CTRL_OS2_2D | VI6_CLU_CTRL_M2D;
 
-	vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
+	vsp1_clu_write(clu, dlb, VI6_CLU_CTRL, ctrl);
 
 	spin_lock_irqsave(&clu->lock, flags);
-	dlb = clu->clu;
+	clu_dlb = clu->clu;
 	clu->clu = NULL;
 	spin_unlock_irqrestore(&clu->lock, flags);
 
-	if (dlb) {
-		vsp1_dl_list_add_body(dl, dlb);
+	if (clu_dlb) {
+		vsp1_dl_list_add_body(dl, clu_dlb);
 
 		/* Release our local reference. */
-		vsp1_dl_body_put(dlb);
+		vsp1_dl_body_put(clu_dlb);
 	}
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 1407c90c6880..c7fa1cb088cd 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -447,17 +447,15 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
 }
 
 /**
- * vsp1_dl_list_write - Write a register to the display list
+ * vsp1_dl_list_get_body0 - Obtain the default body for the display list
  * @dl: The display list
- * @reg: The register address
- * @data: The register value
  *
- * Write the given register and value to the display list. Up to 256 registers
- * can be written per display list.
+ * Obtain a pointer to the internal display list body allowing this to be passed
+ * directly to configure operations.
  */
-void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data)
+struct vsp1_dl_body *vsp1_dl_list_get_body0(struct vsp1_dl_list *dl)
 {
-	vsp1_dl_body_write(dl->body0, reg, data);
+	return dl->body0;
 }
 
 /**
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index 6a7d48e385d5..216bd23029dd 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -31,7 +31,7 @@ unsigned int vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
 
 struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
 void vsp1_dl_list_put(struct vsp1_dl_list *dl);
-void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
+struct vsp1_dl_body *vsp1_dl_list_get_body0(struct vsp1_dl_list *dl);
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl, bool internal);
 
 struct vsp1_dl_body_pool *
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 32ab98f101c1..edb35a5c57ea 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -536,13 +536,15 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 	struct vsp1_entity *entity;
 	struct vsp1_entity *next;
 	struct vsp1_dl_list *dl;
+	struct vsp1_dl_body *dlb;
 
 	dl = vsp1_dl_list_get(pipe->output->dlm);
+	dlb = vsp1_dl_list_get_body0(dl);
 
 	list_for_each_entry_safe(entity, next, &pipe->entities, list_pipe) {
 		/* Disconnect unused entities from the pipeline. */
 		if (!entity->pipe) {
-			vsp1_dl_list_write(dl, entity->route->reg,
+			vsp1_dl_body_write(dlb, entity->route->reg,
 					   VI6_DPR_NODE_UNUSED);
 
 			entity->sink = NULL;
@@ -551,10 +553,10 @@ static void vsp1_du_pipeline_configure(struct vsp1_pipeline *pipe)
 			continue;
 		}
 
-		vsp1_entity_route_setup(entity, pipe, dl);
-		vsp1_entity_configure_stream(entity, pipe, dl);
-		vsp1_entity_configure_frame(entity, pipe, dl);
-		vsp1_entity_configure_partition(entity, pipe, dl);
+		vsp1_entity_route_setup(entity, pipe, dlb);
+		vsp1_entity_configure_stream(entity, pipe, dlb);
+		vsp1_entity_configure_frame(entity, pipe, dl, dlb);
+		vsp1_entity_configure_partition(entity, pipe, dl, dlb);
 	}
 
 	vsp1_dl_list_commit(dl, drm_pipe->force_brx_release);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 73f6611ec279..da276a85aa95 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -22,7 +22,7 @@
 
 void vsp1_entity_route_setup(struct vsp1_entity *entity,
 			     struct vsp1_pipeline *pipe,
-			     struct vsp1_dl_list *dl)
+			     struct vsp1_dl_body *dlb)
 {
 	struct vsp1_entity *source;
 	u32 route;
@@ -38,7 +38,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 		smppt = (pipe->output->entity.index << VI6_DPR_SMPPT_TGW_SHIFT)
 		      | (source->route->output << VI6_DPR_SMPPT_PT_SHIFT);
 
-		vsp1_dl_list_write(dl, VI6_DPR_HGO_SMPPT, smppt);
+		vsp1_dl_body_write(dlb, VI6_DPR_HGO_SMPPT, smppt);
 		return;
 	} else if (entity->type == VSP1_ENTITY_HGT) {
 		u32 smppt;
@@ -51,7 +51,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 		smppt = (pipe->output->entity.index << VI6_DPR_SMPPT_TGW_SHIFT)
 		      | (source->route->output << VI6_DPR_SMPPT_PT_SHIFT);
 
-		vsp1_dl_list_write(dl, VI6_DPR_HGT_SMPPT, smppt);
+		vsp1_dl_body_write(dlb, VI6_DPR_HGT_SMPPT, smppt);
 		return;
 	}
 
@@ -66,31 +66,33 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 	 */
 	if (source->type == VSP1_ENTITY_BRS)
 		route |= VI6_DPR_ROUTE_BRSSEL;
-	vsp1_dl_list_write(dl, source->route->reg, route);
+	vsp1_dl_body_write(dlb, source->route->reg, route);
 }
 
 void vsp1_entity_configure_stream(struct vsp1_entity *entity,
 				  struct vsp1_pipeline *pipe,
-				  struct vsp1_dl_list *dl)
+				  struct vsp1_dl_body *dlb)
 {
 	if (entity->ops->configure_stream)
-		entity->ops->configure_stream(entity, pipe, dl);
+		entity->ops->configure_stream(entity, pipe, dlb);
 }
 
 void vsp1_entity_configure_frame(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_list *dl,
+				 struct vsp1_dl_body *dlb)
 {
 	if (entity->ops->configure_frame)
-		entity->ops->configure_frame(entity, pipe, dl);
+		entity->ops->configure_frame(entity, pipe, dl, dlb);
 }
 
 void vsp1_entity_configure_partition(struct vsp1_entity *entity,
 				     struct vsp1_pipeline *pipe,
-				     struct vsp1_dl_list *dl)
+				     struct vsp1_dl_list *dl,
+				     struct vsp1_dl_body *dlb)
 {
 	if (entity->ops->configure_partition)
-		entity->ops->configure_partition(entity, pipe, dl);
+		entity->ops->configure_partition(entity, pipe, dl, dlb);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index c29676671b1a..97acb7795cf1 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -15,6 +15,7 @@
 #include <media/v4l2-subdev.h>
 
 struct vsp1_device;
+struct vsp1_dl_body;
 struct vsp1_dl_list;
 struct vsp1_pipeline;
 struct vsp1_partition;
@@ -77,12 +78,13 @@ struct vsp1_route {
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
 	void (*configure_stream)(struct vsp1_entity *, struct vsp1_pipeline *,
-				 struct vsp1_dl_list *);
+				 struct vsp1_dl_body *);
 	void (*configure_frame)(struct vsp1_entity *, struct vsp1_pipeline *,
-					struct vsp1_dl_list *);
+				struct vsp1_dl_list *, struct vsp1_dl_body *);
 	void (*configure_partition)(struct vsp1_entity *,
 				    struct vsp1_pipeline *,
-				    struct vsp1_dl_list *);
+				    struct vsp1_dl_list *,
+				    struct vsp1_dl_body *);
 	unsigned int (*max_width)(struct vsp1_entity *, struct vsp1_pipeline *);
 	void (*partition)(struct vsp1_entity *, struct vsp1_pipeline *,
 			  struct vsp1_partition *, unsigned int,
@@ -149,19 +151,21 @@ int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 
 void vsp1_entity_route_setup(struct vsp1_entity *entity,
 			     struct vsp1_pipeline *pipe,
-			     struct vsp1_dl_list *dl);
+			     struct vsp1_dl_body *dlb);
 
 void vsp1_entity_configure_stream(struct vsp1_entity *entity,
 				  struct vsp1_pipeline *pipe,
-				  struct vsp1_dl_list *dl);
+				  struct vsp1_dl_body *dlb);
 
 void vsp1_entity_configure_frame(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl);
+				 struct vsp1_dl_list *dl,
+				 struct vsp1_dl_body *dlb);
 
 void vsp1_entity_configure_partition(struct vsp1_entity *entity,
 				     struct vsp1_pipeline *pipe,
-				     struct vsp1_dl_list *dl);
+				     struct vsp1_dl_list *dl,
+				     struct vsp1_dl_body *dlb);
 
 struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad);
 
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index 8855ad15d132..827373c25351 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -28,10 +28,10 @@ static inline u32 vsp1_hgo_read(struct vsp1_hgo *hgo, u32 reg)
 	return vsp1_read(hgo->histo.entity.vsp1, reg);
 }
 
-static inline void vsp1_hgo_write(struct vsp1_hgo *hgo, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_hgo_write(struct vsp1_hgo *hgo,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg, data);
+	vsp1_dl_body_write(dlb, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -131,7 +131,7 @@ static const struct v4l2_ctrl_config hgo_num_bins_control = {
 
 static void hgo_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -145,12 +145,12 @@ static void hgo_configure_stream(struct vsp1_entity *entity,
 						HISTO_PAD_SINK,
 						V4L2_SEL_TGT_COMPOSE);
 
-	vsp1_hgo_write(hgo, dl, VI6_HGO_REGRST, VI6_HGO_REGRST_RCLEA);
+	vsp1_hgo_write(hgo, dlb, VI6_HGO_REGRST, VI6_HGO_REGRST_RCLEA);
 
-	vsp1_hgo_write(hgo, dl, VI6_HGO_OFFSET,
+	vsp1_hgo_write(hgo, dlb, VI6_HGO_OFFSET,
 		       (crop->left << VI6_HGO_OFFSET_HOFFSET_SHIFT) |
 		       (crop->top << VI6_HGO_OFFSET_VOFFSET_SHIFT));
-	vsp1_hgo_write(hgo, dl, VI6_HGO_SIZE,
+	vsp1_hgo_write(hgo, dlb, VI6_HGO_SIZE,
 		       (crop->width << VI6_HGO_SIZE_HSIZE_SHIFT) |
 		       (crop->height << VI6_HGO_SIZE_VSIZE_SHIFT));
 
@@ -162,7 +162,7 @@ static void hgo_configure_stream(struct vsp1_entity *entity,
 
 	hratio = crop->width * 2 / compose->width / 3;
 	vratio = crop->height * 2 / compose->height / 3;
-	vsp1_hgo_write(hgo, dl, VI6_HGO_MODE,
+	vsp1_hgo_write(hgo, dlb, VI6_HGO_MODE,
 		       (hgo->num_bins == 256 ? VI6_HGO_MODE_STEP : 0) |
 		       (hgo->max_rgb ? VI6_HGO_MODE_MAXRGB : 0) |
 		       (hratio << VI6_HGO_MODE_HRATIO_SHIFT) |
diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c b/drivers/media/platform/vsp1/vsp1_hgt.c
index a7ec2c9fdc5c..bb6ce6fdd5f4 100644
--- a/drivers/media/platform/vsp1/vsp1_hgt.c
+++ b/drivers/media/platform/vsp1/vsp1_hgt.c
@@ -28,10 +28,10 @@ static inline u32 vsp1_hgt_read(struct vsp1_hgt *hgt, u32 reg)
 	return vsp1_read(hgt->histo.entity.vsp1, reg);
 }
 
-static inline void vsp1_hgt_write(struct vsp1_hgt *hgt, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_hgt_write(struct vsp1_hgt *hgt,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg, data);
+	vsp1_dl_body_write(dlb, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -127,7 +127,7 @@ static const struct v4l2_ctrl_config hgt_hue_areas = {
 
 static void hgt_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -144,12 +144,12 @@ static void hgt_configure_stream(struct vsp1_entity *entity,
 						HISTO_PAD_SINK,
 						V4L2_SEL_TGT_COMPOSE);
 
-	vsp1_hgt_write(hgt, dl, VI6_HGT_REGRST, VI6_HGT_REGRST_RCLEA);
+	vsp1_hgt_write(hgt, dlb, VI6_HGT_REGRST, VI6_HGT_REGRST_RCLEA);
 
-	vsp1_hgt_write(hgt, dl, VI6_HGT_OFFSET,
+	vsp1_hgt_write(hgt, dlb, VI6_HGT_OFFSET,
 		       (crop->left << VI6_HGT_OFFSET_HOFFSET_SHIFT) |
 		       (crop->top << VI6_HGT_OFFSET_VOFFSET_SHIFT));
-	vsp1_hgt_write(hgt, dl, VI6_HGT_SIZE,
+	vsp1_hgt_write(hgt, dlb, VI6_HGT_SIZE,
 		       (crop->width << VI6_HGT_SIZE_HSIZE_SHIFT) |
 		       (crop->height << VI6_HGT_SIZE_VSIZE_SHIFT));
 
@@ -157,7 +157,7 @@ static void hgt_configure_stream(struct vsp1_entity *entity,
 	for (i = 0; i < HGT_NUM_HUE_AREAS; ++i) {
 		lower = hgt->hue_areas[i*2 + 0];
 		upper = hgt->hue_areas[i*2 + 1];
-		vsp1_hgt_write(hgt, dl, VI6_HGT_HUE_AREA(i),
+		vsp1_hgt_write(hgt, dlb, VI6_HGT_HUE_AREA(i),
 			       (lower << VI6_HGT_HUE_AREA_LOWER_SHIFT) |
 			       (upper << VI6_HGT_HUE_AREA_UPPER_SHIFT));
 	}
@@ -165,7 +165,7 @@ static void hgt_configure_stream(struct vsp1_entity *entity,
 
 	hratio = crop->width * 2 / compose->width / 3;
 	vratio = crop->height * 2 / compose->height / 3;
-	vsp1_hgt_write(hgt, dl, VI6_HGT_MODE,
+	vsp1_hgt_write(hgt, dlb, VI6_HGT_MODE,
 		       (hratio << VI6_HGT_MODE_HRATIO_SHIFT) |
 		       (vratio << VI6_HGT_MODE_VRATIO_SHIFT));
 }
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 798c1448e3dc..39ab2e0c7c18 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -24,9 +24,9 @@
  */
 
 static inline void vsp1_hsit_write(struct vsp1_hsit *hsit,
-				   struct vsp1_dl_list *dl, u32 reg, u32 data)
+				   struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg, data);
+	vsp1_dl_body_write(dlb, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -129,14 +129,14 @@ static const struct v4l2_subdev_ops hsit_ops = {
 
 static void hsit_configure_stream(struct vsp1_entity *entity,
 				  struct vsp1_pipeline *pipe,
-				  struct vsp1_dl_list *dl)
+				  struct vsp1_dl_body *dlb)
 {
 	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
 
 	if (hsit->inverse)
-		vsp1_hsit_write(hsit, dl, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
+		vsp1_hsit_write(hsit, dlb, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
 	else
-		vsp1_hsit_write(hsit, dl, VI6_HST_CTRL, VI6_HST_CTRL_EN);
+		vsp1_hsit_write(hsit, dlb, VI6_HST_CTRL, VI6_HST_CTRL_EN);
 }
 
 static const struct vsp1_entity_operations hsit_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 5a3f3e7b9bd3..0cb63244b21a 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -23,10 +23,11 @@
  * Device Access
  */
 
-static inline void vsp1_lif_write(struct vsp1_lif *lif, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_lif_write(struct vsp1_lif *lif,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg + lif->entity.index * VI6_LIF_OFFSET, data);
+	vsp1_dl_body_write(dlb, reg + lif->entity.index * VI6_LIF_OFFSET,
+			       data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -83,7 +84,7 @@ static const struct v4l2_subdev_ops lif_ops = {
 
 static void lif_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
@@ -96,11 +97,11 @@ static void lif_configure_stream(struct vsp1_entity *entity,
 
 	obth = min(obth, (format->width + 1) / 2 * format->height - 4);
 
-	vsp1_lif_write(lif, dl, VI6_LIF_CSBTH,
+	vsp1_lif_write(lif, dlb, VI6_LIF_CSBTH,
 			(hbth << VI6_LIF_CSBTH_HBTH_SHIFT) |
 			(lbth << VI6_LIF_CSBTH_LBTH_SHIFT));
 
-	vsp1_lif_write(lif, dl, VI6_LIF_CTRL,
+	vsp1_lif_write(lif, dlb, VI6_LIF_CTRL,
 			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
 			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
 			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
@@ -113,7 +114,7 @@ static void lif_configure_stream(struct vsp1_entity *entity,
 	 */
 	if ((entity->vsp1->version & VI6_IP_VERSION_MASK) ==
 	    (VI6_IP_VERSION_MODEL_VSPD_V3 | VI6_IP_VERSION_SOC_V3M))
-		vsp1_lif_write(lif, dl, VI6_LIF_LBA,
+		vsp1_lif_write(lif, dlb, VI6_LIF_LBA,
 			       VI6_LIF_LBA_LBA0 |
 			       (1536 << VI6_LIF_LBA_LBA1_SHIFT));
 }
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 1b62f54dc302..64c48d9459b0 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -25,10 +25,10 @@
  * Device Access
  */
 
-static inline void vsp1_lut_write(struct vsp1_lut *lut, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_lut_write(struct vsp1_lut *lut,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg, data);
+	vsp1_dl_body_write(dlb, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -147,31 +147,32 @@ static const struct v4l2_subdev_ops lut_ops = {
 
 static void lut_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 
-	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
+	vsp1_lut_write(lut, dlb, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
 }
 
 static void lut_configure_frame(struct vsp1_entity *entity,
 				struct vsp1_pipeline *pipe,
-				struct vsp1_dl_list *dl)
+				struct vsp1_dl_list *dl,
+				struct vsp1_dl_body *dlb)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
-	struct vsp1_dl_body *dlb;
+	struct vsp1_dl_body *lut_dlb;
 	unsigned long flags;
 
 	spin_lock_irqsave(&lut->lock, flags);
-	dlb = lut->lut;
+	lut_dlb = lut->lut;
 	lut->lut = NULL;
 	spin_unlock_irqrestore(&lut->lock, flags);
 
-	if (dlb) {
-		vsp1_dl_list_add_body(dl, dlb);
+	if (lut_dlb) {
+		vsp1_dl_list_add_body(dl, lut_dlb);
 
 		/* Release our local reference. */
-		vsp1_dl_body_put(dlb);
+		vsp1_dl_body_put(lut_dlb);
 	}
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 6fde4c0b9844..d06ffa01027c 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -348,7 +348,7 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
  * from the input RPF alpha.
  */
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
-				   struct vsp1_dl_list *dl, unsigned int alpha)
+				   struct vsp1_dl_body *dlb, unsigned int alpha)
 {
 	if (!pipe->uds)
 		return;
@@ -361,7 +361,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 	    pipe->uds_input->type == VSP1_ENTITY_BRS)
 		alpha = 255;
 
-	vsp1_uds_set_alpha(pipe->uds, dl, alpha);
+	vsp1_uds_set_alpha(pipe->uds, dlb, alpha);
 }
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 663d7fed7929..e00010693eef 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -157,7 +157,8 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
-				   struct vsp1_dl_list *dl, unsigned int alpha);
+				   struct vsp1_dl_body *dlb,
+				   unsigned int alpha);
 
 void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
 				       struct vsp1_partition *partition,
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index deb86cc235ef..69e5fe6e6b50 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -25,9 +25,10 @@
  */
 
 static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf,
-				  struct vsp1_dl_list *dl, u32 reg, u32 data)
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg + rpf->entity.index * VI6_RPF_OFFSET, data);
+	vsp1_dl_body_write(dlb, reg + rpf->entity.index * VI6_RPF_OFFSET,
+			       data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -44,7 +45,7 @@ static const struct v4l2_subdev_ops rpf_ops = {
 
 static void rpf_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
@@ -63,7 +64,7 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
 		pstride |= format->plane_fmt[1].bytesperline
 			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_PSTRIDE, pstride);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_PSTRIDE, pstride);
 
 	/* Format */
 	sink_format = vsp1_entity_get_pad_format(&rpf->entity,
@@ -84,8 +85,8 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
 	if (sink_format->code != source_format->code)
 		infmt |= VI6_RPF_INFMT_CSC;
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_INFMT, infmt);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_DSWAP, fmtinfo->swap);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_INFMT, infmt);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_DSWAP, fmtinfo->swap);
 
 	/* Output location */
 	if (pipe->brx) {
@@ -99,7 +100,7 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
 		top = compose->top;
 	}
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_LOC,
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_LOC,
 		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
 		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
 
@@ -126,7 +127,7 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
 	 *
 	 * In all cases, disable color keying.
 	 */
-	vsp1_rpf_write(rpf, dl, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
 				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
 
@@ -163,28 +164,30 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
 		rpf->mult_alpha = mult;
 	}
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_MSK_CTRL, 0);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_CKEY_CTRL, 0);
 
 }
 
 static void rpf_configure_frame(struct vsp1_entity *entity,
 				struct vsp1_pipeline *pipe,
-				struct vsp1_dl_list *dl)
+				struct vsp1_dl_list *dl,
+				struct vsp1_dl_body *dlb)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_VRTCOL_SET,
 		       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
 		       (rpf->alpha << VI6_RPF_MULT_ALPHA_RATIO_SHIFT));
 
-	vsp1_pipeline_propagate_alpha(pipe, dl, rpf->alpha);
+	vsp1_pipeline_propagate_alpha(pipe, dlb, rpf->alpha);
 }
 
 static void rpf_configure_partition(struct vsp1_entity *entity,
 				    struct vsp1_pipeline *pipe,
-				    struct vsp1_dl_list *dl)
+				    struct vsp1_dl_list *dl,
+				    struct vsp1_dl_body *dlb)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	struct vsp1_rwpf_memory mem = rpf->mem;
@@ -218,10 +221,10 @@ static void rpf_configure_partition(struct vsp1_entity *entity,
 		crop.left += pipe->partition->rpf.left;
 	}
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRC_BSIZE,
 		       (crop.width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
 		       (crop.height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_ESIZE,
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRC_ESIZE,
 		       (crop.width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
 		       (crop.height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
 
@@ -246,9 +249,9 @@ static void rpf_configure_partition(struct vsp1_entity *entity,
 	    fmtinfo->swap_uv)
 		swap(mem.addr[1], mem.addr[2]);
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
 }
 
 static void rpf_partition(struct vsp1_entity *entity,
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index d29f63dfc17e..04e4e05af6ae 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -24,10 +24,10 @@
  * Device Access
  */
 
-static inline void vsp1_sru_write(struct vsp1_sru *sru, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_sru_write(struct vsp1_sru *sru,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg, data);
+	vsp1_dl_body_write(dlb, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -269,7 +269,7 @@ static const struct v4l2_subdev_ops sru_ops = {
 
 static void sru_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
@@ -295,9 +295,9 @@ static void sru_configure_stream(struct vsp1_entity *entity,
 
 	ctrl0 |= param->ctrl0;
 
-	vsp1_sru_write(sru, dl, VI6_SRU_CTRL0, ctrl0);
-	vsp1_sru_write(sru, dl, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
-	vsp1_sru_write(sru, dl, VI6_SRU_CTRL2, param->ctrl2);
+	vsp1_sru_write(sru, dlb, VI6_SRU_CTRL0, ctrl0);
+	vsp1_sru_write(sru, dlb, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
+	vsp1_sru_write(sru, dlb, VI6_SRU_CTRL2, param->ctrl2);
 }
 
 static unsigned int sru_max_width(struct vsp1_entity *entity,
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index c81ce9e5bff3..c20c84b54936 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -27,22 +27,22 @@
  * Device Access
  */
 
-static inline void vsp1_uds_write(struct vsp1_uds *uds, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_uds_write(struct vsp1_uds *uds,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg + uds->entity.index * VI6_UDS_OFFSET, data);
+	vsp1_dl_body_write(dlb, reg + uds->entity.index * VI6_UDS_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
  * Scaling Computation
  */
 
-void vsp1_uds_set_alpha(struct vsp1_entity *entity, struct vsp1_dl_list *dl,
+void vsp1_uds_set_alpha(struct vsp1_entity *entity, struct vsp1_dl_body *dlb,
 			unsigned int alpha)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 
-	vsp1_uds_write(uds, dl, VI6_UDS_ALPVAL,
+	vsp1_uds_write(uds, dlb, VI6_UDS_ALPVAL,
 		       alpha << VI6_UDS_ALPVAL_VAL0_SHIFT);
 }
 
@@ -257,7 +257,7 @@ static const struct v4l2_subdev_ops uds_ops = {
 
 static void uds_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
@@ -286,25 +286,26 @@ static void uds_configure_stream(struct vsp1_entity *entity,
 	else
 		multitap = true;
 
-	vsp1_uds_write(uds, dl, VI6_UDS_CTRL,
+	vsp1_uds_write(uds, dlb, VI6_UDS_CTRL,
 		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
 		       (multitap ? VI6_UDS_CTRL_BC : 0));
 
-	vsp1_uds_write(uds, dl, VI6_UDS_PASS_BWIDTH,
+	vsp1_uds_write(uds, dlb, VI6_UDS_PASS_BWIDTH,
 		       (uds_passband_width(hscale)
 				<< VI6_UDS_PASS_BWIDTH_H_SHIFT) |
 		       (uds_passband_width(vscale)
 				<< VI6_UDS_PASS_BWIDTH_V_SHIFT));
 
 	/* Set the scaling ratios. */
-	vsp1_uds_write(uds, dl, VI6_UDS_SCALE,
+	vsp1_uds_write(uds, dlb, VI6_UDS_SCALE,
 		       (hscale << VI6_UDS_SCALE_HFRAC_SHIFT) |
 		       (vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
 }
 
 static void uds_configure_partition(struct vsp1_entity *entity,
 				    struct vsp1_pipeline *pipe,
-				    struct vsp1_dl_list *dl)
+				    struct vsp1_dl_list *dl,
+				    struct vsp1_dl_body *dlb)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	struct vsp1_partition *partition = pipe->partition;
@@ -314,13 +315,13 @@ static void uds_configure_partition(struct vsp1_entity *entity,
 					    UDS_PAD_SOURCE);
 
 	/* Input size clipping */
-	vsp1_uds_write(uds, dl, VI6_UDS_HSZCLIP, VI6_UDS_HSZCLIP_HCEN |
+	vsp1_uds_write(uds, dlb, VI6_UDS_HSZCLIP, VI6_UDS_HSZCLIP_HCEN |
 		       (0 << VI6_UDS_HSZCLIP_HCL_OFST_SHIFT) |
 		       (partition->uds_sink.width
 				<< VI6_UDS_HSZCLIP_HCL_SIZE_SHIFT));
 
 	/* Output size clipping */
-	vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
+	vsp1_uds_write(uds, dlb, VI6_UDS_CLIP_SIZE,
 		       (partition->uds_source.width
 				<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
 		       (output->height
diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
index 2cd9f4b95442..c34f95a666d2 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.h
+++ b/drivers/media/platform/vsp1/vsp1_uds.h
@@ -31,7 +31,7 @@ static inline struct vsp1_uds *to_uds(struct v4l2_subdev *subdev)
 
 struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index);
 
-void vsp1_uds_set_alpha(struct vsp1_entity *uds, struct vsp1_dl_list *dl,
+void vsp1_uds_set_alpha(struct vsp1_entity *uds, struct vsp1_dl_body *dlb,
 			unsigned int alpha);
 
 #endif /* __VSP1_UDS_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_uif.c b/drivers/media/platform/vsp1/vsp1_uif.c
index c526e484b326..4b58d51df231 100644
--- a/drivers/media/platform/vsp1/vsp1_uif.c
+++ b/drivers/media/platform/vsp1/vsp1_uif.c
@@ -31,10 +31,11 @@ static inline u32 vsp1_uif_read(struct vsp1_uif *uif, u32 reg)
 	return vsp1_read(uif->entity.vsp1,
 			 uif->entity.index * VI6_UIF_OFFSET + reg);
 }
-static inline void vsp1_uif_write(struct vsp1_uif *uif, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+
+static inline void vsp1_uif_write(struct vsp1_uif *uif,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg + uif->entity.index * VI6_UIF_OFFSET, data);
+	vsp1_dl_body_write(dlb, reg + uif->entity.index * VI6_UIF_OFFSET, data);
 }
 
 u32 vsp1_uif_get_crc(struct vsp1_uif *uif)
@@ -191,14 +192,14 @@ static const struct v4l2_subdev_ops uif_ops = {
 
 static void uif_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_uif *uif = to_uif(&entity->subdev);
 	const struct v4l2_rect *crop;
 	unsigned int left;
 	unsigned int width;
 
-	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMPMR,
+	vsp1_uif_write(uif, dlb, VI6_UIF_DISCOM_DOCMPMR,
 		       VI6_UIF_DISCOM_DOCMPMR_SEL(9));
 
 	crop = vsp1_entity_get_pad_selection(entity, entity->config,
@@ -213,12 +214,12 @@ static void uif_configure_stream(struct vsp1_entity *entity,
 		width /= 2;
 	}
 
-	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSPXR, left);
-	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSPYR, crop->top);
-	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSZXR, width);
-	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMSZYR, crop->height);
+	vsp1_uif_write(uif, dlb, VI6_UIF_DISCOM_DOCMSPXR, left);
+	vsp1_uif_write(uif, dlb, VI6_UIF_DISCOM_DOCMSPYR, crop->top);
+	vsp1_uif_write(uif, dlb, VI6_UIF_DISCOM_DOCMSZXR, width);
+	vsp1_uif_write(uif, dlb, VI6_UIF_DISCOM_DOCMSZYR, crop->height);
 
-	vsp1_uif_write(uif, dl, VI6_UIF_DISCOM_DOCMCR,
+	vsp1_uif_write(uif, dlb, VI6_UIF_DISCOM_DOCMCR,
 		       VI6_UIF_DISCOM_DOCMCR_CMPR);
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index b96717f58a72..72f29773eb1c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -378,25 +378,29 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 					      struct vsp1_dl_list *dl,
 					      unsigned int partition)
 {
+	struct vsp1_dl_body *dlb = vsp1_dl_list_get_body0(dl);
 	struct vsp1_entity *entity;
 
 	pipe->partition = &pipe->part_table[partition];
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe)
-		vsp1_entity_configure_partition(entity, pipe, dl);
+		vsp1_entity_configure_partition(entity, pipe, dl, dlb);
 }
 
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
 	struct vsp1_entity *entity;
+	struct vsp1_dl_body *dlb;
 	unsigned int partition;
 
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 
+	dlb = vsp1_dl_list_get_body0(pipe->dl);
+
 	list_for_each_entry(entity, &pipe->entities, list_pipe)
-		vsp1_entity_configure_frame(entity, pipe, pipe->dl);
+		vsp1_entity_configure_frame(entity, pipe, pipe->dl, dlb);
 
 	/* Run the first partition. */
 	vsp1_video_pipeline_run_partition(pipe, pipe->dl, 0);
@@ -787,6 +791,7 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_entity *entity;
+	struct vsp1_dl_body *dlb;
 	int ret;
 
 	/* Determine this pipelines sizes for image partitioning support. */
@@ -799,6 +804,9 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	if (!pipe->dl)
 		return -ENOMEM;
 
+	/* Retrieve the default DLB from the list. */
+	dlb = vsp1_dl_list_get_body0(pipe->dl);
+
 	if (pipe->uds) {
 		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
 
@@ -821,8 +829,8 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe, pipe->dl);
-		vsp1_entity_configure_stream(entity, pipe, pipe->dl);
+		vsp1_entity_route_setup(entity, pipe, dlb);
+		vsp1_entity_configure_stream(entity, pipe, dlb);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 8662c5d2fc64..23c8f706b3f2 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -27,9 +27,9 @@
  */
 
 static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf,
-				  struct vsp1_dl_list *dl, u32 reg, u32 data)
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg + wpf->entity.index * VI6_WPF_OFFSET, data);
+	vsp1_dl_body_write(dlb, reg + wpf->entity.index * VI6_WPF_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -234,7 +234,7 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 
 static void wpf_configure_stream(struct vsp1_entity *entity,
 				 struct vsp1_pipeline *pipe,
-				 struct vsp1_dl_list *dl)
+				 struct vsp1_dl_body *dlb)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
@@ -268,17 +268,17 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 			outfmt |= VI6_WPF_OUTFMT_SPUVS;
 
 		/* Destination stride and byte swapping. */
-		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_STRIDE_Y,
+		vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_STRIDE_Y,
 			       format->plane_fmt[0].bytesperline);
 		if (format->num_planes > 1)
-			vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_STRIDE_C,
+			vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_STRIDE_C,
 				       format->plane_fmt[1].bytesperline);
 
-		vsp1_wpf_write(wpf, dl, VI6_WPF_DSWAP, fmtinfo->swap);
+		vsp1_wpf_write(wpf, dlb, VI6_WPF_DSWAP, fmtinfo->swap);
 
 		if (vsp1->info->features & VSP1_HAS_WPF_HFLIP &&
 		    wpf->entity.index == 0)
-			vsp1_wpf_write(wpf, dl, VI6_WPF_ROT_CTRL,
+			vsp1_wpf_write(wpf, dlb, VI6_WPF_ROT_CTRL,
 				       VI6_WPF_ROT_CTRL_LN16 |
 				       (256 << VI6_WPF_ROT_CTRL_LMEM_WD_SHIFT));
 	}
@@ -288,10 +288,10 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 
 	wpf->outfmt = outfmt;
 
-	vsp1_dl_list_write(dl, VI6_DPR_WPF_FPORCH(wpf->entity.index),
+	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(wpf->entity.index),
 			   VI6_DPR_WPF_FPORCH_FP_WPFN);
 
-	vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, 0);
+	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL, 0);
 
 	/*
 	 * Sources. If the pipeline has a single input and BRx is not used,
@@ -315,17 +315,18 @@ static void wpf_configure_stream(struct vsp1_entity *entity,
 			? VI6_WPF_SRCRPF_VIRACT_MST
 			: VI6_WPF_SRCRPF_VIRACT2_MST;
 
-	vsp1_wpf_write(wpf, dl, VI6_WPF_SRCRPF, srcrpf);
+	vsp1_wpf_write(wpf, dlb, VI6_WPF_SRCRPF, srcrpf);
 
 	/* Enable interrupts */
-	vsp1_dl_list_write(dl, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
-	vsp1_dl_list_write(dl, VI6_WPF_IRQ_ENB(wpf->entity.index),
+	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
+	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(wpf->entity.index),
 			   VI6_WFP_IRQ_ENB_DFEE);
 }
 
 static void wpf_configure_frame(struct vsp1_entity *entity,
 				struct vsp1_pipeline *pipe,
-				struct vsp1_dl_list *dl)
+				struct vsp1_dl_list *dl,
+				struct vsp1_dl_body *dlb)
 {
 	const unsigned int mask = BIT(WPF_CTRL_VFLIP)
 				| BIT(WPF_CTRL_HFLIP);
@@ -345,12 +346,13 @@ static void wpf_configure_frame(struct vsp1_entity *entity,
 	if (wpf->flip.active & BIT(WPF_CTRL_HFLIP))
 		outfmt |= VI6_WPF_OUTFMT_HFLP;
 
-	vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
+	vsp1_wpf_write(wpf, dlb, VI6_WPF_OUTFMT, outfmt);
 }
 
 static void wpf_configure_partition(struct vsp1_entity *entity,
 				    struct vsp1_pipeline *pipe,
-				    struct vsp1_dl_list *dl)
+				    struct vsp1_dl_list *dl,
+				    struct vsp1_dl_body *dlb)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
@@ -377,10 +379,10 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 	if (pipe->partitions > 1)
 		width = pipe->partition->wpf.width;
 
-	vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
+	vsp1_wpf_write(wpf, dlb, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
 		       (width << VI6_WPF_SZCLIP_SIZE_SHIFT));
-	vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
+	vsp1_wpf_write(wpf, dlb, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
 		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
 		       (height << VI6_WPF_SZCLIP_SIZE_SHIFT));
 
@@ -472,9 +474,9 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 	    fmtinfo->swap_uv)
 		swap(mem.addr[1], mem.addr[2]);
 
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
-	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
+	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
+	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
+	vsp1_wpf_write(wpf, dlb, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
 }
 
 static unsigned int wpf_max_width(struct vsp1_entity *entity,
-- 
git-series 0.9.1

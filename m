Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752268AbdIMLTD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Sep 2017 07:19:03 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com,
        linux-renesas-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 7/9] v4l: vsp1: Adapt entities to configure into a body
Date: Wed, 13 Sep 2017 12:18:46 +0100
Message-Id: <2af61c61d863cbe1608f453d5a709fae0caea46c.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.fd1ad59f0229dc110549eecc18b11ad441997b3a.1505299165.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the entities store their configurations into a display list.
Adapt this such that the code can be configured into a body directly,
allowing greater flexibility and control of the content.

All users of vsp1_dl_list_write() are removed in this process, thus it
too is removed.

A helper, vsp1_dl_list_get_body() is provided to access the internal body0
from the display list.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
I don't like the fact this adds vsp1_dl_list_get_body() on top of
vsp1_dl_body_get(); which are a bit too similar.

Perhaps we should remove body0, or at least call vsp1_dl_list_get_body()
vsp1_dl_list_get_body0()...
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 22 ++++++------
 drivers/media/platform/vsp1/vsp1_clu.c    | 22 ++++++------
 drivers/media/platform/vsp1/vsp1_dl.c     | 12 ++-----
 drivers/media/platform/vsp1/vsp1_dl.h     |  4 +-
 drivers/media/platform/vsp1/vsp1_drm.c    | 14 +++++---
 drivers/media/platform/vsp1/vsp1_entity.c | 16 ++++-----
 drivers/media/platform/vsp1/vsp1_entity.h | 12 ++++---
 drivers/media/platform/vsp1/vsp1_hgo.c    | 16 ++++-----
 drivers/media/platform/vsp1/vsp1_hgt.c    | 18 +++++-----
 drivers/media/platform/vsp1/vsp1_hsit.c   | 10 +++---
 drivers/media/platform/vsp1/vsp1_lif.c    | 13 +++----
 drivers/media/platform/vsp1/vsp1_lut.c    | 21 ++++++------
 drivers/media/platform/vsp1/vsp1_pipe.c   |  4 +-
 drivers/media/platform/vsp1/vsp1_pipe.h   |  3 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 43 +++++++++++-------------
 drivers/media/platform/vsp1/vsp1_sru.c    | 14 ++++----
 drivers/media/platform/vsp1/vsp1_uds.c    | 24 +++++++------
 drivers/media/platform/vsp1/vsp1_uds.h    |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c  | 11 ++++--
 drivers/media/platform/vsp1/vsp1_wpf.c    | 42 ++++++++++++-----------
 20 files changed, 169 insertions(+), 154 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index b9ff96f76b3e..60d449d7b135 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -30,10 +30,10 @@
  * Device Access
  */
 
-static inline void vsp1_bru_write(struct vsp1_bru *bru, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_bru_write(struct vsp1_bru *bru,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, bru->base + reg, data);
+	vsp1_dl_body_write(dlb, bru->base + reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -287,7 +287,7 @@ static const struct v4l2_subdev_ops bru_ops = {
 
 static void bru_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	struct vsp1_bru *bru = to_bru(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
@@ -309,7 +309,7 @@ static void bru_prepare(struct vsp1_entity *entity,
 	 * format at the pipeline output is premultiplied.
 	 */
 	flags = pipe->output ? pipe->output->format.flags : 0;
-	vsp1_bru_write(bru, dl, VI6_BRU_INCTRL,
+	vsp1_bru_write(bru, dlb, VI6_BRU_INCTRL,
 		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
 		       0 : VI6_BRU_INCTRL_NRM);
 
@@ -317,12 +317,12 @@ static void bru_prepare(struct vsp1_entity *entity,
 	 * Set the background position to cover the whole output image and
 	 * configure its color.
 	 */
-	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_SIZE,
+	vsp1_bru_write(bru, dlb, VI6_BRU_VIRRPF_SIZE,
 		       (format->width << VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT) |
 		       (format->height << VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT));
-	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_LOC, 0);
+	vsp1_bru_write(bru, dlb, VI6_BRU_VIRRPF_LOC, 0);
 
-	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_COL, bru->bgcolor |
+	vsp1_bru_write(bru, dlb, VI6_BRU_VIRRPF_COL, bru->bgcolor |
 		       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
 
 	/*
@@ -332,7 +332,7 @@ static void bru_prepare(struct vsp1_entity *entity,
 	 * unit.
 	 */
 	if (entity->type == VSP1_ENTITY_BRU)
-		vsp1_bru_write(bru, dl, VI6_BRU_ROP,
+		vsp1_bru_write(bru, dlb, VI6_BRU_ROP,
 			       VI6_BRU_ROP_DSTSEL_BRUIN(1) |
 			       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
 			       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
@@ -374,7 +374,7 @@ static void bru_prepare(struct vsp1_entity *entity,
 		if (!(entity->type == VSP1_ENTITY_BRU && i == 1))
 			ctrl |= VI6_BRU_CTRL_SRCSEL_BRUIN(i);
 
-		vsp1_bru_write(bru, dl, VI6_BRU_CTRL(i), ctrl);
+		vsp1_bru_write(bru, dlb, VI6_BRU_CTRL(i), ctrl);
 
 		/*
 		 * Harcode the blending formula to
@@ -389,7 +389,7 @@ static void bru_prepare(struct vsp1_entity *entity,
 		 *
 		 * otherwise.
 		 */
-		vsp1_bru_write(bru, dl, VI6_BRU_BLD(i),
+		vsp1_bru_write(bru, dlb, VI6_BRU_BLD(i),
 			       VI6_BRU_BLD_CCMDX_255_SRC_A |
 			       (premultiplied ? VI6_BRU_BLD_CCMDY_COEFY :
 						VI6_BRU_BLD_CCMDY_SRC_A) |
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index 2e4af93a053f..e17a60a4f089 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -29,10 +29,10 @@
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
@@ -215,7 +215,7 @@ static const struct v4l2_subdev_ops clu_ops = {
  */
 static void clu_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	struct vsp1_clu *clu = to_clu(&entity->subdev);
 
@@ -234,14 +234,14 @@ static void clu_prepare(struct vsp1_entity *entity,
 static void clu_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
+			  struct vsp1_dl_body *dlb,
 			  unsigned int partition)
 {
 	struct vsp1_clu *clu = to_clu(&entity->subdev);
-	struct vsp1_dl_body *dlb;
+	struct vsp1_dl_body *clu_dlb;
 	unsigned long flags;
 	u32 ctrl = VI6_CLU_CTRL_AAI | VI6_CLU_CTRL_MVS | VI6_CLU_CTRL_EN;
 
-
 	if (partition == 0) {
 		/* 2D mode can only be used with the YCbCr pixel encoding. */
 		if (clu->mode == V4L2_CID_VSP1_CLU_MODE_2D && clu->yuv_mode)
@@ -249,18 +249,18 @@ static void clu_configure(struct vsp1_entity *entity,
 			     |  VI6_CLU_CTRL_OS0_2D | VI6_CLU_CTRL_OS1_2D
 			     |  VI6_CLU_CTRL_OS2_2D | VI6_CLU_CTRL_M2D;
 
-		vsp1_clu_write(clu, dl, VI6_CLU_CTRL, ctrl);
+		vsp1_clu_write(clu, dlb, VI6_CLU_CTRL, ctrl);
 
 		spin_lock_irqsave(&clu->lock, flags);
-		dlb = clu->clu;
+		clu_dlb = clu->clu;
 		clu->clu = NULL;
 		spin_unlock_irqrestore(&clu->lock, flags);
 
-		if (dlb) {
-			vsp1_dl_list_add_body(dl, dlb);
+		if (clu_dlb) {
+			vsp1_dl_list_add_body(dl, clu_dlb);
 
 			/* release our local reference */
-			vsp1_dl_body_put(dlb);
+			vsp1_dl_body_put(clu_dlb);
 		}
 	}
 }
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 0ee12d3338dd..bca9bd45ac7f 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -442,17 +442,15 @@ void vsp1_dl_list_put(struct vsp1_dl_list *dl)
 }
 
 /**
- * vsp1_dl_list_write - Write a register to the display list
+ * vsp1_dl_list_get_body - Obtain the default body for the display list
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
+struct vsp1_dl_body *vsp1_dl_list_get_body(struct vsp1_dl_list *dl)
 {
-	vsp1_dl_body_write(dl->body0, reg, data);
+	return dl->body0;
 }
 
 /**
diff --git a/drivers/media/platform/vsp1/vsp1_dl.h b/drivers/media/platform/vsp1/vsp1_dl.h
index f71a76332477..f162f04b16ba 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.h
+++ b/drivers/media/platform/vsp1/vsp1_dl.h
@@ -32,7 +32,7 @@ bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm);
 
 struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm);
 void vsp1_dl_list_put(struct vsp1_dl_list *dl);
-void vsp1_dl_list_write(struct vsp1_dl_list *dl, u32 reg, u32 data);
+struct vsp1_dl_body *vsp1_dl_list_get_body(struct vsp1_dl_list *dl);
 void vsp1_dl_list_commit(struct vsp1_dl_list *dl);
 
 struct vsp1_dl_body_pool *
@@ -41,8 +41,8 @@ vsp1_dl_body_pool_create(struct vsp1_device *vsp1, unsigned int num_bodies,
 void vsp1_dl_body_pool_destroy(struct vsp1_dl_body_pool *pool);
 struct vsp1_dl_body *vsp1_dl_body_get(struct vsp1_dl_body_pool *pool);
 void vsp1_dl_body_put(struct vsp1_dl_body *dlb);
-
 void vsp1_dl_body_write(struct vsp1_dl_body *dlb, u32 reg, u32 data);
+
 int vsp1_dl_list_add_body(struct vsp1_dl_list *dl,
 			  struct vsp1_dl_body *dlb);
 int vsp1_dl_list_add_chain(struct vsp1_dl_list *head, struct vsp1_dl_list *dl);
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 2a4fcb866629..37fdccf026b5 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -487,6 +487,7 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 	struct vsp1_entity *entity;
 	struct vsp1_entity *next;
 	struct vsp1_dl_list *dl;
+	struct vsp1_dl_body *dlb;
 	const char *bru_name;
 	unsigned long flags;
 	unsigned int i;
@@ -497,6 +498,9 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 	/* Prepare the display list. */
 	dl = vsp1_dl_list_get(pipe->output->dlm);
 
+	/* Retrieve the default DLB from the list */
+	dlb = vsp1_dl_list_get_body(dl);
+
 	/* Count the number of enabled inputs and sort them by Z-order. */
 	pipe->num_inputs = 0;
 
@@ -549,17 +553,17 @@ void vsp1_du_atomic_flush(struct device *dev, unsigned int pipe_index)
 		/* Disconnect unused RPFs from the pipeline. */
 		if (entity->type == VSP1_ENTITY_RPF &&
 		    !pipe->inputs[entity->index]) {
-			vsp1_dl_list_write(dl, entity->route->reg,
-					   VI6_DPR_NODE_UNUSED);
+			vsp1_dl_body_write(dlb, entity->route->reg,
+					       VI6_DPR_NODE_UNUSED);
 
 			list_del_init(&entity->list_pipe);
 
 			continue;
 		}
 
-		vsp1_entity_route_setup(entity, pipe, dl);
-		vsp1_entity_prepare(entity, pipe, dl);
-		vsp1_entity_configure(entity, pipe, dl, 0);
+		vsp1_entity_route_setup(entity, pipe, dlb);
+		vsp1_entity_prepare(entity, pipe, dlb);
+		vsp1_entity_configure(entity, pipe, dl, dlb, 0);
 	}
 
 	vsp1_dl_list_commit(dl);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 76f240f005af..c9383ff3b069 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -26,7 +26,7 @@
 
 void vsp1_entity_route_setup(struct vsp1_entity *entity,
 			     struct vsp1_pipeline *pipe,
-			     struct vsp1_dl_list *dl)
+			     struct vsp1_dl_body *dlb)
 {
 	struct vsp1_entity *source;
 	u32 route;
@@ -42,7 +42,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 		smppt = (pipe->output->entity.index << VI6_DPR_SMPPT_TGW_SHIFT)
 		      | (source->route->output << VI6_DPR_SMPPT_PT_SHIFT);
 
-		vsp1_dl_list_write(dl, VI6_DPR_HGO_SMPPT, smppt);
+		vsp1_dl_body_write(dlb, VI6_DPR_HGO_SMPPT, smppt);
 		return;
 	} else if (entity->type == VSP1_ENTITY_HGT) {
 		u32 smppt;
@@ -55,7 +55,7 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 		smppt = (pipe->output->entity.index << VI6_DPR_SMPPT_TGW_SHIFT)
 		      | (source->route->output << VI6_DPR_SMPPT_PT_SHIFT);
 
-		vsp1_dl_list_write(dl, VI6_DPR_HGT_SMPPT, smppt);
+		vsp1_dl_body_write(dlb, VI6_DPR_HGT_SMPPT, smppt);
 		return;
 	}
 
@@ -70,22 +70,22 @@ void vsp1_entity_route_setup(struct vsp1_entity *entity,
 	 */
 	if (source->type == VSP1_ENTITY_BRS)
 		route |= VI6_DPR_ROUTE_BRSSEL;
-	vsp1_dl_list_write(dl, source->route->reg, route);
+	vsp1_dl_body_write(dlb, source->route->reg, route);
 }
 
 void vsp1_entity_prepare(struct vsp1_entity *entity, struct vsp1_pipeline *pipe,
-			 struct vsp1_dl_list *dl)
+			 struct vsp1_dl_body *dlb)
 {
 	if (entity->ops->prepare)
-		entity->ops->prepare(entity, pipe, dl);
+		entity->ops->prepare(entity, pipe, dlb);
 }
 
 void vsp1_entity_configure(struct vsp1_entity *entity,
 			   struct vsp1_pipeline *pipe, struct vsp1_dl_list *dl,
-			   unsigned int partition)
+			   struct vsp1_dl_body *dlb, unsigned int partition)
 {
 	if (entity->ops->configure)
-		entity->ops->configure(entity, pipe, dl, partition);
+		entity->ops->configure(entity, pipe, dl, dlb, partition);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 2f33e343ccc6..4eb8afd7e402 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -19,6 +19,7 @@
 #include <media/v4l2-subdev.h>
 
 struct vsp1_device;
+struct vsp1_dl_body;
 struct vsp1_dl_list;
 struct vsp1_pipeline;
 struct vsp1_partition;
@@ -80,9 +81,10 @@ struct vsp1_route {
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
 	void (*prepare)(struct vsp1_entity *, struct vsp1_pipeline *,
-			struct vsp1_dl_list *);
+			struct vsp1_dl_body *);
 	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
-			  struct vsp1_dl_list *, unsigned int partition);
+			  struct vsp1_dl_list *, struct vsp1_dl_body *,
+			  unsigned int partition);
 	unsigned int (*max_width)(struct vsp1_entity *, struct vsp1_pipeline *);
 	void (*partition)(struct vsp1_entity *, struct vsp1_pipeline *,
 			  struct vsp1_partition *, unsigned int,
@@ -147,12 +149,12 @@ int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 
 void vsp1_entity_route_setup(struct vsp1_entity *entity,
 			     struct vsp1_pipeline *pipe,
-			     struct vsp1_dl_list *dl);
+			     struct vsp1_dl_body *dlb);
 void vsp1_entity_prepare(struct vsp1_entity *entity, struct vsp1_pipeline *pipe,
-			 struct vsp1_dl_list *dl);
+			 struct vsp1_dl_body *dlb);
 void vsp1_entity_configure(struct vsp1_entity *entity,
 			   struct vsp1_pipeline *pipe, struct vsp1_dl_list *dl,
-			   unsigned int partition);
+			   struct vsp1_dl_body *dlb, unsigned int partition);
 
 struct media_pad *vsp1_entity_remote_pad(struct media_pad *pad);
 
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index 5705ba67dbc8..6d07e0e2a60c 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -32,10 +32,10 @@ static inline u32 vsp1_hgo_read(struct vsp1_hgo *hgo, u32 reg)
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
@@ -135,7 +135,7 @@ static const struct v4l2_ctrl_config hgo_num_bins_control = {
 
 static void hgo_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -149,12 +149,12 @@ static void hgo_prepare(struct vsp1_entity *entity,
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
 
@@ -166,7 +166,7 @@ static void hgo_prepare(struct vsp1_entity *entity,
 
 	hratio = crop->width * 2 / compose->width / 3;
 	vratio = crop->height * 2 / compose->height / 3;
-	vsp1_hgo_write(hgo, dl, VI6_HGO_MODE,
+	vsp1_hgo_write(hgo, dlb, VI6_HGO_MODE,
 		       (hgo->num_bins == 256 ? VI6_HGO_MODE_STEP : 0) |
 		       (hgo->max_rgb ? VI6_HGO_MODE_MAXRGB : 0) |
 		       (hratio << VI6_HGO_MODE_HRATIO_SHIFT) |
diff --git a/drivers/media/platform/vsp1/vsp1_hgt.c b/drivers/media/platform/vsp1/vsp1_hgt.c
index bdd1247e090f..b0614b1e033c 100644
--- a/drivers/media/platform/vsp1/vsp1_hgt.c
+++ b/drivers/media/platform/vsp1/vsp1_hgt.c
@@ -32,10 +32,10 @@ static inline u32 vsp1_hgt_read(struct vsp1_hgt *hgt, u32 reg)
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
@@ -131,7 +131,7 @@ static const struct v4l2_ctrl_config hgt_hue_areas = {
 
 static void hgt_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	struct vsp1_hgt *hgt = to_hgt(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -148,12 +148,12 @@ static void hgt_prepare(struct vsp1_entity *entity,
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
 
@@ -161,7 +161,7 @@ static void hgt_prepare(struct vsp1_entity *entity,
 	for (i = 0; i < HGT_NUM_HUE_AREAS; ++i) {
 		lower = hgt->hue_areas[i*2 + 0];
 		upper = hgt->hue_areas[i*2 + 1];
-		vsp1_hgt_write(hgt, dl, VI6_HGT_HUE_AREA(i),
+		vsp1_hgt_write(hgt, dlb, VI6_HGT_HUE_AREA(i),
 			       (lower << VI6_HGT_HUE_AREA_LOWER_SHIFT) |
 			       (upper << VI6_HGT_HUE_AREA_UPPER_SHIFT));
 	}
@@ -169,7 +169,7 @@ static void hgt_prepare(struct vsp1_entity *entity,
 
 	hratio = crop->width * 2 / compose->width / 3;
 	vratio = crop->height * 2 / compose->height / 3;
-	vsp1_hgt_write(hgt, dl, VI6_HGT_MODE,
+	vsp1_hgt_write(hgt, dlb, VI6_HGT_MODE,
 		       (hratio << VI6_HGT_MODE_HRATIO_SHIFT) |
 		       (vratio << VI6_HGT_MODE_VRATIO_SHIFT));
 }
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index cf96ce2c6da9..d5b454db4f96 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -28,9 +28,9 @@
  */
 
 static inline void vsp1_hsit_write(struct vsp1_hsit *hsit,
-				   struct vsp1_dl_list *dl, u32 reg, u32 data)
+				   struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg, data);
+	vsp1_dl_body_write(dlb, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -133,14 +133,14 @@ static const struct v4l2_subdev_ops hsit_ops = {
 
 static void hsit_prepare(struct vsp1_entity *entity,
 			 struct vsp1_pipeline *pipe,
-			 struct vsp1_dl_list *dl)
+			 struct vsp1_dl_body *dlb)
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
index 0141bce92c2f..8036b3072335 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -27,10 +27,11 @@
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
@@ -130,7 +131,7 @@ static const struct v4l2_subdev_ops lif_ops = {
 
 static void lif_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
@@ -143,11 +144,11 @@ static void lif_prepare(struct vsp1_entity *entity,
 
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
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 33bfaa1df994..58922ebe7ff8 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -29,10 +29,10 @@
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
@@ -192,33 +192,34 @@ static const struct v4l2_subdev_ops lut_ops = {
 
 static void lut_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 
-	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
+	vsp1_lut_write(lut, dlb, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
 }
 
 static void lut_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
+			  struct vsp1_dl_body *dlb,
 			  unsigned int partition)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
-	struct vsp1_dl_body *dlb;
+	struct vsp1_dl_body *lut_dlb;
 	unsigned long flags;
 
 	if (partition == 0) {
 		spin_lock_irqsave(&lut->lock, flags);
-		dlb = lut->lut;
+		lut_dlb = lut->lut;
 		lut->lut = NULL;
 		spin_unlock_irqrestore(&lut->lock, flags);
 
-		if (dlb) {
-			vsp1_dl_list_add_body(dl, dlb);
+		if (lut_dlb) {
+			vsp1_dl_list_add_body(dl, lut_dlb);
 
 			/* release our local reference */
-			vsp1_dl_body_put(dlb);
+			vsp1_dl_body_put(lut_dlb);
 		}
 	}
 }
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 44944ac86d9b..5012643583b6 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -367,7 +367,7 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
  * from the input RPF alpha.
  */
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
-				   struct vsp1_dl_list *dl, unsigned int alpha)
+				   struct vsp1_dl_body *dlb, unsigned int alpha)
 {
 	if (!pipe->uds)
 		return;
@@ -380,7 +380,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 	    pipe->uds_input->type == VSP1_ENTITY_BRS)
 		alpha = 255;
 
-	vsp1_uds_set_alpha(pipe->uds, dl, alpha);
+	vsp1_uds_set_alpha(pipe->uds, dlb, alpha);
 }
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index dfff9b5685fe..90d29492b9b9 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -161,7 +161,8 @@ bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe);
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
-				   struct vsp1_dl_list *dl, unsigned int alpha);
+				   struct vsp1_dl_body *dlb,
+				   unsigned int alpha);
 
 void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
 				       struct vsp1_partition *partition,
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 87a47997a086..79fd86f1b9da 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -29,9 +29,10 @@
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
@@ -48,7 +49,7 @@ static const struct v4l2_subdev_ops rpf_ops = {
 
 static void rpf_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
@@ -67,7 +68,7 @@ static void rpf_prepare(struct vsp1_entity *entity,
 		pstride |= format->plane_fmt[1].bytesperline
 			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_PSTRIDE, pstride);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_PSTRIDE, pstride);
 
 	/* Format */
 	sink_format = vsp1_entity_get_pad_format(&rpf->entity,
@@ -88,8 +89,8 @@ static void rpf_prepare(struct vsp1_entity *entity,
 	if (sink_format->code != source_format->code)
 		infmt |= VI6_RPF_INFMT_CSC;
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_INFMT, infmt);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_DSWAP, fmtinfo->swap);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_INFMT, infmt);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_DSWAP, fmtinfo->swap);
 
 	/* Output location */
 	if (pipe->bru) {
@@ -103,7 +104,7 @@ static void rpf_prepare(struct vsp1_entity *entity,
 		top = compose->top;
 	}
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_LOC,
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_LOC,
 		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
 		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
 
@@ -130,7 +131,7 @@ static void rpf_prepare(struct vsp1_entity *entity,
 	 *
 	 * In all cases, disable color keying.
 	 */
-	vsp1_rpf_write(rpf, dl, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
 				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
 
@@ -167,15 +168,14 @@ static void rpf_prepare(struct vsp1_entity *entity,
 		rpf->mult_alpha = mult;
 	}
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
-	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_MSK_CTRL, 0);
+	vsp1_rpf_write(rpf, dlb, VI6_RPF_CKEY_CTRL, 0);
 
 }
 
 static void rpf_configure(struct vsp1_entity *entity,
-			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl,
-			  unsigned int partition)
+			  struct vsp1_pipeline *pipe, struct vsp1_dl_list *dl,
+			  struct vsp1_dl_body *dlb, unsigned int partition)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	struct vsp1_rwpf_memory mem = rpf->mem;
@@ -185,15 +185,14 @@ static void rpf_configure(struct vsp1_entity *entity,
 	struct v4l2_rect crop;
 
 	if (partition == 0) {
-		vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
+		vsp1_rpf_write(rpf, dlb, VI6_RPF_VRTCOL_SET,
 			       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
-		vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
+		vsp1_rpf_write(rpf, dlb, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
 			       (rpf->alpha << VI6_RPF_MULT_ALPHA_RATIO_SHIFT));
 
-		vsp1_pipeline_propagate_alpha(pipe, dl, rpf->alpha);
+		vsp1_pipeline_propagate_alpha(pipe, dlb, rpf->alpha);
 	}
 
-
 	/*
 	 * Source size and crop offsets.
 	 *
@@ -219,10 +218,10 @@ static void rpf_configure(struct vsp1_entity *entity,
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
 
@@ -247,9 +246,9 @@ static void rpf_configure(struct vsp1_entity *entity,
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
index 0a24bc59bc2f..1f938b6d6d45 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -28,10 +28,10 @@
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
@@ -273,7 +273,7 @@ static const struct v4l2_subdev_ops sru_ops = {
 
 static void sru_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
@@ -299,9 +299,9 @@ static void sru_prepare(struct vsp1_entity *entity,
 
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
index 84be962a33b1..7afcb2ae30a5 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -31,22 +31,23 @@
  * Device Access
  */
 
-static inline void vsp1_uds_write(struct vsp1_uds *uds, struct vsp1_dl_list *dl,
-				  u32 reg, u32 data)
+static inline void vsp1_uds_write(struct vsp1_uds *uds,
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg + uds->entity.index * VI6_UDS_OFFSET, data);
+	vsp1_dl_body_write(dlb, reg + uds->entity.index * VI6_UDS_OFFSET,
+			       data);
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
 
@@ -261,7 +262,7 @@ static const struct v4l2_subdev_ops uds_ops = {
 
 static void uds_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
@@ -290,18 +291,18 @@ static void uds_prepare(struct vsp1_entity *entity,
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
@@ -309,6 +310,7 @@ static void uds_prepare(struct vsp1_entity *entity,
 static void uds_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
+			  struct vsp1_dl_body *dlb,
 			  unsigned int pindex)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
@@ -319,13 +321,13 @@ static void uds_configure(struct vsp1_entity *entity,
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
index 7bf3cdcffc65..d99997f3b28d 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.h
+++ b/drivers/media/platform/vsp1/vsp1_uds.h
@@ -35,7 +35,7 @@ static inline struct vsp1_uds *to_uds(struct v4l2_subdev *subdev)
 
 struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index);
 
-void vsp1_uds_set_alpha(struct vsp1_entity *uds, struct vsp1_dl_list *dl,
+void vsp1_uds_set_alpha(struct vsp1_entity *uds, struct vsp1_dl_body *dlb,
 			unsigned int alpha);
 
 #endif /* __VSP1_UDS_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index bd5403f24dda..9366b41c1b43 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -383,11 +383,12 @@ static void vsp1_video_pipeline_run_partition(struct vsp1_pipeline *pipe,
 					      unsigned int partition)
 {
 	struct vsp1_entity *entity;
+	struct vsp1_dl_body *dlb = vsp1_dl_list_get_body(dl);
 
 	pipe->partition = &pipe->part_table[partition];
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe)
-		vsp1_entity_configure(entity, pipe, dl, partition);
+		vsp1_entity_configure(entity, pipe, dl, dlb, partition);
 }
 
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
@@ -790,6 +791,7 @@ static void vsp1_video_buffer_queue(struct vb2_buffer *vb)
 static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_entity *entity;
+	struct vsp1_dl_body *dlb;
 	int ret;
 
 	/* Determine this pipelines sizes for image partitioning support. */
@@ -802,6 +804,9 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	if (!pipe->dl)
 		return -ENOMEM;
 
+	/* Retrieve the default DLB from the list */
+	dlb = vsp1_dl_list_get_body(pipe->dl);
+
 	if (pipe->uds) {
 		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
 
@@ -824,8 +829,8 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity, pipe, pipe->dl);
-		vsp1_entity_prepare(entity, pipe, pipe->dl);
+		vsp1_entity_route_setup(entity, pipe, dlb);
+		vsp1_entity_prepare(entity, pipe, dlb);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index d6dd7e783d27..2b5c006ecb54 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -31,9 +31,10 @@
  */
 
 static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf,
-				  struct vsp1_dl_list *dl, u32 reg, u32 data)
+				  struct vsp1_dl_body *dlb, u32 reg, u32 data)
 {
-	vsp1_dl_list_write(dl, reg + wpf->entity.index * VI6_WPF_OFFSET, data);
+	vsp1_dl_body_write(dlb, reg + wpf->entity.index * VI6_WPF_OFFSET,
+			       data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -238,7 +239,7 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 
 static void wpf_prepare(struct vsp1_entity *entity,
 			struct vsp1_pipeline *pipe,
-			struct vsp1_dl_list *dl)
+			struct vsp1_dl_body *dlb)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
@@ -272,17 +273,17 @@ static void wpf_prepare(struct vsp1_entity *entity,
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
@@ -292,10 +293,10 @@ static void wpf_prepare(struct vsp1_entity *entity,
 
 	wpf->outfmt = outfmt;
 
-	vsp1_dl_list_write(dl, VI6_DPR_WPF_FPORCH(wpf->entity.index),
-			   VI6_DPR_WPF_FPORCH_FP_WPFN);
+	vsp1_dl_body_write(dlb, VI6_DPR_WPF_FPORCH(wpf->entity.index),
+			       VI6_DPR_WPF_FPORCH_FP_WPFN);
 
-	vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, 0);
+	vsp1_dl_body_write(dlb, VI6_WPF_WRBCK_CTRL, 0);
 
 	/*
 	 * Sources. If the pipeline has a single input and BRU is not used,
@@ -319,17 +320,18 @@ static void wpf_prepare(struct vsp1_entity *entity,
 			? VI6_WPF_SRCRPF_VIRACT_MST
 			: VI6_WPF_SRCRPF_VIRACT2_MST;
 
-	vsp1_wpf_write(wpf, dl, VI6_WPF_SRCRPF, srcrpf);
+	vsp1_wpf_write(wpf, dlb, VI6_WPF_SRCRPF, srcrpf);
 
 	/* Enable interrupts */
-	vsp1_dl_list_write(dl, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
-	vsp1_dl_list_write(dl, VI6_WPF_IRQ_ENB(wpf->entity.index),
-			   VI6_WFP_IRQ_ENB_DFEE);
+	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
+	vsp1_dl_body_write(dlb, VI6_WPF_IRQ_ENB(wpf->entity.index),
+			       VI6_WFP_IRQ_ENB_DFEE);
 }
 
 static void wpf_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_dl_list *dl,
+			  struct vsp1_dl_body *dlb,
 			  unsigned int partition)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
@@ -363,7 +365,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 		if (wpf->flip.active & BIT(WPF_CTRL_HFLIP))
 			outfmt |= VI6_WPF_OUTFMT_HFLP;
 
-		vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
+		vsp1_wpf_write(wpf, dlb, VI6_WPF_OUTFMT, outfmt);
 	}
 
 	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
@@ -379,10 +381,10 @@ static void wpf_configure(struct vsp1_entity *entity,
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
 
@@ -474,9 +476,9 @@ static void wpf_configure(struct vsp1_entity *entity,
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

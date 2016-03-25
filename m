Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbcCYKo7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:59 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 35/54] v4l: vsp1: Pass display list explicitly to configure functions
Date: Fri, 25 Mar 2016 12:44:09 +0200
Message-Id: <1458902668-1141-36-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modules write register values to the active display list pointed to by
the pipeline. In order to support preparing display lists ahead of time,
pass them explicitly to all configuration functions.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 22 ++++++++--------
 drivers/media/platform/vsp1/vsp1_drm.c    | 14 +++++------
 drivers/media/platform/vsp1/vsp1_entity.c | 15 +++--------
 drivers/media/platform/vsp1/vsp1_entity.h | 14 +++++------
 drivers/media/platform/vsp1/vsp1_hsit.c   | 12 +++++----
 drivers/media/platform/vsp1/vsp1_lif.c    | 12 +++++----
 drivers/media/platform/vsp1/vsp1_lut.c    | 10 +++++---
 drivers/media/platform/vsp1/vsp1_pipe.c   |  3 ++-
 drivers/media/platform/vsp1/vsp1_pipe.h   |  1 +
 drivers/media/platform/vsp1/vsp1_rpf.c    | 39 ++++++++++++++--------------
 drivers/media/platform/vsp1/vsp1_rwpf.h   |  8 +++---
 drivers/media/platform/vsp1/vsp1_sru.c    | 14 ++++++-----
 drivers/media/platform/vsp1/vsp1_uds.c    | 23 +++++++++--------
 drivers/media/platform/vsp1/vsp1_uds.h    |  3 ++-
 drivers/media/platform/vsp1/vsp1_video.c  | 11 +++-----
 drivers/media/platform/vsp1/vsp1_wpf.c    | 42 +++++++++++++++----------------
 16 files changed, 125 insertions(+), 118 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index df57ab6d7e3e..9914410362d0 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -18,6 +18,7 @@
 
 #include "vsp1.h"
 #include "vsp1_bru.h"
+#include "vsp1_dl.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_video.h"
 
@@ -28,9 +29,10 @@
  * Device Access
  */
 
-static inline void vsp1_bru_write(struct vsp1_bru *bru, u32 reg, u32 data)
+static inline void vsp1_bru_write(struct vsp1_bru *bru, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
 {
-	vsp1_mod_write(&bru->entity, reg, data);
+	vsp1_dl_list_write(dl, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -303,7 +305,7 @@ static struct v4l2_subdev_ops bru_ops = {
  * VSP1 Entity Operations
  */
 
-static void bru_configure(struct vsp1_entity *entity)
+static void bru_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_bru *bru = to_bru(&entity->subdev);
@@ -324,26 +326,26 @@ static void bru_configure(struct vsp1_entity *entity)
 	 * format at the pipeline output is premultiplied.
 	 */
 	flags = pipe->output ? pipe->output->format.flags : 0;
-	vsp1_bru_write(bru, VI6_BRU_INCTRL,
+	vsp1_bru_write(bru, dl, VI6_BRU_INCTRL,
 		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
 		       0 : VI6_BRU_INCTRL_NRM);
 
 	/* Set the background position to cover the whole output image and
 	 * configure its color.
 	 */
-	vsp1_bru_write(bru, VI6_BRU_VIRRPF_SIZE,
+	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_SIZE,
 		       (format->width << VI6_BRU_VIRRPF_SIZE_HSIZE_SHIFT) |
 		       (format->height << VI6_BRU_VIRRPF_SIZE_VSIZE_SHIFT));
-	vsp1_bru_write(bru, VI6_BRU_VIRRPF_LOC, 0);
+	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_LOC, 0);
 
-	vsp1_bru_write(bru, VI6_BRU_VIRRPF_COL, bru->bgcolor |
+	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_COL, bru->bgcolor |
 		       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
 
 	/* Route BRU input 1 as SRC input to the ROP unit and configure the ROP
 	 * unit with a NOP operation to make BRU input 1 available as the
 	 * Blend/ROP unit B SRC input.
 	 */
-	vsp1_bru_write(bru, VI6_BRU_ROP, VI6_BRU_ROP_DSTSEL_BRUIN(1) |
+	vsp1_bru_write(bru, dl, VI6_BRU_ROP, VI6_BRU_ROP_DSTSEL_BRUIN(1) |
 		       VI6_BRU_ROP_CROP(VI6_ROP_NOP) |
 		       VI6_BRU_ROP_AROP(VI6_ROP_NOP));
 
@@ -380,7 +382,7 @@ static void bru_configure(struct vsp1_entity *entity)
 		if (i != 1)
 			ctrl |= VI6_BRU_CTRL_SRCSEL_BRUIN(i);
 
-		vsp1_bru_write(bru, VI6_BRU_CTRL(i), ctrl);
+		vsp1_bru_write(bru, dl, VI6_BRU_CTRL(i), ctrl);
 
 		/* Harcode the blending formula to
 		 *
@@ -394,7 +396,7 @@ static void bru_configure(struct vsp1_entity *entity)
 		 *
 		 * otherwise.
 		 */
-		vsp1_bru_write(bru, VI6_BRU_BLD(i),
+		vsp1_bru_write(bru, dl, VI6_BRU_BLD(i),
 			       VI6_BRU_BLD_CCMDX_255_SRC_A |
 			       (premultiplied ? VI6_BRU_BLD_CCMDY_COEFY :
 						VI6_BRU_BLD_CCMDY_SRC_A) |
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index bec7a651d152..a9735b199a4b 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -455,24 +455,22 @@ void vsp1_du_atomic_flush(struct device *dev)
 			struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 
 			if (!pipe->inputs[rpf->entity.index]) {
-				vsp1_mod_write(entity, entity->route->reg,
-					   VI6_DPR_NODE_UNUSED);
+				vsp1_dl_list_write(pipe->dl, entity->route->reg,
+						   VI6_DPR_NODE_UNUSED);
 				continue;
 			}
 		}
 
-		vsp1_entity_route_setup(entity);
+		vsp1_entity_route_setup(entity, pipe->dl);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity);
+			entity->ops->configure(entity, pipe->dl);
 
 		if (entity->type == VSP1_ENTITY_RPF)
-			vsp1_rwpf_set_memory(to_rwpf(&entity->subdev));
+			vsp1_rwpf_set_memory(to_rwpf(&entity->subdev),
+					     pipe->dl);
 	}
 
-	/* We know that the WPF s_stream operation never fails. */
-	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 1);
-
 	vsp1_dl_list_commit(pipe->dl);
 	pipe->dl = NULL;
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 37519acd1691..36d425234cd3 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -21,16 +21,9 @@
 #include "vsp1.h"
 #include "vsp1_dl.h"
 #include "vsp1_entity.h"
-#include "vsp1_pipe.h"
 
-void vsp1_mod_write(struct vsp1_entity *e, u32 reg, u32 data)
-{
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&e->subdev.entity);
-
-	vsp1_dl_list_write(pipe->dl, reg, data);
-}
-
-void vsp1_entity_route_setup(struct vsp1_entity *source)
+void vsp1_entity_route_setup(struct vsp1_entity *source,
+			     struct vsp1_dl_list *dl)
 {
 	struct vsp1_entity *sink;
 
@@ -38,8 +31,8 @@ void vsp1_entity_route_setup(struct vsp1_entity *source)
 		return;
 
 	sink = container_of(source->sink, struct vsp1_entity, subdev.entity);
-	vsp1_mod_write(source, source->route->reg,
-		       sink->route->inputs[source->sink_pad]);
+	vsp1_dl_list_write(dl, source->route->reg,
+			   sink->route->inputs[source->sink_pad]);
 }
 
 /* -----------------------------------------------------------------------------
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 3ce74c6f12e1..1db0311b217c 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -19,6 +19,7 @@
 #include <media/v4l2-subdev.h>
 
 struct vsp1_device;
+struct vsp1_dl_list;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
@@ -57,15 +58,15 @@ struct vsp1_route {
  * struct vsp1_entity_operations - Entity operations
  * @destroy:	Destroy the entity.
  * @set_memory:	Setup memory buffer access. This operation applies the settings
- *		stored in the rwpf mem field to the hardware. Valid for RPF and
- *		WPF only.
+ *		stored in the rwpf mem field to the display list. Valid for RPF
+ *		and WPF only.
  * @configure:	Setup the hardware based on the entity state (pipeline, formats,
  *		selection rectangles, ...)
  */
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
-	void (*set_memory)(struct vsp1_entity *);
-	void (*configure)(struct vsp1_entity *);
+	void (*set_memory)(struct vsp1_entity *, struct vsp1_dl_list *dl);
+	void (*configure)(struct vsp1_entity *, struct vsp1_dl_list *dl);
 };
 
 struct vsp1_entity {
@@ -121,8 +122,7 @@ vsp1_entity_get_pad_compose(struct vsp1_entity *entity,
 int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 			 struct v4l2_subdev_pad_config *cfg);
 
-void vsp1_entity_route_setup(struct vsp1_entity *source);
-
-void vsp1_mod_write(struct vsp1_entity *e, u32 reg, u32 data);
+void vsp1_entity_route_setup(struct vsp1_entity *source,
+			     struct vsp1_dl_list *dl);
 
 #endif /* __VSP1_ENTITY_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index b935a62e6399..6352a9e32983 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
+#include "vsp1_dl.h"
 #include "vsp1_hsit.h"
 
 #define HSIT_MIN_SIZE				4U
@@ -26,9 +27,10 @@
  * Device Access
  */
 
-static inline void vsp1_hsit_write(struct vsp1_hsit *hsit, u32 reg, u32 data)
+static inline void vsp1_hsit_write(struct vsp1_hsit *hsit,
+				   struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	vsp1_mod_write(&hsit->entity, reg, data);
+	vsp1_dl_list_write(dl, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -164,14 +166,14 @@ static struct v4l2_subdev_ops hsit_ops = {
  * VSP1 Entity Operations
  */
 
-static void hsit_configure(struct vsp1_entity *entity)
+static void hsit_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
 
 	if (hsit->inverse)
-		vsp1_hsit_write(hsit, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
+		vsp1_hsit_write(hsit, dl, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
 	else
-		vsp1_hsit_write(hsit, VI6_HST_CTRL, VI6_HST_CTRL_EN);
+		vsp1_hsit_write(hsit, dl, VI6_HST_CTRL, VI6_HST_CTRL_EN);
 }
 
 static const struct vsp1_entity_operations hsit_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index d3b94055f23c..ba8610fa45a0 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
+#include "vsp1_dl.h"
 #include "vsp1_lif.h"
 
 #define LIF_MIN_SIZE				2U
@@ -26,9 +27,10 @@
  * Device Access
  */
 
-static inline void vsp1_lif_write(struct vsp1_lif *lif, u32 reg, u32 data)
+static inline void vsp1_lif_write(struct vsp1_lif *lif, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
 {
-	vsp1_mod_write(&lif->entity, reg, data);
+	vsp1_dl_list_write(dl, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -183,7 +185,7 @@ static struct v4l2_subdev_ops lif_ops = {
  * VSP1 Entity Operations
  */
 
-static void lif_configure(struct vsp1_entity *entity)
+static void lif_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
@@ -196,11 +198,11 @@ static void lif_configure(struct vsp1_entity *entity)
 
 	obth = min(obth, (format->width + 1) / 2 * format->height - 4);
 
-	vsp1_lif_write(lif, VI6_LIF_CSBTH,
+	vsp1_lif_write(lif, dl, VI6_LIF_CSBTH,
 			(hbth << VI6_LIF_CSBTH_HBTH_SHIFT) |
 			(lbth << VI6_LIF_CSBTH_LBTH_SHIFT));
 
-	vsp1_lif_write(lif, VI6_LIF_CTRL,
+	vsp1_lif_write(lif, dl, VI6_LIF_CTRL,
 			(obth << VI6_LIF_CTRL_OBTH_SHIFT) |
 			(format->code == 0 ? VI6_LIF_CTRL_CFMT : 0) |
 			VI6_LIF_CTRL_REQSEL | VI6_LIF_CTRL_LIF_EN);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 1e8d43460d49..93c6b45f96ad 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -18,6 +18,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
+#include "vsp1_dl.h"
 #include "vsp1_lut.h"
 
 #define LUT_MIN_SIZE				4U
@@ -27,9 +28,10 @@
  * Device Access
  */
 
-static inline void vsp1_lut_write(struct vsp1_lut *lut, u32 reg, u32 data)
+static inline void vsp1_lut_write(struct vsp1_lut *lut, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
 {
-	vsp1_mod_write(&lut->entity, reg, data);
+	vsp1_dl_list_write(dl, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -219,11 +221,11 @@ static struct v4l2_subdev_ops lut_ops = {
  * VSP1 Entity Operations
  */
 
-static void lut_configure(struct vsp1_entity *entity)
+static void lut_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 
-	vsp1_lut_write(lut, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
+	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
 }
 
 static const struct vsp1_entity_operations lut_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index fe2538d5bed1..4d06519f717d 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -295,6 +295,7 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe)
  */
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 				   struct vsp1_entity *input,
+				   struct vsp1_dl_list *dl,
 				   unsigned int alpha)
 {
 	struct vsp1_entity *entity;
@@ -317,7 +318,7 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 		if (entity->type == VSP1_ENTITY_UDS) {
 			struct vsp1_uds *uds = to_uds(&entity->subdev);
 
-			vsp1_uds_set_alpha(uds, alpha);
+			vsp1_uds_set_alpha(uds, dl, alpha);
 			break;
 		}
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index f4bdfc943add..1100229a1ed2 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -123,6 +123,7 @@ void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 
 void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 				   struct vsp1_entity *input,
+				   struct vsp1_dl_list *dl,
 				   unsigned int alpha);
 
 void vsp1_pipelines_suspend(struct vsp1_device *vsp1);
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 886312de9089..c8127f2999d2 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -16,6 +16,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
+#include "vsp1_dl.h"
 #include "vsp1_rwpf.h"
 #include "vsp1_video.h"
 
@@ -26,10 +27,10 @@
  * Device Access
  */
 
-static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
+static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf,
+				  struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	vsp1_mod_write(&rpf->entity, reg + rpf->entity.index * VI6_RPF_OFFSET,
-		       data);
+	vsp1_dl_list_write(dl, reg + rpf->entity.index * VI6_RPF_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -44,19 +45,19 @@ static struct v4l2_subdev_ops rpf_ops = {
  * VSP1 Entity Operations
  */
 
-static void rpf_set_memory(struct vsp1_entity *entity)
+static void rpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_rwpf *rpf = entity_to_rwpf(entity);
 
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_Y,
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_Y,
 		       rpf->mem.addr[0] + rpf->offsets[0]);
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C0,
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C0,
 		       rpf->mem.addr[1] + rpf->offsets[1]);
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_ADDR_C1,
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C1,
 		       rpf->mem.addr[2] + rpf->offsets[1]);
 }
 
-static void rpf_configure(struct vsp1_entity *entity)
+static void rpf_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
@@ -78,10 +79,10 @@ static void rpf_configure(struct vsp1_entity *entity)
 	 */
 	crop = vsp1_rwpf_get_crop(rpf, rpf->entity.config);
 
-	vsp1_rpf_write(rpf, VI6_RPF_SRC_BSIZE,
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_BSIZE,
 		       (crop->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
 		       (crop->height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
-	vsp1_rpf_write(rpf, VI6_RPF_SRC_ESIZE,
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRC_ESIZE,
 		       (crop->width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
 		       (crop->height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
 
@@ -99,7 +100,7 @@ static void rpf_configure(struct vsp1_entity *entity)
 		rpf->offsets[1] = 0;
 	}
 
-	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
+	vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_PSTRIDE, pstride);
 
 	/* Format */
 	sink_format = vsp1_entity_get_pad_format(&rpf->entity,
@@ -120,8 +121,8 @@ static void rpf_configure(struct vsp1_entity *entity)
 	if (sink_format->code != source_format->code)
 		infmt |= VI6_RPF_INFMT_CSC;
 
-	vsp1_rpf_write(rpf, VI6_RPF_INFMT, infmt);
-	vsp1_rpf_write(rpf, VI6_RPF_DSWAP, fmtinfo->swap);
+	vsp1_rpf_write(rpf, dl, VI6_RPF_INFMT, infmt);
+	vsp1_rpf_write(rpf, dl, VI6_RPF_DSWAP, fmtinfo->swap);
 
 	/* Output location */
 	if (pipe->bru) {
@@ -134,7 +135,7 @@ static void rpf_configure(struct vsp1_entity *entity)
 		top = compose->top;
 	}
 
-	vsp1_rpf_write(rpf, VI6_RPF_LOC,
+	vsp1_rpf_write(rpf, dl, VI6_RPF_LOC,
 		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
 		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
 
@@ -142,17 +143,17 @@ static void rpf_configure(struct vsp1_entity *entity)
 	 * alpha value set through the V4L2_CID_ALPHA_COMPONENT control
 	 * otherwise. Disable color keying.
 	 */
-	vsp1_rpf_write(rpf, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
+	vsp1_rpf_write(rpf, dl, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
 				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
 
-	vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
+	vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
 		       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
 
-	vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, rpf->alpha);
+	vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, dl, rpf->alpha);
 
-	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
-	vsp1_rpf_write(rpf, VI6_RPF_CKEY_CTRL, 0);
+	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
+	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 9502710977e8..38c8c902db52 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -75,12 +75,14 @@ struct v4l2_rect *vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf,
 /**
  * vsp1_rwpf_set_memory - Configure DMA addresses for a [RW]PF
  * @rwpf: the [RW]PF instance
+ * @dl: the display list
  *
- * This function applies the cached memory buffer address to the hardware.
+ * This function applies the cached memory buffer address to the display list.
  */
-static inline void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf)
+static inline void vsp1_rwpf_set_memory(struct vsp1_rwpf *rwpf,
+					struct vsp1_dl_list *dl)
 {
-	rwpf->entity.ops->set_memory(&rwpf->entity);
+	rwpf->entity.ops->set_memory(&rwpf->entity, dl);
 }
 
 #endif /* __VSP1_RWPF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 82a8ee202f1a..bb3389dda9c5 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
+#include "vsp1_dl.h"
 #include "vsp1_sru.h"
 
 #define SRU_MIN_SIZE				4U
@@ -26,9 +27,10 @@
  * Device Access
  */
 
-static inline void vsp1_sru_write(struct vsp1_sru *sru, u32 reg, u32 data)
+static inline void vsp1_sru_write(struct vsp1_sru *sru, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
 {
-	vsp1_mod_write(&sru->entity, reg, data);
+	vsp1_dl_list_write(dl, reg, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -295,7 +297,7 @@ static struct v4l2_subdev_ops sru_ops = {
  * VSP1 Entity Operations
  */
 
-static void sru_configure(struct vsp1_entity *entity)
+static void sru_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
@@ -321,9 +323,9 @@ static void sru_configure(struct vsp1_entity *entity)
 
 	ctrl0 |= param->ctrl0;
 
-	vsp1_sru_write(sru, VI6_SRU_CTRL0, ctrl0);
-	vsp1_sru_write(sru, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
-	vsp1_sru_write(sru, VI6_SRU_CTRL2, param->ctrl2);
+	vsp1_sru_write(sru, dl, VI6_SRU_CTRL0, ctrl0);
+	vsp1_sru_write(sru, dl, VI6_SRU_CTRL1, VI6_SRU_CTRL1_PARAM5);
+	vsp1_sru_write(sru, dl, VI6_SRU_CTRL2, param->ctrl2);
 }
 
 static const struct vsp1_entity_operations sru_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 88c44f450f88..cdc033050a9b 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -17,6 +17,7 @@
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
+#include "vsp1_dl.h"
 #include "vsp1_uds.h"
 
 #define UDS_MIN_SIZE				4U
@@ -29,19 +30,21 @@
  * Device Access
  */
 
-static inline void vsp1_uds_write(struct vsp1_uds *uds, u32 reg, u32 data)
+static inline void vsp1_uds_write(struct vsp1_uds *uds, struct vsp1_dl_list *dl,
+				  u32 reg, u32 data)
 {
-	vsp1_mod_write(&uds->entity, reg + uds->entity.index * VI6_UDS_OFFSET,
-		       data);
+	vsp1_dl_list_write(dl, reg + uds->entity.index * VI6_UDS_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
  * Scaling Computation
  */
 
-void vsp1_uds_set_alpha(struct vsp1_uds *uds, unsigned int alpha)
+void vsp1_uds_set_alpha(struct vsp1_uds *uds, struct vsp1_dl_list *dl,
+			unsigned int alpha)
 {
-	vsp1_uds_write(uds, VI6_UDS_ALPVAL, alpha << VI6_UDS_ALPVAL_VAL0_SHIFT);
+	vsp1_uds_write(uds, dl, VI6_UDS_ALPVAL,
+		       alpha << VI6_UDS_ALPVAL_VAL0_SHIFT);
 }
 
 /*
@@ -281,7 +284,7 @@ static struct v4l2_subdev_ops uds_ops = {
  * VSP1 Entity Operations
  */
 
-static void uds_configure(struct vsp1_entity *entity)
+static void uds_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
@@ -309,21 +312,21 @@ static void uds_configure(struct vsp1_entity *entity)
 	else
 		multitap = true;
 
-	vsp1_uds_write(uds, VI6_UDS_CTRL,
+	vsp1_uds_write(uds, dl, VI6_UDS_CTRL,
 		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
 		       (multitap ? VI6_UDS_CTRL_BC : 0));
 
-	vsp1_uds_write(uds, VI6_UDS_PASS_BWIDTH,
+	vsp1_uds_write(uds, dl, VI6_UDS_PASS_BWIDTH,
 		       (uds_passband_width(hscale)
 				<< VI6_UDS_PASS_BWIDTH_H_SHIFT) |
 		       (uds_passband_width(vscale)
 				<< VI6_UDS_PASS_BWIDTH_V_SHIFT));
 
 	/* Set the scaling ratios and the output size. */
-	vsp1_uds_write(uds, VI6_UDS_SCALE,
+	vsp1_uds_write(uds, dl, VI6_UDS_SCALE,
 		       (hscale << VI6_UDS_SCALE_HFRAC_SHIFT) |
 		       (vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
-	vsp1_uds_write(uds, VI6_UDS_CLIP_SIZE,
+	vsp1_uds_write(uds, dl, VI6_UDS_CLIP_SIZE,
 		       (output->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
 		       (output->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
 }
diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
index 031ac0da1b66..5c8cbfcad4cc 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.h
+++ b/drivers/media/platform/vsp1/vsp1_uds.h
@@ -35,6 +35,7 @@ static inline struct vsp1_uds *to_uds(struct v4l2_subdev *subdev)
 
 struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index);
 
-void vsp1_uds_set_alpha(struct vsp1_uds *uds, unsigned int alpha);
+void vsp1_uds_set_alpha(struct vsp1_uds *uds, struct vsp1_dl_list *dl,
+			unsigned int alpha);
 
 #endif /* __VSP1_UDS_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 4dcc892977df..a45bf68e0ba1 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -455,11 +455,11 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 		struct vsp1_rwpf *rwpf = pipe->inputs[i];
 
 		if (rwpf)
-			vsp1_rwpf_set_memory(rwpf);
+			vsp1_rwpf_set_memory(rwpf, pipe->dl);
 	}
 
 	if (!pipe->lif)
-		vsp1_rwpf_set_memory(pipe->output);
+		vsp1_rwpf_set_memory(pipe->output, pipe->dl);
 
 	vsp1_dl_list_commit(pipe->dl);
 	pipe->dl = NULL;
@@ -616,15 +616,12 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	}
 
 	list_for_each_entry(entity, &pipe->entities, list_pipe) {
-		vsp1_entity_route_setup(entity);
+		vsp1_entity_route_setup(entity, pipe->dl);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity);
+			entity->ops->configure(entity, pipe->dl);
 	}
 
-	/* We know that the WPF s_stream operation never fails. */
-	v4l2_subdev_call(&pipe->output->entity.subdev, video, s_stream, 1);
-
 	return 0;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 783a923fa76c..36b4c9fdead6 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -27,10 +27,10 @@
  * Device Access
  */
 
-static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, u32 reg, u32 data)
+static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf,
+				  struct vsp1_dl_list *dl, u32 reg, u32 data)
 {
-	vsp1_mod_write(&wpf->entity,
-		       reg + wpf->entity.index * VI6_WPF_OFFSET, data);
+	vsp1_dl_list_write(dl, reg + wpf->entity.index * VI6_WPF_OFFSET, data);
 }
 
 /* -----------------------------------------------------------------------------
@@ -79,16 +79,16 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 	vsp1_dlm_destroy(wpf->dlm);
 }
 
-static void wpf_set_memory(struct vsp1_entity *entity)
+static void wpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_rwpf *wpf = entity_to_rwpf(entity);
 
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_Y, wpf->mem.addr[0]);
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C0, wpf->mem.addr[1]);
-	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, wpf->mem.addr[0]);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, wpf->mem.addr[1]);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
 }
 
-static void wpf_configure(struct vsp1_entity *entity)
+static void wpf_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
@@ -103,10 +103,10 @@ static void wpf_configure(struct vsp1_entity *entity)
 	/* Cropping */
 	crop = vsp1_rwpf_get_crop(wpf, wpf->entity.config);
 
-	vsp1_wpf_write(wpf, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
+	vsp1_wpf_write(wpf, dl, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 		       (crop->left << VI6_WPF_SZCLIP_OFST_SHIFT) |
 		       (crop->width << VI6_WPF_SZCLIP_SIZE_SHIFT));
-	vsp1_wpf_write(wpf, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
+	vsp1_wpf_write(wpf, dl, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
 		       (crop->top << VI6_WPF_SZCLIP_OFST_SHIFT) |
 		       (crop->height << VI6_WPF_SZCLIP_SIZE_SHIFT));
 
@@ -132,25 +132,25 @@ static void wpf_configure(struct vsp1_entity *entity)
 			outfmt |= VI6_WPF_OUTFMT_SPUVS;
 
 		/* Destination stride and byte swapping. */
-		vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_Y,
+		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_STRIDE_Y,
 			       format->plane_fmt[0].bytesperline);
 		if (format->num_planes > 1)
-			vsp1_wpf_write(wpf, VI6_WPF_DSTM_STRIDE_C,
+			vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_STRIDE_C,
 				       format->plane_fmt[1].bytesperline);
 
-		vsp1_wpf_write(wpf, VI6_WPF_DSWAP, fmtinfo->swap);
+		vsp1_wpf_write(wpf, dl, VI6_WPF_DSWAP, fmtinfo->swap);
 	}
 
 	if (sink_format->code != source_format->code)
 		outfmt |= VI6_WPF_OUTFMT_CSC;
 
 	outfmt |= wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT;
-	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
 
-	vsp1_mod_write(&wpf->entity, VI6_DPR_WPF_FPORCH(wpf->entity.index),
-		       VI6_DPR_WPF_FPORCH_FP_WPFN);
+	vsp1_dl_list_write(dl, VI6_DPR_WPF_FPORCH(wpf->entity.index),
+			   VI6_DPR_WPF_FPORCH_FP_WPFN);
 
-	vsp1_mod_write(&wpf->entity, VI6_WPF_WRBCK_CTRL, 0);
+	vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, 0);
 
 	/* Sources. If the pipeline has a single input and BRU is not used,
 	 * configure it as the master layer. Otherwise configure all
@@ -171,12 +171,12 @@ static void wpf_configure(struct vsp1_entity *entity)
 	if (pipe->bru || pipe->num_inputs > 1)
 		srcrpf |= VI6_WPF_SRCRPF_VIRACT_MST;
 
-	vsp1_wpf_write(wpf, VI6_WPF_SRCRPF, srcrpf);
+	vsp1_wpf_write(wpf, dl, VI6_WPF_SRCRPF, srcrpf);
 
 	/* Enable interrupts */
-	vsp1_mod_write(&wpf->entity, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
-	vsp1_mod_write(&wpf->entity, VI6_WPF_IRQ_ENB(wpf->entity.index),
-		       VI6_WFP_IRQ_ENB_FREE);
+	vsp1_dl_list_write(dl, VI6_WPF_IRQ_STA(wpf->entity.index), 0);
+	vsp1_dl_list_write(dl, VI6_WPF_IRQ_ENB(wpf->entity.index),
+			   VI6_WFP_IRQ_ENB_FREE);
 }
 
 static const struct vsp1_entity_operations wpf_entity_ops = {
-- 
2.7.3


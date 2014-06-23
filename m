Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaFWXyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:15 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 23/23] v4l: vsp1: uds: Fix scaling of alpha layer
Date: Tue, 24 Jun 2014 01:54:29 +0200
Message-Id: <1403567669-18539-24-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pixel color components can be scaled using either bilinear interpolation
or a multitap filter. The multitap filter provides better results, but
can't be selected when the alpha layer need to be scaled down by more
than 1/2.

Disable alpha scaling when the input has a fixed alpha value, and
program the UDS to output a fixed alpha value in that case. This ensures
the multitap filter will be used whenever possible.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c   |  4 ++
 drivers/media/platform/vsp1/vsp1_uds.c   | 65 +++++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_uds.h   |  6 +--
 drivers/media/platform/vsp1/vsp1_video.c | 78 ++++++++++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_video.h |  6 +++
 5 files changed, 124 insertions(+), 35 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 576779f..d14d26b 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -46,6 +46,7 @@ static int rpf_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vsp1_rwpf *rpf =
 		container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
+	struct vsp1_pipeline *pipe;
 
 	if (!vsp1_entity_is_streaming(&rpf->entity))
 		return 0;
@@ -54,6 +55,9 @@ static int rpf_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_ALPHA_COMPONENT:
 		vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
 			       ctrl->val << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
+
+		pipe = to_vsp1_pipeline(&rpf->entity.subdev.entity);
+		vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, ctrl->val);
 		break;
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 0293bdb..1622a6a 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -45,6 +45,11 @@ static inline void vsp1_uds_write(struct vsp1_uds *uds, u32 reg, u32 data)
  * Scaling Computation
  */
 
+void vsp1_uds_set_alpha(struct vsp1_uds *uds, unsigned int alpha)
+{
+	vsp1_uds_write(uds, VI6_UDS_ALPVAL, alpha << VI6_UDS_ALPVAL_VAL0_SHIFT);
+}
+
 /*
  * uds_output_size - Return the output size for an input size and scaling ratio
  * @input: input size in pixels
@@ -105,49 +110,58 @@ static unsigned int uds_compute_ratio(unsigned int input, unsigned int output)
 	return (input - 1) * 4096 / (output - 1);
 }
 
-static void uds_compute_ratios(struct vsp1_uds *uds)
-{
-	struct v4l2_mbus_framefmt *input = &uds->entity.formats[UDS_PAD_SINK];
-	struct v4l2_mbus_framefmt *output =
-		&uds->entity.formats[UDS_PAD_SOURCE];
-
-	uds->hscale = uds_compute_ratio(input->width, output->width);
-	uds->vscale = uds_compute_ratio(input->height, output->height);
-
-	dev_dbg(uds->entity.vsp1->dev, "hscale %u vscale %u\n",
-		uds->hscale, uds->vscale);
-}
-
 /* -----------------------------------------------------------------------------
  * V4L2 Subdevice Core Operations
  */
 
 static int uds_s_stream(struct v4l2_subdev *subdev, int enable)
 {
-	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_uds *uds = to_uds(subdev);
+	const struct v4l2_mbus_framefmt *output;
+	const struct v4l2_mbus_framefmt *input;
+	unsigned int hscale;
+	unsigned int vscale;
+	bool multitap;
 
 	if (!enable)
 		return 0;
 
-	/* Enable multi-tap scaling. */
-	vsp1_uds_write(uds, VI6_UDS_CTRL, VI6_UDS_CTRL_AON | VI6_UDS_CTRL_BC);
+	input = &uds->entity.formats[UDS_PAD_SINK];
+	output = &uds->entity.formats[UDS_PAD_SOURCE];
+
+	hscale = uds_compute_ratio(input->width, output->width);
+	vscale = uds_compute_ratio(input->height, output->height);
+
+	dev_dbg(uds->entity.vsp1->dev, "hscale %u vscale %u\n", hscale, vscale);
+
+	/* Multi-tap scaling can only be enabled along with alpha scaling if the
+	 * scaling factor is 2/1, 1/1 or 1/2.
+	 */
+	if (!uds->scale_alpha)
+		multitap = true;
+	else if ((hscale == 2048 && hscale == 4096 && hscale == 8192) &&
+		 (vscale == 2048 && vscale == 4096 && vscale == 8192))
+		multitap = true;
+	else
+		multitap = false;
+
+	vsp1_uds_write(uds, VI6_UDS_CTRL,
+		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
+		       (multitap ? VI6_UDS_CTRL_BC : 0));
 
 	vsp1_uds_write(uds, VI6_UDS_PASS_BWIDTH,
-		       (uds_passband_width(uds->hscale)
+		       (uds_passband_width(hscale)
 				<< VI6_UDS_PASS_BWIDTH_H_SHIFT) |
-		       (uds_passband_width(uds->vscale)
+		       (uds_passband_width(vscale)
 				<< VI6_UDS_PASS_BWIDTH_V_SHIFT));
 
 	/* Set the scaling ratios and the output size. */
-	format = &uds->entity.formats[UDS_PAD_SOURCE];
-
 	vsp1_uds_write(uds, VI6_UDS_SCALE,
-		       (uds->hscale << VI6_UDS_SCALE_HFRAC_SHIFT) |
-		       (uds->vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
+		       (hscale << VI6_UDS_SCALE_HFRAC_SHIFT) |
+		       (vscale << VI6_UDS_SCALE_VFRAC_SHIFT));
 	vsp1_uds_write(uds, VI6_UDS_CLIP_SIZE,
-		       (format->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
-		       (format->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+		       (output->width << VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
+		       (output->height << VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
 
 	return 0;
 }
@@ -280,9 +294,6 @@ static int uds_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 		uds_try_format(uds, fh, UDS_PAD_SOURCE, format, fmt->which);
 	}
 
-	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
-		uds_compute_ratios(uds);
-
 	return 0;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_uds.h b/drivers/media/platform/vsp1/vsp1_uds.h
index 479d12d..031ac0d 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.h
+++ b/drivers/media/platform/vsp1/vsp1_uds.h
@@ -25,9 +25,7 @@ struct vsp1_device;
 
 struct vsp1_uds {
 	struct vsp1_entity entity;
-
-	unsigned int hscale;
-	unsigned int vscale;
+	bool scale_alpha;
 };
 
 static inline struct vsp1_uds *to_uds(struct v4l2_subdev *subdev)
@@ -37,4 +35,6 @@ static inline struct vsp1_uds *to_uds(struct v4l2_subdev *subdev)
 
 struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index);
 
+void vsp1_uds_set_alpha(struct vsp1_uds *uds, unsigned int alpha);
+
 #endif /* __VSP1_UDS_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 58fc076..915a20e 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -31,6 +31,7 @@
 #include "vsp1_bru.h"
 #include "vsp1_entity.h"
 #include "vsp1_rwpf.h"
+#include "vsp1_uds.h"
 #include "vsp1_video.h"
 
 #define VSP1_VIDEO_DEF_FORMAT		V4L2_PIX_FMT_YUYV
@@ -306,13 +307,14 @@ vsp1_video_format_adjust(struct vsp1_video *video,
  * Pipeline Management
  */
 
-static int vsp1_pipeline_validate_branch(struct vsp1_rwpf *input,
+static int vsp1_pipeline_validate_branch(struct vsp1_pipeline *pipe,
+					 struct vsp1_rwpf *input,
 					 struct vsp1_rwpf *output)
 {
 	struct vsp1_entity *entity;
 	unsigned int entities = 0;
 	struct media_pad *pad;
-	bool uds_found = false;
+	bool bru_found = false;
 
 	input->location.left = 0;
 	input->location.top = 0;
@@ -341,6 +343,8 @@ static int vsp1_pipeline_validate_branch(struct vsp1_rwpf *input,
 
 			input->location.left = rect->left;
 			input->location.top = rect->top;
+
+			bru_found = true;
 		}
 
 		/* We've reached the WPF, we're done. */
@@ -355,9 +359,12 @@ static int vsp1_pipeline_validate_branch(struct vsp1_rwpf *input,
 
 		/* UDS can't be chained. */
 		if (entity->type == VSP1_ENTITY_UDS) {
-			if (uds_found)
+			if (pipe->uds)
 				return -EPIPE;
-			uds_found = true;
+
+			pipe->uds = entity;
+			pipe->uds_input = bru_found ? pipe->bru
+					: &input->entity;
 		}
 
 		/* Follow the source link. The link setup operations ensure
@@ -394,6 +401,7 @@ static void __vsp1_pipeline_cleanup(struct vsp1_pipeline *pipe)
 	pipe->output = NULL;
 	pipe->bru = NULL;
 	pipe->lif = NULL;
+	pipe->uds = NULL;
 }
 
 static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
@@ -451,7 +459,7 @@ static int vsp1_pipeline_validate(struct vsp1_pipeline *pipe,
 	 * contains no loop and that all branches end at the output WPF.
 	 */
 	for (i = 0; i < pipe->num_inputs; ++i) {
-		ret = vsp1_pipeline_validate_branch(pipe->inputs[i],
+		ret = vsp1_pipeline_validate_branch(pipe, pipe->inputs[i],
 						    pipe->output);
 		if (ret < 0)
 			goto error;
@@ -654,6 +662,47 @@ done:
 	spin_unlock_irqrestore(&pipe->irqlock, flags);
 }
 
+/*
+ * Propagate the alpha value through the pipeline.
+ *
+ * As the UDS has restricted scaling capabilities when the alpha component needs
+ * to be scaled, we disable alpha scaling when the UDS input has a fixed alpha
+ * value. The UDS then outputs a fixed alpha value which needs to be programmed
+ * from the input RPF alpha.
+ */
+void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
+				   struct vsp1_entity *input,
+				   unsigned int alpha)
+{
+	struct vsp1_entity *entity;
+	struct media_pad *pad;
+
+	pad = media_entity_remote_pad(&input->pads[RWPF_PAD_SOURCE]);
+
+	while (pad) {
+		if (media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
+			break;
+
+		entity = to_vsp1_entity(media_entity_to_v4l2_subdev(pad->entity));
+
+		/* The BRU background color has a fixed alpha value set to 255,
+		 * the output alpha value is thus always equal to 255.
+		 */
+		if (entity->type == VSP1_ENTITY_BRU)
+			alpha = 255;
+
+		if (entity->type == VSP1_ENTITY_UDS) {
+			struct vsp1_uds *uds = to_uds(&entity->subdev);
+
+			vsp1_uds_set_alpha(uds, alpha);
+			break;
+		}
+
+		pad = &entity->pads[entity->source_pad];
+		pad = media_entity_remote_pad(pad);
+	}
+}
+
 /* -----------------------------------------------------------------------------
  * videobuf2 Queue Operations
  */
@@ -761,6 +810,25 @@ static int vsp1_video_start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	mutex_lock(&pipe->lock);
 	if (pipe->stream_count == pipe->num_video - 1) {
+		if (pipe->uds) {
+			struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
+
+			/* If a BRU is present in the pipeline before the UDS,
+			 * the alpha component doesn't need to be scaled as the
+			 * BRU output alpha value is fixed to 255. Otherwise we
+			 * need to scale the alpha component only when available
+			 * at the input RPF.
+			 */
+			if (pipe->uds_input->type == VSP1_ENTITY_BRU) {
+				uds->scale_alpha = false;
+			} else {
+				struct vsp1_rwpf *rpf =
+					to_rwpf(&pipe->uds_input->subdev);
+
+				uds->scale_alpha = rpf->video.fmtinfo->alpha;
+			}
+		}
+
 		list_for_each_entry(entity, &pipe->entities, list_pipe) {
 			vsp1_entity_route_setup(entity);
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.h b/drivers/media/platform/vsp1/vsp1_video.h
index 4dad110..fd2851a 100644
--- a/drivers/media/platform/vsp1/vsp1_video.h
+++ b/drivers/media/platform/vsp1/vsp1_video.h
@@ -79,6 +79,8 @@ struct vsp1_pipeline {
 	struct vsp1_rwpf *output;
 	struct vsp1_entity *bru;
 	struct vsp1_entity *lif;
+	struct vsp1_entity *uds;
+	struct vsp1_entity *uds_input;
 
 	struct list_head entities;
 };
@@ -143,4 +145,8 @@ void vsp1_video_cleanup(struct vsp1_video *video);
 
 void vsp1_pipeline_frame_end(struct vsp1_pipeline *pipe);
 
+void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
+				   struct vsp1_entity *input,
+				   unsigned int alpha);
+
 #endif /* __VSP1_VIDEO_H__ */
-- 
1.8.5.5


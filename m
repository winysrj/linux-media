Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40281 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbcCXX2H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:07 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 15/51] v4l: vsp1: rwpf: Don't program alpha value in control set handler
Date: Fri, 25 Mar 2016 01:27:11 +0200
Message-Id: <1458862067-19525-16-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The datasheet clearly states that all but a few registers can't be
modified when the device is running. Programming the alpha value in
the control set handler is thus prohibited. Program it when starting the
module instead.

This requires storing the alpha value internally as the module can be
started from the frame completion interrupt handler, and accessing
control values requires taking a mutex.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c  | 51 +++---------------------------
 drivers/media/platform/vsp1/vsp1_rwpf.c | 35 +++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_rwpf.h |  5 ++-
 drivers/media/platform/vsp1/vsp1_wpf.c  | 55 ++-------------------------------
 4 files changed, 47 insertions(+), 99 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 7853e0f1d526..8721c82801ca 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -33,36 +33,6 @@ static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
- * Controls
- */
-
-static int rpf_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct vsp1_rwpf *rpf =
-		container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
-	struct vsp1_pipeline *pipe;
-
-	if (!vsp1_entity_is_streaming(&rpf->entity))
-		return 0;
-
-	switch (ctrl->id) {
-	case V4L2_CID_ALPHA_COMPONENT:
-		vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
-			       ctrl->val << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
-
-		pipe = to_vsp1_pipeline(&rpf->entity.subdev.entity);
-		vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, ctrl->val);
-		break;
-	}
-
-	return 0;
-}
-
-static const struct v4l2_ctrl_ops rpf_ctrl_ops = {
-	.s_ctrl = rpf_s_ctrl,
-};
-
-/* -----------------------------------------------------------------------------
  * V4L2 Subdevice Core Operations
  */
 
@@ -70,7 +40,6 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&subdev->entity);
 	struct vsp1_rwpf *rpf = to_rwpf(subdev);
-	struct vsp1_device *vsp1 = rpf->entity.vsp1;
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
 	const struct v4l2_rect *crop = &rpf->crop;
@@ -151,13 +120,10 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
 				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
 
-	if (vsp1->info->uapi)
-		mutex_lock(rpf->ctrls.lock);
 	vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
-		       rpf->alpha->cur.val << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
-	vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, rpf->alpha->cur.val);
-	if (vsp1->info->uapi)
-		mutex_unlock(rpf->ctrls.lock);
+		       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
+
+	vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, rpf->alpha);
 
 	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
 	vsp1_rpf_write(rpf, VI6_RPF_CKEY_CTRL, 0);
@@ -257,17 +223,10 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	vsp1_entity_init_formats(subdev, NULL);
 
 	/* Initialize the control handler. */
-	v4l2_ctrl_handler_init(&rpf->ctrls, 1);
-	rpf->alpha = v4l2_ctrl_new_std(&rpf->ctrls, &rpf_ctrl_ops,
-				       V4L2_CID_ALPHA_COMPONENT,
-				       0, 255, 1, 255);
-
-	rpf->entity.subdev.ctrl_handler = &rpf->ctrls;
-
-	if (rpf->ctrls.error) {
+	ret = vsp1_rwpf_init_ctrls(rpf);
+	if (ret < 0) {
 		dev_err(vsp1->dev, "rpf%u: failed to initialize controls\n",
 			index);
-		ret = rpf->ctrls.error;
 		goto error;
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 9688c219b30e..ba50386db35c 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -230,3 +230,38 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 
 	return 0;
 }
+
+/* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+static int vsp1_rwpf_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_rwpf *rwpf =
+		container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
+
+	switch (ctrl->id) {
+	case V4L2_CID_ALPHA_COMPONENT:
+		rwpf->alpha = ctrl->val;
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops vsp1_rwpf_ctrl_ops = {
+	.s_ctrl = vsp1_rwpf_s_ctrl,
+};
+
+int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf)
+{
+	rwpf->alpha = 255;
+
+	v4l2_ctrl_handler_init(&rwpf->ctrls, 1);
+	v4l2_ctrl_new_std(&rwpf->ctrls, &vsp1_rwpf_ctrl_ops,
+			  V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 255);
+
+	rwpf->entity.subdev.ctrl_handler = &rwpf->ctrls;
+
+	return rwpf->ctrls.error;
+}
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index d04df39b2737..66af2a06dd8b 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -42,7 +42,6 @@ struct vsp1_rwpf_operations {
 struct vsp1_rwpf {
 	struct vsp1_entity entity;
 	struct v4l2_ctrl_handler ctrls;
-	struct v4l2_ctrl *alpha;
 
 	struct vsp1_video *video;
 
@@ -59,6 +58,8 @@ struct vsp1_rwpf {
 	} location;
 	struct v4l2_rect crop;
 
+	unsigned int alpha;
+
 	unsigned int offsets[2];
 	dma_addr_t buf_addr[3];
 
@@ -73,6 +74,8 @@ static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
 struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index);
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
 
+int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf);
+
 int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_mbus_code_enum *code);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 3640989b3fd5..1ca08f4d67c2 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -27,12 +27,6 @@
  * Device Access
  */
 
-static inline u32 vsp1_wpf_read(struct vsp1_rwpf *wpf, u32 reg)
-{
-	return vsp1_read(wpf->entity.vsp1,
-			 reg + wpf->entity.index * VI6_WPF_OFFSET);
-}
-
 static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, u32 reg, u32 data)
 {
 	vsp1_mod_write(&wpf->entity,
@@ -40,35 +34,6 @@ static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
- * Controls
- */
-
-static int wpf_s_ctrl(struct v4l2_ctrl *ctrl)
-{
-	struct vsp1_rwpf *wpf =
-		container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
-	u32 value;
-
-	if (!vsp1_entity_is_streaming(&wpf->entity))
-		return 0;
-
-	switch (ctrl->id) {
-	case V4L2_CID_ALPHA_COMPONENT:
-		value = vsp1_wpf_read(wpf, VI6_WPF_OUTFMT);
-		value &= ~VI6_WPF_OUTFMT_PDV_MASK;
-		value |= ctrl->val << VI6_WPF_OUTFMT_PDV_SHIFT;
-		vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, value);
-		break;
-	}
-
-	return 0;
-}
-
-static const struct v4l2_ctrl_ops wpf_ctrl_ops = {
-	.s_ctrl = wpf_s_ctrl,
-};
-
-/* -----------------------------------------------------------------------------
  * V4L2 Subdevice Core Operations
  */
 
@@ -153,15 +118,8 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	    wpf->entity.formats[RWPF_PAD_SOURCE].code)
 		outfmt |= VI6_WPF_OUTFMT_CSC;
 
-	/* Take the control handler lock to ensure that the PDV value won't be
-	 * changed behind our back by a set control operation.
-	 */
-	if (vsp1->info->uapi)
-		mutex_lock(wpf->ctrls.lock);
-	outfmt |= wpf->alpha->cur.val << VI6_WPF_OUTFMT_PDV_SHIFT;
+	outfmt |= wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT;
 	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
-	if (vsp1->info->uapi)
-		mutex_unlock(wpf->ctrls.lock);
 
 	vsp1_mod_write(&wpf->entity, VI6_DPR_WPF_FPORCH(wpf->entity.index),
 		       VI6_DPR_WPF_FPORCH_FP_WPFN);
@@ -274,17 +232,10 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	vsp1_entity_init_formats(subdev, NULL);
 
 	/* Initialize the control handler. */
-	v4l2_ctrl_handler_init(&wpf->ctrls, 1);
-	wpf->alpha = v4l2_ctrl_new_std(&wpf->ctrls, &wpf_ctrl_ops,
-				       V4L2_CID_ALPHA_COMPONENT,
-				       0, 255, 1, 255);
-
-	wpf->entity.subdev.ctrl_handler = &wpf->ctrls;
-
-	if (wpf->ctrls.error) {
+	ret = vsp1_rwpf_init_ctrls(wpf);
+	if (ret < 0) {
 		dev_err(vsp1->dev, "wpf%u: failed to initialize controls\n",
 			index);
-		ret = wpf->ctrls.error;
 		goto error;
 	}
 
-- 
2.7.3


Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59654 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbaFADja (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 May 2014 23:39:30 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 15/18] v4l: vsp1: Add V4L2_CID_ALPHA_COMPONENT control support
Date: Sun,  1 Jun 2014 05:39:34 +0200
Message-Id: <1401593977-30660-16-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1401593977-30660-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The control is used to configure the fixed alpha channel value, when
reading from memory in the RPF or writing to memory in the WPF.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c  | 52 ++++++++++++++++++++++++++++---
 drivers/media/platform/vsp1/vsp1_rwpf.h |  2 ++
 drivers/media/platform/vsp1/vsp1_wpf.c  | 54 +++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 2824f53..576779f 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -39,6 +39,32 @@ static inline void vsp1_rpf_write(struct vsp1_rwpf *rpf, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+static int rpf_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_rwpf *rpf =
+		container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
+
+	if (!vsp1_entity_is_streaming(&rpf->entity))
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ALPHA_COMPONENT:
+		vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
+			       ctrl->val << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops rpf_ctrl_ops = {
+	.s_ctrl = rpf_s_ctrl,
+};
+
+/* -----------------------------------------------------------------------------
  * V4L2 Subdevice Core Operations
  */
 
@@ -50,6 +76,11 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	const struct v4l2_rect *crop = &rpf->crop;
 	u32 pstride;
 	u32 infmt;
+	int ret;
+
+	ret = vsp1_entity_set_streaming(&rpf->entity, enable);
+	if (ret < 0)
+		return ret;
 
 	if (!enable)
 		return 0;
@@ -101,14 +132,13 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 		       (rpf->location.left << VI6_RPF_LOC_HCOORD_SHIFT) |
 		       (rpf->location.top << VI6_RPF_LOC_VCOORD_SHIFT));
 
-	/* Use the alpha channel (extended to 8 bits) when available or a
-	 * hardcoded 255 value otherwise. Disable color keying.
+	/* Use the alpha channel (extended to 8 bits) when available or an
+	 * alpha value set through the V4L2_CID_ALPHA_COMPONENT control
+	 * otherwise. Disable color keying.
 	 */
 	vsp1_rpf_write(rpf, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
 				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
-	vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
-		       255 << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
 	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
 	vsp1_rpf_write(rpf, VI6_RPF_CKEY_CTRL, 0);
 
@@ -198,6 +228,20 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	vsp1_entity_init_formats(subdev, NULL);
 
+	/* Initialize the control handler. */
+	v4l2_ctrl_handler_init(&rpf->ctrls, 1);
+	v4l2_ctrl_new_std(&rpf->ctrls, &rpf_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
+			  0, 255, 1, 255);
+
+	rpf->entity.subdev.ctrl_handler = &rpf->ctrls;
+
+	if (rpf->ctrls.error) {
+		dev_err(vsp1->dev, "rpf%u: failed to initialize controls\n",
+			index);
+		ret = rpf->ctrls.error;
+		goto error;
+	}
+
 	/* Initialize the video device. */
 	video = &rpf->video;
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index b4fb65e..28dd9e7 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -14,6 +14,7 @@
 #define __VSP1_RWPF_H__
 
 #include <media/media-entity.h>
+#include <media/v4l2-ctrls.h>
 #include <media/v4l2-subdev.h>
 
 #include "vsp1.h"
@@ -26,6 +27,7 @@
 struct vsp1_rwpf {
 	struct vsp1_entity entity;
 	struct vsp1_video video;
+	struct v4l2_ctrl_handler ctrls;
 
 	unsigned int max_width;
 	unsigned int max_height;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index a2ba107..6e05776 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -39,6 +39,35 @@ static inline void vsp1_wpf_write(struct vsp1_rwpf *wpf, u32 reg, u32 data)
 }
 
 /* -----------------------------------------------------------------------------
+ * Controls
+ */
+
+static int wpf_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vsp1_rwpf *wpf =
+		container_of(ctrl->handler, struct vsp1_rwpf, ctrls);
+	u32 value;
+
+	if (!vsp1_entity_is_streaming(&wpf->entity))
+		return 0;
+
+	switch (ctrl->id) {
+	case V4L2_CID_ALPHA_COMPONENT:
+		value = vsp1_wpf_read(wpf, VI6_WPF_OUTFMT);
+		value &= ~VI6_WPF_OUTFMT_PDV_MASK;
+		value |= ctrl->val << VI6_WPF_OUTFMT_PDV_SHIFT;
+		vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, value);
+		break;
+	}
+
+	return 0;
+}
+
+static const struct v4l2_ctrl_ops wpf_ctrl_ops = {
+	.s_ctrl = wpf_s_ctrl,
+};
+
+/* -----------------------------------------------------------------------------
  * V4L2 Subdevice Core Operations
  */
 
@@ -51,6 +80,11 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	unsigned int i;
 	u32 srcrpf = 0;
 	u32 outfmt = 0;
+	int ret;
+
+	ret = vsp1_entity_set_streaming(&wpf->entity, enable);
+	if (ret < 0)
+		return ret;
 
 	if (!enable) {
 		vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
@@ -113,7 +147,13 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	    wpf->entity.formats[RWPF_PAD_SOURCE].code)
 		outfmt |= VI6_WPF_OUTFMT_CSC;
 
+	/* Take the control handler lock to ensure that the PDV value won't be
+	 * changed behind our back by a set control operation.
+	 */
+	mutex_lock(wpf->ctrls.lock);
+	outfmt |= vsp1_wpf_read(wpf, VI6_WPF_OUTFMT) & VI6_WPF_OUTFMT_PDV_MASK;
 	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
+	mutex_unlock(wpf->ctrls.lock);
 
 	vsp1_write(vsp1, VI6_DPR_WPF_FPORCH(wpf->entity.index),
 		   VI6_DPR_WPF_FPORCH_FP_WPFN);
@@ -209,6 +249,20 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	vsp1_entity_init_formats(subdev, NULL);
 
+	/* Initialize the control handler. */
+	v4l2_ctrl_handler_init(&wpf->ctrls, 1);
+	v4l2_ctrl_new_std(&wpf->ctrls, &wpf_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
+			  0, 255, 1, 255);
+
+	wpf->entity.subdev.ctrl_handler = &wpf->ctrls;
+
+	if (wpf->ctrls.error) {
+		dev_err(vsp1->dev, "wpf%u: failed to initialize controls\n",
+			index);
+		ret = wpf->ctrls.error;
+		goto error;
+	}
+
 	/* Initialize the video device. */
 	video = &wpf->video;
 
-- 
1.8.5.5


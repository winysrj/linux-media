Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52348 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbbIMU53 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 16:57:29 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 26/32] v4l: vsp1: Set the alpha value manually in RPF and WPF s_stream handlers
Date: Sun, 13 Sep 2015 23:57:04 +0300
Message-Id: <1442177830-24536-27-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1442177830-24536-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RPF and WPF alpha values are set through V4L2 controls and applied
when starting the video stream by a call to v4l2_ctrl_handler_setup().
As that function uses the control handler mutex it can't be called in
interrupt context, where the VSP+DU pipeline handler might need to
reconfigure the pipeline.

Set the alpha value manually in the RPF and WPF s_stream handler to
ensure that the hardware is properly configured even when controlled
without the userspace API. If the userspace API is enabled protect that
with the control lock to avoid race conditions with userspace.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c  | 16 ++++++++++++++--
 drivers/media/platform/vsp1/vsp1_rwpf.h |  2 ++
 drivers/media/platform/vsp1/vsp1_wpf.c  |  7 ++++---
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index b9c39f9e4458..7ccec87b1139 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -68,7 +68,9 @@ static const struct v4l2_ctrl_ops rpf_ctrl_ops = {
 
 static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 {
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&subdev->entity);
 	struct vsp1_rwpf *rpf = to_rwpf(subdev);
+	struct vsp1_device *vsp1 = rpf->entity.vsp1;
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
 	const struct v4l2_rect *crop = &rpf->crop;
@@ -148,6 +150,15 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	vsp1_rpf_write(rpf, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
 				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
+
+	if (vsp1->info->uapi)
+		mutex_lock(rpf->ctrls.lock);
+	vsp1_rpf_write(rpf, VI6_RPF_VRTCOL_SET,
+		       rpf->alpha->cur.val << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
+	vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, rpf->alpha->cur.val);
+	if (vsp1->info->uapi)
+		mutex_unlock(rpf->ctrls.lock);
+
 	vsp1_rpf_write(rpf, VI6_RPF_MSK_CTRL, 0);
 	vsp1_rpf_write(rpf, VI6_RPF_CKEY_CTRL, 0);
 
@@ -245,8 +256,9 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&rpf->ctrls, 1);
-	v4l2_ctrl_new_std(&rpf->ctrls, &rpf_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
-			  0, 255, 1, 255);
+	rpf->alpha = v4l2_ctrl_new_std(&rpf->ctrls, &rpf_ctrl_ops,
+				       V4L2_CID_ALPHA_COMPONENT,
+				       0, 255, 1, 255);
 
 	rpf->entity.subdev.ctrl_handler = &rpf->ctrls;
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 1a90c7c8e972..8e8235682ada 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -23,6 +23,7 @@
 #define RWPF_PAD_SINK				0
 #define RWPF_PAD_SOURCE				1
 
+struct v4l2_ctrl;
 struct vsp1_rwpf;
 struct vsp1_video;
 
@@ -40,6 +41,7 @@ struct vsp1_rwpf_operations {
 struct vsp1_rwpf {
 	struct vsp1_entity entity;
 	struct v4l2_ctrl_handler ctrls;
+	struct v4l2_ctrl *alpha;
 
 	struct vsp1_video *video;
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 5996a35143b8..6212fc714a7c 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -156,7 +156,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	 */
 	if (vsp1->info->uapi)
 		mutex_lock(wpf->ctrls.lock);
-	outfmt |= vsp1_wpf_read(wpf, VI6_WPF_OUTFMT) & VI6_WPF_OUTFMT_PDV_MASK;
+	outfmt |= wpf->alpha->cur.val << VI6_WPF_OUTFMT_PDV_SHIFT;
 	vsp1_wpf_write(wpf, VI6_WPF_OUTFMT, outfmt);
 	if (vsp1->info->uapi)
 		mutex_unlock(wpf->ctrls.lock);
@@ -254,8 +254,9 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&wpf->ctrls, 1);
-	v4l2_ctrl_new_std(&wpf->ctrls, &wpf_ctrl_ops, V4L2_CID_ALPHA_COMPONENT,
-			  0, 255, 1, 255);
+	wpf->alpha = v4l2_ctrl_new_std(&wpf->ctrls, &wpf_ctrl_ops,
+				       V4L2_CID_ALPHA_COMPONENT,
+				       0, 255, 1, 255);
 
 	wpf->entity.subdev.ctrl_handler = &wpf->ctrls;
 
-- 
2.4.6


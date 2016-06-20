Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52953 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159AbcFTTNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:13:53 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 21/24] v4l: vsp1: rwpf: Support runtime modification of controls
Date: Mon, 20 Jun 2016 22:10:39 +0300
Message-Id: <1466449842-29502-22-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow reconfiguration of the alpha value at runtime.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c  | 21 ++++++++++++---------
 drivers/media/platform/vsp1/vsp1_rwpf.c |  2 --
 drivers/media/platform/vsp1/vsp1_rwpf.h |  3 +++
 drivers/media/platform/vsp1/vsp1_wpf.c  | 10 +++++++---
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 2a734b131110..39b0580878ce 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -73,8 +73,15 @@ static void rpf_configure(struct vsp1_entity *entity,
 	u32 pstride;
 	u32 infmt;
 
-	if (!full)
+	if (!full) {
+		vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
+			       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
+		vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, rpf->mult_alpha |
+			       (rpf->alpha << VI6_RPF_MULT_ALPHA_RATIO_SHIFT));
+
+		vsp1_pipeline_propagate_alpha(pipe, dl, rpf->alpha);
 		return;
+	}
 
 	/* Source size, stride and crop offsets.
 	 *
@@ -171,9 +178,6 @@ static void rpf_configure(struct vsp1_entity *entity,
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
 				       : VI6_RPF_ALPH_SEL_ASEL_FIXED));
 
-	vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
-		       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
-
 	if (entity->vsp1->info->gen == 3) {
 		u32 mult;
 
@@ -191,8 +195,7 @@ static void rpf_configure(struct vsp1_entity *entity,
 			mult = VI6_RPF_MULT_ALPHA_A_MMD_RATIO
 			     | (premultiplied ?
 				VI6_RPF_MULT_ALPHA_P_MMD_RATIO :
-				VI6_RPF_MULT_ALPHA_P_MMD_NONE)
-			     | (rpf->alpha << VI6_RPF_MULT_ALPHA_RATIO_SHIFT);
+				VI6_RPF_MULT_ALPHA_P_MMD_NONE);
 		} else {
 			/* When the input doesn't contain an alpha channel the
 			 * global alpha value is applied in the unpacking unit,
@@ -203,11 +206,9 @@ static void rpf_configure(struct vsp1_entity *entity,
 			     | VI6_RPF_MULT_ALPHA_P_MMD_NONE;
 		}
 
-		vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, mult);
+		rpf->mult_alpha = mult;
 	}
 
-	vsp1_pipeline_propagate_alpha(pipe, dl, rpf->alpha);
-
 	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
 	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
 
@@ -253,6 +254,8 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 		goto error;
 	}
 
+	v4l2_ctrl_handler_setup(&rpf->ctrls);
+
 	return rpf;
 
 error:
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 3b6e032e7806..cd3562d1d9cf 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -243,8 +243,6 @@ static const struct v4l2_ctrl_ops vsp1_rwpf_ctrl_ops = {
 
 int vsp1_rwpf_init_ctrls(struct vsp1_rwpf *rwpf)
 {
-	rwpf->alpha = 255;
-
 	v4l2_ctrl_handler_init(&rwpf->ctrls, 1);
 	v4l2_ctrl_new_std(&rwpf->ctrls, &vsp1_rwpf_ctrl_ops,
 			  V4L2_CID_ALPHA_COMPONENT, 0, 255, 1, 255);
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 9ff7c78f239e..801cacc12e07 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -49,6 +49,9 @@ struct vsp1_rwpf {
 
 	unsigned int alpha;
 
+	u32 mult_alpha;
+	u32 outfmt;
+
 	unsigned int offsets[2];
 	struct vsp1_rwpf_memory mem;
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index af22d8043a70..dab902c2e676 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -104,8 +104,11 @@ static void wpf_configure(struct vsp1_entity *entity,
 	u32 outfmt = 0;
 	u32 srcrpf = 0;
 
-	if (!full)
+	if (!full) {
+		vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, wpf->outfmt |
+			       (wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT));
 		return;
+	}
 
 	/* Cropping */
 	crop = vsp1_rwpf_get_crop(wpf, wpf->entity.config);
@@ -151,8 +154,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 	if (sink_format->code != source_format->code)
 		outfmt |= VI6_WPF_OUTFMT_CSC;
 
-	outfmt |= wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT;
-	vsp1_wpf_write(wpf, dl, VI6_WPF_OUTFMT, outfmt);
+	wpf->outfmt = outfmt;
 
 	vsp1_dl_list_write(dl, VI6_DPR_WPF_FPORCH(wpf->entity.index),
 			   VI6_DPR_WPF_FPORCH_FP_WPFN);
@@ -239,6 +241,8 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 		goto error;
 	}
 
+	v4l2_ctrl_handler_setup(&wpf->ctrls);
+
 	return wpf;
 
 error:
-- 
Regards,

Laurent Pinchart


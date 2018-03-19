Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34533 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932708AbeCSO3f (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Mar 2018 10:29:35 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, smitha.t@samsung.com, a.hajda@samsung.com,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-mfc: Ensure HEVC QP controls range is properly updated
Date: Mon, 19 Mar 2018 15:29:16 +0100
Message-id: <20180319142916.21489-1-s.nawrocki@samsung.com>
References: <CGME20180319142931epcas2p38fdca1ec6e4a5e5dd654d3ca3ed3577e@epcas2p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When value of V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP or V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP
controls is changed we should update range of a set of HEVC quantization
parameter v4l2 controls as specified in the HEVC controls documentation.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c | 40 ++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 6c80ebc5dbcc..810dabe2f1b9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1773,6 +1773,42 @@ static inline int vui_sar_idc(enum v4l2_mpeg_video_h264_vui_sar_idc sar)
 	return t[sar];
 }
 
+/*
+ * Update range of all HEVC quantization parameter controls that depend on the
+ * V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP, V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP controls.
+ */
+static void __enc_update_hevc_qp_ctrls_range(struct s5p_mfc_ctx *ctx,
+					     int min, int max)
+{
+	static const int __hevc_qp_ctrls[] = {
+		V4L2_CID_MPEG_VIDEO_HEVC_I_FRAME_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_P_FRAME_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_B_FRAME_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L0_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L1_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L2_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L3_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L4_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L5_QP,
+		V4L2_CID_MPEG_VIDEO_HEVC_HIER_CODING_L6_QP,
+	};
+	struct v4l2_ctrl *ctrl = NULL;
+	int i, j;
+
+	for (i = 0; i < ARRAY_SIZE(__hevc_qp_ctrls); i++) {
+		for (j = 0; j < ARRAY_SIZE(ctx->ctrls); j++) {
+			if (ctx->ctrls[j]->id == __hevc_qp_ctrls[i]) {
+				ctrl = ctx->ctrls[j];
+				break;
+			}
+		}
+		if (WARN_ON(!ctrl))
+			break;
+
+		__v4l2_ctrl_modify_range(ctrl, min, max, ctrl->step, min);
+	}
+}
+
 static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct s5p_mfc_ctx *ctx = ctrl_to_ctx(ctrl);
@@ -2038,9 +2074,13 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	case V4L2_CID_MPEG_VIDEO_HEVC_MIN_QP:
 		p->codec.hevc.rc_min_qp = ctrl->val;
+		__enc_update_hevc_qp_ctrls_range(ctx, ctrl->val,
+						 p->codec.hevc.rc_max_qp);
 		break;
 	case V4L2_CID_MPEG_VIDEO_HEVC_MAX_QP:
 		p->codec.hevc.rc_max_qp = ctrl->val;
+		__enc_update_hevc_qp_ctrls_range(ctx, p->codec.hevc.rc_min_qp,
+						 ctrl->val);
 		break;
 	case V4L2_CID_MPEG_VIDEO_HEVC_LEVEL:
 		p->codec.hevc.level_v4l2 = ctrl->val;
-- 
2.14.2

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:43602 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbaBDJ6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Feb 2014 04:58:08 -0500
From: Amit Grover <amit.grover@samsung.com>
To: linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kyungmin.park@samsung.com, k.debski@samsung.com,
	prabhakar.csengg@gmail.com, s.nawrocki@samsung.com,
	hans.verkuil@cisco.com, hverkuil@xs4all.nl, swaminath.p@samsung.com
Cc: jtp.park@samsung.com, Rrob@landley.net, andrew.smirnov@gmail.com,
	anatol.pomozov@gmail.com, jmccrohan@gmail.com, joe@perches.com,
	awalls@md.metrocast.net, arun.kk@samsung.com,
	amit.grover@samsung.com, austin.lobo@samsung.com
Subject: [PATCH 2/2] [media] s5p-mfc: Add Horizontal and Vertical MV Search
 Range
Date: Tue, 04 Feb 2014 15:29:59 +0530
Message-id: <1391507999-31437-3-git-send-email-amit.grover@samsung.com>
In-reply-to: <1391507999-31437-1-git-send-email-amit.grover@samsung.com>
References: <52E0ED10.2020901@samsung.com>
 <1391507999-31437-1-git-send-email-amit.grover@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds Controls to set Horizontal and Vertical search range
for Motion Estimation block for Samsung MFC video Encoders.

Signed-off-by: Swami Nathan <swaminath.p@samsung.com>
Signed-off-by: Amit Grover <amit.grover@samsung.com>
---
 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |    1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    |   24 +++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    8 ++------
 4 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
index 2398cdf..8d0b686 100644
--- a/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
+++ b/drivers/media/platform/s5p-mfc/regs-mfc-v6.h
@@ -229,6 +229,7 @@
 #define S5P_FIMV_E_PADDING_CTRL_V6		0xf7a4
 #define S5P_FIMV_E_MV_HOR_RANGE_V6		0xf7ac
 #define S5P_FIMV_E_MV_VER_RANGE_V6		0xf7b0
+#define S5P_FIMV_E_MV_RANGE_V6_MASK		0x3fff
 
 #define S5P_FIMV_E_VBV_BUFFER_SIZE_V6		0xf84c
 #define S5P_FIMV_E_VBV_INIT_DELAY_V6		0xf850
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index f723f1f..5c28cc3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -426,6 +426,8 @@ struct s5p_mfc_vp8_enc_params {
 struct s5p_mfc_enc_params {
 	u16 width;
 	u16 height;
+	u32 mv_h_range;
+	u32 mv_v_range;
 
 	u16 gop_size;
 	enum v4l2_mpeg_video_multi_slice_mode slice_mode;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 91b6e02..df83cd1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -208,6 +208,24 @@ static struct mfc_control controls[] = {
 		.default_value = 0,
 	},
 	{
+		.id = V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Horizontal MV Search Range",
+		.minimum = 16,
+		.maximum = 128,
+		.step = 16,
+		.default_value = 32,
+	},
+	{
+		.id = V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE,
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.name = "Vertical MV Search Range",
+		.minimum = 16,
+		.maximum = 128,
+		.step = 16,
+		.default_value = 32,
+	},
+	{
 		.id = V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE,
 		.type = V4L2_CTRL_TYPE_INTEGER,
 		.minimum = 0,
@@ -1417,6 +1435,12 @@ static int s5p_mfc_enc_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_VBV_SIZE:
 		p->vbv_size = ctrl->val;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MV_H_SEARCH_RANGE:
+		p->mv_h_range = ctrl->val;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:
+		p->mv_v_range = ctrl->val;
+		break;
 	case V4L2_CID_MPEG_VIDEO_H264_CPB_SIZE:
 		p->codec.h264.cpb_size = ctrl->val;
 		break;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index f6ff2db..f64621a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -727,14 +727,10 @@ static int s5p_mfc_set_enc_params(struct s5p_mfc_ctx *ctx)
 	WRITEL(reg, S5P_FIMV_E_RC_CONFIG_V6);
 
 	/* setting for MV range [16, 256] */
-	reg = 0;
-	reg &= ~(0x3FFF);
-	reg = 256;
+	reg = (p->mv_h_range & S5P_FIMV_E_MV_RANGE_V6_MASK);
 	WRITEL(reg, S5P_FIMV_E_MV_HOR_RANGE_V6);
 
-	reg = 0;
-	reg &= ~(0x3FFF);
-	reg = 256;
+	reg = (p->mv_v_range & S5P_FIMV_E_MV_RANGE_V6_MASK);
 	WRITEL(reg, S5P_FIMV_E_MV_VER_RANGE_V6);
 
 	WRITEL(0x0, S5P_FIMV_E_FRAME_INSERTION_V6);
-- 
1.7.9.5


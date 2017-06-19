Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56019 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751227AbdFSO45 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:56:57 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 15/19] camss: vfe: Configure scaler module in VFE
Date: Mon, 19 Jun 2017 17:48:35 +0300
Message-Id: <1497883719-12410-16-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add scaler module configuration support to be able to apply scaling.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss-8x16/vfe.c | 59 ++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/vfe.c b/drivers/media/platform/qcom/camss-8x16/vfe.c
index 2d2bbcb..a64f158 100644
--- a/drivers/media/platform/qcom/camss-8x16/vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/vfe.c
@@ -183,13 +183,16 @@
 #define VFE_0_DEMUX_EVEN_CFG			0x438
 #define VFE_0_DEMUX_ODD_CFG			0x43c
 
+#define VFE_0_SCALE_ENC_Y_CFG			0x75c
+#define VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE		0x760
+#define VFE_0_SCALE_ENC_Y_H_PHASE		0x764
+#define VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE		0x76c
+#define VFE_0_SCALE_ENC_Y_V_PHASE		0x770
 #define VFE_0_SCALE_ENC_CBCR_CFG		0x778
 #define VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE	0x77c
 #define VFE_0_SCALE_ENC_CBCR_H_PHASE		0x780
-#define VFE_0_SCALE_ENC_CBCR_H_PAD		0x78c
 #define VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE	0x790
 #define VFE_0_SCALE_ENC_CBCR_V_PHASE		0x794
-#define VFE_0_SCALE_ENC_CBCR_V_PAD		0x7a0
 
 #define VFE_0_CLAMP_ENC_MAX_CFG			0x874
 #define VFE_0_CLAMP_ENC_MIN_CFG			0x878
@@ -644,6 +647,20 @@ static void vfe_set_demux_cfg(struct vfe_device *vfe, struct vfe_line *line)
 	writel_relaxed(odd_cfg, vfe->base + VFE_0_DEMUX_ODD_CFG);
 }
 
+static inline u8 vfe_calc_interp_reso(u16 input, u16 output)
+{
+	if (input / output >= 16)
+		return 0;
+
+	if (input / output >= 8)
+		return 1;
+
+	if (input / output >= 4)
+		return 2;
+
+	return 3;
+}
+
 static void vfe_set_scale_cfg(struct vfe_device *vfe, struct vfe_line *line)
 {
 	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
@@ -652,35 +669,51 @@ static void vfe_set_scale_cfg(struct vfe_device *vfe, struct vfe_line *line)
 	u8 interp_reso;
 	u32 phase_mult;
 
+	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_Y_CFG);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].width;
+	output = line->compose.width;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (13 + interp_reso)) / output;
+	reg = (interp_reso << 20) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_H_PHASE);
+
+	input = line->fmt[MSM_VFE_PAD_SINK].height;
+	output = line->compose.height;
+	reg = (output << 16) | input;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_IMAGE_SIZE);
+
+	interp_reso = vfe_calc_interp_reso(input, output);
+	phase_mult = input * (1 << (13 + interp_reso)) / output;
+	reg = (interp_reso << 20) | phase_mult;
+	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_Y_V_PHASE);
+
 	writel_relaxed(0x3, vfe->base + VFE_0_SCALE_ENC_CBCR_CFG);
 
 	input = line->fmt[MSM_VFE_PAD_SINK].width;
-	output = line->fmt[MSM_VFE_PAD_SRC].width / 2;
+	output = line->compose.width / 2;
 	reg = (output << 16) | input;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_IMAGE_SIZE);
 
-	interp_reso = 3;
+	interp_reso = vfe_calc_interp_reso(input, output);
 	phase_mult = input * (1 << (13 + interp_reso)) / output;
 	reg = (interp_reso << 20) | phase_mult;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PHASE);
 
-	reg = input;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_H_PAD);
-
 	input = line->fmt[MSM_VFE_PAD_SINK].height;
-	output = line->fmt[MSM_VFE_PAD_SRC].height;
+	output = line->compose.height;
 	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21)
-		output = line->fmt[MSM_VFE_PAD_SRC].height / 2;
+		output = line->compose.height / 2;
 	reg = (output << 16) | input;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE);
 
-	interp_reso = 3;
+	interp_reso = vfe_calc_interp_reso(input, output);
 	phase_mult = input * (1 << (13 + interp_reso)) / output;
 	reg = (interp_reso << 20) | phase_mult;
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PHASE);
-
-	reg = input;
-	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PAD);
 }
 
 static void vfe_set_clamp_cfg(struct vfe_device *vfe)
-- 
1.9.1

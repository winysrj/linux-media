Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40326 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752408AbdHHNbA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:31:00 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 16/21] camss: vfe: Configure scaler module in VFE
Date: Tue,  8 Aug 2017 16:30:13 +0300
Message-Id: <1502199018-28250-17-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add scaler module configuration support to be able to apply scaling.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 59 +++++++++++++++++-----
 1 file changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
index c6b230b..cc1fc68 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
@@ -198,13 +198,16 @@
 #define VFE_0_DEMUX_ODD_CFG_PATTERN_UYVY	0xc9ca
 #define VFE_0_DEMUX_ODD_CFG_PATTERN_VYUY	0xcac9
 
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
 #define VFE_0_CLAMP_ENC_MAX_CFG_CH0		(0xff << 0)
@@ -670,6 +673,20 @@ static void vfe_set_demux_cfg(struct vfe_device *vfe, struct vfe_line *line)
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
@@ -678,35 +695,51 @@ static void vfe_set_scale_cfg(struct vfe_device *vfe, struct vfe_line *line)
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
2.7.4

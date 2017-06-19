Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:56065 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752111AbdFSO4m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Jun 2017 10:56:42 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v2 17/19] camss: vfe: Configure crop module in VFE
Date: Mon, 19 Jun 2017 17:48:37 +0300
Message-Id: <1497883719-12410-18-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
References: <1497883719-12410-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add crop module configuration support to be able to apply cropping.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss-8x16/vfe.c | 41 +++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/vfe.c b/drivers/media/platform/qcom/camss-8x16/vfe.c
index b97aefa..0241faa 100644
--- a/drivers/media/platform/qcom/camss-8x16/vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/vfe.c
@@ -57,6 +57,7 @@
 #define VFE_0_MODULE_CFG_DEMUX			(1 << 2)
 #define VFE_0_MODULE_CFG_CHROMA_UPSAMPLE	(1 << 3)
 #define VFE_0_MODULE_CFG_SCALE_ENC		(1 << 23)
+#define VFE_0_MODULE_CFG_CROP_ENC		(1 << 27)
 
 #define VFE_0_CORE_CFG			0x01c
 #define VFE_0_CORE_CFG_PIXEL_PATTERN_YCBYCR	0x4
@@ -194,6 +195,11 @@
 #define VFE_0_SCALE_ENC_CBCR_V_IMAGE_SIZE	0x790
 #define VFE_0_SCALE_ENC_CBCR_V_PHASE		0x794
 
+#define VFE_0_CROP_ENC_Y_WIDTH			0x854
+#define VFE_0_CROP_ENC_Y_HEIGHT			0x858
+#define VFE_0_CROP_ENC_CBCR_WIDTH		0x85c
+#define VFE_0_CROP_ENC_CBCR_HEIGHT		0x860
+
 #define VFE_0_CLAMP_ENC_MAX_CFG			0x874
 #define VFE_0_CLAMP_ENC_MIN_CFG			0x878
 
@@ -716,6 +722,37 @@ static void vfe_set_scale_cfg(struct vfe_device *vfe, struct vfe_line *line)
 	writel_relaxed(reg, vfe->base + VFE_0_SCALE_ENC_CBCR_V_PHASE);
 }
 
+static void vfe_set_crop_cfg(struct vfe_device *vfe, struct vfe_line *line)
+{
+	u32 p = line->video_out.active_fmt.fmt.pix_mp.pixelformat;
+	u32 reg;
+	u16 first, last;
+
+	first = line->crop.left;
+	last = line->crop.left + line->crop.width - 1;
+	reg = (first << 16) | last;
+	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_Y_WIDTH);
+
+	first = line->crop.top;
+	last = line->crop.top + line->crop.height - 1;
+	reg = (first << 16) | last;
+	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_Y_HEIGHT);
+
+	first = line->crop.left / 2;
+	last = line->crop.left / 2 + line->crop.width / 2 - 1;
+	reg = (first << 16) | last;
+	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_CBCR_WIDTH);
+
+	first = line->crop.top;
+	last = line->crop.top + line->crop.height - 1;
+	if (p == V4L2_PIX_FMT_NV12 || p == V4L2_PIX_FMT_NV21) {
+		first = line->crop.top / 2;
+		last = line->crop.top / 2 + line->crop.height / 2 - 1;
+	}
+	reg = (first << 16) | last;
+	writel_relaxed(reg, vfe->base + VFE_0_CROP_ENC_CBCR_HEIGHT);
+}
+
 static void vfe_set_clamp_cfg(struct vfe_device *vfe)
 {
 	writel_relaxed(0x00ffffff, vfe->base + VFE_0_CLAMP_ENC_MAX_CFG);
@@ -828,7 +865,8 @@ static void vfe_set_module_cfg(struct vfe_device *vfe, u8 enable)
 {
 	u32 val = VFE_0_MODULE_CFG_DEMUX |
 		  VFE_0_MODULE_CFG_CHROMA_UPSAMPLE |
-		  VFE_0_MODULE_CFG_SCALE_ENC;
+		  VFE_0_MODULE_CFG_SCALE_ENC |
+		  VFE_0_MODULE_CFG_CROP_ENC;
 
 	if (enable)
 		writel_relaxed(val, vfe->base + VFE_0_MODULE_CFG);
@@ -1303,6 +1341,7 @@ static int vfe_enable_output(struct vfe_line *line)
 		vfe_set_xbar_cfg(vfe, output, 1);
 		vfe_set_demux_cfg(vfe, line);
 		vfe_set_scale_cfg(vfe, line);
+		vfe_set_crop_cfg(vfe, line);
 		vfe_set_clamp_cfg(vfe);
 		vfe_set_camif_cmd(vfe, VFE_0_CAMIF_CMD_ENABLE_FRAME_BOUNDARY);
 	}
-- 
1.9.1

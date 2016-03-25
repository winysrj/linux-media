Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40677 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbcCYKpN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:13 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 50/54] v4l: vsp1: Add support for the RPF alpha multiplier on Gen3
Date: Fri, 25 Mar 2016 12:44:24 +0200
Message-Id: <1458902668-1141-51-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Gen3 RPF includes an alpha multiplier that can both multiply the
alpha channel by a fixed global alpha value, and multiply the pixel
components to convert the input to premultiplied alpha.

As alpha premultiplication is available in the BRU for both Gen2 and
Gen3 we handle it there and use the Gen3 alpha multiplier for global
alpha multiplication only. This prevents conversion to premultiplied
alpha if no BRU is present in the pipeline, that use case will be
implemented later if needed.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1.h      |  1 +
 drivers/media/platform/vsp1/vsp1_drv.c  |  8 +++++
 drivers/media/platform/vsp1/vsp1_regs.h | 10 ++++++
 drivers/media/platform/vsp1/vsp1_rpf.c  | 57 +++++++++++++++++++++++++++++++--
 4 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1.h b/drivers/media/platform/vsp1/vsp1.h
index dae987a11a70..46738b6c5f72 100644
--- a/drivers/media/platform/vsp1/vsp1.h
+++ b/drivers/media/platform/vsp1/vsp1.h
@@ -48,6 +48,7 @@ struct vsp1_uds;
 
 struct vsp1_device_info {
 	u32 version;
+	unsigned int gen;
 	unsigned int features;
 	unsigned int rpf_count;
 	unsigned int uds_count;
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 596f26d81494..e2d779fac0eb 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -558,6 +558,7 @@ static const struct dev_pm_ops vsp1_pm_ops = {
 static const struct vsp1_device_info vsp1_device_infos[] = {
 	{
 		.version = VI6_IP_VERSION_MODEL_VSPS_H2,
+		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LUT | VSP1_HAS_SRU,
 		.rpf_count = 5,
 		.uds_count = 3,
@@ -566,6 +567,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPR_H2,
+		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_SRU,
 		.rpf_count = 5,
 		.uds_count = 1,
@@ -574,6 +576,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN2,
+		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LIF | VSP1_HAS_LUT,
 		.rpf_count = 4,
 		.uds_count = 1,
@@ -582,6 +585,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPS_M2,
+		.gen = 2,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LUT | VSP1_HAS_SRU,
 		.rpf_count = 5,
 		.uds_count = 3,
@@ -590,6 +594,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPI_GEN3,
+		.gen = 3,
 		.features = VSP1_HAS_LUT | VSP1_HAS_SRU,
 		.rpf_count = 1,
 		.uds_count = 1,
@@ -597,6 +602,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBD_GEN3,
+		.gen = 3,
 		.features = VSP1_HAS_BRU,
 		.rpf_count = 5,
 		.wpf_count = 1,
@@ -604,6 +610,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPBC_GEN3,
+		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LUT,
 		.rpf_count = 5,
 		.wpf_count = 1,
@@ -611,6 +618,7 @@ static const struct vsp1_device_info vsp1_device_infos[] = {
 		.uapi = true,
 	}, {
 		.version = VI6_IP_VERSION_MODEL_VSPD_GEN3,
+		.gen = 3,
 		.features = VSP1_HAS_BRU | VSP1_HAS_LIF,
 		.rpf_count = 5,
 		.wpf_count = 2,
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 069216f0eb44..927b5fb94c48 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -217,6 +217,16 @@
 #define VI6_RPF_SRCM_ADDR_C1		0x0344
 #define VI6_RPF_SRCM_ADDR_AI		0x0348
 
+#define VI6_RPF_MULT_ALPHA		0x036c
+#define VI6_RPF_MULT_ALPHA_A_MMD_NONE	(0 << 12)
+#define VI6_RPF_MULT_ALPHA_A_MMD_RATIO	(1 << 12)
+#define VI6_RPF_MULT_ALPHA_P_MMD_NONE	(0 << 8)
+#define VI6_RPF_MULT_ALPHA_P_MMD_RATIO	(1 << 8)
+#define VI6_RPF_MULT_ALPHA_P_MMD_IMAGE	(2 << 8)
+#define VI6_RPF_MULT_ALPHA_P_MMD_BOTH	(3 << 8)
+#define VI6_RPF_MULT_ALPHA_RATIO_MASK	(0xff < 0)
+#define VI6_RPF_MULT_ALPHA_RATIO_SHIFT	0
+
 /* -----------------------------------------------------------------------------
  * WPF Control Registers
  */
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index bc94427c0740..a316e1030610 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -141,9 +141,27 @@ static void rpf_configure(struct vsp1_entity *entity,
 		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
 		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
 
-	/* Use the alpha channel (extended to 8 bits) when available or an
-	 * alpha value set through the V4L2_CID_ALPHA_COMPONENT control
-	 * otherwise. Disable color keying.
+	/* On Gen2 use the alpha channel (extended to 8 bits) when available or
+	 * a fixed alpha value set through the V4L2_CID_ALPHA_COMPONENT control
+	 * otherwise.
+	 *
+	 * The Gen3 RPF has extended alpha capability and can both multiply the
+	 * alpha channel by a fixed global alpha value, and multiply the pixel
+	 * components to convert the input to premultiplied alpha.
+	 *
+	 * As alpha premultiplication is available in the BRU for both Gen2 and
+	 * Gen3 we handle it there and use the Gen3 alpha multiplier for global
+	 * alpha multiplication only. This however prevents conversion to
+	 * premultiplied alpha if no BRU is present in the pipeline. If that use
+	 * case turns out to be useful we will revisit the implementation (for
+	 * Gen3 only).
+	 *
+	 * We enable alpha multiplication on Gen3 using the fixed alpha value
+	 * set through the V4L2_CID_ALPHA_COMPONENT control when the input
+	 * contains an alpha channel. On Gen2 the global alpha is ignored in
+	 * that case.
+	 *
+	 * In all cases, disable color keying.
 	 */
 	vsp1_rpf_write(rpf, dl, VI6_RPF_ALPH_SEL, VI6_RPF_ALPH_SEL_AEXT_EXT |
 		       (fmtinfo->alpha ? VI6_RPF_ALPH_SEL_ASEL_PACKED
@@ -152,10 +170,43 @@ static void rpf_configure(struct vsp1_entity *entity,
 	vsp1_rpf_write(rpf, dl, VI6_RPF_VRTCOL_SET,
 		       rpf->alpha << VI6_RPF_VRTCOL_SET_LAYA_SHIFT);
 
+	if (entity->vsp1->info->gen == 3) {
+		u32 mult;
+
+		if (fmtinfo->alpha) {
+			/* When the input contains an alpha channel enable the
+			 * alpha multiplier. If the input is premultiplied we
+			 * need to multiply both the alpha channel and the pixel
+			 * components by the global alpha value to keep them
+			 * premultiplied. Otherwise multiply the alpha channel
+			 * only.
+			 */
+			bool premultiplied = format->flags
+					   & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA;
+
+			mult = VI6_RPF_MULT_ALPHA_A_MMD_RATIO
+			     | (premultiplied ?
+				VI6_RPF_MULT_ALPHA_P_MMD_RATIO :
+				VI6_RPF_MULT_ALPHA_P_MMD_NONE)
+			     | (rpf->alpha << VI6_RPF_MULT_ALPHA_RATIO_SHIFT);
+		} else {
+			/* When the input doesn't contain an alpha channel the
+			 * global alpha value is applied in the unpacking unit,
+			 * the alpha multiplier isn't needed and must be
+			 * disabled.
+			 */
+			mult = VI6_RPF_MULT_ALPHA_A_MMD_NONE
+			     | VI6_RPF_MULT_ALPHA_P_MMD_NONE;
+		}
+
+		vsp1_rpf_write(rpf, dl, VI6_RPF_MULT_ALPHA, mult);
+	}
+
 	vsp1_pipeline_propagate_alpha(pipe, &rpf->entity, dl, rpf->alpha);
 
 	vsp1_rpf_write(rpf, dl, VI6_RPF_MSK_CTRL, 0);
 	vsp1_rpf_write(rpf, dl, VI6_RPF_CKEY_CTRL, 0);
+
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
-- 
2.7.3


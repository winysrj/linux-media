Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:48714 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933454AbcI1VVr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:21:47 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [Patch 15/35] media: ti-vpe: vpe: configure line mode separately
Date: Wed, 28 Sep 2016 16:21:45 -0500
Message-ID: <20160928212145.26995-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Nikhil Devshatwar <nikhil.nd@ti.com>

Current driver configures the line mode of the DEI clients
from the open function directly. Even if the newly created context
is not yet scheduled, it updates some of the VPDMA registers.
This causes a problem in multi instance use case where just opening
the m2m device second time causes the running job to stall. This
happens especially if the source buffers used are NV12.

While all other configuration is being written to context specific
shadow registers, only line mode configuration is happening directly.

As there is no shadow register for line mode configuration, it's better
to separate the config_mode setting and line_mode setting. Call the
new "set_line_modes" functions only when actually loading the mmrs.
This makes sure that no non-running job will write to the registers
directly.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 000cd073fa8d..ab677f34a627 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -660,14 +660,13 @@ static void set_us_coefficients(struct vpe_ctx *ctx)
 /*
  * Set the upsampler config mode and the VPDMA line mode in the shadow MMRs.
  */
-static void set_cfg_and_line_modes(struct vpe_ctx *ctx)
+static void set_cfg_modes(struct vpe_ctx *ctx)
 {
 	struct vpe_fmt *fmt = ctx->q_data[Q_DATA_SRC].fmt;
 	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
 	u32 *us1_reg0 = &mmr_adb->us1_regs[0];
 	u32 *us2_reg0 = &mmr_adb->us2_regs[0];
 	u32 *us3_reg0 = &mmr_adb->us3_regs[0];
-	int line_mode = 1;
 	int cfg_mode = 1;
 
 	/*
@@ -675,15 +674,24 @@ static void set_cfg_and_line_modes(struct vpe_ctx *ctx)
 	 * Cfg Mode 1: YUV422 source, disable upsampler, DEI is de-interlacing.
 	 */
 
-	if (fmt->fourcc == V4L2_PIX_FMT_NV12) {
+	if (fmt->fourcc == V4L2_PIX_FMT_NV12)
 		cfg_mode = 0;
-		line_mode = 0;		/* double lines to line buffer */
-	}
 
 	write_field(us1_reg0, cfg_mode, VPE_US_MODE_MASK, VPE_US_MODE_SHIFT);
 	write_field(us2_reg0, cfg_mode, VPE_US_MODE_MASK, VPE_US_MODE_SHIFT);
 	write_field(us3_reg0, cfg_mode, VPE_US_MODE_MASK, VPE_US_MODE_SHIFT);
 
+	ctx->load_mmrs = true;
+}
+
+static void set_line_modes(struct vpe_ctx *ctx)
+{
+	struct vpe_fmt *fmt = ctx->q_data[Q_DATA_SRC].fmt;
+	int line_mode = 1;
+
+	if (fmt->fourcc == V4L2_PIX_FMT_NV12)
+		line_mode = 0;		/* double lines to line buffer */
+
 	/* regs for now */
 	vpdma_set_line_mode(ctx->dev->vpdma, line_mode, VPE_CHAN_CHROMA1_IN);
 	vpdma_set_line_mode(ctx->dev->vpdma, line_mode, VPE_CHAN_CHROMA2_IN);
@@ -708,8 +716,6 @@ static void set_cfg_and_line_modes(struct vpe_ctx *ctx)
 	/* frame start for MV in client */
 	vpdma_set_frame_start_event(ctx->dev->vpdma, VPDMA_FSEVENT_CHANNEL_ACTIVE,
 		VPE_CHAN_MV_IN);
-
-	ctx->load_mmrs = true;
 }
 
 /*
@@ -868,7 +874,7 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	if (ret)
 		return ret;
 
-	set_cfg_and_line_modes(ctx);
+	set_cfg_modes(ctx);
 	set_dei_regs(ctx);
 
 	csc_set_coeff(ctx->dev->csc, &mmr_adb->csc_regs[0],
@@ -1184,6 +1190,9 @@ static void device_run(void *priv)
 	if (ctx->dev->loaded_mmrs != ctx->mmr_adb.dma_addr || ctx->load_mmrs) {
 		vpdma_map_desc_buf(ctx->dev->vpdma, &ctx->mmr_adb);
 		vpdma_add_cfd_adb(&ctx->desc_list, CFD_MMR_CLIENT, &ctx->mmr_adb);
+
+		set_line_modes(ctx);
+
 		ctx->dev->loaded_mmrs = ctx->mmr_adb.dma_addr;
 		ctx->load_mmrs = false;
 	}
-- 
2.9.0


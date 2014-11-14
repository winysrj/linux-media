Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36642 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964995AbaKNLU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 06:20:57 -0500
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id sAEBKvT7031193
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 05:20:57 -0600
Received: from DLEE71.ent.ti.com (dlee71.ent.ti.com [157.170.170.114])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id sAEBKvLw002908
	for <linux-media@vger.kernel.org>; Fri, 14 Nov 2014 05:20:57 -0600
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: <nikhil.nd@ti.com>
Subject: [PATCH v2 2/4] media: ti-vpe: Use line average de-interlacing for first 2 frames
Date: Fri, 14 Nov 2014 16:50:50 +0530
Message-ID: <1415964052-30351-3-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1415964052-30351-1-git-send-email-nikhil.nd@ti.com>
References: <1415964052-30351-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Archit Taneja <archit@ti.com>

For n input fields, the VPE de-interlacer creates n - 2 progressive frames.

To support this, we use line average mode of de-interlacer for the first 2
input fields to generate 2 progressive frames. We then revert back to the
preferred EDI method, and create n - 2 frames, creating a sum of n frames.

Signed-off-by: Archit Taneja <archit@ti.com>
Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index e59eb81..4d3ab43 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -806,6 +806,23 @@ static void set_dei_shadow_registers(struct vpe_ctx *ctx)
 	ctx->load_mmrs = true;
 }
 
+static void config_edi_input_mode(struct vpe_ctx *ctx, int mode)
+{
+	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
+	u32 *edi_config_reg = &mmr_adb->dei_regs[3];
+
+	if (mode & 0x2)
+		write_field(edi_config_reg, 1, 1, 2);	/* EDI_ENABLE_3D */
+
+	if (mode & 0x3)
+		write_field(edi_config_reg, 1, 1, 3);	/* EDI_CHROMA_3D  */
+
+	write_field(edi_config_reg, mode, VPE_EDI_INP_MODE_MASK,
+		VPE_EDI_INP_MODE_SHIFT);
+
+	ctx->load_mmrs = true;
+}
+
 /*
  * Set the shadow registers whose values are modified when either the
  * source or destination format is changed.
@@ -1118,6 +1135,15 @@ static void device_run(void *priv)
 	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx);
 	WARN_ON(ctx->dst_vb == NULL);
 
+	if (ctx->deinterlacing) {
+		/*
+		 * we have output the first 2 frames through line average, we
+		 * now switch to EDI de-interlacer
+		 */
+		if (ctx->sequence == 2)
+			config_edi_input_mode(ctx, 0x3); /* EDI (Y + UV) */
+	}
+
 	/* config descriptors */
 	if (ctx->dev->loaded_mmrs != ctx->mmr_adb.dma_addr || ctx->load_mmrs) {
 		vpdma_map_desc_buf(ctx->dev->vpdma, &ctx->mmr_adb);
@@ -1779,6 +1805,9 @@ static int vpe_streamon(struct file *file, void *priv, enum v4l2_buf_type type)
 {
 	struct vpe_ctx *ctx = file2ctx(file);
 
+	if (ctx->deinterlacing)
+		config_edi_input_mode(ctx, 0x0);
+
 	return v4l2_m2m_streamon(file, ctx->m2m_ctx, type);
 }
 
-- 
1.7.9.5


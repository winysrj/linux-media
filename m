Return-path: <linux-media-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:14812 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753303AbcKRXVD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 18:21:03 -0500
From: Benoit Parrot <bparrot@ti.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch v2 05/35] media: ti-vpe: Use line average de-interlacing for first 2 frames
Date: Fri, 18 Nov 2016 17:20:15 -0600
Message-ID: <20161118232045.24665-6-bparrot@ti.com>
In-Reply-To: <20161118232045.24665-1-bparrot@ti.com>
References: <20161118232045.24665-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Archit Taneja <archit@ti.com>

The motion detection block requires 3 fields to create the motion vector
data. This means that using the default method the first progressive
frame is only generated after 3rd field is consumed.
Hence by default for N input field we would generate N - 2 progressive
frames.

In order to generate N progressive frames from N fields we use the
line averaging mode of the de-interlacer for the first 2 fields and then
revert back to the preferred Edge Directed Interpolation method (using
the motion vector).
Thus creating 2 line averaged frames + N - 2 motion based frames for a
total of N frames.

Signed-off-by: Archit Taneja <archit@ti.com>
Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index bd385c5bae2f..ad838b8a98c4 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -141,7 +141,7 @@ struct vpe_dei_regs {
  */
 static const struct vpe_dei_regs dei_regs = {
 	.mdt_spacial_freq_thr_reg = 0x020C0804u,
-	.edi_config_reg = 0x0118100Fu,
+	.edi_config_reg = 0x0118100Cu,
 	.edi_lut_reg0 = 0x08040200u,
 	.edi_lut_reg1 = 0x1010100Cu,
 	.edi_lut_reg2 = 0x10101010u,
@@ -798,6 +798,23 @@ static void set_dei_shadow_registers(struct vpe_ctx *ctx)
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
@@ -1111,6 +1128,15 @@ static void device_run(void *priv)
 	ctx->dst_vb = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
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
@@ -1864,7 +1890,10 @@ static void vpe_buf_queue(struct vb2_buffer *vb)
 
 static int vpe_start_streaming(struct vb2_queue *q, unsigned int count)
 {
-	/* currently we do nothing here */
+	struct vpe_ctx *ctx = vb2_get_drv_priv(q);
+
+	if (ctx->deinterlacing)
+		config_edi_input_mode(ctx, 0x0);
 
 	return 0;
 }
-- 
2.9.0


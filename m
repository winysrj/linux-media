Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58627 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458Ab3LLIga (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Dec 2013 03:36:30 -0500
From: Archit Taneja <archit@ti.com>
To: <linux-media@vger.kernel.org>, <k.debski@samsung.com>,
	<hverkuil@xs4all.nl>, <laurent.pinchart@ideasonboard.com>
CC: <linux-omap@vger.kernel.org>, <tomi.valkeinen@ti.com>,
	Archit Taneja <archit@ti.com>
Subject: [PATCH 3/8] v4l: ti-vpe: make vpe driver load scaler coefficients
Date: Thu, 12 Dec 2013 14:05:59 +0530
Message-ID: <1386837364-1264-4-git-send-email-archit@ti.com>
In-Reply-To: <1386837364-1264-1-git-send-email-archit@ti.com>
References: <1386837364-1264-1-git-send-email-archit@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the driver allocate dma buffers to store horizontal and scaler coeffs.
Use the scaler library api to choose and copy scaler coefficients to a
the above buffers based on the scaling ratio. Since the SC block comes after
the de-interlacer, make sure that the source height is doubled if de-interlacer
was used.

These buffers now need to be used by VPDMA to load the coefficients into the
SRAM within SC.

In device_run, add configuration descriptors which have payloads pointing to
the scaler coefficients in memory. Use the members in sc_data handle to prevent
addition of these descriptors if there isn't a need to re-load coefficients into
SC. This comes helps unnecessary re-loading of the coefficients when we switch
back and forth between vpe contexts.

Signed-off-by: Archit Taneja <archit@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c | 47 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index ecb85f9..50d6d0e 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -356,6 +356,8 @@ struct vpe_ctx {
 	void			*mv_buf[2];		/* virtual addrs of motion vector bufs */
 	size_t			mv_buf_size;		/* current motion vector buffer size */
 	struct vpdma_buf	mmr_adb;		/* shadow reg addr/data block */
+	struct vpdma_buf	sc_coeff_h;		/* h coeff buffer */
+	struct vpdma_buf	sc_coeff_v;		/* v coeff buffer */
 	struct vpdma_desc_list	desc_list;		/* DMA descriptor list */
 
 	bool			deinterlacing;		/* using de-interlacer */
@@ -765,6 +767,10 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	struct vpe_q_data *s_q_data =  &ctx->q_data[Q_DATA_SRC];
 	struct vpe_q_data *d_q_data =  &ctx->q_data[Q_DATA_DST];
 	struct vpe_mmr_adb *mmr_adb = ctx->mmr_adb.addr;
+	unsigned int src_w = s_q_data->c_rect.width;
+	unsigned int src_h = s_q_data->c_rect.height;
+	unsigned int dst_w = d_q_data->c_rect.width;
+	unsigned int dst_h = d_q_data->c_rect.height;
 	size_t mv_buf_size;
 	int ret;
 
@@ -777,7 +783,6 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 		const struct vpdma_data_format *mv =
 			&vpdma_misc_fmts[VPDMA_DATA_FMT_MV];
 
-		ctx->deinterlacing = 1;
 		/*
 		 * we make sure that the source image has a 16 byte aligned
 		 * stride, we need to do the same for the motion vector buffer
@@ -788,6 +793,9 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 		bytes_per_line = ALIGN((s_q_data->width * mv->depth) >> 3,
 					VPDMA_STRIDE_ALIGN);
 		mv_buf_size = bytes_per_line * s_q_data->height;
+
+		ctx->deinterlacing = 1;
+		src_h <<= 1;
 	} else {
 		ctx->deinterlacing = 0;
 		mv_buf_size = 0;
@@ -802,6 +810,8 @@ static int set_srcdst_params(struct vpe_ctx *ctx)
 	set_cfg_and_line_modes(ctx);
 	set_dei_regs(ctx);
 	set_csc_coeff_bypass(ctx);
+	sc_set_hs_coeffs(ctx->dev->sc, ctx->sc_coeff_h.addr, src_w, dst_w);
+	sc_set_vs_coeffs(ctx->dev->sc, ctx->sc_coeff_v.addr, src_h, dst_h);
 	sc_set_regs_bypass(ctx->dev->sc, &mmr_adb->sc_regs[0]);
 
 	return 0;
@@ -1035,6 +1045,7 @@ static void disable_irqs(struct vpe_ctx *ctx)
 static void device_run(void *priv)
 {
 	struct vpe_ctx *ctx = priv;
+	struct sc_data *sc = ctx->dev->sc;
 	struct vpe_q_data *d_q_data = &ctx->q_data[Q_DATA_DST];
 
 	if (ctx->deinterlacing && ctx->src_vbs[2] == NULL) {
@@ -1057,6 +1068,26 @@ static void device_run(void *priv)
 		ctx->load_mmrs = false;
 	}
 
+	if (sc->loaded_coeff_h != ctx->sc_coeff_h.dma_addr ||
+			sc->load_coeff_h) {
+		vpdma_map_desc_buf(ctx->dev->vpdma, &ctx->sc_coeff_h);
+		vpdma_add_cfd_block(&ctx->desc_list, CFD_SC_CLIENT,
+			&ctx->sc_coeff_h, 0);
+
+		sc->loaded_coeff_h = ctx->sc_coeff_h.dma_addr;
+		sc->load_coeff_h = false;
+	}
+
+	if (sc->loaded_coeff_v != ctx->sc_coeff_v.dma_addr ||
+			sc->load_coeff_v) {
+		vpdma_map_desc_buf(ctx->dev->vpdma, &ctx->sc_coeff_v);
+		vpdma_add_cfd_block(&ctx->desc_list, CFD_SC_CLIENT,
+			&ctx->sc_coeff_v, SC_COEF_SRAM_SIZE >> 4);
+
+		sc->loaded_coeff_v = ctx->sc_coeff_v.dma_addr;
+		sc->load_coeff_v = false;
+	}
+
 	/* output data descriptors */
 	if (ctx->deinterlacing)
 		add_out_dtd(ctx, VPE_PORT_MV_OUT);
@@ -1180,6 +1211,8 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 
 	vpdma_unmap_desc_buf(dev->vpdma, &ctx->desc_list.buf);
 	vpdma_unmap_desc_buf(dev->vpdma, &ctx->mmr_adb);
+	vpdma_unmap_desc_buf(dev->vpdma, &ctx->sc_coeff_h);
+	vpdma_unmap_desc_buf(dev->vpdma, &ctx->sc_coeff_v);
 
 	vpdma_reset_desc_list(&ctx->desc_list);
 
@@ -1752,6 +1785,14 @@ static int vpe_open(struct file *file)
 	if (ret != 0)
 		goto free_desc_list;
 
+	ret = vpdma_alloc_desc_buf(&ctx->sc_coeff_h, SC_COEF_SRAM_SIZE);
+	if (ret != 0)
+		goto free_mmr_adb;
+
+	ret = vpdma_alloc_desc_buf(&ctx->sc_coeff_v, SC_COEF_SRAM_SIZE);
+	if (ret != 0)
+		goto free_sc_h;
+
 	init_adb_hdrs(ctx);
 
 	v4l2_fh_init(&ctx->fh, video_devdata(file));
@@ -1820,6 +1861,10 @@ static int vpe_open(struct file *file)
 exit_fh:
 	v4l2_ctrl_handler_free(hdl);
 	v4l2_fh_exit(&ctx->fh);
+	vpdma_free_desc_buf(&ctx->sc_coeff_v);
+free_sc_h:
+	vpdma_free_desc_buf(&ctx->sc_coeff_h);
+free_mmr_adb:
 	vpdma_free_desc_buf(&ctx->mmr_adb);
 free_desc_list:
 	vpdma_free_desc_list(&ctx->desc_list);
-- 
1.8.3.2


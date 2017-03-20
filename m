Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27549 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753578AbdCTK5N (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:57:13 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v3 15/16] media: s5p-mfc: Rename BANK1/2 to BANK_L/R to better
 match documentation
Date: Mon, 20 Mar 2017 11:56:41 +0100
Message-id: <1490007402-30265-16-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170320105654eucas1p26e4fb044e6b814d4a349f2d2831076d7@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation for MFC hardware still uses 'left' and 'right' names for
the memory channel/banks, so replace BANK1/2 defines with more appropriate
BANK_L/R names.

Suggested-by: Shuah Khan <shuahkhan@gmail.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 54 ++++++++++++-------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 13 +++---
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  8 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 10 ++---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 28 ++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  6 +--
 7 files changed, 62 insertions(+), 61 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index a56031c3263e..dc1f6a96877a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1118,34 +1118,34 @@ static int s5p_mfc_configure_2port_memory(struct s5p_mfc_dev *mfc_dev)
 	 * Create and initialize virtual devices for accessing
 	 * reserved memory regions.
 	 */
-	mfc_dev->mem_dev[BANK1_CTX] = s5p_mfc_alloc_memdev(dev, "left",
-							   BANK1_CTX);
-	if (!mfc_dev->mem_dev[BANK1_CTX])
+	mfc_dev->mem_dev[BANK_L_CTX] = s5p_mfc_alloc_memdev(dev, "left",
+							   BANK_L_CTX);
+	if (!mfc_dev->mem_dev[BANK_L_CTX])
 		return -ENODEV;
-	mfc_dev->mem_dev[BANK2_CTX] = s5p_mfc_alloc_memdev(dev, "right",
-							   BANK2_CTX);
-	if (!mfc_dev->mem_dev[BANK2_CTX]) {
-		device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
+	mfc_dev->mem_dev[BANK_R_CTX] = s5p_mfc_alloc_memdev(dev, "right",
+							   BANK_R_CTX);
+	if (!mfc_dev->mem_dev[BANK_R_CTX]) {
+		device_unregister(mfc_dev->mem_dev[BANK_L_CTX]);
 		return -ENODEV;
 	}
 
 	/* Allocate memory for firmware and initialize both banks addresses */
 	ret = s5p_mfc_alloc_firmware(mfc_dev);
 	if (ret) {
-		device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
-		device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
+		device_unregister(mfc_dev->mem_dev[BANK_R_CTX]);
+		device_unregister(mfc_dev->mem_dev[BANK_L_CTX]);
 		return ret;
 	}
 
-	mfc_dev->dma_base[BANK1_CTX] = mfc_dev->fw_buf.dma;
+	mfc_dev->dma_base[BANK_L_CTX] = mfc_dev->fw_buf.dma;
 
-	bank2_virt = dma_alloc_coherent(mfc_dev->mem_dev[BANK2_CTX], align_size,
-					&bank2_dma_addr, GFP_KERNEL);
+	bank2_virt = dma_alloc_coherent(mfc_dev->mem_dev[BANK_R_CTX],
+				       align_size, &bank2_dma_addr, GFP_KERNEL);
 	if (!bank2_virt) {
 		mfc_err("Allocating bank2 base failed\n");
 		s5p_mfc_release_firmware(mfc_dev);
-		device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
-		device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
+		device_unregister(mfc_dev->mem_dev[BANK_R_CTX]);
+		device_unregister(mfc_dev->mem_dev[BANK_L_CTX]);
 		return -ENOMEM;
 	}
 
@@ -1153,14 +1153,14 @@ static int s5p_mfc_configure_2port_memory(struct s5p_mfc_dev *mfc_dev)
 	 * should not have address of bank2 - MFC will treat it as a null frame.
 	 * To avoid such situation we set bank2 address below the pool address.
 	 */
-	mfc_dev->dma_base[BANK2_CTX] = bank2_dma_addr - align_size;
+	mfc_dev->dma_base[BANK_R_CTX] = bank2_dma_addr - align_size;
 
-	dma_free_coherent(mfc_dev->mem_dev[BANK2_CTX], align_size, bank2_virt,
+	dma_free_coherent(mfc_dev->mem_dev[BANK_R_CTX], align_size, bank2_virt,
 			  bank2_dma_addr);
 
-	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK1_CTX],
+	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK_L_CTX],
 					DMA_BIT_MASK(32));
-	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK2_CTX],
+	vb2_dma_contig_set_max_seg_size(mfc_dev->mem_dev[BANK_R_CTX],
 					DMA_BIT_MASK(32));
 
 	return 0;
@@ -1168,10 +1168,10 @@ static int s5p_mfc_configure_2port_memory(struct s5p_mfc_dev *mfc_dev)
 
 static void s5p_mfc_unconfigure_2port_memory(struct s5p_mfc_dev *mfc_dev)
 {
-	device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
-	device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
-	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK1_CTX]);
-	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK2_CTX]);
+	device_unregister(mfc_dev->mem_dev[BANK_L_CTX]);
+	device_unregister(mfc_dev->mem_dev[BANK_R_CTX]);
+	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK_L_CTX]);
+	vb2_dma_contig_clear_max_seg_size(mfc_dev->mem_dev[BANK_R_CTX]);
 }
 
 static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
@@ -1201,8 +1201,8 @@ static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
 		return -ENOMEM;
 	}
 	mfc_dev->mem_size = mem_size;
-	mfc_dev->dma_base[BANK1_CTX] = mfc_dev->mem_base;
-	mfc_dev->dma_base[BANK2_CTX] = mfc_dev->mem_base;
+	mfc_dev->dma_base[BANK_L_CTX] = mfc_dev->mem_base;
+	mfc_dev->dma_base[BANK_R_CTX] = mfc_dev->mem_base;
 
 	/*
 	 * MFC hardware cannot handle 0 as a base address, so mark first 128K
@@ -1212,14 +1212,14 @@ static int s5p_mfc_configure_common_memory(struct s5p_mfc_dev *mfc_dev)
 		unsigned int offset = 1 << MFC_BASE_ALIGN_ORDER;
 
 		bitmap_set(mfc_dev->mem_bitmap, 0, offset >> PAGE_SHIFT);
-		mfc_dev->dma_base[BANK1_CTX] += offset;
-		mfc_dev->dma_base[BANK2_CTX] += offset;
+		mfc_dev->dma_base[BANK_L_CTX] += offset;
+		mfc_dev->dma_base[BANK_R_CTX] += offset;
 	}
 
 	/* Firmware allocation cannot fail in this case */
 	s5p_mfc_alloc_firmware(mfc_dev);
 
-	mfc_dev->mem_dev[BANK1_CTX] = mfc_dev->mem_dev[BANK2_CTX] = dev;
+	mfc_dev->mem_dev[BANK_L_CTX] = mfc_dev->mem_dev[BANK_R_CTX] = dev;
 	vb2_dma_contig_set_max_seg_size(dev, DMA_BIT_MASK(32));
 
 	dev_info(dev, "preallocated %ld MiB buffer for the firmware and context buffers\n",
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index e64dc6e3c75e..4220914529b2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -33,8 +33,8 @@
 *  while mmaping */
 #define DST_QUEUE_OFF_BASE	(1 << 30)
 
-#define BANK1_CTX	0
-#define BANK2_CTX	1
+#define BANK_L_CTX	0
+#define BANK_R_CTX	1
 #define BANK_CTX_NUM	2
 
 #define MFC_BANK1_ALIGN_ORDER	13
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index a1811ee538bd..69ef9c23a99a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -36,7 +36,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		return -ENOMEM;
 	}
 
-	err = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &dev->fw_buf);
+	err = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &dev->fw_buf);
 	if (err) {
 		mfc_err("Allocating bitprocessor buffer failed\n");
 		return err;
@@ -177,17 +177,18 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 static inline void s5p_mfc_init_memctrl(struct s5p_mfc_dev *dev)
 {
 	if (IS_MFCV6_PLUS(dev)) {
-		mfc_write(dev, dev->dma_base[BANK1_CTX],
+		mfc_write(dev, dev->dma_base[BANK_L_CTX],
 			  S5P_FIMV_RISC_BASE_ADDRESS_V6);
 		mfc_debug(2, "Base Address : %pad\n",
-			  &dev->dma_base[BANK1_CTX]);
+			  &dev->dma_base[BANK_L_CTX]);
 	} else {
-		mfc_write(dev, dev->dma_base[BANK1_CTX],
+		mfc_write(dev, dev->dma_base[BANK_L_CTX],
 			  S5P_FIMV_MC_DRAMBASE_ADR_A);
-		mfc_write(dev, dev->dma_base[BANK2_CTX],
+		mfc_write(dev, dev->dma_base[BANK_R_CTX],
 			  S5P_FIMV_MC_DRAMBASE_ADR_B);
 		mfc_debug(2, "Bank1: %pad, Bank2: %pad\n",
-			  &dev->dma_base[BANK1_CTX], &dev->dma_base[BANK2_CTX]);
+			  &dev->dma_base[BANK_L_CTX],
+			  &dev->dma_base[BANK_R_CTX]);
 	}
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index f17062f9070b..8937b0af7cb3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -931,14 +931,14 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[1] = ctx->chroma_size;
 
 		if (IS_MFCV6_PLUS(dev))
-			alloc_devs[0] = ctx->dev->mem_dev[BANK1_CTX];
+			alloc_devs[0] = ctx->dev->mem_dev[BANK_L_CTX];
 		else
-			alloc_devs[0] = ctx->dev->mem_dev[BANK2_CTX];
-		alloc_devs[1] = ctx->dev->mem_dev[BANK1_CTX];
+			alloc_devs[0] = ctx->dev->mem_dev[BANK_R_CTX];
+		alloc_devs[1] = ctx->dev->mem_dev[BANK_L_CTX];
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		   ctx->state == MFCINST_INIT) {
 		psize[0] = ctx->dec_src_buf_size;
-		alloc_devs[0] = ctx->dev->mem_dev[BANK1_CTX];
+		alloc_devs[0] = ctx->dev->mem_dev[BANK_L_CTX];
 	} else {
 		mfc_err("This video node is dedicated to decoding. Decoding not initialized\n");
 		return -EINVAL;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 2eea21f06d7e..2a5fd7c42cd5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1832,7 +1832,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		if (*buf_count > MFC_MAX_BUFFERS)
 			*buf_count = MFC_MAX_BUFFERS;
 		psize[0] = ctx->enc_dst_buf_size;
-		alloc_devs[0] = ctx->dev->mem_dev[BANK1_CTX];
+		alloc_devs[0] = ctx->dev->mem_dev[BANK_L_CTX];
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->src_fmt)
 			*plane_count = ctx->src_fmt->num_planes;
@@ -1848,11 +1848,11 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[1] = ctx->chroma_size;
 
 		if (IS_MFCV6_PLUS(dev)) {
-			alloc_devs[0] = ctx->dev->mem_dev[BANK1_CTX];
-			alloc_devs[1] = ctx->dev->mem_dev[BANK1_CTX];
+			alloc_devs[0] = ctx->dev->mem_dev[BANK_L_CTX];
+			alloc_devs[1] = ctx->dev->mem_dev[BANK_L_CTX];
 		} else {
-			alloc_devs[0] = ctx->dev->mem_dev[BANK2_CTX];
-			alloc_devs[1] = ctx->dev->mem_dev[BANK2_CTX];
+			alloc_devs[0] = ctx->dev->mem_dev[BANK_R_CTX];
+			alloc_devs[1] = ctx->dev->mem_dev[BANK_R_CTX];
 		}
 	} else {
 		mfc_err("invalid queue type: %d\n", vq->type);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 20e8a1bdc984..b41ee608c171 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -30,8 +30,8 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define OFFSETA(x)		(((x) - dev->dma_base[BANK1_CTX]) >> MFC_OFFSET_SHIFT)
-#define OFFSETB(x)		(((x) - dev->dma_base[BANK2_CTX]) >> MFC_OFFSET_SHIFT)
+#define OFFSETA(x)		(((x) - dev->dma_base[BANK_L_CTX]) >> MFC_OFFSET_SHIFT)
+#define OFFSETB(x)		(((x) - dev->dma_base[BANK_R_CTX]) >> MFC_OFFSET_SHIFT)
 
 /* Allocate temporary buffers for decoding */
 static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
@@ -41,7 +41,7 @@ static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 	int ret;
 
 	ctx->dsc.size = buf_size->dsc;
-	ret =  s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->dsc);
+	ret =  s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &ctx->dsc);
 	if (ret) {
 		mfc_err("Failed to allocate temporary buffer\n");
 		return ret;
@@ -172,7 +172,7 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
 
-		ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->bank1);
+		ret = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 temporary buffer\n");
 			return ret;
@@ -181,7 +181,7 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	}
 	/* Allocate only if memory from bank 2 is necessary */
 	if (ctx->bank2.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev, BANK2_CTX, &ctx->bank2);
+		ret = s5p_mfc_alloc_priv_buf(dev, BANK_R_CTX, &ctx->bank2);
 		if (ret) {
 			mfc_err("Failed to allocate Bank2 temporary buffer\n");
 			s5p_mfc_release_priv_buf(ctx->dev, &ctx->bank1);
@@ -212,7 +212,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 	else
 		ctx->ctx.size = buf_size->non_h264_ctx;
 
-	ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -225,7 +225,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 
 	/* Initialize shared memory */
 	ctx->shm.size = buf_size->shm;
-	ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->shm);
+	ret = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &ctx->shm);
 	if (ret) {
 		mfc_err("Failed to allocate shared memory buffer\n");
 		s5p_mfc_release_priv_buf(dev, &ctx->ctx);
@@ -233,7 +233,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* shared memory offset only keeps the offset from base (port a) */
-	ctx->shm.ofs = ctx->shm.dma - dev->dma_base[BANK1_CTX];
+	ctx->shm.ofs = ctx->shm.dma - dev->dma_base[BANK_L_CTX];
 	BUG_ON(ctx->shm.ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
 
 	memset(ctx->shm.virt, 0, buf_size->shm);
@@ -532,9 +532,9 @@ static void s5p_mfc_get_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
-	*y_addr = dev->dma_base[BANK2_CTX] +
+	*y_addr = dev->dma_base[BANK_R_CTX] +
 		  (mfc_read(dev, S5P_FIMV_ENCODED_Y_ADDR) << MFC_OFFSET_SHIFT);
-	*c_addr = dev->dma_base[BANK2_CTX] +
+	*c_addr = dev->dma_base[BANK_R_CTX] +
 		  (mfc_read(dev, S5P_FIMV_ENCODED_C_ADDR) << MFC_OFFSET_SHIFT);
 }
 
@@ -1212,8 +1212,8 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	}
 	if (list_empty(&ctx->src_queue)) {
 		/* send null frame */
-		s5p_mfc_set_enc_frame_buffer_v5(ctx, dev->dma_base[BANK2_CTX],
-						dev->dma_base[BANK2_CTX]);
+		s5p_mfc_set_enc_frame_buffer_v5(ctx, dev->dma_base[BANK_R_CTX],
+						dev->dma_base[BANK_R_CTX]);
 		src_mb = NULL;
 	} else {
 		src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
@@ -1222,8 +1222,8 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 		if (src_mb->b->vb2_buf.planes[0].bytesused == 0) {
 			/* send null frame */
 			s5p_mfc_set_enc_frame_buffer_v5(ctx,
-						dev->dma_base[BANK2_CTX],
-						dev->dma_base[BANK2_CTX]);
+						dev->dma_base[BANK_R_CTX],
+						dev->dma_base[BANK_R_CTX]);
 			ctx->state = MFCINST_FINISHING;
 		} else {
 			src_y_addr = vb2_dma_contig_plane_dma_addr(
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 50cc9351d1af..70071a12db16 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -239,7 +239,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->bank1);
+		ret = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 memory\n");
 			return ret;
@@ -291,7 +291,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	}
 
-	ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -320,7 +320,7 @@ static int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 	mfc_debug_enter();
 
 	dev->ctx_buf.size = buf_size->dev_ctx;
-	ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &dev->ctx_buf);
+	ret = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &dev->ctx_buf);
 	if (ret) {
 		mfc_err("Failed to allocate device context buffer\n");
 		return ret;
-- 
1.9.1

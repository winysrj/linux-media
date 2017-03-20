Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:32748 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753642AbdCTK5O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:57:14 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v3 04/16] media: s5p-mfc: Replace bank1/bank2 entries with an
 array
Date: Mon, 20 Mar 2017 11:56:30 +0100
Message-id: <1490007402-30265-5-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170320105650eucas1p299820f40e39d09fe4a1591917dd8fc6c@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Internal MFC driver device structure contains two entries for keeping
addresses of the DMA memory banks. Replace them with the dma_base[] array
and use defines for accessing particular banks. This will help to simplify
code in the next patches.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>
Tested-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  6 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 27 +++++++++++-------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 38 +++++++++++++------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 10 +++----
 4 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 27d4c864e06e..da601a2dba2f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -273,8 +273,7 @@ struct s5p_mfc_priv_buf {
  * @queue:		waitqueue for waiting for completion of device commands
  * @fw_size:		size of firmware
  * @fw_virt_addr:	virtual firmware address
- * @bank1:		address of the beginning of bank 1 memory
- * @bank2:		address of the beginning of bank 2 memory
+ * @dma_base[]:		address of the beginning of memory banks
  * @hw_lock:		used for hardware locking
  * @ctx:		array of driver contexts
  * @curr_ctx:		number of the currently running context
@@ -315,8 +314,7 @@ struct s5p_mfc_dev {
 	wait_queue_head_t queue;
 	size_t fw_size;
 	void *fw_virt_addr;
-	dma_addr_t bank1;
-	dma_addr_t bank2;
+	dma_addr_t dma_base[BANK_CTX_NUM];
 	unsigned long hw_lock;
 	struct s5p_mfc_ctx *ctx[MFC_NUM_CONTEXTS];
 	int curr_ctx;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index cd1406c75d9a..c9bff3d0655f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -38,8 +38,8 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 	}
 
 	dev->fw_virt_addr = dma_alloc_coherent(dev->mem_dev[BANK1_CTX],
-					dev->fw_size, &dev->bank1, GFP_KERNEL);
-
+					dev->fw_size, &dev->dma_base[BANK1_CTX],
+					GFP_KERNEL);
 	if (!dev->fw_virt_addr) {
 		mfc_err("Allocating bitprocessor buffer failed\n");
 		return -ENOMEM;
@@ -52,7 +52,8 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		if (!bank2_virt) {
 			mfc_err("Allocating bank2 base failed\n");
 			dma_free_coherent(dev->mem_dev[BANK1_CTX], dev->fw_size,
-					  dev->fw_virt_addr, dev->bank1);
+					  dev->fw_virt_addr,
+					  dev->dma_base[BANK1_CTX]);
 			dev->fw_virt_addr = NULL;
 			return -ENOMEM;
 		}
@@ -61,7 +62,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		 * should not have address of bank2 - MFC will treat it as a null frame.
 		 * To avoid such situation we set bank2 address below the pool address.
 		 */
-		dev->bank2 = bank2_dma_addr - align_size;
+		dev->dma_base[BANK2_CTX] = bank2_dma_addr - align_size;
 
 		dma_free_coherent(dev->mem_dev[BANK2_CTX], align_size,
 				  bank2_virt, bank2_dma_addr);
@@ -70,7 +71,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		/* In this case bank2 can point to the same address as bank1.
 		 * Firmware will always occupy the beginning of this area so it is
 		 * impossible having a video frame buffer with zero address. */
-		dev->bank2 = dev->bank1;
+		dev->dma_base[BANK2_CTX] = dev->dma_base[BANK1_CTX];
 	}
 	return 0;
 }
@@ -125,7 +126,7 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
 	if (!dev->fw_virt_addr)
 		return -EINVAL;
 	dma_free_coherent(dev->mem_dev[BANK1_CTX], dev->fw_size,
-			  dev->fw_virt_addr, dev->bank1);
+			  dev->fw_virt_addr, dev->dma_base[BANK1_CTX]);
 	dev->fw_virt_addr = NULL;
 	return 0;
 }
@@ -211,13 +212,17 @@ int s5p_mfc_reset(struct s5p_mfc_dev *dev)
 static inline void s5p_mfc_init_memctrl(struct s5p_mfc_dev *dev)
 {
 	if (IS_MFCV6_PLUS(dev)) {
-		mfc_write(dev, dev->bank1, S5P_FIMV_RISC_BASE_ADDRESS_V6);
-		mfc_debug(2, "Base Address : %pad\n", &dev->bank1);
+		mfc_write(dev, dev->dma_base[BANK1_CTX],
+			  S5P_FIMV_RISC_BASE_ADDRESS_V6);
+		mfc_debug(2, "Base Address : %pad\n",
+			  &dev->dma_base[BANK1_CTX]);
 	} else {
-		mfc_write(dev, dev->bank1, S5P_FIMV_MC_DRAMBASE_ADR_A);
-		mfc_write(dev, dev->bank2, S5P_FIMV_MC_DRAMBASE_ADR_B);
+		mfc_write(dev, dev->dma_base[BANK1_CTX],
+			  S5P_FIMV_MC_DRAMBASE_ADR_A);
+		mfc_write(dev, dev->dma_base[BANK2_CTX],
+			  S5P_FIMV_MC_DRAMBASE_ADR_B);
 		mfc_debug(2, "Bank1: %pad, Bank2: %pad\n",
-				&dev->bank1, &dev->bank2);
+			  &dev->dma_base[BANK1_CTX], &dev->dma_base[BANK2_CTX]);
 	}
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 65dd3e64b4db..32ce9ade2edb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -30,8 +30,8 @@
 #include <linux/mm.h>
 #include <linux/sched.h>
 
-#define OFFSETA(x)		(((x) - dev->bank1) >> MFC_OFFSET_SHIFT)
-#define OFFSETB(x)		(((x) - dev->bank2) >> MFC_OFFSET_SHIFT)
+#define OFFSETA(x)		(((x) - dev->dma_base[BANK1_CTX]) >> MFC_OFFSET_SHIFT)
+#define OFFSETB(x)		(((x) - dev->dma_base[BANK2_CTX]) >> MFC_OFFSET_SHIFT)
 
 /* Allocate temporary buffers for decoding */
 static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
@@ -41,8 +41,8 @@ static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 	int ret;
 
 	ctx->dsc.size = buf_size->dsc;
-	ret =  s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
-				      &ctx->dsc);
+	ret =  s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
+				      dev->dma_base[BANK1_CTX], &ctx->dsc);
 	if (ret) {
 		mfc_err("Failed to allocate temporary buffer\n");
 		return ret;
@@ -174,7 +174,7 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	if (ctx->bank1.size > 0) {
 
 		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-					     dev->bank1, &ctx->bank1);
+				     dev->dma_base[BANK1_CTX], &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 temporary buffer\n");
 			return ret;
@@ -184,7 +184,7 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	/* Allocate only if memory from bank 2 is necessary */
 	if (ctx->bank2.size > 0) {
 		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK2_CTX],
-					     dev->bank2, &ctx->bank2);
+				     dev->dma_base[BANK2_CTX], &ctx->bank2);
 		if (ret) {
 			mfc_err("Failed to allocate Bank2 temporary buffer\n");
 			s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX],
@@ -216,8 +216,8 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 	else
 		ctx->ctx.size = buf_size->non_h264_ctx;
 
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
-				     &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
+				     dev->dma_base[BANK1_CTX], &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -230,8 +230,8 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 
 	/* Initialize shared memory */
 	ctx->shm.size = buf_size->shm;
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
-				     &ctx->shm);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
+				     dev->dma_base[BANK1_CTX], &ctx->shm);
 	if (ret) {
 		mfc_err("Failed to allocate shared memory buffer\n");
 		s5p_mfc_release_priv_buf(dev->mem_dev[BANK1_CTX], &ctx->ctx);
@@ -239,7 +239,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* shared memory offset only keeps the offset from base (port a) */
-	ctx->shm.ofs = ctx->shm.dma - dev->bank1;
+	ctx->shm.ofs = ctx->shm.dma - dev->dma_base[BANK1_CTX];
 	BUG_ON(ctx->shm.ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
 
 	memset(ctx->shm.virt, 0, buf_size->shm);
@@ -538,10 +538,10 @@ static void s5p_mfc_get_enc_frame_buffer_v5(struct s5p_mfc_ctx *ctx,
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 
-	*y_addr = dev->bank2 + (mfc_read(dev, S5P_FIMV_ENCODED_Y_ADDR)
-							<< MFC_OFFSET_SHIFT);
-	*c_addr = dev->bank2 + (mfc_read(dev, S5P_FIMV_ENCODED_C_ADDR)
-							<< MFC_OFFSET_SHIFT);
+	*y_addr = dev->dma_base[BANK2_CTX] +
+		  (mfc_read(dev, S5P_FIMV_ENCODED_Y_ADDR) << MFC_OFFSET_SHIFT);
+	*c_addr = dev->dma_base[BANK2_CTX] +
+		  (mfc_read(dev, S5P_FIMV_ENCODED_C_ADDR) << MFC_OFFSET_SHIFT);
 }
 
 /* Set encoding ref & codec buffer */
@@ -1218,7 +1218,8 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 	}
 	if (list_empty(&ctx->src_queue)) {
 		/* send null frame */
-		s5p_mfc_set_enc_frame_buffer_v5(ctx, dev->bank2, dev->bank2);
+		s5p_mfc_set_enc_frame_buffer_v5(ctx, dev->dma_base[BANK2_CTX],
+						dev->dma_base[BANK2_CTX]);
 		src_mb = NULL;
 	} else {
 		src_mb = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
@@ -1226,8 +1227,9 @@ static int s5p_mfc_run_enc_frame(struct s5p_mfc_ctx *ctx)
 		src_mb->flags |= MFC_BUF_FLAG_USED;
 		if (src_mb->b->vb2_buf.planes[0].bytesused == 0) {
 			/* send null frame */
-			s5p_mfc_set_enc_frame_buffer_v5(ctx, dev->bank2,
-								dev->bank2);
+			s5p_mfc_set_enc_frame_buffer_v5(ctx,
+						dev->dma_base[BANK2_CTX],
+						dev->dma_base[BANK2_CTX]);
 			ctx->state = MFCINST_FINISHING;
 		} else {
 			src_y_addr = vb2_dma_contig_plane_dma_addr(
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index e23ca08e88c5..f1a6a3539549 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -240,7 +240,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
 		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-					     dev->bank1, &ctx->bank1);
+					dev->dma_base[BANK1_CTX], &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 memory\n");
 			return ret;
@@ -292,8 +292,8 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	}
 
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
-				     &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
+				     dev->dma_base[BANK1_CTX], &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -322,8 +322,8 @@ static int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 	mfc_debug_enter();
 
 	dev->ctx_buf.size = buf_size->dev_ctx;
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
-				     &dev->ctx_buf);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
+				     dev->dma_base[BANK1_CTX], &dev->ctx_buf);
 	if (ret) {
 		mfc_err("Failed to allocate device context buffer\n");
 		return ret;
-- 
1.9.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27534 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753344AbdCTK5K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Mar 2017 06:57:10 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v3 03/16] media: s5p-mfc: Replace mem_dev_* entries with an
 array
Date: Mon, 20 Mar 2017 11:56:29 +0100
Message-id: <1490007402-30265-4-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170320105650eucas1p16eab3e05a99c2ce8464687400b47d09e@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Internal MFC driver device structure contains two pointers to devices used
for DMA memory allocation: mem_dev_l and mem_dev_r. Replace them with the
mem_dev[] array and use defines for accessing particular banks. This will
help to simplify code in the next patches.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
Acked-by: Andrzej Hajda <a.hajda@samsung.com>
Tested-by: Smitha T Murthy <smitha.t@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 31 +++++++++++++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h | 11 ++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c   | 23 +++++++++---------
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c    |  8 +++----
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 10 ++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 32 ++++++++++++++-----------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 15 ++++++------
 7 files changed, 69 insertions(+), 61 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index af223b0a41a3..c03ed1a737b7 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1118,7 +1118,8 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 		int ret = exynos_configure_iommu(dev, S5P_MFC_IOMMU_DMA_BASE,
 						 S5P_MFC_IOMMU_DMA_SIZE);
 		if (ret == 0)
-			mfc_dev->mem_dev_l = mfc_dev->mem_dev_r = dev;
+			mfc_dev->mem_dev[BANK1_CTX] =
+				mfc_dev->mem_dev[BANK2_CTX] = dev;
 		return ret;
 	}
 
@@ -1126,14 +1127,14 @@ static int s5p_mfc_configure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 	 * Create and initialize virtual devices for accessing
 	 * reserved memory regions.
 	 */
-	mfc_dev->mem_dev_l = s5p_mfc_alloc_memdev(dev, "left",
-						  MFC_BANK1_ALLOC_CTX);
-	if (!mfc_dev->mem_dev_l)
+	mfc_dev->mem_dev[BANK1_CTX] = s5p_mfc_alloc_memdev(dev, "left",
+							   BANK1_CTX);
+	if (!mfc_dev->mem_dev[BANK1_CTX])
 		return -ENODEV;
-	mfc_dev->mem_dev_r = s5p_mfc_alloc_memdev(dev, "right",
-						  MFC_BANK2_ALLOC_CTX);
-	if (!mfc_dev->mem_dev_r) {
-		device_unregister(mfc_dev->mem_dev_l);
+	mfc_dev->mem_dev[BANK2_CTX] = s5p_mfc_alloc_memdev(dev, "right",
+							   BANK2_CTX);
+	if (!mfc_dev->mem_dev[BANK2_CTX]) {
+		device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
 		return -ENODEV;
 	}
 
@@ -1149,8 +1150,8 @@ static void s5p_mfc_unconfigure_dma_memory(struct s5p_mfc_dev *mfc_dev)
 		return;
 	}
 
-	device_unregister(mfc_dev->mem_dev_l);
-	device_unregister(mfc_dev->mem_dev_r);
+	device_unregister(mfc_dev->mem_dev[BANK1_CTX]);
+	device_unregister(mfc_dev->mem_dev[BANK2_CTX]);
 }
 
 /* MFC probe function */
@@ -1208,8 +1209,10 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 		goto err_dma;
 	}
 
-	vb2_dma_contig_set_max_seg_size(dev->mem_dev_l, DMA_BIT_MASK(32));
-	vb2_dma_contig_set_max_seg_size(dev->mem_dev_r, DMA_BIT_MASK(32));
+	vb2_dma_contig_set_max_seg_size(dev->mem_dev[BANK1_CTX],
+					DMA_BIT_MASK(32));
+	vb2_dma_contig_set_max_seg_size(dev->mem_dev[BANK2_CTX],
+					DMA_BIT_MASK(32));
 
 	mutex_init(&dev->mfc_mutex);
 	init_waitqueue_head(&dev->queue);
@@ -1343,8 +1346,8 @@ static int s5p_mfc_remove(struct platform_device *pdev)
 	v4l2_device_unregister(&dev->v4l2_dev);
 	s5p_mfc_release_firmware(dev);
 	s5p_mfc_unconfigure_dma_memory(dev);
-	vb2_dma_contig_clear_max_seg_size(dev->mem_dev_l);
-	vb2_dma_contig_clear_max_seg_size(dev->mem_dev_r);
+	vb2_dma_contig_clear_max_seg_size(dev->mem_dev[BANK1_CTX]);
+	vb2_dma_contig_clear_max_seg_size(dev->mem_dev[BANK2_CTX]);
 
 	s5p_mfc_final_pm(dev);
 	return 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 2f1387a4c386..27d4c864e06e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -33,8 +33,9 @@
 *  while mmaping */
 #define DST_QUEUE_OFF_BASE	(1 << 30)
 
-#define MFC_BANK1_ALLOC_CTX	0
-#define MFC_BANK2_ALLOC_CTX	1
+#define BANK1_CTX	0
+#define BANK2_CTX	1
+#define BANK_CTX_NUM	2
 
 #define MFC_BANK1_ALIGN_ORDER	13
 #define MFC_BANK2_ALIGN_ORDER	13
@@ -254,8 +255,7 @@ struct s5p_mfc_priv_buf {
  * @vfd_dec:		video device for decoding
  * @vfd_enc:		video device for encoding
  * @plat_dev:		platform device
- * @mem_dev_l:		child device of the left memory bank (0)
- * @mem_dev_r:		child device of the right memory bank (1)
+ * @mem_dev[]:		child devices of the memory banks
  * @regs_base:		base address of the MFC hw registers
  * @irq:		irq resource
  * @dec_ctrl_handler:	control framework handler for decoding
@@ -297,8 +297,7 @@ struct s5p_mfc_dev {
 	struct video_device	*vfd_dec;
 	struct video_device	*vfd_enc;
 	struct platform_device	*plat_dev;
-	struct device		*mem_dev_l;
-	struct device		*mem_dev_r;
+	struct device		*mem_dev[BANK_CTX_NUM];
 	void __iomem		*regs_base;
 	int			irq;
 	struct v4l2_ctrl_handler dec_ctrl_handler;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index cc888713b3b6..cd1406c75d9a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -28,6 +28,7 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 {
 	void *bank2_virt;
 	dma_addr_t bank2_dma_addr;
+	unsigned int align_size = 1 << MFC_BASE_ALIGN_ORDER;
 
 	dev->fw_size = dev->variant->buf_size->fw;
 
@@ -36,8 +37,8 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		return -ENOMEM;
 	}
 
-	dev->fw_virt_addr = dma_alloc_coherent(dev->mem_dev_l, dev->fw_size,
-					&dev->bank1, GFP_KERNEL);
+	dev->fw_virt_addr = dma_alloc_coherent(dev->mem_dev[BANK1_CTX],
+					dev->fw_size, &dev->bank1, GFP_KERNEL);
 
 	if (!dev->fw_virt_addr) {
 		mfc_err("Allocating bitprocessor buffer failed\n");
@@ -45,13 +46,13 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 	}
 
 	if (HAS_PORTNUM(dev) && IS_TWOPORT(dev)) {
-		bank2_virt = dma_alloc_coherent(dev->mem_dev_r, 1 << MFC_BASE_ALIGN_ORDER,
-					&bank2_dma_addr, GFP_KERNEL);
+		bank2_virt = dma_alloc_coherent(dev->mem_dev[BANK2_CTX],
+				       align_size, &bank2_dma_addr, GFP_KERNEL);
 
 		if (!bank2_virt) {
 			mfc_err("Allocating bank2 base failed\n");
-			dma_free_coherent(dev->mem_dev_l, dev->fw_size,
-				dev->fw_virt_addr, dev->bank1);
+			dma_free_coherent(dev->mem_dev[BANK1_CTX], dev->fw_size,
+					  dev->fw_virt_addr, dev->bank1);
 			dev->fw_virt_addr = NULL;
 			return -ENOMEM;
 		}
@@ -60,10 +61,10 @@ int s5p_mfc_alloc_firmware(struct s5p_mfc_dev *dev)
 		 * should not have address of bank2 - MFC will treat it as a null frame.
 		 * To avoid such situation we set bank2 address below the pool address.
 		 */
-		dev->bank2 = bank2_dma_addr - (1 << MFC_BASE_ALIGN_ORDER);
+		dev->bank2 = bank2_dma_addr - align_size;
 
-		dma_free_coherent(dev->mem_dev_r, 1 << MFC_BASE_ALIGN_ORDER,
-			bank2_virt, bank2_dma_addr);
+		dma_free_coherent(dev->mem_dev[BANK2_CTX], align_size,
+				  bank2_virt, bank2_dma_addr);
 
 	} else {
 		/* In this case bank2 can point to the same address as bank1.
@@ -123,8 +124,8 @@ int s5p_mfc_release_firmware(struct s5p_mfc_dev *dev)
 	 * that MFC is no longer processing */
 	if (!dev->fw_virt_addr)
 		return -EINVAL;
-	dma_free_coherent(dev->mem_dev_l, dev->fw_size, dev->fw_virt_addr,
-						dev->bank1);
+	dma_free_coherent(dev->mem_dev[BANK1_CTX], dev->fw_size,
+			  dev->fw_virt_addr, dev->bank1);
 	dev->fw_virt_addr = NULL;
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 367ef8e8dbf0..f17062f9070b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -931,14 +931,14 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[1] = ctx->chroma_size;
 
 		if (IS_MFCV6_PLUS(dev))
-			alloc_devs[0] = ctx->dev->mem_dev_l;
+			alloc_devs[0] = ctx->dev->mem_dev[BANK1_CTX];
 		else
-			alloc_devs[0] = ctx->dev->mem_dev_r;
-		alloc_devs[1] = ctx->dev->mem_dev_l;
+			alloc_devs[0] = ctx->dev->mem_dev[BANK2_CTX];
+		alloc_devs[1] = ctx->dev->mem_dev[BANK1_CTX];
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
 		   ctx->state == MFCINST_INIT) {
 		psize[0] = ctx->dec_src_buf_size;
-		alloc_devs[0] = ctx->dev->mem_dev_l;
+		alloc_devs[0] = ctx->dev->mem_dev[BANK1_CTX];
 	} else {
 		mfc_err("This video node is dedicated to decoding. Decoding not initialized\n");
 		return -EINVAL;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index e39d9e06e299..2eea21f06d7e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1832,7 +1832,7 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		if (*buf_count > MFC_MAX_BUFFERS)
 			*buf_count = MFC_MAX_BUFFERS;
 		psize[0] = ctx->enc_dst_buf_size;
-		alloc_devs[0] = ctx->dev->mem_dev_l;
+		alloc_devs[0] = ctx->dev->mem_dev[BANK1_CTX];
 	} else if (vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		if (ctx->src_fmt)
 			*plane_count = ctx->src_fmt->num_planes;
@@ -1848,11 +1848,11 @@ static int s5p_mfc_queue_setup(struct vb2_queue *vq,
 		psize[1] = ctx->chroma_size;
 
 		if (IS_MFCV6_PLUS(dev)) {
-			alloc_devs[0] = ctx->dev->mem_dev_l;
-			alloc_devs[1] = ctx->dev->mem_dev_l;
+			alloc_devs[0] = ctx->dev->mem_dev[BANK1_CTX];
+			alloc_devs[1] = ctx->dev->mem_dev[BANK1_CTX];
 		} else {
-			alloc_devs[0] = ctx->dev->mem_dev_r;
-			alloc_devs[1] = ctx->dev->mem_dev_r;
+			alloc_devs[0] = ctx->dev->mem_dev[BANK2_CTX];
+			alloc_devs[1] = ctx->dev->mem_dev[BANK2_CTX];
 		}
 	} else {
 		mfc_err("invalid queue type: %d\n", vq->type);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index f4301d5bbd32..65dd3e64b4db 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -41,7 +41,8 @@ static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 	int ret;
 
 	ctx->dsc.size = buf_size->dsc;
-	ret =  s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1, &ctx->dsc);
+	ret =  s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
+				      &ctx->dsc);
 	if (ret) {
 		mfc_err("Failed to allocate temporary buffer\n");
 		return ret;
@@ -57,7 +58,7 @@ static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 /* Release temporary buffers for decoding */
 static void s5p_mfc_release_dec_desc_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->dsc);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->dsc);
 }
 
 /* Allocate codec buffers */
@@ -172,8 +173,8 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
 
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1,
-					     &ctx->bank1);
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
+					     dev->bank1, &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 temporary buffer\n");
 			return ret;
@@ -182,11 +183,12 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	}
 	/* Allocate only if memory from bank 2 is necessary */
 	if (ctx->bank2.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_r, dev->bank2,
-					     &ctx->bank2);
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK2_CTX],
+					     dev->bank2, &ctx->bank2);
 		if (ret) {
 			mfc_err("Failed to allocate Bank2 temporary buffer\n");
-			s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
+			s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX],
+						 &ctx->bank1);
 			return ret;
 		}
 		BUG_ON(ctx->bank2.dma & ((1 << MFC_BANK2_ALIGN_ORDER) - 1));
@@ -197,8 +199,8 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 /* Release buffers allocated for codec */
 static void s5p_mfc_release_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_r, &ctx->bank2);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->bank1);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK2_CTX], &ctx->bank2);
 }
 
 /* Allocate memory for instance data buffer */
@@ -214,7 +216,8 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 	else
 		ctx->ctx.size = buf_size->non_h264_ctx;
 
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1, &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
+				     &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -227,10 +230,11 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 
 	/* Initialize shared memory */
 	ctx->shm.size = buf_size->shm;
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1, &ctx->shm);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
+				     &ctx->shm);
 	if (ret) {
 		mfc_err("Failed to allocate shared memory buffer\n");
-		s5p_mfc_release_priv_buf(dev->mem_dev_l, &ctx->ctx);
+		s5p_mfc_release_priv_buf(dev->mem_dev[BANK1_CTX], &ctx->ctx);
 		return ret;
 	}
 
@@ -246,8 +250,8 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 /* Release instance buffer */
 static void s5p_mfc_release_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->ctx);
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->shm);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->ctx);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->shm);
 }
 
 static int s5p_mfc_alloc_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index fc4598021e43..e23ca08e88c5 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -239,8 +239,8 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1,
-					     &ctx->bank1);
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
+					     dev->bank1, &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 memory\n");
 			return ret;
@@ -253,7 +253,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 /* Release buffers allocated for codec */
 static void s5p_mfc_release_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->bank1);
 }
 
 /* Allocate memory for instance data buffer */
@@ -292,7 +292,8 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	}
 
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1, &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
+				     &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -309,7 +310,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 /* Release instance buffer */
 static void s5p_mfc_release_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->ctx);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->ctx);
 }
 
 /* Allocate context buffers for SYS_INIT */
@@ -321,7 +322,7 @@ static int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 	mfc_debug_enter();
 
 	dev->ctx_buf.size = buf_size->dev_ctx;
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1,
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX], dev->bank1,
 				     &dev->ctx_buf);
 	if (ret) {
 		mfc_err("Failed to allocate device context buffer\n");
@@ -339,7 +340,7 @@ static int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 /* Release context buffers for SYS_INIT */
 static void s5p_mfc_release_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 {
-	s5p_mfc_release_priv_buf(dev->mem_dev_l, &dev->ctx_buf);
+	s5p_mfc_release_priv_buf(dev->mem_dev[BANK1_CTX], &dev->ctx_buf);
 }
 
 static int calc_plane(int width, int height)
-- 
1.9.1

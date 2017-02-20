Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23438 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752683AbdBTNjR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Feb 2017 08:39:17 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH v2 05/15] media: s5p-mfc: Simplify alloc/release private buffer
 functions
Date: Mon, 20 Feb 2017 14:38:54 +0100
Message-id: <1487597944-2000-6-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
References: <1487597944-2000-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170220133913eucas1p1389444e1df79cd8c48157fd64212257b@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change parameters for s5p_mfc_alloc_priv_buf() and s5p_mfc_release_priv_buf()
functions. Instead of DMA device pointer and a base, provide common MFC
device structure and memory bank context identifier.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Javier Martinez Canillas <javier@osg.samsung.com>
Tested-by: Javier Martinez Canillas <javier@osg.samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    | 20 +++++++++++------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  8 +++----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 30 ++++++++++---------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 15 +++++--------
 5 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index da601a2dba2f..9cf860f34c71 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -240,12 +240,14 @@ struct s5p_mfc_variant {
  *			buffer accessed by driver
  * @dma:		DMA address, only valid when kernel DMA API used
  * @size:		size of the buffer
+ * @ctx:		memory context (bank) used for this allocation
  */
 struct s5p_mfc_priv_buf {
 	unsigned long	ofs;
 	void		*virt;
 	dma_addr_t	dma;
 	size_t		size;
+	unsigned int	ctx;
 };
 
 /**
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 99f65a92a6be..9294ee124661 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -37,12 +37,16 @@ void s5p_mfc_init_regs(struct s5p_mfc_dev *dev)
 		dev->mfc_regs = s5p_mfc_init_regs_v6_plus(dev);
 }
 
-int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
-					struct s5p_mfc_priv_buf *b)
+int s5p_mfc_alloc_priv_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
+			   struct s5p_mfc_priv_buf *b)
 {
+	struct device *mem_dev = dev->mem_dev[mem_ctx];
+	dma_addr_t base = dev->dma_base[mem_ctx];
+
 	mfc_debug(3, "Allocating priv: %zu\n", b->size);
 
-	b->virt = dma_alloc_coherent(dev, b->size, &b->dma, GFP_KERNEL);
+	b->ctx = mem_ctx;
+	b->virt = dma_alloc_coherent(mem_dev, b->size, &b->dma, GFP_KERNEL);
 
 	if (!b->virt) {
 		mfc_err("Allocating private buffer of size %zu failed\n",
@@ -53,7 +57,7 @@ int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
 	if (b->dma < base) {
 		mfc_err("Invalid memory configuration - buffer (%pad) is below base memory address(%pad)\n",
 			&b->dma, &base);
-		dma_free_coherent(dev, b->size, b->virt, b->dma);
+		dma_free_coherent(mem_dev, b->size, b->virt, b->dma);
 		return -ENOMEM;
 	}
 
@@ -61,11 +65,13 @@ int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
 	return 0;
 }
 
-void s5p_mfc_release_priv_buf(struct device *dev,
-						struct s5p_mfc_priv_buf *b)
+void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
+			      struct s5p_mfc_priv_buf *b)
 {
+	struct device *mem_dev = dev->mem_dev[b->ctx];
+
 	if (b->virt) {
-		dma_free_coherent(dev, b->size, b->virt, b->dma);
+		dma_free_coherent(mem_dev, b->size, b->virt, b->dma);
 		b->virt = NULL;
 		b->dma = 0;
 		b->size = 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index b6ac417ab63e..108e59382e0c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -315,10 +315,10 @@ struct s5p_mfc_hw_ops {
 
 void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev);
 void s5p_mfc_init_regs(struct s5p_mfc_dev *dev);
-int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
-					struct s5p_mfc_priv_buf *b);
-void s5p_mfc_release_priv_buf(struct device *dev,
-					struct s5p_mfc_priv_buf *b);
+int s5p_mfc_alloc_priv_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
+			   struct s5p_mfc_priv_buf *b);
+void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
+			      struct s5p_mfc_priv_buf *b);
 
 
 #endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 32ce9ade2edb..20e8a1bdc984 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -41,8 +41,7 @@ static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 	int ret;
 
 	ctx->dsc.size = buf_size->dsc;
-	ret =  s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-				      dev->dma_base[BANK1_CTX], &ctx->dsc);
+	ret =  s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->dsc);
 	if (ret) {
 		mfc_err("Failed to allocate temporary buffer\n");
 		return ret;
@@ -58,7 +57,7 @@ static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 /* Release temporary buffers for decoding */
 static void s5p_mfc_release_dec_desc_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->dsc);
+	s5p_mfc_release_priv_buf(ctx->dev, &ctx->dsc);
 }
 
 /* Allocate codec buffers */
@@ -173,8 +172,7 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
 
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-				     dev->dma_base[BANK1_CTX], &ctx->bank1);
+		ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 temporary buffer\n");
 			return ret;
@@ -183,12 +181,10 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	}
 	/* Allocate only if memory from bank 2 is necessary */
 	if (ctx->bank2.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK2_CTX],
-				     dev->dma_base[BANK2_CTX], &ctx->bank2);
+		ret = s5p_mfc_alloc_priv_buf(dev, BANK2_CTX, &ctx->bank2);
 		if (ret) {
 			mfc_err("Failed to allocate Bank2 temporary buffer\n");
-			s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX],
-						 &ctx->bank1);
+			s5p_mfc_release_priv_buf(ctx->dev, &ctx->bank1);
 			return ret;
 		}
 		BUG_ON(ctx->bank2.dma & ((1 << MFC_BANK2_ALIGN_ORDER) - 1));
@@ -199,8 +195,8 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 /* Release buffers allocated for codec */
 static void s5p_mfc_release_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->bank1);
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK2_CTX], &ctx->bank2);
+	s5p_mfc_release_priv_buf(ctx->dev, &ctx->bank1);
+	s5p_mfc_release_priv_buf(ctx->dev, &ctx->bank2);
 }
 
 /* Allocate memory for instance data buffer */
@@ -216,8 +212,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 	else
 		ctx->ctx.size = buf_size->non_h264_ctx;
 
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-				     dev->dma_base[BANK1_CTX], &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -230,11 +225,10 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 
 	/* Initialize shared memory */
 	ctx->shm.size = buf_size->shm;
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-				     dev->dma_base[BANK1_CTX], &ctx->shm);
+	ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->shm);
 	if (ret) {
 		mfc_err("Failed to allocate shared memory buffer\n");
-		s5p_mfc_release_priv_buf(dev->mem_dev[BANK1_CTX], &ctx->ctx);
+		s5p_mfc_release_priv_buf(dev, &ctx->ctx);
 		return ret;
 	}
 
@@ -250,8 +244,8 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 /* Release instance buffer */
 static void s5p_mfc_release_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->ctx);
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->shm);
+	s5p_mfc_release_priv_buf(ctx->dev, &ctx->ctx);
+	s5p_mfc_release_priv_buf(ctx->dev, &ctx->shm);
 }
 
 static int s5p_mfc_alloc_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 51053ed68741..4e5ead236455 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -239,8 +239,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-					dev->dma_base[BANK1_CTX], &ctx->bank1);
+		ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 memory\n");
 			return ret;
@@ -253,7 +252,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 /* Release buffers allocated for codec */
 static void s5p_mfc_release_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->bank1);
+	s5p_mfc_release_priv_buf(ctx->dev, &ctx->bank1);
 }
 
 /* Allocate memory for instance data buffer */
@@ -292,8 +291,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	}
 
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-				     dev->dma_base[BANK1_CTX], &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -310,7 +308,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 /* Release instance buffer */
 static void s5p_mfc_release_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev->mem_dev[BANK1_CTX], &ctx->ctx);
+	s5p_mfc_release_priv_buf(ctx->dev, &ctx->ctx);
 }
 
 /* Allocate context buffers for SYS_INIT */
@@ -322,8 +320,7 @@ static int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 	mfc_debug_enter();
 
 	dev->ctx_buf.size = buf_size->dev_ctx;
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev[BANK1_CTX],
-				     dev->dma_base[BANK1_CTX], &dev->ctx_buf);
+	ret = s5p_mfc_alloc_priv_buf(dev, BANK1_CTX, &dev->ctx_buf);
 	if (ret) {
 		mfc_err("Failed to allocate device context buffer\n");
 		return ret;
@@ -340,7 +337,7 @@ static int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 /* Release context buffers for SYS_INIT */
 static void s5p_mfc_release_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 {
-	s5p_mfc_release_priv_buf(dev->mem_dev[BANK1_CTX], &dev->ctx_buf);
+	s5p_mfc_release_priv_buf(dev, &dev->ctx_buf);
 }
 
 static int calc_plane(int width, int height)
-- 
1.9.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57415 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbbFCKgi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jun 2015 06:36:38 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NPD00LWL6SZ3R80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Jun 2015 11:36:35 +0100 (BST)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 2/2] media: s5p-mfc: add additional check for incorrect memory
 configuration
Date: Wed, 03 Jun 2015 12:36:23 +0200
Message-id: <1433327783-29552-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1433327783-29552-1-git-send-email-m.szyprowski@samsung.com>
References: <1433327783-29552-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC hardware is known to trash random memory if one tries to use a
buffer buffer, which has lower DMA addresses than the configured DMA
base address. This patch adds a check for this case and proper error
handling.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    | 11 +++++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c | 12 +++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  8 +++++---
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 00a1d8b..8d27f88 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -37,10 +37,9 @@ void s5p_mfc_init_regs(struct s5p_mfc_dev *dev)
 		dev->mfc_regs = s5p_mfc_init_regs_v6_plus(dev);
 }
 
-int s5p_mfc_alloc_priv_buf(struct device *dev,
+int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
 					struct s5p_mfc_priv_buf *b)
 {
-
 	mfc_debug(3, "Allocating priv: %zu\n", b->size);
 
 	b->virt = dma_alloc_coherent(dev, b->size, &b->dma, GFP_KERNEL);
@@ -50,6 +49,14 @@ int s5p_mfc_alloc_priv_buf(struct device *dev,
 		return -ENOMEM;
 	}
 
+	if (b->dma < base) {
+		mfc_err("Invaling memory configuration!\n");
+		mfc_err("Allocated buffer (%pad) is lower than memory base addres (%pad)\n",
+			&b->dma, &base);
+		dma_free_coherent(dev, b->size, b->virt, b->dma);
+		return -ENOMEM;
+	}
+
 	mfc_debug(3, "Allocated addr %p %pad\n", b->virt, &b->dma);
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 22dfb3e..77a08b1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -334,7 +334,7 @@ struct s5p_mfc_hw_ops {
 
 void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev);
 void s5p_mfc_init_regs(struct s5p_mfc_dev *dev);
-int s5p_mfc_alloc_priv_buf(struct device *dev,
+int s5p_mfc_alloc_priv_buf(struct device *dev, dma_addr_t base,
 					struct s5p_mfc_priv_buf *b);
 void s5p_mfc_release_priv_buf(struct device *dev,
 					struct s5p_mfc_priv_buf *b);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index c7adc3d..b3f6700 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -41,7 +41,7 @@ static int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 	int ret;
 
 	ctx->dsc.size = buf_size->dsc;
-	ret =  s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->dsc);
+	ret =  s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1, &ctx->dsc);
 	if (ret) {
 		mfc_err("Failed to allocate temporary buffer\n");
 		return ret;
@@ -172,7 +172,8 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
 
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->bank1);
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1,
+					     &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 temporary buffer\n");
 			return ret;
@@ -181,7 +182,8 @@ static int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	}
 	/* Allocate only if memory from bank 2 is necessary */
 	if (ctx->bank2.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_r, &ctx->bank2);
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_r, dev->bank2,
+					     &ctx->bank2);
 		if (ret) {
 			mfc_err("Failed to allocate Bank2 temporary buffer\n");
 			s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
@@ -212,7 +214,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 	else
 		ctx->ctx.size = buf_size->non_h264_ctx;
 
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1, &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -225,7 +227,7 @@ static int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 
 	/* Initialize shared memory */
 	ctx->shm.size = buf_size->shm;
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->shm);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1, &ctx->shm);
 	if (ret) {
 		mfc_err("Failed to allocate shared memory buffer\n");
 		s5p_mfc_release_priv_buf(dev->mem_dev_l, &ctx->ctx);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index cefad18..ed6b14c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -239,7 +239,8 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->bank1);
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1,
+					     &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 memory\n");
 			return ret;
@@ -291,7 +292,7 @@ static int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	}
 
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->ctx);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1, &ctx->ctx);
 	if (ret) {
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
@@ -320,7 +321,8 @@ static int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 	mfc_debug_enter();
 
 	dev->ctx_buf.size = buf_size->dev_ctx;
-	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &dev->ctx_buf);
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, dev->bank1,
+				     &dev->ctx_buf);
 	if (ret) {
 		mfc_err("Failed to allocate device context buffer\n");
 		return ret;
-- 
1.9.2


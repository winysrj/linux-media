Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:54845 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3ACLGY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 06:06:24 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG100HUGQU6CKX0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jan 2013 20:06:22 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG100FOEQU7KHB0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jan 2013 20:06:22 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 3/3 RESEND] s5p-mfc: Change internal buffer allocation from vb2
 ops to dma_alloc_coherent
Date: Thu, 03 Jan 2013 12:06:04 +0100
Message-id: <1357211164-27443-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1357211164-27443-1-git-send-email-k.debski@samsung.com>
References: <1357211164-27443-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Change internal buffer allocation from vb2 memory ops call to direct
calls of dma_alloc_coherent. This change shortens the code and makes it
much more readable.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |   20 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    |   30 ++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |    5 +
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |  196 ++++++++---------------
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  121 +++++---------
 5 files changed, 143 insertions(+), 229 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 2298d27..4e1a28c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -495,15 +495,9 @@ struct s5p_mfc_codec_ops {
  *			flushed
  * @head_processed:	flag mentioning whether the header data is processed
  *			completely or not
- * @bank1_buf:		handle to memory allocated for temporary buffers from
+ * @bank1:		handle to memory allocated for temporary buffers from
  *			memory bank 1
- * @bank1_phys:		address of the temporary buffers from memory bank 1
- * @bank1_size:		size of the memory allocated for temporary buffers from
- *			memory bank 1
- * @bank2_buf:		handle to memory allocated for temporary buffers from
- *			memory bank 2
- * @bank2_phys:		address of the temporary buffers from memory bank 2
- * @bank2_size:		size of the memory allocated for temporary buffers from
+ * @bank2:		handle to memory allocated for temporary buffers from
  *			memory bank 2
  * @capture_state:	state of the capture buffers queue
  * @output_state:	state of the output buffers queue
@@ -583,14 +577,8 @@ struct s5p_mfc_ctx {
 	unsigned int dpb_flush_flag;
 	unsigned int head_processed;
 
-	/* Buffers */
-	void *bank1_buf;
-	size_t bank1_phys;
-	size_t bank1_size;
-
-	void *bank2_buf;
-	size_t bank2_phys;
-	size_t bank2_size;
+	struct s5p_mfc_priv_buf bank1;
+	struct s5p_mfc_priv_buf bank2;
 
 	enum s5p_mfc_queue_state capture_state;
 	enum s5p_mfc_queue_state output_state;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 6932e90..b4c1943 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -12,6 +12,7 @@
  * published by the Free Software Foundation.
  */
 
+#include "s5p_mfc_debug.h"
 #include "s5p_mfc_opr.h"
 #include "s5p_mfc_opr_v5.h"
 #include "s5p_mfc_opr_v6.h"
@@ -29,3 +30,32 @@ void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev)
 	}
 	dev->mfc_ops = s5p_mfc_ops;
 }
+
+int s5p_mfc_alloc_priv_buf(struct device *dev,
+					struct s5p_mfc_priv_buf *b)
+{
+
+	mfc_debug(3, "Allocating priv: %d\n", b->size);
+
+	b->virt = dma_alloc_coherent(dev, b->size, &b->dma, GFP_KERNEL);
+
+	if (!b->virt) {
+		mfc_err("Allocating private buffer failed\n");
+		return -ENOMEM;
+	}
+
+	mfc_debug(3, "Allocated addr %p %08x\n", b->virt, b->dma);
+	return 0;
+}
+
+void s5p_mfc_release_priv_buf(struct device *dev,
+						struct s5p_mfc_priv_buf *b)
+{
+	if (b->virt) {
+		dma_free_coherent(dev, b->size, b->virt, b->dma);
+		b->virt = 0;
+		b->dma = 0;
+		b->size = 0;
+	}
+}
+
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 420abec..754c540 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -80,5 +80,10 @@ struct s5p_mfc_hw_ops {
 };
 
 void s5p_mfc_init_hw_ops(struct s5p_mfc_dev *dev);
+int s5p_mfc_alloc_priv_buf(struct device *dev,
+					struct s5p_mfc_priv_buf *b);
+void s5p_mfc_release_priv_buf(struct device *dev,
+					struct s5p_mfc_priv_buf *b);
+
 
 #endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index bf7d010..15f40e4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -38,39 +38,26 @@ int s5p_mfc_alloc_dec_temp_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
+	int ret;
 
-	ctx->dsc.alloc = vb2_dma_contig_memops.alloc(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX],
-			buf_size->dsc);
-	if (IS_ERR_VALUE((int)ctx->dsc.alloc)) {
-		ctx->dsc.alloc = NULL;
-		mfc_err("Allocating DESC buffer failed\n");
-		return -ENOMEM;
+	ctx->dsc.size = buf_size->dsc;
+	ret =  s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->dsc);
+	if (ret) {
+		mfc_err("Failed to allocate temporary buffer\n");
+		return ret;
 	}
-	ctx->dsc.dma = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->dsc.alloc);
+
 	BUG_ON(ctx->dsc.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
-	ctx->dsc.virt = vb2_dma_contig_memops.vaddr(ctx->dsc.alloc);
-	if (ctx->dsc.virt == NULL) {
-		vb2_dma_contig_memops.put(ctx->dsc.alloc);
-		ctx->dsc.dma = 0;
-		ctx->dsc.alloc = NULL;
-		mfc_err("Remapping DESC buffer failed\n");
-		return -ENOMEM;
-	}
-	memset(ctx->dsc.virt, 0, buf_size->dsc);
+	memset(ctx->dsc.virt, 0, ctx->dsc.size);
 	wmb();
 	return 0;
 }
 
+
 /* Release temporary buffers for decoding */
 void s5p_mfc_release_dec_desc_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->dsc.dma) {
-		vb2_dma_contig_memops.put(ctx->dsc.alloc);
-		ctx->dsc.alloc = NULL;
-		ctx->dsc.dma = 0;
-	}
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->dsc);
 }
 
 /* Allocate codec buffers */
@@ -80,6 +67,7 @@ int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	unsigned int enc_ref_y_size = 0;
 	unsigned int enc_ref_c_size = 0;
 	unsigned int guard_width, guard_height;
+	int ret;
 
 	if (ctx->type == MFCINST_DECODER) {
 		mfc_debug(2, "Luma size:%d Chroma size:%d MV size:%d\n",
@@ -113,100 +101,93 @@ int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 	/* Codecs have different memory requirements */
 	switch (ctx->codec_mode) {
 	case S5P_MFC_CODEC_H264_DEC:
-		ctx->bank1_size =
+		ctx->bank1.size =
 		    ALIGN(S5P_FIMV_DEC_NB_IP_SIZE +
 					S5P_FIMV_DEC_VERT_NB_MV_SIZE,
 					S5P_FIMV_DEC_BUF_ALIGN);
-		ctx->bank2_size = ctx->total_dpb_count * ctx->mv_size;
+		ctx->bank2.size = ctx->total_dpb_count * ctx->mv_size;
 		break;
 	case S5P_MFC_CODEC_MPEG4_DEC:
-		ctx->bank1_size =
+		ctx->bank1.size =
 		    ALIGN(S5P_FIMV_DEC_NB_DCAC_SIZE +
 				     S5P_FIMV_DEC_UPNB_MV_SIZE +
 				     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
 				     S5P_FIMV_DEC_STX_PARSER_SIZE +
 				     S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE,
 				     S5P_FIMV_DEC_BUF_ALIGN);
-		ctx->bank2_size = 0;
+		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_VC1RCV_DEC:
 	case S5P_MFC_CODEC_VC1_DEC:
-		ctx->bank1_size =
+		ctx->bank1.size =
 		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
 			     S5P_FIMV_DEC_UPNB_MV_SIZE +
 			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
 			     S5P_FIMV_DEC_NB_DCAC_SIZE +
 			     3 * S5P_FIMV_DEC_VC1_BITPLANE_SIZE,
 			     S5P_FIMV_DEC_BUF_ALIGN);
-		ctx->bank2_size = 0;
+		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_MPEG2_DEC:
-		ctx->bank1_size = 0;
-		ctx->bank2_size = 0;
+		ctx->bank1.size = 0;
+		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_H263_DEC:
-		ctx->bank1_size =
+		ctx->bank1.size =
 		    ALIGN(S5P_FIMV_DEC_OVERLAP_TRANSFORM_SIZE +
 			     S5P_FIMV_DEC_UPNB_MV_SIZE +
 			     S5P_FIMV_DEC_SUB_ANCHOR_MV_SIZE +
 			     S5P_FIMV_DEC_NB_DCAC_SIZE,
 			     S5P_FIMV_DEC_BUF_ALIGN);
-		ctx->bank2_size = 0;
+		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_H264_ENC:
-		ctx->bank1_size = (enc_ref_y_size * 2) +
+		ctx->bank1.size = (enc_ref_y_size * 2) +
 				   S5P_FIMV_ENC_UPMV_SIZE +
 				   S5P_FIMV_ENC_COLFLG_SIZE +
 				   S5P_FIMV_ENC_INTRAMD_SIZE +
 				   S5P_FIMV_ENC_NBORINFO_SIZE;
-		ctx->bank2_size = (enc_ref_y_size * 2) +
+		ctx->bank2.size = (enc_ref_y_size * 2) +
 				   (enc_ref_c_size * 4) +
 				   S5P_FIMV_ENC_INTRAPRED_SIZE;
 		break;
 	case S5P_MFC_CODEC_MPEG4_ENC:
-		ctx->bank1_size = (enc_ref_y_size * 2) +
+		ctx->bank1.size = (enc_ref_y_size * 2) +
 				   S5P_FIMV_ENC_UPMV_SIZE +
 				   S5P_FIMV_ENC_COLFLG_SIZE +
 				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		ctx->bank2_size = (enc_ref_y_size * 2) +
+		ctx->bank2.size = (enc_ref_y_size * 2) +
 				   (enc_ref_c_size * 4);
 		break;
 	case S5P_MFC_CODEC_H263_ENC:
-		ctx->bank1_size = (enc_ref_y_size * 2) +
+		ctx->bank1.size = (enc_ref_y_size * 2) +
 				   S5P_FIMV_ENC_UPMV_SIZE +
 				   S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		ctx->bank2_size = (enc_ref_y_size * 2) +
+		ctx->bank2.size = (enc_ref_y_size * 2) +
 				   (enc_ref_c_size * 4);
 		break;
 	default:
 		break;
 	}
 	/* Allocate only if memory from bank 1 is necessary */
-	if (ctx->bank1_size > 0) {
-		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
-		if (IS_ERR(ctx->bank1_buf)) {
-			ctx->bank1_buf = NULL;
-			printk(KERN_ERR
-			       "Buf alloc for decoding failed (port A)\n");
-			return -ENOMEM;
+	if (ctx->bank1.size > 0) {
+
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->bank1);
+		if (ret) {
+			mfc_err("Failed to allocate Bank1 temporary buffer\n");
+			return ret;
 		}
-		ctx->bank1_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_buf);
-		BUG_ON(ctx->bank1_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+		BUG_ON(ctx->bank1.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
 	}
 	/* Allocate only if memory from bank 2 is necessary */
-	if (ctx->bank2_size > 0) {
-		ctx->bank2_buf = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], ctx->bank2_size);
-		if (IS_ERR(ctx->bank2_buf)) {
-			ctx->bank2_buf = NULL;
-			mfc_err("Buf alloc for decoding failed (port B)\n");
-			return -ENOMEM;
+	if (ctx->bank2.size > 0) {
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_r, &ctx->bank2);
+		if (ret) {
+			mfc_err("Failed to allocate Bank2 temporary buffer\n");
+		s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
+			return ret;
 		}
-		ctx->bank2_phys = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK2_ALLOC_CTX], ctx->bank2_buf);
-		BUG_ON(ctx->bank2_phys & ((1 << MFC_BANK2_ALIGN_ORDER) - 1));
+		BUG_ON(ctx->bank2.dma & ((1 << MFC_BANK2_ALIGN_ORDER) - 1));
 	}
 	return 0;
 }
@@ -214,18 +195,8 @@ int s5p_mfc_alloc_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 /* Release buffers allocated for codec */
 void s5p_mfc_release_codec_buffers_v5(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->bank1_buf) {
-		vb2_dma_contig_memops.put(ctx->bank1_buf);
-		ctx->bank1_buf = NULL;
-		ctx->bank1_phys = 0;
-		ctx->bank1_size = 0;
-	}
-	if (ctx->bank2_buf) {
-		vb2_dma_contig_memops.put(ctx->bank2_buf);
-		ctx->bank2_buf = NULL;
-		ctx->bank2_phys = 0;
-		ctx->bank2_size = 0;
-	}
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_r, &ctx->bank2);
 }
 
 /* Allocate memory for instance data buffer */
@@ -233,58 +204,38 @@ int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf_size_v5 *buf_size = dev->variant->buf_size->priv;
+	int ret;
 
 	if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC ||
 		ctx->codec_mode == S5P_MFC_CODEC_H264_ENC)
 		ctx->ctx.size = buf_size->h264_ctx;
 	else
 		ctx->ctx.size = buf_size->non_h264_ctx;
-	ctx->ctx.alloc = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.size);
-	if (IS_ERR(ctx->ctx.alloc)) {
-		mfc_err("Allocating context buffer failed\n");
-		ctx->ctx.alloc = NULL;
-		return -ENOMEM;
+
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->ctx);
+	if (ret) {
+		mfc_err("Failed to allocate instance buffer\n");
+		return ret;
 	}
-	ctx->ctx.dma = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.alloc);
-	BUG_ON(ctx->ctx.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
 	ctx->ctx.ofs = OFFSETA(ctx->ctx.dma);
-	ctx->ctx.virt = vb2_dma_contig_memops.vaddr(ctx->ctx.alloc);
-	if (!ctx->ctx.virt) {
-		mfc_err("Remapping instance buffer failed\n");
-		vb2_dma_contig_memops.put(ctx->ctx.alloc);
-		ctx->ctx.alloc = NULL;
-		ctx->ctx.ofs = 0;
-		ctx->ctx.dma = 0;
-		return -ENOMEM;
-	}
+
 	/* Zero content of the allocated memory */
 	memset(ctx->ctx.virt, 0, ctx->ctx.size);
 	wmb();
 
 	/* Initialize shared memory */
-	ctx->shm.alloc = vb2_dma_contig_memops.alloc(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], buf_size->shm);
-	if (IS_ERR(ctx->shm.alloc)) {
-		mfc_err("failed to allocate shared memory\n");
-		return PTR_ERR(ctx->shm.alloc);
+	ctx->shm.size = buf_size->shm;
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->shm);
+	if (ret) {
+		mfc_err("Failed to allocate shared memory buffer\n");
+		return ret;
 	}
+
 	/* shared memory offset only keeps the offset from base (port a) */
-	ctx->shm.ofs = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->shm.alloc)
-								- dev->bank1;
+	ctx->shm.ofs = ctx->shm.dma - dev->bank1;
 	BUG_ON(ctx->shm.ofs & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
 
-	ctx->shm.virt = vb2_dma_contig_memops.vaddr(ctx->shm.alloc);
-	if (!ctx->shm.virt) {
-		vb2_dma_contig_memops.put(ctx->shm.alloc);
-		ctx->shm.alloc = NULL;
-		ctx->shm.ofs = 0;
-		mfc_err("failed to virt addr of shared memory\n");
-		return -ENOMEM;
-	}
-	memset((void *)ctx->shm.virt, 0, buf_size->shm);
+	memset(ctx->shm.virt, 0, buf_size->shm);
 	wmb();
 	return 0;
 }
@@ -292,19 +243,8 @@ int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 /* Release instance buffer */
 void s5p_mfc_release_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->ctx.alloc) {
-		vb2_dma_contig_memops.put(ctx->ctx.alloc);
-		ctx->ctx.alloc = NULL;
-		ctx->ctx.ofs = 0;
-		ctx->ctx.virt = NULL;
-		ctx->ctx.dma = 0;
-	}
-	if (ctx->shm.alloc) {
-		vb2_dma_contig_memops.put(ctx->shm.alloc);
-		ctx->shm.alloc = NULL;
-		ctx->shm.ofs = 0;
-		ctx->shm.virt = NULL;
-	}
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->ctx);
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->shm);
 }
 
 int s5p_mfc_alloc_dev_context_buffer_v5(struct s5p_mfc_dev *dev)
@@ -443,10 +383,10 @@ int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 	size_t buf_addr1, buf_addr2;
 	int buf_size1, buf_size2;
 
-	buf_addr1 = ctx->bank1_phys;
-	buf_size1 = ctx->bank1_size;
-	buf_addr2 = ctx->bank2_phys;
-	buf_size2 = ctx->bank2_size;
+	buf_addr1 = ctx->bank1.dma;
+	buf_size1 = ctx->bank1.size;
+	buf_addr2 = ctx->bank2.dma;
+	buf_size2 = ctx->bank2.size;
 	dpb = mfc_read(dev, S5P_FIMV_SI_CH0_DPB_CONF_CTRL) &
 						~S5P_FIMV_DPB_COUNT_MASK;
 	mfc_write(dev, ctx->total_dpb_count | dpb,
@@ -607,10 +547,10 @@ int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 	unsigned int guard_width, guard_height;
 	int i;
 
-	buf_addr1 = ctx->bank1_phys;
-	buf_size1 = ctx->bank1_size;
-	buf_addr2 = ctx->bank2_phys;
-	buf_size2 = ctx->bank2_size;
+	buf_addr1 = ctx->bank1.dma;
+	buf_size1 = ctx->bank1.size;
+	buf_addr2 = ctx->bank2.dma;
+	buf_size2 = ctx->bank2.size;
 	enc_ref_y_size = ALIGN(ctx->img_width, S5P_FIMV_NV12MT_HALIGN)
 		* ALIGN(ctx->img_height, S5P_FIMV_NV12MT_VALIGN);
 	enc_ref_y_size = ALIGN(enc_ref_y_size, S5P_FIMV_NV12MT_SALIGN);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 3a8cfd9..30d91c6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -73,6 +73,7 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	unsigned int mb_width, mb_height;
+	int ret;
 
 	mb_width = MB_WIDTH(ctx->img_width);
 	mb_height = MB_HEIGHT(ctx->img_height);
@@ -112,7 +113,7 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 					mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
-		ctx->bank1_size =
+		ctx->bank1.size =
 			ctx->scratch_buf_size +
 			(ctx->mv_count * ctx->mv_size);
 		break;
@@ -123,7 +124,7 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 					mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
-		ctx->bank1_size = ctx->scratch_buf_size;
+		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
 	case S5P_MFC_CODEC_VC1RCV_DEC:
 	case S5P_MFC_CODEC_VC1_DEC:
@@ -133,11 +134,11 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 					mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
-		ctx->bank1_size = ctx->scratch_buf_size;
+		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
 	case S5P_MFC_CODEC_MPEG2_DEC:
-		ctx->bank1_size = 0;
-		ctx->bank2_size = 0;
+		ctx->bank1.size = 0;
+		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_H263_DEC:
 		ctx->scratch_buf_size =
@@ -146,7 +147,7 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 					mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
-		ctx->bank1_size = ctx->scratch_buf_size;
+		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
 	case S5P_MFC_CODEC_VP8_DEC:
 		ctx->scratch_buf_size =
@@ -155,7 +156,7 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 					mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
-		ctx->bank1_size = ctx->scratch_buf_size;
+		ctx->bank1.size = ctx->scratch_buf_size;
 		break;
 	case S5P_MFC_CODEC_H264_ENC:
 		ctx->scratch_buf_size =
@@ -164,11 +165,11 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 					mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
-		ctx->bank1_size =
+		ctx->bank1.size =
 			ctx->scratch_buf_size + ctx->tmv_buffer_size +
 			(ctx->dpb_count * (ctx->luma_dpb_size +
 			ctx->chroma_dpb_size + ctx->me_buffer_size));
-		ctx->bank2_size = 0;
+		ctx->bank2.size = 0;
 		break;
 	case S5P_MFC_CODEC_MPEG4_ENC:
 	case S5P_MFC_CODEC_H263_ENC:
@@ -178,28 +179,24 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 					mb_height);
 		ctx->scratch_buf_size = ALIGN(ctx->scratch_buf_size,
 				S5P_FIMV_SCRATCH_BUFFER_ALIGN_V6);
-		ctx->bank1_size =
+		ctx->bank1.size =
 			ctx->scratch_buf_size + ctx->tmv_buffer_size +
 			(ctx->dpb_count * (ctx->luma_dpb_size +
 			ctx->chroma_dpb_size + ctx->me_buffer_size));
-		ctx->bank2_size = 0;
+		ctx->bank2.size = 0;
 		break;
 	default:
 		break;
 	}
 
 	/* Allocate only if memory from bank 1 is necessary */
-	if (ctx->bank1_size > 0) {
-		ctx->bank1_buf = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_size);
-		if (IS_ERR(ctx->bank1_buf)) {
-			ctx->bank1_buf = 0;
-			pr_err("Buf alloc for decoding failed (port A)\n");
-			return -ENOMEM;
+	if (ctx->bank1.size > 0) {
+		ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->bank1);
+		if (ret) {
+			mfc_err("Failed to allocate Bank1 memory\n");
+			return ret;
 		}
-		ctx->bank1_phys = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->bank1_buf);
-		BUG_ON(ctx->bank1_phys & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
+		BUG_ON(ctx->bank1.dma & ((1 << MFC_BANK1_ALIGN_ORDER) - 1));
 	}
 
 	return 0;
@@ -208,12 +205,7 @@ int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 /* Release buffers allocated for codec */
 void s5p_mfc_release_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
-	if (ctx->bank1_buf) {
-		vb2_dma_contig_memops.put(ctx->bank1_buf);
-		ctx->bank1_buf = 0;
-		ctx->bank1_phys = 0;
-		ctx->bank1_size = 0;
-	}
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->bank1);
 }
 
 /* Allocate memory for instance data buffer */
@@ -221,6 +213,7 @@ int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
 	struct s5p_mfc_dev *dev = ctx->dev;
 	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
+	int ret;
 
 	mfc_debug_enter();
 
@@ -250,25 +243,10 @@ int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 		break;
 	}
 
-	ctx->ctx.alloc = vb2_dma_contig_memops.alloc(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.size);
-	if (IS_ERR(ctx->ctx.alloc)) {
-		mfc_err("Allocating context buffer failed.\n");
-		return PTR_ERR(ctx->ctx.alloc);
-	}
-
-	ctx->ctx.dma = s5p_mfc_mem_cookie(
-		dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], ctx->ctx.alloc);
-
-	ctx->ctx.virt = vb2_dma_contig_memops.vaddr(ctx->ctx.alloc);
-	if (!ctx->ctx.virt) {
-		vb2_dma_contig_memops.put(ctx->ctx.alloc);
-		ctx->ctx.alloc = NULL;
-		ctx->ctx.dma = 0;
-		ctx->ctx.virt = NULL;
-
-		mfc_err("Remapping context buffer failed.\n");
-		return -ENOMEM;
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &ctx->ctx);
+	if (ret) {
+		mfc_err("Failed to allocate instance buffer\n");
+		return ret;
 	}
 
 	memset(ctx->ctx.virt, 0, ctx->ctx.size);
@@ -282,44 +260,22 @@ int s5p_mfc_alloc_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 /* Release instance buffer */
 void s5p_mfc_release_instance_buffer_v6(struct s5p_mfc_ctx *ctx)
 {
-	mfc_debug_enter();
-
-	if (ctx->ctx.alloc) {
-		vb2_dma_contig_memops.put(ctx->ctx.alloc);
-		ctx->ctx.alloc = NULL;
-		ctx->ctx.dma = 0;
-		ctx->ctx.virt = NULL;
-	}
-
-	mfc_debug_leave();
+	s5p_mfc_release_priv_buf(ctx->dev->mem_dev_l, &ctx->ctx);
 }
 
 /* Allocate context buffers for SYS_INIT */
 int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 {
 	struct s5p_mfc_buf_size_v6 *buf_size = dev->variant->buf_size->priv;
+	int ret;
 
 	mfc_debug_enter();
 
-	dev->ctx_buf.alloc = vb2_dma_contig_memops.alloc(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX], buf_size->dev_ctx);
-	if (IS_ERR(dev->ctx_buf.alloc)) {
-		mfc_err("Allocating DESC buffer failed.\n");
-		return PTR_ERR(dev->ctx_buf.alloc);
-	}
-
-	dev->ctx_buf.dma = s5p_mfc_mem_cookie(
-			dev->alloc_ctx[MFC_BANK1_ALLOC_CTX],
-			dev->ctx_buf.alloc);
-
-	dev->ctx_buf.virt = vb2_dma_contig_memops.vaddr(dev->ctx_buf.alloc);
-	if (!dev->ctx_buf.virt) {
-		vb2_dma_contig_memops.put(dev->ctx_buf.alloc);
-		dev->ctx_buf.alloc = NULL;
-		dev->ctx_buf.dma = 0;
-
-		mfc_err("Remapping DESC buffer failed.\n");
-		return -ENOMEM;
+	dev->ctx_buf.size = buf_size->dev_ctx;
+	ret = s5p_mfc_alloc_priv_buf(dev->mem_dev_l, &dev->ctx_buf);
+	if (ret) {
+		mfc_err("Failed to allocate device context buffer\n");
+		return ret;
 	}
 
 	memset(dev->ctx_buf.virt, 0, buf_size->dev_ctx);
@@ -333,12 +289,7 @@ int s5p_mfc_alloc_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 /* Release context buffers for SYS_INIT */
 void s5p_mfc_release_dev_context_buffer_v6(struct s5p_mfc_dev *dev)
 {
-	if (dev->ctx_buf.alloc) {
-		vb2_dma_contig_memops.put(dev->ctx_buf.alloc);
-		dev->ctx_buf.alloc = NULL;
-		dev->ctx_buf.dma = 0;
-		dev->ctx_buf.virt = NULL;
-	}
+	s5p_mfc_release_priv_buf(dev->mem_dev_l, &dev->ctx_buf);
 }
 
 static int calc_plane(int width, int height)
@@ -417,8 +368,8 @@ int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 	int buf_size1;
 	int align_gap;
 
-	buf_addr1 = ctx->bank1_phys;
-	buf_size1 = ctx->bank1_size;
+	buf_addr1 = ctx->bank1.dma;
+	buf_size1 = ctx->bank1.size;
 
 	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
 	mfc_debug(2, "Total DPB COUNT: %d\n", ctx->total_dpb_count);
@@ -540,8 +491,8 @@ int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 
 	mfc_debug_enter();
 
-	buf_addr1 = ctx->bank1_phys;
-	buf_size1 = ctx->bank1_size;
+	buf_addr1 = ctx->bank1.dma;
+	buf_size1 = ctx->bank1.size;
 
 	mfc_debug(2, "Buf1: %p (%d)\n", (void *)buf_addr1, buf_size1);
 
-- 
1.7.9.5


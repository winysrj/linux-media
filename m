Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbaIXXY5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 19:24:57 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCHv2 2/2] [media] s5p-mfc: Fix several printk warnings
Date: Wed, 24 Sep 2014 20:24:29 -0300
Message-Id: <930b6dd5b89db1dfffda9c55a001607c62339d5d.1411601060.git.mchehab@osg.samsung.com>
In-Reply-To: <fe8cf45259509ecd981732901b4b74579c1ccc19.1411601060.git.mchehab@osg.samsung.com>
References: <fe8cf45259509ecd981732901b4b74579c1ccc19.1411601060.git.mchehab@osg.samsung.com>
In-Reply-To: <fe8cf45259509ecd981732901b4b74579c1ccc19.1411601060.git.mchehab@osg.samsung.com>
References: <fe8cf45259509ecd981732901b4b74579c1ccc19.1411601060.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:192:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 4 has type ‘dma_addr_t’ [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:196:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 4 has type ‘dma_addr_t’ [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c:196:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘dma_addr_t’ [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1206:4: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1206:32: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1757:3: warning: format ‘%zx’ expects argument of type ‘size_t’, but argument 6 has type ‘dma_addr_t’ [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_enc.c:1879:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1206:4: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:1206:32: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
index 3c10e31d017b..0c885a8a0e9f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_ctrl.c
@@ -189,12 +189,12 @@ static inline void s5p_mfc_init_memctrl(struct s5p_mfc_dev *dev)
 {
 	if (IS_MFCV6_PLUS(dev)) {
 		mfc_write(dev, dev->bank1, S5P_FIMV_RISC_BASE_ADDRESS_V6);
-		mfc_debug(2, "Base Address : %08x\n", dev->bank1);
+		mfc_debug(2, "Base Address : %pad\n", &dev->bank1);
 	} else {
 		mfc_write(dev, dev->bank1, S5P_FIMV_MC_DRAMBASE_ADR_A);
 		mfc_write(dev, dev->bank2, S5P_FIMV_MC_DRAMBASE_ADR_B);
-		mfc_debug(2, "Bank1: %08x, Bank2: %08x\n",
-				dev->bank1, dev->bank2);
+		mfc_debug(2, "Bank1: %pad, Bank2: %pad\n",
+				&dev->bank1, &dev->bank2);
 	}
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 77eb952a744a..a98fe023deaf 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1202,7 +1202,7 @@ void s5p_mfc_dec_init(struct s5p_mfc_ctx *ctx)
 	else
 		f.fmt.pix_mp.pixelformat = V4L2_PIX_FMT_NV12MT;
 	ctx->dst_fmt = find_format(&f, MFC_FMT_RAW);
-	mfc_debug(2, "Default src_fmt is %x, dest_fmt is %x\n",
-			(unsigned int)ctx->src_fmt, (unsigned int)ctx->dst_fmt);
+	mfc_debug(2, "Default src_fmt is %p, dest_fmt is %p\n",
+			ctx->src_fmt, ctx->dst_fmt);
 }
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index adffdb37746b..a904a1c7bb21 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1750,13 +1750,13 @@ static int check_vb_with_fmt(struct s5p_mfc_fmt *fmt, struct vb2_buffer *vb)
 		return -EINVAL;
 	}
 	for (i = 0; i < fmt->num_planes; i++) {
-		if (!vb2_dma_contig_plane_dma_addr(vb, i)) {
+		dma_addr_t dma = vb2_dma_contig_plane_dma_addr(vb, i);
+		if (!dma) {
 			mfc_err("failed to get plane cookie\n");
 			return -EINVAL;
 		}
-		mfc_debug(2, "index: %d, plane[%d] cookie: 0x%08zx\n",
-			  vb->v4l2_buf.index, i,
-			  vb2_dma_contig_plane_dma_addr(vb, i));
+		mfc_debug(2, "index: %d, plane[%d] cookie: %pad\n",
+			  vb->v4l2_buf.index, i, &dma);
 	}
 	return 0;
 }
@@ -1876,7 +1876,7 @@ static int s5p_mfc_buf_prepare(struct vb2_buffer *vb)
 		ret = check_vb_with_fmt(ctx->dst_fmt, vb);
 		if (ret < 0)
 			return ret;
-		mfc_debug(2, "plane size: %ld, dst size: %d\n",
+		mfc_debug(2, "plane size: %ld, dst size: %zu\n",
 			vb2_plane_size(vb, 0), ctx->enc_dst_buf_size);
 		if (vb2_plane_size(vb, 0) < ctx->enc_dst_buf_size) {
 			mfc_err("plane size is too small for capture\n");
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 90e3d61c1b59..7cf07963187d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -567,7 +567,7 @@ static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 		enc_ref_c_size = ALIGN(guard_width * guard_height,
 				       S5P_FIMV_NV12MT_SALIGN);
 	}
-	mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n", buf_size1, buf_size2);
+	mfc_debug(2, "buf_size1: %zu, buf_size2: %zu\n", buf_size1, buf_size2);
 	switch (ctx->codec_mode) {
 	case S5P_MFC_CODEC_H264_ENC:
 		for (i = 0; i < 2; i++) {
@@ -606,7 +606,7 @@ static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 					S5P_FIMV_H264_NBOR_INFO_ADR);
 		buf_addr1 += S5P_FIMV_ENC_NBORINFO_SIZE;
 		buf_size1 -= S5P_FIMV_ENC_NBORINFO_SIZE;
-		mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n",
+		mfc_debug(2, "buf_size1: %zu, buf_size2: %zu\n",
 			buf_size1, buf_size2);
 		break;
 	case S5P_MFC_CODEC_MPEG4_ENC:
@@ -637,7 +637,7 @@ static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 						S5P_FIMV_MPEG4_ACDC_COEF_ADR);
 		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
 		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n",
+		mfc_debug(2, "buf_size1: %zu, buf_size2: %zu\n",
 			buf_size1, buf_size2);
 		break;
 	case S5P_MFC_CODEC_H263_ENC:
@@ -663,7 +663,7 @@ static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_ACDC_COEF_ADR);
 		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
 		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n",
+		mfc_debug(2, "buf_size1: %zu, buf_size2: %zu\n",
 			buf_size1, buf_size2);
 		break;
 	default:
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 89de7a6daa5b..8798b14bacce 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -100,7 +100,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 						mb_width, mb_height),
 						S5P_FIMV_ME_BUFFER_ALIGN_V6);
 
-		mfc_debug(2, "recon luma size: %zd chroma size: %zd\n",
+		mfc_debug(2, "recon luma size: %zu chroma size: %zu\n",
 			  ctx->luma_dpb_size, ctx->chroma_dpb_size);
 	} else {
 		return -EINVAL;
-- 
1.9.3


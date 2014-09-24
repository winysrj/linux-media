Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34180 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaIXW14 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:56 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 13/18] [media] s5p_mfc_opr_v5: Fix lots of warnings on x86_64
Date: Wed, 24 Sep 2014 19:27:13 -0300
Message-Id: <5824d4d8b177c3778cea8ef5e345d126e6c46767.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When compiled on x86_64, several warnings popup:

drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:476:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:480:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:485:4: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 4 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:493:2: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:570:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:570:2: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:609:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:609:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:640:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:640:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:666:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat=]
drivers/media//platform/s5p-mfc/s5p_mfc_opr_v5.c:666:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 6234e4d70596..90e3d61c1b59 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -473,16 +473,16 @@ static int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 								frame_size_mv);
 	for (i = 0; i < ctx->total_dpb_count; i++) {
 		/* Bank2 */
-		mfc_debug(2, "Luma %d: %x\n", i,
+		mfc_debug(2, "Luma %d: %zx\n", i,
 					ctx->dst_bufs[i].cookie.raw.luma);
 		mfc_write(dev, OFFSETB(ctx->dst_bufs[i].cookie.raw.luma),
 						S5P_FIMV_DEC_LUMA_ADR + i * 4);
-		mfc_debug(2, "\tChroma %d: %x\n", i,
+		mfc_debug(2, "\tChroma %d: %zx\n", i,
 					ctx->dst_bufs[i].cookie.raw.chroma);
 		mfc_write(dev, OFFSETA(ctx->dst_bufs[i].cookie.raw.chroma),
 					       S5P_FIMV_DEC_CHROMA_ADR + i * 4);
 		if (ctx->codec_mode == S5P_MFC_CODEC_H264_DEC) {
-			mfc_debug(2, "\tBuf2: %x, size: %d\n",
+			mfc_debug(2, "\tBuf2: %zx, size: %d\n",
 							buf_addr2, buf_size2);
 			mfc_write(dev, OFFSETB(buf_addr2),
 						S5P_FIMV_H264_MV_ADR + i * 4);
@@ -490,7 +490,7 @@ static int s5p_mfc_set_dec_frame_buffer_v5(struct s5p_mfc_ctx *ctx)
 			buf_size2 -= frame_size_mv;
 		}
 	}
-	mfc_debug(2, "Buf1: %u, buf_size1: %d\n", buf_addr1, buf_size1);
+	mfc_debug(2, "Buf1: %zu, buf_size1: %d\n", buf_addr1, buf_size1);
 	mfc_debug(2, "Buf 1/2 size after: %d/%d (frames %d)\n",
 			buf_size1,  buf_size2, ctx->total_dpb_count);
 	if (buf_size1 < 0 || buf_size2 < 0) {
@@ -567,7 +567,7 @@ static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 		enc_ref_c_size = ALIGN(guard_width * guard_height,
 				       S5P_FIMV_NV12MT_SALIGN);
 	}
-	mfc_debug(2, "buf_size1: %d, buf_size2: %d\n", buf_size1, buf_size2);
+	mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n", buf_size1, buf_size2);
 	switch (ctx->codec_mode) {
 	case S5P_MFC_CODEC_H264_ENC:
 		for (i = 0; i < 2; i++) {
@@ -606,7 +606,7 @@ static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 					S5P_FIMV_H264_NBOR_INFO_ADR);
 		buf_addr1 += S5P_FIMV_ENC_NBORINFO_SIZE;
 		buf_size1 -= S5P_FIMV_ENC_NBORINFO_SIZE;
-		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+		mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n",
 			buf_size1, buf_size2);
 		break;
 	case S5P_MFC_CODEC_MPEG4_ENC:
@@ -637,7 +637,7 @@ static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 						S5P_FIMV_MPEG4_ACDC_COEF_ADR);
 		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
 		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+		mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n",
 			buf_size1, buf_size2);
 		break;
 	case S5P_MFC_CODEC_H263_ENC:
@@ -663,7 +663,7 @@ static int s5p_mfc_set_enc_ref_buffer_v5(struct s5p_mfc_ctx *ctx)
 		mfc_write(dev, OFFSETA(buf_addr1), S5P_FIMV_H263_ACDC_COEF_ADR);
 		buf_addr1 += S5P_FIMV_ENC_ACDCCOEF_SIZE;
 		buf_size1 -= S5P_FIMV_ENC_ACDCCOEF_SIZE;
-		mfc_debug(2, "buf_size1: %d, buf_size2: %d\n",
+		mfc_debug(2, "buf_size1: %zd, buf_size2: %zd\n",
 			buf_size1, buf_size2);
 		break;
 	default:
-- 
1.9.3


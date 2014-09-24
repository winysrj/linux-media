Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbaIXW1y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:54 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 14/18] [media] s5p_mfc_opr_v6: get rid of warnings when compiled with 64 bits
Date: Wed, 24 Sep 2014 19:27:14 -0300
Message-Id: <dda7cdbd99166519fd47e676915573ced63ec488.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
In-Reply-To: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
References: <c8634fac0c56cfaa9bdad29d541e95b17c049c0a.1411597610.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several errors related to size_t size and the usage of
unsigned int for pointers:

drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_alloc_codec_buffers_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:103:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 4 has type ‘size_t’ [-Wformat=]
   mfc_debug(2, "recon luma size: %d chroma size: %d\n",
   ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:103:3: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_set_dec_frame_buffer_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:472:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘size_t’ [-Wformat=]
   mfc_debug(2, "Luma %d: %x\n", i,
   ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:476:3: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 5 has type ‘size_t’ [-Wformat=]
   mfc_debug(2, "\tChroma %d: %x\n", i,
   ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:490:4: warning: format ‘%x’ expects argument of type ‘unsigned int’, but argument 4 has type ‘size_t’ [-Wformat=]
    mfc_debug(2, "\tBuf1: %x, size: %d\n",
    ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:498:2: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘size_t’ [-Wformat=]
  mfc_debug(2, "Buf1: %u, buf_size1: %d (frames %d)\n",
  ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_set_enc_ref_buffer_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:596:2: warning: format ‘%u’ expects argument of type ‘unsigned int’, but argument 4 has type ‘size_t’ [-Wformat=]
  mfc_debug(2, "Buf1: %u, buf_size1: %d (ref frames %d)\n",
  ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_write_info_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1883:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  writel(data, (volatile void __iomem *)ofs);
               ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_read_info_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:1893:14: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
  ret = readl((volatile void __iomem *)ofs);
              ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_get_pic_type_top_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2022:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   (__force unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_top);
   ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_get_pic_type_bot_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2028:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   (__force unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_bot);
   ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_get_crop_info_h_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2034:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   (__force unsigned int) ctx->dev->mfc_regs->d_display_crop_info1);
   ^
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c: In function ‘s5p_mfc_get_crop_info_v_v6’:
drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c:2040:3: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   (__force unsigned int) ctx->dev->mfc_regs->d_display_crop_info2);

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index e38d78f21726..89de7a6daa5b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -100,7 +100,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 						mb_width, mb_height),
 						S5P_FIMV_ME_BUFFER_ALIGN_V6);
 
-		mfc_debug(2, "recon luma size: %d chroma size: %d\n",
+		mfc_debug(2, "recon luma size: %zd chroma size: %zd\n",
 			  ctx->luma_dpb_size, ctx->chroma_dpb_size);
 	} else {
 		return -EINVAL;
@@ -469,11 +469,11 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 
 	for (i = 0; i < ctx->total_dpb_count; i++) {
 		/* Bank2 */
-		mfc_debug(2, "Luma %d: %x\n", i,
+		mfc_debug(2, "Luma %d: %zx\n", i,
 					ctx->dst_bufs[i].cookie.raw.luma);
 		writel(ctx->dst_bufs[i].cookie.raw.luma,
 				mfc_regs->d_first_plane_dpb + i * 4);
-		mfc_debug(2, "\tChroma %d: %x\n", i,
+		mfc_debug(2, "\tChroma %d: %zx\n", i,
 					ctx->dst_bufs[i].cookie.raw.chroma);
 		writel(ctx->dst_bufs[i].cookie.raw.chroma,
 				mfc_regs->d_second_plane_dpb + i * 4);
@@ -487,7 +487,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 			align_gap = buf_addr1 - align_gap;
 			buf_size1 -= align_gap;
 
-			mfc_debug(2, "\tBuf1: %x, size: %d\n",
+			mfc_debug(2, "\tBuf1: %zx, size: %d\n",
 					buf_addr1, buf_size1);
 			writel(buf_addr1, mfc_regs->d_mv_buffer + i * 4);
 			buf_addr1 += frame_size_mv;
@@ -495,7 +495,7 @@ static int s5p_mfc_set_dec_frame_buffer_v6(struct s5p_mfc_ctx *ctx)
 		}
 	}
 
-	mfc_debug(2, "Buf1: %u, buf_size1: %d (frames %d)\n",
+	mfc_debug(2, "Buf1: %zu, buf_size1: %d (frames %d)\n",
 			buf_addr1, buf_size1, ctx->total_dpb_count);
 	if (buf_size1 < 0) {
 		mfc_debug(2, "Not enough memory has been allocated.\n");
@@ -593,7 +593,7 @@ static int s5p_mfc_set_enc_ref_buffer_v6(struct s5p_mfc_ctx *ctx)
 	buf_addr1 += ctx->tmv_buffer_size >> 1;
 	buf_size1 -= ctx->tmv_buffer_size;
 
-	mfc_debug(2, "Buf1: %u, buf_size1: %d (ref frames %d)\n",
+	mfc_debug(2, "Buf1: %zu, buf_size1: %d (ref frames %d)\n",
 			buf_addr1, buf_size1, ctx->pb_count);
 	if (buf_size1 < 0) {
 		mfc_debug(2, "Not enough memory has been allocated.\n");
@@ -1880,7 +1880,7 @@ static void s5p_mfc_write_info_v6(struct s5p_mfc_ctx *ctx, unsigned int data,
 		unsigned int ofs)
 {
 	s5p_mfc_clock_on();
-	writel(data, (volatile void __iomem *)ofs);
+	writel(data, (volatile void __iomem *)((unsigned long)ofs));
 	s5p_mfc_clock_off();
 }
 
@@ -1890,7 +1890,7 @@ s5p_mfc_read_info_v6(struct s5p_mfc_ctx *ctx, unsigned int ofs)
 	int ret;
 
 	s5p_mfc_clock_on();
-	ret = readl((volatile void __iomem *)ofs);
+	ret = readl((volatile void __iomem *)((unsigned long)ofs));
 	s5p_mfc_clock_off();
 
 	return ret;
@@ -2019,25 +2019,25 @@ static int s5p_mfc_get_mvc_view_id_v6(struct s5p_mfc_dev *dev)
 static unsigned int s5p_mfc_get_pic_type_top_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
-		(__force unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_top);
+		(__force unsigned long) ctx->dev->mfc_regs->d_ret_picture_tag_top);
 }
 
 static unsigned int s5p_mfc_get_pic_type_bot_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
-		(__force unsigned int) ctx->dev->mfc_regs->d_ret_picture_tag_bot);
+		(__force unsigned long) ctx->dev->mfc_regs->d_ret_picture_tag_bot);
 }
 
 static unsigned int s5p_mfc_get_crop_info_h_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
-		(__force unsigned int) ctx->dev->mfc_regs->d_display_crop_info1);
+		(__force unsigned long) ctx->dev->mfc_regs->d_display_crop_info1);
 }
 
 static unsigned int s5p_mfc_get_crop_info_v_v6(struct s5p_mfc_ctx *ctx)
 {
 	return s5p_mfc_read_info_v6(ctx,
-		(__force unsigned int) ctx->dev->mfc_regs->d_display_crop_info2);
+		(__force unsigned long) ctx->dev->mfc_regs->d_display_crop_info2);
 }
 
 static struct s5p_mfc_regs mfc_regs;
-- 
1.9.3


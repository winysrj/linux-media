Return-Path: <SRS0=EeSY=QP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B210C169C4
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 017232084D
	for <linux-media@archiver.kernel.org>; Fri,  8 Feb 2019 16:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfBHQVd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 8 Feb 2019 11:21:33 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:55428 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbfBHQVd (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Feb 2019 11:21:33 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id F105D27F6A8
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 03/10] mtk-vcodec: Correct return type for mem2mem buffer helpers
Date:   Fri,  8 Feb 2019 13:17:41 -0300
Message-Id: <20190208161748.5862-4-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190208161748.5862-1-ezequiel@collabora.com>
References: <20190208161748.5862-1-ezequiel@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Fix the assigned type of mem2mem buffer handling API.
Namely, these functions:

 v4l2_m2m_next_buf
 v4l2_m2m_last_buf
 v4l2_m2m_buf_remove
 v4l2_m2m_next_src_buf
 v4l2_m2m_next_dst_buf
 v4l2_m2m_last_src_buf
 v4l2_m2m_last_dst_buf
 v4l2_m2m_src_buf_remove
 v4l2_m2m_dst_buf_remove

return a struct vb2_v4l2_buffer, and not a struct vb2_buffer.

Fixing this is necessary to fix the mem2mem buffer handling API,
changing the return to the correct struct vb2_v4l2_buffer instead
of a void pointer.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../platform/mtk-vcodec/mtk_vcodec_dec.c      | 62 +++++++---------
 .../platform/mtk-vcodec/mtk_vcodec_enc.c      | 72 ++++++++-----------
 2 files changed, 54 insertions(+), 80 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index ba619647bc10..2a36f0ce6974 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -325,13 +325,12 @@ static void mtk_vdec_worker(struct work_struct *work)
 	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
 				decode_work);
 	struct mtk_vcodec_dev *dev = ctx->dev;
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct mtk_vcodec_mem buf;
 	struct vdec_fb *pfb;
 	bool res_chg = false;
 	int ret;
 	struct mtk_video_dec_buf *dst_buf_info, *src_buf_info;
-	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
 	if (src_buf == NULL) {
@@ -347,26 +346,23 @@ static void mtk_vdec_worker(struct work_struct *work)
 		return;
 	}
 
-	src_vb2_v4l2 = container_of(src_buf, struct vb2_v4l2_buffer, vb2_buf);
-	src_buf_info = container_of(src_vb2_v4l2, struct mtk_video_dec_buf, vb);
-
-	dst_vb2_v4l2 = container_of(dst_buf, struct vb2_v4l2_buffer, vb2_buf);
-	dst_buf_info = container_of(dst_vb2_v4l2, struct mtk_video_dec_buf, vb);
+	src_buf_info = container_of(src_buf, struct mtk_video_dec_buf, vb);
+	dst_buf_info = container_of(dst_buf, struct mtk_video_dec_buf, vb);
 
 	pfb = &dst_buf_info->frame_buffer;
-	pfb->base_y.va = vb2_plane_vaddr(dst_buf, 0);
-	pfb->base_y.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	pfb->base_y.va = vb2_plane_vaddr(&dst_buf->vb2_buf, 0);
+	pfb->base_y.dma_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 	pfb->base_y.size = ctx->picinfo.y_bs_sz + ctx->picinfo.y_len_sz;
 
-	pfb->base_c.va = vb2_plane_vaddr(dst_buf, 1);
-	pfb->base_c.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 1);
+	pfb->base_c.va = vb2_plane_vaddr(&dst_buf->vb2_buf, 1);
+	pfb->base_c.dma_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 1);
 	pfb->base_c.size = ctx->picinfo.c_bs_sz + ctx->picinfo.c_len_sz;
 	pfb->status = 0;
 	mtk_v4l2_debug(3, "===>[%d] vdec_if_decode() ===>", ctx->id);
 
 	mtk_v4l2_debug(3,
 			"id=%d Framebuf  pfb=%p VA=%p Y_DMA=%pad C_DMA=%pad Size=%zx",
-			dst_buf->index, pfb,
+			dst_buf->vb2_buf.index, pfb,
 			pfb->base_y.va, &pfb->base_y.dma_addr,
 			&pfb->base_c.dma_addr, pfb->base_y.size);
 
@@ -384,19 +380,19 @@ static void mtk_vdec_worker(struct work_struct *work)
 		clean_display_buffer(ctx);
 		vb2_set_plane_payload(&dst_buf_info->vb.vb2_buf, 0, 0);
 		vb2_set_plane_payload(&dst_buf_info->vb.vb2_buf, 1, 0);
-		dst_vb2_v4l2->flags |= V4L2_BUF_FLAG_LAST;
+		dst_buf->flags |= V4L2_BUF_FLAG_LAST;
 		v4l2_m2m_buf_done(&dst_buf_info->vb, VB2_BUF_STATE_DONE);
 		clean_free_buffer(ctx);
 		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
 		return;
 	}
-	buf.va = vb2_plane_vaddr(src_buf, 0);
-	buf.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	buf.va = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
+	buf.dma_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
 	buf.size = (size_t)src_buf->planes[0].bytesused;
 	if (!buf.va) {
 		v4l2_m2m_job_finish(dev->m2m_dev_dec, ctx->m2m_ctx);
 		mtk_v4l2_err("[%d] id=%d src_addr is NULL!!",
-				ctx->id, src_buf->index);
+				ctx->id, src_buf->vb2_buf.index);
 		return;
 	}
 	mtk_v4l2_debug(3, "[%d] Bitstream VA=%p DMA=%pad Size=%zx vb=%p",
@@ -416,10 +412,10 @@ static void mtk_vdec_worker(struct work_struct *work)
 		mtk_v4l2_err(
 			" <===[%d], src_buf[%d] sz=0x%zx pts=%llu dst_buf[%d] vdec_if_decode() ret=%d res_chg=%d===>",
 			ctx->id,
-			src_buf->index,
+			src_buf->vb2_buf.index,
 			buf.size,
 			src_buf_info->vb.vb2_buf.timestamp,
-			dst_buf->index,
+			dst_buf->vb2_buf.index,
 			ret, res_chg);
 		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
 		if (ret == -EIO) {
@@ -1103,7 +1099,7 @@ static int vb2ops_vdec_buf_prepare(struct vb2_buffer *vb)
 
 static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 {
-	struct vb2_buffer *src_buf;
+	struct vb2_v4l2_buffer *src_buf;
 	struct mtk_vcodec_mem src_mem;
 	bool res_chg = false;
 	int ret = 0;
@@ -1149,8 +1145,7 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 		mtk_v4l2_err("No src buffer");
 		return;
 	}
-	vb2_v4l2 = to_vb2_v4l2_buffer(src_buf);
-	buf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
+	buf = container_of(src_buf, struct mtk_video_dec_buf, vb);
 	if (buf->lastframe) {
 		/* This shouldn't happen. Just in case. */
 		mtk_v4l2_err("Invalid flush buffer.");
@@ -1158,8 +1153,8 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 		return;
 	}
 
-	src_mem.va = vb2_plane_vaddr(src_buf, 0);
-	src_mem.dma_addr = vb2_dma_contig_plane_dma_addr(src_buf, 0);
+	src_mem.va = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
+	src_mem.dma_addr = vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, 0);
 	src_mem.size = (size_t)src_buf->planes[0].bytesused;
 	mtk_v4l2_debug(2,
 			"[%d] buf id=%d va=%p dma=%pad size=%zx",
@@ -1181,11 +1176,9 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 			mtk_v4l2_err("[%d] Unrecoverable error in vdec_if_decode.",
 					ctx->id);
 			ctx->state = MTK_STATE_ABORT;
-			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
-						VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
 		} else {
-			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
-						VB2_BUF_STATE_DONE);
+			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 		}
 		mtk_v4l2_debug(ret ? 0 : 1,
 			       "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
@@ -1281,7 +1274,7 @@ static int vb2ops_vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 
 static void vb2ops_vdec_stop_streaming(struct vb2_queue *q)
 {
-	struct vb2_buffer *src_buf = NULL, *dst_buf = NULL;
+	struct vb2_v4l2_buffer *src_buf = NULL, *dst_buf = NULL;
 	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
 
 	mtk_v4l2_debug(3, "[%d] (%d) state=(%x) ctx->decoded_frame_cnt=%d",
@@ -1289,12 +1282,10 @@ static void vb2ops_vdec_stop_streaming(struct vb2_queue *q)
 
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
 		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx))) {
-			struct vb2_v4l2_buffer *vb2_v4l2 =
-					to_vb2_v4l2_buffer(src_buf);
 			struct mtk_video_dec_buf *buf_info = container_of(
-					vb2_v4l2, struct mtk_video_dec_buf, vb);
+					src_buf, struct mtk_video_dec_buf, vb);
 			if (!buf_info->lastframe)
-				v4l2_m2m_buf_done(vb2_v4l2,
+				v4l2_m2m_buf_done(src_buf,
 						VB2_BUF_STATE_ERROR);
 		}
 		return;
@@ -1323,10 +1314,9 @@ static void vb2ops_vdec_stop_streaming(struct vb2_queue *q)
 	ctx->state = MTK_STATE_FLUSH;
 
 	while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
-		vb2_set_plane_payload(dst_buf, 0, 0);
-		vb2_set_plane_payload(dst_buf, 1, 0);
-		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
-					VB2_BUF_STATE_ERROR);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, 0);
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 1, 0);
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 	}
 
 }
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index d1f12257bf66..c627202fcffd 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -887,7 +887,7 @@ static int vb2ops_venc_start_streaming(struct vb2_queue *q, unsigned int count)
 static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
 {
 	struct mtk_vcodec_ctx *ctx = vb2_get_drv_priv(q);
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	int ret;
 
 	mtk_v4l2_debug(2, "[%d]-> type=%d", ctx->id, q->type);
@@ -895,13 +895,11 @@ static void vb2ops_venc_stop_streaming(struct vb2_queue *q)
 	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		while ((dst_buf = v4l2_m2m_dst_buf_remove(ctx->m2m_ctx))) {
 			dst_buf->planes[0].bytesused = 0;
-			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
-					VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 		}
 	} else {
 		while ((src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx)))
-			v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
-					VB2_BUF_STATE_ERROR);
+			v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
 	}
 
 	if ((q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
@@ -937,8 +935,7 @@ static int mtk_venc_encode_header(void *priv)
 {
 	struct mtk_vcodec_ctx *ctx = priv;
 	int ret;
-	struct vb2_buffer *src_buf, *dst_buf;
-	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct mtk_vcodec_mem bs_buf;
 	struct venc_done_result enc_result;
 
@@ -948,14 +945,14 @@ static int mtk_venc_encode_header(void *priv)
 		return -EINVAL;
 	}
 
-	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
-	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
+	bs_buf.va = vb2_plane_vaddr(&dst_buf->vb2_buf, 0);
+	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
 	bs_buf.size = (size_t)dst_buf->planes[0].length;
 
 	mtk_v4l2_debug(1,
 			"[%d] buf id=%d va=0x%p dma_addr=0x%llx size=%zu",
 			ctx->id,
-			dst_buf->index, bs_buf.va,
+			dst_buf->vb2_buf.index, bs_buf.va,
 			(u64)bs_buf.dma_addr,
 			bs_buf.size);
 
@@ -964,26 +961,23 @@ static int mtk_venc_encode_header(void *priv)
 			NULL, &bs_buf, &enc_result);
 
 	if (ret) {
-		dst_buf->planes[0].bytesused = 0;
+		dst_buf->vb2_buf.planes[0].bytesused = 0;
 		ctx->state = MTK_STATE_ABORT;
-		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
-				  VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 		mtk_v4l2_err("venc_if_encode failed=%d", ret);
 		return -EINVAL;
 	}
 	src_buf = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
 	if (src_buf) {
-		src_vb2_v4l2 = to_vb2_v4l2_buffer(src_buf);
-		dst_vb2_v4l2 = to_vb2_v4l2_buffer(dst_buf);
-		dst_buf->timestamp = src_buf->timestamp;
-		dst_vb2_v4l2->timecode = src_vb2_v4l2->timecode;
+		dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
+		dst_buf->timecode = src_buf->timecode;
 	} else {
 		mtk_v4l2_err("No timestamp for the header buffer.");
 	}
 
 	ctx->state = MTK_STATE_HEADER;
 	dst_buf->planes[0].bytesused = enc_result.bs_size;
-	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_DONE);
+	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 
 	return 0;
 }
@@ -991,9 +985,7 @@ static int mtk_venc_encode_header(void *priv)
 static int mtk_venc_param_change(struct mtk_vcodec_ctx *ctx)
 {
 	struct venc_enc_param enc_prm;
-	struct vb2_buffer *vb = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
-	struct vb2_v4l2_buffer *vb2_v4l2 =
-			container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
+	struct vb2_v4l2_buffer *vb2_v4l2 = v4l2_m2m_next_src_buf(ctx->m2m_ctx);
 	struct mtk_video_enc_buf *mtk_buf =
 			container_of(vb2_v4l2, struct mtk_video_enc_buf, vb);
 
@@ -1067,12 +1059,11 @@ static void mtk_venc_worker(struct work_struct *work)
 {
 	struct mtk_vcodec_ctx *ctx = container_of(work, struct mtk_vcodec_ctx,
 				    encode_work);
-	struct vb2_buffer *src_buf, *dst_buf;
+	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct venc_frm_buf frm_buf;
 	struct mtk_vcodec_mem bs_buf;
 	struct venc_done_result enc_result;
 	int ret, i;
-	struct vb2_v4l2_buffer *dst_vb2_v4l2, *src_vb2_v4l2;
 
 	/* check dst_buf, dst_buf may be removed in device_run
 	 * to stored encdoe header so we need check dst_buf and
@@ -1086,15 +1077,15 @@ static void mtk_venc_worker(struct work_struct *work)
 
 	src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
 	memset(&frm_buf, 0, sizeof(frm_buf));
-	for (i = 0; i < src_buf->num_planes ; i++) {
+	for (i = 0; i < src_buf->vb2_buf.num_planes ; i++) {
 		frm_buf.fb_addr[i].dma_addr =
-				vb2_dma_contig_plane_dma_addr(src_buf, i);
+				vb2_dma_contig_plane_dma_addr(&src_buf->vb2_buf, i);
 		frm_buf.fb_addr[i].size =
-				(size_t)src_buf->planes[i].length;
+				(size_t)src_buf->vb2_buf.planes[i].length;
 	}
-	bs_buf.va = vb2_plane_vaddr(dst_buf, 0);
-	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(dst_buf, 0);
-	bs_buf.size = (size_t)dst_buf->planes[0].length;
+	bs_buf.va = vb2_plane_vaddr(&dst_buf->vb2_buf, 0);
+	bs_buf.dma_addr = vb2_dma_contig_plane_dma_addr(&dst_buf->vb2_buf, 0);
+	bs_buf.size = (size_t)dst_buf->vb2_buf.planes[0].length;
 
 	mtk_v4l2_debug(2,
 			"Framebuf PA=%llx Size=0x%zx;PA=0x%llx Size=0x%zx;PA=0x%llx Size=%zu",
@@ -1108,28 +1099,21 @@ static void mtk_venc_worker(struct work_struct *work)
 	ret = venc_if_encode(ctx, VENC_START_OPT_ENCODE_FRAME,
 			     &frm_buf, &bs_buf, &enc_result);
 
-	src_vb2_v4l2 = to_vb2_v4l2_buffer(src_buf);
-	dst_vb2_v4l2 = to_vb2_v4l2_buffer(dst_buf);
-
-	dst_buf->timestamp = src_buf->timestamp;
-	dst_vb2_v4l2->timecode = src_vb2_v4l2->timecode;
+	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
+	dst_buf->timecode = src_buf->timecode;
 
 	if (enc_result.is_key_frm)
-		dst_vb2_v4l2->flags |= V4L2_BUF_FLAG_KEYFRAME;
+		dst_buf->flags |= V4L2_BUF_FLAG_KEYFRAME;
 
 	if (ret) {
-		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
-				  VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_ERROR);
 		dst_buf->planes[0].bytesused = 0;
-		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
-				  VB2_BUF_STATE_ERROR);
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_ERROR);
 		mtk_v4l2_err("venc_if_encode failed=%d", ret);
 	} else {
-		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf),
-				  VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
 		dst_buf->planes[0].bytesused = enc_result.bs_size;
-		v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf),
-				  VB2_BUF_STATE_DONE);
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 		mtk_v4l2_debug(2, "venc_if_encode bs size=%d",
 				 enc_result.bs_size);
 	}
@@ -1137,7 +1121,7 @@ static void mtk_venc_worker(struct work_struct *work)
 	v4l2_m2m_job_finish(ctx->dev->m2m_dev_enc, ctx->m2m_ctx);
 
 	mtk_v4l2_debug(1, "<=== src_buf[%d] dst_buf[%d] venc_if_encode ret=%d Size=%u===>",
-			src_buf->index, dst_buf->index, ret,
+			src_buf->vb2_buf.index, dst_buf->vb2_buf.index, ret,
 			enc_result.bs_size);
 }
 
-- 
2.20.1


Return-Path: <SRS0=AYlV=OX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08CDC43612
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 15:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 388222070B
	for <linux-media@archiver.kernel.org>; Fri, 14 Dec 2018 15:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729017AbeLNPng (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 14 Dec 2018 10:43:36 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:35714 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727256AbeLNPnf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Dec 2018 10:43:35 -0500
Received: from test-nl.fritz.box ([80.101.105.217])
        by smtp-cloud7.xs4all.net with ESMTPA
        id XpcSgqK2FdllcXpcjgJJFY; Fri, 14 Dec 2018 16:43:33 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Tomasz Figa <tfiga@chromium.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 2/2] vicodec: add encoder support to write to multiple buffers
Date:   Fri, 14 Dec 2018 16:43:16 +0100
Message-Id: <20181214154316.62011-3-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181214154316.62011-1-hverkuil-cisco@xs4all.nl>
References: <20181214154316.62011-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfE2gd1jVKlCvESmiEaleHmfcQkPS1Y+WCzIGqEPxfP1Dvz3AEIleISlttyV3C9tAlKxNeMeUh7zF5CWbtvS5qdQstEl+EqB0ltW7BhlE2I29OpS9ZHoo
 sSTH4FL+lhmIZCLK2EXiRgP1u7mmKS19JOHd7D2ofy0maklf+QszDK+MkZmGAoMx+BvIN/1RIR9+mN5dPzVJxv9rIbPi0GQJlVYXReBx1krIjYlCriWrGgoe
 q+yJF7puMWeAoi0t52hef6UTODvsilNuAXUsDQn86O9XELmowh4yysTH6BVZC9RmZDa7gRQVHGvgfZEIw4ksQ/KTazYHv3a/BVphI3hSUGY=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

With the new mem2mem functionality it is now easy to write the
result of the encoder to multiple buffers.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
---
 drivers/media/platform/vicodec/vicodec-core.c | 91 +++++++++++++++----
 1 file changed, 75 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 2b7daff63425..f422804ab40e 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -115,6 +115,11 @@ struct vicodec_ctx {
 	struct vb2_v4l2_buffer *last_src_buf;
 	struct vb2_v4l2_buffer *last_dst_buf;
 
+	u64			dst_timestamp;
+	u32			dst_field;
+	u32			dst_flags;
+	struct v4l2_timecode	dst_timecode;
+
 	/* Source and destination queue data */
 	struct vicodec_q_data   q_data[2];
 	struct v4l2_fwht_state	state;
@@ -161,11 +166,13 @@ static int device_process(struct vicodec_ctx *ctx,
 	int ret;
 
 	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
-	if (ctx->is_enc)
+	if (ctx->is_enc) {
 		p_src = vb2_plane_vaddr(&src_vb->vb2_buf, 0);
-	else
+		p_dst = state->compressed_frame;
+	} else {
 		p_src = state->compressed_frame;
-	p_dst = vb2_plane_vaddr(&dst_vb->vb2_buf, 0);
+		p_dst = vb2_plane_vaddr(&dst_vb->vb2_buf, 0);
+	}
 	if (!p_src || !p_dst) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
@@ -180,7 +187,11 @@ static int device_process(struct vicodec_ctx *ctx,
 		ret = v4l2_fwht_encode(state, p_src, p_dst);
 		if (ret < 0)
 			return ret;
+		ctx->comp_size = ret;
+		ret = min_t(u32, ret, vb2_plane_size(&dst_vb->vb2_buf, 0));
+		ctx->cur_buf_offset = ret;
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, ret);
+		memcpy(vb2_plane_vaddr(&dst_vb->vb2_buf, 0), p_dst, ret);
 	} else {
 		state->info = q_dst->info;
 		ret = v4l2_fwht_decode(state, p_src, p_dst);
@@ -240,6 +251,14 @@ static void device_run(void *priv)
 		src_buf->sequence = q_src->sequence++;
 		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, state);
+		if (ctx->cur_buf_offset < ctx->comp_size) {
+			ctx->dst_timestamp = dst_buf->vb2_buf.timestamp;
+			ctx->dst_field = dst_buf->field;
+			ctx->dst_flags = dst_buf->flags;
+			dst_buf->flags &= ~V4L2_BUF_FLAG_LAST;
+			if (dst_buf->flags & V4L2_BUF_FLAG_TIMECODE)
+				ctx->dst_timecode = dst_buf->timecode;
+		}
 	} else if (vb2_get_plane_payload(&src_buf->vb2_buf, 0) == ctx->cur_buf_offset) {
 		src_buf->sequence = q_src->sequence++;
 		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
@@ -247,16 +266,22 @@ static void device_run(void *priv)
 		ctx->cur_buf_offset = 0;
 		ctx->comp_has_next_frame = false;
 	}
-	v4l2_m2m_buf_done(dst_buf, state);
-	ctx->comp_size = 0;
-	ctx->comp_magic_cnt = 0;
-	ctx->comp_has_frame = false;
+	if (!ctx->is_enc) {
+		ctx->comp_size = 0;
+		ctx->comp_magic_cnt = 0;
+		ctx->comp_has_frame = false;
+	}
 	spin_unlock(ctx->lock);
 
-	if (ctx->is_enc)
-		v4l2_m2m_job_finish(dev->enc_dev, ctx->fh.m2m_ctx);
-	else
+	if (ctx->is_enc) {
+		if (ctx->cur_buf_offset < ctx->comp_size)
+			v4l2_m2m_job_writing(dev->enc_dev, ctx->fh.m2m_ctx);
+		else
+			v4l2_m2m_job_finish(dev->enc_dev, ctx->fh.m2m_ctx);
+	} else {
 		v4l2_m2m_job_finish(dev->dec_dev, ctx->fh.m2m_ctx);
+	}
+	v4l2_m2m_buf_done(dst_buf, state);
 }
 
 static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
@@ -273,6 +298,41 @@ static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
 	spin_unlock(ctx->lock);
 }
 
+static void job_write(void *priv)
+{
+	struct vicodec_ctx *ctx = priv;
+	struct v4l2_fwht_state *state = &ctx->state;
+	struct vb2_v4l2_buffer *dst_buf;
+	struct vicodec_q_data *q_cap;
+	u32 size;
+
+	q_cap = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	while (v4l2_m2m_num_dst_bufs_ready(ctx->fh.m2m_ctx) &&
+	       ctx->cur_buf_offset < ctx->comp_size) {
+		dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+		size = min_t(u32, ctx->comp_size - ctx->cur_buf_offset,
+			     vb2_plane_size(&dst_buf->vb2_buf, 0));
+		vb2_set_plane_payload(&dst_buf->vb2_buf, 0, size);
+		memcpy(vb2_plane_vaddr(&dst_buf->vb2_buf, 0),
+		       state->compressed_frame + ctx->cur_buf_offset, size);
+		ctx->cur_buf_offset += size;
+
+		dst_buf->sequence = q_cap->sequence++;
+		dst_buf->vb2_buf.timestamp = ctx->dst_timestamp;
+		if (ctx->dst_flags & V4L2_BUF_FLAG_TIMECODE)
+			dst_buf->timecode = ctx->dst_timecode;
+		dst_buf->field = ctx->dst_field;
+		dst_buf->flags = ctx->dst_flags;
+
+		if (ctx->cur_buf_offset < ctx->comp_size)
+			dst_buf->flags &= ~V4L2_BUF_FLAG_LAST;
+
+		if (ctx->cur_buf_offset == ctx->comp_size)
+			v4l2_m2m_job_finish(ctx->dev->enc_dev, ctx->fh.m2m_ctx);
+		v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
+	}
+}
+
 static int job_ready(void *priv)
 {
 	static const u8 magic[] = {
@@ -536,7 +596,7 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix->sizeimage = pix->width * pix->height *
 			info->sizeimage_mult / info->sizeimage_div;
 		if (pix->pixelformat == V4L2_PIX_FMT_FWHT)
-			pix->sizeimage += sizeof(struct fwht_cframe_hdr);
+			pix->sizeimage /= 16;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
@@ -554,7 +614,7 @@ static int vidioc_try_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		plane->sizeimage = pix_mp->width * pix_mp->height *
 			info->sizeimage_mult / info->sizeimage_div;
 		if (pix_mp->pixelformat == V4L2_PIX_FMT_FWHT)
-			plane->sizeimage += sizeof(struct fwht_cframe_hdr);
+			plane->sizeimage /= 16;
 		memset(pix_mp->reserved, 0, sizeof(pix_mp->reserved));
 		memset(plane->reserved, 0, sizeof(plane->reserved));
 		break;
@@ -1204,16 +1264,14 @@ static int vicodec_open(struct file *file)
 	if (ctx->is_enc)
 		ctx->q_data[V4L2_M2M_SRC].sizeimage = size;
 	else
-		ctx->q_data[V4L2_M2M_SRC].sizeimage =
-			size + sizeof(struct fwht_cframe_hdr);
+		ctx->q_data[V4L2_M2M_SRC].sizeimage = size / 16;
 	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
 	ctx->q_data[V4L2_M2M_DST].info =
 		ctx->is_enc ? &pixfmt_fwht : v4l2_fwht_get_pixfmt(0);
 	size = 1280 * 720 * ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
 		ctx->q_data[V4L2_M2M_DST].info->sizeimage_div;
 	if (ctx->is_enc)
-		ctx->q_data[V4L2_M2M_DST].sizeimage =
-			size + sizeof(struct fwht_cframe_hdr);
+		ctx->q_data[V4L2_M2M_DST].sizeimage = size / 16;
 	else
 		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
 	ctx->state.colorspace = V4L2_COLORSPACE_REC709;
@@ -1281,6 +1339,7 @@ static const struct video_device vicodec_videodev = {
 static const struct v4l2_m2m_ops m2m_ops = {
 	.device_run	= device_run,
 	.job_ready	= job_ready,
+	.job_write	= job_write,
 };
 
 static int vicodec_probe(struct platform_device *pdev)
-- 
2.19.2


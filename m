Return-Path: <SRS0=WxzW=ON=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DE1C04EB8
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 20:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 205E62081B
	for <linux-media@archiver.kernel.org>; Tue,  4 Dec 2018 20:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NyplqODK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 205E62081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbeLDUy7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 4 Dec 2018 15:54:59 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35551 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbeLDUy7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2018 15:54:59 -0500
Received: by mail-wm1-f65.google.com with SMTP id c126so10734825wmh.0
        for <linux-media@vger.kernel.org>; Tue, 04 Dec 2018 12:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=pjAlLIuw9oTQ3n0i7+KmsnQ/ecFM1tKHcKLLzBoaMPk=;
        b=NyplqODK+ntNqGWFsvrP0PbEXRv/0CA2oNWsKOcmfi7MNNWEtrnvesMuSy94sWQVh/
         wTWyeen91ZSDKPmSJT7M6A1zNLFKDfJjoXwiS8oSe1Z8SrLZ7UZIpbFXd3mzQgZflUzH
         8kFUzKJndKZ4+Pa6k/VdcRLOseGRx3MbGcVH7Dwxw5lmwT4Y7SkueXfMa4Ps3nKMhqUh
         zgdMYz+uEvoHpjpaJagoWsOF1pOypeuT4U1pDJzzdHg/UhhpxvDlXulkQx7L8ztKCSOh
         Ku0uU1e9ZU7yQKK1YnQpNZvsWxELLnXAO//t5Wt9i+SFxUM6NeVxCOOrJLWBToW1Xb4r
         j/mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pjAlLIuw9oTQ3n0i7+KmsnQ/ecFM1tKHcKLLzBoaMPk=;
        b=qOF9t3tt8ArTkZ5aNeJJMAdkr2WKvvcpAPHqYjmk8Jwv73nWjr1aYo7t0iPkP1gwgj
         3ubtYxB8GNfZSXq9FmwnxgOmilPAw6b4qv5EQ+21Yv2bkiBWfxAQnMOgsA5hUSG5r56Y
         wGUo5Ultm7ZNiKOF6RjsbrhHJ0NCFPyrsSg4PxzSRbA48H6FDwf7adcCPURMA9C6og3Y
         SeFQcPjWPtSkndsbl5gcacfc0Dvvyn91062qqQJhHwei2WJ52XzOeEM0cYthje6wgKUd
         XDE40MxMbA6YDtr1Fst8l7qyfF+drirzjZbLjIvqzLA5GgWd8v6F81317MXybVV2fT0s
         ESXQ==
X-Gm-Message-State: AA+aEWZhfsG+1H2G74YhgjETFK7+cwCcoCEg10fLCvHQ/hSj4phzJMVw
        EgfSLI18e4RLZ8sNF+5FcXY=
X-Google-Smtp-Source: AFSGD/VR+UXvAN0BtEFERmql/qDflSekDay3LNP0IR/xTqGaiHiTY2ftbCLuM4RzM5WmU7rGUhcJBQ==
X-Received: by 2002:a1c:9692:: with SMTP id y140mr14376365wmd.67.1543956896036;
        Tue, 04 Dec 2018 12:54:56 -0800 (PST)
Received: from localhost.localdomain ([87.70.73.241])
        by smtp.gmail.com with ESMTPSA id m4sm16679816wmi.3.2018.12.04.12.54.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Dec 2018 12:54:55 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     hverkuil@xs4all.nl, helen.koike@collabora.com
Cc:     linux-media@vger.kernel.org, Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH] media: vicodec: Change variable names
Date:   Tue,  4 Dec 2018 22:54:37 +0200
Message-Id: <20181204205437.21933-1-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Change variables names in vicodec-core.c to *_src *_dst
to improve readability

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 94 ++++++++++---------
 1 file changed, 48 insertions(+), 46 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index b7bdfe97215b..78c6009a53c3 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -151,52 +151,52 @@ static struct vicodec_q_data *get_q_data(struct vicodec_ctx *ctx,
 }
 
 static int device_process(struct vicodec_ctx *ctx,
-			  struct vb2_v4l2_buffer *in_vb,
-			  struct vb2_v4l2_buffer *out_vb)
+			  struct vb2_v4l2_buffer *src_vb,
+			  struct vb2_v4l2_buffer *dst_vb)
 {
 	struct vicodec_dev *dev = ctx->dev;
-	struct vicodec_q_data *q_cap;
+	struct vicodec_q_data *q_dst;
 	struct v4l2_fwht_state *state = &ctx->state;
-	u8 *p_in, *p_out;
+	u8 *p_src, *p_dst;
 	int ret;
 
-	q_cap = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 	if (ctx->is_enc)
-		p_in = vb2_plane_vaddr(&in_vb->vb2_buf, 0);
+		p_src = vb2_plane_vaddr(&src_vb->vb2_buf, 0);
 	else
-		p_in = state->compressed_frame;
-	p_out = vb2_plane_vaddr(&out_vb->vb2_buf, 0);
-	if (!p_in || !p_out) {
+		p_src = state->compressed_frame;
+	p_dst = vb2_plane_vaddr(&dst_vb->vb2_buf, 0);
+	if (!p_src || !p_dst) {
 		v4l2_err(&dev->v4l2_dev,
 			 "Acquiring kernel pointers to buffers failed\n");
 		return -EFAULT;
 	}
 
 	if (ctx->is_enc) {
-		struct vicodec_q_data *q_out;
+		struct vicodec_q_data *q_src;
 
-		q_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
-		state->info = q_out->info;
-		ret = v4l2_fwht_encode(state, p_in, p_out);
+		q_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		state->info = q_src->info;
+		ret = v4l2_fwht_encode(state, p_src, p_dst);
 		if (ret < 0)
 			return ret;
-		vb2_set_plane_payload(&out_vb->vb2_buf, 0, ret);
+		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, ret);
 	} else {
-		state->info = q_cap->info;
-		ret = v4l2_fwht_decode(state, p_in, p_out);
+		state->info = q_dst->info;
+		ret = v4l2_fwht_decode(state, p_src, p_dst);
 		if (ret < 0)
 			return ret;
-		vb2_set_plane_payload(&out_vb->vb2_buf, 0, q_cap->sizeimage);
+		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
 	}
 
-	out_vb->sequence = q_cap->sequence++;
-	out_vb->vb2_buf.timestamp = in_vb->vb2_buf.timestamp;
+	dst_vb->sequence = q_dst->sequence++;
+	dst_vb->vb2_buf.timestamp = src_vb->vb2_buf.timestamp;
 
-	if (in_vb->flags & V4L2_BUF_FLAG_TIMECODE)
-		out_vb->timecode = in_vb->timecode;
-	out_vb->field = in_vb->field;
-	out_vb->flags &= ~V4L2_BUF_FLAG_LAST;
-	out_vb->flags |= in_vb->flags &
+	if (src_vb->flags & V4L2_BUF_FLAG_TIMECODE)
+		dst_vb->timecode = src_vb->timecode;
+	dst_vb->field = src_vb->field;
+	dst_vb->flags &= ~V4L2_BUF_FLAG_LAST;
+	dst_vb->flags |= src_vb->flags &
 		(V4L2_BUF_FLAG_TIMECODE |
 		 V4L2_BUF_FLAG_KEYFRAME |
 		 V4L2_BUF_FLAG_PFRAME |
@@ -219,12 +219,12 @@ static void device_run(void *priv)
 	struct vicodec_ctx *ctx = priv;
 	struct vicodec_dev *dev = ctx->dev;
 	struct vb2_v4l2_buffer *src_buf, *dst_buf;
-	struct vicodec_q_data *q_out;
+	struct vicodec_q_data *q_src;
 	u32 state;
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	q_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 
 	state = VB2_BUF_STATE_DONE;
 	if (device_process(ctx, src_buf, dst_buf))
@@ -237,11 +237,11 @@ static void device_run(void *priv)
 		v4l2_event_queue_fh(&ctx->fh, &eos_event);
 	}
 	if (ctx->is_enc) {
-		src_buf->sequence = q_out->sequence++;
+		src_buf->sequence = q_src->sequence++;
 		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, state);
 	} else if (vb2_get_plane_payload(&src_buf->vb2_buf, 0) == ctx->cur_buf_offset) {
-		src_buf->sequence = q_out->sequence++;
+		src_buf->sequence = q_src->sequence++;
 		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, state);
 		ctx->cur_buf_offset = 0;
@@ -259,15 +259,15 @@ static void device_run(void *priv)
 		v4l2_m2m_job_finish(dev->dec_dev, ctx->fh.m2m_ctx);
 }
 
-static void job_remove_out_buf(struct vicodec_ctx *ctx, u32 state)
+static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
 {
 	struct vb2_v4l2_buffer *src_buf;
-	struct vicodec_q_data *q_out;
+	struct vicodec_q_data *q_src;
 
-	q_out = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	q_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	spin_lock(ctx->lock);
 	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-	src_buf->sequence = q_out->sequence++;
+	src_buf->sequence = q_src->sequence++;
 	v4l2_m2m_buf_done(src_buf, state);
 	ctx->cur_buf_offset = 0;
 	spin_unlock(ctx->lock);
@@ -280,7 +280,7 @@ static int job_ready(void *priv)
 	};
 	struct vicodec_ctx *ctx = priv;
 	struct vb2_v4l2_buffer *src_buf;
-	u8 *p_out;
+	u8 *p_src;
 	u8 *p;
 	u32 sz;
 	u32 state;
@@ -293,15 +293,15 @@ static int job_ready(void *priv)
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	if (!src_buf)
 		return 0;
-	p_out = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
+	p_src = vb2_plane_vaddr(&src_buf->vb2_buf, 0);
 	sz = vb2_get_plane_payload(&src_buf->vb2_buf, 0);
-	p = p_out + ctx->cur_buf_offset;
+	p = p_src + ctx->cur_buf_offset;
 
 	state = VB2_BUF_STATE_DONE;
 
 	if (!ctx->comp_size) {
 		state = VB2_BUF_STATE_ERROR;
-		for (; p < p_out + sz; p++) {
+		for (; p < p_src + sz; p++) {
 			u32 copy;
 
 			p = memchr(p, magic[ctx->comp_magic_cnt], sz);
@@ -310,8 +310,9 @@ static int job_ready(void *priv)
 				break;
 			}
 			copy = sizeof(magic) - ctx->comp_magic_cnt;
-			if (p_out + sz - p < copy)
-				copy = p_out + sz - p;
+			if (p_src + sz - p < copy)
+				copy = p_src + sz - p;
+
 			memcpy(ctx->state.compressed_frame + ctx->comp_magic_cnt,
 			       p, copy);
 			ctx->comp_magic_cnt += copy;
@@ -324,7 +325,7 @@ static int job_ready(void *priv)
 			ctx->comp_magic_cnt = 0;
 		}
 		if (ctx->comp_magic_cnt < sizeof(magic)) {
-			job_remove_out_buf(ctx, state);
+			job_remove_src_buf(ctx, state);
 			goto restart;
 		}
 		ctx->comp_size = sizeof(magic);
@@ -334,14 +335,14 @@ static int job_ready(void *priv)
 			(struct fwht_cframe_hdr *)ctx->state.compressed_frame;
 		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->comp_size;
 
-		if (copy > p_out + sz - p)
-			copy = p_out + sz - p;
+		if (copy > p_src + sz - p)
+			copy = p_src + sz - p;
 		memcpy(ctx->state.compressed_frame + ctx->comp_size,
 		       p, copy);
 		p += copy;
 		ctx->comp_size += copy;
 		if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
-			job_remove_out_buf(ctx, state);
+			job_remove_src_buf(ctx, state);
 			goto restart;
 		}
 		ctx->comp_frame_size = ntohl(p_hdr->size) + sizeof(*p_hdr);
@@ -351,18 +352,19 @@ static int job_ready(void *priv)
 	if (ctx->comp_size < ctx->comp_frame_size) {
 		u32 copy = ctx->comp_frame_size - ctx->comp_size;
 
-		if (copy > p_out + sz - p)
-			copy = p_out + sz - p;
+		if (copy > p_src + sz - p)
+			copy = p_src + sz - p;
+
 		memcpy(ctx->state.compressed_frame + ctx->comp_size,
 		       p, copy);
 		p += copy;
 		ctx->comp_size += copy;
 		if (ctx->comp_size < ctx->comp_frame_size) {
-			job_remove_out_buf(ctx, state);
+			job_remove_src_buf(ctx, state);
 			goto restart;
 		}
 	}
-	ctx->cur_buf_offset = p - p_out;
+	ctx->cur_buf_offset = p - p_src;
 	ctx->comp_has_frame = true;
 	ctx->comp_has_next_frame = false;
 	if (sz - ctx->cur_buf_offset >= sizeof(struct fwht_cframe_hdr)) {
-- 
2.17.1


Return-Path: <SRS0=HRs9=P4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84F2C636A2
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 13:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E8A520880
	for <linux-media@archiver.kernel.org>; Sun, 20 Jan 2019 13:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEJFuIJY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbfATN31 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 20 Jan 2019 08:29:27 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33490 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730571AbfATN31 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Jan 2019 08:29:27 -0500
Received: by mail-wm1-f68.google.com with SMTP id r24so4250044wmh.0
        for <linux-media@vger.kernel.org>; Sun, 20 Jan 2019 05:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A9WpZKOeX6UJi1mzeD2Ml/nWT0phL+rp9McuNOZypCM=;
        b=QEJFuIJYCpuxrSk/HtlaWYp4ndIjy05llDhSOivzxGGM4IaXoOUi6WJzsBKF4F+qe3
         WQPp9/ueiOa88iAUrEigzpeecAs1ktRwuILXHW1PfzduZRWR+NrqU4ECuyN6PHCWAfia
         Bq7UCdyZtAC6NkMeXUk9YnXHtumkc0EfH/NeQ7M28gbwYHFdAWnIBwGwqa4WqL7ajkYI
         sI63CjT0eapVk/yEjV6xIiQuVby9bH6ZDAoZ2Ch5WZxWTeX+TIhYF/TdsYnF+aRtwVMe
         EvEzO24v1xI6MlbxlTNPDbcK+bpMhYwq+8t6ATIUibwPBYTok0A1ke8jNNwrPgBNOb/H
         M5Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A9WpZKOeX6UJi1mzeD2Ml/nWT0phL+rp9McuNOZypCM=;
        b=gdjk6GVebSVFS2bAVIVuAlPQkVDb/jann1ZyHxe44Y3REY2OVUltblKOO+P/VEG5Gw
         wHscFcGcnV0ScgsMXp/T43OwMtYEDsLUAjwVxpqd6UTFvizCSb3FDKu2y1tFg0i6PnbH
         RYMZMK3qb8j58XjnhluX9bdRQi+A04mVdellzbRV7ipLE2EoLZl839XQEtKBFY3JblZW
         sGKyD3nTmsPqOyfM7V43voVIUyyONX9vYAS/+YWUoinB3YCWsoc/pGEuHj0l6As9Qggo
         kq+9E7gHR5asBnsXkc26Xp5cLr3MfS3UjC1oq+RuR0hHRSQZxrhlVZNTr7/JpxKwe7gh
         G8sg==
X-Gm-Message-State: AJcUukebRB6BodHcaxe1zPu5uGHwShf4t6/PqtPXjUn6a6xLyHq+sHOF
        lhBg5gy9IYqNeIY8sFeNjBG8LKXbZEc=
X-Google-Smtp-Source: ALg8bN43iKhBEtABa4JM0Wy7cVu6epQD8BFjqCXIC6qVf5sYMZN8QAaGTMNiLNwnXJxyuKshexDxRw==
X-Received: by 2002:a1c:7eca:: with SMTP id z193mr7318128wmc.5.1547990964195;
        Sun, 20 Jan 2019 05:29:24 -0800 (PST)
Received: from localhost.localdomain ([87.70.46.65])
        by smtp.gmail.com with ESMTPSA id e16sm148601036wrn.72.2019.01.20.05.29.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Jan 2019 05:29:23 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v5 5/6] media: vicodec: Separate fwht header from the frame data
Date:   Sun, 20 Jan 2019 05:29:06 -0800
Message-Id: <20190120132907.30812-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190120132907.30812-1-dafna3@gmail.com>
References: <20190120132907.30812-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Keep the fwht header in separated field from the data.
Refactor job_ready to use a new function 'get_next_header'

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 .../media/platform/vicodec/codec-v4l2-fwht.c  |  24 ++--
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   1 +
 drivers/media/platform/vicodec/vicodec-core.c | 110 +++++++++++-------
 3 files changed, 77 insertions(+), 58 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 63b7e1525dbc..4b7133725ea8 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -233,7 +233,6 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
 	unsigned int i, j, k;
 	u32 flags;
-	struct fwht_cframe_hdr *p_hdr;
 	struct fwht_cframe cf;
 	u8 *p, *ref_p;
 	unsigned int components_num = 3;
@@ -245,25 +244,24 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 		return -EINVAL;
 
 	info = state->info;
-	p_hdr = (struct fwht_cframe_hdr *)p_in;
 
-	version = ntohl(p_hdr->version);
+	version = ntohl(state->header.version);
 	if (!version || version > FWHT_VERSION) {
 		pr_err("version %d is not supported, current version is %d\n",
 		       version, FWHT_VERSION);
 		return -EINVAL;
 	}
 
-	if (p_hdr->magic1 != FWHT_MAGIC1 ||
-	    p_hdr->magic2 != FWHT_MAGIC2)
+	if (state->header.magic1 != FWHT_MAGIC1 ||
+	    state->header.magic2 != FWHT_MAGIC2)
 		return -EINVAL;
 
 	/* TODO: support resolution changes */
-	if (ntohl(p_hdr->width)  != state->visible_width ||
-	    ntohl(p_hdr->height) != state->visible_height)
+	if (ntohl(state->header.width)  != state->visible_width ||
+	    ntohl(state->header.height) != state->visible_height)
 		return -EINVAL;
 
-	flags = ntohl(p_hdr->flags);
+	flags = ntohl(state->header.flags);
 
 	if (version == FWHT_VERSION) {
 		if ((flags & FWHT_FL_PIXENC_MSK) != info->pixenc)
@@ -275,11 +273,11 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 	if (components_num != info->components_num)
 		return -EINVAL;
 
-	state->colorspace = ntohl(p_hdr->colorspace);
-	state->xfer_func = ntohl(p_hdr->xfer_func);
-	state->ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
-	state->quantization = ntohl(p_hdr->quantization);
-	cf.rlc_data = (__be16 *)(p_in + sizeof(*p_hdr));
+	state->colorspace = ntohl(state->header.colorspace);
+	state->xfer_func = ntohl(state->header.xfer_func);
+	state->ycbcr_enc = ntohl(state->header.ycbcr_enc);
+	state->quantization = ntohl(state->header.quantization);
+	cf.rlc_data = (__be16 *)p_in;
 
 	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
 	hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index 18ac25978829..aa6fa90a48be 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -41,6 +41,7 @@ struct v4l2_fwht_state {
 	enum v4l2_quantization quantization;
 
 	struct fwht_raw_frame ref_frame;
+	struct fwht_cframe_hdr header;
 	u8 *compressed_frame;
 };
 
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index ef7ee75106b5..aa3dd609b243 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -124,6 +124,7 @@ struct vicodec_ctx {
 	u32			cur_buf_offset;
 	u32			comp_max_size;
 	u32			comp_size;
+	u32			header_size;
 	u32			comp_magic_cnt;
 	u32			comp_frame_size;
 	bool			comp_has_frame;
@@ -201,6 +202,62 @@ static int device_process(struct vicodec_ctx *ctx,
 /*
  * mem2mem callbacks
  */
+enum vb2_buffer_state get_next_header(struct vicodec_ctx *ctx, u8 **pp, u32 sz)
+{
+	static const u8 magic[] = {
+		0x4f, 0x4f, 0x4f, 0x4f, 0xff, 0xff, 0xff, 0xff
+	};
+	u8 *p = *pp;
+	u32 state;
+	u8 *header = (u8 *)&ctx->state.header;
+
+	state = VB2_BUF_STATE_DONE;
+
+	if (!ctx->header_size) {
+		state = VB2_BUF_STATE_ERROR;
+		for (; p < *pp + sz; p++) {
+			u32 copy;
+
+			p = memchr(p, magic[ctx->comp_magic_cnt],
+				   *pp + sz - p);
+			if (!p) {
+				ctx->comp_magic_cnt = 0;
+				p = *pp + sz;
+				break;
+			}
+			copy = sizeof(magic) - ctx->comp_magic_cnt;
+			if (*pp + sz - p < copy)
+				copy = *pp + sz - p;
+
+			memcpy(header + ctx->comp_magic_cnt, p, copy);
+			ctx->comp_magic_cnt += copy;
+			if (!memcmp(header, magic, ctx->comp_magic_cnt)) {
+				p += copy;
+				state = VB2_BUF_STATE_DONE;
+				break;
+			}
+			ctx->comp_magic_cnt = 0;
+		}
+		if (ctx->comp_magic_cnt < sizeof(magic)) {
+			*pp = p;
+			return state;
+		}
+		ctx->header_size = sizeof(magic);
+	}
+
+	if (ctx->header_size < sizeof(struct fwht_cframe_hdr)) {
+		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->header_size;
+
+		if (*pp + sz - p < copy)
+			copy = *pp + sz - p;
+
+		memcpy(header + ctx->header_size, p, copy);
+		p += copy;
+		ctx->header_size += copy;
+	}
+	*pp = p;
+	return state;
+}
 
 /* device_run() - prepares and starts the device */
 static void device_run(void *priv)
@@ -241,6 +298,7 @@ static void device_run(void *priv)
 	}
 	v4l2_m2m_buf_done(dst_buf, state);
 	ctx->comp_size = 0;
+	ctx->header_size = 0;
 	ctx->comp_magic_cnt = 0;
 	ctx->comp_has_frame = false;
 	spin_unlock(ctx->lock);
@@ -291,54 +349,15 @@ static int job_ready(void *priv)
 
 	state = VB2_BUF_STATE_DONE;
 
-	if (!ctx->comp_size) {
-		state = VB2_BUF_STATE_ERROR;
-		for (; p < p_src + sz; p++) {
-			u32 copy;
-
-			p = memchr(p, magic[ctx->comp_magic_cnt],
-				   p_src + sz - p);
-			if (!p) {
-				ctx->comp_magic_cnt = 0;
-				break;
-			}
-			copy = sizeof(magic) - ctx->comp_magic_cnt;
-			if (p_src + sz - p < copy)
-				copy = p_src + sz - p;
-
-			memcpy(ctx->state.compressed_frame + ctx->comp_magic_cnt,
-			       p, copy);
-			ctx->comp_magic_cnt += copy;
-			if (!memcmp(ctx->state.compressed_frame, magic,
-				    ctx->comp_magic_cnt)) {
-				p += copy;
-				state = VB2_BUF_STATE_DONE;
-				break;
-			}
-			ctx->comp_magic_cnt = 0;
-		}
-		if (ctx->comp_magic_cnt < sizeof(magic)) {
+	if (ctx->header_size < sizeof(struct fwht_cframe_hdr)) {
+		state = get_next_header(ctx, &p, p_src + sz - p);
+		if (ctx->header_size < sizeof(struct fwht_cframe_hdr)) {
 			job_remove_src_buf(ctx, state);
 			goto restart;
 		}
-		ctx->comp_size = sizeof(magic);
-	}
-	if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
-		struct fwht_cframe_hdr *p_hdr =
-			(struct fwht_cframe_hdr *)ctx->state.compressed_frame;
-		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->comp_size;
 
-		if (copy > p_src + sz - p)
-			copy = p_src + sz - p;
-		memcpy(ctx->state.compressed_frame + ctx->comp_size,
-		       p, copy);
-		p += copy;
-		ctx->comp_size += copy;
-		if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
-			job_remove_src_buf(ctx, state);
-			goto restart;
-		}
-		ctx->comp_frame_size = ntohl(p_hdr->size) + sizeof(*p_hdr);
+		ctx->comp_frame_size = ntohl(ctx->state.header.size);
+
 		if (ctx->comp_frame_size > ctx->comp_max_size)
 			ctx->comp_frame_size = ctx->comp_max_size;
 	}
@@ -1103,7 +1122,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		state->stride = q_data->coded_width * info->bytesperline_mult;
 	}
 	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
-	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
+	ctx->comp_max_size = total_planes_size;
 	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 	if (!state->ref_frame.luma || !state->compressed_frame) {
 		kvfree(state->ref_frame.luma);
@@ -1130,6 +1149,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->gop_cnt = 0;
 	ctx->cur_buf_offset = 0;
 	ctx->comp_size = 0;
+	ctx->header_size = 0;
 	ctx->comp_magic_cnt = 0;
 	ctx->comp_has_frame = false;
 
-- 
2.17.1


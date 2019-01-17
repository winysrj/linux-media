Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A6FC43444
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 18:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A58120856
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 18:24:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZMTtJjjq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfAQSYb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 13:24:31 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41435 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbfAQSYb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 13:24:31 -0500
Received: by mail-wr1-f66.google.com with SMTP id x10so12090804wrs.8
        for <linux-media@vger.kernel.org>; Thu, 17 Jan 2019 10:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hHk6Mn7AVDX5K90YWvRw9iajXIirn+qxXkH5+LFsRA8=;
        b=ZMTtJjjq4I2SiGzB2+KsNjoDj7+dRt9r0BGsOQFZOgESQ7byHqIMp8EiHNEi3JInOh
         Zw7rYpHrowzkrP4dL4/veGvAYKA4QUbg5OOZ42IF6fejyu0GbORNuM5kaWl6gmsdxJMi
         JjzpVppfBDAolVsAx2QHF4lAGFrgxK/2cd0U9mh2JskjOBSrEa42ZG7kc+QVT+4LceIQ
         AxvxjTV3uGdLRY/ahSg+KKFtFTnfXhS7JKsMsYt4FPEO9/R4DHEFD4Q5SvWhzUpY2ojx
         6J2lzb9m4PtxJdOcDwxIflUW7eeIuwwlZ8bh/LAKtgoxTWd+2MW3jKHAoKNAtKTH1+RB
         jzkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hHk6Mn7AVDX5K90YWvRw9iajXIirn+qxXkH5+LFsRA8=;
        b=WQLoa/rN5Q2Ci5YomOxyecC6wi84hkJIdqH1mQSwz3vUF963cp0URbLW5Z8x/5KyHf
         yHG7M2+no/+iJtsDCNsdmkNwf2MD+nKGKc12YjMp15j5+ADTuoswVzlZnhhhF0YTDgSh
         jQe+p2Jn0oKX8jQCejJ5G5zNO0cnNZ8VGxZ42rXS6DwgIenyHCtdEXLw9pmVnBm7H0J/
         oTROFPTXrH6AYT+bphLDPJaU00aF9pYKQdBVWhEVpbzCquljYfwdzkp5Bbnzt+S29Lb0
         AKw7cDVk9xK22IuJKSOup1bGAMKHEKnNuSd90NwoKUJEOascB6LwvW5IEZS90V25H8BO
         2NJw==
X-Gm-Message-State: AJcUukcYFEiEAjVZ86zeaq1Q8YJcqNFIKcOjMmpIFGigoLGS7rE3pE1J
        qy7ZInaJxBv+OrsZnlBg5ijKnwKGttk=
X-Google-Smtp-Source: ALg8bN6VIdIxNhDU6bdmDMlBFaBhmHCw6Hoao0v1KpfIHKk0Xt/LxI2cIPqSSRu2sobUGhlQLbQyVA==
X-Received: by 2002:adf:ed46:: with SMTP id u6mr13537197wro.262.1547749468465;
        Thu, 17 Jan 2019 10:24:28 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id o4sm76052266wrq.66.2019.01.17.10.24.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Jan 2019 10:24:27 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v3 5/6] media: vicodec: Separate fwht header from the frame data
Date:   Thu, 17 Jan 2019 10:23:18 -0800
Message-Id: <20190117182319.118359-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190117182319.118359-1-dafna3@gmail.com>
References: <20190117182319.118359-1-dafna3@gmail.com>
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
 drivers/media/platform/vicodec/vicodec-core.c | 109 ++++++++++--------
 3 files changed, 76 insertions(+), 58 deletions(-)

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
index ef7ee75106b5..2a95eca3cae6 100644
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
@@ -201,6 +202,61 @@ static int device_process(struct vicodec_ctx *ctx,
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
@@ -241,6 +297,7 @@ static void device_run(void *priv)
 	}
 	v4l2_m2m_buf_done(dst_buf, state);
 	ctx->comp_size = 0;
+	ctx->header_size = 0;
 	ctx->comp_magic_cnt = 0;
 	ctx->comp_has_frame = false;
 	spin_unlock(ctx->lock);
@@ -291,54 +348,15 @@ static int job_ready(void *priv)
 
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
@@ -1103,7 +1121,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		state->stride = q_data->coded_width * info->bytesperline_mult;
 	}
 	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
-	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
+	ctx->comp_max_size = total_planes_size;
 	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 	if (!state->ref_frame.luma || !state->compressed_frame) {
 		kvfree(state->ref_frame.luma);
@@ -1130,6 +1148,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->gop_cnt = 0;
 	ctx->cur_buf_offset = 0;
 	ctx->comp_size = 0;
+	ctx->header_size = 0;
 	ctx->comp_magic_cnt = 0;
 	ctx->comp_has_frame = false;
 
-- 
2.17.1


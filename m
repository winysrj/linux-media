Return-Path: <SRS0=IHIA=PY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AC0CC43387
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1FC220657
	for <linux-media@archiver.kernel.org>; Wed, 16 Jan 2019 15:25:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iAjVN2Ip"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394074AbfAPPZv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 16 Jan 2019 10:25:51 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53332 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394068AbfAPPZu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Jan 2019 10:25:50 -0500
Received: by mail-wm1-f65.google.com with SMTP id d15so2411266wmb.3
        for <linux-media@vger.kernel.org>; Wed, 16 Jan 2019 07:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=62d7u3NWOF92LZtNBPRoNPwilnmTP4a3umw7lI/8X9s=;
        b=iAjVN2Ip3ubm3ez9MpSnwV8bpCsV3oTeADar0GNNVMlbDOaflY7d79uQg8GD4KY7mc
         pJRgOwY7X7Nd41wv2fXShq93arVT8pg0crILwikjh+ag6fqoOBvXCQDTGai2IdmNzw/A
         BBFt6mypcEN9z1MpSIrPshjVh8FCeVSIacSIpN2K6nT6Ci1+hU9pF5rfz8/O36r+Zj8j
         YOFKyZVp3IKqHqmhAiNfs42s4jLPpwywlR+WUwNPLCj9IXnSlQjlE4MWQoCgnzMbZC+3
         ILbNCte4Wk1p5K+7GfmANTohBcocKLNSU/c3+U3b6ZNabxugPa1oXSTwdkKPdwSrxFRw
         UXVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=62d7u3NWOF92LZtNBPRoNPwilnmTP4a3umw7lI/8X9s=;
        b=l6S7c7FHpSFK6ie1F21ui2MdG344nOpaZsZUTFYWM+NcU2wE0hJx3FxS7eSIQ9V5a6
         TgnComNdKEvfWIpcfqNyTPYS07KpVqT03+T5BLEiq34fOaSGDec3Qd+kagEWXQvPrcSF
         vNGTmVcJDdA8okRCeHyM8+6LbA5zaXFwSGpsxDmNy8o/Ae4f865G1bHMn2QcDpOvh803
         92q/QE8+B0kvZ7Jio/nUWcfmYj/798aJSjabeoaGzjb4mqynlaqO9+OvyF8N8FDIBoN0
         P+4a4H6B5UIp57ERoVizVZzP3PqSgdg59Z2sdgHOc72jpeshO/2janwzONpoWeZfs4k2
         fRSg==
X-Gm-Message-State: AJcUukenWetYtShhHlKA3TSlnsjJuRF8qA7hfjDtj04Ta9rVC5z9j6eR
        Pl+fKEPBDY1YuNmvtJDsL7JbvDhpeS0=
X-Google-Smtp-Source: ALg8bN5E8luhXEZEZ6v4zFAugsQYAqxxKu8N5KWHJBdUFMqvYgfHRJ43n29+WpOfT5ooUQSpYE+wSg==
X-Received: by 2002:a7b:ce84:: with SMTP id q4mr8418948wmj.105.1547652347262;
        Wed, 16 Jan 2019 07:25:47 -0800 (PST)
Received: from localhost.localdomain ([87.71.12.187])
        by smtp.gmail.com with ESMTPSA id l14sm161371758wrp.55.2019.01.16.07.25.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jan 2019 07:25:46 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v2 5/6] media: vicodec: Separate fwht header from the frame data
Date:   Wed, 16 Jan 2019 07:25:26 -0800
Message-Id: <20190116152527.34411-6-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190116152527.34411-1-dafna3@gmail.com>
References: <20190116152527.34411-1-dafna3@gmail.com>
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
 drivers/media/platform/vicodec/vicodec-core.c | 118 ++++++++++--------
 3 files changed, 81 insertions(+), 62 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
index 3df51d47674b..3dcf2ed24212 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
@@ -234,7 +234,6 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 {
 	unsigned int i, j, k;
 	u32 flags;
-	struct fwht_cframe_hdr *p_hdr;
 	struct fwht_cframe cf;
 	u8 *p, *ref_p;
 	unsigned int components_num = 3;
@@ -246,25 +245,24 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
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
 		u32 pixenc = flags & FWHT_FL_PIXENC_MSK;
@@ -277,11 +275,11 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
 			return -EINVAL;
 	}
 
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
index 5787d4e6822b..1dc5169a14e5 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -41,6 +41,7 @@ struct v4l2_fwht_state {
 	enum v4l2_quantization quantization;
 
 	struct fwht_raw_frame ref_frame;
+	struct fwht_cframe_hdr header;
 	u8 *compressed_frame;
 };
 
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 0df8d3509144..c97300344fbd 100644
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
+enum vb2_buffer_state get_next_header(struct vicodec_ctx *ctx, u8 *p_src,
+				      u32 sz, u8 *header, u8 **pp)
+{
+	static const u8 magic[] = {
+		0x4f, 0x4f, 0x4f, 0x4f, 0xff, 0xff, 0xff, 0xff
+	};
+	u8 *p = *pp;
+	u32 state;
+
+	state = VB2_BUF_STATE_DONE;
+
+	if (!ctx->header_size) {
+		state = VB2_BUF_STATE_ERROR;
+		for (; p < p_src + sz; p++) {
+			u32 copy;
+
+			p = memchr(p, magic[ctx->comp_magic_cnt],
+					p_src + sz - p);
+			if (!p) {
+				ctx->comp_magic_cnt = 0;
+				break;
+			}
+			copy = sizeof(magic) - ctx->comp_magic_cnt;
+			if (p_src + sz - p < copy)
+				copy = p_src + sz - p;
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
+		if (copy > p_src + sz - p)
+			copy = p_src + sz - p;
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
@@ -291,57 +348,19 @@ static int job_ready(void *priv)
 
 	state = VB2_BUF_STATE_DONE;
 
-	if (!ctx->comp_size) {
-		state = VB2_BUF_STATE_ERROR;
-		for (; p < p_src + sz; p++) {
-			u32 copy;
+	if (ctx->header_size < sizeof(struct fwht_cframe_hdr))
+		state = get_next_header(ctx, p_src, sz,
+					(u8 *)&ctx->state.header, &p);
+	if (ctx->header_size < sizeof(struct fwht_cframe_hdr)) {
+		job_remove_src_buf(ctx, state);
+		goto restart;
+	}
 
-			p = memchr(p, magic[ctx->comp_magic_cnt],
-				   p_src + sz - p);
-			if (!p) {
-				ctx->comp_magic_cnt = 0;
-				break;
-			}
-			copy = sizeof(magic) - ctx->comp_magic_cnt;
-			if (p_src + sz - p < copy)
-				copy = p_src + sz - p;
+	ctx->comp_frame_size = ntohl(ctx->state.header.size);
 
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
-			job_remove_src_buf(ctx, state);
-			goto restart;
-		}
-		ctx->comp_size = sizeof(magic);
-	}
-	if (ctx->comp_size < sizeof(struct fwht_cframe_hdr)) {
-		struct fwht_cframe_hdr *p_hdr =
-			(struct fwht_cframe_hdr *)ctx->state.compressed_frame;
-		u32 copy = sizeof(struct fwht_cframe_hdr) - ctx->comp_size;
+	if (ctx->comp_frame_size > ctx->comp_max_size)
+		ctx->comp_frame_size = ctx->comp_max_size;
 
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
-		if (ctx->comp_frame_size > ctx->comp_max_size)
-			ctx->comp_frame_size = ctx->comp_max_size;
-	}
 	if (ctx->comp_size < ctx->comp_frame_size) {
 		u32 copy = ctx->comp_frame_size - ctx->comp_size;
 
@@ -1104,7 +1123,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		state->stride = q_data->coded_width * info->bytesperline_mult;
 	}
 	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
-	ctx->comp_max_size = total_planes_size + sizeof(struct fwht_cframe_hdr);
+	ctx->comp_max_size = total_planes_size;
 	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 	if (!state->ref_frame.luma || !state->compressed_frame) {
 		kvfree(state->ref_frame.luma);
@@ -1131,6 +1150,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->gop_cnt = 0;
 	ctx->cur_buf_offset = 0;
 	ctx->comp_size = 0;
+	ctx->header_size = 0;
 	ctx->comp_magic_cnt = 0;
 	ctx->comp_has_frame = false;
 
-- 
2.17.1


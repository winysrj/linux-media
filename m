Return-Path: <SRS0=jH9h=P3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6D2C61CE4
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 12:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05EF92086D
	for <linux-media@archiver.kernel.org>; Sat, 19 Jan 2019 12:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uKhiHn2L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfASMCS (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 19 Jan 2019 07:02:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38535 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfASMCR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Jan 2019 07:02:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id m22so6860036wml.3
        for <linux-media@vger.kernel.org>; Sat, 19 Jan 2019 04:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wMCw2z8Y/sZkJy82H1jMIoujjY6b1J8MBOuTHWfsbtQ=;
        b=uKhiHn2LtdV9XLMkLXG7ekZOOeD5M3L6fw3ShpjOphSw0bJQatxT6se/TaXX8LBifE
         xjtsX9LQlWywNT1Mr6VEw19my+kWMs8eXcjHe6aZ5k2G7QY65ImzN2o0RH0vkuEi9qCk
         a0om4GCd12h0Cm3R/pV5xMhcT9/NJaRVAmk+YnfHd+6pm3CUk/SsPzOtmqKq6HOzK+QW
         nbNNHAForJ7zaidlMm519c17USqJSQ46gZPGWHK2hx67K40fecnAHP9b6n1l7+hAUhcM
         9/6i0WhW1KsefuVGujNtQ3lH3OAnMpf/esIL2oJO3q+o+P/oIUv2c8BadqjDl8AsTv9c
         WJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wMCw2z8Y/sZkJy82H1jMIoujjY6b1J8MBOuTHWfsbtQ=;
        b=XTi40zUOSKDZyojf08xDVTqhnaH83I/dLijdyg2JgiE8G4Sou3uIrlU/byrmCjd7in
         C/hGZF+2dWrKt0z27FYOucVBzjLPYj7lZYBjewhqidLACtxB6kbnJSyUvGQ23yZAo8FG
         JiQc1QznEZieyH69smWFZrDIxmw1VoW/0dBkbtDzyQvsHZYvw2zsx7AjzhTzPwcOaZ1B
         9zyUfD1WOVhm6U+xXX3hi9yrjgoTotaWh7dKuF2UI1MBwoxG/PdTPQqPF7hZOtADaS+E
         mdW6rsJnLkVaZ4yfZDZprqOChgcnrq5c5M6Fxgxu6ju2/41FIBY1Zi5uZ2nyVRNVAYf1
         rXXQ==
X-Gm-Message-State: AJcUuke4Bs/WCpKfYs2fenkUddRo0sMQQ2Ackeg83LI4CIPEYyxSP7x6
        KbZXbLWQ9BVx3a+N0N7CLLvBaSB2nQI=
X-Google-Smtp-Source: ALg8bN68xCiDKj22Cl19x+btn4LGMhmxJOoOwAACjR53c/M6mzwni0+Az23mahJkD0gg3B29lsd8Pw==
X-Received: by 2002:a1c:85d2:: with SMTP id h201mr17757575wmd.151.1547899333392;
        Sat, 19 Jan 2019 04:02:13 -0800 (PST)
Received: from localhost.localdomain ([87.71.51.33])
        by smtp.gmail.com with ESMTPSA id e27sm95011131wra.67.2019.01.19.04.02.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Jan 2019 04:02:12 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 6/6] media: vicodec: Add support for resolution change event.
Date:   Sat, 19 Jan 2019 04:01:56 -0800
Message-Id: <20190119120156.15851-7-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190119120156.15851-1-dafna3@gmail.com>
References: <20190119120156.15851-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

If the the queues are not streaming then the first resolution
change is handled in the buf_queue callback.
The following resolution change events are handled in job_ready.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 355 ++++++++++++++----
 1 file changed, 290 insertions(+), 65 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 2a95eca3cae6..de7d5ce0ec72 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -129,6 +129,8 @@ struct vicodec_ctx {
 	u32			comp_frame_size;
 	bool			comp_has_frame;
 	bool			comp_has_next_frame;
+	bool			first_source_change_sent;
+	bool			source_changed;
 };
 
 static inline struct vicodec_ctx *file2ctx(struct file *file)
@@ -322,6 +324,95 @@ static void job_remove_src_buf(struct vicodec_ctx *ctx, u32 state)
 	spin_unlock(ctx->lock);
 }
 
+static const struct v4l2_fwht_pixfmt_info *info_from_header(const struct fwht_cframe_hdr *p_hdr)
+{
+	unsigned int flags = ntohl(p_hdr->flags);
+	unsigned int width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
+	unsigned int height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
+	unsigned int components_num = 3;
+	unsigned int pixenc = 0;
+	unsigned int version = ntohl(p_hdr->version);
+
+	if (version == FWHT_VERSION) {
+		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
+				FWHT_FL_COMPONENTS_NUM_OFFSET);
+		pixenc = (flags & FWHT_FL_PIXENC_MSK);
+	}
+	return v4l2_fwht_default_fmt(width_div, height_div,
+				     components_num, pixenc, 0);
+}
+
+static bool is_header_valid(const struct fwht_cframe_hdr *p_hdr)
+{
+	const struct v4l2_fwht_pixfmt_info *info;
+	unsigned int w = ntohl(p_hdr->width);
+	unsigned int h = ntohl(p_hdr->height);
+	unsigned int version = ntohl(p_hdr->version);
+	unsigned int flags = ntohl(p_hdr->flags);
+
+	if (!version || version > FWHT_VERSION)
+		return false;
+
+	if (w < MIN_WIDTH || w > MAX_WIDTH || h < MIN_HEIGHT || h > MAX_HEIGHT)
+		return false;
+
+	if (version == FWHT_VERSION) {
+		unsigned int components_num = 1 +
+			((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
+			FWHT_FL_COMPONENTS_NUM_OFFSET);
+		unsigned int pixenc = flags & FWHT_FL_PIXENC_MSK;
+
+		if (components_num == 0 || components_num > 4 || !pixenc)
+			return false;
+	}
+
+	info = info_from_header(p_hdr);
+	if (!info)
+		return false;
+	return true;
+}
+
+static void update_capture_data_from_header(struct vicodec_ctx *ctx)
+{
+	struct vicodec_q_data *q_dst = get_q_data(ctx,
+						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	const struct fwht_cframe_hdr *p_hdr = &ctx->state.header;
+	const struct v4l2_fwht_pixfmt_info *info = info_from_header(p_hdr);
+	unsigned int flags = ntohl(p_hdr->flags);
+	unsigned int hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
+	unsigned int hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
+
+	q_dst->info = info;
+	q_dst->visible_width = ntohl(p_hdr->width);
+	q_dst->visible_height = ntohl(p_hdr->height);
+	q_dst->coded_width = vic_round_dim(q_dst->visible_width, hdr_width_div);
+	q_dst->coded_height = vic_round_dim(q_dst->visible_height,
+					    hdr_height_div);
+
+	q_dst->sizeimage = q_dst->coded_width * q_dst->coded_height *
+		q_dst->info->sizeimage_mult / q_dst->info->sizeimage_div;
+	ctx->state.colorspace = ntohl(p_hdr->colorspace);
+
+	ctx->state.xfer_func = ntohl(p_hdr->xfer_func);
+	ctx->state.ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
+	ctx->state.quantization = ntohl(p_hdr->quantization);
+}
+
+static void set_last_buffer(struct vb2_v4l2_buffer *dst_buf,
+			    const struct vb2_v4l2_buffer *src_buf,
+			    struct vicodec_ctx *ctx)
+{
+	struct vicodec_q_data *q_dst = get_q_data(ctx,
+						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	vb2_set_plane_payload(&dst_buf->vb2_buf, 0, 0);
+	dst_buf->sequence = q_dst->sequence++;
+
+	v4l2_m2m_buf_copy_data(src_buf, dst_buf, !ctx->is_enc);
+	dst_buf->flags |= V4L2_BUF_FLAG_LAST;
+	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
+}
+
 static int job_ready(void *priv)
 {
 	static const u8 magic[] = {
@@ -333,7 +424,15 @@ static int job_ready(void *priv)
 	u8 *p;
 	u32 sz;
 	u32 state;
-
+	struct vicodec_q_data *q_dst = get_q_data(ctx,
+						  V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	unsigned int flags;
+	unsigned int hdr_width_div;
+	unsigned int hdr_height_div;
+	unsigned int max_to_copy;
+
+	if (ctx->source_changed)
+		return 0;
 	if (ctx->is_enc || ctx->comp_has_frame)
 		return 1;
 
@@ -356,12 +455,19 @@ static int job_ready(void *priv)
 		}
 
 		ctx->comp_frame_size = ntohl(ctx->state.header.size);
-
-		if (ctx->comp_frame_size > ctx->comp_max_size)
-			ctx->comp_frame_size = ctx->comp_max_size;
 	}
-	if (ctx->comp_size < ctx->comp_frame_size) {
-		u32 copy = ctx->comp_frame_size - ctx->comp_size;
+
+	/*
+	 * The current scanned frame might be the first frame of a new
+	 * resolution so its size might be larger than ctx->comp_max_size.
+	 * In that case it is copied up to the current buffer capacity and
+	 * the copy will continue after allocating new large enough buffer
+	 * when restreaming
+	 */
+	max_to_copy = min(ctx->comp_frame_size, ctx->comp_max_size);
+
+	if (ctx->comp_size < max_to_copy) {
+		u32 copy = max_to_copy - ctx->comp_size;
 
 		if (copy > p_src + sz - p)
 			copy = p_src + sz - p;
@@ -370,15 +476,16 @@ static int job_ready(void *priv)
 		       p, copy);
 		p += copy;
 		ctx->comp_size += copy;
-		if (ctx->comp_size < ctx->comp_frame_size) {
+		if (ctx->comp_size < max_to_copy) {
 			job_remove_src_buf(ctx, state);
 			goto restart;
 		}
 	}
 	ctx->cur_buf_offset = p - p_src;
-	ctx->comp_has_frame = true;
+	if (ctx->comp_size == ctx->comp_frame_size)
+		ctx->comp_has_frame = true;
 	ctx->comp_has_next_frame = false;
-	if (sz - ctx->cur_buf_offset >= sizeof(struct fwht_cframe_hdr)) {
+	if (ctx->comp_has_frame && sz - ctx->cur_buf_offset >= sizeof(struct fwht_cframe_hdr)) {
 		struct fwht_cframe_hdr *p_hdr = (struct fwht_cframe_hdr *)p;
 		u32 frame_size = ntohl(p_hdr->size);
 		u32 remaining = sz - ctx->cur_buf_offset - sizeof(*p_hdr);
@@ -386,6 +493,36 @@ static int job_ready(void *priv)
 		if (!memcmp(p, magic, sizeof(magic)))
 			ctx->comp_has_next_frame = remaining >= frame_size;
 	}
+	/*
+	 * if the header is invalid the device_run will just drop the frame
+	 * with an error
+	 */
+	if (!is_header_valid(&ctx->state.header) && ctx->comp_has_frame)
+		return 1;
+	flags = ntohl(ctx->state.header.flags);
+	hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
+	hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
+
+	if (ntohl(ctx->state.header.width) != q_dst->visible_width ||
+	    ntohl(ctx->state.header.height) != q_dst->visible_height ||
+	    !q_dst->info ||
+	    hdr_width_div != q_dst->info->width_div ||
+	    hdr_height_div != q_dst->info->height_div) {
+		static const struct v4l2_event rs_event = {
+			.type = V4L2_EVENT_SOURCE_CHANGE,
+			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+		};
+
+		struct vb2_v4l2_buffer *dst_buf =
+			v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+
+		update_capture_data_from_header(ctx);
+		ctx->first_source_change_sent = true;
+		v4l2_event_queue_fh(&ctx->fh, &rs_event);
+		set_last_buffer(dst_buf, src_buf, ctx);
+		ctx->source_changed = true;
+		return 0;
+	}
 	return 1;
 }
 
@@ -425,7 +562,7 @@ static int enum_fmt(struct v4l2_fmtdesc *f, struct vicodec_ctx *ctx, bool is_out
 	if (is_uncomp) {
 		const struct v4l2_fwht_pixfmt_info *info = get_q_data(ctx, f->type)->info;
 
-		if (ctx->is_enc)
+		if (!info || ctx->is_enc)
 			info = v4l2_fwht_get_pixfmt(f->index);
 		else
 			info = v4l2_fwht_default_fmt(info->width_div,
@@ -475,6 +612,9 @@ static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 	q_data = get_q_data(ctx, f->type);
 	info = q_data->info;
 
+	if (!info)
+		info = v4l2_fwht_get_pixfmt(0);
+
 	switch (f->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
@@ -673,6 +813,7 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix = &f->fmt.pix;
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
+				!q_data->info ||
 				q_data->info->id != pix->pixelformat ||
 				q_data->coded_width != pix->width ||
 				q_data->coded_height != pix->height;
@@ -693,6 +834,7 @@ static int vidioc_s_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
 		pix_mp = &f->fmt.pix_mp;
 		if (ctx->is_enc && V4L2_TYPE_IS_OUTPUT(f->type))
 			fmt_changed =
+				!q_data->info ||
 				q_data->info->id != pix_mp->pixelformat ||
 				q_data->coded_width != pix_mp->width ||
 				q_data->coded_height != pix_mp->height;
@@ -948,6 +1090,7 @@ static int vicodec_subscribe_event(struct v4l2_fh *fh,
 {
 	switch (sub->type) {
 	case V4L2_EVENT_EOS:
+	case V4L2_EVENT_SOURCE_CHANGE:
 		return v4l2_event_subscribe(fh, sub, 0, NULL);
 	default:
 		return v4l2_ctrl_subscribe_event(fh, sub);
@@ -1056,7 +1199,70 @@ static void vicodec_buf_queue(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vicodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	unsigned int sz = vb2_get_plane_payload(&vbuf->vb2_buf, 0);
+	u8 *p_src = vb2_plane_vaddr(&vbuf->vb2_buf, 0);
+	u8 *p = p_src;
+	struct vb2_queue *vq_out = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+						   V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	struct vb2_queue *vq_cap = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+						   V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	bool header_valid = false;
+	static const struct v4l2_event rs_event = {
+		.type = V4L2_EVENT_SOURCE_CHANGE,
+		.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
+	};
+
+	/* buf_queue handles only the first source change event */
+	if (ctx->first_source_change_sent) {
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+		return;
+	}
+
+	/*
+	 * if both queues are streaming, the source change event is
+	 * handled in job_ready
+	 */
+	if (vb2_is_streaming(vq_cap) && vb2_is_streaming(vq_out)) {
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+		return;
+	}
+
+	/*
+	 * source change event is relevant only for the decoder
+	 * in the compressed stream
+	 */
+	if (ctx->is_enc || !V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
+		return;
+	}
+
+	do {
+		enum vb2_buffer_state state =
+			get_next_header(ctx, &p, p_src + sz - p);
+
+		if (ctx->header_size < sizeof(struct fwht_cframe_hdr)) {
+			v4l2_m2m_buf_done(vbuf, state);
+			return;
+		}
+		header_valid = is_header_valid(&ctx->state.header);
+		/*
+		 * p points right after the end of the header in the
+		 * buffer. If the header is invalid we set p to point
+		 * to the next byte after the start of the header
+		 */
+		if (!header_valid) {
+			p = p - sizeof(struct fwht_cframe_hdr) + 1;
+			ctx->header_size = 0;
+			ctx->comp_magic_cnt = 0;
+		}
+
+	} while (!header_valid);
+	if (p < p_src + sz)
+		ctx->cur_buf_offset = p - p_src;
 
+	update_capture_data_from_header(ctx);
+	ctx->first_source_change_sent = true;
+	v4l2_event_queue_fh(&ctx->fh, &rs_event);
 	v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 }
 
@@ -1086,50 +1292,68 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	struct v4l2_fwht_state *state = &ctx->state;
 	const struct v4l2_fwht_pixfmt_info *info = q_data->info;
 	unsigned int size = q_data->coded_width * q_data->coded_height;
-	unsigned int chroma_div = info->width_div * info->height_div;
+	unsigned int chroma_div;
 	unsigned int total_planes_size;
+	u8 *new_comp_frame;
 
-	/*
-	 * we don't know ahead how many components are in the encoding type
-	 * V4L2_PIX_FMT_FWHT, so we will allocate space for 4 planes.
-	 */
-	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num == 4)
+	if (!info)
+		return -EINVAL;
+
+	chroma_div = info->width_div * info->height_div;
+	q_data->sequence = 0;
+
+	ctx->last_src_buf = NULL;
+	ctx->last_dst_buf = NULL;
+	state->gop_cnt = 0;
+
+	if ((V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
+	    (!V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc))
+		return 0;
+
+	if (info->id == V4L2_PIX_FMT_FWHT) {
+		vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
+		return -EINVAL;
+	}
+	if (info->components_num == 4)
 		total_planes_size = 2 * size + 2 * (size / chroma_div);
 	else if (info->components_num == 3)
 		total_planes_size = size + 2 * (size / chroma_div);
 	else
 		total_planes_size = size;
 
-	q_data->sequence = 0;
-
-	if (!V4L2_TYPE_IS_OUTPUT(q->type)) {
-		if (!ctx->is_enc) {
-			state->visible_width = q_data->visible_width;
-			state->visible_height = q_data->visible_height;
-			state->coded_width = q_data->coded_width;
-			state->coded_height = q_data->coded_height;
-			state->stride = q_data->coded_width * info->bytesperline_mult;
-		}
-		return 0;
-	}
+	state->visible_width = q_data->visible_width;
+	state->visible_height = q_data->visible_height;
+	state->coded_width = q_data->coded_width;
+	state->coded_height = q_data->coded_height;
+	state->stride = q_data->coded_width * info->bytesperline_mult;
 
-	if (ctx->is_enc) {
-		state->visible_width = q_data->visible_width;
-		state->visible_height = q_data->visible_height;
-		state->coded_width = q_data->coded_width;
-		state->coded_height = q_data->coded_height;
-		state->stride = q_data->coded_width * info->bytesperline_mult;
-	}
 	state->ref_frame.luma = kvmalloc(total_planes_size, GFP_KERNEL);
 	ctx->comp_max_size = total_planes_size;
-	state->compressed_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
-	if (!state->ref_frame.luma || !state->compressed_frame) {
+	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
+
+	if (!state->ref_frame.luma || !new_comp_frame) {
 		kvfree(state->ref_frame.luma);
-		kvfree(state->compressed_frame);
+		kvfree(new_comp_frame);
 		vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
 		return -ENOMEM;
 	}
-	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num >= 3) {
+	/*
+	 * if state->compressed_frame was already allocated then
+	 * it contain data of the first frame of the new resolution
+	 */
+	if (state->compressed_frame) {
+		if (ctx->comp_size > ctx->comp_max_size) {
+			ctx->comp_size = ctx->comp_max_size;
+			ctx->comp_frame_size = ctx->comp_max_size;
+		}
+		memcpy(new_comp_frame,
+		       state->compressed_frame, ctx->comp_size);
+	}
+
+	kvfree(state->compressed_frame);
+	state->compressed_frame = new_comp_frame;
+
+	if (info->components_num >= 3) {
 		state->ref_frame.cb = state->ref_frame.luma + size;
 		state->ref_frame.cr = state->ref_frame.cb + size / chroma_div;
 	} else {
@@ -1137,21 +1361,11 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		state->ref_frame.cr = NULL;
 	}
 
-	if (info->id == V4L2_PIX_FMT_FWHT || info->components_num == 4)
+	if (info->components_num == 4)
 		state->ref_frame.alpha =
 			state->ref_frame.cr + size / chroma_div;
 	else
 		state->ref_frame.alpha = NULL;
-
-	ctx->last_src_buf = NULL;
-	ctx->last_dst_buf = NULL;
-	state->gop_cnt = 0;
-	ctx->cur_buf_offset = 0;
-	ctx->comp_size = 0;
-	ctx->header_size = 0;
-	ctx->comp_magic_cnt = 0;
-	ctx->comp_has_frame = false;
-
 	return 0;
 }
 
@@ -1161,11 +1375,21 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 
 	vicodec_return_bufs(q, VB2_BUF_STATE_ERROR);
 
-	if (!V4L2_TYPE_IS_OUTPUT(q->type))
-		return;
-
-	kvfree(ctx->state.ref_frame.luma);
-	kvfree(ctx->state.compressed_frame);
+	if ((!V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
+	    (V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc)) {
+		kvfree(ctx->state.ref_frame.luma);
+		ctx->comp_max_size = 0;
+		ctx->source_changed = false;
+	}
+	if (V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) {
+		ctx->cur_buf_offset = 0;
+		ctx->comp_size = 0;
+		ctx->header_size = 0;
+		ctx->comp_magic_cnt = 0;
+		ctx->comp_frame_size = 0;
+		ctx->comp_has_frame = 0;
+		ctx->comp_has_next_frame = 0;
+	}
 }
 
 static const struct vb2_ops vicodec_qops = {
@@ -1317,16 +1541,17 @@ static int vicodec_open(struct file *file)
 	else
 		ctx->q_data[V4L2_M2M_SRC].sizeimage =
 			size + sizeof(struct fwht_cframe_hdr);
-	ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
-	ctx->q_data[V4L2_M2M_DST].info =
-		ctx->is_enc ? &pixfmt_fwht : v4l2_fwht_get_pixfmt(0);
-	size = 1280 * 720 * ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
-		ctx->q_data[V4L2_M2M_DST].info->sizeimage_div;
-	if (ctx->is_enc)
-		ctx->q_data[V4L2_M2M_DST].sizeimage =
-			size + sizeof(struct fwht_cframe_hdr);
-	else
-		ctx->q_data[V4L2_M2M_DST].sizeimage = size;
+	if (ctx->is_enc) {
+		ctx->q_data[V4L2_M2M_DST] = ctx->q_data[V4L2_M2M_SRC];
+		ctx->q_data[V4L2_M2M_DST].info = &pixfmt_fwht;
+		ctx->q_data[V4L2_M2M_DST].sizeimage = 1280 * 720 *
+			ctx->q_data[V4L2_M2M_DST].info->sizeimage_mult /
+			ctx->q_data[V4L2_M2M_DST].info->sizeimage_div +
+			sizeof(struct fwht_cframe_hdr);
+	} else {
+		ctx->q_data[V4L2_M2M_DST].info = NULL;
+	}
+
 	ctx->state.colorspace = V4L2_COLORSPACE_REC709;
 
 	if (ctx->is_enc) {
-- 
2.17.1


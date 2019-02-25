Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E322C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42B08213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 22:22:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TZYysUX0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727490AbfBYWWw (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 17:22:52 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:55695 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728441AbfBYWWw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 17:22:52 -0500
Received: by mail-wm1-f68.google.com with SMTP id q187so493177wme.5
        for <linux-media@vger.kernel.org>; Mon, 25 Feb 2019 14:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0Vmpqqybk0Ly4zuzw4qW4U6M8qZsIaECxOD5uUc5IxY=;
        b=TZYysUX05119Zce/i+TLNs4AUKYfC18TBDZo0FRBiTigiNLv4qg8HzC1cr1BAglPRZ
         cPfsuGvOccRTG3ShyssGZYE4jeARXz+VDELG8yGvwXVZ6gMOGOMkAeoidLwbPaZtX5++
         viCqA9tn9Umxnigr/fOs6YnS6Ge/XfkWDQTECs263vu6rPhfwOCvisBhDQHeMZU6dbAH
         QGeCdZWymr+LJ6+PnR/e72HvGtP2EZnKZhB/LTCOqUdHie5cuZvFNFtdp/+NU7OFQWKg
         d2nuwPyNqKfe+4sbkZW2uusn2QydTvAU8IwJH+2KQfKijui8oFnxdbWjwYtyTDhhg9Ho
         zU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0Vmpqqybk0Ly4zuzw4qW4U6M8qZsIaECxOD5uUc5IxY=;
        b=kdHMxLu699KrkNTJMDOJaSv/R2PBTKfZKQT+Uy/SN0UUELfGvirUIVW5t5O2gHhiDP
         2r5eBlpFfHfjNp8q6pI171vCfNEapofvUfL+32nS0ms50rf757im+Z8XMgENvJUT5yh8
         Coz/wY7G15wOsp7zr5E8YhcII/B9MIwNM8BfSSg4G3A/03NMrRSXYrzeb/hGNeNpBM90
         BY/aPeXMzPh8rgXJHtSyAbIgzEajXY4Ywms3s9+3JZRGvFwTYFNuKiO3AbJ0Z7wrEchs
         BZAY+zhgX/bjaKOD9ZsvfrnEBYljzZEW4+IX0EHSJrZw4jjSU/Q9J9VLXwn8OxEnyXsZ
         nBSQ==
X-Gm-Message-State: AHQUAuagILk1SmgvIHtgdKnX0JrpaFuZCB7HIkNx95rMZee6QuMW7sbz
        JMTpKnxdGUwO6d2poCXIt7EcOm3vdlo=
X-Google-Smtp-Source: AHgI3IaTiJOujXwEtCX4SlPTlRThNXZnFAA9UTyBCDkXkOpd8xHLVb0m0tk0KM5jSnEJ8tE/90HVzQ==
X-Received: by 2002:a1c:cb86:: with SMTP id b128mr566494wmg.46.1551133368633;
        Mon, 25 Feb 2019 14:22:48 -0800 (PST)
Received: from ubuntu.home ([77.127.107.32])
        by smtp.gmail.com with ESMTPSA id p16sm24061977wro.25.2019.02.25.14.22.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 14:22:48 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH v4 21/21] media: vicodec: Add support for stateless decoder.
Date:   Mon, 25 Feb 2019 14:22:39 -0800
Message-Id: <20190225222239.121770-2-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190225222239.121770-1-dafna3@gmail.com>
References: <20190225222239.121770-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Implement a stateless decoder for the new node.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 .../media/platform/vicodec/codec-v4l2-fwht.h  |   1 +
 drivers/media/platform/vicodec/vicodec-core.c | 285 ++++++++++++++++--
 2 files changed, 262 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
index b59503d4049a..1a0d2a9f931a 100644
--- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
+++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
@@ -44,6 +44,7 @@ struct v4l2_fwht_state {
 	struct fwht_raw_frame ref_frame;
 	struct fwht_cframe_hdr header;
 	u8 *compressed_frame;
+	u64 ref_frame_ts;
 };
 
 const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat);
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 9e67c1fd81a4..f8d89ed8b9a5 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -214,6 +214,41 @@ static bool validate_by_version(unsigned int flags, unsigned int version)
 	return true;
 }
 
+static bool validate_stateless_params_flags(const struct v4l2_ctrl_fwht_params *params,
+					    const struct v4l2_fwht_pixfmt_info *cur_info)
+{
+	unsigned int width_div =
+		(params->flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
+	unsigned int height_div =
+		(params->flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
+	unsigned int components_num = 3;
+	unsigned int pixenc = 0;
+
+	if (params->version < 3)
+		return false;
+
+	components_num = 1 + ((params->flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
+			      FWHT_FL_COMPONENTS_NUM_OFFSET);
+	pixenc = (params->flags & FWHT_FL_PIXENC_MSK);
+	if (v4l2_fwht_validate_fmt(cur_info, width_div, height_div,
+				    components_num, pixenc))
+		return true;
+	return false;
+}
+
+
+static void update_state_from_header(struct vicodec_ctx *ctx)
+{
+	const struct fwht_cframe_hdr *p_hdr = &ctx->state.header;
+
+	ctx->state.visible_width = ntohl(p_hdr->width);
+	ctx->state.visible_height = ntohl(p_hdr->height);
+	ctx->state.colorspace = ntohl(p_hdr->colorspace);
+	ctx->state.xfer_func = ntohl(p_hdr->xfer_func);
+	ctx->state.ycbcr_enc = ntohl(p_hdr->ycbcr_enc);
+	ctx->state.quantization = ntohl(p_hdr->quantization);
+}
+
 static int device_process(struct vicodec_ctx *ctx,
 			  struct vb2_v4l2_buffer *src_vb,
 			  struct vb2_v4l2_buffer *dst_vb)
@@ -221,12 +256,44 @@ static int device_process(struct vicodec_ctx *ctx,
 	struct vicodec_dev *dev = ctx->dev;
 	struct v4l2_fwht_state *state = &ctx->state;
 	u8 *p_src, *p_dst;
-	int ret;
+	int ret = 0;
 
-	if (ctx->is_enc)
+	if (ctx->is_enc || ctx->is_stateless)
 		p_src = vb2_plane_vaddr(&src_vb->vb2_buf, 0);
 	else
 		p_src = state->compressed_frame;
+
+	if (ctx->is_stateless) {
+		struct media_request *src_req = src_vb->vb2_buf.req_obj.req;
+
+		ret = v4l2_ctrl_request_setup(src_req, &ctx->hdl);
+		if (ret)
+			return ret;
+		update_state_from_header(ctx);
+
+		/*
+		 * set the reference buffer from the reference timestamp
+		 * only if this is a P-frame
+		 */
+		if (!(ntohl(ctx->state.header.flags) & FWHT_FL_I_FRAME)) {
+			struct vb2_buffer *ref_vb2_buf;
+			int ref_buf_idx;
+			struct vb2_queue *vq_cap =
+				v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+						V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+			ref_buf_idx = vb2_find_timestamp(vq_cap,
+							 ctx->state.ref_frame_ts, 0);
+			if (ref_buf_idx < 0)
+				return -EINVAL;
+
+			ref_vb2_buf = vq_cap->bufs[ref_buf_idx];
+			if (ref_vb2_buf->state == VB2_BUF_STATE_ERROR)
+				ret = -EINVAL;
+			ctx->state.ref_frame.buf =
+				vb2_plane_vaddr(ref_vb2_buf, 0);
+		}
+	}
 	p_dst = vb2_plane_vaddr(&dst_vb->vb2_buf, 0);
 	if (!p_src || !p_dst) {
 		v4l2_err(&dev->v4l2_dev,
@@ -255,11 +322,12 @@ static int device_process(struct vicodec_ctx *ctx,
 		ret = v4l2_fwht_decode(state, p_src, p_dst);
 		if (ret < 0)
 			return ret;
-		copy_cap_to_ref(p_dst, ctx->state.info, &ctx->state);
+		if (!ctx->is_stateless)
+			copy_cap_to_ref(p_dst, ctx->state.info, &ctx->state);
 
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
 	}
-	return 0;
+	return ret;
 }
 
 /*
@@ -334,9 +402,13 @@ static void device_run(void *priv)
 	struct vb2_v4l2_buffer *src_buf, *dst_buf;
 	struct vicodec_q_data *q_src, *q_dst;
 	u32 state;
+	struct media_request *src_req;
+
 
 	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
+	src_req = src_buf->vb2_buf.req_obj.req;
+
 	q_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 	q_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 
@@ -355,7 +427,7 @@ static void device_run(void *priv)
 		dst_buf->flags |= V4L2_BUF_FLAG_LAST;
 		v4l2_event_queue_fh(&ctx->fh, &eos_event);
 	}
-	if (ctx->is_enc) {
+	if (ctx->is_enc || ctx->is_stateless) {
 		src_buf->sequence = q_src->sequence++;
 		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, state);
@@ -367,6 +439,9 @@ static void device_run(void *priv)
 		ctx->comp_has_next_frame = false;
 	}
 	v4l2_m2m_buf_done(dst_buf, state);
+	if (ctx->is_stateless && src_req)
+		v4l2_ctrl_request_complete(src_req, &ctx->hdl);
+
 	ctx->comp_size = 0;
 	ctx->header_size = 0;
 	ctx->comp_magic_cnt = 0;
@@ -445,6 +520,12 @@ static void update_capture_data_from_header(struct vicodec_ctx *ctx)
 	unsigned int hdr_width_div = (flags & FWHT_FL_CHROMA_FULL_WIDTH) ? 1 : 2;
 	unsigned int hdr_height_div = (flags & FWHT_FL_CHROMA_FULL_HEIGHT) ? 1 : 2;
 
+	/*
+	 * This function should not be used by a stateless codec since
+	 * it changes values in q_data that are not request specific
+	 */
+	WARN_ON(ctx->is_stateless);
+
 	q_dst->info = info;
 	q_dst->visible_width = ntohl(p_hdr->width);
 	q_dst->visible_height = ntohl(p_hdr->height);
@@ -497,7 +578,7 @@ static int job_ready(void *priv)
 
 	if (ctx->source_changed)
 		return 0;
-	if (ctx->is_enc || ctx->comp_has_frame)
+	if (ctx->is_stateless || ctx->is_enc || ctx->comp_has_frame)
 		return 1;
 
 restart:
@@ -1243,6 +1324,14 @@ static int vicodec_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	return 0;
 }
 
+static int vicodec_buf_out_validate(struct vb2_buffer *vb)
+{
+	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+	vbuf->field = V4L2_FIELD_NONE;
+	return 0;
+}
+
 static int vicodec_buf_prepare(struct vb2_buffer *vb)
 {
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
@@ -1306,10 +1395,11 @@ static void vicodec_buf_queue(struct vb2_buffer *vb)
 	}
 
 	/*
-	 * source change event is relevant only for the decoder
+	 * source change event is relevant only for the stateful decoder
 	 * in the compressed stream
 	 */
-	if (ctx->is_enc || !V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
+	if (ctx->is_stateless || ctx->is_enc ||
+	    !V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
 		v4l2_m2m_buf_queue(ctx->fh.m2m_ctx, vbuf);
 		return;
 	}
@@ -1357,12 +1447,33 @@ static void vicodec_return_bufs(struct vb2_queue *q, u32 state)
 			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		if (vbuf == NULL)
 			return;
+		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
+					   &ctx->hdl);
 		spin_lock(ctx->lock);
 		v4l2_m2m_buf_done(vbuf, state);
 		spin_unlock(ctx->lock);
 	}
 }
 
+static unsigned int total_frame_size(struct vicodec_q_data *q_data)
+{
+	unsigned int size;
+	unsigned int chroma_div;
+
+	if (!q_data->info) {
+		WARN_ON(1);
+		return 0;
+	}
+	size = q_data->coded_width * q_data->coded_height;
+	chroma_div = q_data->info->width_div * q_data->info->height_div;
+
+	if (q_data->info->components_num == 4)
+		return 2 * size + 2 * (size / chroma_div);
+	else if (q_data->info->components_num == 3)
+		return size + 2 * (size / chroma_div);
+	return size;
+}
+
 static int vicodec_start_streaming(struct vb2_queue *q,
 				   unsigned int count)
 {
@@ -1373,7 +1484,7 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	unsigned int size = q_data->coded_width * q_data->coded_height;
 	unsigned int chroma_div;
 	unsigned int total_planes_size;
-	u8 *new_comp_frame;
+	u8 *new_comp_frame = NULL;
 
 	if (!info)
 		return -EINVAL;
@@ -1393,12 +1504,8 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 		vicodec_return_bufs(q, VB2_BUF_STATE_QUEUED);
 		return -EINVAL;
 	}
-	if (info->components_num == 4)
-		total_planes_size = 2 * size + 2 * (size / chroma_div);
-	else if (info->components_num == 3)
-		total_planes_size = size + 2 * (size / chroma_div);
-	else
-		total_planes_size = size;
+	total_planes_size = total_frame_size(q_data);
+	ctx->comp_max_size = total_planes_size;
 
 	state->visible_width = q_data->visible_width;
 	state->visible_height = q_data->visible_height;
@@ -1407,10 +1514,14 @@ static int vicodec_start_streaming(struct vb2_queue *q,
 	state->stride = q_data->coded_width *
 				info->bytesperline_mult;
 
+	if (ctx->is_stateless) {
+		state->ref_stride = state->stride;
+		return 0;
+	}
 	state->ref_stride = q_data->coded_width * info->luma_alpha_step;
+
 	state->ref_frame.buf = kvmalloc(total_planes_size, GFP_KERNEL);
 	state->ref_frame.luma = state->ref_frame.buf;
-	ctx->comp_max_size = total_planes_size;
 	new_comp_frame = kvmalloc(ctx->comp_max_size, GFP_KERNEL);
 
 	if (!state->ref_frame.luma || !new_comp_frame) {
@@ -1458,7 +1569,8 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 
 	if ((!V4L2_TYPE_IS_OUTPUT(q->type) && !ctx->is_enc) ||
 	    (V4L2_TYPE_IS_OUTPUT(q->type) && ctx->is_enc)) {
-		kvfree(ctx->state.ref_frame.buf);
+		if (!ctx->is_stateless)
+			kvfree(ctx->state.ref_frame.buf);
 		ctx->state.ref_frame.buf = NULL;
 		ctx->state.ref_frame.luma = NULL;
 		ctx->comp_max_size = 0;
@@ -1474,14 +1586,24 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
 	}
 }
 
+static void vicodec_buf_request_complete(struct vb2_buffer *vb)
+{
+	struct vicodec_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+	v4l2_ctrl_request_complete(vb->req_obj.req, &ctx->hdl);
+}
+
+
 static const struct vb2_ops vicodec_qops = {
-	.queue_setup	 = vicodec_queue_setup,
-	.buf_prepare	 = vicodec_buf_prepare,
-	.buf_queue	 = vicodec_buf_queue,
-	.start_streaming = vicodec_start_streaming,
-	.stop_streaming  = vicodec_stop_streaming,
-	.wait_prepare	 = vb2_ops_wait_prepare,
-	.wait_finish	 = vb2_ops_wait_finish,
+	.queue_setup		= vicodec_queue_setup,
+	.buf_out_validate	= vicodec_buf_out_validate,
+	.buf_prepare		= vicodec_buf_prepare,
+	.buf_queue		= vicodec_buf_queue,
+	.buf_request_complete	= vicodec_buf_request_complete,
+	.start_streaming	= vicodec_start_streaming,
+	.stop_streaming		= vicodec_stop_streaming,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
@@ -1525,10 +1647,59 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	return vb2_queue_init(dst_vq);
 }
 
+static int vicodec_try_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct vicodec_ctx *ctx = container_of(ctrl->handler,
+			struct vicodec_ctx, hdl);
+	const struct v4l2_ctrl_fwht_params *params;
+	struct vicodec_q_data *q_dst = get_q_data(ctx,
+			V4L2_BUF_TYPE_VIDEO_CAPTURE);
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_FWHT_PARAMS:
+		if (!q_dst->info)
+			return -EINVAL;
+		params = ctrl->p_new.p_fwht_params;
+		if (params->width > q_dst->coded_width ||
+		    params->width < MIN_WIDTH ||
+		    params->height > q_dst->coded_height ||
+		    params->height < MIN_HEIGHT)
+			return -EINVAL;
+		if (!validate_by_version(params->flags, params->version))
+			return -EINVAL;
+		if (!validate_stateless_params_flags(params, q_dst->info))
+			return -EINVAL;
+		if (params->comp_frame_size > total_frame_size(q_dst))
+			return -EINVAL;
+	default:
+		return 0;
+	}
+	return 0;
+}
+
+static void update_header_from_stateless_params(struct vicodec_ctx *ctx,
+						const struct v4l2_ctrl_fwht_params *params)
+{
+	struct fwht_cframe_hdr *p_hdr = &ctx->state.header;
+
+	p_hdr->magic1 = FWHT_MAGIC1;
+	p_hdr->magic2 = FWHT_MAGIC2;
+	p_hdr->version = htonl(params->version);
+	p_hdr->width = htonl(params->width);
+	p_hdr->height = htonl(params->height);
+	p_hdr->flags = htonl(params->flags);
+	p_hdr->colorspace = htonl(params->colorspace);
+	p_hdr->xfer_func = htonl(params->xfer_func);
+	p_hdr->ycbcr_enc = htonl(params->ycbcr_enc);
+	p_hdr->quantization = htonl(params->quantization);
+	p_hdr->size = htonl(params->comp_frame_size);
+}
+
 static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vicodec_ctx *ctx = container_of(ctrl->handler,
 					       struct vicodec_ctx, hdl);
+	const struct v4l2_ctrl_fwht_params *params;
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
@@ -1540,12 +1711,18 @@ static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_FWHT_P_FRAME_QP:
 		ctx->state.p_frame_qp = ctrl->val;
 		return 0;
+	case V4L2_CID_MPEG_VIDEO_FWHT_PARAMS:
+		params = ctrl->p_new.p_fwht_params;
+		update_header_from_stateless_params(ctx, params);
+		ctx->state.ref_frame_ts = params->backward_ref_ts;
+		return 0;
 	}
 	return -EINVAL;
 }
 
 static const struct v4l2_ctrl_ops vicodec_ctrl_ops = {
 	.s_ctrl = vicodec_s_ctrl,
+	.try_ctrl = vicodec_try_ctrl,
 };
 
 static const struct v4l2_ctrl_config vicodec_ctrl_i_frame = {
@@ -1571,6 +1748,7 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
 };
 
 static const struct v4l2_ctrl_config vicodec_ctrl_stateless_state = {
+	.ops		= &vicodec_ctrl_ops,
 	.id		= V4L2_CID_MPEG_VIDEO_FWHT_PARAMS,
 	.elem_size	= sizeof(struct v4l2_ctrl_fwht_params),
 	.name		= "FWHT-Stateless State Params",
@@ -1695,6 +1873,59 @@ static int vicodec_release(struct file *file)
 	return 0;
 }
 
+static int vicodec_request_validate(struct media_request *req)
+{
+	struct media_request_object *obj;
+	struct v4l2_ctrl_handler *parent_hdl, *hdl;
+	struct vicodec_ctx *ctx = NULL;
+	struct v4l2_ctrl *ctrl;
+	unsigned int count;
+
+	list_for_each_entry(obj, &req->objects, list) {
+		struct vb2_buffer *vb;
+
+		if (vb2_request_object_is_buffer(obj)) {
+			vb = container_of(obj, struct vb2_buffer, req_obj);
+			ctx = vb2_get_drv_priv(vb->vb2_queue);
+
+			break;
+		}
+	}
+
+	if (!ctx) {
+		pr_err("No buffer was provided with the request\n");
+		return -ENOENT;
+	}
+
+	count = vb2_request_buffer_cnt(req);
+	if (!count) {
+		v4l2_info(&ctx->dev->v4l2_dev,
+			  "No buffer was provided with the request\n");
+		return -ENOENT;
+	} else if (count > 1) {
+		v4l2_info(&ctx->dev->v4l2_dev,
+			  "More than one buffer was provided with the request\n");
+		return -EINVAL;
+	}
+
+	parent_hdl = &ctx->hdl;
+
+	hdl = v4l2_ctrl_request_hdl_find(req, parent_hdl);
+	if (!hdl) {
+		v4l2_info(&ctx->dev->v4l2_dev, "Missing codec control\n");
+		return -ENOENT;
+	}
+	ctrl = v4l2_ctrl_request_hdl_ctrl_find(hdl,
+					       vicodec_ctrl_stateless_state.id);
+	if (!ctrl) {
+		v4l2_info(&ctx->dev->v4l2_dev,
+			  "Missing required codec control\n");
+		return -ENOENT;
+	}
+
+	return vb2_request_validate(req);
+}
+
 static const struct v4l2_file_operations vicodec_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vicodec_open,
@@ -1713,6 +1944,11 @@ static const struct video_device vicodec_videodev = {
 	.release	= video_device_release_empty,
 };
 
+static const struct media_device_ops vicodec_m2m_media_ops = {
+	.req_validate	= vicodec_request_validate,
+	.req_queue	= v4l2_m2m_request_queue,
+};
+
 static const struct v4l2_m2m_ops m2m_ops = {
 	.device_run	= device_run,
 	.job_ready	= job_ready,
@@ -1779,6 +2015,7 @@ static int vicodec_probe(struct platform_device *pdev)
 	strscpy(dev->mdev.bus_info, "platform:vicodec",
 		sizeof(dev->mdev.bus_info));
 	media_device_init(&dev->mdev);
+	dev->mdev.ops = &vicodec_m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;
 #endif
 
-- 
2.17.1


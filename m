Return-Path: <SRS0=QP2W=QQ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1A9C282C4
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 266C9218D2
	for <linux-media@archiver.kernel.org>; Sat,  9 Feb 2019 13:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T9O7EDDu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfBINyy (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 9 Feb 2019 08:54:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38385 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfBINyy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2019 08:54:54 -0500
Received: by mail-wm1-f66.google.com with SMTP id v26so8297531wmh.3
        for <linux-media@vger.kernel.org>; Sat, 09 Feb 2019 05:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=00IfhbUtWS0TxPCLp7rmv74Wc3CQ4VvvKeR5e7YksWs=;
        b=T9O7EDDuUoutFkDHo31ibCG+rb3Pzj6f/8UDFN847zRDngDA1+JVKJ7Kf2KcwZDw3a
         XXYuC+MCl4KyJfzH+2YTJRYhN9ccbC3AWcIuxnlPTOj4g9X/K/b2W0RmH3xiDuEZQo+Y
         A9GYaDGTzKgE9zckhWeBLA50ypMvtmYcqqErI2RdU0w7XGslo67xV+RJsLdxqXV8ZRb+
         RPiYo+8liG6LSlbJH/0V53Ab9IoSPOx71EtMkA+mVga65bRqIIW61SsHUFvG/oPFXfMl
         lvxb0G85xLfzIOdPYNvJoxBaEPD6Dg6judyrQfaVZQiLr8scsEJ3kadAjYT58uHYsVlG
         6xHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=00IfhbUtWS0TxPCLp7rmv74Wc3CQ4VvvKeR5e7YksWs=;
        b=kV55MEwWtLRuDRwD4AAtWKBno1QPbNT4BfqJdjCaCfsGZvDcWYkDxRKnzymmJiRBml
         QwtwdhUykW0XEOOXR7grZyDUQIEIRGRyBQHIL8owjTTF2Vg5B5tpRrie8AAG2183IgeN
         fhWbklNkTmRZ/K6dCnU3aVfjaF1OXik1FzShWvCCcfErhyY5m71wCkvNrv1PSHQWXGyd
         NcSGvl8MGSaMamCio203n0fEZdbbMoTKed/2Q+ql8ptDLcT2PKRhZJnaUeimYtqLUJO/
         WFX45BZjlm8riM/3RiAIWtFjrFG/C9M4CiUUOMGo+4wv1P7oG8AbZcf5qzfisTbtCruu
         OnCw==
X-Gm-Message-State: AHQUAuY37sGDm8Yq1a1KqzLUQIV73R+jETbSpqYCRCfDwhknlW/WkVfh
        uCe6evrfiRxix43Jcp4ZUmHSYf362nI=
X-Google-Smtp-Source: AHgI3IZIMVM9u1vJWtf5ivBmTJcP//HhjoTwxhatIhbRTSVSEztt/kaR4DNHlTjYkEyoyreb4WrnNg==
X-Received: by 2002:a5d:53cd:: with SMTP id a13mr171892wrw.146.1549720490275;
        Sat, 09 Feb 2019 05:54:50 -0800 (PST)
Received: from localhost.localdomain ([87.70.76.19])
        by smtp.gmail.com with ESMTPSA id a15sm2864081wrx.58.2019.02.09.05.54.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Feb 2019 05:54:49 -0800 (PST)
From:   Dafna Hirschfeld <dafna3@gmail.com>
To:     linux-media@vger.kernel.org
Cc:     hverkuil@xs4all.nl, helen.koike@collabora.com,
        Dafna Hirschfeld <dafna3@gmail.com>
Subject: [PATCH 9/9] media: vicodec: Add support for stateless decoder.
Date:   Sat,  9 Feb 2019 05:54:27 -0800
Message-Id: <20190209135427.20630-10-dafna3@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190209135427.20630-1-dafna3@gmail.com>
References: <20190209135427.20630-1-dafna3@gmail.com>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Implement a stateless decoder for the new node.

Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
---
 drivers/media/platform/vicodec/vicodec-core.c | 202 ++++++++++++++++--
 1 file changed, 190 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 9a6ee593ae19..9fda0f9138e8 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -117,6 +117,7 @@ struct vicodec_ctx {
 	bool			is_enc;
 	bool			is_stateless;
 	spinlock_t		*lock;
+	struct media_request	*cur_req;
 
 	struct v4l2_ctrl_handler hdl;
 
@@ -136,6 +137,7 @@ struct vicodec_ctx {
 	bool			comp_has_next_frame;
 	bool			first_source_change_sent;
 	bool			source_changed;
+	bool			bad_statless_params;
 };
 
 static inline struct vicodec_ctx *file2ctx(struct file *file)
@@ -169,10 +171,38 @@ static int device_process(struct vicodec_ctx *ctx,
 	u8 *p_src, *p_dst;
 	int ret;
 
+	if (ctx->is_stateless) {
+		unsigned int comp_frame_size;
+
+		p_src = vb2_plane_vaddr(&src_vb->vb2_buf, 0);
+
+		memcpy(&state->header, p_src, sizeof(struct fwht_cframe_hdr));
+		comp_frame_size = ntohl(ctx->state.header.size);
+		if (comp_frame_size > ctx->comp_max_size)
+			return -EINVAL;
+		memcpy(state->compressed_frame,
+		       p_src + sizeof(struct fwht_cframe_hdr), comp_frame_size);
+	}
+
 	if (ctx->is_enc)
 		p_src = vb2_plane_vaddr(&src_vb->vb2_buf, 0);
 	else
 		p_src = state->compressed_frame;
+
+	if (ctx->is_stateless) {
+		struct media_request *src_req = src_vb->vb2_buf.req_obj.req;
+
+		if (!src_req) {
+			v4l2_err(&dev->v4l2_dev, "%s: request is NULL\n",
+				__func__);
+			return -EFAULT;
+		}
+		ctx->cur_req = src_req;
+		v4l2_ctrl_request_setup(src_req, &ctx->hdl);
+		ctx->cur_req = NULL;
+		if (ctx->bad_statless_params)
+			return -EINVAL;
+	}
 	p_dst = vb2_plane_vaddr(&dst_vb->vb2_buf, 0);
 	if (!p_src || !p_dst) {
 		v4l2_err(&dev->v4l2_dev,
@@ -200,7 +230,8 @@ static int device_process(struct vicodec_ctx *ctx,
 		ret = v4l2_fwht_decode(state, p_src, p_dst);
 		if (ret < 0)
 			return ret;
-		copy_cap_to_ref(p_dst, ctx->state.info, &ctx->state);
+		if (!ctx->is_stateless)
+			copy_cap_to_ref(p_dst, ctx->state.info, &ctx->state);
 
 		vb2_set_plane_payload(&dst_vb->vb2_buf, 0, q_dst->sizeimage);
 	}
@@ -294,13 +325,21 @@ static void device_run(void *priv)
 	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, !ctx->is_enc);
 
 	ctx->last_dst_buf = dst_buf;
+	if (ctx->is_stateless) {
+		struct media_request *src_req;
+
+		src_req = src_buf->vb2_buf.req_obj.req;
+		if (src_req)
+			v4l2_ctrl_request_complete(src_req, &ctx->hdl);
+	}
+
 
 	spin_lock(ctx->lock);
 	if (!ctx->comp_has_next_frame && src_buf == ctx->last_src_buf) {
 		dst_buf->flags |= V4L2_BUF_FLAG_LAST;
 		v4l2_event_queue_fh(&ctx->fh, &eos_event);
 	}
-	if (ctx->is_enc) {
+	if (ctx->is_enc || ctx->is_stateless) {
 		src_buf->sequence = q_src->sequence++;
 		src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
 		v4l2_m2m_buf_done(src_buf, state);
@@ -452,7 +491,7 @@ static int job_ready(void *priv)
 
 	if (ctx->source_changed)
 		return 0;
-	if (ctx->is_enc || ctx->comp_has_frame)
+	if (ctx->is_stateless || ctx->is_enc || ctx->comp_has_frame)
 		return 1;
 
 restart:
@@ -1212,6 +1251,14 @@ static int vicodec_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
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
@@ -1275,10 +1322,11 @@ static void vicodec_buf_queue(struct vb2_buffer *vb)
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
@@ -1326,6 +1374,8 @@ static void vicodec_return_bufs(struct vb2_queue *q, u32 state)
 			vbuf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 		if (vbuf == NULL)
 			return;
+		v4l2_ctrl_request_complete(vbuf->vb2_buf.req_obj.req,
+					   &ctx->hdl);
 		spin_lock(ctx->lock);
 		v4l2_m2m_buf_done(vbuf, state);
 		spin_unlock(ctx->lock);
@@ -1442,14 +1492,24 @@ static void vicodec_stop_streaming(struct vb2_queue *q)
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
@@ -1501,6 +1561,13 @@ static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct vicodec_ctx *ctx = container_of(ctrl->handler,
 					       struct vicodec_ctx, hdl);
+	struct media_request *src_req;
+	struct vb2_v4l2_buffer *src_buf;
+	struct vb2_buffer *ref_vb2_buf;
+	u8 *ref_buf;
+	struct v4l2_ctrl_fwht_params *params;
+	struct vb2_queue *vq_cap;
+	struct fwht_raw_frame *ref_frame;
 
 	switch (ctrl->id) {
 	case V4L2_CID_MPEG_VIDEO_GOP_SIZE:
@@ -1511,6 +1578,49 @@ static int vicodec_s_ctrl(struct v4l2_ctrl *ctrl)
 		return 0;
 	case VICODEC_CID_P_FRAME_QP:
 		ctx->state.p_frame_qp = ctrl->val;
+		return 0;
+	case VICODEC_CID_STATELESS_FWHT:
+		if (!ctx->cur_req)
+			return 0;
+		params = (struct v4l2_ctrl_fwht_params *) ctrl->p_new.p;
+		vq_cap = v4l2_m2m_get_vq(ctx->fh.m2m_ctx,
+					  V4L2_BUF_TYPE_VIDEO_CAPTURE);
+		ref_frame = &ctx->state.ref_frame;
+
+		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+		if (!src_buf)
+			return 0;
+		src_req = src_buf->vb2_buf.req_obj.req;
+		if (src_req != ctx->cur_req)
+			return 0;
+
+		if (params->width > ctx->state.coded_width ||
+		    params->height > ctx->state.coded_height) {
+			ctx->bad_statless_params = true;
+			return 0;
+		}
+		/*
+		 * if backward_ref_ts is 0, it means there is no
+		 * ref frame, so just return
+		 */
+		if (params->backward_ref_ts == 0) {
+			ctx->state.visible_width = params->width;
+			ctx->state.visible_height = params->height;
+			return 0;
+		}
+		ref_vb2_buf = vb2_find_timestamp_buf(vq_cap,
+						     params->backward_ref_ts, 0);
+
+		if (!ref_vb2_buf) {
+			ctx->bad_statless_params = true;
+			return 0;
+		}
+
+		ref_buf = vb2_plane_vaddr(ref_vb2_buf, 0);
+		ctx->state.visible_width = params->width;
+		ctx->state.visible_height = params->height;
+		copy_cap_to_ref(ref_buf, ctx->state.info, &ctx->state);
+
 		return 0;
 	}
 	return -EINVAL;
@@ -1543,6 +1653,7 @@ static const struct v4l2_ctrl_config vicodec_ctrl_p_frame = {
 };
 
 static const struct v4l2_ctrl_config vicodec_ctrl_stateless_state = {
+	.ops		= &vicodec_ctrl_ops,
 	.id		= VICODEC_CID_STATELESS_FWHT,
 	.elem_size	= sizeof(struct v4l2_ctrl_fwht_params),
 	.name		= "FWHT-Stateless State Params",
@@ -1666,6 +1777,67 @@ static int vicodec_release(struct file *file)
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
+		v4l2_info(&ctx->dev->v4l2_dev, "Missing codec control(s)\n");
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
+	if (ctrl->elem_size != vicodec_ctrl_stateless_state.elem_size) {
+		v4l2_info(&ctx->dev->v4l2_dev,
+			  "wrong size, got %u expected %u\n",
+			  ctrl->elem_size,
+			  vicodec_ctrl_stateless_state.elem_size);
+		return -ENOENT;
+
+	}
+	return vb2_request_validate(req);
+}
+
 static const struct v4l2_file_operations vicodec_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vicodec_open,
@@ -1684,6 +1856,11 @@ static const struct video_device vicodec_videodev = {
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
@@ -1750,6 +1927,7 @@ static int vicodec_probe(struct platform_device *pdev)
 	strscpy(dev->mdev.bus_info, "platform:vicodec",
 		sizeof(dev->mdev.bus_info));
 	media_device_init(&dev->mdev);
+	dev->mdev.ops = &vicodec_m2m_media_ops;
 	dev->v4l2_dev.mdev = &dev->mdev;
 #endif
 
-- 
2.17.1


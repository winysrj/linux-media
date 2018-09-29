Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53014 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbeI2S3D (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 14:29:03 -0400
From: Srinu Gorle <sgorle@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        sgorle@codeaurora.org
Cc: acourbot@chromium.org, vgarodia@codeaurora.org
Subject: [PATCH v1 1/5] media: venus: handle video decoder resolution change
Date: Sat, 29 Sep 2018 17:30:28 +0530
Message-Id: <1538222432-25894-2-git-send-email-sgorle@codeaurora.org>
In-Reply-To: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add logic for below to handle resolution change during video decode.
- stream off support for video decoder OUTPUT plane and
  flush old resolution OUTPUT plane buffers.
- De-allocate and allocate video firmware internal buffers.
  And also ensures g_fmt for output plane populated
  only after SPS and PPS has parsed.

Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 159 +++++++++++++++++++++++-----
 drivers/media/platform/qcom/venus/helpers.h |   3 +
 drivers/media/platform/qcom/venus/hfi.c     |   5 +-
 drivers/media/platform/qcom/venus/hfi.h     |   2 +-
 drivers/media/platform/qcom/venus/vdec.c    | 102 +++++++++++++++---
 drivers/media/platform/qcom/venus/venc.c    |  20 +++-
 6 files changed, 246 insertions(+), 45 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index e436385..822a853 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -180,6 +180,7 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst)
 		list_add_tail(&buf->list, &inst->dpbbufs);
 	}
 
+	venus_helper_queue_dpb_bufs(inst);
 	return 0;
 
 fail:
@@ -319,6 +320,65 @@ static int intbufs_free(struct venus_inst *inst)
 	return intbufs_unset_buffers(inst);
 }
 
+static int alloc_reconfig_buffers(struct venus_inst *inst)
+{
+	size_t arr_sz;
+	size_t i;
+	int ret;
+	unsigned int buf_type;
+
+	if (IS_V4(inst->core))
+		arr_sz = ARRAY_SIZE(intbuf_types_4xx);
+	else
+		arr_sz = ARRAY_SIZE(intbuf_types_1xx);
+
+	for (i = 0; i < arr_sz; i++) {
+		buf_type = IS_V4(inst->core) ? intbuf_types_4xx[i] :
+					intbuf_types_1xx[i];
+		if (buf_type == HFI_BUFFER_INTERNAL_PERSIST ||
+		    buf_type == HFI_BUFFER_INTERNAL_PERSIST_1)
+			continue;
+
+		ret = intbufs_set_buffer(inst, buf_type);
+		if (ret)
+			goto error;
+	}
+
+	return 0;
+
+error:
+	intbufs_unset_buffers(inst);
+	return ret;
+}
+
+static int unset_reconfig_buffers(struct venus_inst *inst)
+{
+	struct hfi_buffer_desc bd = {0};
+	struct intbuf *buf, *n;
+	int ret = 0;
+
+	list_for_each_entry_safe(buf, n, &inst->internalbufs, list) {
+		if (buf->type == HFI_BUFFER_INTERNAL_PERSIST ||
+		    buf->type == HFI_BUFFER_INTERNAL_PERSIST_1)
+			continue;
+
+		bd.buffer_size = buf->size;
+		bd.buffer_type = buf->type;
+		bd.num_buffers = 1;
+		bd.device_addr = buf->da;
+		bd.response_required = true;
+
+		ret = hfi_session_unset_buffers(inst, &bd);
+
+		list_del_init(&buf->list);
+		dma_free_attrs(inst->core->dev, buf->size, buf->va, buf->da,
+			       buf->attrs);
+		kfree(buf);
+	}
+
+	return ret;
+}
+
 static u32 load_per_instance(struct venus_inst *inst)
 {
 	u32 mbs;
@@ -969,14 +1029,26 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
 	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
+	struct venus_core *core = inst->core;
+	struct device *dev = core->dev;
 	int ret;
+	bool is_plane_enabled;
 
 	mutex_lock(&inst->lock);
 
 	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
 
-	if (!(inst->streamon_out & inst->streamon_cap))
+	is_plane_enabled = inst->streamon_out &&
+		vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
+	is_plane_enabled |= inst->streamon_cap &&
+		vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
+
+	if (!is_plane_enabled) {
+		dev_info(dev, "%s: Yet to start_stream the Q",
+			 vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ?
+			 "FTB" : "ETB");
 		goto unlock;
+	}
 
 	ret = is_buf_refed(inst, vbuf);
 	if (ret)
@@ -1009,37 +1081,72 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
 	struct venus_core *core = inst->core;
 	int ret;
 
-	mutex_lock(&inst->lock);
-
-	if (inst->streamon_out & inst->streamon_cap) {
-		ret = hfi_session_stop(inst);
-		ret |= hfi_session_unload_res(inst);
+	hfi_session_stop(inst);
+	ret = hfi_session_unload_res(inst);
+	if (inst->hfi_codec == HFI_VIDEO_CODEC_H264)
 		ret |= session_unregister_bufs(inst);
-		ret |= intbufs_free(inst);
-		ret |= hfi_session_deinit(inst);
-
-		if (inst->session_error || core->sys_error)
-			ret = -EIO;
+	ret |= intbufs_free(inst);
+	ret |= hfi_session_deinit(inst);
 
-		if (ret)
-			hfi_session_abort(inst);
+	if (inst->session_error || core->sys_error)
+		ret = -EIO;
 
-		venus_helper_free_dpb_bufs(inst);
+	if (IS_V3(core) && ret)
+		hfi_session_abort(inst);
 
-		load_scale_clocks(core);
-		INIT_LIST_HEAD(&inst->registeredbufs);
-	}
+	venus_helper_free_dpb_bufs(inst);
+	load_scale_clocks(core);
+	INIT_LIST_HEAD(&inst->registeredbufs);
 
 	venus_helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
+}
+EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
 
-	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		inst->streamon_out = 0;
-	else
-		inst->streamon_cap = 0;
+int venus_helper_alloc_intbufs(struct venus_inst *inst)
+{
+	int ret = 0;
 
-	mutex_unlock(&inst->lock);
+	ret = intbufs_free(inst);
+	ret |= intbufs_alloc(inst);
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
+EXPORT_SYMBOL_GPL(venus_helper_alloc_intbufs);
+
+int venus_helper_alloc_reconfig_bufs(struct venus_inst *inst)
+{
+	int ret = 0;
+
+	ret = unset_reconfig_buffers(inst);
+	ret |= alloc_reconfig_buffers(inst);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(venus_helper_alloc_reconfig_bufs);
+
+int venus_helper_queue_initial_bufs(struct venus_inst *inst, unsigned int type)
+{
+	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
+	struct v4l2_m2m_buffer *buf, *n;
+	int ret;
+
+	if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)	{
+		v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, buf, n)	{
+			ret = session_process_buf(inst, &buf->vb);
+			if (ret)
+				return_buf_error(inst, &buf->vb);
+		}
+	}
+	if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
+		v4l2_m2m_for_each_src_buf_safe(m2m_ctx, buf, n) {
+			ret = session_process_buf(inst, &buf->vb);
+			if (ret)
+				return_buf_error(inst, &buf->vb);
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(venus_helper_queue_initial_bufs);
 
 int venus_helper_vb2_start_streaming(struct venus_inst *inst)
 {
@@ -1064,14 +1171,8 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
 	if (ret)
 		goto err_unload_res;
 
-	ret = venus_helper_queue_dpb_bufs(inst);
-	if (ret)
-		goto err_session_stop;
-
 	return 0;
 
-err_session_stop:
-	hfi_session_stop(inst);
 err_unload_res:
 	hfi_session_unload_res(inst);
 err_unreg_bufs:
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 2475f284..3de0c44 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -31,6 +31,8 @@ void venus_helper_buffers_done(struct venus_inst *inst,
 int venus_helper_vb2_start_streaming(struct venus_inst *inst);
 void venus_helper_m2m_device_run(void *priv);
 void venus_helper_m2m_job_abort(void *priv);
+int venus_helper_queue_initial_bufs(struct venus_inst *inst, unsigned int type);
+int venus_helper_alloc_intbufs(struct venus_inst *inst);
 int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
 			    struct hfi_buffer_requirements *req);
 u32 venus_helper_get_framesz_raw(u32 hfi_fmt, u32 width, u32 height);
@@ -62,4 +64,5 @@ int venus_helper_get_out_fmts(struct venus_inst *inst, u32 fmt, u32 *out_fmt,
 int venus_helper_free_dpb_bufs(struct venus_inst *inst);
 int venus_helper_power_enable(struct venus_core *core, u32 session_type,
 			      bool enable);
+int venus_helper_alloc_reconfig_bufs(struct venus_inst *inst);
 #endif
diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 2420782..36a4784 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -308,6 +308,7 @@ int hfi_session_stop(struct venus_inst *inst)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(hfi_session_stop);
 
 int hfi_session_continue(struct venus_inst *inst)
 {
@@ -384,14 +385,14 @@ int hfi_session_unload_res(struct venus_inst *inst)
 	return 0;
 }
 
-int hfi_session_flush(struct venus_inst *inst)
+int hfi_session_flush(struct venus_inst *inst, u32 mode)
 {
 	const struct hfi_ops *ops = inst->core->ops;
 	int ret;
 
 	reinit_completion(&inst->done);
 
-	ret = ops->session_flush(inst, HFI_FLUSH_ALL);
+	ret = ops->session_flush(inst, mode);
 	if (ret)
 		return ret;
 
diff --git a/drivers/media/platform/qcom/venus/hfi.h b/drivers/media/platform/qcom/venus/hfi.h
index 6038d8e..5e883a1 100644
--- a/drivers/media/platform/qcom/venus/hfi.h
+++ b/drivers/media/platform/qcom/venus/hfi.h
@@ -170,7 +170,7 @@ struct hfi_ops {
 int hfi_session_abort(struct venus_inst *inst);
 int hfi_session_load_res(struct venus_inst *inst);
 int hfi_session_unload_res(struct venus_inst *inst);
-int hfi_session_flush(struct venus_inst *inst);
+int hfi_session_flush(struct venus_inst *inst, u32 mode);
 int hfi_session_set_buffers(struct venus_inst *inst,
 			    struct hfi_buffer_desc *bd);
 int hfi_session_unset_buffers(struct venus_inst *inst,
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 991e158..98675db 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -207,7 +207,6 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 
 		inst->out_width = inst->reconfig_width;
 		inst->out_height = inst->reconfig_height;
-		inst->reconfig = false;
 
 		format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 		format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt;
@@ -223,6 +222,9 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
 	pixmp->pixelformat = fmt->pixfmt;
 
 	if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		if (!(inst->reconfig))
+			return -EINVAL;
+
 		pixmp->width = inst->width;
 		pixmp->height = inst->height;
 		pixmp->colorspace = inst->colorspace;
@@ -451,6 +453,8 @@ static int vdec_subscribe_event(struct v4l2_fh *fh,
 		if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
 			return -EINVAL;
 		break;
+	case V4L2_DEC_CMD_START:
+		return 0;
 	default:
 		return -EINVAL;
 	}
@@ -465,6 +469,9 @@ static int vdec_subscribe_event(struct v4l2_fh *fh,
 	struct hfi_frame_data fdata = {0};
 	int ret;
 
+	if (cmd->cmd != V4L2_DEC_CMD_STOP)
+		return 0;
+
 	ret = vdec_try_decoder_cmd(file, fh, cmd);
 	if (ret)
 		return ret;
@@ -790,22 +797,60 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct venus_inst *inst = vb2_get_drv_priv(q);
 	int ret;
+	bool is_mplane_enabled;
 
 	mutex_lock(&inst->lock);
+	is_mplane_enabled = q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+				inst->streamon_cap;
+	is_mplane_enabled |= q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
+				inst->streamon_out;
 
-	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
-		inst->streamon_out = 1;
-	else
-		inst->streamon_cap = 1;
+	if (is_mplane_enabled) {
+		mutex_unlock(&inst->lock);
+		return 0;
+	}
 
-	if (!(inst->streamon_out & inst->streamon_cap)) {
+	if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
+	    !inst->streamon_out){
 		mutex_unlock(&inst->lock);
 		return 0;
 	}
 
+	if (inst->streamon_out && !inst->streamon_cap &&
+	    q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = vdec_output_conf(inst);
+		if (ret)
+			goto deinit_sess;
+
+		ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
+						inst->num_output_bufs,
+						inst->num_output_bufs);
+
+		if (ret)
+			goto deinit_sess;
+
+		ret = vdec_verify_conf(inst);
+		if (ret)
+			goto deinit_sess;
+
+		if (inst->reconfig)
+			ret = venus_helper_alloc_reconfig_bufs(inst);
+
+		if (ret)
+			goto deinit_sess;
+
+		ret = venus_helper_alloc_dpb_bufs(inst);
+		if (ret)
+			goto deinit_sess;
+
+		if (inst->reconfig) {
+			hfi_session_continue(inst);
+			inst->reconfig = false;
+		}
+		goto enable_mplane;
+	}
 	venus_helper_init_instance(inst);
 
-	inst->reconfig = false;
 	inst->sequence_cap = 0;
 	inst->sequence_out = 0;
 
@@ -830,14 +875,17 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ret)
 		goto deinit_sess;
 
-	ret = venus_helper_alloc_dpb_bufs(inst);
-	if (ret)
-		goto deinit_sess;
-
 	ret = venus_helper_vb2_start_streaming(inst);
 	if (ret)
 		goto deinit_sess;
 
+enable_mplane:
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		inst->streamon_out = 1;
+	else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		inst->streamon_cap = 1;
+
+	ret = venus_helper_queue_initial_bufs(inst, q->type);
 	mutex_unlock(&inst->lock);
 
 	return 0;
@@ -854,12 +902,42 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 	return ret;
 }
 
+static void vdec_stop_streaming(struct vb2_queue *q)
+{
+	struct venus_inst *inst = vb2_get_drv_priv(q);
+	int ret;
+
+	mutex_lock(&inst->lock);
+
+	if (!inst->streamon_cap && !inst->streamon_out)
+		goto unlock;
+
+	if (inst->streamon_cap &&
+	    q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		ret = hfi_session_stop(inst);
+		inst->streamon_cap = 0;
+	}
+
+	if (inst->streamon_out && !inst->streamon_cap) {
+		inst->streamon_out = 0;
+		venus_helper_vb2_stop_streaming(q);
+	}
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		inst->streamon_out = 0;
+	else
+		inst->streamon_cap = 0;
+unlock:
+	venus_helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
+	mutex_unlock(&inst->lock);
+}
+
 static const struct vb2_ops vdec_vb2_ops = {
 	.queue_setup = vdec_queue_setup,
 	.buf_init = venus_helper_vb2_buf_init,
 	.buf_prepare = venus_helper_vb2_buf_prepare,
 	.start_streaming = vdec_start_streaming,
-	.stop_streaming = venus_helper_vb2_stop_streaming,
+	.stop_streaming = vdec_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
 };
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index ce85962..3ce0f7a 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -1005,12 +1005,30 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 	return ret;
 }
 
+void venc_stop_streaming(struct vb2_queue *q)
+{
+	struct venus_inst *inst = vb2_get_drv_priv(q);
+
+	mutex_lock(&inst->lock);
+
+	if (inst->streamon_out & inst->streamon_cap)
+		venus_helper_vb2_stop_streaming(q);
+
+	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
+		inst->streamon_out = 0;
+	else
+		inst->streamon_cap = 0;
+
+	mutex_unlock(&inst->lock);
+}
+EXPORT_SYMBOL_GPL(venc_stop_streaming);
+
 static const struct vb2_ops venc_vb2_ops = {
 	.queue_setup = venc_queue_setup,
 	.buf_init = venus_helper_vb2_buf_init,
 	.buf_prepare = venus_helper_vb2_buf_prepare,
 	.start_streaming = venc_start_streaming,
-	.stop_streaming = venus_helper_vb2_stop_streaming,
+	.stop_streaming = venc_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
 };
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

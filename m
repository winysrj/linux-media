Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35884 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934701AbeFOTIF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:08:05 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 08/17] venus: Add video_device and vb2_queue locks
Date: Fri, 15 Jun 2018 16:07:28 -0300
Message-Id: <20180615190737.24139-9-ezequiel@collabora.com>
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

video_device and vb2_queue locks are now both
mandatory. Add them, remove driver ad-hoc locking,
and implement wait_{prepare, finish}.

To stay on the safe side, this commit uses a single mutex
for both locks. Better latency can be obtained by separating
these if needed.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/qcom/venus/core.h    |  4 +++-
 drivers/media/platform/qcom/venus/helpers.c | 16 ++++++-------
 drivers/media/platform/qcom/venus/vdec.c    | 25 +++++++++------------
 drivers/media/platform/qcom/venus/venc.c    | 19 ++++++++--------
 4 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 0360d295f4c8..5617d0af990f 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -102,6 +102,8 @@ struct venus_core {
 	struct device *dev_dec;
 	struct device *dev_enc;
 	struct mutex lock;
+	struct mutex dec_lock;
+	struct mutex enc_lock;
 	struct list_head instances;
 	atomic_t insts_count;
 	unsigned int state;
@@ -243,7 +245,7 @@ struct venus_buffer {
  */
 struct venus_inst {
 	struct list_head list;
-	struct mutex lock;
+	struct mutex *lock;
 	struct venus_core *core;
 	struct list_head internalbufs;
 	struct list_head registeredbufs;
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 0ce9559a2924..5a2dda6fb984 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -512,7 +512,7 @@ static void delayed_process_buf_func(struct work_struct *work)
 
 	inst = container_of(work, struct venus_inst, delayed_process_work);
 
-	mutex_lock(&inst->lock);
+	mutex_lock(inst->lock);
 
 	if (!(inst->streamon_out & inst->streamon_cap))
 		goto unlock;
@@ -528,7 +528,7 @@ static void delayed_process_buf_func(struct work_struct *work)
 		list_del_init(&buf->ref_list);
 	}
 unlock:
-	mutex_unlock(&inst->lock);
+	mutex_unlock(inst->lock);
 }
 
 void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx)
@@ -621,7 +621,7 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
 	struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
 	int ret;
 
-	mutex_lock(&inst->lock);
+	mutex_lock(inst->lock);
 
 	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
 
@@ -637,7 +637,7 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
 		return_buf_error(inst, vbuf);
 
 unlock:
-	mutex_unlock(&inst->lock);
+	mutex_unlock(inst->lock);
 }
 EXPORT_SYMBOL_GPL(venus_helper_vb2_buf_queue);
 
@@ -659,7 +659,7 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
 	struct venus_core *core = inst->core;
 	int ret;
 
-	mutex_lock(&inst->lock);
+	mutex_lock(inst->lock);
 
 	if (inst->streamon_out & inst->streamon_cap) {
 		ret = hfi_session_stop(inst);
@@ -685,7 +685,7 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
 	else
 		inst->streamon_cap = 0;
 
-	mutex_unlock(&inst->lock);
+	mutex_unlock(inst->lock);
 }
 EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
 
@@ -731,7 +731,7 @@ void venus_helper_m2m_device_run(void *priv)
 	struct v4l2_m2m_buffer *buf, *n;
 	int ret;
 
-	mutex_lock(&inst->lock);
+	mutex_lock(inst->lock);
 
 	v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, buf, n) {
 		ret = session_process_buf(inst, &buf->vb);
@@ -745,7 +745,7 @@ void venus_helper_m2m_device_run(void *priv)
 			return_buf_error(inst, &buf->vb);
 	}
 
-	mutex_unlock(&inst->lock);
+	mutex_unlock(inst->lock);
 }
 EXPORT_SYMBOL_GPL(venus_helper_m2m_device_run);
 
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 49bbd1861d3a..41d14df46f5d 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -493,14 +493,12 @@ vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
 	if (ret)
 		return ret;
 
-	mutex_lock(&inst->lock);
-
 	/*
 	 * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on decoder
 	 * input to signal EOS.
 	 */
 	if (!(inst->streamon_out & inst->streamon_cap))
-		goto unlock;
+		return 0;
 
 	fdata.buffer_type = HFI_BUFFER_INPUT;
 	fdata.flags |= HFI_BUFFERFLAG_EOS;
@@ -508,8 +506,6 @@ vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
 
 	ret = hfi_session_process_buf(inst, &fdata);
 
-unlock:
-	mutex_unlock(&inst->lock);
 	return ret;
 }
 
@@ -720,17 +716,13 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 	u32 ptype;
 	int ret;
 
-	mutex_lock(&inst->lock);
-
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		inst->streamon_out = 1;
 	else
 		inst->streamon_cap = 1;
 
-	if (!(inst->streamon_out & inst->streamon_cap)) {
-		mutex_unlock(&inst->lock);
+	if (!(inst->streamon_out & inst->streamon_cap))
 		return 0;
-	}
 
 	venus_helper_init_instance(inst);
 
@@ -771,8 +763,6 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ret)
 		goto deinit_sess;
 
-	mutex_unlock(&inst->lock);
-
 	return 0;
 
 deinit_sess:
@@ -783,7 +773,6 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 		inst->streamon_out = 0;
 	else
 		inst->streamon_cap = 0;
-	mutex_unlock(&inst->lock);
 	return ret;
 }
 
@@ -794,6 +783,8 @@ static const struct vb2_ops vdec_vb2_ops = {
 	.start_streaming = vdec_start_streaming,
 	.stop_streaming = venus_helper_vb2_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 };
 
 static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
@@ -940,6 +931,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->allow_zero_bytesused = 1;
 	src_vq->min_buffers_needed = 1;
 	src_vq->dev = inst->core->dev;
+	src_vq->lock = &inst->core->dec_lock;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
@@ -954,6 +946,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->allow_zero_bytesused = 1;
 	dst_vq->min_buffers_needed = 1;
 	dst_vq->dev = inst->core->dev;
+	dst_vq->lock = &inst->core->dec_lock;
 	ret = vb2_queue_init(dst_vq);
 	if (ret) {
 		vb2_queue_release(src_vq);
@@ -976,9 +969,9 @@ static int vdec_open(struct file *file)
 	INIT_LIST_HEAD(&inst->registeredbufs);
 	INIT_LIST_HEAD(&inst->internalbufs);
 	INIT_LIST_HEAD(&inst->list);
-	mutex_init(&inst->lock);
 
 	inst->core = core;
+	inst->lock = &core->dec_lock;
 	inst->session_type = VIDC_SESSION_TYPE_DEC;
 	inst->num_output_bufs = 1;
 
@@ -1044,7 +1037,6 @@ static int vdec_close(struct file *file)
 	v4l2_m2m_release(inst->m2m_dev);
 	vdec_ctrl_deinit(inst);
 	hfi_session_destroy(inst);
-	mutex_destroy(&inst->lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 
@@ -1092,12 +1084,14 @@ static int vdec_probe(struct platform_device *pdev)
 	if (!vdev)
 		return -ENOMEM;
 
+	mutex_init(&core->dec_lock);
 	strlcpy(vdev->name, "qcom-venus-decoder", sizeof(vdev->name));
 	vdev->release = video_device_release;
 	vdev->fops = &vdec_fops;
 	vdev->ioctl_ops = &vdec_ioctl_ops;
 	vdev->vfl_dir = VFL_DIR_M2M;
 	vdev->v4l2_dev = &core->v4l2_dev;
+	vdev->lock = &core->dec_lock;
 	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
@@ -1123,6 +1117,7 @@ static int vdec_remove(struct platform_device *pdev)
 
 	video_unregister_device(core->vdev_dec);
 	pm_runtime_disable(core->dev_dec);
+	mutex_destroy(&core->dec_lock);
 
 	return 0;
 }
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 6b2ce479584e..016af21abf5d 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -922,17 +922,13 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 	struct venus_inst *inst = vb2_get_drv_priv(q);
 	int ret;
 
-	mutex_lock(&inst->lock);
-
 	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		inst->streamon_out = 1;
 	else
 		inst->streamon_cap = 1;
 
-	if (!(inst->streamon_out & inst->streamon_cap)) {
-		mutex_unlock(&inst->lock);
+	if (!(inst->streamon_out & inst->streamon_cap))
 		return 0;
-	}
 
 	venus_helper_init_instance(inst);
 
@@ -960,8 +956,6 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 	if (ret)
 		goto deinit_sess;
 
-	mutex_unlock(&inst->lock);
-
 	return 0;
 
 deinit_sess:
@@ -972,7 +966,6 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 		inst->streamon_out = 0;
 	else
 		inst->streamon_cap = 0;
-	mutex_unlock(&inst->lock);
 	return ret;
 }
 
@@ -983,6 +976,8 @@ static const struct vb2_ops venc_vb2_ops = {
 	.start_streaming = venc_start_streaming,
 	.stop_streaming = venus_helper_vb2_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 };
 
 static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
@@ -1054,6 +1049,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->allow_zero_bytesused = 1;
 	src_vq->min_buffers_needed = 1;
 	src_vq->dev = inst->core->dev;
+	src_vq->lock = &inst->core->enc_lock;
 	if (inst->core->res->hfi_version == HFI_VERSION_1XX)
 		src_vq->bidirectional = 1;
 	ret = vb2_queue_init(src_vq);
@@ -1070,6 +1066,7 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	dst_vq->allow_zero_bytesused = 1;
 	dst_vq->min_buffers_needed = 1;
 	dst_vq->dev = inst->core->dev;
+	dst_vq->lock = &inst->core->enc_lock;
 	ret = vb2_queue_init(dst_vq);
 	if (ret) {
 		vb2_queue_release(src_vq);
@@ -1121,9 +1118,9 @@ static int venc_open(struct file *file)
 	INIT_LIST_HEAD(&inst->registeredbufs);
 	INIT_LIST_HEAD(&inst->internalbufs);
 	INIT_LIST_HEAD(&inst->list);
-	mutex_init(&inst->lock);
 
 	inst->core = core;
+	inst->lock = &core->enc_lock;
 	inst->session_type = VIDC_SESSION_TYPE_ENC;
 
 	venus_helper_init_instance(inst);
@@ -1188,7 +1185,6 @@ static int venc_close(struct file *file)
 	v4l2_m2m_release(inst->m2m_dev);
 	venc_ctrl_deinit(inst);
 	hfi_session_destroy(inst);
-	mutex_destroy(&inst->lock);
 	v4l2_fh_del(&inst->fh);
 	v4l2_fh_exit(&inst->fh);
 
@@ -1237,11 +1233,13 @@ static int venc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	strlcpy(vdev->name, "qcom-venus-encoder", sizeof(vdev->name));
+	mutex_init(&core->enc_lock);
 	vdev->release = video_device_release;
 	vdev->fops = &venc_fops;
 	vdev->ioctl_ops = &venc_ioctl_ops;
 	vdev->vfl_dir = VFL_DIR_M2M;
 	vdev->v4l2_dev = &core->v4l2_dev;
+	vdev->lock = &core->enc_lock;
 	vdev->device_caps = V4L2_CAP_VIDEO_M2M_MPLANE | V4L2_CAP_STREAMING;
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
@@ -1267,6 +1265,7 @@ static int venc_remove(struct platform_device *pdev)
 
 	video_unregister_device(core->vdev_enc);
 	pm_runtime_disable(core->dev_enc);
+	mutex_destroy(&core->enc_lock);
 
 	return 0;
 }
-- 
2.17.1

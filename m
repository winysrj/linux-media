Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:52254 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753479AbdJMONk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 10:13:40 -0400
Received: by mail-wm0-f49.google.com with SMTP id k4so22105217wmc.1
        for <linux-media@vger.kernel.org>; Fri, 13 Oct 2017 07:13:39 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH] venus: reimplement decoder stop command
Date: Fri, 13 Oct 2017 17:13:17 +0300
Message-Id: <20171013141317.23211-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This addresses the wrong behavior of decoder stop command by
rewriting it. These new implementation enqueue an empty buffer
on the decoder input buffer queue to signal end-of-stream. The
client should stop queuing buffers on the V4L2 Output queue
and continue queuing/dequeuing buffers on Capture queue. This
process will continue until the client receives a buffer with
V4L2_BUF_FLAG_LAST flag raised, which means that this is last
decoded buffer with data.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.h    |  2 --
 drivers/media/platform/qcom/venus/helpers.c |  7 ------
 drivers/media/platform/qcom/venus/hfi.c     |  1 +
 drivers/media/platform/qcom/venus/vdec.c    | 34 +++++++++++++++++++----------
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index cba092bcb76d..a0fe80df0cbd 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -194,7 +194,6 @@ struct venus_buffer {
  * @fh:	 a holder of v4l file handle structure
  * @streamon_cap: stream on flag for capture queue
  * @streamon_out: stream on flag for output queue
- * @cmd_stop:	a flag to signal encoder/decoder commands
  * @width:	current capture width
  * @height:	current capture height
  * @out_width:	current output width
@@ -258,7 +257,6 @@ struct venus_inst {
 	} controls;
 	struct v4l2_fh fh;
 	unsigned int streamon_cap, streamon_out;
-	bool cmd_stop;
 	u32 width;
 	u32 height;
 	u32 out_width;
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index cac429be5609..6a85dd10ecd4 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -626,13 +626,6 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
 
 	mutex_lock(&inst->lock);
 
-	if (inst->cmd_stop) {
-		vbuf->flags |= V4L2_BUF_FLAG_LAST;
-		v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
-		inst->cmd_stop = false;
-		goto unlock;
-	}
-
 	v4l2_m2m_buf_queue(m2m_ctx, vbuf);
 
 	if (!(inst->streamon_out & inst->streamon_cap))
diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index c09490876516..ba29fd4d4984 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -484,6 +484,7 @@ int hfi_session_process_buf(struct venus_inst *inst, struct hfi_frame_data *fd)
 
 	return -EINVAL;
 }
+EXPORT_SYMBOL_GPL(hfi_session_process_buf);
 
 irqreturn_t hfi_isr_thread(int irq, void *dev_id)
 {
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index da611a5eb670..c9e9576bb08a 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -469,8 +469,14 @@ static int vdec_subscribe_event(struct v4l2_fh *fh,
 static int
 vdec_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
 {
-	if (cmd->cmd != V4L2_DEC_CMD_STOP)
+	switch (cmd->cmd) {
+	case V4L2_DEC_CMD_STOP:
+		if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
+			return -EINVAL;
+		break;
+	default:
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -479,6 +485,7 @@ static int
 vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
 {
 	struct venus_inst *inst = to_inst(file);
+	struct hfi_frame_data fdata = {0};
 	int ret;
 
 	ret = vdec_try_decoder_cmd(file, fh, cmd);
@@ -486,12 +493,23 @@ vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
 		return ret;
 
 	mutex_lock(&inst->lock);
-	inst->cmd_stop = true;
-	mutex_unlock(&inst->lock);
 
-	hfi_session_flush(inst);
+	/*
+	 * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on decoder
+	 * input to signal EOS.
+	 */
+	if (!(inst->streamon_out & inst->streamon_cap))
+		goto unlock;
+
+	fdata.buffer_type = HFI_BUFFER_INPUT;
+	fdata.flags |= HFI_BUFFERFLAG_EOS;
+	fdata.device_addr = 0xdeadbeef;
 
-	return 0;
+	ret = hfi_session_process_buf(inst, &fdata);
+
+unlock:
+	mutex_unlock(&inst->lock);
+	return ret;
 }
 
 static const struct v4l2_ioctl_ops vdec_ioctl_ops = {
@@ -718,7 +736,6 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 	inst->reconfig = false;
 	inst->sequence_cap = 0;
 	inst->sequence_out = 0;
-	inst->cmd_stop = false;
 
 	ret = vdec_init_session(inst);
 	if (ret)
@@ -807,11 +824,6 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
 		vb->timestamp = timestamp_us * NSEC_PER_USEC;
 		vbuf->sequence = inst->sequence_cap++;
 
-		if (inst->cmd_stop) {
-			vbuf->flags |= V4L2_BUF_FLAG_LAST;
-			inst->cmd_stop = false;
-		}
-
 		if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
 			const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
 
-- 
2.11.0

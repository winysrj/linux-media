Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:35688 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754712AbdFLQaH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 12:30:07 -0400
Received: by mail-wr0-f171.google.com with SMTP id q97so103975538wrb.2
        for <linux-media@vger.kernel.org>; Mon, 12 Jun 2017 09:30:06 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v10 17/18] media: venus: vdec: add support for min buffers for capture
Date: Mon, 12 Jun 2017 19:27:54 +0300
Message-Id: <1497284875-19999-18-git-send-email-stanimir.varbanov@linaro.org>
In-Reply-To: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
References: <1497284875-19999-1-git-send-email-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds support for V4L2_CID_MIN_BUFFERS_FOR_CAPTURE get control
in venus decoder, it is usable in case when the userspace wants
to know minimum capture buffers before calling request_buf for
capture queue in mem2mem drivers. Also this will fix an issue
found gstreamer v4l2videodec element, i.e. the video decoder
element cannot continue because the buffers are insufficient.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c       |  7 +++++++
 drivers/media/platform/qcom/venus/vdec_ctrls.c | 10 +++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 594315b55b1f..eb0c1c51cfef 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -627,6 +627,12 @@ static int vdec_queue_setup(struct vb2_queue *q,
 						    inst->out_height);
 		inst->input_buf_size = sizes[0];
 		inst->num_input_bufs = *num_buffers;
+
+		ret = vdec_cap_num_buffers(inst, &num);
+		if (ret)
+			break;
+
+		inst->num_output_bufs = num;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		*num_planes = inst->fmt_cap->num_planes;
@@ -951,6 +957,7 @@ static int vdec_open(struct file *file)
 
 	inst->core = core;
 	inst->session_type = VIDC_SESSION_TYPE_DEC;
+	inst->num_output_bufs = 1;
 
 	venus_helper_init_instance(inst);
 
diff --git a/drivers/media/platform/qcom/venus/vdec_ctrls.c b/drivers/media/platform/qcom/venus/vdec_ctrls.c
index 1045fc5b4925..032839bbc967 100644
--- a/drivers/media/platform/qcom/venus/vdec_ctrls.c
+++ b/drivers/media/platform/qcom/venus/vdec_ctrls.c
@@ -70,6 +70,9 @@ static int vdec_op_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	case V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER:
 		ctrl->val = ctr->post_loop_deb_mode;
 		break;
+	case V4L2_CID_MIN_BUFFERS_FOR_CAPTURE:
+		ctrl->val = inst->num_output_bufs;
+		break;
 	default:
 		return -EINVAL;
 	};
@@ -87,7 +90,7 @@ int vdec_ctrl_init(struct venus_inst *inst)
 	struct v4l2_ctrl *ctrl;
 	int ret;
 
-	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 6);
+	ret = v4l2_ctrl_handler_init(&inst->ctrl_handler, 7);
 	if (ret)
 		return ret;
 
@@ -135,6 +138,11 @@ int vdec_ctrl_init(struct venus_inst *inst)
 	v4l2_ctrl_new_std(&inst->ctrl_handler, &vdec_ctrl_ops,
 		V4L2_CID_MPEG_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER, 0, 1, 1, 0);
 
+	ctrl = v4l2_ctrl_new_std(&inst->ctrl_handler, &vdec_ctrl_ops,
+		V4L2_CID_MIN_BUFFERS_FOR_CAPTURE, 1, 32, 1, 1);
+	if (ctrl)
+		ctrl->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
 	ret = inst->ctrl_handler.error;
 	if (ret) {
 		v4l2_ctrl_handler_free(&inst->ctrl_handler);
-- 
2.7.4

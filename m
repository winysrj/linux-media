Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51233 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757873AbeDXMpe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:45:34 -0400
Received: by mail-wm0-f68.google.com with SMTP id j4so694039wme.1
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 05:45:33 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 23/28] venus: vdec: get required input buffers as well
Date: Tue, 24 Apr 2018 15:44:31 +0300
Message-Id: <20180424124436.26955-24-stanimir.varbanov@linaro.org>
In-Reply-To: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rework and rename vdec_cap_num_buffers() to get the number of
input buffers too.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 41 +++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 8d188b11b85a..6ed9b7c4bd6e 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -603,19 +603,32 @@ static int vdec_init_session(struct venus_inst *inst)
 	return ret;
 }
 
-static int vdec_cap_num_buffers(struct venus_inst *inst, unsigned int *num)
+static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
+			    unsigned int *out_num)
 {
+	enum hfi_version ver = inst->core->res->hfi_version;
 	struct hfi_buffer_requirements bufreq;
 	int ret;
 
+	*in_num = *out_num = 0;
+
 	ret = vdec_init_session(inst);
 	if (ret)
 		return ret;
 
+	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
+	if (ret)
+		goto deinit;
+
+	*in_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
+
 	ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
+	if (ret)
+		goto deinit;
 
-	*num = bufreq.count_actual;
+	*out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
 
+deinit:
 	hfi_session_deinit(inst);
 
 	return ret;
@@ -626,7 +639,7 @@ static int vdec_queue_setup(struct vb2_queue *q,
 			    unsigned int sizes[], struct device *alloc_devs[])
 {
 	struct venus_inst *inst = vb2_get_drv_priv(q);
-	unsigned int p, num;
+	unsigned int p, in_num, out_num;
 	int ret = 0;
 
 	if (*num_planes) {
@@ -649,35 +662,29 @@ static int vdec_queue_setup(struct vb2_queue *q,
 		return 0;
 	}
 
+	ret = vdec_num_buffers(inst, &in_num, &out_num);
+	if (ret)
+		return ret;
+
 	switch (q->type) {
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		*num_planes = inst->fmt_out->num_planes;
 		sizes[0] = get_framesize_compressed(inst->out_width,
 						    inst->out_height);
 		inst->input_buf_size = sizes[0];
+		*num_buffers = max(*num_buffers, in_num);
 		inst->num_input_bufs = *num_buffers;
-
-		ret = vdec_cap_num_buffers(inst, &num);
-		if (ret)
-			break;
-
-		inst->num_output_bufs = num;
+		inst->num_output_bufs = out_num;
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
 		*num_planes = inst->fmt_cap->num_planes;
 
-		ret = vdec_cap_num_buffers(inst, &num);
-		if (ret)
-			break;
-
-		*num_buffers = max(*num_buffers, num);
-
 		for (p = 0; p < *num_planes; p++)
 			sizes[p] = get_framesize_uncompressed(p, inst->width,
 							      inst->height);
-
-		inst->num_output_bufs = *num_buffers;
 		inst->output_buf_size = sizes[0];
+		*num_buffers = max(*num_buffers, out_num);
+		inst->num_output_bufs = *num_buffers;
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.14.1

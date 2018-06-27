Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39902 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965224AbeF0P2Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 11:28:25 -0400
Received: by mail-wr0-f193.google.com with SMTP id b8-v6so2474922wro.6
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2018 08:28:24 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v4 22/27] venus: vdec: get required input buffers as well
Date: Wed, 27 Jun 2018 18:27:20 +0300
Message-Id: <20180627152725.9783-23-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Rework and rename vdec_cap_num_buffers() to get the number of
input buffers too.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/vdec.c | 41 +++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 5d8bf288bd2a..55213a8d55a3 100644
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

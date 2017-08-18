Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:38026 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbdHROQq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Aug 2017 10:16:46 -0400
Received: by mail-wr0-f177.google.com with SMTP id 5so47464566wrz.5
        for <linux-media@vger.kernel.org>; Fri, 18 Aug 2017 07:16:46 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 2/7] media: venus: venc: set correct resolution on compressed stream
Date: Fri, 18 Aug 2017 17:16:01 +0300
Message-Id: <20170818141606.4835-3-stanimir.varbanov@linaro.org>
In-Reply-To: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
References: <20170818141606.4835-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This change the alignment restriction for output type of buffers
only, also set corect input resolution and fill bidirectional
vb2 queue flag in order to map output type buffers read/write.
The last is needed by encoder firmware to add padding at the
bottom of output (input buffers).

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/venc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 39748e7a08e4..01af1ac89edf 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -289,7 +289,7 @@ venc_try_fmt_common(struct venus_inst *inst, struct v4l2_format *f)
 	pixmp->height = clamp(pixmp->height, inst->cap_height.min,
 			      inst->cap_height.max);
 
-	if (inst->core->res->hfi_version == HFI_VERSION_1XX)
+	if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		pixmp->height = ALIGN(pixmp->height, 32);
 
 	pixmp->width = ALIGN(pixmp->width, 2);
@@ -747,8 +747,8 @@ static int venc_init_session(struct venus_inst *inst)
 	if (ret)
 		return ret;
 
-	ret = venus_helper_set_input_resolution(inst, inst->out_width,
-						inst->out_height);
+	ret = venus_helper_set_input_resolution(inst, inst->width,
+						inst->height);
 	if (ret)
 		goto deinit;
 
@@ -1010,6 +1010,8 @@ static int m2m_queue_init(void *priv, struct vb2_queue *src_vq,
 	src_vq->allow_zero_bytesused = 1;
 	src_vq->min_buffers_needed = 1;
 	src_vq->dev = inst->core->dev;
+	if (inst->core->res->hfi_version == HFI_VERSION_1XX)
+		src_vq->bidirectional = 1;
 	ret = vb2_queue_init(src_vq);
 	if (ret)
 		return ret;
-- 
2.11.0

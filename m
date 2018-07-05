Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53202 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754476AbeGENFa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:30 -0400
Received: by mail-wm0-f65.google.com with SMTP id w16-v6so10970123wmc.2
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:29 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 20/27] venus: helpers: extend set_num_bufs helper with one more argument
Date: Thu,  5 Jul 2018 16:03:54 +0300
Message-Id: <20180705130401.24315-21-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend venus_helper_set_num_bufs() helper function with one more
argument to set number of output buffers for the secondary decoder
output.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 16 ++++++++++++++--
 drivers/media/platform/qcom/venus/helpers.h |  3 ++-
 drivers/media/platform/qcom/venus/vdec.c    |  2 +-
 drivers/media/platform/qcom/venus/venc.c    |  2 +-
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 3cd25e25aa70..13f0bc4e5ffa 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -515,7 +515,8 @@ int venus_helper_set_core_usage(struct venus_inst *inst, u32 usage)
 EXPORT_SYMBOL_GPL(venus_helper_set_core_usage);
 
 int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
-			      unsigned int output_bufs)
+			      unsigned int output_bufs,
+			      unsigned int output2_bufs)
 {
 	u32 ptype = HFI_PROPERTY_PARAM_BUFFER_COUNT_ACTUAL;
 	struct hfi_buffer_count_actual buf_count;
@@ -531,7 +532,18 @@ int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 	buf_count.type = HFI_BUFFER_OUTPUT;
 	buf_count.count_actual = output_bufs;
 
-	return hfi_session_set_property(inst, ptype, &buf_count);
+	ret = hfi_session_set_property(inst, ptype, &buf_count);
+	if (ret)
+		return ret;
+
+	if (output2_bufs) {
+		buf_count.type = HFI_BUFFER_OUTPUT2;
+		buf_count.count_actual = output2_bufs;
+
+		ret = hfi_session_set_property(inst, ptype, &buf_count);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(venus_helper_set_num_bufs);
 
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index d5e727e1ecab..8ff4bd3ef958 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -41,7 +41,8 @@ int venus_helper_set_output_resolution(struct venus_inst *inst,
 int venus_helper_set_work_mode(struct venus_inst *inst, u32 mode);
 int venus_helper_set_core_usage(struct venus_inst *inst, u32 usage);
 int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
-			      unsigned int output_bufs);
+			      unsigned int output_bufs,
+			      unsigned int output2_bufs);
 int venus_helper_set_raw_format(struct venus_inst *inst, u32 hfi_format,
 				u32 buftype);
 int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 75f622c73222..3af1fb81cc32 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -758,7 +758,7 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 		goto deinit_sess;
 
 	ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
-					VB2_MAX_FRAME);
+					VB2_MAX_FRAME, VB2_MAX_FRAME);
 	if (ret)
 		goto deinit_sess;
 
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 6dc153f16d88..cc8049fd8811 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -963,7 +963,7 @@ static int venc_start_streaming(struct vb2_queue *q, unsigned int count)
 		goto deinit_sess;
 
 	ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
-					inst->num_output_bufs);
+					inst->num_output_bufs, 0);
 	if (ret)
 		goto deinit_sess;
 
-- 
2.14.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53432 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932894AbeDXMpZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:45:25 -0400
Received: by mail-wm0-f67.google.com with SMTP id 66so685620wmd.3
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 05:45:25 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 16/28] venus: add helper function to set actual buffer size
Date: Tue, 24 Apr 2018 15:44:24 +0300
Message-Id: <20180424124436.26955-17-stanimir.varbanov@linaro.org>
In-Reply-To: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add and use a helper function to set actual buffer size for
particular buffer type. This is also preparation to use
the second decoder output.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 12 ++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  1 +
 drivers/media/platform/qcom/venus/vdec.c    | 10 ++--------
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 824ad4d2d064..94664a3ce3e2 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -544,6 +544,18 @@ int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
 }
 EXPORT_SYMBOL_GPL(venus_helper_set_dyn_bufmode);
 
+int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize, u32 buftype)
+{
+	u32 ptype = HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL;
+	struct hfi_buffer_size_actual bufsz;
+
+	bufsz.type = buftype;
+	bufsz.size = bufsize;
+
+	return hfi_session_set_property(inst, ptype, &bufsz);
+}
+EXPORT_SYMBOL_GPL(venus_helper_set_bufsize);
+
 static void delayed_process_buf_func(struct work_struct *work)
 {
 	struct venus_buffer *buf, *n;
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 52b961ed491e..cd306bd8978f 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -41,6 +41,7 @@ int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 			      unsigned int output_bufs);
 int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
 int venus_helper_set_dyn_bufmode(struct venus_inst *inst);
+int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize, u32 buftype);
 void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
 void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
 void venus_helper_init_instance(struct venus_inst *inst);
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 1de9cc64cf2f..b43607dee4fe 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -710,7 +710,6 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 {
 	struct venus_inst *inst = vb2_get_drv_priv(q);
 	struct venus_core *core = inst->core;
-	u32 ptype;
 	int ret;
 
 	mutex_lock(&inst->lock);
@@ -740,13 +739,8 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
 		goto deinit_sess;
 
 	if (core->res->hfi_version == HFI_VERSION_3XX) {
-		struct hfi_buffer_size_actual buf_sz;
-
-		ptype = HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL;
-		buf_sz.type = HFI_BUFFER_OUTPUT;
-		buf_sz.size = inst->output_buf_size;
-
-		ret = hfi_session_set_property(inst, ptype, &buf_sz);
+		ret = venus_helper_set_bufsize(inst, inst->output_buf_size,
+					       HFI_BUFFER_OUTPUT);
 		if (ret)
 			goto deinit_sess;
 	}
-- 
2.14.1

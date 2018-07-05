Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50253 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754416AbeGENFb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:31 -0400
Received: by mail-wm0-f65.google.com with SMTP id v25-v6so11042995wmc.0
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:30 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 21/27] venus: helpers: add a helper to return opb buffer sizes
Date: Thu,  5 Jul 2018 16:03:55 +0300
Message-Id: <20180705130401.24315-22-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a helper function to return current output picture buffer size.
OPB sizes can vary depending on the selected decoder output(s).

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.h    |  6 ++++++
 drivers/media/platform/qcom/venus/helpers.c | 15 +++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  1 +
 3 files changed, 22 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index 1d1a59a5d343..f8e4d92ff0e1 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -239,6 +239,9 @@ struct venus_buffer {
  * @num_output_bufs:	holds number of output buffers
  * @input_buf_size	holds input buffer size
  * @output_buf_size:	holds output buffer size
+ * @output2_buf_size:	holds secondary decoder output buffer size
+ * @opb_buftype:	output picture buffer type
+ * @opb_fmt:		output picture buffer raw format
  * @reconfig:	a flag raised by decoder when the stream resolution changed
  * @reconfig_width:	holds the new width
  * @reconfig_height:	holds the new height
@@ -288,6 +291,9 @@ struct venus_inst {
 	unsigned int num_output_bufs;
 	unsigned int input_buf_size;
 	unsigned int output_buf_size;
+	unsigned int output2_buf_size;
+	u32 opb_buftype;
+	u32 opb_fmt;
 	bool reconfig;
 	u32 reconfig_width;
 	u32 reconfig_height;
diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 13f0bc4e5ffa..8d2f4db52e48 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -613,6 +613,21 @@ int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize, u32 buftype)
 }
 EXPORT_SYMBOL_GPL(venus_helper_set_bufsize);
 
+unsigned int venus_helper_get_opb_size(struct venus_inst *inst)
+{
+	/* the encoder has only one output */
+	if (inst->session_type == VIDC_SESSION_TYPE_ENC)
+		return inst->output_buf_size;
+
+	if (inst->opb_buftype == HFI_BUFFER_OUTPUT)
+		return inst->output_buf_size;
+	else if (inst->opb_buftype == HFI_BUFFER_OUTPUT2)
+		return inst->output2_buf_size;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(venus_helper_get_opb_size);
+
 static void delayed_process_buf_func(struct work_struct *work)
 {
 	struct venus_buffer *buf, *n;
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 8ff4bd3ef958..92be45894a69 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -48,6 +48,7 @@ int venus_helper_set_raw_format(struct venus_inst *inst, u32 hfi_format,
 int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
 int venus_helper_set_dyn_bufmode(struct venus_inst *inst);
 int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize, u32 buftype);
+unsigned int venus_helper_get_opb_size(struct venus_inst *inst);
 void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
 void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
 void venus_helper_init_instance(struct venus_inst *inst);
-- 
2.14.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38023 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754415AbeGENFX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:23 -0400
Received: by mail-wm0-f66.google.com with SMTP id 69-v6so10664997wmf.3
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:22 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 14/27] venus: helpers: add a helper function to set dynamic buffer mode
Date: Thu,  5 Jul 2018 16:03:48 +0300
Message-Id: <20180705130401.24315-15-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adds a new helper function to set dynamic buffer mode if it is
supported by current HFI version. The dynamic buffer mode is
set unconditionally for both decoder outputs.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 22 ++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  1 +
 drivers/media/platform/qcom/venus/vdec.c    | 15 +++------------
 3 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 27c4a4060c4e..29cc84777125 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -524,6 +524,28 @@ int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
 }
 EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
 
+int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
+{
+	const u32 ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
+	struct hfi_buffer_alloc_mode mode;
+	int ret;
+
+	if (!is_dynamic_bufmode(inst))
+		return 0;
+
+	mode.type = HFI_BUFFER_OUTPUT;
+	mode.mode = HFI_BUFFER_MODE_DYNAMIC;
+
+	ret = hfi_session_set_property(inst, ptype, &mode);
+	if (ret)
+		return ret;
+
+	mode.type = HFI_BUFFER_OUTPUT2;
+
+	return hfi_session_set_property(inst, ptype, &mode);
+}
+EXPORT_SYMBOL_GPL(venus_helper_set_dyn_bufmode);
+
 static void delayed_process_buf_func(struct work_struct *work)
 {
 	struct venus_buffer *buf, *n;
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 0e64aa95624a..52b961ed491e 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -40,6 +40,7 @@ int venus_helper_set_output_resolution(struct venus_inst *inst,
 int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 			      unsigned int output_bufs);
 int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
+int venus_helper_set_dyn_bufmode(struct venus_inst *inst);
 void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
 void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
 void venus_helper_init_instance(struct venus_inst *inst);
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 95892090e2f3..c37779d82fec 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -557,18 +557,9 @@ static int vdec_set_properties(struct venus_inst *inst)
 			return ret;
 	}
 
-	if (core->res->hfi_version == HFI_VERSION_3XX ||
-	    inst->cap_bufs_mode_dynamic) {
-		struct hfi_buffer_alloc_mode mode;
-
-		ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
-		mode.type = HFI_BUFFER_OUTPUT;
-		mode.mode = HFI_BUFFER_MODE_DYNAMIC;
-
-		ret = hfi_session_set_property(inst, ptype, &mode);
-		if (ret)
-			return ret;
-	}
+	ret = venus_helper_set_dyn_bufmode(inst);
+	if (ret)
+		return ret;
 
 	if (ctr->post_loop_deb_mode) {
 		ptype = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
-- 
2.14.1

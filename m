Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40281 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964786AbeFMPJ2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 11:09:28 -0400
Received: by mail-wm0-f67.google.com with SMTP id n5-v6so6067789wmc.5
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2018 08:09:27 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 14/27] venus: helpers: add a helper function to set dynamic buffer mode
Date: Wed, 13 Jun 2018 18:07:48 +0300
Message-Id: <20180613150801.11702-15-stanimir.varbanov@linaro.org>
In-Reply-To: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
References: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
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
index 03121dbb4175..e3dc2772946f 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -519,6 +519,28 @@ int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
 }
 EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
 
+int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
+{
+	u32 ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
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
index 31a240ab142b..92669a358a90 100644
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

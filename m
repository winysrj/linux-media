Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45782 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754467AbeGENF3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:29 -0400
Received: by mail-wr1-f65.google.com with SMTP id u7-v6so1138088wrn.12
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:28 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 19/27] venus: helpers,vdec,venc: add helpers to set work mode and core usage
Date: Thu,  5 Jul 2018 16:03:53 +0300
Message-Id: <20180705130401.24315-20-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These are new properties applicable to Venus version 4xx. Add the
helpers and call them from decoder and encoder drivers.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 28 ++++++++++++++++++++++++++++
 drivers/media/platform/qcom/venus/helpers.h |  2 ++
 drivers/media/platform/qcom/venus/vdec.c    |  8 ++++++++
 drivers/media/platform/qcom/venus/venc.c    |  8 ++++++++
 4 files changed, 46 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 4e4109e80988..3cd25e25aa70 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -486,6 +486,34 @@ int venus_helper_set_output_resolution(struct venus_inst *inst,
 }
 EXPORT_SYMBOL_GPL(venus_helper_set_output_resolution);
 
+int venus_helper_set_work_mode(struct venus_inst *inst, u32 mode)
+{
+	const u32 ptype = HFI_PROPERTY_PARAM_WORK_MODE;
+	struct hfi_video_work_mode wm;
+
+	if (!IS_V4(inst->core))
+		return 0;
+
+	wm.video_work_mode = mode;
+
+	return hfi_session_set_property(inst, ptype, &wm);
+}
+EXPORT_SYMBOL_GPL(venus_helper_set_work_mode);
+
+int venus_helper_set_core_usage(struct venus_inst *inst, u32 usage)
+{
+	const u32 ptype = HFI_PROPERTY_CONFIG_VIDEOCORES_USAGE;
+	struct hfi_videocores_usage_type cu;
+
+	if (!IS_V4(inst->core))
+		return 0;
+
+	cu.video_core_enable_mask = usage;
+
+	return hfi_session_set_property(inst, ptype, &cu);
+}
+EXPORT_SYMBOL_GPL(venus_helper_set_core_usage);
+
 int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 			      unsigned int output_bufs)
 {
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 79af7845efbd..d5e727e1ecab 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -38,6 +38,8 @@ int venus_helper_set_input_resolution(struct venus_inst *inst,
 int venus_helper_set_output_resolution(struct venus_inst *inst,
 				       unsigned int width, unsigned int height,
 				       u32 buftype);
+int venus_helper_set_work_mode(struct venus_inst *inst, u32 mode);
+int venus_helper_set_core_usage(struct venus_inst *inst, u32 usage);
 int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 			      unsigned int output_bufs);
 int venus_helper_set_raw_format(struct venus_inst *inst, u32 hfi_format,
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index d2a53c0eab86..75f622c73222 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -550,6 +550,14 @@ static int vdec_set_properties(struct venus_inst *inst)
 	u32 ptype;
 	int ret;
 
+	ret = venus_helper_set_work_mode(inst, VIDC_WORK_MODE_2);
+	if (ret)
+		return ret;
+
+	ret = venus_helper_set_core_usage(inst, VIDC_CORE_ID_1);
+	if (ret)
+		return ret;
+
 	if (core->res->hfi_version == HFI_VERSION_1XX) {
 		ptype = HFI_PROPERTY_PARAM_VDEC_CONTINUE_DATA_TRANSFER;
 		ret = hfi_session_set_property(inst, ptype, &en);
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 650e6b0a01d2..6dc153f16d88 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -643,6 +643,14 @@ static int venc_set_properties(struct venus_inst *inst)
 	u32 ptype, rate_control, bitrate, profile = 0, level = 0;
 	int ret;
 
+	ret = venus_helper_set_work_mode(inst, VIDC_WORK_MODE_2);
+	if (ret)
+		return ret;
+
+	ret = venus_helper_set_core_usage(inst, VIDC_CORE_ID_2);
+	if (ret)
+		return ret;
+
 	ptype = HFI_PROPERTY_CONFIG_FRAME_RATE;
 	frate.buffer_type = HFI_BUFFER_OUTPUT;
 	frate.framerate = inst->fps * (1 << 16);
-- 
2.14.1

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51976 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754461AbeGENF2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:28 -0400
Received: by mail-wm0-f68.google.com with SMTP id s12-v6so11040936wmc.1
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:27 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 18/27] venus: helpers: add a new helper to set raw format
Date: Thu,  5 Jul 2018 16:03:52 +0300
Message-Id: <20180705130401.24315-19-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The new helper will has one more argument for buffer type, that
way the decoder can configure the format on it's secondary
output.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 52 ++++++++++++++++++-----------
 drivers/media/platform/qcom/venus/helpers.h |  2 ++
 2 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 7e764eeeb07c..4e4109e80988 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -412,6 +412,20 @@ static int session_register_bufs(struct venus_inst *inst)
 	return ret;
 }
 
+static u32 to_hfi_raw_fmt(u32 v4l2_fmt)
+{
+	switch (v4l2_fmt) {
+	case V4L2_PIX_FMT_NV12:
+		return HFI_COLOR_FORMAT_NV12;
+	case V4L2_PIX_FMT_NV21:
+		return HFI_COLOR_FORMAT_NV21;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
 			    struct hfi_buffer_requirements *req)
 {
@@ -493,35 +507,35 @@ int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 }
 EXPORT_SYMBOL_GPL(venus_helper_set_num_bufs);
 
-int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
+int venus_helper_set_raw_format(struct venus_inst *inst, u32 hfi_format,
+				u32 buftype)
 {
+	const u32 ptype = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
 	struct hfi_uncompressed_format_select fmt;
-	u32 ptype = HFI_PROPERTY_PARAM_UNCOMPRESSED_FORMAT_SELECT;
-	int ret;
+
+	fmt.buffer_type = buftype;
+	fmt.format = hfi_format;
+
+	return hfi_session_set_property(inst, ptype, &fmt);
+}
+EXPORT_SYMBOL_GPL(venus_helper_set_raw_format);
+
+int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
+{
+	u32 hfi_format, buftype;
 
 	if (inst->session_type == VIDC_SESSION_TYPE_DEC)
-		fmt.buffer_type = HFI_BUFFER_OUTPUT;
+		buftype = HFI_BUFFER_OUTPUT;
 	else if (inst->session_type == VIDC_SESSION_TYPE_ENC)
-		fmt.buffer_type = HFI_BUFFER_INPUT;
+		buftype = HFI_BUFFER_INPUT;
 	else
 		return -EINVAL;
 
-	switch (pixfmt) {
-	case V4L2_PIX_FMT_NV12:
-		fmt.format = HFI_COLOR_FORMAT_NV12;
-		break;
-	case V4L2_PIX_FMT_NV21:
-		fmt.format = HFI_COLOR_FORMAT_NV21;
-		break;
-	default:
+	hfi_format = to_hfi_raw_fmt(pixfmt);
+	if (!hfi_format)
 		return -EINVAL;
-	}
 
-	ret = hfi_session_set_property(inst, ptype, &fmt);
-	if (ret)
-		return ret;
-
-	return 0;
+	return venus_helper_set_raw_format(inst, hfi_format, buftype);
 }
 EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
 
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index 0de9989adcdb..79af7845efbd 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -40,6 +40,8 @@ int venus_helper_set_output_resolution(struct venus_inst *inst,
 				       u32 buftype);
 int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 			      unsigned int output_bufs);
+int venus_helper_set_raw_format(struct venus_inst *inst, u32 hfi_format,
+				u32 buftype);
 int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
 int venus_helper_set_dyn_bufmode(struct venus_inst *inst);
 int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize, u32 buftype);
-- 
2.14.1

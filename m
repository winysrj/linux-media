Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51498 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934935AbeF0P2T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Jun 2018 11:28:19 -0400
Received: by mail-wm0-f66.google.com with SMTP id w137-v6so6339989wmw.1
        for <linux-media@vger.kernel.org>; Wed, 27 Jun 2018 08:28:19 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v4 17/27] venus: helpers: add buffer type argument to a helper
Date: Wed, 27 Jun 2018 18:27:15 +0300
Message-Id: <20180627152725.9783-18-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds one more function argument to pass buffer type to
set_output_resolution() helper function. That is a preparation
to support secondary decoder output.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 5 +++--
 drivers/media/platform/qcom/venus/helpers.h | 3 ++-
 drivers/media/platform/qcom/venus/venc.c    | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 0cce664f093d..2eeb243e4dbe 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -453,12 +453,13 @@ int venus_helper_set_input_resolution(struct venus_inst *inst,
 EXPORT_SYMBOL_GPL(venus_helper_set_input_resolution);
 
 int venus_helper_set_output_resolution(struct venus_inst *inst,
-				       unsigned int width, unsigned int height)
+				       unsigned int width, unsigned int height,
+				       u32 buftype)
 {
 	u32 ptype = HFI_PROPERTY_PARAM_FRAME_SIZE;
 	struct hfi_framesize fs;
 
-	fs.buffer_type = HFI_BUFFER_OUTPUT;
+	fs.buffer_type = buftype;
 	fs.width = width;
 	fs.height = height;
 
diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
index cd306bd8978f..0de9989adcdb 100644
--- a/drivers/media/platform/qcom/venus/helpers.h
+++ b/drivers/media/platform/qcom/venus/helpers.h
@@ -36,7 +36,8 @@ int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
 int venus_helper_set_input_resolution(struct venus_inst *inst,
 				      unsigned int width, unsigned int height);
 int venus_helper_set_output_resolution(struct venus_inst *inst,
-				       unsigned int width, unsigned int height);
+				       unsigned int width, unsigned int height,
+				       u32 buftype);
 int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
 			      unsigned int output_bufs);
 int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index aa6b0026d79d..1d7f87e0f5b3 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -795,7 +795,8 @@ static int venc_init_session(struct venus_inst *inst)
 		goto deinit;
 
 	ret = venus_helper_set_output_resolution(inst, inst->width,
-						 inst->height);
+						 inst->height,
+						 HFI_BUFFER_OUTPUT);
 	if (ret)
 		goto deinit;
 
-- 
2.14.1

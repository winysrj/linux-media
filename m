Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:42164 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752568AbeEOH7t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:49 -0400
Received: by mail-wr0-f195.google.com with SMTP id v5-v6so14902789wrf.9
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:48 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 19/29] venus: helpers: add buffer type argument to a helper
Date: Tue, 15 May 2018 10:58:49 +0300
Message-Id: <20180515075859.17217-20-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds one more function argument to pass buffer type to
set_output_resolution() helper function. That is a preparation
to support secondary decoder output.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/helpers.c | 5 +++--
 drivers/media/platform/qcom/venus/helpers.h | 3 ++-
 drivers/media/platform/qcom/venus/venc.c    | 3 ++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 94664a3ce3e2..5512fbfdebb9 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -456,12 +456,13 @@ int venus_helper_set_input_resolution(struct venus_inst *inst,
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
index f87d891325ea..8970f14b3a82 100644
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

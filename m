Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728241AbeI2S3K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Sep 2018 14:29:10 -0400
From: Srinu Gorle <sgorle@codeaurora.org>
To: stanimir.varbanov@linaro.org, hverkuil@xs4all.nl,
        mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        sgorle@codeaurora.org
Cc: acourbot@chromium.org, vgarodia@codeaurora.org
Subject: [PATCH v1 3/5] media: venus: do not destroy video session during queue setup
Date: Sat, 29 Sep 2018 17:30:30 +0530
Message-Id: <1538222432-25894-4-git-send-email-sgorle@codeaurora.org>
In-Reply-To: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

- open and close video sessions for plane properties is incorrect.
- add check to ensure, same instance persist from driver open to close.

Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
---
 drivers/media/platform/qcom/venus/hfi.c  | 3 +++
 drivers/media/platform/qcom/venus/vdec.c | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index 36a4784..59c34ba 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -207,6 +207,9 @@ int hfi_session_init(struct venus_inst *inst, u32 pixfmt)
 	const struct hfi_ops *ops = core->ops;
 	int ret;
 
+	if (inst->state >= INST_INIT && inst->state < INST_STOP)
+		return 0;
+
 	inst->hfi_codec = to_codec_type(pixfmt);
 	reinit_completion(&inst->done);
 
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index afe3b36..0035cf2 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -700,6 +700,8 @@ static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
 
 	*out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
 
+	return 0;
+
 deinit:
 	hfi_session_deinit(inst);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35848 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935972AbeFMPJO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 11:09:14 -0400
Received: by mail-wm0-f65.google.com with SMTP id v131-v6so6111430wma.1
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2018 08:09:13 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 06/27] venus: hfi: handle buffer output2 type as well
Date: Wed, 13 Jun 2018 18:07:40 +0300
Message-Id: <20180613150801.11702-7-stanimir.varbanov@linaro.org>
In-Reply-To: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
References: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds handling of buffers of type OUTPUT2 which is needed to
support Venus 4xx version.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/hfi.c      | 3 ++-
 drivers/media/platform/qcom/venus/hfi_msgs.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
index cbc6fad05e47..a570fdad0de0 100644
--- a/drivers/media/platform/qcom/venus/hfi.c
+++ b/drivers/media/platform/qcom/venus/hfi.c
@@ -473,7 +473,8 @@ int hfi_session_process_buf(struct venus_inst *inst, struct hfi_frame_data *fd)
 
 	if (fd->buffer_type == HFI_BUFFER_INPUT)
 		return ops->session_etb(inst, fd);
-	else if (fd->buffer_type == HFI_BUFFER_OUTPUT)
+	else if (fd->buffer_type == HFI_BUFFER_OUTPUT ||
+		 fd->buffer_type == HFI_BUFFER_OUTPUT2)
 		return ops->session_ftb(inst, fd);
 
 	return -EINVAL;
diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index 54cd41e5837c..c0f3bef8299f 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -823,7 +823,8 @@ static void hfi_session_ftb_done(struct venus_core *core,
 		error = HFI_ERR_SESSION_INVALID_PARAMETER;
 	}
 
-	if (buffer_type != HFI_BUFFER_OUTPUT)
+	if (buffer_type != HFI_BUFFER_OUTPUT &&
+	    buffer_type != HFI_BUFFER_OUTPUT2)
 		goto done;
 
 	if (hfi_flags & HFI_BUFFERFLAG_EOS)
-- 
2.14.1

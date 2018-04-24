Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38360 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932966AbeDXMp0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 08:45:26 -0400
Received: by mail-wm0-f66.google.com with SMTP id i3so614796wmf.3
        for <linux-media@vger.kernel.org>; Tue, 24 Apr 2018 05:45:26 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH 17/28] venus: delete no longer used bufmode flag from instance
Date: Tue, 24 Apr 2018 15:44:25 +0300
Message-Id: <20180424124436.26955-18-stanimir.varbanov@linaro.org>
In-Reply-To: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Delete no longer used flag cap_bufs_mode_dynamic from instance
structure.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
---
 drivers/media/platform/qcom/venus/core.h       | 2 --
 drivers/media/platform/qcom/venus/hfi_parser.c | 6 +-----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index c46334454cd9..255292899204 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -249,7 +249,6 @@ struct venus_buffer {
  * @priv:	a private for HFI operations callbacks
  * @session_type:	the type of the session (decoder or encoder)
  * @hprop:	a union used as a holder by get property
- * @cap_bufs_mode_dynamic:	buffers allocation mode capability
  */
 struct venus_inst {
 	struct list_head list;
@@ -298,7 +297,6 @@ struct venus_inst {
 	const struct hfi_inst_ops *ops;
 	u32 session_type;
 	union hfi_get_property hprop;
-	bool cap_bufs_mode_dynamic;
 };
 
 #define IS_V1(core)	((core)->res->hfi_version == HFI_VERSION_1XX)
diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
index 4b155997abbb..ac92fd347ce1 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -74,13 +74,9 @@ static void parse_alloc_mode(struct venus_core *core, struct venus_inst *inst,
 
 	while (num_entries--) {
 		if (mode->buffer_type == HFI_BUFFER_OUTPUT ||
-		    mode->buffer_type == HFI_BUFFER_OUTPUT2) {
-			if (*type == HFI_BUFFER_MODE_DYNAMIC && inst)
-				inst->cap_bufs_mode_dynamic = true;
-
+		    mode->buffer_type == HFI_BUFFER_OUTPUT2)
 			for_each_codec(core->caps, ARRAY_SIZE(core->caps),
 				       codecs, domain, fill_buf_mode, type, 1);
-		}
 
 		type++;
 	}
-- 
2.14.1

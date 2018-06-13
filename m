Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35929 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936044AbeFMPJc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Jun 2018 11:09:32 -0400
Received: by mail-wr0-f194.google.com with SMTP id f16-v6so3160861wrm.3
        for <linux-media@vger.kernel.org>; Wed, 13 Jun 2018 08:09:32 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v3 16/27] venus: core: delete not used buffer mode flags
Date: Wed, 13 Jun 2018 18:07:50 +0300
Message-Id: <20180613150801.11702-17-stanimir.varbanov@linaro.org>
In-Reply-To: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
References: <20180613150801.11702-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Delete not used flag for capture buffer allocation mode and
no longer used cap_bufs_mode_dynamic from instance structure.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/core.h       | 4 ----
 drivers/media/platform/qcom/venus/hfi_parser.c | 6 +-----
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index b995d1601c87..1d1a59a5d343 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -255,8 +255,6 @@ struct venus_buffer {
  * @priv:	a private for HFI operations callbacks
  * @session_type:	the type of the session (decoder or encoder)
  * @hprop:	a union used as a holder by get property
- * @cap_bufs_mode_static:	buffers allocation mode capability
- * @cap_bufs_mode_dynamic:	buffers allocation mode capability
  */
 struct venus_inst {
 	struct list_head list;
@@ -305,8 +303,6 @@ struct venus_inst {
 	const struct hfi_inst_ops *ops;
 	u32 session_type;
 	union hfi_get_property hprop;
-	bool cap_bufs_mode_static;
-	bool cap_bufs_mode_dynamic;
 };
 
 #define IS_V1(core)	((core)->res->hfi_version == HFI_VERSION_1XX)
diff --git a/drivers/media/platform/qcom/venus/hfi_parser.c b/drivers/media/platform/qcom/venus/hfi_parser.c
index e8e41811db80..c4ad50f992b0 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -73,13 +73,9 @@ parse_alloc_mode(struct venus_core *core, u32 codecs, u32 domain, void *data)
 
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

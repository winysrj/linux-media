Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:44865 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752564AbeEOH7s (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:59:48 -0400
Received: by mail-wr0-f196.google.com with SMTP id y15-v6so14880557wrg.11
        for <linux-media@vger.kernel.org>; Tue, 15 May 2018 00:59:47 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v2 18/29] venus: delete no longer used bufmode flag from instance
Date: Tue, 15 May 2018 10:58:48 +0300
Message-Id: <20180515075859.17217-19-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
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
index f9181d999b23..ad039a3444b8 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -75,13 +75,9 @@ static void parse_alloc_mode(struct venus_core *core, struct venus_inst *inst,
 
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

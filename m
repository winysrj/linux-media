Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:55401 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754428AbeGENFZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jul 2018 09:05:25 -0400
Received: by mail-wm0-f67.google.com with SMTP id v16-v6so11019711wmv.5
        for <linux-media@vger.kernel.org>; Thu, 05 Jul 2018 06:05:25 -0700 (PDT)
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: [PATCH v5 16/27] venus: core: delete not used buffer mode flags
Date: Thu,  5 Jul 2018 16:03:50 +0300
Message-Id: <20180705130401.24315-17-stanimir.varbanov@linaro.org>
In-Reply-To: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
References: <20180705130401.24315-1-stanimir.varbanov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Delete not used flag for capture buffer allocation mode and
no longer used cap_bufs_mode_dynamic from instance structure.

Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
---
 drivers/media/platform/qcom/venus/core.h       |  4 ----
 drivers/media/platform/qcom/venus/hfi_parser.c | 11 +++--------
 2 files changed, 3 insertions(+), 12 deletions(-)

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
index afc0db3b5dc3..2293d936e49c 100644
--- a/drivers/media/platform/qcom/venus/hfi_parser.c
+++ b/drivers/media/platform/qcom/venus/hfi_parser.c
@@ -60,8 +60,7 @@ fill_buf_mode(struct venus_caps *cap, const void *data, unsigned int num)
 }
 
 static void
-parse_alloc_mode(struct venus_core *core, struct venus_inst *inst, u32 codecs,
-		 u32 domain, void *data)
+parse_alloc_mode(struct venus_core *core, u32 codecs, u32 domain, void *data)
 {
 	struct hfi_buffer_alloc_mode_supported *mode = data;
 	u32 num_entries = mode->num_entries;
@@ -74,13 +73,9 @@ parse_alloc_mode(struct venus_core *core, struct venus_inst *inst, u32 codecs,
 
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
@@ -267,7 +262,7 @@ u32 hfi_parser(struct venus_core *core, struct venus_inst *inst, void *buf,
 			parse_profile_level(core, codecs, domain, data);
 			break;
 		case HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE_SUPPORTED:
-			parse_alloc_mode(core, inst, codecs, domain, data);
+			parse_alloc_mode(core, codecs, domain, data);
 			break;
 		default:
 			break;
-- 
2.14.1
